import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/i_rating_repository.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/rating_histogram.dart';
import '../../domain/entities/rated_beer_record.dart';
import '../../domain/entities/beer.dart';

@LazySingleton(as: IRatingRepository)
class SupabaseRatingRepository implements IRatingRepository {
  final SupabaseClient _supabase;

  SupabaseRatingRepository(this._supabase);

  @override
  Future<Either<String, RatingHistogram>> getRatingHistogram(String beerId) async {
    try {
      // Zgodnie z wytycznymi - nie pobieramy wszystkich wierszy do klienta.
      // Używamy funkcji RPC po stronie bazy, która zwraca od razu podsumowanie.
      final response = await _supabase
          .rpc('get_rating_histogram', params: {'p_beer_id': beerId});
          
      // TODO: Upewnij się, że funkcja RPC istnieje w Supabase i zwraca dane w tym formacie.
      // Oczekiwany format odpowiedzi: 
      // { 'count5': int, 'count4': int, 'count3': int, 'count2': int, 'count1': int, 'total': int, 'average': double }
      
      return right(RatingHistogram(
        count5: response['count5'] as int? ?? 0,
        count4: response['count4'] as int? ?? 0,
        count3: response['count3'] as int? ?? 0,
        count2: response['count2'] as int? ?? 0,
        count1: response['count1'] as int? ?? 0,
        totalCount: response['total'] as int? ?? 0,
        averageRating: (response['average'] as num?)?.toDouble() ?? 0.0,
      ));
    } catch (e) {
      // W przypadku błędu (np. bazy) zwracamy prawdziwe 0, a nie fake-owe dane.
      return right(const RatingHistogram(
        count5: 0, count4: 0, count3: 0, count2: 0, count1: 0,
        totalCount: 0, averageRating: 0.0,
      ));
    }
  }

  @override
  Future<Either<String, List<Review>>> getReviews(String beerId, {int limit = 20}) async {
    try {
      final response = await _supabase
          .from('ratings')
          .select('''
            id,
            overall,
            note,
            created_at,
            users (
              name,
              avatar_url
            )
          ''')
          .eq('beer_id', beerId)
          .not('note', 'is', null)
          .order('created_at', ascending: false)
          .limit(limit);

      final List<Review> reviews = (response as List<dynamic>).map((row) {
        final user = row['users'] as Map<String, dynamic>?;
        return Review(
          id: row['id']?.toString() ?? '',
          userName: user?['name'] as String? ?? 'Anonim',
          userAvatarUrl: user?['avatar_url'] as String? ?? '',
          overallRating: (row['overall'] as num?)?.round() ?? 0,
          note: row['note'] as String? ?? '',
          createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
        );
      }).toList();

      return right(reviews);
    } catch (e) {
      return left('Nie udało się pobrać recenzji.');
    }
  }

  @override
  Future<Either<String, void>> submitRating({
    required String beerId,
    required int overall,
    required int taste,
    required int aroma,
    required int bitterness,
    required int appearance,
    required int drinkability,
    String? note,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return left('Musisz być zalogowany by ocenić piwo');

      await _supabase.from('ratings').upsert({
        'user_id': user.id,
        'beer_id': beerId,
        'overall': overall,
        'taste': taste,
        'aroma': aroma,
        'bitterness': bitterness,
        'appearance': appearance,
        'drinkability': drinkability,
        'note': note,
      });
      return right(null);
    } catch (e) {
      return left('Wystąpił błąd podczas zapisywania oceny.');
    }
  }

  @override
  Future<Either<String, int?>> getUserRating(String beerId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return right(null);

      final response = await _supabase
          .from('ratings')
          .select('overall')
          .eq('beer_id', beerId)
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null && response['overall'] != null) {
        return right((response['overall'] as num).round());
      }
      return right(null);
    } catch (e) {
      return left('Nie udało się pobrać oceny użytkownika.');
    }
  }

  @override
  Future<Either<String, List<RatedBeerRecord>>> getUserRatedBeers() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return left('Użytkownik niezalogowany');

      final response = await _supabase
          .from('ratings')
          .select('''
            overall,
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

      final List<RatedBeerRecord> results = (response as List<dynamic>).map((row) {
        final overall = (row['overall'] as num?)?.round() ?? 0;
        final beerData = row['beers'] as Map<String, dynamic>?;
        
        final beer = Beer(
          id: beerData?['id']?.toString() ?? '',
          name: beerData?['name'] as String? ?? 'Nieznane',
          brewery: beerData?['brewery'] as String? ?? '',
          country: beerData?['country'] as String? ?? '',
          style: beerData?['style'] as String? ?? '',
          abv: (beerData?['abv'] as num?)?.toDouble() ?? 0.0,
          rating: (beerData?['rating'] as num?)?.toDouble() ?? 0.0,
          lightStrong: (beerData?['light_strong'] as num?)?.toDouble() ?? 50.0,
          bitterSweet: (beerData?['bitter_sweet'] as num?)?.toDouble() ?? 50.0,
          dryFruity: (beerData?['dry_fruity'] as num?)?.toDouble() ?? 50.0,
          crispMalty: (beerData?['crisp_malty'] as num?)?.toDouble() ?? 50.0,
          imageUrl: beerData?['image_url'] as String? ?? '',
        );

        return RatedBeerRecord(beer: beer, rating: overall);
      }).toList();

      return right(results);
    } catch (e) {
      return left('Nie udało się pobrać ocenionych piw.');
    }
  }
}
