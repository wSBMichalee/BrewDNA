import 'package:freezed_annotation/freezed_annotation.dart';

part 'beer.freezed.dart';
part 'beer.g.dart';

@freezed
abstract class Beer with _$Beer {
  const factory Beer({
    required String id,
    required String name,
    required String brewery,
    required String country,
    required String style,
    required double abv,
    required double rating,
    required double lightStrong,
    required double bitterSweet,
    required double dryFruity,
    required String imageUrl,
  }) = _Beer;

  factory Beer.fromJson(Map<String, dynamic> json) => _$BeerFromJson(json);
}
