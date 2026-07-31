import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/i_scan_repository.dart';
import 'scan_state.dart';

@injectable
class ScanCubit extends Cubit<ScanState> {
  final IScanRepository _repository;

  ScanCubit(this._repository) : super(const ScanState.initial());

  Future<void> analyzeImage(Uint8List imageBytes) async {
    emit(const ScanState.analyzing());

    final result = await _repository.scanBeer(imageBytes);

    result.fold(
      (error) => emit(ScanState.error(error)),
      (beer) => emit(ScanState.success(beer)),
    );
  }

  void reset() {
    emit(const ScanState.initial());
  }
}
