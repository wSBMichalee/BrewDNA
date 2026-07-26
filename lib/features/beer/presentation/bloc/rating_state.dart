import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/rating_histogram.dart';

part 'rating_state.freezed.dart';

@freezed
class RatingState with _$RatingState {
  const factory RatingState.initial() = _Initial;
  const factory RatingState.loading() = _Loading;
  const factory RatingState.loaded({
    required RatingHistogram histogram,
    required List<Review> reviews,
    int? userRating,
  }) = _Loaded;
  const factory RatingState.submitting() = _Submitting;
  const factory RatingState.submitted() = _Submitted;
  const factory RatingState.error(String message) = _Error;
}
