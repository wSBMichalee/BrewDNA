import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

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
