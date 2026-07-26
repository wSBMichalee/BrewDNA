import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/beer.dart';
import '../../domain/entities/checkin_record.dart';

part 'beer_state.freezed.dart';

@freezed
class BeerState with _$BeerState {
  const factory BeerState.initial() = _Initial;
  const factory BeerState.loading() = _Loading;
  
  const factory BeerState.loaded({
    @Default([]) List<CheckinRecord> history,
    @Default([]) List<Beer> recommendations,
    Beer? beerOfTheDay,
    Beer? selectedBeer,
  }) = _Loaded;
  
  const factory BeerState.error(String message) = _Error;
}
