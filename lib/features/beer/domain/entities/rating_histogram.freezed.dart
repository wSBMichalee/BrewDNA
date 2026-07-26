// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_histogram.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RatingHistogram {

 int get count5; int get count4; int get count3; int get count2; int get count1; int get totalCount; double get averageRating;
/// Create a copy of RatingHistogram
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingHistogramCopyWith<RatingHistogram> get copyWith => _$RatingHistogramCopyWithImpl<RatingHistogram>(this as RatingHistogram, _$identity);

  /// Serializes this RatingHistogram to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingHistogram&&(identical(other.count5, count5) || other.count5 == count5)&&(identical(other.count4, count4) || other.count4 == count4)&&(identical(other.count3, count3) || other.count3 == count3)&&(identical(other.count2, count2) || other.count2 == count2)&&(identical(other.count1, count1) || other.count1 == count1)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count5,count4,count3,count2,count1,totalCount,averageRating);

@override
String toString() {
  return 'RatingHistogram(count5: $count5, count4: $count4, count3: $count3, count2: $count2, count1: $count1, totalCount: $totalCount, averageRating: $averageRating)';
}


}

/// @nodoc
abstract mixin class $RatingHistogramCopyWith<$Res>  {
  factory $RatingHistogramCopyWith(RatingHistogram value, $Res Function(RatingHistogram) _then) = _$RatingHistogramCopyWithImpl;
@useResult
$Res call({
 int count5, int count4, int count3, int count2, int count1, int totalCount, double averageRating
});




}
/// @nodoc
class _$RatingHistogramCopyWithImpl<$Res>
    implements $RatingHistogramCopyWith<$Res> {
  _$RatingHistogramCopyWithImpl(this._self, this._then);

  final RatingHistogram _self;
  final $Res Function(RatingHistogram) _then;

/// Create a copy of RatingHistogram
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count5 = null,Object? count4 = null,Object? count3 = null,Object? count2 = null,Object? count1 = null,Object? totalCount = null,Object? averageRating = null,}) {
  return _then(_self.copyWith(
count5: null == count5 ? _self.count5 : count5 // ignore: cast_nullable_to_non_nullable
as int,count4: null == count4 ? _self.count4 : count4 // ignore: cast_nullable_to_non_nullable
as int,count3: null == count3 ? _self.count3 : count3 // ignore: cast_nullable_to_non_nullable
as int,count2: null == count2 ? _self.count2 : count2 // ignore: cast_nullable_to_non_nullable
as int,count1: null == count1 ? _self.count1 : count1 // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [RatingHistogram].
extension RatingHistogramPatterns on RatingHistogram {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RatingHistogram value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RatingHistogram() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RatingHistogram value)  $default,){
final _that = this;
switch (_that) {
case _RatingHistogram():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RatingHistogram value)?  $default,){
final _that = this;
switch (_that) {
case _RatingHistogram() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count5,  int count4,  int count3,  int count2,  int count1,  int totalCount,  double averageRating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RatingHistogram() when $default != null:
return $default(_that.count5,_that.count4,_that.count3,_that.count2,_that.count1,_that.totalCount,_that.averageRating);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count5,  int count4,  int count3,  int count2,  int count1,  int totalCount,  double averageRating)  $default,) {final _that = this;
switch (_that) {
case _RatingHistogram():
return $default(_that.count5,_that.count4,_that.count3,_that.count2,_that.count1,_that.totalCount,_that.averageRating);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count5,  int count4,  int count3,  int count2,  int count1,  int totalCount,  double averageRating)?  $default,) {final _that = this;
switch (_that) {
case _RatingHistogram() when $default != null:
return $default(_that.count5,_that.count4,_that.count3,_that.count2,_that.count1,_that.totalCount,_that.averageRating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RatingHistogram implements RatingHistogram {
  const _RatingHistogram({required this.count5, required this.count4, required this.count3, required this.count2, required this.count1, required this.totalCount, required this.averageRating});
  factory _RatingHistogram.fromJson(Map<String, dynamic> json) => _$RatingHistogramFromJson(json);

@override final  int count5;
@override final  int count4;
@override final  int count3;
@override final  int count2;
@override final  int count1;
@override final  int totalCount;
@override final  double averageRating;

/// Create a copy of RatingHistogram
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingHistogramCopyWith<_RatingHistogram> get copyWith => __$RatingHistogramCopyWithImpl<_RatingHistogram>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingHistogramToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatingHistogram&&(identical(other.count5, count5) || other.count5 == count5)&&(identical(other.count4, count4) || other.count4 == count4)&&(identical(other.count3, count3) || other.count3 == count3)&&(identical(other.count2, count2) || other.count2 == count2)&&(identical(other.count1, count1) || other.count1 == count1)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count5,count4,count3,count2,count1,totalCount,averageRating);

@override
String toString() {
  return 'RatingHistogram(count5: $count5, count4: $count4, count3: $count3, count2: $count2, count1: $count1, totalCount: $totalCount, averageRating: $averageRating)';
}


}

/// @nodoc
abstract mixin class _$RatingHistogramCopyWith<$Res> implements $RatingHistogramCopyWith<$Res> {
  factory _$RatingHistogramCopyWith(_RatingHistogram value, $Res Function(_RatingHistogram) _then) = __$RatingHistogramCopyWithImpl;
@override @useResult
$Res call({
 int count5, int count4, int count3, int count2, int count1, int totalCount, double averageRating
});




}
/// @nodoc
class __$RatingHistogramCopyWithImpl<$Res>
    implements _$RatingHistogramCopyWith<$Res> {
  __$RatingHistogramCopyWithImpl(this._self, this._then);

  final _RatingHistogram _self;
  final $Res Function(_RatingHistogram) _then;

/// Create a copy of RatingHistogram
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count5 = null,Object? count4 = null,Object? count3 = null,Object? count2 = null,Object? count1 = null,Object? totalCount = null,Object? averageRating = null,}) {
  return _then(_RatingHistogram(
count5: null == count5 ? _self.count5 : count5 // ignore: cast_nullable_to_non_nullable
as int,count4: null == count4 ? _self.count4 : count4 // ignore: cast_nullable_to_non_nullable
as int,count3: null == count3 ? _self.count3 : count3 // ignore: cast_nullable_to_non_nullable
as int,count2: null == count2 ? _self.count2 : count2 // ignore: cast_nullable_to_non_nullable
as int,count1: null == count1 ? _self.count1 : count1 // ignore: cast_nullable_to_non_nullable
as int,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
