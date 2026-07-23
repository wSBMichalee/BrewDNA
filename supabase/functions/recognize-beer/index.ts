import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { z } from "https://esm.sh/zod@3.22.4";
import { corsHeaders } from "../_shared/cors.ts";
import { AppError, handleError } from "../_shared/errors.ts";
import { createServiceRoleClient } from "../_shared/supabaseClient.ts";
import { callGemini } from "../_shared/gemini.ts";

const RecognizeSchema = z.object({
  image_base64: z.string().min(1),
});

const PROMPT = `
Przeanalizuj etykietę piwa na obrazku i zwróć JSON o strukturze:
{
  "name": "Nazwa piwa",
  "brewery_name": "Nazwa browaru",
  "style_name": "Styl piwa (np. IPA, Pilsner)",
  "category": "Kategoria stylu (np. Ale, Lager)",
  "country": "Kraj pochodzenia (np. Polska, USA)",
  "abv": "Zawartość alkoholu jako liczba (np. 5.5), null jeśli brak",
  "description": "Krótki, wygenerowany opis tego piwa (1-2 zdania)",
  "axis_strength": "Ocena mocy (0-100), 0=lekkie wodniste, 100=mocne palące",
  "axis_bitterness": "Ocena goryczki (0-100), 0=łagodne słodkie, 100=ekstremalnie gorzkie",
  "axis_fruitiness": "Ocena owocowości (0-100), 0=całkowicie wytrawne ziemiste, 100=bomba owocowa",
  "axis_maltiness": "Ocena słodowości (0-100), 0=bardzo rześkie, 100=gęste karmelowe/słodowe"
}
Zwróć TYLKO czysty JSON, bez żadnych znaczników markdown typu \`\`\`json.
`;

function normalize(str: string | null | undefined): string | null {
  if (!str) return null;
  return str.trim().toLowerCase();
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    let body;
    try {
      body = await req.json();
    } catch (_) {
      throw new AppError(400, "Nieprawidłowy format JSON", "INVALID_JSON");
    }

    const parseResult = RecognizeSchema.safeParse(body);
    if (!parseResult.success) {
      throw new AppError(400, "Brak lub nieprawidłowy obrazek base64", "VALIDATION_ERROR");
    }

    const { image_base64 } = parseResult.data;

    // 1. Rozpoznanie przez Gemini
    let aiResult;
    try {
      aiResult = await callGemini(PROMPT, image_base64);
    } catch (err) {
      console.error("Gemini Error:", err);
      throw new AppError(500, "Nie udało się rozpoznać etykiety (Błąd AI)", "AI_ERROR");
    }

    if (!aiResult.name || !aiResult.brewery_name) {
      throw new AppError(400, "Nie udało się poprawnie zidentyfikować piwa na zdjęciu.", "NOT_RECOGNIZED");
    }

    const supabase = createServiceRoleClient();

    // 2. Normalizacja nazw
    const normBrewery = normalize(aiResult.brewery_name)!;
    const normStyle = normalize(aiResult.style_name);
    const normBeer = normalize(aiResult.name)!;

    // 3. Znajdź lub stwórz browar
    let breweryId: string;
    const { data: existingBrewery } = await supabase
      .from("breweries")
      .select("id")
      .ilike("name", normBrewery)
      .limit(1)
      .maybeSingle();

    if (existingBrewery) {
      breweryId = existingBrewery.id;
    } else {
      const { data: newBrewery, error: errBrewery } = await supabase
        .from("breweries")
        .insert({
          name: aiResult.brewery_name,
          country: aiResult.country || null,
        })
        .select("id")
        .single();
      
      if (errBrewery) throw new AppError(500, "Błąd bazy danych (brewery)", "DB_ERROR");
      breweryId = newBrewery.id;
    }

    // 4. Znajdź lub stwórz styl
    let styleId: string | null = null;
    if (normStyle) {
      const { data: existingStyle } = await supabase
        .from("styles")
        .select("id")
        .ilike("name", normStyle)
        .limit(1)
        .maybeSingle();
      
      if (existingStyle) {
        styleId = existingStyle.id;
      } else {
        const { data: newStyle, error: errStyle } = await supabase
          .from("styles")
          .insert({
            name: aiResult.style_name,
            category: aiResult.category || null,
          })
          .select("id")
          .single();
        if (!errStyle) styleId = newStyle.id;
      }
    }

    // 5. Znajdź lub stwórz piwo
    let beerId: string;
    const { data: existingBeer } = await supabase
      .from("beers")
      .select("id, name, breweries(name), styles(name)")
      .eq("brewery_id", breweryId)
      .ilike("name", normBeer)
      .limit(1)
      .maybeSingle();

    if (existingBeer) {
      beerId = existingBeer.id;
    } else {
      const { data: newBeer, error: errBeer } = await supabase
        .from("beers")
        .insert({
          name: aiResult.name,
          brewery_id: breweryId,
          style_id: styleId,
          abv: aiResult.abv ? parseFloat(aiResult.abv) : null,
          description: aiResult.description || null,
          axis_strength: aiResult.axis_strength ? parseInt(aiResult.axis_strength) : null,
          axis_bitterness: aiResult.axis_bitterness ? parseInt(aiResult.axis_bitterness) : null,
          axis_fruitiness: aiResult.axis_fruitiness ? parseInt(aiResult.axis_fruitiness) : null,
          axis_maltiness: aiResult.axis_maltiness ? parseInt(aiResult.axis_maltiness) : null,
        })
        .select("id")
        .single();
      
      if (errBeer) throw new AppError(500, "Błąd bazy danych (beer)", "DB_ERROR");
      beerId = newBeer.id;
    }

    return new Response(JSON.stringify({ 
      success: true, 
      beer_id: beerId,
      beer: aiResult // send back what was found
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    return handleError(error);
  }
});
