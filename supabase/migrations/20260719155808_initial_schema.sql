-- TABELE SŁOWNIKOWE I PUBLICZNE (Odczyt publiczny, zapis tylko przez Edge Functions/Admina)

CREATE TABLE breweries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    country TEXT,
    region TEXT
);

CREATE TABLE styles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    category TEXT
);

CREATE TABLE beers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    brewery_id UUID REFERENCES breweries(id),
    style_id UUID REFERENCES styles(id),
    abv NUMERIC,
    ibu NUMERIC,
    ebc NUMERIC,
    description TEXT,
    image_url TEXT,
    global_rating NUMERIC DEFAULT 0
);

-- TABELE UŻYTKOWNIKA I POWIĄZANE (auth.users)

CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE checkins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    beer_id UUID NOT NULL REFERENCES beers(id),
    location_country TEXT,
    location_city TEXT,
    lat NUMERIC,
    lng NUMERIC,
    photo_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE ratings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    beer_id UUID NOT NULL REFERENCES beers(id) ON DELETE CASCADE,
    overall NUMERIC NOT NULL CHECK (overall >= 0 AND overall <= 5),
    taste NUMERIC CHECK (taste >= 0 AND taste <= 5),
    aroma NUMERIC CHECK (aroma >= 0 AND aroma <= 5),
    bitterness NUMERIC CHECK (bitterness >= 0 AND bitterness <= 5),
    appearance NUMERIC CHECK (appearance >= 0 AND appearance <= 5),
    drinkability NUMERIC CHECK (drinkability >= 0 AND drinkability <= 5),
    note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (user_id, beer_id)
);

CREATE TABLE taste_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    insights_json JSONB,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE wishlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    beer_id UUID NOT NULL REFERENCES beers(id)
);

CREATE TABLE cellar (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    beer_id UUID NOT NULL REFERENCES beers(id),
    quantity INTEGER DEFAULT 1
);

-- Włączenie RLS dla wszystkich tabel
ALTER TABLE breweries ENABLE ROW LEVEL SECURITY;
ALTER TABLE styles ENABLE ROW LEVEL SECURITY;
ALTER TABLE beers ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE checkins ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE taste_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE wishlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE cellar ENABLE ROW LEVEL SECURITY;

-- Tabele słownikowe (beers, breweries, styles) - Odczyt dla wszystkich
CREATE POLICY "Public read access for breweries" ON breweries FOR SELECT USING (true);
CREATE POLICY "Public read access for styles" ON styles FOR SELECT USING (true);
CREATE POLICY "Public read access for beers" ON beers FOR SELECT USING (true);

-- Users
CREATE POLICY "Users can read all users profiles" ON users FOR SELECT USING (true);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);

-- Checkins
CREATE POLICY "Users can read own checkins" ON checkins FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own checkins" ON checkins FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own checkins" ON checkins FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own checkins" ON checkins FOR DELETE USING (auth.uid() = user_id);

-- Ratings (zmienione zgodnie ze wskazówkami)
CREATE POLICY "Public read access for ratings" ON ratings FOR SELECT USING (true);
CREATE POLICY "Users can insert own ratings" ON ratings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own ratings" ON ratings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own ratings" ON ratings FOR DELETE USING (auth.uid() = user_id);

-- Taste Profiles
CREATE POLICY "Users can read own taste_profiles" ON taste_profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own taste_profiles" ON taste_profiles FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own taste_profiles" ON taste_profiles FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own taste_profiles" ON taste_profiles FOR DELETE USING (auth.uid() = user_id);

-- Wishlists
CREATE POLICY "Users can read own wishlists" ON wishlists FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own wishlists" ON wishlists FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own wishlists" ON wishlists FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own wishlists" ON wishlists FOR DELETE USING (auth.uid() = user_id);

-- Cellar
CREATE POLICY "Users can read own cellar" ON cellar FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own cellar" ON cellar FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own cellar" ON cellar FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own cellar" ON cellar FOR DELETE USING (auth.uid() = user_id);

-- TRIGGERS & FUNCTIONS

-- Trigger do autotworzenia profilu public.users po rejestracji w auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- Trigger do aktualizacji global_rating piwa
CREATE OR REPLACE FUNCTION public.recalculate_beer_rating()
RETURNS trigger AS $$
BEGIN
  UPDATE beers
  SET global_rating = (
    SELECT COALESCE(AVG(overall), 0) FROM ratings WHERE beer_id = COALESCE(NEW.beer_id, OLD.beer_id)
  )
  WHERE id = COALESCE(NEW.beer_id, OLD.beer_id);
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_rating_change
  AFTER INSERT OR UPDATE OR DELETE ON ratings
  FOR EACH ROW EXECUTE PROCEDURE public.recalculate_beer_rating();
