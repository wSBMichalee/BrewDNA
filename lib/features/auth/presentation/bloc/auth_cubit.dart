import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

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
}
