/// Reprezentuje aktualny stan planu subskrypcji użytkownika.
// TODO: replace with real subscription status once payment integration exists.
enum SubscriptionPlan {
  free,
  premium,
  premiumTrial,
}

// TODO: replace with real subscription status once payment integration exists.
const currentSubscription = SubscriptionPlan.free;
