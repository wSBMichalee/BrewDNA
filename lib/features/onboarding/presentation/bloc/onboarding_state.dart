import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(0) int currentStep,
    @Default(50.0) double lightStrongValue,
    @Default(50.0) double bitterSweetValue,
    @Default(50.0) double dryFruityValue,
    @Default(50.0) double crispMaltyValue,
    @Default({}) Set<String> selectedStyles,
    @Default({}) Set<String> selectedCountries,
    String? experienceLevel,
  }) = _OnboardingState;
}
