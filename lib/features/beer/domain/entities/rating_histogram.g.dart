// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_histogram.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RatingHistogram _$RatingHistogramFromJson(Map<String, dynamic> json) =>
    _RatingHistogram(
      count5: (json['count5'] as num).toInt(),
      count4: (json['count4'] as num).toInt(),
      count3: (json['count3'] as num).toInt(),
      count2: (json['count2'] as num).toInt(),
      count1: (json['count1'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      averageRating: (json['averageRating'] as num).toDouble(),
    );

Map<String, dynamic> _$RatingHistogramToJson(_RatingHistogram instance) =>
    <String, dynamic>{
      'count5': instance.count5,
      'count4': instance.count4,
      'count3': instance.count3,
      'count2': instance.count2,
      'count1': instance.count1,
      'totalCount': instance.totalCount,
      'averageRating': instance.averageRating,
    };
