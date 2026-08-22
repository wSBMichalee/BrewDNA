import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/i_auth_repository.dart';

@LazySingleton(as: IAuthRepository)
class SupabaseAuthRepository implements IAuthRepository {
  final GoTrueClient _authClient = Supabase.instance.client.auth;

  @override
  Future<void> signInWithApple() async {
    await _authClient.signInWithOAuth(OAuthProvider.apple, redirectTo: 'io.supabase.brewdna://login-callback/');
  }

  @override
  Future<void> signInWithGoogle() async {
    await _authClient.signInWithOAuth(OAuthProvider.google, redirectTo: 'io.supabase.brewdna://login-callback/');
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    await _authClient.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signUpWithEmail(String email, String password, String name, Map<String, dynamic> tasteProfileData) async {
    await _authClient.signUp(
      email: email, 
      password: password,
      data: {
        'display_name': name,
        'taste_profile': tasteProfileData,
      },
    );
  }

  @override
  Future<void> signOut() async {
    await _authClient.signOut();
  }

  @override
  Session? getCurrentSession() {
    return _authClient.currentSession;
  }

  @override
  Stream<AuthState> authStateChanges() {
    return _authClient.onAuthStateChange;
  }
}
