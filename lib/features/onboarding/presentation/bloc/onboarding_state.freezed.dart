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

 int get currentStep; double get lightStrongValue; double get bitterSweetValue; double get dryFruityValue; Set<String> get selectedStyles; Set<String> get selectedCountries; String? get experienceLevel; List<String> get availableStyles; bool get isStylesLoading;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.lightStrongValue, lightStrongValue) || other.lightStrongValue == lightStrongValue)&&(identical(other.bitterSweetValue, bitterSweetValue) || other.bitterSweetValue == bitterSweetValue)&&(identical(other.dryFruityValue, dryFruityValue) || other.dryFruityValue == dryFruityValue)&&const DeepCollectionEquality().equals(other.selectedStyles, selectedStyles)&&const DeepCollectionEquality().equals(other.selectedCountries, selectedCountries)&&(identical(other.experienceLevel, experienceLevel) || other.experienceLevel == experienceLevel)&&const DeepCollectionEquality().equals(other.availableStyles, availableStyles)&&(identical(other.isStylesLoading, isStylesLoading) || other.isStylesLoading == isStylesLoading));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,lightStrongValue,bitterSweetValue,dryFruityValue,const DeepCollectionEquality().hash(selectedStyles),const DeepCollectionEquality().hash(selectedCountries),experienceLevel,const DeepCollectionEquality().hash(availableStyles),isStylesLoading);

@override
String toString() {
  return 'OnboardingState(currentStep: $currentStep, lightStrongValue: $lightStrongValue, bitterSweetValue: $bitterSweetValue, dryFruityValue: $dryFruityValue, selectedStyles: $selectedStyles, selectedCountries: $selectedCountries, experienceLevel: $experienceLevel, availableStyles: $availableStyles, isStylesLoading: $isStylesLoading)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int currentStep, double lightStrongValue, double bitterSweetValue, double dryFruityValue, Set<String> selectedStyles, Set<String> selectedCountries, String? experienceLevel, List<String> availableStyles, bool isStylesLoading
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
@pragma('vm:prefer-inline') @override $Res call({Object? currentStep = null,Object? lightStrongValue = null,Object? bitterSweetValue = null,Object? dryFruityValue = null,Object? selectedStyles = null,Object? selectedCountries = null,Object? experienceLevel = freezed,Object? availableStyles = null,Object? isStylesLoading = null,}) {
  return _then(_self.copyWith(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,lightStrongValue: null == lightStrongValue ? _self.lightStrongValue : lightStrongValue // ignore: cast_nullable_to_non_nullable
as double,bitterSweetValue: null == bitterSweetValue ? _self.bitterSweetValue : bitterSweetValue // ignore: cast_nullable_to_non_nullable
as double,dryFruityValue: null == dryFruityValue ? _self.dryFruityValue : dryFruityValue // ignore: cast_nullable_to_non_nullable
as double,selectedStyles: null == selectedStyles ? _self.selectedStyles : selectedStyles // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedCountries: null == selectedCountries ? _self.selectedCountries : selectedCountries // ignore: cast_nullable_to_non_nullable
as Set<String>,experienceLevel: freezed == experienceLevel ? _self.experienceLevel : experienceLevel // ignore: cast_nullable_to_non_nullable
as String?,availableStyles: null == availableStyles ? _self.availableStyles : availableStyles // ignore: cast_nullable_to_non_nullable
as List<String>,isStylesLoading: null == isStylesLoading ? _self.isStylesLoading : isStylesLoading // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStep,  double lightStrongValue,  double bitterSweetValue,  double dryFruityValue,  Set<String> selectedStyles,  Set<String> selectedCountries,  String? experienceLevel,  List<String> availableStyles,  bool isStylesLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentStep,_that.lightStrongValue,_that.bitterSweetValue,_that.dryFruityValue,_that.selectedStyles,_that.selectedCountries,_that.experienceLevel,_that.availableStyles,_that.isStylesLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStep,  double lightStrongValue,  double bitterSweetValue,  double dryFruityValue,  Set<String> selectedStyles,  Set<String> selectedCountries,  String? experienceLevel,  List<String> availableStyles,  bool isStylesLoading)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.currentStep,_that.lightStrongValue,_that.bitterSweetValue,_that.dryFruityValue,_that.selectedStyles,_that.selectedCountries,_that.experienceLevel,_that.availableStyles,_that.isStylesLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStep,  double lightStrongValue,  double bitterSweetValue,  double dryFruityValue,  Set<String> selectedStyles,  Set<String> selectedCountries,  String? experienceLevel,  List<String> availableStyles,  bool isStylesLoading)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.currentStep,_that.lightStrongValue,_that.bitterSweetValue,_that.dryFruityValue,_that.selectedStyles,_that.selectedCountries,_that.experienceLevel,_that.availableStyles,_that.isStylesLoading);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.currentStep = 0, this.lightStrongValue = 50.0, this.bitterSweetValue = 50.0, this.dryFruityValue = 50.0, final  Set<String> selectedStyles = const {}, final  Set<String> selectedCountries = const {}, this.experienceLevel, final  List<String> availableStyles = const [], this.isStylesLoading = false}): _selectedStyles = selectedStyles,_selectedCountries = selectedCountries,_availableStyles = availableStyles;
  

@override@JsonKey() final  int currentStep;
@override@JsonKey() final  double lightStrongValue;
@override@JsonKey() final  double bitterSweetValue;
@override@JsonKey() final  double dryFruityValue;
 final  Set<String> _selectedStyles;
@override@JsonKey() Set<String> get selectedStyles {
  if (_selectedStyles is EqualUnmodifiableSetView) return _selectedStyles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedStyles);
}

 final  Set<String> _selectedCountries;
@override@JsonKey() Set<String> get selectedCountries {
  if (_selectedCountries is EqualUnmodifiableSetView) return _selectedCountries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedCountries);
}

@override final  String? experienceLevel;
 final  List<String> _availableStyles;
@override@JsonKey() List<String> get availableStyles {
  if (_availableStyles is EqualUnmodifiableListView) return _availableStyles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableStyles);
}

@override@JsonKey() final  bool isStylesLoading;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.lightStrongValue, lightStrongValue) || other.lightStrongValue == lightStrongValue)&&(identical(other.bitterSweetValue, bitterSweetValue) || other.bitterSweetValue == bitterSweetValue)&&(identical(other.dryFruityValue, dryFruityValue) || other.dryFruityValue == dryFruityValue)&&const DeepCollectionEquality().equals(other._selectedStyles, _selectedStyles)&&const DeepCollectionEquality().equals(other._selectedCountries, _selectedCountries)&&(identical(other.experienceLevel, experienceLevel) || other.experienceLevel == experienceLevel)&&const DeepCollectionEquality().equals(other._availableStyles, _availableStyles)&&(identical(other.isStylesLoading, isStylesLoading) || other.isStylesLoading == isStylesLoading));
}


@override
int get hashCode => Object.hash(runtimeType,currentStep,lightStrongValue,bitterSweetValue,dryFruityValue,const DeepCollectionEquality().hash(_selectedStyles),const DeepCollectionEquality().hash(_selectedCountries),experienceLevel,const DeepCollectionEquality().hash(_availableStyles),isStylesLoading);

@override
String toString() {
  return 'OnboardingState(currentStep: $currentStep, lightStrongValue: $lightStrongValue, bitterSweetValue: $bitterSweetValue, dryFruityValue: $dryFruityValue, selectedStyles: $selectedStyles, selectedCountries: $selectedCountries, experienceLevel: $experienceLevel, availableStyles: $availableStyles, isStylesLoading: $isStylesLoading)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int currentStep, double lightStrongValue, double bitterSweetValue, double dryFruityValue, Set<String> selectedStyles, Set<String> selectedCountries, String? experienceLevel, List<String> availableStyles, bool isStylesLoading
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
@override @pragma('vm:prefer-inline') $Res call({Object? currentStep = null,Object? lightStrongValue = null,Object? bitterSweetValue = null,Object? dryFruityValue = null,Object? selectedStyles = null,Object? selectedCountries = null,Object? experienceLevel = freezed,Object? availableStyles = null,Object? isStylesLoading = null,}) {
  return _then(_OnboardingState(
currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,lightStrongValue: null == lightStrongValue ? _self.lightStrongValue : lightStrongValue // ignore: cast_nullable_to_non_nullable
as double,bitterSweetValue: null == bitterSweetValue ? _self.bitterSweetValue : bitterSweetValue // ignore: cast_nullable_to_non_nullable
as double,dryFruityValue: null == dryFruityValue ? _self.dryFruityValue : dryFruityValue // ignore: cast_nullable_to_non_nullable
as double,selectedStyles: null == selectedStyles ? _self._selectedStyles : selectedStyles // ignore: cast_nullable_to_non_nullable
as Set<String>,selectedCountries: null == selectedCountries ? _self._selectedCountries : selectedCountries // ignore: cast_nullable_to_non_nullable
as Set<String>,experienceLevel: freezed == experienceLevel ? _self.experienceLevel : experienceLevel // ignore: cast_nullable_to_non_nullable
as String?,availableStyles: null == availableStyles ? _self._availableStyles : availableStyles // ignore: cast_nullable_to_non_nullable
as List<String>,isStylesLoading: null == isStylesLoading ? _self.isStylesLoading : isStylesLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
