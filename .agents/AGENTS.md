
## Zasady Bezpieczeństwa (Security Rules)
- **NIGDY** nie proś użytkownika o wklejenie w czacie sekretów, takich jak `service_role key`, `GEMINI_API_KEY`, hasła do bazy danych, czy inne tokeny.
- Zamiast tego, poinstruuj użytkownika, aby samodzielnie wykonał odpowiednie komendy w swoim terminalu (np. `supabase login`, `supabase secrets set`).
- Wyjątek stanowią wartości jawne: **Project Ref** oraz **anon key** – te mogą być bezpiecznie przekazywane w oknie czatu.
