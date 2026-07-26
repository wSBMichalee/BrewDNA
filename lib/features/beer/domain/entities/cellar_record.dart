import 'beer.dart';

class CellarRecord {
  final Beer beer;
  final int quantity;

  const CellarRecord({
    required this.beer,
    required this.quantity,
  });
}
