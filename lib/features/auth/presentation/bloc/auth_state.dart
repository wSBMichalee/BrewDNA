import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String name,
    @Default('Polska') String country,
    @Default(false) bool acceptedTerms,
    @Default(false) bool isReturningUser,
  }) = _AuthState;
}
