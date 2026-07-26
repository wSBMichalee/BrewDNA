import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    required String userName,
    required String userAvatarUrl,
    required int overallRating,
    required String note,
    required DateTime createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
