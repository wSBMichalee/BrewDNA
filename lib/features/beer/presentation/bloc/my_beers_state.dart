import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/beer.dart';
import '../../domain/entities/checkin_record.dart';
import '../../domain/entities/rated_beer_record.dart';
import '../../domain/entities/cellar_record.dart';

part 'my_beers_state.freezed.dart';

@freezed
class MyBeersState with _$MyBeersState {
  const factory MyBeersState.initial() = _Initial;
  const factory MyBeersState.loading() = _Loading;
  
  const factory MyBeersState.loaded({
    @Default([]) List<RatedBeerRecord> ratings,
    @Default([]) List<Beer> wishlist,
    @Default([]) List<CellarRecord> cellar,
    @Default([]) List<CheckinRecord> history,
  }) = _Loaded;
  
  const factory MyBeersState.error(String message) = _Error;
}
