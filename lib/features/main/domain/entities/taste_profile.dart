import 'package:freezed_annotation/freezed_annotation.dart';

part 'taste_profile.freezed.dart';
part 'taste_profile.g.dart';

@freezed
abstract class TasteProfile with _$TasteProfile {
  const factory TasteProfile({
    @JsonKey(name: 'calculated_strength') num? calculatedStrength,
    @JsonKey(name: 'calculated_bitterness') num? calculatedBitterness,
    @JsonKey(name: 'calculated_fruitiness') num? calculatedFruitiness,
    @JsonKey(name: 'declared_strength') num? declaredStrength,
    @JsonKey(name: 'declared_bitterness') num? declaredBitterness,
    @JsonKey(name: 'declared_fruitiness') num? declaredFruitiness,
  }) = _TasteProfile;

  const TasteProfile._();

  factory TasteProfile.fromJson(Map<String, dynamic> json) =>
      _$TasteProfileFromJson(json);

  /// Zwraca efektywny wskaźnik mocy (70% calculated, 30% declared).
  /// Jeśli brakuje jednego z nich, używa drugiego w 100%.
  /// Jeśli brakuje obu, zwraca 50 (neutralny środek).
  double get effectiveStrength => _calculateEffective(calculatedStrength, declaredStrength);

  double get effectiveBitterness => _calculateEffective(calculatedBitterness, declaredBitterness);

  double get effectiveFruitiness => _calculateEffective(calculatedFruitiness, declaredFruitiness);

  double _calculateEffective(num? calc, num? decl) {
    if (calc != null && decl != null) {
      return (calc * 0.7) + (decl * 0.3);
    }
    if (calc != null) return calc.toDouble();
    if (decl != null) return decl.toDouble();
    return 50.0;
  }
}
