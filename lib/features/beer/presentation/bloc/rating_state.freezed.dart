// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RatingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState()';
}


}

/// @nodoc
class $RatingStateCopyWith<$Res>  {
$RatingStateCopyWith(RatingState _, $Res Function(RatingState) __);
}


/// Adds pattern-matching-related methods to [RatingState].
extension RatingStatePatterns on RatingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Submitting value)?  submitting,TResult Function( _Submitted value)?  submitted,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Submitting() when submitting != null:
return submitting(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Submitting value)  submitting,required TResult Function( _Submitted value)  submitted,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Submitting():
return submitting(_that);case _Submitted():
return submitted(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Submitting value)?  submitting,TResult? Function( _Submitted value)?  submitted,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Submitting() when submitting != null:
return submitting(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( RatingHistogram histogram,  List<Review> reviews,  int? userRating)?  loaded,TResult Function()?  submitting,TResult Function()?  submitted,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.histogram,_that.reviews,_that.userRating);case _Submitting() when submitting != null:
return submitting();case _Submitted() when submitted != null:
return submitted();case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( RatingHistogram histogram,  List<Review> reviews,  int? userRating)  loaded,required TResult Function()  submitting,required TResult Function()  submitted,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.histogram,_that.reviews,_that.userRating);case _Submitting():
return submitting();case _Submitted():
return submitted();case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( RatingHistogram histogram,  List<Review> reviews,  int? userRating)?  loaded,TResult? Function()?  submitting,TResult? Function()?  submitted,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.histogram,_that.reviews,_that.userRating);case _Submitting() when submitting != null:
return submitting();case _Submitted() when submitted != null:
return submitted();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements RatingState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState.initial()';
}


}




/// @nodoc


class _Loading implements RatingState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState.loading()';
}


}




/// @nodoc


class _Loaded implements RatingState {
  const _Loaded({required this.histogram, required final  List<Review> reviews, this.userRating}): _reviews = reviews;
  

 final  RatingHistogram histogram;
 final  List<Review> _reviews;
 List<Review> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}

 final  int? userRating;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.histogram, histogram) || other.histogram == histogram)&&const DeepCollectionEquality().equals(other._reviews, _reviews)&&(identical(other.userRating, userRating) || other.userRating == userRating));
}


@override
int get hashCode => Object.hash(runtimeType,histogram,const DeepCollectionEquality().hash(_reviews),userRating);

@override
String toString() {
  return 'RatingState.loaded(histogram: $histogram, reviews: $reviews, userRating: $userRating)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $RatingStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 RatingHistogram histogram, List<Review> reviews, int? userRating
});


$RatingHistogramCopyWith<$Res> get histogram;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? histogram = null,Object? reviews = null,Object? userRating = freezed,}) {
  return _then(_Loaded(
histogram: null == histogram ? _self.histogram : histogram // ignore: cast_nullable_to_non_nullable
as RatingHistogram,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<Review>,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RatingHistogramCopyWith<$Res> get histogram {
  
  return $RatingHistogramCopyWith<$Res>(_self.histogram, (value) {
    return _then(_self.copyWith(histogram: value));
  });
}
}

/// @nodoc


class _Submitting implements RatingState {
  const _Submitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState.submitting()';
}


}




/// @nodoc


class _Submitted implements RatingState {
  const _Submitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RatingState.submitted()';
}


}




/// @nodoc


class _Error implements RatingState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'RatingState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $RatingStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of RatingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
