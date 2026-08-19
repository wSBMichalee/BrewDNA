// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tabHistory => 'My Beers';

  @override
  String get tabMap => 'Map';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabProfile => 'Profile';

  @override
  String get tabScan => 'Scan';

  @override
  String get authStartTitle => 'Start building your collection';

  @override
  String get authStartApple => 'Continue with Apple';

  @override
  String get authStartGoogle => 'Continue with Google';

  @override
  String get authStartOr => 'or';

  @override
  String get authStartEmail => 'Continue with Email';

  @override
  String get authStartAlreadyHaveAccount => 'Already have an account? ';

  @override
  String get authStartLogin => 'Log in';

  @override
  String get authStartComingSoonTitle => 'Coming Soon';

  @override
  String get authStartComingSoonContent =>
      'This login method will be available in future updates.';

  @override
  String get authStartComingSoonOk => 'OK';

  @override
  String welcomeTitle(Object name) {
    return 'Welcome to BrewDNA, $name!';
  }

  @override
  String get welcomeSubtitle =>
      'Scan your first beer to start building your collection.';

  @override
  String get welcomeScanButton => 'Scan your first beer';

  @override
  String get welcomeMaybeLater => 'Maybe later';

  @override
  String get emailTitle => 'What\'s your email?';

  @override
  String get emailSubtitle =>
      'We\'ll use it for login and important notifications.';

  @override
  String get emailHint => 'address@email.com';

  @override
  String get emailNext => 'Next';

  @override
  String get passwordTitleLogin => 'Enter your password';

  @override
  String get passwordTitleRegister => 'Create a password';

  @override
  String get passwordSubtitle => 'Minimum 8 characters.';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get passwordNext => 'Next';

  @override
  String get detailsTitle => 'Last step';

  @override
  String get detailsHint => 'First name';

  @override
  String get detailsCountryPoland => 'Poland';

  @override
  String get detailsCountryGermany => 'Germany';

  @override
  String get detailsCountryCzech => 'Czech Republic';

  @override
  String get detailsCountryUK => 'United Kingdom';

  @override
  String get detailsCountryUSA => 'USA';

  @override
  String get detailsCountryPlaceholder => 'Country';

  @override
  String get detailsTermsAccept => 'I accept the ';

  @override
  String get detailsTermsLink => 'Terms of Service';

  @override
  String get detailsTermsAnd => ' and ';

  @override
  String get detailsPrivacyLink => 'Privacy Policy';

  @override
  String get detailsRegistering => 'Registering...';

  @override
  String get detailsContinue => 'Continue';

  @override
  String get detailsErrorGeneric =>
      'An error occurred during registration. Please try again.';

  @override
  String get detailsErrorTitle => 'Error';

  @override
  String get historyTabRatings => 'Ratings';

  @override
  String get historyTabWishlist => 'Wishlist';

  @override
  String get historyTabCellar => 'Cellar';

  @override
  String get historyTabHistory => 'History';

  @override
  String get historyEmptyState => 'No beers in your history yet.';

  @override
  String get scanInstruction => 'Position the BEER LABEL within the frame';

  @override
  String get mapTitle => 'World Map';

  @override
  String mapCountriesDiscovered(int count) {
    return '$count of 195 countries discovered';
  }

  @override
  String mapPercentDiscovered(int percent) {
    return '$percent% DISCOVERED';
  }

  @override
  String get mapRecentlyDiscovered => 'Recently discovered';

  @override
  String get mapEmptyState => 'No beers discovered yet.';

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
  String get discoverGreetingHello => 'Hello, ';

  @override
  String get discoverGreetingDefaultName => 'Taster';

  @override
  String get discoverSubtitle => 'Here are some beers you might enjoy';

  @override
  String get discoverBeerOfTheDayLabel => 'BEER OF THE DAY';

  @override
  String get discoverRecommendedTitle => 'Recommended for you';

  @override
  String get discoverSeeAll => 'See all';

  @override
  String get profileDnaAnalyzing => 'Analyzing your taste DNA...';

  @override
  String get profileDnaReady => 'Your taste DNA is ready. Tap to discover it.';

  @override
  String get profileDnaMoreBeers =>
      'You\'re on the right track. Try more beers to generate your profile.';

  @override
  String get profileDnaError => 'Error fetching taste DNA.';

  @override
  String get profileDummyName => 'Michał';

  @override
  String get profileDummyStats => '68 beers · 31 breweries · 12 countries';

  @override
  String get profileAchievementsTitle => 'Achievements';

  @override
  String get profileAchievement1Title => 'Explorer';

  @override
  String get profileAchievement1Subtitle => '19 styles';

  @override
  String get profileAchievement2Title => 'Top 10';

  @override
  String get profileAchievement2Subtitle => 'in Poland';

  @override
  String get profileAchievement3Title => 'Connoisseur';

  @override
  String get profileAchievement3Subtitle => '100+ ratings';

  @override
  String get profileTasteProfileTitle => 'Taste profile';

  @override
  String get profileTasteTabStyles => 'Styles';

  @override
  String get profileTasteTabCountries => 'Countries';

  @override
  String get profileTasteProgressText => 'Tried 19 of 42 styles';

  @override
  String get profileTasteProgressPercent => '45%';

  @override
  String get profileTasteFavStyle => 'West Coast IPA';

  @override
  String get profileTasteFavStyleLabel => 'Favorite style';

  @override
  String get profileBrewDnaTitle => 'Your BrewDNA';

  @override
  String get beerDetailsEmpty => 'No beer data available';

  @override
  String get beerDetailsTopStyle => 'TOP 2% IN STYLE';

  @override
  String get beerDetailsTopCountry => 'TOP 1% IN POLAND';

  @override
  String beerDetailsStyleCountry(Object style, Object country) {
    return '🍺 $style from $country';
  }

  @override
  String get beerDetailsRate => 'Rate';

  @override
  String get beerDetailsMoreOptions => 'More options...';

  @override
  String beerDetailsRated(Object rating) {
    return 'You rated: $rating';
  }

  @override
  String get beerDetailsInsightsTitle => 'Beer insights';

  @override
  String get beerDetailsInsightsSubtitle => 'Will you enjoy this beer?';

  @override
  String get beerDetailsStyleMatch => 'You will likely enjoy this style';

  @override
  String get rateBeerSavedSuccess => 'Rating saved!';

  @override
  String get rateBeerOverallLabel => 'YOUR OVERALL RATING';

  @override
  String get rateBeerTaste => 'Taste';

  @override
  String get rateBeerAroma => 'Aroma';

  @override
  String get rateBeerBitterness => 'Bitterness';

  @override
  String get rateBeerAppearance => 'Appearance';

  @override
  String get rateBeerDrinkability => 'Drinkability';

  @override
  String get rateBeerNoteLabel => 'Note (optional)';

  @override
  String get rateBeerNotePlaceholder => 'What did you like about it?';

  @override
  String get rateBeerPhotoLabel => 'Photo';

  @override
  String get rateBeerPhotoAdd => 'Add photo';

  @override
  String get rateBeerSaving => 'Saving...';

  @override
  String get rateBeerSaveButton => 'Save rating';

  @override
  String get rateBeerYourRating => 'Your rating';

  @override
  String get rateBeerShareButton => 'Share rating';

  @override
  String get rateBeerClose => 'Close';

  @override
  String get rateBeerGallerySavedSuccess => 'Saved to gallery!';

  @override
  String get rateBeerGallerySavedError => 'Error saving to gallery.';

  @override
  String get beerReviewsTitle => 'Reviews';

  @override
  String get beerReviewsRatingsCountLabel => 'RATINGS';

  @override
  String get beerReviewsWriteReviewButton => 'Write a review';

  @override
  String get beerReviewsUseCardButtonNotice =>
      'Use the button on the beer card to rate';

  @override
  String beerReviewsDaysAgo(Object days) {
    return '$days days ago';
  }

  @override
  String beerReviewsHoursAgo(Object hours) {
    return '$hours hrs ago';
  }

  @override
  String beerReviewsMinsAgo(Object mins) {
    return '$mins mins ago';
  }

  @override
  String get shareCardMyRatingLabel => 'MY RATING';

  @override
  String get shareCardMatchSuffix => '% match with your taste';

  @override
  String get shareCardSave => 'Save';

  @override
  String get onboardingQ1Title => 'How about bitterness?';

  @override
  String get onboardingQ1Subtitle =>
      'Think clean lager versus strong west-coast IPA.';

  @override
  String get onboardingQ1Left => 'Mild';

  @override
  String get onboardingQ1Right => 'Bitter';

  @override
  String get onboardingNextQuestionButton => 'Next question';

  @override
  String get onboardingQ2Title => 'How do you like your beer?';

  @override
  String get onboardingQ2Subtitle =>
      'Light and refreshing, or strong and warming?';

  @override
  String get onboardingQ2Left => 'Light';

  @override
  String get onboardingQ2Right => 'Strong';

  @override
  String get onboardingQ3Title => 'Fruity or dry?';

  @override
  String get onboardingQ3Subtitle =>
      'Think juicy NEIPA versus classic, dry pilsner.';

  @override
  String get onboardingQ3Left => 'Fruity';

  @override
  String get onboardingQ3Right => 'Dry';

  @override
  String get onboardingQ4Title => 'Or maybe something malty?';

  @override
  String get onboardingQ4Subtitle => 'Dry and light, or malty and full?';

  @override
  String get onboardingQ4Left => 'Dry';

  @override
  String get onboardingQ4Right => 'Malty';

  @override
  String get onboardingNextButton => 'Next';

  @override
  String get onboardingQ5Title => 'What styles do you already know and enjoy?';

  @override
  String get onboardingQ5Subtitle =>
      'Select as many as you like — this helps us get to know you better.';

  @override
  String get onboardingQ6Title => 'Where do you prefer your beers from?';

  @override
  String get onboardingQ6Subtitle => 'Select your favorite beer countries.';

  @override
  String onboardingStep(Object step, Object totalSteps) {
    return 'STEP $step OF $totalSteps';
  }

  @override
  String get onboardingExpTitle => 'How well do you know the world of beer?';

  @override
  String get onboardingExpLevel1Title => 'Just starting out';

  @override
  String get onboardingExpLevel1Subtitle =>
      'Discovering new tastes step by step';

  @override
  String get onboardingExpLevel2Title => 'I know a fair bit';

  @override
  String get onboardingExpLevel2Subtitle =>
      'I have my favorite styles and am looking for more';

  @override
  String get onboardingExpLevel3Title => 'I\'m a hobbyist';

  @override
  String get onboardingExpLevel3Subtitle =>
      'Beer is my passion, I want to discover rarities';

  @override
  String get onboardingExpSeeProfileButton => 'See my profile';

  @override
  String get onboardingAnalyzingTitle => 'Analyzing your taste...';

  @override
  String get onboardingAnalyzingFact =>
      'IPA owes its strength to England\'s colonial history — it was brewed stronger to survive the voyage to India.';

  @override
  String get onboardingAnalyzingWait => 'Just a moment...';

  @override
  String get onboardingFactTitle => 'Your taste profile is taking shape';

  @override
  String get onboardingFactBadge => 'DID YOU KNOW?';

  @override
  String get onboardingFactContentFruity =>
      'Hops can be selected so that the beer smells like mango or passion fruit, even though there isn\'t a single gram of fruit in the brewery - this is due to natural compounds (thiols) released by yeast during fermentation.';

  @override
  String get onboardingFactContentDry =>
      'Classic, dry lagers are aged at low temperatures for up to several weeks - it\'s this long, cold rest that gives them such a clean, crisp finish.';

  @override
  String get onboardingHookTitle => 'Great!';

  @override
  String get onboardingHookSubtitle =>
      'Based on your answers, you\'ll probably like';

  @override
  String get onboardingHookDescription => 'SOCZYSTE, OWOCOWE, Z NUTĄ CYTRUSÓW';

  @override
  String get onboardingHookFooter =>
      'Your beer DNA is unique. We\'ve found your perfect starting point.';

  @override
  String get onboardingHookRegisterButton =>
      'Create an account to save your profile';

  @override
  String get onboardingIntroSubtitle => 'Your personal beer guide';

  @override
  String get onboardingIntroFeature1Title => 'Smart label scanning';

  @override
  String get onboardingIntroFeature1Desc =>
      'Instantly recognize beers thanks to AI.';

  @override
  String get onboardingIntroFeature2Title => 'Taste matching';

  @override
  String get onboardingIntroFeature2Desc =>
      'Find beers perfectly matched to your profile.';

  @override
  String get onboardingIntroStartButton => 'Discover your taste';

  @override
  String get onboardingIntroLoginButton => 'Log in';

  @override
  String get paywallTitle => 'BrewDNA Premium';

  @override
  String get paywallSubtitle =>
      'Unlock the full potential of your beer profile';

  @override
  String get paywallFeature1Title => 'Unlimited AI';

  @override
  String get paywallFeature1Desc => 'Unlimited scans and BeerDNA';

  @override
  String get paywallFeature2Title => 'Advanced statistics';

  @override
  String get paywallFeature2Desc => 'Discover hidden patterns in your ratings';

  @override
  String get paywallFeature3Title => 'Collection export';

  @override
  String get paywallFeature3Desc => 'Download your data to CSV or PDF';

  @override
  String get paywallFeature4Title => 'Cloud backup';

  @override
  String get paywallFeature4Desc => 'Never lose your collection';

  @override
  String get paywallFeature5Title => 'Exclusive badges';

  @override
  String get paywallFeature5Desc => 'Get a premium profile on the platform';

  @override
  String get paywallPlanMonthly => 'Monthly';

  @override
  String get paywallPlanMonthlyDesc => 'Billed every month';

  @override
  String get paywallPlanYearly => 'Yearly';

  @override
  String get paywallPlanYearlyDesc => '3 days free, then 149.99 PLN/year';

  @override
  String get paywallPlanYearlyBadge => 'Save 16%';

  @override
  String get paywallBuyButton => 'Buy';

  @override
  String get paywallDisclaimer =>
      'Payment charged at purchase. Subscription automatically renews unless canceled 24h before the end of the current period. You can manage subscriptions in Account Settings.';

  @override
  String get devWidgetGalleryCardDesc => 'Sample card description.';

  @override
  String get scanResultManualSearchDesc => 'Opening manual search...';

  @override
  String get scanningAnalyzingTryAgain => 'Try again';

  @override
  String get discoverTopCountries =>
      'Discover flavors from different countries';

  @override
  String get discoverTopRated => 'Top Rated';

  @override
  String get discoverMatchedDna => 'Matched to Your Taste DNA';

  @override
  String beersCount(int count) {
    return '$count beers';
  }
}
