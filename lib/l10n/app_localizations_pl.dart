// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get tabHistory => 'Moje Piwa';

  @override
  String get tabMap => 'Mapa';

  @override
  String get tabDiscover => 'Odkryj';

  @override
  String get tabProfile => 'Profil';

  @override
  String get tabScan => 'Skanuj';

  @override
  String get authStartTitle => 'Zacznij budować swoją kolekcję';

  @override
  String get authStartApple => 'Kontynuuj z Apple';

  @override
  String get authStartGoogle => 'Kontynuuj z Google';

  @override
  String get authStartOr => 'lub';

  @override
  String get authStartEmail => 'Kontynuuj emailem';

  @override
  String get authStartAlreadyHaveAccount => 'Masz już konto? ';

  @override
  String get authStartLogin => 'Zaloguj się';

  @override
  String get authStartComingSoonTitle => 'Wkrótce dostępne';

  @override
  String get authStartComingSoonContent =>
      'Ta metoda logowania będzie dostępna w przyszłych wersjach.';

  @override
  String get authStartComingSoonOk => 'OK';

  @override
  String welcomeTitle(Object name) {
    return 'Witaj w BrewDNA, $name!';
  }

  @override
  String get welcomeSubtitle =>
      'Zeskanuj swoje pierwsze piwo, żeby zacząć budować swoją kolekcję.';

  @override
  String get welcomeScanButton => 'Zeskanuj pierwsze piwo';

  @override
  String get welcomeMaybeLater => 'Może później';

  @override
  String get emailTitle => 'Jaki jest Twój e-mail?';

  @override
  String get emailSubtitle => 'Użyjemy go do logowania i ważnych powiadomień.';

  @override
  String get emailHint => 'adres@email.com';

  @override
  String get emailNext => 'Dalej';

  @override
  String get passwordTitleLogin => 'Podaj hasło';

  @override
  String get passwordTitleRegister => 'Ustaw hasło';

  @override
  String get passwordSubtitle => 'Minimum 8 znaków.';

  @override
  String get passwordHint => 'Wpisz hasło';

  @override
  String get passwordNext => 'Dalej';

  @override
  String get detailsTitle => 'Ostatni krok';

  @override
  String get detailsHint => 'Imię';

  @override
  String get detailsCountryPoland => 'Polska';

  @override
  String get detailsCountryGermany => 'Niemcy';

  @override
  String get detailsCountryCzech => 'Czechy';

  @override
  String get detailsCountryUK => 'Wielka Brytania';

  @override
  String get detailsCountryUSA => 'USA';

  @override
  String get detailsCountryPlaceholder => 'Kraj';

  @override
  String get detailsTermsAccept => 'Akceptuję ';

  @override
  String get detailsTermsLink => 'Regulamin';

  @override
  String get detailsTermsAnd => ' i ';

  @override
  String get detailsPrivacyLink => 'Politykę Prywatności';

  @override
  String get detailsRegistering => 'Rejestracja...';

  @override
  String get detailsContinue => 'Kontynuuj';

  @override
  String get detailsErrorGeneric =>
      'Wystąpił błąd podczas rejestracji. Spróbuj ponownie.';

  @override
  String get detailsErrorTitle => 'Błąd';

  @override
  String get historyTabRatings => 'Oceny';

  @override
  String get historyTabWishlist => 'Wishlista';

  @override
  String get historyTabCellar => 'Piwniczka';

  @override
  String get historyTabHistory => 'Historia';

  @override
  String get historyEmptyState => 'Brak danych';

  @override
  String get scanInstruction => 'Umieść ETYKIETĘ PIWA w ramce';

  @override
  String get mapTitle => 'Mapa świata';

  @override
  String mapCountriesDiscovered(int count) {
    return '$count z 195 krajów odkrytych';
  }

  @override
  String mapPercentDiscovered(int percent) {
    return '$percent% ODKRYTE';
  }

  @override
  String get mapRecentlyDiscovered => 'Ostatnio odkryte';

  @override
  String get mapEmptyState => 'Brak odkrytych piw.';

  @override
  String get mapDummyCzech => 'Czechy';

  @override
  String get mapDummyCzechCount => '12 piw';

  @override
  String get mapDummyGermany => 'Niemcy';

  @override
  String get mapDummyGermanyCount => '8 piw';

  @override
  String get mapDummyBelgium => 'Belgia';

  @override
  String get mapDummyBelgiumCount => '5 piw';

  @override
  String get discoverGreetingHello => 'Cześć, ';

  @override
  String get discoverGreetingDefaultName => 'Smakoszu';

  @override
  String get discoverSubtitle => 'Oto piwa, które mogą Ci podejść';

  @override
  String get discoverBeerOfTheDayLabel => 'PIWO DNIA';

  @override
  String get discoverRecommendedTitle => 'Polecane dla Ciebie';

  @override
  String get discoverSeeAll => 'Zobacz wszystkie';

  @override
  String get profileDnaAnalyzing => 'Analizowanie Twojego DNA smakowego...';

  @override
  String get profileDnaReady =>
      'Twoje DNA smakowe jest już gotowe. Kliknij, by je poznać.';

  @override
  String get profileDnaMoreBeers =>
      'Jesteś na dobrej drodze. Spróbuj więcej piw, by wygenerować swój profil.';

  @override
  String get profileDnaError => 'Błąd pobierania DNA smakowego.';

  @override
  String get profileDummyName => 'Michał';

  @override
  String get profileAchievementsTitle => 'Osiągnięcia';

  @override
  String get profileAchievement1Title => 'Odkrywca';

  @override
  String get profileAchievement1Subtitle => '19 stylów';

  @override
  String get profileAchievement2Title => 'Top 10';

  @override
  String get profileAchievement2Subtitle => 'w Polsce';

  @override
  String get profileAchievement3Title => 'Koneser';

  @override
  String get profileAchievement3Subtitle => '100+ ocen';

  @override
  String get profileTasteProfileTitle => 'Profil smakowy';

  @override
  String get profileTasteTabStyles => 'Style';

  @override
  String get profileTasteTabCountries => 'Kraje';

  @override
  String get profileBrewDnaTitle => 'Twoje BrewDNA';

  @override
  String get beerDetailsEmpty => 'Brak danych piwa';

  @override
  String get beerDetailsTopStyle => 'TOP 2% W STYLU';

  @override
  String get beerDetailsTopCountry => 'TOP 1% W POLSCE';

  @override
  String beerDetailsStyleCountry(Object style, Object country) {
    return '🍺 $style z $country';
  }

  @override
  String get beerDetailsRate => 'Oceń';

  @override
  String get beerDetailsMoreOptions => 'Więcej opcji...';

  @override
  String beerDetailsRated(Object rating) {
    return 'Oceniłeś: $rating';
  }

  @override
  String get beerDetailsInsightsTitle => 'Wgląd w piwo';

  @override
  String get beerDetailsInsightsSubtitle => 'Czy to piwo Ci zasmakuje?';

  @override
  String get beerDetailsStyleMatch => 'Prawdopodobnie polubisz ten styl';

  @override
  String get rateBeerSavedSuccess => 'Ocena zapisana!';

  @override
  String get rateBeerOverallLabel => 'TWOJA OGÓLNA OCENA';

  @override
  String get rateBeerTaste => 'Smak';

  @override
  String get rateBeerAroma => 'Aromat';

  @override
  String get rateBeerBitterness => 'Gorycz';

  @override
  String get rateBeerAppearance => 'Wygląd';

  @override
  String get rateBeerDrinkability => 'Pijalność';

  @override
  String get rateBeerNoteLabel => 'Notatka (opcjonalnie)';

  @override
  String get rateBeerNotePlaceholder => 'Co Ci się podobało?';

  @override
  String get rateBeerPhotoLabel => 'Zdjęcie';

  @override
  String get rateBeerPhotoAdd => 'Dodaj zdjęcie';

  @override
  String get rateBeerSaving => 'Zapisywanie...';

  @override
  String get rateBeerSaveButton => 'Zapisz ocenę';

  @override
  String get rateBeerYourRating => 'Twoja ocena';

  @override
  String get rateBeerShareButton => 'Udostępnij ocenę';

  @override
  String get rateBeerClose => 'Zamknij';

  @override
  String get rateBeerGallerySavedSuccess => 'Zapisano w galerii!';

  @override
  String get rateBeerGallerySavedError => 'Błąd zapisu.';

  @override
  String get beerReviewsTitle => 'Recenzje';

  @override
  String get beerReviewsRatingsCountLabel => 'OCEN';

  @override
  String get beerReviewsWriteReviewButton => 'Napisz recenzję';

  @override
  String get beerReviewsUseCardButtonNotice =>
      'Użyj przycisku na karcie piwa aby ocenić';

  @override
  String beerReviewsDaysAgo(Object days) {
    return '$days dni temu';
  }

  @override
  String beerReviewsHoursAgo(Object hours) {
    return '$hours godz temu';
  }

  @override
  String beerReviewsMinsAgo(Object mins) {
    return '$mins min temu';
  }

  @override
  String get shareCardMyRatingLabel => 'MOJA OCENA';

  @override
  String get shareCardMatchSuffix => '% zgodności z Twoim gustem';

  @override
  String get shareCardSave => 'Zapisz';

  @override
  String get onboardingQ1Title => 'Co powiesz na goryczkę?';

  @override
  String get onboardingQ1Subtitle =>
      'Pomyśl o czystym lagerze kontra mocnym west-coast IPA.';

  @override
  String get onboardingQ1Left => 'Łagodne';

  @override
  String get onboardingQ1Right => 'Gorzkie';

  @override
  String get onboardingNextQuestionButton => 'Następne pytanie';

  @override
  String get onboardingQ2Title => 'Jak lubisz swoje piwo?';

  @override
  String get onboardingQ2Subtitle =>
      'Lekkie i orzeźwiające, czy mocne i rozgrzewające?';

  @override
  String get onboardingQ2Left => 'Lekkie';

  @override
  String get onboardingQ2Right => 'Mocne';

  @override
  String get onboardingQ3Title => 'Owocowe czy wytrawne?';

  @override
  String get onboardingQ3Subtitle =>
      'Pomyśl o soczystym NEIPA kontra klasycznym, wytrawnym pilznerze.';

  @override
  String get onboardingQ3Left => 'Owocowe';

  @override
  String get onboardingQ3Right => 'Wytrawne';

  @override
  String get onboardingQ4Title => 'A może coś słodowego?';

  @override
  String get onboardingQ4Subtitle => 'Suche i lekkie, czy słodowe i pełne?';

  @override
  String get onboardingQ4Left => 'Suche';

  @override
  String get onboardingQ4Right => 'Słodowe';

  @override
  String get onboardingNextButton => 'Dalej';

  @override
  String get onboardingQ5Title => 'Jakie style już znasz i lubisz?';

  @override
  String get onboardingQ5Subtitle =>
      'Wybierz tyle, ile chcesz — to pomoże nam Cię lepiej poznać.';

  @override
  String get onboardingQ6Title => 'Skąd najchętniej sięgasz po piwo?';

  @override
  String get onboardingQ6Subtitle => 'Wybierz swoje ulubione kraje piwne.';

  @override
  String onboardingStep(Object step, Object totalSteps) {
    return 'STEP $step OF $totalSteps';
  }

  @override
  String get onboardingExpTitle => 'Jak dobrze znasz świat piwa?';

  @override
  String get onboardingExpLevel1Title => 'Dopiero zaczynam';

  @override
  String get onboardingExpLevel1Subtitle => 'Odkrywam nowe smaki krok po kroku';

  @override
  String get onboardingExpLevel2Title => 'Znam się nieźle';

  @override
  String get onboardingExpLevel2Subtitle =>
      'Mam swoje ulubione style i szukam więcej';

  @override
  String get onboardingExpLevel3Title => 'Jestem hobbystą';

  @override
  String get onboardingExpLevel3Subtitle =>
      'Piwo to moja pasja, chcę odkrywać rzadkości';

  @override
  String get onboardingExpSeeProfileButton => 'Zobacz mój profil';

  @override
  String get onboardingAnalyzingTitle => 'Analizujemy Twój gust...';

  @override
  String get onboardingAnalyzingFact =>
      'IPA zawdzięcza swoją moc kolonialnej historii Anglii — warzono je mocniej, by przetrwały rejs do Indii.';

  @override
  String get onboardingAnalyzingWait => 'Chwileczkę...';

  @override
  String get onboardingFactTitle =>
      'Twój profil smakowy zaczyna nabierać kształtu';

  @override
  String get onboardingFactBadge => 'CZY WIESZ, ŻE?';

  @override
  String get onboardingFactContentFruity =>
      'Chmiel można tak dobrać, że piwo pachnie mango czy marakują, mimo że w warzelni nie ma ani grama owoców - to zasługa naturalnych związków (tioli) uwalnianych przez drożdże podczas fermentacji.';

  @override
  String get onboardingFactContentDry =>
      'Klasyczne, wytrawne lagery leżakują w niskiej temperaturze nawet kilka tygodni - to właśnie ten długi, zimny spoczynek daje im tak czysty, chrupiący finisz.';

  @override
  String get onboardingHookTitle => 'Świetnie!';

  @override
  String get onboardingHookSubtitle =>
      'Na podstawie Twoich odpowiedzi prawdopodobnie polubisz';

  @override
  String get onboardingHookDescription => 'SOCZYSTE, OWOCOWE, Z NUTĄ CYTRUSÓW';

  @override
  String get onboardingHookFooter =>
      'Twoje DNA piwne jest unikalne. Odkryliśmy Twój idealny punkt startowy.';

  @override
  String get onboardingHookRegisterButton => 'Załóż konto, by zapisać profil';

  @override
  String get onboardingIntroSubtitle => 'Twój osobisty przewodnik po piwie';

  @override
  String get onboardingIntroFeature1Title => 'Inteligentne skanowanie etykiet';

  @override
  String get onboardingIntroFeature1Desc =>
      'Błyskawicznie rozpoznawaj piwa dzięki AI.';

  @override
  String get onboardingIntroFeature2Title => 'Dopasowanie smaku';

  @override
  String get onboardingIntroFeature2Desc =>
      'Znajdź piwa idealnie dopasowane do Twojego profilu.';

  @override
  String get onboardingIntroStartButton => 'Odkryj swój gust';

  @override
  String get onboardingIntroLoginButton => 'Zaloguj się';

  @override
  String get paywallTitle => 'BrewDNA Premium';

  @override
  String get paywallSubtitle =>
      'Odblokuj pełny potencjał swojego profilu piwnego';

  @override
  String get paywallFeature1Title => 'AI bez limitu';

  @override
  String get paywallFeature1Desc => 'Nielimitowane skany i BeerDNA';

  @override
  String get paywallFeature2Title => 'Zaawansowane statystyki';

  @override
  String get paywallFeature2Desc => 'Odkryj ukryte wzorce w swoich ocenach';

  @override
  String get paywallFeature3Title => 'Eksport kolekcji';

  @override
  String get paywallFeature3Desc => 'Pobierz swoje dane do CSV lub PDF';

  @override
  String get paywallFeature4Title => 'Backup w chmurze';

  @override
  String get paywallFeature4Desc => 'Nigdy nie trać swojej kolekcji';

  @override
  String get paywallFeature5Title => 'Ekskluzywne odznaki';

  @override
  String get paywallFeature5Desc => 'Zdobądź profil premium na platformie';

  @override
  String get paywallPlanMonthly => 'Miesięcznie';

  @override
  String get paywallPlanMonthlyDesc => 'Rozliczenie co miesiąc';

  @override
  String get paywallPlanYearly => 'Rocznie';

  @override
  String get paywallPlanYearlyDesc => '3 dni za darmo, potem 149,99 zł/rok';

  @override
  String get paywallPlanYearlyBadge => 'Oszczędzasz 16%';

  @override
  String get paywallBuyButton => 'Kup';

  @override
  String get paywallDisclaimer =>
      'Płatność pobierana przy zakupie. Subskrypcja odnawia się automatycznie, chyba że zostanie anulowana 24h przed końcem bieżącego okresu. Możesz zarządzać subskrypcjami w Ustawieniach Konta.';

  @override
  String get devWidgetGalleryCardDesc => 'Przykładowy opis karty.';

  @override
  String get scanResultManualSearchDesc => 'Otwieram ręczne wyszukiwanie...';

  @override
  String get scanningAnalyzingTryAgain => 'Spróbuj ponownie';

  @override
  String get discoverTopCountries => 'Odkryj smaki z różnych krajów';

  @override
  String get discoverTopRated => 'Najlepiej oceniane';

  @override
  String get discoverMatchedDna => 'Dopasowane do Twojego DNA smakowego';

  @override
  String beersCount(int count) {
    return '$count piw';
  }
}
