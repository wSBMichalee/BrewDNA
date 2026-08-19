-- 1. Rename existing columns to calculated_*
ALTER TABLE public.taste_profiles 
  RENAME COLUMN axis_strength TO calculated_strength;
ALTER TABLE public.taste_profiles 
  RENAME COLUMN axis_bitterness TO calculated_bitterness;
ALTER TABLE public.taste_profiles 
  RENAME COLUMN axis_fruitiness TO calculated_fruitiness;

-- 2. Add declared_* columns
ALTER TABLE public.taste_profiles
  ADD COLUMN declared_strength NUMERIC,
  ADD COLUMN declared_bitterness NUMERIC,
  ADD COLUMN declared_fruitiness NUMERIC;

-- 3. Update the trigger function to use calculated_*
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
    calculated_strength = ROUND(calculated_strength + (b_strength - calculated_strength) * (delta / (cur_count + abs(delta))), 2),
    calculated_bitterness = ROUND(calculated_bitterness + (b_bitterness - calculated_bitterness) * (delta / (cur_count + abs(delta))), 2),
    calculated_fruitiness = ROUND(calculated_fruitiness + (b_fruitiness - calculated_fruitiness) * (delta / (cur_count + abs(delta))), 2)
  WHERE user_id = NEW.user_id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

