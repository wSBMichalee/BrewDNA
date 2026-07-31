import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/beer.dart';
import '../../domain/repositories/i_beer_repository.dart';

@LazySingleton(as: IBeerRepository)
class SupabaseBeerRepository implements IBeerRepository {
  final SupabaseClient _supabase;

  SupabaseBeerRepository(this._supabase);

  // Helper to map Supabase JSON to Beer entity
  Beer _mapBeer(Map<String, dynamic> row) {
    final breweryData = row['breweries'] as Map<String, dynamic>?;
    final styleData = row['styles'] as Map<String, dynamic>?;

    return Beer(
      id: row['id'] as String,
      name: row['name'] as String,
      brewery: breweryData?['name'] as String? ?? 'Nieznany browar',
      country: breweryData?['country'] as String? ?? 'Nieznany',
      style: styleData?['name'] as String? ?? 'Nieznany styl',
      abv: (row['abv'] as num?)?.toDouble() ?? 0.0,
      rating: (row['global_rating'] as num?)?.toDouble() ?? 0.0,
      lightStrong: (row['axis_strength'] as num?)?.toDouble() ?? 50.0,
      bitterSweet: (row['axis_bitterness'] as num?)?.toDouble() ?? 50.0,
      dryFruity: (row['axis_fruitiness'] as num?)?.toDouble() ?? 50.0,
      crispMalty: (row['axis_maltiness'] as num?)?.toDouble() ?? 50.0,
      imageUrl: row['image_url'] as String? ?? '',
    );
  }

  @override
  Future<Either<String, List<Beer>>> getHistory() async {
    // To be implemented when users and checkins are fully hooked up.
    // For now, return an empty list as expected.
    return right([]);
  }

  @override
  Future<Either<String, List<Beer>>> getRecommendations() async {
    try {
      final response = await _supabase
          .from('beers')
          .select('*, breweries(name, country), styles(name)')
          .limit(10);

      final beers = (response as List).map((e) => _mapBeer(e as Map<String, dynamic>)).toList();
      return right(beers);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Map<String, dynamic>>>> getTopCountries() async {
    try {
      // Grouping by country in Dart as requested.
      final response = await _supabase
          .from('beers')
          .select('breweries(country)');

      final countryCounts = <String, int>{};
      for (final row in response as List) {
        final brewery = row['breweries'] as Map<String, dynamic>?;
        if (brewery != null) {
          final countryCode = brewery['country'] as String?;
          if (countryCode != null && countryCode.isNotEmpty) {
            countryCounts[countryCode] = (countryCounts[countryCode] ?? 0) + 1;
          }
        }
      }

      // Convert to list of maps and sort descending by count
      final result = countryCounts.entries.map((e) {
        return {
          'name': _getCountryName(e.key),
          'count': e.value,
          'flag': _getFlagEmoji(e.key), // Helper for flags based on country code
        };
      }).toList();

      result.sort((a, b) => (b['count'] as num).compareTo(a['count'] as num));

      return right(result);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Beer>>> getTopRatedBeers() async {
    try {
      final response = await _supabase
          .from('beers')
          .select('*, breweries(name, country), styles(name)')
          .order('global_rating', ascending: false)
          .limit(10);

      final beers = (response as List).map((e) => _mapBeer(e as Map<String, dynamic>)).toList();
      return right(beers);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Beer>> getBeerOfTheDay() async {
    try {
      // Using highest rated as 'Beer of the Day' for now
      final response = await _supabase
          .from('beers')
          .select('*, breweries(name, country), styles(name)')
          .order('global_rating', ascending: false)
          .limit(1);

      if ((response as List).isNotEmpty) {
        return right(_mapBeer(response.first as Map<String, dynamic>));
      } else {
        return left('Brak piw w bazie.');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Beer>> getBeerById(String id) async {
    try {
      final response = await _supabase
          .from('beers')
          .select('*, breweries(name, country), styles(name)')
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        return right(_mapBeer(response));
      } else {
        return left('Nie znaleziono piwa.');
      }
    } catch (e) {
      return left(e.toString());
    }
  }
  
  String _getCountryName(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'PL': return 'Polska';
      case 'UK': return 'Wlk. Brytania';
      case 'USA': return 'USA';
      case 'US': return 'USA';
      case 'DK': return 'Dania';
      case 'SE': return 'Szwecja';
      case 'IE': return 'Irlandia';
      case 'BE': return 'Belgia';
      case 'DE': return 'Niemcy';
      case 'CZ': return 'Czechy';
      default: return countryCode;
    }
  }

  String _getFlagEmoji(String countryCode) {
    switch (countryCode.toUpperCase()) {
      case 'PL': return '🇵🇱';
      case 'UK': return '🇬🇧';
      case 'USA': return '🇺🇸';
      case 'US': return '🇺🇸';
      case 'DK': return '🇩🇰';
      case 'SE': return '🇸🇪';
      case 'IE': return '🇮🇪';
      case 'BE': return '🇧🇪';
      case 'DE': return '🇩🇪';
      case 'CZ': return '🇨🇿';
      default: return '🍺';
    }
  }
}
