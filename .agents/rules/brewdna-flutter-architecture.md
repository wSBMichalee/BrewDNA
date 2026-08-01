---
trigger: always_on
---

BrewDNA jest aplikacją Flutter i musi zachować Clean Architecture oraz strukturę
feature-first.

Struktura:

- lib/core: współdzielone, stabilne elementy: theme, routing, DI, design tokens,
  komponenty, narzędzia.
- lib/features/<feature>/data: DTO, datasource, implementacje repozytoriów.
- lib/features/<feature>/domain: encje, kontrakty repozytoriów, use case’y; bez
  zależności od Fluttera, Supabase i HTTP.
- lib/features/<feature>/presentation: ekrany, widgety, stan UI i
  kontrolery/bloc/cubit.

Zasady:

- Ekran nie może wykonywać zapytań API ani zawierać logiki biznesowej.
- UI komunikuje się z domain przez stan i use case’y, nie przez implementacje
  data.
- Nie dodawaj nowej logiki do main.dart, app_router.dart ani widgetów wspólnych
  bez uzasadnienia.
- Dziel duże pliki na małe, odpowiedzialne komponenty. Każdy widget i klasa ma
  jedną wyraźną odpowiedzialność.
- Nie kopiuj kodu, styli ani logiki; wyodrębniaj reużywalne komponenty i
  funkcje.
- Nie używaj dynamic, globalnego mutowalnego stanu, callback chains ani
  magicznych stringów/liczb bez nazwanego kontekstu.
- Nie zmieniaj kontraktów API, modeli, migracji ani logiki backendu podczas
  zadania czysto frontendowego.
