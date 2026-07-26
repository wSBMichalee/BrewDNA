import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import '../entities/beer.dart';

abstract class IScanRepository {
  Future<Either<String, Beer>> scanBeer(Uint8List imageBytes);
}
