-- 1. Usunięcie skorumpowanych danych testowych
-- (z dużą precyzją, pow. 15 znaków po rzutowaniu na TEXT)
DELETE FROM public.taste_profiles
WHERE rating_count > 0 AND (
  LENGTH(axis_strength::TEXT) > 15 OR
  LENGTH(axis_bitterness::TEXT) > 15 OR
  LENGTH(axis_fruitiness::TEXT) > 15
);

-- 2. Zmiana typów kolumn na ściśle limitowane NUMERIC(5,2) 
-- Zabezpiecza bazę na poziomie schematu i zaokrągla pozostawione poprawne wiersze.
ALTER TABLE public.taste_profiles
  ALTER COLUMN axis_strength TYPE NUMERIC(5,2) USING ROUND(axis_strength, 2),
  ALTER COLUMN axis_bitterness TYPE NUMERIC(5,2) USING ROUND(axis_bitterness, 2),
  ALTER COLUMN axis_fruitiness TYPE NUMERIC(5,2) USING ROUND(axis_fruitiness, 2);

-- 3. Usunięcie axis_maltiness z taste_profiles i beers (decyzja biznesowa)
ALTER TABLE public.taste_profiles DROP COLUMN IF EXISTS axis_maltiness;
ALTER TABLE public.beers DROP COLUMN IF EXISTS axis_maltiness;

-- 4. Aktualizacja triggera z jawnym ROUND(..., 2) bez axis_maltiness
CREATE OR REPLACE FUNCTION public.update_taste_profile_on_rating()
RETURNS trigger AS $$
DECLARE
  weight NUMERIC;
  old_weight NUMERIC := 0;
  delta NUMERIC;
  b_strength NUMERIC;
  b_bitterness NUMERIC;
  b_fruitiness NUMERIC;
  cur_count INTEGER;
BEGIN
  -- Pobranie wektorów piwa
  SELECT axis_strength, axis_bitterness, axis_fruitiness
  INTO b_strength, b_bitterness, b_fruitiness
  FROM beers WHERE id = NEW.beer_id;
  
  IF b_strength IS NULL THEN
    RETURN NULL;
  END IF;

  weight := NEW.overall - 3;
  IF TG_OP = 'UPDATE' THEN
    old_weight := OLD.overall - 3;
  END IF;

  delta := weight - old_weight;
  IF delta = 0 THEN
    RETURN NULL; -- ocena się nie zmieniła (np. edytowano tylko notatkę)
  END IF;

  -- Upsert profilu w razie gdyby nie istniał
  INSERT INTO taste_profiles (user_id) VALUES (NEW.user_id) ON CONFLICT (user_id) DO NOTHING;

  SELECT rating_count INTO cur_count FROM taste_profiles WHERE user_id = NEW.user_id;
  IF TG_OP = 'INSERT' THEN
    cur_count := cur_count + 1; -- nowe piwo w profilu, nie samo poprawienie starej oceny
  END IF;

  -- Wyliczenie wektorów wg wzoru na deltę z jawnym odcięciem dziesiętnym
  UPDATE taste_profiles
  SET 
    rating_count = cur_count,
    axis_strength = ROUND(axis_strength + (b_strength - axis_strength) * (delta / (cur_count + abs(delta))), 2),
    axis_bitterness = ROUND(axis_bitterness + (b_bitterness - axis_bitterness) * (delta / (cur_count + abs(delta))), 2),
    axis_fruitiness = ROUND(axis_fruitiness + (b_fruitiness - axis_fruitiness) * (delta / (cur_count + abs(delta))), 2)
  WHERE user_id = NEW.user_id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
