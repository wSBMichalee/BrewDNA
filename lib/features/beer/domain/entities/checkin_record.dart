import 'beer.dart';

class CheckinRecord {
  final Beer beer;
  final DateTime checkinDate;
  final String locationCity;

  const CheckinRecord({
    required this.beer,
    required this.checkinDate,
    required this.locationCity,
  });
}
