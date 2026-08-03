import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:math' as math;
import '../../domain/repositories/i_beer_repository.dart';
import '../../domain/entities/beer.dart';
import 'beer_state.dart';

// TODO(taste-profiles): zastąpić realnym profilem z Supabase po domknięciu
// zapisu OnboardingState -> taste_profiles. Patrz wątek "taste_profiles".
const _tempTasteProfile = (lightStrong: 70.0, bitterSweet: 60.0, dryFruity: 40.0);

@injectable
class BeerCubit extends Cubit<BeerState> {
  final IBeerRepository _repository;
  // Cache prekalkulowanych procentów dopasowania — uzupełniany raz w loadDiscoverData().
  final Map<String, int> _matchPercentages = {};

  BeerCubit(this._repository) : super(const BeerState.initial());

  Future<void> loadBeerOfTheDay() async {
    _emitLoading();
    final result = await _repository.getBeerOfTheDay();
    result.fold(
      (error) => emit(BeerState.error(error)),
      (beer) => _emitLoaded(beerOfTheDay: beer),
    );
  }

  Future<void> loadHistory() async {
    _emitLoading();
    final result = await _repository.getHistory();
    result.fold(
      (error) => emit(BeerState.error(error)),
      (beers) => _emitLoaded(history: beers),
    );
  }

  Future<void> loadDiscoverData() async {
    _emitLoading();
    final botdFuture = _repository.getBeerOfTheDay();
    final recFuture = _repository.getRecommendations();
    final countriesFuture = _repository.getTopCountries();
    final topRatedFuture = _repository.getTopRatedBeers();

    final results = await Future.wait([botdFuture, recFuture, countriesFuture, topRatedFuture]);

    final botdResult = results[0] as Either<String, Beer>;
    final recResult = results[1] as Either<String, List<Beer>>;
    final countriesResult = results[2] as Either<String, List<Map<String, dynamic>>>;
    final topRatedResult = results[3] as Either<String, List<Beer>>;

    if (recResult.isLeft() || countriesResult.isLeft() || topRatedResult.isLeft()) {
      emit(BeerState.error('Failed to load discover data'));
      return;
    }

    final beerOfTheDay = botdResult.toOption().toNullable();
    final recommendations = recResult.getOrElse((_) => []);
    final topCountries = countriesResult.getOrElse((_) => []);
    final topRatedBeers = topRatedResult.getOrElse((_) => []);

    // Gather unique beers to sort by match percentage
    final allBeers = <String, Beer>{};
    for (final beer in [...recommendations, ...topRatedBeers]) {
      allBeers[beer.id] = beer;
    }
    
    // Prekalkuluj raz — zamiast 2× per porównanie w sort i per render w itemBuilder.
    for (final beer in allBeers.values) {
      _matchPercentages[beer.id] = calculateMatchPercentage(beer);
    }
    final matchedBeers = allBeers.values.toList()
      ..sort((a, b) => (_matchPercentages[b.id] ?? 0).compareTo(_matchPercentages[a.id] ?? 0));

    _emitLoaded(
      beerOfTheDay: beerOfTheDay,
      recommendations: recommendations,
      topCountries: topCountries,
      topRatedBeers: topRatedBeers,
      matchedBeers: matchedBeers,
    );
  }

  int calculateMatchPercentage(Beer beer) {
    final lsDiff = beer.lightStrong - _tempTasteProfile.lightStrong;
    final bsDiff = beer.bitterSweet - _tempTasteProfile.bitterSweet;
    final dfDiff = beer.dryFruity - _tempTasteProfile.dryFruity;

    final distance = math.sqrt(
        (lsDiff * lsDiff) + (bsDiff * bsDiff) + (dfDiff * dfDiff));
    const maxDistance = 200.0;
    
    final match = 100.0 - (distance / maxDistance * 100.0);
    return match.clamp(0.0, 100.0).round();
  }

  /// Zwraca prekalkulowany procent dopasowania dla piwa o danym [beerId].
  /// Wartości są obliczane raz w [loadDiscoverData] i cachowane w [_matchPercentages].
  int getMatchPercentage(String beerId) => _matchPercentages[beerId] ?? 0;

  Future<void> loadBeerById(String id) async {
    _emitLoading();
    final result = await _repository.getBeerById(id);
    result.fold(
      (error) => emit(BeerState.error(error)),
      (beer) => _emitLoaded(selectedBeer: beer),
    );
  }

  void _emitLoading() {
    state.maybeWhen(
      loaded: (_, _, _, _, _, _, _) {}, // Do not emit loading if already loaded
      orElse: () => emit(const BeerState.loading()),
    );
  }

  void _emitLoaded({
    List<Beer>? history,
    List<Beer>? recommendations,
    List<Map<String, dynamic>>? topCountries,
    List<Beer>? topRatedBeers,
    Beer? beerOfTheDay,
    Beer? selectedBeer,
    List<Beer>? matchedBeers,
  }) {
    state.maybeWhen(
      loaded:
          (
            currHistory,
            currRecommendations,
            currTopCountries,
            currTopRatedBeers,
            currBeerOfTheDay,
            currSelectedBeer,
            currMatchedBeers,
          ) {
            emit(
              BeerState.loaded(
                history: history ?? currHistory,
                recommendations: recommendations ?? currRecommendations,
                topCountries: topCountries ?? currTopCountries,
                topRatedBeers: topRatedBeers ?? currTopRatedBeers,
                beerOfTheDay: beerOfTheDay ?? currBeerOfTheDay,
                selectedBeer: selectedBeer ?? currSelectedBeer,
                matchedBeers: matchedBeers ?? currMatchedBeers,
              ),
            );
          },
      orElse: () {
        emit(
          BeerState.loaded(
            history: history ?? [],
            recommendations: recommendations ?? [],
            topCountries: topCountries ?? [],
            topRatedBeers: topRatedBeers ?? [],
            beerOfTheDay: beerOfTheDay,
            selectedBeer: selectedBeer,
            matchedBeers: matchedBeers ?? [],
          ),
        );
      },
    );
  }
}
