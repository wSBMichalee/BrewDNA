// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Beer _$BeerFromJson(Map<String, dynamic> json) => _Beer(
  id: json['id'] as String,
  name: json['name'] as String,
  brewery: json['brewery'] as String,
  country: json['country'] as String,
  style: json['style'] as String,
  abv: (json['abv'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  lightStrong: (json['lightStrong'] as num).toDouble(),
  bitterSweet: (json['bitterSweet'] as num).toDouble(),
  dryFruity: (json['dryFruity'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$BeerToJson(_Beer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'brewery': instance.brewery,
  'country': instance.country,
  'style': instance.style,
  'abv': instance.abv,
  'rating': instance.rating,
  'lightStrong': instance.lightStrong,
  'bitterSweet': instance.bitterSweet,
  'dryFruity': instance.dryFruity,
  'imageUrl': instance.imageUrl,
};
