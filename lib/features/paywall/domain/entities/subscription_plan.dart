/// Reprezentuje aktualny stan planu subskrypcji użytkownika.
// TODO: replace with real subscription status once payment integration exists.
enum SubscriptionPlan {
  free,
  premium,
  premiumTrial,
}

// TODO: replace with real subscription status once payment integration exists.
const currentSubscription = SubscriptionPlan.free;

class SubscriptionPrices {
  static const String monthly = '19,99 zł';
  static const String yearly = '199,99 zł';
}
