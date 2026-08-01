import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentStep,
    @Default(50.0) double lightStrongValue,
    @Default(50.0) double bitterSweetValue,
    @Default(50.0) double dryFruityValue,
    @Default({}) Set<String> selectedStyles,
    @Default({}) Set<String> selectedCountries,
    String? experienceLevel,
    @Default([]) List<String> availableStyles,
    @Default(false) bool isStylesLoading,
  }) = _OnboardingState;
}
