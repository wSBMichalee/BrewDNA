// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 int get currentStep; double get lightStrongValue; double get bitterSweetValue; double get dryFruityValue; double get crispMaltyValue;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.lightStrongValue, lightStrongValue) || other.lightStrongValue == lightStrongValue)&&(identical(other.bitterSweetValue, bitterSweetValue) || other.bitterSweetValue == bitterSweetValue)&&(identical(other.dryFruityValue, dryFruityValue) || other.dryFruityValue == dryFruityValue)&&(identical(other.crispMaltyValue, crispMaltyValue) || other.crispMaltyValue == crispMaltyValue));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,lightStrongValue,bitterSweetValue,dryFruityValue,crispMaltyValue);

@override
String toString() {
  return 'OnboardingState(currentStep: $currentStep, lightStrongValue: $lightStrongValue, bitterSweetValue: $bitterSweetValue, dryFruityValue: $dryFruityValue, crispMaltyValue: $crispMaltyValue)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int currentStep, double lightStrongValue, double bitterSweetValue, double dryFruityValue, double crispMaltyValue
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? lightStrongValue = null,Object? bitterSweetValue = null,Object? dryFruityValue = null,Object? crispMaltyValue = null,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,lightStrongValue: null == lightStrongValue ? _self.lightStrongValue : lightStrongValue // ignore: cast_nullable_to_non_nullable
as double,bitterSweetValue: null == bitterSweetValue ? _self.bitterSweetValue : bitterSweetValue // ignore: cast_nullable_to_non_nullable
as double,dryFruityValue: null == dryFruityValue ? _self.dryFruityValue : dryFruityValue // ignore: cast_nullable_to_non_nullable
as double,crispMaltyValue: null == crispMaltyValue ? _self.crispMaltyValue : crispMaltyValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStep,  double lightStrongValue,  double bitterSweetValue,  double dryFruityValue,  double crispMaltyValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentStep,_that.lightStrongValue,_that.bitterSweetValue,_that.dryFruityValue,_that.crispMaltyValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStep,  double lightStrongValue,  double bitterSweetValue,  double dryFruityValue,  double crispMaltyValue)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.currentStep,_that.lightStrongValue,_that.bitterSweetValue,_that.dryFruityValue,_that.crispMaltyValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStep,  double lightStrongValue,  double bitterSweetValue,  double dryFruityValue,  double crispMaltyValue)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentStep,_that.lightStrongValue,_that.bitterSweetValue,_that.dryFruityValue,_that.crispMaltyValue);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.currentStep = 0, this.lightStrongValue = 50.0, this.bitterSweetValue = 50.0, this.dryFruityValue = 50.0, this.crispMaltyValue = 50.0});
  

@override@JsonKey() final  int currentStep;
@override@JsonKey() final  double lightStrongValue;
@override@JsonKey() final  double bitterSweetValue;
@override@JsonKey() final  double dryFruityValue;
@override@JsonKey() final  double crispMaltyValue;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.lightStrongValue, lightStrongValue) || other.lightStrongValue == lightStrongValue)&&(identical(other.bitterSweetValue, bitterSweetValue) || other.bitterSweetValue == bitterSweetValue)&&(identical(other.dryFruityValue, dryFruityValue) || other.dryFruityValue == dryFruityValue)&&(identical(other.crispMaltyValue, crispMaltyValue) || other.crispMaltyValue == crispMaltyValue));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,lightStrongValue,bitterSweetValue,dryFruityValue,crispMaltyValue);

@override
String toString() {
  return 'OnboardingState(currentStep: $currentStep, lightStrongValue: $lightStrongValue, bitterSweetValue: $bitterSweetValue, dryFruityValue: $dryFruityValue, crispMaltyValue: $crispMaltyValue)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, double lightStrongValue, double bitterSweetValue, double dryFruityValue, double crispMaltyValue
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? lightStrongValue = null,Object? bitterSweetValue = null,Object? dryFruityValue = null,Object? crispMaltyValue = null,}) {
  return _then(_OnboardingState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,lightStrongValue: null == lightStrongValue ? _self.lightStrongValue : lightStrongValue // ignore: cast_nullable_to_non_nullable
as double,bitterSweetValue: null == bitterSweetValue ? _self.bitterSweetValue : bitterSweetValue // ignore: cast_nullable_to_non_nullable
as double,dryFruityValue: null == dryFruityValue ? _self.dryFruityValue : dryFruityValue // ignore: cast_nullable_to_non_nullable
as double,crispMaltyValue: null == crispMaltyValue ? _self.crispMaltyValue : crispMaltyValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
