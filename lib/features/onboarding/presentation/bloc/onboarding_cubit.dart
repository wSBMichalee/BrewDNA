import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'onboarding_state.dart';

@lazySingleton
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void setStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void updateLightStrong(double value) {
    emit(state.copyWith(lightStrongValue: value));
  }

  void updateBitterSweet(double value) {
    emit(state.copyWith(bitterSweetValue: value));
  }

  void updateDryFruity(double value) {
    emit(state.copyWith(dryFruityValue: value));
  }

  void updateCrispMalty(double value) {
    emit(state.copyWith(crispMaltyValue: value));
  }

  void toggleStyle(String style) {
    final styles = Set<String>.from(state.selectedStyles);
    if (styles.contains(style)) {
      styles.remove(style);
    } else {
      styles.add(style);
    }
    emit(state.copyWith(selectedStyles: styles));
  }

  void toggleCountry(String country) {
    final countries = Set<String>.from(state.selectedCountries);
    if (countries.contains(country)) {
      countries.remove(country);
    } else {
      countries.add(country);
    }
    emit(state.copyWith(selectedCountries: countries));
  }

  void setExperienceLevel(String level) {
    emit(state.copyWith(experienceLevel: level));
  }

  String getRecommendedStyle() {
    final s = state;
    if (s.bitterSweetValue > 70 && s.lightStrongValue > 50) {
      return 'India Pale Ale (IPA)';
    } else if (s.crispMaltyValue > 70 && s.lightStrongValue > 60) {
      return 'Stout / Porter';
    } else if (s.dryFruityValue < 40 && s.lightStrongValue < 60) {
      return 'Wheat Beer / Hazy IPA';
    } else if (s.crispMaltyValue < 40 && s.lightStrongValue < 50) {
      return 'Pilsner / Lager';
    } else {
      return 'Pale Ale';
    }
  }
}
