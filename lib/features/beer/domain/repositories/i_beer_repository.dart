import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';
import '../entities/checkin_record.dart';

abstract class IBeerRepository {
  Future<Either<String, List<CheckinRecord>>> getHistory();
  Future<Either<String, List<Beer>>> getRecommendations();
  Future<Either<String, Beer>> getBeerOfTheDay();
  Future<Either<String, Beer>> getBeerById(String id);
}
