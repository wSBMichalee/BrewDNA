import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';
import '../entities/cellar_record.dart';

abstract class ICellarRepository {
  Future<Either<String, List<CellarRecord>>> getCellar();
  Future<Either<String, void>> addToCellar(String beerId);
  Future<Either<String, void>> removeFromCellar(String beerId);
}
