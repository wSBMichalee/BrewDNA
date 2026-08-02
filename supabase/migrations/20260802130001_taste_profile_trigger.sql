-- Zastępuje dotychczasowy trigger `handle_new_user` dodając:
-- 1. Obsługę pobierania `display_name` z metadanych.
-- 2. Automatyczne tworzenie rekordu `taste_profiles`, o ile metadane zawierają klucz `taste_profile`.

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  -- Tworzenie podstawowego profilu public.users (teraz wyciąga też display_name)
  INSERT INTO public.users (id, email, display_name)
  VALUES (
    new.id, 
    new.email,
    new.raw_user_meta_data->>'display_name'
  )
  ON CONFLICT (id) DO UPDATE 
  SET display_name = EXCLUDED.display_name;

  -- Automatyczne tworzenie profilu smaku, jeśli dane zostały przekazane z quizu podczas rejestracji
  IF new.raw_user_meta_data->'taste_profile' IS NOT NULL THEN
    INSERT INTO public.taste_profiles (
      user_id,
      axis_strength,
      axis_bitterness,
      axis_fruitiness,
      preferred_styles,
      preferred_countries,
      experience_level
    ) VALUES (
      new.id,
      (new.raw_user_meta_data->'taste_profile'->>'axis_strength')::numeric,
      (new.raw_user_meta_data->'taste_profile'->>'axis_bitterness')::numeric,
      (new.raw_user_meta_data->'taste_profile'->>'axis_fruitiness')::numeric,
      new.raw_user_meta_data->'taste_profile'->'preferred_styles',
      new.raw_user_meta_data->'taste_profile'->'preferred_countries',
      new.raw_user_meta_data->'taste_profile'->>'experience_level'
    )
    ON CONFLICT (user_id) DO NOTHING;
  END IF;

  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
