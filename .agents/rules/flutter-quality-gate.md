---
trigger: always_on
---

Dla każdego projektu Flutter pracuj zgodnie z poniższymi zasadami:

1. Architektura

- Stosuj Clean Architecture i układ feature-first: lib/core oraz
  lib/features/<feature>/{data,domain,presentation}.
- Domain nie może zależeć od Fluttera, HTTP, Supabase ani implementacji UI.
- UI nie może zawierać zapytań do API, SQL, mapowania DTO ani logiki biznesowej.
- Każdy ekran dziel na małe, czytelne widgety; nie twórz ekranów-monolitów.
- Nie duplikuj stylów, kolorów, odstępów ani logiki — używaj design tokens i
  komponentów wspólnych.
- Nie wprowadzaj magicznych wartości bez uzasadnienia; nazwiij stałe
  semantycznie.

2. Jakość i bezpieczeństwo

- Nie zmieniaj zakresu zadania bez wyraźnej zgody użytkownika.
- Nie zapisuj sekretów, kluczy API ani haseł w kodzie, plikach konfiguracyjnych
  lub logach.
- Przed uznaniem zadania za gotowe uruchom adekwatne kontrole: formatowanie,
  analizę statyczną i testy.
- Nie deklaruj sukcesu, jeśli weryfikacja nie została wykonana. Podaj dokładnie
  co uruchomiono i wynik.
- Naprawiaj przyczynę problemu, nie tylko jego objaw. Nie wyciszaj warningów bez
  uzasadnienia.
- Zachowaj istniejące, niezwiązane z zadaniem zmiany użytkownika.

3. UI/UX

- Projektuj mobile-first, responsywnie i z obsługą SafeArea, małych ekranów,
  dużej czcionki i accessibility.
- Każdy ekran asynchroniczny musi mieć dopracowany stan loading, empty, error
  oraz retry.
- Animacje mają być krótkie, celowe, możliwe do ograniczenia przy preferencji
  reduced motion i nie mogą pogarszać płynności.
- Glassmorphism/liquid glass stosuj oszczędnie: czytelny kontrast, ograniczony
  blur, brak nadmiaru półprzezroczystych kart.
- Każda interakcja musi mieć stan pressed, disabled i jasny feedback.
- Nie używaj generycznych „AI UI patterns”. Buduj spójny, charakterystyczny
  produkt.

4. Definition of Done

- Kod jest sformatowany i przechodzi analizę statyczną bez nowych błędów.
- Testy krytycznego flow zostały uruchomione i przechodzą.
- Zmiana została zweryfikowana wizualnie na docelowym rozmiarze telefonu.
- Podsumowanie zawiera: co zmieniono, co zweryfikowano oraz znane ograniczenia.
