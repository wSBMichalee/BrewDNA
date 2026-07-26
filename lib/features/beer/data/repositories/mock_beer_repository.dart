import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/beer.dart';
import '../../domain/repositories/i_beer_repository.dart';

@LazySingleton(as: IBeerRepository)
class MockBeerRepository implements IBeerRepository {
  final Beer _mockBeer = Beer(
    id: '1',
    name: 'Citra Haze',
    brewery: 'Browar Trzech Kotów',
    style: 'New England IPA',
    abv: 6.5,
    rating: 4.5,
    lightStrong: 65,
    bitterSweet: 30,
    dryFruity: 20,
    crispMalty: 40,
    imageUrl: '',
  );

  final Beer _mockBeer2 = Beer(
    id: '2',
    name: 'Imperial Stout',
    brewery: 'Ciemna Strona',
    style: 'Russian Imperial Stout',
    abv: 11.0,
    rating: 4.8,
    lightStrong: 95,
    bitterSweet: 70,
    dryFruity: 60,
    crispMalty: 85,
    imageUrl: '',
  );

  final Beer _mockBeer3 = Beer(
    id: '3',
    name: 'Klasyczny Pils',
    brewery: 'Browar Rzemieślniczy',
    style: 'Pilsner',
    abv: 4.5,
    rating: 3.9,
    lightStrong: 40,
    bitterSweet: 60,
    dryFruity: 80,
    crispMalty: 30,
    imageUrl: '',
  );

  @override
  Future<Either<String, List<Beer>>> getHistory() async {
    await Future.delayed(Duration(milliseconds: 500));
    return right([_mockBeer, _mockBeer2, _mockBeer3]);
  }

  @override
  Future<Either<String, List<Beer>>> getRecommendations() async {
    await Future.delayed(Duration(milliseconds: 500));
    return right([_mockBeer2, _mockBeer3, _mockBeer]);
  }

  @override
  Future<Either<String, Beer>> getBeerOfTheDay() async {
    await Future.delayed(Duration(milliseconds: 500));
    return right(_mockBeer);
  }

  @override
  Future<Either<String, Beer>> getBeerById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    final beers = [_mockBeer, _mockBeer2, _mockBeer3];
    final match = beers.firstWhere((b) => b.id == id, orElse: () => _mockBeer);
    // As per user requirement: return match or error. Wait, user said "zwracającą dopasowanie po id z listy mocków, albo pierwszy z brzegu jeśli nie znaleziono, z sensownym błędem po stronie Either.left gdy nie istnieje". 
    // Let's implement Either.left if not found:
    final found = beers.where((b) => b.id == id).toList();
    if (found.isNotEmpty) {
      return right(found.first);
    } else {
      return left('Nie znaleziono piwa o podanym ID.');
    }
  }
}
