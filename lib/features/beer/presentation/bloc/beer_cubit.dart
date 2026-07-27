import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_beer_repository.dart';
import '../../domain/entities/beer.dart';
import 'beer_state.dart';

@injectable
class BeerCubit extends Cubit<BeerState> {
  final IBeerRepository _repository;

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

  Future<void> loadRecommendations() async {
    _emitLoading();
    final result = await _repository.getRecommendations();
    result.fold(
      (error) => emit(BeerState.error(error)),
      (beers) => _emitLoaded(recommendations: beers),
    );
  }

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
      loaded: (_, __, ___, ____) {}, // Do not emit loading if already loaded
      orElse: () => emit(const BeerState.loading()),
    );
  }

  void _emitLoaded({
    List<Beer>? history,
    List<Beer>? recommendations,
    Beer? beerOfTheDay,
    Beer? selectedBeer,
  }) {
    state.maybeWhen(
      loaded: (currHistory, currRecommendations, currBeerOfTheDay, currSelectedBeer) {
        emit(BeerState.loaded(
          history: history ?? currHistory,
          recommendations: recommendations ?? currRecommendations,
          beerOfTheDay: beerOfTheDay ?? currBeerOfTheDay,
          selectedBeer: selectedBeer ?? currSelectedBeer,
        ));
      },
      orElse: () {
        emit(BeerState.loaded(
          history: history ?? [],
          recommendations: recommendations ?? [],
          beerOfTheDay: beerOfTheDay,
          selectedBeer: selectedBeer,
        ));
      },
    );
  }
}
