// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taste_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TasteProfile _$TasteProfileFromJson(Map<String, dynamic> json) =>
    _TasteProfile(
      calculatedStrength: json['calculated_strength'] as num?,
      calculatedBitterness: json['calculated_bitterness'] as num?,
      calculatedFruitiness: json['calculated_fruitiness'] as num?,
      declaredStrength: json['declared_strength'] as num?,
      declaredBitterness: json['declared_bitterness'] as num?,
      declaredFruitiness: json['declared_fruitiness'] as num?,
    );

Map<String, dynamic> _$TasteProfileToJson(_TasteProfile instance) =>
    <String, dynamic>{
      'calculated_strength': instance.calculatedStrength,
      'calculated_bitterness': instance.calculatedBitterness,
      'calculated_fruitiness': instance.calculatedFruitiness,
      'declared_strength': instance.declaredStrength,
      'declared_bitterness': instance.declaredBitterness,
      'declared_fruitiness': instance.declaredFruitiness,
    };
