---
trigger: always_on
---

Płynność aplikacji jest wymaganiem produktu.

- Unikaj zbędnych rebuildów, kosztownych efektów blur, dużych obrazów i ciężkich
  obliczeń w metodzie build.
- Stosuj lazy listy dla długich zbiorów oraz const widgety tam, gdzie to
  możliwe.
- Używaj cache dla obrazów i nie pobieraj tych samych danych wielokrotnie bez
  potrzeby.
- Blur i animacje stosuj selektywnie; elementy animowane muszą pozostać płynne
  na przeciętnym telefonie.
- Nie blokuj głównego wątku operacjami IO, parsowaniem lub obliczeniami.
- Przed dodaniem paczki sprawdź, czy jej funkcji nie oferuje Flutter/Dart albo
  obecne zależności.
