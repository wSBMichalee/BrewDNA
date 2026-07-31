import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/beer.dart';

part 'beer_state.freezed.dart';

@freezed
class BeerState with _$BeerState {
  const factory BeerState.initial() = _Initial;
  const factory BeerState.loading() = _Loading;

  const factory BeerState.loaded({
    @Default([]) List<Beer> history,
    @Default([]) List<Beer> recommendations,
    @Default([]) List<Map<String, dynamic>> topCountries,
    @Default([]) List<Beer> topRatedBeers,
    Beer? beerOfTheDay,
    Beer? selectedBeer,
    @Default([]) List<Beer> matchedBeers,
  }) = _Loaded;

  const factory BeerState.error(String message) = _Error;
}
