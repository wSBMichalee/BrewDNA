import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';

abstract class IBeerRepository {
  Future<Either<String, List<Beer>>> getHistory();
  Future<Either<String, List<Beer>>> getRecommendations();
  Future<Either<String, Beer>> getBeerOfTheDay();
  Future<Either<String, Beer>> getBeerById(String id);
  Future<Either<String, Beer>> scanBeer(String mockResult);
}
