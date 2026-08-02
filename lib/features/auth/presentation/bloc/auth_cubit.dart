import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'auth_state.dart';
import '../../domain/repositories/i_auth_repository.dart';
import 'dart:async';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;
  StreamSubscription? _authStateSubscription;

  AuthCubit(this._authRepository) : super(const AuthState()) {
    _authStateSubscription = _authRepository.authStateChanges().listen((event) {
      if (event.session != null) {
        emit(state.copyWith(isAuthenticated: true));
      } else {
        emit(state.copyWith(isAuthenticated: false));
      }
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password));
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateCountry(String country) {
    emit(state.copyWith(country: country));
  }

  void toggleTerms(bool value) {
    emit(state.copyWith(acceptedTerms: value));
  }

  void checkEmailExists(String email) {
    // TODO: Add real logic for checkEmailExists if necessary
    final isReturning = email.contains('powrot');
    emit(state.copyWith(isReturningUser: isReturning));
  }

  Future<void> signUpWithEmail(Map<String, dynamic> tasteProfileData) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.signUpWithEmail(
        state.email,
        state.password,
        state.name,
        tasteProfileData,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      debugPrint('Email sign up error: $e');
      rethrow; // Rethrow to let the UI catch Exception if needed, or just handle it here.
    }
  }

  Future<void> signInWithEmail() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.signInWithEmail(
        state.email,
        state.password,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      debugPrint('Email sign in error: $e');
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.signInWithApple();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      debugPrint('Apple sign in error: $e');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      debugPrint('Google sign in error: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  Future<void> checkSession() async {
    // Await a microtask to ensure state emission is processed if we use streams
    await Future.microtask(() {});
    final session = _authRepository.getCurrentSession();
    emit(state.copyWith(isAuthenticated: session != null));
  }
}
