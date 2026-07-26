import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_histogram.freezed.dart';
part 'rating_histogram.g.dart';

@freezed
abstract class RatingHistogram with _$RatingHistogram {
  const factory RatingHistogram({
    required int count5,
    required int count4,
    required int count3,
    required int count2,
    required int count1,
    required int totalCount,
    required double averageRating,
  }) = _RatingHistogram;

  factory RatingHistogram.fromJson(Map<String, dynamic> json) => _$RatingHistogramFromJson(json);
}
