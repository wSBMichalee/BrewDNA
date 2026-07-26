import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';

abstract class ICellarRepository {
  Future<Either<String, List<Beer>>> getCellar();
  Future<Either<String, void>> addToCellar(String beerId);
  Future<Either<String, void>> removeFromCellar(String beerId);
}
