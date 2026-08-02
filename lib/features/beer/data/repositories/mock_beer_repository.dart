import 'package:fpdart/fpdart.dart';
import '../../domain/entities/beer.dart';
import '../../domain/repositories/i_beer_repository.dart';

class MockBeerRepository implements IBeerRepository {
  final Beer _mockBeer = Beer(
    id: '1',
    name: 'Citra Haze',
    brewery: 'Browar Trzech Kotów',
    country: 'Polska',
    style: 'New England IPA',
    abv: 6.5,
    rating: 4.5,
    lightStrong: 65,
    bitterSweet: 30,
    dryFruity: 20,

    imageUrl: '',
  );

  final Beer _mockBeer2 = Beer(
    id: '2',
    name: 'Imperial Stout',
    brewery: 'Ciemna Strona',
    country: 'Polska',
    style: 'Russian Imperial Stout',
    abv: 11.0,
    rating: 4.8,
    lightStrong: 95,
    bitterSweet: 70,
    dryFruity: 60,
    imageUrl: '',
  );

  final Beer _mockBeer3 = Beer(
    id: '3',
    name: 'Klasyczny Pils',
    brewery: 'Browar Rzemieślniczy',
    country: 'Polska',
    style: 'Pilsner',
    abv: 4.5,
    rating: 3.9,
    lightStrong: 40,
    bitterSweet: 60,
    dryFruity: 80,
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
    return right([_mockBeer3, _mockBeer, _mockBeer2]);
  }

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getTopCountries() async {
    await Future.delayed(Duration(milliseconds: 500));
    return right([
      {'name': 'Polska', 'count': 120, 'flag': '🇵🇱'},
      {'name': 'Niemcy', 'count': 85, 'flag': '🇩🇪'},
      {'name': 'Belgia', 'count': 42, 'flag': '🇧🇪'},
      {'name': 'Czechy', 'count': 38, 'flag': '🇨🇿'},
      {'name': 'USA', 'count': 25, 'flag': '🇺🇸'},
      {'name': 'Wielka Brytania', 'count': 15, 'flag': '🇬🇧'},
    ]);
  }

  @override
  Future<Either<String, List<Beer>>> getTopRatedBeers() async {
    await Future.delayed(Duration(milliseconds: 500));
    return right([_mockBeer2, _mockBeer, _mockBeer3]);
  }

  @override
  Future<Either<String, Beer>> getBeerOfTheDay() async {
    await Future.delayed(Duration(milliseconds: 500));
    return right(_mockBeer);
  }

  @override
  Future<Either<String, List<String>>> getAllStyles() async {
    return right(['IPA', 'Lager', 'Weizen', 'Stout', 'Sour', 'Belgijskie', 'Porter', 'Pils']);
  }

  @override
  Future<Either<String, Beer>> getBeerById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    final beers = [_mockBeer, _mockBeer2, _mockBeer3];
    final found = beers.where((b) => b.id == id).toList();
    if (found.isNotEmpty) {
      return right(found.first);
    } else {
      return left('Nie znaleziono piwa o podanym ID.');
    }
  }
}
