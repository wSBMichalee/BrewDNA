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
      
      final data = response.data;
      
      if (data == null || data['error'] != null || data['id'] == null) {
        return left('Wystąpił błąd podczas analizy piwa.');
      }
      
      return right(Beer(
        id: data['id'].toString(),
        name: data['name']?.toString() ?? '',
        brewery: data['brewery']?.toString() ?? '',
        country: data['country']?.toString() ?? '',
        style: data['style']?.toString() ?? '',
        abv: (data['abv'] as num?)?.toDouble() ?? 0.0,
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
        lightStrong: (data['lightStrong'] as num?)?.toDouble() ?? 50.0,
        bitterSweet: (data['bitterSweet'] as num?)?.toDouble() ?? 50.0,
        dryFruity: (data['dryFruity'] as num?)?.toDouble() ?? 50.0,
        crispMalty: (data['crispMalty'] as num?)?.toDouble() ?? 50.0,
        imageUrl: data['imageUrl']?.toString() ?? '',
      ));
    } catch (e) {
      return left('Nie udało się rozpoznać piwa. Spróbuj ponownie.');
    }
  }
}
