---
trigger: always_on
---

Nie uznawaj zadania za zakończone bez rzeczywistej weryfikacji.

Dla każdej zmiany kodu:

1. Uruchom formatowanie kodu.
2. Uruchom analizę statyczną bez nowych błędów.
3. Uruchom testy adekwatne do zmiany; krytyczne flow wymagają testu.
4. Zweryfikuj wizualnie zmienione ekrany na docelowym rozmiarze telefonu, jeśli
   zmiana dotyczy UI.
5. Sprawdź stan loading, empty i error, jeśli ekran pobiera dane.
6. W podsumowaniu podaj: zmienione obszary, uruchomione kontrole i ich wynik
   oraz ewentualne ograniczenia.

Nie maskuj błędów przez wyłączanie linterów, catch bez obsługi, ignorowanie
wyjątków ani usuwanie testów.
