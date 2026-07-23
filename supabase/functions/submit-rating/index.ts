import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { z } from "https://esm.sh/zod@3.22.4";
import { corsHeaders } from "../_shared/cors.ts";
import { AppError, handleError } from "../_shared/errors.ts";
import { createUserScopedClient } from "../_shared/supabaseClient.ts";

const RatingSchema = z.object({
  beer_id: z.string().uuid({ message: "Nieprawidłowy identyfikator piwa" }),
  overall: z.number().min(0).max(5),
  taste: z.number().min(0).max(5).optional(),
  aroma: z.number().min(0).max(5).optional(),
  bitterness: z.number().min(0).max(5).optional(),
  appearance: z.number().min(0).max(5).optional(),
  drinkability: z.number().min(0).max(5).optional(),
  note: z.string().optional(),
});

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

    // Validate body
    let body;
    try {
      body = await req.json();
    } catch (_) {
      throw new AppError(400, "Nieprawidłowy format JSON", "INVALID_JSON");
    }

    const parseResult = RatingSchema.safeParse(body);
    if (!parseResult.success) {
      throw new AppError(400, parseResult.error.errors[0].message, "VALIDATION_ERROR");
    }

    const data = parseResult.data;

    // Upsert rating
    const { error: upsertError } = await supabase
      .from("ratings")
      .upsert({
        user_id: user.id,
        beer_id: data.beer_id,
        overall: data.overall,
        taste: data.taste ?? null,
        aroma: data.aroma ?? null,
        bitterness: data.bitterness ?? null,
        appearance: data.appearance ?? null,
        drinkability: data.drinkability ?? null,
        note: data.note ?? null,
      }, {
        onConflict: 'user_id,beer_id'
      });

    if (upsertError) {
      console.error(upsertError);
      throw new AppError(500, "Nie udało się zapisać oceny", "DB_ERROR");
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    return handleError(error);
  }
});
