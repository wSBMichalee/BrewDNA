import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { corsHeaders } from "../_shared/cors.ts";
import { AppError, handleError } from "../_shared/errors.ts";
import { createUserScopedClient } from "../_shared/supabaseClient.ts";
import { callGemini } from "../_shared/gemini.ts";

const PROMPT = `
Jesteś ekspertem-sommelierem piwnym (BeerDNA). 
Na podstawie aktualnego wektora smaku (wynikającego z systemu ocen i quizu powitalnego) oraz historii ocen piw, wygeneruj spersonalizowany opis profilu smakowego.
Zwróć TYLKO ustrukturyzowany JSON bez znaczników markdown (\`\`\`json) o poniższej strukturze:
{
  "insights": [
    "Krótkie spostrzeżenie 1 (np. Wyraźnie preferujesz mocno chmielone IPA, co widać po wysokiej ocenie goryczki)",
    "Krótkie spostrzeżenie 2 (np. Pomimo zamiłowania do goryczy, doceniasz też słodowe stouty)",
    "Krótkie spostrzeżenie 3"
  ]
}
`;

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabase = createUserScopedClient(req);

    // Get user
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      throw new AppError(401, "Nieautoryzowany dostęp", "UNAUTHORIZED");
    }

    // Fetch user's taste profile
    const { data: tasteProfile, error: profileError } = await supabase
      .from("taste_profiles")
      .select("axis_strength, axis_bitterness, axis_fruitiness, axis_maltiness, preferred_styles, preferred_countries, experience_level, rating_count, last_generated_at_count, insights_json")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError) {
      throw new AppError(500, "Błąd pobierania profilu smakowego", "DB_ERROR");
    }

    const currentRatingCount = tasteProfile?.rating_count || 0;
    const lastGeneratedCount = tasteProfile?.last_generated_at_count || 0;

    // Check if we have enough new ratings to warrant an AI generation
    if (tasteProfile?.insights_json && (currentRatingCount - lastGeneratedCount) < 10 && currentRatingCount > 0) {
      return new Response(JSON.stringify({ 
        success: true, 
        profile: tasteProfile.insights_json,
        cached: true
      }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Fetch user's ratings
    const { data: ratings, error: ratingsError } = await supabase
      .from("ratings")
      .select(`
        overall, note,
        beers (
          name,
          breweries (name),
          styles (name)
        )
      `)
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(20);

    // Prepare data for Gemini
    const profileText = tasteProfile ? `
Wektory Smaku (0-100):
- Moc: ${tasteProfile.axis_strength ?? 50}
- Goryczka: ${tasteProfile.axis_bitterness ?? 50}
- Owocowość: ${tasteProfile.axis_fruitiness ?? 50}
- Słodowość: ${tasteProfile.axis_maltiness ?? 50}
Ulubione style: ${tasteProfile.preferred_styles || 'brak danych'}
Ulubione kraje: ${tasteProfile.preferred_countries || 'brak danych'}
Poziom doświadczenia: ${tasteProfile.experience_level || 'beginner'}
` : 'Brak danych wektorowych.';

    const historyText = (ratings && ratings.length > 0) ? ratings.map((r: any) => {
      const bName = r.beers?.name;
      const brewery = r.beers?.breweries?.name;
      const style = r.beers?.styles?.name;
      return `- Piwo: ${bName} (${brewery}), Styl: ${style}, Ocena: ${r.overall}/5, Notatka: ${r.note || 'brak'}`;
    }).join("\n") : 'Brak historii ocen.';

    const fullPrompt = `${PROMPT}\n\nAktualny Profil Wektorowy:\n${profileText}\n\nOstatnie Oceny:\n${historyText}`;

    // Call Gemini
    let aiResult;
    try {
      aiResult = await callGemini(fullPrompt);
    } catch (err) {
      console.error("Gemini Error:", err);
      throw new AppError(500, "Nie udało się wygenerować profilu smakowego (Błąd AI)", "AI_ERROR");
    }

    if (!aiResult.insights) {
      throw new AppError(500, "Zły format odpowiedzi z AI", "AI_PARSE_ERROR");
    }

    // Save to taste_profiles insights_json and update last_generated_at_count
    const { error: upsertError } = await supabase
      .from("taste_profiles")
      .upsert({
        user_id: user.id,
        insights_json: aiResult,
        last_generated_at_count: currentRatingCount,
        updated_at: new Date().toISOString(),
      }, {
        onConflict: 'user_id'
      });

    if (upsertError) {
      console.error("Taste Profile Save Error:", upsertError);
      throw new AppError(500, "Błąd zapisu profilu smakowego do bazy", "DB_ERROR");
    }

    return new Response(JSON.stringify({ 
      success: true, 
      profile: aiResult,
      cached: false
    }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    return handleError(error);
  }
});
