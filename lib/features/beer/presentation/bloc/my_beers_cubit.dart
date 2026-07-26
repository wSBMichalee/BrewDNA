import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_beer_repository.dart';
import '../../domain/repositories/i_rating_repository.dart';
import '../../domain/repositories/i_wishlist_repository.dart';
import '../../domain/repositories/i_cellar_repository.dart';
import 'my_beers_state.dart';

@injectable
class MyBeersCubit extends Cubit<MyBeersState> {
  final IBeerRepository _beerRepository;
  final IRatingRepository _ratingRepository;
  final IWishlistRepository _wishlistRepository;
  final ICellarRepository _cellarRepository;

  MyBeersCubit(
    this._beerRepository,
    this._ratingRepository,
    this._wishlistRepository,
    this._cellarRepository,
  ) : super(const MyBeersState.initial());

  Future<void> loadAll() async {
    emit(const MyBeersState.loading());
    
    final ratingsResult = await _ratingRepository.getUserRatedBeers();
    final wishlistResult = await _wishlistRepository.getWishlist();
    final cellarResult = await _cellarRepository.getCellar();
    final historyResult = await _beerRepository.getHistory();

    // If any fail, we might want to still show the others, but for simplicity let's handle errors
    // Or we just default to empty lists on error to be resilient
    final ratings = ratingsResult.getOrElse((_) => []);
    final wishlist = wishlistResult.getOrElse((_) => []);
    final cellar = cellarResult.getOrElse((_) => []);
    final history = historyResult.getOrElse((_) => []);

    emit(MyBeersState.loaded(
      ratings: ratings,
      wishlist: wishlist,
      cellar: cellar,
      history: history,
    ));
  }
}
