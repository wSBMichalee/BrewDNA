import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/taste_profile.dart';
import '../../domain/repositories/i_taste_profile_repository.dart';

@LazySingleton(as: ITasteProfileRepository)
class SupabaseTasteProfileRepository implements ITasteProfileRepository {
  final SupabaseClient _supabaseClient;

  SupabaseTasteProfileRepository(this._supabaseClient);

  @override
  Future<Either<String, TasteProfile?>> getTasteProfile() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return left('Brak zalogowanego użytkownika');
      }

      final response = await _supabaseClient
          .from('taste_profiles')
          .select('calculated_strength, calculated_bitterness, calculated_fruitiness, declared_strength, declared_bitterness, declared_fruitiness, rating_count')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        return right(null);
      }

      // Jeśli rating_count jest 0, to calculated_* zawierają jedynie bazodanowe zera z DEFAULT 0
      // Ignorujemy je, żeby model nie przeliczył 0 jako realnej oceny
      final data = Map<String, dynamic>.from(response);
      if (data['rating_count'] == 0) {
        data['calculated_strength'] = null;
        data['calculated_bitterness'] = null;
        data['calculated_fruitiness'] = null;
      }

      return right(TasteProfile.fromJson(data));
    } catch (e) {
      return left('Błąd pobierania profilu smaku: $e');
    }
  }

  @override
  Future<Either<String, void>> updateDeclaredPreferences({
    required double declaredStrength,
    required double declaredBitterness,
    required double declaredFruitiness,
  }) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return left('Brak zalogowanego użytkownika');
      }

      await _supabaseClient.from('taste_profiles').upsert({
        'user_id': user.id,
        'declared_strength': declaredStrength,
        'declared_bitterness': declaredBitterness,
        'declared_fruitiness': declaredFruitiness,
      }, onConflict: 'user_id');

      return right(null);
    } catch (e) {
      return left('Błąd aktualizacji preferencji: $e');
    }
  }
}
