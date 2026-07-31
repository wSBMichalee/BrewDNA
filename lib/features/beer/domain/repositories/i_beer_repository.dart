import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';

abstract class IBeerRepository {
  Future<Either<String, List<Beer>>> getHistory();
  Future<Either<String, List<Beer>>> getRecommendations();
  Future<Either<String, List<Map<String, dynamic>>>> getTopCountries();
  Future<Either<String, List<Beer>>> getTopRatedBeers();
  Future<Either<String, Beer>> getBeerOfTheDay();
  Future<Either<String, Beer>> getBeerById(String id);
}
