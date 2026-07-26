import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';

abstract class IWishlistRepository {
  Future<Either<String, List<Beer>>> getWishlist();
  Future<Either<String, void>> addToWishlist(String beerId);
  Future<Either<String, void>> removeFromWishlist(String beerId);
}
