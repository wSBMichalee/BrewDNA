import 'dart:convert';
import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/beer.dart';
import '../../domain/repositories/i_scan_repository.dart';

@LazySingleton(as: IScanRepository)
class SupabaseScanRepository implements IScanRepository {
  final SupabaseClient _supabase;

  SupabaseScanRepository(this._supabase);

  @override
  Future<Either<String, Beer>> scanBeer(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await _supabase.functions.invoke(
        'recognize-beer',
        body: {'image': base64Image},
      );

      // Parse the response to extract Beer data
      // (This will fail as GEMINI_API_KEY is not set in Supabase, but it is expected)
      final data = response.data;

      // In a real scenario, we'd parse the map into a Beer entity.
      // For now, let's construct a dummy beer based on what we'd expect or just rely on the API.
      // Since it will throw anyway due to missing API key, this is a placeholder.
      if (data == null || data['error'] != null) {
        return left('Wystąpił błąd podczas analizy piwa.');
      }

      return right(
        Beer(
          id: data['id'] ?? 'scan_1',
          name: data['name'] ?? 'Rozpoznane Piwo',
          brewery: data['brewery'] ?? 'Nieznany Browar',
          country: data['country'] ?? 'Nieznany Kraj',
          style: data['style'] ?? 'Brak Danych',
          abv: (data['abv'] as num?)?.toDouble() ?? 5.0,
          rating: 0.0,
          lightStrong: 50,
          bitterSweet: 50,
          dryFruity: 50,
          crispMalty: 50,
          imageUrl: '',
        ),
      );
    } catch (e) {
      return left('Nie udało się rozpoznać piwa. Spróbuj ponownie.');
    }
  }
}
