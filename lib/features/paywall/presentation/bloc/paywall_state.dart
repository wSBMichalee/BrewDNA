enum PaywallPlan {
  premiumYearly,
  premiumTrial,
  free
}

class PaywallState {
  final PaywallPlan selectedPlan;
  final bool isLoading;
  final String? error;

  const PaywallState({
    this.selectedPlan = PaywallPlan.premiumTrial,
    this.isLoading = false,
    this.error,
  });

  PaywallState copyWith({
    PaywallPlan? selectedPlan,
    bool? isLoading,
    String? error,
  }) {
    return PaywallState(
      selectedPlan: selectedPlan ?? this.selectedPlan,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
