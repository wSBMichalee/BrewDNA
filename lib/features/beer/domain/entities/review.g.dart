// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  userName: json['userName'] as String,
  userAvatarUrl: json['userAvatarUrl'] as String,
  overallRating: (json['overallRating'] as num).toInt(),
  note: json['note'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'userAvatarUrl': instance.userAvatarUrl,
  'overallRating': instance.overallRating,
  'note': instance.note,
  'createdAt': instance.createdAt.toIso8601String(),
};
