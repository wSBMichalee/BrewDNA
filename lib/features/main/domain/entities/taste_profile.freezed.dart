// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taste_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TasteProfile {

@JsonKey(name: 'calculated_strength') num? get calculatedStrength;@JsonKey(name: 'calculated_bitterness') num? get calculatedBitterness;@JsonKey(name: 'calculated_fruitiness') num? get calculatedFruitiness;@JsonKey(name: 'declared_strength') num? get declaredStrength;@JsonKey(name: 'declared_bitterness') num? get declaredBitterness;@JsonKey(name: 'declared_fruitiness') num? get declaredFruitiness;
/// Create a copy of TasteProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TasteProfileCopyWith<TasteProfile> get copyWith => _$TasteProfileCopyWithImpl<TasteProfile>(this as TasteProfile, _$identity);

  /// Serializes this TasteProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TasteProfile&&(identical(other.calculatedStrength, calculatedStrength) || other.calculatedStrength == calculatedStrength)&&(identical(other.calculatedBitterness, calculatedBitterness) || other.calculatedBitterness == calculatedBitterness)&&(identical(other.calculatedFruitiness, calculatedFruitiness) || other.calculatedFruitiness == calculatedFruitiness)&&(identical(other.declaredStrength, declaredStrength) || other.declaredStrength == declaredStrength)&&(identical(other.declaredBitterness, declaredBitterness) || other.declaredBitterness == declaredBitterness)&&(identical(other.declaredFruitiness, declaredFruitiness) || other.declaredFruitiness == declaredFruitiness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calculatedStrength,calculatedBitterness,calculatedFruitiness,declaredStrength,declaredBitterness,declaredFruitiness);

@override
String toString() {
  return 'TasteProfile(calculatedStrength: $calculatedStrength, calculatedBitterness: $calculatedBitterness, calculatedFruitiness: $calculatedFruitiness, declaredStrength: $declaredStrength, declaredBitterness: $declaredBitterness, declaredFruitiness: $declaredFruitiness)';
}


}

/// @nodoc
abstract mixin class $TasteProfileCopyWith<$Res>  {
  factory $TasteProfileCopyWith(TasteProfile value, $Res Function(TasteProfile) _then) = _$TasteProfileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'calculated_strength') num? calculatedStrength,@JsonKey(name: 'calculated_bitterness') num? calculatedBitterness,@JsonKey(name: 'calculated_fruitiness') num? calculatedFruitiness,@JsonKey(name: 'declared_strength') num? declaredStrength,@JsonKey(name: 'declared_bitterness') num? declaredBitterness,@JsonKey(name: 'declared_fruitiness') num? declaredFruitiness
});




}
/// @nodoc
class _$TasteProfileCopyWithImpl<$Res>
    implements $TasteProfileCopyWith<$Res> {
  _$TasteProfileCopyWithImpl(this._self, this._then);

  final TasteProfile _self;
  final $Res Function(TasteProfile) _then;

/// Create a copy of TasteProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calculatedStrength = freezed,Object? calculatedBitterness = freezed,Object? calculatedFruitiness = freezed,Object? declaredStrength = freezed,Object? declaredBitterness = freezed,Object? declaredFruitiness = freezed,}) {
  return _then(_self.copyWith(
calculatedStrength: freezed == calculatedStrength ? _self.calculatedStrength : calculatedStrength // ignore: cast_nullable_to_non_nullable
as num?,calculatedBitterness: freezed == calculatedBitterness ? _self.calculatedBitterness : calculatedBitterness // ignore: cast_nullable_to_non_nullable
as num?,calculatedFruitiness: freezed == calculatedFruitiness ? _self.calculatedFruitiness : calculatedFruitiness // ignore: cast_nullable_to_non_nullable
as num?,declaredStrength: freezed == declaredStrength ? _self.declaredStrength : declaredStrength // ignore: cast_nullable_to_non_nullable
as num?,declaredBitterness: freezed == declaredBitterness ? _self.declaredBitterness : declaredBitterness // ignore: cast_nullable_to_non_nullable
as num?,declaredFruitiness: freezed == declaredFruitiness ? _self.declaredFruitiness : declaredFruitiness // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [TasteProfile].
extension TasteProfilePatterns on TasteProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TasteProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TasteProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TasteProfile value)  $default,){
final _that = this;
switch (_that) {
case _TasteProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TasteProfile value)?  $default,){
final _that = this;
switch (_that) {
case _TasteProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'calculated_strength')  num? calculatedStrength, @JsonKey(name: 'calculated_bitterness')  num? calculatedBitterness, @JsonKey(name: 'calculated_fruitiness')  num? calculatedFruitiness, @JsonKey(name: 'declared_strength')  num? declaredStrength, @JsonKey(name: 'declared_bitterness')  num? declaredBitterness, @JsonKey(name: 'declared_fruitiness')  num? declaredFruitiness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TasteProfile() when $default != null:
return $default(_that.calculatedStrength,_that.calculatedBitterness,_that.calculatedFruitiness,_that.declaredStrength,_that.declaredBitterness,_that.declaredFruitiness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'calculated_strength')  num? calculatedStrength, @JsonKey(name: 'calculated_bitterness')  num? calculatedBitterness, @JsonKey(name: 'calculated_fruitiness')  num? calculatedFruitiness, @JsonKey(name: 'declared_strength')  num? declaredStrength, @JsonKey(name: 'declared_bitterness')  num? declaredBitterness, @JsonKey(name: 'declared_fruitiness')  num? declaredFruitiness)  $default,) {final _that = this;
switch (_that) {
case _TasteProfile():
return $default(_that.calculatedStrength,_that.calculatedBitterness,_that.calculatedFruitiness,_that.declaredStrength,_that.declaredBitterness,_that.declaredFruitiness);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'calculated_strength')  num? calculatedStrength, @JsonKey(name: 'calculated_bitterness')  num? calculatedBitterness, @JsonKey(name: 'calculated_fruitiness')  num? calculatedFruitiness, @JsonKey(name: 'declared_strength')  num? declaredStrength, @JsonKey(name: 'declared_bitterness')  num? declaredBitterness, @JsonKey(name: 'declared_fruitiness')  num? declaredFruitiness)?  $default,) {final _that = this;
switch (_that) {
case _TasteProfile() when $default != null:
return $default(_that.calculatedStrength,_that.calculatedBitterness,_that.calculatedFruitiness,_that.declaredStrength,_that.declaredBitterness,_that.declaredFruitiness);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TasteProfile extends TasteProfile {
  const _TasteProfile({@JsonKey(name: 'calculated_strength') this.calculatedStrength, @JsonKey(name: 'calculated_bitterness') this.calculatedBitterness, @JsonKey(name: 'calculated_fruitiness') this.calculatedFruitiness, @JsonKey(name: 'declared_strength') this.declaredStrength, @JsonKey(name: 'declared_bitterness') this.declaredBitterness, @JsonKey(name: 'declared_fruitiness') this.declaredFruitiness}): super._();
  factory _TasteProfile.fromJson(Map<String, dynamic> json) => _$TasteProfileFromJson(json);

@override@JsonKey(name: 'calculated_strength') final  num? calculatedStrength;
@override@JsonKey(name: 'calculated_bitterness') final  num? calculatedBitterness;
@override@JsonKey(name: 'calculated_fruitiness') final  num? calculatedFruitiness;
@override@JsonKey(name: 'declared_strength') final  num? declaredStrength;
@override@JsonKey(name: 'declared_bitterness') final  num? declaredBitterness;
@override@JsonKey(name: 'declared_fruitiness') final  num? declaredFruitiness;

/// Create a copy of TasteProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TasteProfileCopyWith<_TasteProfile> get copyWith => __$TasteProfileCopyWithImpl<_TasteProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TasteProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TasteProfile&&(identical(other.calculatedStrength, calculatedStrength) || other.calculatedStrength == calculatedStrength)&&(identical(other.calculatedBitterness, calculatedBitterness) || other.calculatedBitterness == calculatedBitterness)&&(identical(other.calculatedFruitiness, calculatedFruitiness) || other.calculatedFruitiness == calculatedFruitiness)&&(identical(other.declaredStrength, declaredStrength) || other.declaredStrength == declaredStrength)&&(identical(other.declaredBitterness, declaredBitterness) || other.declaredBitterness == declaredBitterness)&&(identical(other.declaredFruitiness, declaredFruitiness) || other.declaredFruitiness == declaredFruitiness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,calculatedStrength,calculatedBitterness,calculatedFruitiness,declaredStrength,declaredBitterness,declaredFruitiness);

@override
String toString() {
  return 'TasteProfile(calculatedStrength: $calculatedStrength, calculatedBitterness: $calculatedBitterness, calculatedFruitiness: $calculatedFruitiness, declaredStrength: $declaredStrength, declaredBitterness: $declaredBitterness, declaredFruitiness: $declaredFruitiness)';
}


}

/// @nodoc
abstract mixin class _$TasteProfileCopyWith<$Res> implements $TasteProfileCopyWith<$Res> {
  factory _$TasteProfileCopyWith(_TasteProfile value, $Res Function(_TasteProfile) _then) = __$TasteProfileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'calculated_strength') num? calculatedStrength,@JsonKey(name: 'calculated_bitterness') num? calculatedBitterness,@JsonKey(name: 'calculated_fruitiness') num? calculatedFruitiness,@JsonKey(name: 'declared_strength') num? declaredStrength,@JsonKey(name: 'declared_bitterness') num? declaredBitterness,@JsonKey(name: 'declared_fruitiness') num? declaredFruitiness
});




}
/// @nodoc
class __$TasteProfileCopyWithImpl<$Res>
    implements _$TasteProfileCopyWith<$Res> {
  __$TasteProfileCopyWithImpl(this._self, this._then);

  final _TasteProfile _self;
  final $Res Function(_TasteProfile) _then;

/// Create a copy of TasteProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calculatedStrength = freezed,Object? calculatedBitterness = freezed,Object? calculatedFruitiness = freezed,Object? declaredStrength = freezed,Object? declaredBitterness = freezed,Object? declaredFruitiness = freezed,}) {
  return _then(_TasteProfile(
calculatedStrength: freezed == calculatedStrength ? _self.calculatedStrength : calculatedStrength // ignore: cast_nullable_to_non_nullable
as num?,calculatedBitterness: freezed == calculatedBitterness ? _self.calculatedBitterness : calculatedBitterness // ignore: cast_nullable_to_non_nullable
as num?,calculatedFruitiness: freezed == calculatedFruitiness ? _self.calculatedFruitiness : calculatedFruitiness // ignore: cast_nullable_to_non_nullable
as num?,declaredStrength: freezed == declaredStrength ? _self.declaredStrength : declaredStrength // ignore: cast_nullable_to_non_nullable
as num?,declaredBitterness: freezed == declaredBitterness ? _self.declaredBitterness : declaredBitterness // ignore: cast_nullable_to_non_nullable
as num?,declaredFruitiness: freezed == declaredFruitiness ? _self.declaredFruitiness : declaredFruitiness // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
