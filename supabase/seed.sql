-- Dane testowe do developmentu i testów obciążeniowych, nie produkcyjne.

-- Usuwamy stare dane przy ponownym odpaleniu seeda (opcjonalne, ale pomocne w dev)
-- DELETE FROM public.beers;
-- DELETE FROM public.styles;
-- DELETE FROM public.breweries;

-- BREWERIES (~15 rekordów)
INSERT INTO public.breweries (id, name, country, region) VALUES
('b0000000-0000-0000-0000-000000000001', 'Trzech Kotów', 'PL', 'Mazowieckie'),
('b0000000-0000-0000-0000-000000000002', 'BrewDog', 'UK', 'Scotland'),
('b0000000-0000-0000-0000-000000000003', 'Sierra Nevada', 'USA', 'California'),
('b0000000-0000-0000-0000-000000000004', 'Pinta', 'PL', 'Śląskie'),
('b0000000-0000-0000-0000-000000000005', 'Artezan', 'PL', 'Mazowieckie'),
('b0000000-0000-0000-0000-000000000006', 'Funky Fluid', 'PL', 'Mazowieckie'),
('b0000000-0000-0000-0000-000000000007', 'Mikkeller', 'DK', 'Capital Region'),
('b0000000-0000-0000-0000-000000000008', 'Omnipollo', 'SE', 'Stockholm'),
('b0000000-0000-0000-0000-000000000009', 'Stone Brewing', 'USA', 'California'),
('b0000000-0000-0000-0000-000000000010', 'Guinness', 'IE', 'Dublin'),
('b0000000-0000-0000-0000-000000000011', 'Trzech Kumpli', 'PL', 'Małopolskie'),
('b0000000-0000-0000-0000-000000000012', 'Nepomucen', 'PL', 'Wielkopolskie'),
('b0000000-0000-0000-0000-000000000013', 'Tree House', 'USA', 'Massachusetts'),
('b0000000-0000-0000-0000-000000000014', 'Cantillon', 'BE', 'Brussels'),
('b0000000-0000-0000-0000-000000000015', 'Stu Mostów', 'PL', 'Dolnośląskie')
ON CONFLICT (id) DO NOTHING;

-- STYLES (8 rekordów)
INSERT INTO public.styles (id, name, category) VALUES
('s0000000-0000-0000-0000-000000000001', 'IPA', 'Ale'),
('s0000000-0000-0000-0000-000000000002', 'Lager', 'Lager'),
('s0000000-0000-0000-0000-000000000003', 'Stout', 'Ale'),
('s0000000-0000-0000-0000-000000000004', 'Weizen', 'Wheat Beer'),
('s0000000-0000-0000-0000-000000000005', 'Porter', 'Ale'),
('s0000000-0000-0000-0000-000000000006', 'Sour', 'Sour'),
('s0000000-0000-0000-0000-000000000007', 'Pils', 'Lager'),
('s0000000-0000-0000-0000-000000000008', 'Belgijskie', 'Ale')
ON CONFLICT (id) DO NOTHING;

-- BEERS (~35 rekordów)
INSERT INTO public.beers (
    id, name, brewery_id, style_id, abv, ibu, ebc, description, image_url, 
    axis_strength, axis_bitterness, axis_fruitiness, axis_maltiness
) VALUES
-- IPA
('c0000000-0000-0000-0000-000000000001', 'Punk IPA', 'b0000000-0000-0000-0000-000000000002', 's0000000-0000-0000-0000-000000000001', 5.4, 35, 12, 'Klasyka z BrewDog, dużo owoców tropikalnych i karmelu.', 'https://media.screensdesign.com/image-placeholder.jpg', 55, 65, 45, 30),
('c0000000-0000-0000-0000-000000000002', 'Atak Chmielu', 'b0000000-0000-0000-0000-000000000004', 's0000000-0000-0000-0000-000000000001', 6.1, 58, 15, 'Polski klasyk chmielowy. Cytrusy i żywica.', 'https://media.screensdesign.com/image-placeholder.jpg', 60, 75, 40, 35),
('c0000000-0000-0000-0000-000000000003', 'Pale Ale', 'b0000000-0000-0000-0000-000000000003', 's0000000-0000-0000-0000-000000000001', 5.6, 38, 10, 'Ikona amerykańskiego rzemiosła, grejpfrut i sosna.', 'https://media.screensdesign.com/image-placeholder.jpg', 55, 60, 35, 40),
('c0000000-0000-0000-0000-000000000004', 'Pan IPAni', 'b0000000-0000-0000-0000-000000000011', 's0000000-0000-0000-0000-000000000001', 6.0, 45, 11, 'Wheat IPA, gładkie i mocno owocowe.', 'https://media.screensdesign.com/image-placeholder.jpg', 58, 55, 60, 30),
('c0000000-0000-0000-0000-000000000005', 'Julius', 'b0000000-0000-0000-0000-000000000013', 's0000000-0000-0000-0000-000000000001', 6.8, 70, 8, 'Hazy IPA pełna brzoskwiń, mango i marakui.', 'https://media.screensdesign.com/image-placeholder.jpg', 65, 50, 85, 20),
('c0000000-0000-0000-0000-000000000006', 'Ruination Double IPA', 'b0000000-0000-0000-0000-000000000009', 's0000000-0000-0000-0000-000000000001', 8.2, 100, 15, 'Potężna dawka chmielowej goryczki i żywicy.', 'https://media.screensdesign.com/image-placeholder.jpg', 80, 95, 40, 45),

-- Lager / Pils
('c0000000-0000-0000-0000-000000000007', 'Mrauu', 'b0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000007', 5.0, 35, 7, 'Klasyczny pils z nutą nowofalowego chmielu.', 'https://media.screensdesign.com/image-placeholder.jpg', 48, 45, 20, 35),
('c0000000-0000-0000-0000-000000000008', 'Pia', 'b0000000-0000-0000-0000-000000000011', 's0000000-0000-0000-0000-000000000007', 4.5, 40, 6, 'Rześki, chmielowy Pils rzemieślniczy.', 'https://media.screensdesign.com/image-placeholder.jpg', 42, 55, 15, 30),
('c0000000-0000-0000-0000-000000000009', 'Hazy Pils', 'b0000000-0000-0000-0000-000000000012', 's0000000-0000-0000-0000-000000000007', 4.8, 30, 8, 'Niefiltrowany pils od Nepomucena.', 'https://media.screensdesign.com/image-placeholder.jpg', 45, 40, 25, 40),
('c0000000-0000-0000-0000-000000000010', 'Bawarski Lager', 'b0000000-0000-0000-0000-000000000005', 's0000000-0000-0000-0000-000000000002', 5.2, 22, 10, 'Jasne, słodowe piwo nawiązujące do klasyki Niemiec.', 'https://media.screensdesign.com/image-placeholder.jpg', 50, 25, 10, 60),

-- Stout
('c0000000-0000-0000-0000-000000000011', 'Draught', 'b0000000-0000-0000-0000-000000000010', 's0000000-0000-0000-0000-000000000003', 4.2, 45, 80, 'Klasyczny irlandzki suchy stout.', 'https://media.screensdesign.com/image-placeholder.jpg', 40, 45, 5, 55),
('c0000000-0000-0000-0000-000000000012', 'Noa Pecan Mud Cake', 'b0000000-0000-0000-0000-000000000008', 's0000000-0000-0000-0000-000000000003', 11.0, 60, 100, 'Gęsty, słodki i deserowy Imperial Stout.', 'https://media.screensdesign.com/image-placeholder.jpg', 90, 40, 20, 95),
('c0000000-0000-0000-0000-000000000013', 'Beer Geek Breakfast', 'b0000000-0000-0000-0000-000000000007', 's0000000-0000-0000-0000-000000000003', 7.5, 75, 90, 'Oatmeal Stout parzony z kawą.', 'https://media.screensdesign.com/image-placeholder.jpg', 72, 60, 15, 75),
('c0000000-0000-0000-0000-000000000014', 'Bursztynowy Kot', 'b0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000003', 6.0, 30, 75, 'Delikatnie palony stout mleczny.', 'https://media.screensdesign.com/image-placeholder.jpg', 55, 30, 25, 70),

-- Porter
('c0000000-0000-0000-0000-000000000015', 'Porter Bałtycki', 'b0000000-0000-0000-0000-000000000004', 's0000000-0000-0000-0000-000000000005', 9.0, 35, 80, 'Piwowarski skarb Polski, gęsty i likierowy.', 'https://media.screensdesign.com/image-placeholder.jpg', 85, 35, 35, 85),
('c0000000-0000-0000-0000-000000000016', 'Black Cyl', 'b0000000-0000-0000-0000-000000000012', 's0000000-0000-0000-0000-000000000005', 7.2, 40, 70, 'Smoked Porter z dymnym profilem.', 'https://media.screensdesign.com/image-placeholder.jpg', 70, 45, 10, 80),
('c0000000-0000-0000-0000-000000000017', 'ART+8', 'b0000000-0000-0000-0000-000000000015', 's0000000-0000-0000-0000-000000000005', 8.5, 45, 90, 'Imperialny Porter ze świetnie ukrytym alkoholem.', 'https://media.screensdesign.com/image-placeholder.jpg', 82, 40, 40, 88),

-- Weizen
('c0000000-0000-0000-0000-000000000018', 'Biały Kot', 'b0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000004', 5.2, 12, 9, 'Tradycyjny niemiecki Hefeweizen. Banan i goździk.', 'https://media.screensdesign.com/image-placeholder.jpg', 50, 10, 65, 45),
('c0000000-0000-0000-0000-000000000019', 'Czeski Błąd', 'b0000000-0000-0000-0000-000000000005', 's0000000-0000-0000-0000-000000000004', 4.8, 15, 11, 'Lekki i puszysty weizen z cytrusową nutą.', 'https://media.screensdesign.com/image-placeholder.jpg', 48, 12, 55, 40),
('c0000000-0000-0000-0000-000000000020', 'Pia Weizen', 'b0000000-0000-0000-0000-000000000011', 's0000000-0000-0000-0000-000000000004', 5.5, 14, 12, 'Polski weizen rzemieślniczy na ciepłe dni.', 'https://media.screensdesign.com/image-placeholder.jpg', 52, 14, 60, 45),

-- Sour
('c0000000-0000-0000-0000-000000000021', 'Kwas Theta', 'b0000000-0000-0000-0000-000000000004', 's0000000-0000-0000-0000-000000000006', 4.5, 5, 8, 'Klasyczny polski kwas, intensywnie owocowy (mango/marakuja).', 'https://media.screensdesign.com/image-placeholder.jpg', 45, 5, 85, 20),
('c0000000-0000-0000-0000-000000000022', 'Gelato Mango & Peach', 'b0000000-0000-0000-0000-000000000006', 's0000000-0000-0000-0000-000000000006', 5.5, 5, 15, 'Pastry Sour gęste jak lody owocowe.', 'https://media.screensdesign.com/image-placeholder.jpg', 52, 5, 95, 30),
('c0000000-0000-0000-0000-000000000023', 'Gueuze 100% Lambic', 'b0000000-0000-0000-0000-000000000014', 's0000000-0000-0000-0000-000000000006', 5.0, 10, 14, 'Belgijski klasyk, wytrawny, kwaśny i dziki.', 'https://media.screensdesign.com/image-placeholder.jpg', 48, 15, 60, 20),
('c0000000-0000-0000-0000-000000000024', 'Kwaśny Kot', 'b0000000-0000-0000-0000-000000000001', 's0000000-0000-0000-0000-000000000006', 4.2, 8, 6, 'Rześki Berliner Weisse.', 'https://media.screensdesign.com/image-placeholder.jpg', 40, 8, 70, 15),
('c0000000-0000-0000-0000-000000000025', 'Spontanbasil', 'b0000000-0000-0000-0000-000000000007', 's0000000-0000-0000-0000-000000000006', 6.0, 15, 12, 'Sour ale warzone z bazylią, niezwykle aromatyczne.', 'https://media.screensdesign.com/image-placeholder.jpg', 55, 10, 75, 25),

-- Belgijskie
('c0000000-0000-0000-0000-000000000026', 'Kriek 100% Lambic', 'b0000000-0000-0000-0000-000000000014', 's0000000-0000-0000-0000-000000000008', 5.0, 0, 30, 'Tradycyjny Lambic z dodatkiem kwaśnych wiśni.', 'https://media.screensdesign.com/image-placeholder.jpg', 50, 10, 85, 25),
('c0000000-0000-0000-0000-000000000027', 'Oaty', 'b0000000-0000-0000-0000-000000000011', 's0000000-0000-0000-0000-000000000008', 5.5, 30, 20, 'Owsiane belgijskie ale rzemieślnicze.', 'https://media.screensdesign.com/image-placeholder.jpg', 55, 25, 45, 50),
('c0000000-0000-0000-0000-000000000028', 'Mera IPA', 'b0000000-0000-0000-0000-000000000005', 's0000000-0000-0000-0000-000000000008', 6.5, 45, 12, 'Belgian IPA – owoce estrowe i mocne chmielenie.', 'https://media.screensdesign.com/image-placeholder.jpg', 62, 55, 65, 35),
('c0000000-0000-0000-0000-000000000029', 'Fat Tire', 'b0000000-0000-0000-0000-000000000003', 's0000000-0000-0000-0000-000000000008', 5.2, 22, 18, 'Amber Ale wzorowane na belgijskiej tradycji.', 'https://media.screensdesign.com/image-placeholder.jpg', 50, 25, 30, 60),

-- Więcej mixu
('c0000000-0000-0000-0000-000000000030', 'Hazy Disco', 'b0000000-0000-0000-0000-000000000004', 's0000000-0000-0000-0000-000000000001', 6.5, 40, 9, 'New England IPA, sok owocowy w płynie.', 'https://media.screensdesign.com/image-placeholder.jpg', 60, 35, 90, 25),
('c0000000-0000-0000-0000-000000000031', 'Gelato Yellow', 'b0000000-0000-0000-0000-000000000006', 's0000000-0000-0000-0000-000000000006', 5.5, 0, 10, 'Kwas z dodatkiem mango i marakui.', 'https://media.screensdesign.com/image-placeholder.jpg', 55, 5, 98, 25),
('c0000000-0000-0000-0000-000000000032', 'Green', 'b0000000-0000-0000-0000-000000000013', 's0000000-0000-0000-0000-000000000001', 7.5, 75, 10, 'Ikoniczne IPA od Tree House.', 'https://media.screensdesign.com/image-placeholder.jpg', 72, 60, 80, 25),
('c0000000-0000-0000-0000-000000000033', 'Elvis Juice', 'b0000000-0000-0000-0000-000000000002', 's0000000-0000-0000-0000-000000000001', 6.5, 40, 14, 'Grapefruit Infused IPA.', 'https://media.screensdesign.com/image-placeholder.jpg', 62, 50, 80, 30),
('c0000000-0000-0000-0000-000000000034', 'Zonker', 'b0000000-0000-0000-0000-000000000008', 's0000000-0000-0000-0000-000000000003', 7.0, 50, 85, 'Stout z niespodziewanym chmieleniem.', 'https://media.screensdesign.com/image-placeholder.jpg', 65, 60, 20, 75),
('c0000000-0000-0000-0000-000000000035', 'Crazy Mike', 'b0000000-0000-0000-0000-000000000012', 's0000000-0000-0000-0000-000000000001', 9.0, 100, 20, 'Double IPA, mordercza goryczka i owoce tropikalne.', 'https://media.screensdesign.com/image-placeholder.jpg', 85, 95, 50, 45)
ON CONFLICT (id) DO NOTHING;
