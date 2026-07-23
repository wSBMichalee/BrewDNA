-- Modyfikacje dla BeerDNA

-- 1. Nowe kolumny osi smakowych w tabeli beers
ALTER TABLE beers 
  ADD COLUMN axis_strength SMALLINT,      -- 0=lekkie, 100=mocne
  ADD COLUMN axis_bitterness SMALLINT,    -- 0=łagodne, 100=gorzkie
  ADD COLUMN axis_fruitiness SMALLINT,    -- 0=wytrawne, 100=owocowe
  ADD COLUMN axis_maltiness SMALLINT;     -- 0=orzeźwiające, 100=słodowe

-- 2. Zabezpieczenie istniejącej tabeli taste_profiles węzłem UNIQUE przed upsertem
ALTER TABLE taste_profiles ADD CONSTRAINT taste_profiles_user_id_key UNIQUE (user_id);

-- 3. Rozszerzenie taste_profiles o nowe kolumny i wektory smakowe
ALTER TABLE taste_profiles 
  ADD COLUMN axis_strength NUMERIC DEFAULT 50,
  ADD COLUMN axis_bitterness NUMERIC DEFAULT 50,
  ADD COLUMN axis_fruitiness NUMERIC DEFAULT 50,
  ADD COLUMN axis_maltiness NUMERIC DEFAULT 50,
  ADD COLUMN preferred_styles JSONB DEFAULT '[]',
  ADD COLUMN preferred_countries JSONB DEFAULT '[]',
  ADD COLUMN experience_level TEXT DEFAULT 'beginner',
  ADD COLUMN rating_count INTEGER DEFAULT 0;

-- 4. Funkcja uśredniająca profil smaku na podstawie delta oceny
CREATE OR REPLACE FUNCTION public.update_taste_profile_on_rating()
RETURNS trigger AS $$
DECLARE
  weight NUMERIC;
  old_weight NUMERIC := 0;
  delta NUMERIC;
  b_strength NUMERIC;
  b_bitterness NUMERIC;
  b_fruitiness NUMERIC;
  b_maltiness NUMERIC;
  cur_count INTEGER;
BEGIN
  -- Pobranie wektorów piwa
  SELECT axis_strength, axis_bitterness, axis_fruitiness, axis_maltiness
  INTO b_strength, b_bitterness, b_fruitiness, b_maltiness
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

  -- Wyliczenie wektorów wg wzoru na deltę
  UPDATE taste_profiles
  SET 
    rating_count = cur_count,
    axis_strength = axis_strength + (b_strength - axis_strength) * (delta / (cur_count + abs(delta))),
    axis_bitterness = axis_bitterness + (b_bitterness - axis_bitterness) * (delta / (cur_count + abs(delta))),
    axis_fruitiness = axis_fruitiness + (b_fruitiness - axis_fruitiness) * (delta / (cur_count + abs(delta))),
    axis_maltiness = axis_maltiness + (b_maltiness - axis_maltiness) * (delta / (cur_count + abs(delta)))
  WHERE user_id = NEW.user_id;

  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Trigger
CREATE TRIGGER on_rating_insert_update_profile
  AFTER INSERT OR UPDATE ON ratings
  FOR EACH ROW EXECUTE PROCEDURE public.update_taste_profile_on_rating();
