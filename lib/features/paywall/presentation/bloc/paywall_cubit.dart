import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'paywall_state.dart';

@injectable
class PaywallCubit extends Cubit<PaywallState> {
  PaywallCubit({PaywallPlan initialPlan = PaywallPlan.premiumTrial})
      : super(PaywallState(selectedPlan: initialPlan));

  void selectPlan(PaywallPlan plan) {
    emit(state.copyWith(selectedPlan: plan));
  }

  Future<void> confirmPlan() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      if (state.selectedPlan == PaywallPlan.free) {
        // Proceed without payment
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(isLoading: false));
        return;
      }

      // TODO: Actual RevenueCat integration goes here.
      // For now, this is a simulated purchase for Premium / Trial.
      debugPrint('SIMULATED PURCHASE for plan: ${state.selectedPlan}');
      await Future.delayed(const Duration(seconds: 1)); // Simulate network call

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Wystąpił błąd podczas zakupu: $e'));
    }
  }

  /// Sprawdza czy modal re-engagementu (oferta po wybraniu planu Free) był już pokazany.
  /// Zwraca true jeśli modal POWINIEN zostać pokazany (i oznacza go jako pokazany).
  /// Zwraca false jeśli był już wcześniej pokazany.
  Future<bool> checkAndMarkReengagementModalShown() async {
    final prefs = await SharedPreferences.getInstance();
    final shownAt = prefs.getString('trial_offer_shown_at');
    
    if (shownAt == null) {
      await prefs.setString('trial_offer_shown_at', DateTime.now().toIso8601String());
      return true;
    }
    
    return false;
  }
}
