---
trigger: always_on
---

1. Każde "zrobione" musi być potwierdzone realnym outputem (flutter analyze /
   git diff) — nie samym opisem słownym.
2. Zrzuty ekranu i inne dowody wizualne muszą pochodzić z realnych plików
   wgranych w czacie przez użytkownika. Ścieżka na dysku ani plik .md z opisem
   "artefaktu" nigdy nie są wystarczające jako potwierdzenie zmiany UI.
3. Zero masowych regexów/skryptów zmieniających wiele plików naraz bez wyraźnej
   zgody użytkownika — domyślnie edycja plik po pliku, z diffem.
4. Nigdy nie proś o ani nie zapisuj: service_role key, GEMINI_API_KEY, haseł do
   bazy danych. Tylko project ref + anon/publishable key są bezpieczne do użycia
   w czacie.
5. Nie rozszerzaj samodzielnie zakresu zadania na inne pliki/ostrzeżenia/
   refactory "przy okazji" — zgłoś to jako propozycję i czekaj na zgodę.
6. Po każdej zmianie dotykającej UI/logiki uruchom `flutter analyze` i pokaż
   czysty wynik (0 errors) przed uznaniem zadania za zakończone.
7. Po zaimplementowaniu zmiany UI NIE deklaruj zadania jako zakończonego —
   poinformuj że kod czeka na potwierdzenie realnym zrzutem ekranu od
   użytkownika, i nie przechodź do kolejnego punktu listy zanim to potwierdzenie
   nie nadejdzie.

## Kontekst projektu BrewDNA

Stack: Flutter (Clean Architecture, BLoC/Cubit, get_it/injectable), Supabase
(Postgres+RLS+triggery+Edge Functions na gemini-3.5-flash), native_glass_navbar,
flutter_screenutil, Cupertino-only.

Design system "Golden Native Calm": amber #F5A623 na ivory. Font Inter
(UI/body) + Fraunces (WYŁĄCZNIE duże nagłówki wizerunkowe — momenty
kulminacyjne, nie zwykłe nagłówki sekcji). Glassmorphism (BackdropFilter, blur
~15, tło ~65% przezroczystości) na kartach/chipach/nawigacji — to spójny język
wizualny całej appki, nie punktowa dekoracja.

Twarde zasady: zero mieszania Material z Cupertino. Wszystkie kolory z AppColors
— zero Color()/Colors.* rozsianych po kodzie. Nazwa paczki w pubspec.yaml wciąż
"hop_iq" — rebranding na "brew_dna" świadomie odłożony, nie zmieniaj tego
samodzielnie bez wyraźnego zlecenia.

Znane otwarte problemy (nie zamykaj bez weryfikacji):

- Preferencje z quizu onboardingowego NIE są zapisywane do taste_profiles w
  Supabase — Discover działa na tymczasowym, zahardcodowanym profilu
  (_tempTasteProfile w beer_cubit.dart)
- Realna rejestracja (auth.signUp) nigdy nie potwierdzona end-to-end w panelu
  Supabase
- Istnieją dwa osobne ekrany z ciekawostkami piwnymi:
  interstitial_fact_page.dart (Step 3/6) i analyzing_page.dart (ekran ładowania)
  — sprawdź czy oba są faktycznie w flow i czy to nie jest redundancja przed
  jakąkolwiek dalszą zmianą w tym obszarze

Pre-production checklist (przypomnij, jeśli temat wypłynie):

- Włączyć z powrotem "Confirm email" w Supabase Auth
- Dodać reset() dla OnboardingCubit na starcie intro_screen.dart
- Skonfigurować własny provider SMTP (Resend/Postmark/SendGrid) w Supabase Auth, zamiast polegać na domyślnym (zapobiega bounce rate i rate limits).
