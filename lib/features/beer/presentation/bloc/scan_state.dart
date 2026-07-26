import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/beer.dart';

part 'scan_state.freezed.dart';

@freezed
class ScanState with _$ScanState {
  const factory ScanState.initial() = _Initial;
  const factory ScanState.analyzing() = _Analyzing;
  const factory ScanState.success(Beer beer) = _Success;
  const factory ScanState.error(String message) = _Error;
}
