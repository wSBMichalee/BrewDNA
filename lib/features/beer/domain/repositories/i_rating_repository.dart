import 'package:fpdart/fpdart.dart';
import '../entities/review.dart';
import '../entities/rating_histogram.dart';

abstract class IRatingRepository {
  Future<Either<String, RatingHistogram>> getRatingHistogram(String beerId);
  Future<Either<String, List<Review>>> getReviews(
    String beerId, {
    int limit = 20,
  });
  Future<Either<String, void>> submitRating({
    required String beerId,
    required int overall,
    required int taste,
    required int aroma,
    required int bitterness,
    required int appearance,
    required int drinkability,
    String? note,
  });
  Future<Either<String, int?>> getUserRating(String beerId);
}
