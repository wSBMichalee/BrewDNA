import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/i_wishlist_repository.dart';
import '../../domain/entities/beer.dart';

@LazySingleton(as: IWishlistRepository)
class SupabaseWishlistRepository implements IWishlistRepository {
  final SupabaseClient _supabase;

  SupabaseWishlistRepository(this._supabase);

  @override
  Future<Either<String, List<Beer>>> getWishlist() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return left('Użytkownik niezalogowany');

      final response = await _supabase
          .from('wishlist')
          .select('''
            beers (
              id,
              name,
              brewery,
              country,
              style,
              abv,
              rating,
              light_strong,
              bitter_sweet,
              dry_fruity,
              crisp_malty,
              image_url
            )
          ''')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<Beer> results = (response as List<dynamic>).map((row) {
        final beerData = row['beers'] as Map<String, dynamic>?;
        if (beerData == null) return null;
        
        return Beer(
          id: beerData['id']?.toString() ?? '',
          name: beerData['name'] as String? ?? 'Nieznane',
          brewery: beerData['brewery'] as String? ?? '',
          country: beerData['country'] as String? ?? '',
          style: beerData['style'] as String? ?? '',
          abv: (beerData['abv'] as num?)?.toDouble() ?? 0.0,
          rating: (beerData['rating'] as num?)?.toDouble() ?? 0.0,
          lightStrong: (beerData['light_strong'] as num?)?.toDouble() ?? 50.0,
          bitterSweet: (beerData['bitter_sweet'] as num?)?.toDouble() ?? 50.0,
          dryFruity: (beerData['dry_fruity'] as num?)?.toDouble() ?? 50.0,
          crispMalty: (beerData['crisp_malty'] as num?)?.toDouble() ?? 50.0,
          imageUrl: beerData['image_url'] as String? ?? '',
        );
      }).whereType<Beer>().toList();

      return right(results);
    } catch (e) {
      return left('Nie udało się pobrać wishlisty.');
    }
  }

  @override
  Future<Either<String, void>> addToWishlist(String beerId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return left('Użytkownik niezalogowany');

      await _supabase.from('wishlist').insert({
        'user_id': user.id,
        'beer_id': beerId,
      });
      return right(null);
    } catch (e) {
      return left('Nie udało się dodać do wishlisty.');
    }
  }

  @override
  Future<Either<String, void>> removeFromWishlist(String beerId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return left('Użytkownik niezalogowany');

      await _supabase
          .from('wishlist')
          .delete()
          .eq('user_id', user.id)
          .eq('beer_id', beerId);
      return right(null);
    } catch (e) {
      return left('Nie udało się usunąć z wishlisty.');
    }
  }
}
