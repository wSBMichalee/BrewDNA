import 'package:fpdart/fpdart.dart';
import '../entities/taste_profile.dart';

abstract class ITasteProfileRepository {
  /// Pobiera profil smaku dla zalogowanego użytkownika
  Future<Either<String, TasteProfile?>> getTasteProfile();

  /// Aktualizuje zadeklarowane wartości profilu smaku
  Future<Either<String, void>> updateDeclaredPreferences({
    required double declaredStrength,
    required double declaredBitterness,
    required double declaredFruitiness,
  });
}
