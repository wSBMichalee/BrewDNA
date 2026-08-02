// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Beer {

 String get id; String get name; String get brewery; String get country; String get style; double get abv; double get rating; double get lightStrong; double get bitterSweet; double get dryFruity; String get imageUrl;
/// Create a copy of Beer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeerCopyWith<Beer> get copyWith => _$BeerCopyWithImpl<Beer>(this as Beer, _$identity);

  /// Serializes this Beer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Beer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brewery, brewery) || other.brewery == brewery)&&(identical(other.country, country) || other.country == country)&&(identical(other.style, style) || other.style == style)&&(identical(other.abv, abv) || other.abv == abv)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.lightStrong, lightStrong) || other.lightStrong == lightStrong)&&(identical(other.bitterSweet, bitterSweet) || other.bitterSweet == bitterSweet)&&(identical(other.dryFruity, dryFruity) || other.dryFruity == dryFruity)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,brewery,country,style,abv,rating,lightStrong,bitterSweet,dryFruity,imageUrl);

@override
String toString() {
  return 'Beer(id: $id, name: $name, brewery: $brewery, country: $country, style: $style, abv: $abv, rating: $rating, lightStrong: $lightStrong, bitterSweet: $bitterSweet, dryFruity: $dryFruity, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $BeerCopyWith<$Res>  {
  factory $BeerCopyWith(Beer value, $Res Function(Beer) _then) = _$BeerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String brewery, String country, String style, double abv, double rating, double lightStrong, double bitterSweet, double dryFruity, String imageUrl
});




}
/// @nodoc
class _$BeerCopyWithImpl<$Res>
    implements $BeerCopyWith<$Res> {
  _$BeerCopyWithImpl(this._self, this._then);

  final Beer _self;
  final $Res Function(Beer) _then;

/// Create a copy of Beer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brewery = null,Object? country = null,Object? style = null,Object? abv = null,Object? rating = null,Object? lightStrong = null,Object? bitterSweet = null,Object? dryFruity = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brewery: null == brewery ? _self.brewery : brewery // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String,abv: null == abv ? _self.abv : abv // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,lightStrong: null == lightStrong ? _self.lightStrong : lightStrong // ignore: cast_nullable_to_non_nullable
as double,bitterSweet: null == bitterSweet ? _self.bitterSweet : bitterSweet // ignore: cast_nullable_to_non_nullable
as double,dryFruity: null == dryFruity ? _self.dryFruity : dryFruity // ignore: cast_nullable_to_non_nullable
as double,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Beer].
extension BeerPatterns on Beer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Beer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Beer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Beer value)  $default,){
final _that = this;
switch (_that) {
case _Beer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Beer value)?  $default,){
final _that = this;
switch (_that) {
case _Beer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String brewery,  String country,  String style,  double abv,  double rating,  double lightStrong,  double bitterSweet,  double dryFruity,  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Beer() when $default != null:
return $default(_that.id,_that.name,_that.brewery,_that.country,_that.style,_that.abv,_that.rating,_that.lightStrong,_that.bitterSweet,_that.dryFruity,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String brewery,  String country,  String style,  double abv,  double rating,  double lightStrong,  double bitterSweet,  double dryFruity,  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Beer():
return $default(_that.id,_that.name,_that.brewery,_that.country,_that.style,_that.abv,_that.rating,_that.lightStrong,_that.bitterSweet,_that.dryFruity,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String brewery,  String country,  String style,  double abv,  double rating,  double lightStrong,  double bitterSweet,  double dryFruity,  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Beer() when $default != null:
return $default(_that.id,_that.name,_that.brewery,_that.country,_that.style,_that.abv,_that.rating,_that.lightStrong,_that.bitterSweet,_that.dryFruity,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Beer implements Beer {
  const _Beer({required this.id, required this.name, required this.brewery, required this.country, required this.style, required this.abv, required this.rating, required this.lightStrong, required this.bitterSweet, required this.dryFruity, required this.imageUrl});
  factory _Beer.fromJson(Map<String, dynamic> json) => _$BeerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String brewery;
@override final  String country;
@override final  String style;
@override final  double abv;
@override final  double rating;
@override final  double lightStrong;
@override final  double bitterSweet;
@override final  double dryFruity;
@override final  String imageUrl;

/// Create a copy of Beer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeerCopyWith<_Beer> get copyWith => __$BeerCopyWithImpl<_Beer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Beer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brewery, brewery) || other.brewery == brewery)&&(identical(other.country, country) || other.country == country)&&(identical(other.style, style) || other.style == style)&&(identical(other.abv, abv) || other.abv == abv)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.lightStrong, lightStrong) || other.lightStrong == lightStrong)&&(identical(other.bitterSweet, bitterSweet) || other.bitterSweet == bitterSweet)&&(identical(other.dryFruity, dryFruity) || other.dryFruity == dryFruity)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,brewery,country,style,abv,rating,lightStrong,bitterSweet,dryFruity,imageUrl);

@override
String toString() {
  return 'Beer(id: $id, name: $name, brewery: $brewery, country: $country, style: $style, abv: $abv, rating: $rating, lightStrong: $lightStrong, bitterSweet: $bitterSweet, dryFruity: $dryFruity, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$BeerCopyWith<$Res> implements $BeerCopyWith<$Res> {
  factory _$BeerCopyWith(_Beer value, $Res Function(_Beer) _then) = __$BeerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String brewery, String country, String style, double abv, double rating, double lightStrong, double bitterSweet, double dryFruity, String imageUrl
});




}
/// @nodoc
class __$BeerCopyWithImpl<$Res>
    implements _$BeerCopyWith<$Res> {
  __$BeerCopyWithImpl(this._self, this._then);

  final _Beer _self;
  final $Res Function(_Beer) _then;

/// Create a copy of Beer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brewery = null,Object? country = null,Object? style = null,Object? abv = null,Object? rating = null,Object? lightStrong = null,Object? bitterSweet = null,Object? dryFruity = null,Object? imageUrl = null,}) {
  return _then(_Beer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brewery: null == brewery ? _self.brewery : brewery // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as String,abv: null == abv ? _self.abv : abv // ignore: cast_nullable_to_non_nullable
as double,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,lightStrong: null == lightStrong ? _self.lightStrong : lightStrong // ignore: cast_nullable_to_non_nullable
as double,bitterSweet: null == bitterSweet ? _self.bitterSweet : bitterSweet // ignore: cast_nullable_to_non_nullable
as double,dryFruity: null == dryFruity ? _self.dryFruity : dryFruity // ignore: cast_nullable_to_non_nullable
as double,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
