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

  /// Zwraca wyliczony wskaźnik mocy (na podstawie historii ocen).
  /// Jeśli brakuje danych z ocen (np. konto bez recenzji), zwraca 50 (neutralny środek).
  double get effectiveStrength => (calculatedStrength ?? 50.0).toDouble();

  double get effectiveBitterness => (calculatedBitterness ?? 50.0).toDouble();

  double get effectiveFruitiness => (calculatedFruitiness ?? 50.0).toDouble();
}
