import '../../../beer/domain/entities/beer.dart';

class UserTasteStats {
  final int totalBeers;
  final int uniqueBreweries;
  final int uniqueCountries;
  
  final int uniqueStylesCount;
  final String? favoriteStyle;
  final double? favoriteStyleAvgRating;
  
  final String? favoriteCountry;
  final int? favoriteCountryBeersCount;
  
  const UserTasteStats({
    required this.totalBeers,
    required this.uniqueBreweries,
    required this.uniqueCountries,
    required this.uniqueStylesCount,
    this.favoriteStyle,
    this.favoriteStyleAvgRating,
    this.favoriteCountry,
    this.favoriteCountryBeersCount,
  });

  factory UserTasteStats.fromHistory(List<Beer> history) {
    if (history.isEmpty) {
      return const UserTasteStats(
        totalBeers: 0,
        uniqueBreweries: 0,
        uniqueCountries: 0,
        uniqueStylesCount: 0,
      );
    }
    
    final breweries = <String>{};
    final countries = <String>{};
    final styles = <String>{};
    
    final styleRatings = <String, List<double>>{};
    final countryCounts = <String, int>{};
    
    for (final beer in history) {
      breweries.add(beer.brewery);
      countries.add(beer.country);
      styles.add(beer.style);
      
      styleRatings.putIfAbsent(beer.style, () => []).add(beer.rating);
      countryCounts[beer.country] = (countryCounts[beer.country] ?? 0) + 1;
    }
    
    // Calculate favorite style
    String? favStyle;
    double? favStyleAvg;
    int maxStyleCount = 0;
    
    for (final entry in styleRatings.entries) {
      final style = entry.key;
      final ratings = entry.value;
      final avg = ratings.reduce((a, b) => a + b) / ratings.length;
      final count = ratings.length;
      
      if (favStyleAvg == null || avg > favStyleAvg || (avg == favStyleAvg && count > maxStyleCount)) {
        favStyleAvg = avg;
        favStyle = style;
        maxStyleCount = count;
      }
    }
    
    // Calculate favorite country
    String? favCountry;
    int maxCountryCount = 0;
    for (final entry in countryCounts.entries) {
      if (entry.value > maxCountryCount) {
        maxCountryCount = entry.value;
        favCountry = entry.key;
      }
    }
    
    return UserTasteStats(
      totalBeers: history.length,
      uniqueBreweries: breweries.length,
      uniqueCountries: countries.length,
      uniqueStylesCount: styles.length,
      favoriteStyle: favStyle,
      favoriteStyleAvgRating: favStyleAvg,
      favoriteCountry: favCountry,
      favoriteCountryBeersCount: favCountry != null ? maxCountryCount : null,
    );
  }
}
