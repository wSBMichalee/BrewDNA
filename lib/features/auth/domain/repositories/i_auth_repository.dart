import 'package:supabase_flutter/supabase_flutter.dart' show Session, AuthState;

abstract class IAuthRepository {
  Future<void> signInWithApple();
  Future<void> signInWithGoogle();
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password, String name, Map<String, dynamic> tasteProfileData);
  Future<void> signOut();
  
  Session? getCurrentSession();
  Stream<AuthState> authStateChanges();
}
