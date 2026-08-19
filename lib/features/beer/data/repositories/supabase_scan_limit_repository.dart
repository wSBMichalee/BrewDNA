import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/i_scan_limit_repository.dart';

@LazySingleton(as: IScanLimitRepository)
class SupabaseScanLimitRepository implements IScanLimitRepository {
  final SupabaseClient _supabase;
  static const int _maxFreeScans = 5;

  SupabaseScanLimitRepository(this._supabase);

  @override
  Future<int> getRemainingScans(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('scan_count, scan_count_reset_at')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return _maxFreeScans;

      final scanCount = (response['scan_count'] as num?)?.toInt() ?? 0;
      final resetAtStr = response['scan_count_reset_at'] as String?;
      
      if (resetAtStr != null) {
        final resetAt = DateTime.parse(resetAtStr);
        final now = DateTime.now();
        // Sprawdzamy czy minęło 30 dni od ostatniego resetu
        if (now.difference(resetAt).inDays >= 30) {
          // Leniwy reset - z perspektywy odczytu limit został zresetowany do zera,
          // więc użytkownik ma znów _maxFreeScans skanów.
          // Faktyczny update nastąpi podczas incrementScanCount.
          return _maxFreeScans;
        }
      }

      final remaining = _maxFreeScans - scanCount;
      return remaining < 0 ? 0 : remaining;
    } catch (e) {
      // W przypadku błędu dla bezpieczeństwa zwracamy pełny limit, by nie blokować aplikacji
      return _maxFreeScans;
    }
  }

  @override
  Future<void> incrementScanCount(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select('scan_count, scan_count_reset_at')
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return;

      int currentCount = (response['scan_count'] as num?)?.toInt() ?? 0;
      final resetAtStr = response['scan_count_reset_at'] as String?;
      DateTime? resetAt = resetAtStr != null ? DateTime.parse(resetAtStr) : null;
      final now = DateTime.now();

      // Logika leniwego resetu podczas inkrementacji
      if (resetAt == null || now.difference(resetAt).inDays >= 30) {
        currentCount = 0;
        resetAt = now;
      }

      currentCount += 1;

      await _supabase.from('users').update({
        'scan_count': currentCount,
        'scan_count_reset_at': resetAt.toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      // Ignorujemy błędy aktualizacji, by nie przerywać flow użytkownika
    }
  }
}
