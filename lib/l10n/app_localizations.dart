import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// No description provided for @tabHistory.
  ///
  /// In pl, this message translates to:
  /// **'Moje Piwa'**
  String get tabHistory;

  /// No description provided for @tabMap.
  ///
  /// In pl, this message translates to:
  /// **'Mapa'**
  String get tabMap;

  /// No description provided for @tabDiscover.
  ///
  /// In pl, this message translates to:
  /// **'Odkryj'**
  String get tabDiscover;

  /// No description provided for @tabProfile.
  ///
  /// In pl, this message translates to:
  /// **'Profil'**
  String get tabProfile;

  /// No description provided for @tabScan.
  ///
  /// In pl, this message translates to:
  /// **'Skanuj'**
  String get tabScan;

  /// No description provided for @authStartTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zacznij budować swoją kolekcję'**
  String get authStartTitle;

  /// No description provided for @authStartApple.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj z Apple'**
  String get authStartApple;

  /// No description provided for @authStartGoogle.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj z Google'**
  String get authStartGoogle;

  /// No description provided for @authStartOr.
  ///
  /// In pl, this message translates to:
  /// **'lub'**
  String get authStartOr;

  /// No description provided for @authStartEmail.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj emailem'**
  String get authStartEmail;

  /// No description provided for @authStartAlreadyHaveAccount.
  ///
  /// In pl, this message translates to:
  /// **'Masz już konto? '**
  String get authStartAlreadyHaveAccount;

  /// No description provided for @authStartLogin.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get authStartLogin;

  /// No description provided for @authStartComingSoonTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wkrótce dostępne'**
  String get authStartComingSoonTitle;

  /// No description provided for @authStartComingSoonContent.
  ///
  /// In pl, this message translates to:
  /// **'Ta metoda logowania będzie dostępna w przyszłych wersjach.'**
  String get authStartComingSoonContent;

  /// No description provided for @authStartComingSoonOk.
  ///
  /// In pl, this message translates to:
  /// **'OK'**
  String get authStartComingSoonOk;

  /// No description provided for @welcomeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Witaj w BrewDNA, {name}!'**
  String welcomeTitle(Object name);

  /// No description provided for @welcomeSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Zeskanuj swoje pierwsze piwo, żeby zacząć budować swoją kolekcję.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeScanButton.
  ///
  /// In pl, this message translates to:
  /// **'Zeskanuj pierwsze piwo'**
  String get welcomeScanButton;

  /// No description provided for @welcomeMaybeLater.
  ///
  /// In pl, this message translates to:
  /// **'Może później'**
  String get welcomeMaybeLater;

  /// No description provided for @emailTitle.
  ///
  /// In pl, this message translates to:
  /// **'Jaki jest Twój e-mail?'**
  String get emailTitle;

  /// No description provided for @emailSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Użyjemy go do logowania i ważnych powiadomień.'**
  String get emailSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In pl, this message translates to:
  /// **'adres@email.com'**
  String get emailHint;

  /// No description provided for @emailNext.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get emailNext;

  /// No description provided for @passwordTitleLogin.
  ///
  /// In pl, this message translates to:
  /// **'Podaj hasło'**
  String get passwordTitleLogin;

  /// No description provided for @passwordTitleRegister.
  ///
  /// In pl, this message translates to:
  /// **'Ustaw hasło'**
  String get passwordTitleRegister;

  /// No description provided for @passwordSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Minimum 8 znaków.'**
  String get passwordSubtitle;

  /// No description provided for @passwordHint.
  ///
  /// In pl, this message translates to:
  /// **'Wpisz hasło'**
  String get passwordHint;

  /// No description provided for @passwordNext.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get passwordNext;

  /// No description provided for @detailsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Ostatni krok'**
  String get detailsTitle;

  /// No description provided for @detailsHint.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get detailsHint;

  /// No description provided for @detailsCountryPoland.
  ///
  /// In pl, this message translates to:
  /// **'Polska'**
  String get detailsCountryPoland;

  /// No description provided for @detailsCountryGermany.
  ///
  /// In pl, this message translates to:
  /// **'Niemcy'**
  String get detailsCountryGermany;

  /// No description provided for @detailsCountryCzech.
  ///
  /// In pl, this message translates to:
  /// **'Czechy'**
  String get detailsCountryCzech;

  /// No description provided for @detailsCountryUK.
  ///
  /// In pl, this message translates to:
  /// **'Wielka Brytania'**
  String get detailsCountryUK;

  /// No description provided for @detailsCountryUSA.
  ///
  /// In pl, this message translates to:
  /// **'USA'**
  String get detailsCountryUSA;

  /// No description provided for @detailsCountryPlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'Kraj'**
  String get detailsCountryPlaceholder;

  /// No description provided for @detailsTermsAccept.
  ///
  /// In pl, this message translates to:
  /// **'Akceptuję '**
  String get detailsTermsAccept;

  /// No description provided for @detailsTermsLink.
  ///
  /// In pl, this message translates to:
  /// **'Regulamin'**
  String get detailsTermsLink;

  /// No description provided for @detailsTermsAnd.
  ///
  /// In pl, this message translates to:
  /// **' i '**
  String get detailsTermsAnd;

  /// No description provided for @detailsPrivacyLink.
  ///
  /// In pl, this message translates to:
  /// **'Politykę Prywatności'**
  String get detailsPrivacyLink;

  /// No description provided for @detailsRegistering.
  ///
  /// In pl, this message translates to:
  /// **'Rejestracja...'**
  String get detailsRegistering;

  /// No description provided for @detailsContinue.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get detailsContinue;

  /// No description provided for @detailsErrorGeneric.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd podczas rejestracji. Spróbuj ponownie.'**
  String get detailsErrorGeneric;

  /// No description provided for @detailsErrorTitle.
  ///
  /// In pl, this message translates to:
  /// **'Błąd'**
  String get detailsErrorTitle;

  /// No description provided for @historyTabRatings.
  ///
  /// In pl, this message translates to:
  /// **'Oceny'**
  String get historyTabRatings;

  /// No description provided for @historyTabWishlist.
  ///
  /// In pl, this message translates to:
  /// **'Wishlista'**
  String get historyTabWishlist;

  /// No description provided for @historyTabCellar.
  ///
  /// In pl, this message translates to:
  /// **'Piwniczka'**
  String get historyTabCellar;

  /// No description provided for @historyTabHistory.
  ///
  /// In pl, this message translates to:
  /// **'Historia'**
  String get historyTabHistory;

  /// No description provided for @historyEmptyState.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych'**
  String get historyEmptyState;

  /// No description provided for @scanInstruction.
  ///
  /// In pl, this message translates to:
  /// **'Umieść ETYKIETĘ PIWA w ramce'**
  String get scanInstruction;

  /// No description provided for @mapTitle.
  ///
  /// In pl, this message translates to:
  /// **'Mapa świata'**
  String get mapTitle;

  /// No description provided for @mapCountriesDiscovered.
  ///
  /// In pl, this message translates to:
  /// **'{count} z 195 krajów odkrytych'**
  String mapCountriesDiscovered(int count);

  /// No description provided for @mapPercentDiscovered.
  ///
  /// In pl, this message translates to:
  /// **'{percent}% ODKRYTE'**
  String mapPercentDiscovered(int percent);

  /// No description provided for @mapRecentlyDiscovered.
  ///
  /// In pl, this message translates to:
  /// **'Ostatnio odkryte'**
  String get mapRecentlyDiscovered;

  /// No description provided for @mapEmptyState.
  ///
  /// In pl, this message translates to:
  /// **'Brak odkrytych piw.'**
  String get mapEmptyState;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'Czechy'**
  String get mapDummyCzech;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'12 piw'**
  String get mapDummyCzechCount;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'Niemcy'**
  String get mapDummyGermany;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'8 piw'**
  String get mapDummyGermanyCount;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'Belgia'**
  String get mapDummyBelgium;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'5 piw'**
  String get mapDummyBelgiumCount;

  /// No description provided for @discoverGreetingHello.
  ///
  /// In pl, this message translates to:
  /// **'Cześć, '**
  String get discoverGreetingHello;

  /// No description provided for @discoverGreetingDefaultName.
  ///
  /// In pl, this message translates to:
  /// **'Smakoszu'**
  String get discoverGreetingDefaultName;

  /// No description provided for @discoverSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Oto piwa, które mogą Ci podejść'**
  String get discoverSubtitle;

  /// No description provided for @discoverBeerOfTheDayLabel.
  ///
  /// In pl, this message translates to:
  /// **'PIWO DNIA'**
  String get discoverBeerOfTheDayLabel;

  /// No description provided for @discoverRecommendedTitle.
  ///
  /// In pl, this message translates to:
  /// **'Polecane dla Ciebie'**
  String get discoverRecommendedTitle;

  /// No description provided for @discoverSeeAll.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz wszystkie'**
  String get discoverSeeAll;

  /// No description provided for @profileDnaAnalyzing.
  ///
  /// In pl, this message translates to:
  /// **'Analizowanie Twojego DNA smakowego...'**
  String get profileDnaAnalyzing;

  /// No description provided for @profileDnaReady.
  ///
  /// In pl, this message translates to:
  /// **'Twoje DNA smakowe jest już gotowe. Kliknij, by je poznać.'**
  String get profileDnaReady;

  /// No description provided for @profileDnaMoreBeers.
  ///
  /// In pl, this message translates to:
  /// **'Jesteś na dobrej drodze. Spróbuj więcej piw, by wygenerować swój profil.'**
  String get profileDnaMoreBeers;

  /// No description provided for @profileDnaError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd pobierania DNA smakowego.'**
  String get profileDnaError;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'Michał'**
  String get profileDummyName;

  /// No description provided for @profileAchievementsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Osiągnięcia'**
  String get profileAchievementsTitle;

  /// No description provided for @profileAchievement1Title.
  ///
  /// In pl, this message translates to:
  /// **'Odkrywca'**
  String get profileAchievement1Title;

  /// No description provided for @profileAchievement1Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'19 stylów'**
  String get profileAchievement1Subtitle;

  /// No description provided for @profileAchievement2Title.
  ///
  /// In pl, this message translates to:
  /// **'Top 10'**
  String get profileAchievement2Title;

  /// No description provided for @profileAchievement2Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'w Polsce'**
  String get profileAchievement2Subtitle;

  /// No description provided for @profileAchievement3Title.
  ///
  /// In pl, this message translates to:
  /// **'Koneser'**
  String get profileAchievement3Title;

  /// No description provided for @profileAchievement3Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'100+ ocen'**
  String get profileAchievement3Subtitle;

  /// No description provided for @profileTasteProfileTitle.
  ///
  /// In pl, this message translates to:
  /// **'Profil smakowy'**
  String get profileTasteProfileTitle;

  /// No description provided for @profileTasteTabStyles.
  ///
  /// In pl, this message translates to:
  /// **'Style'**
  String get profileTasteTabStyles;

  /// No description provided for @profileTasteTabCountries.
  ///
  /// In pl, this message translates to:
  /// **'Kraje'**
  String get profileTasteTabCountries;

  /// No description provided for @profileBrewDnaTitle.
  ///
  /// In pl, this message translates to:
  /// **'Twoje BrewDNA'**
  String get profileBrewDnaTitle;

  /// No description provided for @beerDetailsEmpty.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych piwa'**
  String get beerDetailsEmpty;

  /// No description provided for @beerDetailsTopStyle.
  ///
  /// In pl, this message translates to:
  /// **'TOP 2% W STYLU'**
  String get beerDetailsTopStyle;

  /// No description provided for @beerDetailsTopCountry.
  ///
  /// In pl, this message translates to:
  /// **'TOP 1% W POLSCE'**
  String get beerDetailsTopCountry;

  /// No description provided for @beerDetailsStyleCountry.
  ///
  /// In pl, this message translates to:
  /// **'🍺 {style} z {country}'**
  String beerDetailsStyleCountry(Object style, Object country);

  /// No description provided for @beerDetailsRate.
  ///
  /// In pl, this message translates to:
  /// **'Oceń'**
  String get beerDetailsRate;

  /// No description provided for @beerDetailsMoreOptions.
  ///
  /// In pl, this message translates to:
  /// **'Więcej opcji...'**
  String get beerDetailsMoreOptions;

  /// No description provided for @beerDetailsRated.
  ///
  /// In pl, this message translates to:
  /// **'Oceniłeś: {rating}'**
  String beerDetailsRated(Object rating);

  /// No description provided for @beerDetailsInsightsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wgląd w piwo'**
  String get beerDetailsInsightsTitle;

  /// No description provided for @beerDetailsInsightsSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Czy to piwo Ci zasmakuje?'**
  String get beerDetailsInsightsSubtitle;

  /// No description provided for @beerDetailsStyleMatch.
  ///
  /// In pl, this message translates to:
  /// **'Prawdopodobnie polubisz ten styl'**
  String get beerDetailsStyleMatch;

  /// No description provided for @rateBeerSavedSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Ocena zapisana!'**
  String get rateBeerSavedSuccess;

  /// No description provided for @rateBeerOverallLabel.
  ///
  /// In pl, this message translates to:
  /// **'TWOJA OGÓLNA OCENA'**
  String get rateBeerOverallLabel;

  /// No description provided for @rateBeerTaste.
  ///
  /// In pl, this message translates to:
  /// **'Smak'**
  String get rateBeerTaste;

  /// No description provided for @rateBeerAroma.
  ///
  /// In pl, this message translates to:
  /// **'Aromat'**
  String get rateBeerAroma;

  /// No description provided for @rateBeerBitterness.
  ///
  /// In pl, this message translates to:
  /// **'Gorycz'**
  String get rateBeerBitterness;

  /// No description provided for @rateBeerAppearance.
  ///
  /// In pl, this message translates to:
  /// **'Wygląd'**
  String get rateBeerAppearance;

  /// No description provided for @rateBeerDrinkability.
  ///
  /// In pl, this message translates to:
  /// **'Pijalność'**
  String get rateBeerDrinkability;

  /// No description provided for @rateBeerNoteLabel.
  ///
  /// In pl, this message translates to:
  /// **'Notatka (opcjonalnie)'**
  String get rateBeerNoteLabel;

  /// No description provided for @rateBeerNotePlaceholder.
  ///
  /// In pl, this message translates to:
  /// **'Co Ci się podobało?'**
  String get rateBeerNotePlaceholder;

  /// No description provided for @rateBeerPhotoLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdjęcie'**
  String get rateBeerPhotoLabel;

  /// No description provided for @rateBeerPhotoAdd.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj zdjęcie'**
  String get rateBeerPhotoAdd;

  /// No description provided for @rateBeerSaving.
  ///
  /// In pl, this message translates to:
  /// **'Zapisywanie...'**
  String get rateBeerSaving;

  /// No description provided for @rateBeerSaveButton.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz ocenę'**
  String get rateBeerSaveButton;

  /// No description provided for @rateBeerYourRating.
  ///
  /// In pl, this message translates to:
  /// **'Twoja ocena'**
  String get rateBeerYourRating;

  /// No description provided for @rateBeerShareButton.
  ///
  /// In pl, this message translates to:
  /// **'Udostępnij ocenę'**
  String get rateBeerShareButton;

  /// No description provided for @rateBeerClose.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get rateBeerClose;

  /// No description provided for @rateBeerGallerySavedSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Zapisano w galerii!'**
  String get rateBeerGallerySavedSuccess;

  /// No description provided for @rateBeerGallerySavedError.
  ///
  /// In pl, this message translates to:
  /// **'Błąd zapisu.'**
  String get rateBeerGallerySavedError;

  /// No description provided for @beerReviewsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Recenzje'**
  String get beerReviewsTitle;

  /// No description provided for @beerReviewsRatingsCountLabel.
  ///
  /// In pl, this message translates to:
  /// **'OCEN'**
  String get beerReviewsRatingsCountLabel;

  /// No description provided for @beerReviewsWriteReviewButton.
  ///
  /// In pl, this message translates to:
  /// **'Napisz recenzję'**
  String get beerReviewsWriteReviewButton;

  /// No description provided for @beerReviewsUseCardButtonNotice.
  ///
  /// In pl, this message translates to:
  /// **'Użyj przycisku na karcie piwa aby ocenić'**
  String get beerReviewsUseCardButtonNotice;

  /// No description provided for @beerReviewsDaysAgo.
  ///
  /// In pl, this message translates to:
  /// **'{days} dni temu'**
  String beerReviewsDaysAgo(Object days);

  /// No description provided for @beerReviewsHoursAgo.
  ///
  /// In pl, this message translates to:
  /// **'{hours} godz temu'**
  String beerReviewsHoursAgo(Object hours);

  /// No description provided for @beerReviewsMinsAgo.
  ///
  /// In pl, this message translates to:
  /// **'{mins} min temu'**
  String beerReviewsMinsAgo(Object mins);

  /// No description provided for @shareCardMyRatingLabel.
  ///
  /// In pl, this message translates to:
  /// **'MOJA OCENA'**
  String get shareCardMyRatingLabel;

  /// No description provided for @shareCardMatchSuffix.
  ///
  /// In pl, this message translates to:
  /// **'% zgodności z Twoim gustem'**
  String get shareCardMatchSuffix;

  /// No description provided for @shareCardSave.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get shareCardSave;

  /// No description provided for @onboardingQ1Title.
  ///
  /// In pl, this message translates to:
  /// **'Co powiesz na goryczkę?'**
  String get onboardingQ1Title;

  /// No description provided for @onboardingQ1Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Pomyśl o czystym lagerze kontra mocnym west-coast IPA.'**
  String get onboardingQ1Subtitle;

  /// No description provided for @onboardingQ1Left.
  ///
  /// In pl, this message translates to:
  /// **'Łagodne'**
  String get onboardingQ1Left;

  /// No description provided for @onboardingQ1Right.
  ///
  /// In pl, this message translates to:
  /// **'Gorzkie'**
  String get onboardingQ1Right;

  /// No description provided for @onboardingNextQuestionButton.
  ///
  /// In pl, this message translates to:
  /// **'Następne pytanie'**
  String get onboardingNextQuestionButton;

  /// No description provided for @onboardingQ2Title.
  ///
  /// In pl, this message translates to:
  /// **'Jak lubisz swoje piwo?'**
  String get onboardingQ2Title;

  /// No description provided for @onboardingQ2Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Lekkie i orzeźwiające, czy mocne i rozgrzewające?'**
  String get onboardingQ2Subtitle;

  /// No description provided for @onboardingQ2Left.
  ///
  /// In pl, this message translates to:
  /// **'Lekkie'**
  String get onboardingQ2Left;

  /// No description provided for @onboardingQ2Right.
  ///
  /// In pl, this message translates to:
  /// **'Mocne'**
  String get onboardingQ2Right;

  /// No description provided for @onboardingQ3Title.
  ///
  /// In pl, this message translates to:
  /// **'Owocowe czy wytrawne?'**
  String get onboardingQ3Title;

  /// No description provided for @onboardingQ3Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Pomyśl o soczystym NEIPA kontra klasycznym, wytrawnym pilznerze.'**
  String get onboardingQ3Subtitle;

  /// No description provided for @onboardingQ3Left.
  ///
  /// In pl, this message translates to:
  /// **'Owocowe'**
  String get onboardingQ3Left;

  /// No description provided for @onboardingQ3Right.
  ///
  /// In pl, this message translates to:
  /// **'Wytrawne'**
  String get onboardingQ3Right;

  /// No description provided for @onboardingQ4Title.
  ///
  /// In pl, this message translates to:
  /// **'A może coś słodowego?'**
  String get onboardingQ4Title;

  /// No description provided for @onboardingQ4Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Suche i lekkie, czy słodowe i pełne?'**
  String get onboardingQ4Subtitle;

  /// No description provided for @onboardingQ4Left.
  ///
  /// In pl, this message translates to:
  /// **'Suche'**
  String get onboardingQ4Left;

  /// No description provided for @onboardingQ4Right.
  ///
  /// In pl, this message translates to:
  /// **'Słodowe'**
  String get onboardingQ4Right;

  /// No description provided for @onboardingNextButton.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get onboardingNextButton;

  /// No description provided for @onboardingQ5Title.
  ///
  /// In pl, this message translates to:
  /// **'Jakie style już znasz i lubisz?'**
  String get onboardingQ5Title;

  /// No description provided for @onboardingQ5Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz tyle, ile chcesz — to pomoże nam Cię lepiej poznać.'**
  String get onboardingQ5Subtitle;

  /// No description provided for @onboardingQ6Title.
  ///
  /// In pl, this message translates to:
  /// **'Skąd najchętniej sięgasz po piwo?'**
  String get onboardingQ6Title;

  /// No description provided for @onboardingQ6Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz swoje ulubione kraje piwne.'**
  String get onboardingQ6Subtitle;

  /// No description provided for @onboardingStep.
  ///
  /// In pl, this message translates to:
  /// **'STEP {step} OF {totalSteps}'**
  String onboardingStep(Object step, Object totalSteps);

  /// No description provided for @onboardingExpTitle.
  ///
  /// In pl, this message translates to:
  /// **'Jak dobrze znasz świat piwa?'**
  String get onboardingExpTitle;

  /// No description provided for @onboardingExpLevel1Title.
  ///
  /// In pl, this message translates to:
  /// **'Dopiero zaczynam'**
  String get onboardingExpLevel1Title;

  /// No description provided for @onboardingExpLevel1Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Odkrywam nowe smaki krok po kroku'**
  String get onboardingExpLevel1Subtitle;

  /// No description provided for @onboardingExpLevel2Title.
  ///
  /// In pl, this message translates to:
  /// **'Znam się nieźle'**
  String get onboardingExpLevel2Title;

  /// No description provided for @onboardingExpLevel2Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Mam swoje ulubione style i szukam więcej'**
  String get onboardingExpLevel2Subtitle;

  /// No description provided for @onboardingExpLevel3Title.
  ///
  /// In pl, this message translates to:
  /// **'Jestem hobbystą'**
  String get onboardingExpLevel3Title;

  /// No description provided for @onboardingExpLevel3Subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Piwo to moja pasja, chcę odkrywać rzadkości'**
  String get onboardingExpLevel3Subtitle;

  /// No description provided for @onboardingExpSeeProfileButton.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz mój profil'**
  String get onboardingExpSeeProfileButton;

  /// No description provided for @onboardingAnalyzingTitle.
  ///
  /// In pl, this message translates to:
  /// **'Analizujemy Twój gust...'**
  String get onboardingAnalyzingTitle;

  /// No description provided for @onboardingAnalyzingFact.
  ///
  /// In pl, this message translates to:
  /// **'IPA zawdzięcza swoją moc kolonialnej historii Anglii — warzono je mocniej, by przetrwały rejs do Indii.'**
  String get onboardingAnalyzingFact;

  /// No description provided for @onboardingAnalyzingWait.
  ///
  /// In pl, this message translates to:
  /// **'Chwileczkę...'**
  String get onboardingAnalyzingWait;

  /// No description provided for @onboardingFactTitle.
  ///
  /// In pl, this message translates to:
  /// **'Twój profil smakowy zaczyna nabierać kształtu'**
  String get onboardingFactTitle;

  /// No description provided for @onboardingFactBadge.
  ///
  /// In pl, this message translates to:
  /// **'CZY WIESZ, ŻE?'**
  String get onboardingFactBadge;

  /// No description provided for @onboardingFactContentFruity.
  ///
  /// In pl, this message translates to:
  /// **'Chmiel można tak dobrać, że piwo pachnie mango czy marakują, mimo że w warzelni nie ma ani grama owoców - to zasługa naturalnych związków (tioli) uwalnianych przez drożdże podczas fermentacji.'**
  String get onboardingFactContentFruity;

  /// No description provided for @onboardingFactContentDry.
  ///
  /// In pl, this message translates to:
  /// **'Klasyczne, wytrawne lagery leżakują w niskiej temperaturze nawet kilka tygodni - to właśnie ten długi, zimny spoczynek daje im tak czysty, chrupiący finisz.'**
  String get onboardingFactContentDry;

  /// No description provided for @onboardingHookTitle.
  ///
  /// In pl, this message translates to:
  /// **'Świetnie!'**
  String get onboardingHookTitle;

  /// No description provided for @onboardingHookSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Na podstawie Twoich odpowiedzi prawdopodobnie polubisz'**
  String get onboardingHookSubtitle;

  /// TEMP - mock data, replace when real backend wired up
  ///
  /// In pl, this message translates to:
  /// **'SOCZYSTE, OWOCOWE, Z NUTĄ CYTRUSÓW'**
  String get onboardingHookDescription;

  /// No description provided for @onboardingHookFooter.
  ///
  /// In pl, this message translates to:
  /// **'Twoje DNA piwne jest unikalne. Odkryliśmy Twój idealny punkt startowy.'**
  String get onboardingHookFooter;

  /// No description provided for @onboardingHookRegisterButton.
  ///
  /// In pl, this message translates to:
  /// **'Załóż konto, by zapisać profil'**
  String get onboardingHookRegisterButton;

  /// No description provided for @onboardingIntroSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Twój osobisty przewodnik po piwie'**
  String get onboardingIntroSubtitle;

  /// No description provided for @onboardingIntroFeature1Title.
  ///
  /// In pl, this message translates to:
  /// **'Inteligentne skanowanie etykiet'**
  String get onboardingIntroFeature1Title;

  /// No description provided for @onboardingIntroFeature1Desc.
  ///
  /// In pl, this message translates to:
  /// **'Błyskawicznie rozpoznawaj piwa dzięki AI.'**
  String get onboardingIntroFeature1Desc;

  /// No description provided for @onboardingIntroFeature2Title.
  ///
  /// In pl, this message translates to:
  /// **'Dopasowanie smaku'**
  String get onboardingIntroFeature2Title;

  /// No description provided for @onboardingIntroFeature2Desc.
  ///
  /// In pl, this message translates to:
  /// **'Znajdź piwa idealnie dopasowane do Twojego profilu.'**
  String get onboardingIntroFeature2Desc;

  /// No description provided for @onboardingIntroStartButton.
  ///
  /// In pl, this message translates to:
  /// **'Odkryj swój gust'**
  String get onboardingIntroStartButton;

  /// No description provided for @onboardingIntroLoginButton.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get onboardingIntroLoginButton;

  /// No description provided for @paywallTitle.
  ///
  /// In pl, this message translates to:
  /// **'BrewDNA Premium'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Odblokuj pełny potencjał swojego profilu piwnego'**
  String get paywallSubtitle;

  /// No description provided for @paywallFeature1Title.
  ///
  /// In pl, this message translates to:
  /// **'AI bez limitu'**
  String get paywallFeature1Title;

  /// No description provided for @paywallFeature1Desc.
  ///
  /// In pl, this message translates to:
  /// **'Nielimitowane skany i BeerDNA'**
  String get paywallFeature1Desc;

  /// No description provided for @paywallFeature2Title.
  ///
  /// In pl, this message translates to:
  /// **'Zaawansowane statystyki'**
  String get paywallFeature2Title;

  /// No description provided for @paywallFeature2Desc.
  ///
  /// In pl, this message translates to:
  /// **'Odkryj ukryte wzorce w swoich ocenach'**
  String get paywallFeature2Desc;

  /// No description provided for @paywallFeature3Title.
  ///
  /// In pl, this message translates to:
  /// **'Eksport kolekcji'**
  String get paywallFeature3Title;

  /// No description provided for @paywallFeature3Desc.
  ///
  /// In pl, this message translates to:
  /// **'Pobierz swoje dane do CSV lub PDF'**
  String get paywallFeature3Desc;

  /// No description provided for @paywallFeature4Title.
  ///
  /// In pl, this message translates to:
  /// **'Backup w chmurze'**
  String get paywallFeature4Title;

  /// No description provided for @paywallFeature4Desc.
  ///
  /// In pl, this message translates to:
  /// **'Nigdy nie trać swojej kolekcji'**
  String get paywallFeature4Desc;

  /// No description provided for @paywallFeature5Title.
  ///
  /// In pl, this message translates to:
  /// **'Ekskluzywne odznaki'**
  String get paywallFeature5Title;

  /// No description provided for @paywallFeature5Desc.
  ///
  /// In pl, this message translates to:
  /// **'Zdobądź profil premium na platformie'**
  String get paywallFeature5Desc;

  /// No description provided for @paywallPlanMonthly.
  ///
  /// In pl, this message translates to:
  /// **'Miesięcznie'**
  String get paywallPlanMonthly;

  /// No description provided for @paywallPlanMonthlyDesc.
  ///
  /// In pl, this message translates to:
  /// **'Rozliczenie co miesiąc'**
  String get paywallPlanMonthlyDesc;

  /// No description provided for @paywallPlanYearly.
  ///
  /// In pl, this message translates to:
  /// **'Rocznie'**
  String get paywallPlanYearly;

  /// No description provided for @paywallPlanYearlyDesc.
  ///
  /// In pl, this message translates to:
  /// **'3 dni za darmo, potem 149,99 zł/rok'**
  String get paywallPlanYearlyDesc;

  /// No description provided for @paywallPlanYearlyBadge.
  ///
  /// In pl, this message translates to:
  /// **'Oszczędzasz 16%'**
  String get paywallPlanYearlyBadge;

  /// No description provided for @paywallBuyButton.
  ///
  /// In pl, this message translates to:
  /// **'Kup'**
  String get paywallBuyButton;

  /// No description provided for @paywallDisclaimer.
  ///
  /// In pl, this message translates to:
  /// **'Płatność pobierana przy zakupie. Subskrypcja odnawia się automatycznie, chyba że zostanie anulowana 24h przed końcem bieżącego okresu. Możesz zarządzać subskrypcjami w Ustawieniach Konta.'**
  String get paywallDisclaimer;

  /// No description provided for @devWidgetGalleryCardDesc.
  ///
  /// In pl, this message translates to:
  /// **'Przykładowy opis karty.'**
  String get devWidgetGalleryCardDesc;

  /// No description provided for @scanResultManualSearchDesc.
  ///
  /// In pl, this message translates to:
  /// **'Otwieram ręczne wyszukiwanie...'**
  String get scanResultManualSearchDesc;

  /// No description provided for @scanningAnalyzingTryAgain.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get scanningAnalyzingTryAgain;

  /// No description provided for @discoverTopCountries.
  ///
  /// In pl, this message translates to:
  /// **'Odkryj smaki z różnych krajów'**
  String get discoverTopCountries;

  /// No description provided for @discoverTopRated.
  ///
  /// In pl, this message translates to:
  /// **'Najlepiej oceniane'**
  String get discoverTopRated;

  /// No description provided for @discoverMatchedDna.
  ///
  /// In pl, this message translates to:
  /// **'Dopasowane do Twojego DNA smakowego'**
  String get discoverMatchedDna;

  /// No description provided for @beersCount.
  ///
  /// In pl, this message translates to:
  /// **'{count} piw'**
  String beersCount(int count);

  /// No description provided for @tasteProfileBalanced.
  ///
  /// In pl, this message translates to:
  /// **'Zbalansowane'**
  String get tasteProfileBalanced;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
