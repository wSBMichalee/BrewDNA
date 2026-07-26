import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'rating_state.dart';
import '../../domain/repositories/i_rating_repository.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/rating_histogram.dart';

@injectable
class RatingCubit extends Cubit<RatingState> {
  final IRatingRepository _ratingRepository;

  RatingCubit(this._ratingRepository) : super(const RatingState.initial());

  Future<void> loadBeerRatings(String beerId) async {
    emit(const RatingState.loading());

    final userRatingResult = await _ratingRepository.getUserRating(beerId);
    final histogramResult = await _ratingRepository.getRatingHistogram(beerId);
    final reviewsResult = await _ratingRepository.getReviews(beerId);

    // Combine results (simplistic approach for now)
    histogramResult.fold(
      (String error) => emit(RatingState.error(error)),
      (RatingHistogram histogram) {
        reviewsResult.fold(
          (String error) => emit(RatingState.error(error)),
          (List<Review> reviews) {
            int? userRating;
            userRatingResult.fold(
              (String _) {}, 
              (int? rating) => userRating = rating,
            );

            emit(RatingState.loaded(
              histogram: histogram,
              reviews: reviews,
              userRating: userRating,
            ));
          },
        );
      },
    );
  }

  Future<void> submitRating({
    required String beerId,
    required int overall,
    required int taste,
    required int aroma,
    required int bitterness,
    required int appearance,
    required int drinkability,
    String? note,
  }) async {
    emit(const RatingState.submitting());
    final result = await _ratingRepository.submitRating(
      beerId: beerId,
      overall: overall,
      taste: taste,
      aroma: aroma,
      bitterness: bitterness,
      appearance: appearance,
      drinkability: drinkability,
      note: note,
    );

    result.fold(
      (error) => emit(RatingState.error(error)),
      (_) {
        emit(const RatingState.submitted());
        // Reload ratings to reflect the new state
        loadBeerRatings(beerId);
      },
    );
  }
}
