// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Zone {

 String get id; String get venueId; String get name; String get type; int get maxCapacity; List<String> get beaconIds; Map<String, dynamic> get geometry;
/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneCopyWith<Zone> get copyWith => _$ZoneCopyWithImpl<Zone>(this as Zone, _$identity);

  /// Serializes this Zone to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Zone&&(identical(other.id, id) || other.id == id)&&(identical(other.venueId, venueId) || other.venueId == venueId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.maxCapacity, maxCapacity) || other.maxCapacity == maxCapacity)&&const DeepCollectionEquality().equals(other.beaconIds, beaconIds)&&const DeepCollectionEquality().equals(other.geometry, geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,venueId,name,type,maxCapacity,const DeepCollectionEquality().hash(beaconIds),const DeepCollectionEquality().hash(geometry));

@override
String toString() {
  return 'Zone(id: $id, venueId: $venueId, name: $name, type: $type, maxCapacity: $maxCapacity, beaconIds: $beaconIds, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class $ZoneCopyWith<$Res>  {
  factory $ZoneCopyWith(Zone value, $Res Function(Zone) _then) = _$ZoneCopyWithImpl;
@useResult
$Res call({
 String id, String venueId, String name, String type, int maxCapacity, List<String> beaconIds, Map<String, dynamic> geometry
});




}
/// @nodoc
class _$ZoneCopyWithImpl<$Res>
    implements $ZoneCopyWith<$Res> {
  _$ZoneCopyWithImpl(this._self, this._then);

  final Zone _self;
  final $Res Function(Zone) _then;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? venueId = null,Object? name = null,Object? type = null,Object? maxCapacity = null,Object? beaconIds = null,Object? geometry = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,venueId: null == venueId ? _self.venueId : venueId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,maxCapacity: null == maxCapacity ? _self.maxCapacity : maxCapacity // ignore: cast_nullable_to_non_nullable
as int,beaconIds: null == beaconIds ? _self.beaconIds : beaconIds // ignore: cast_nullable_to_non_nullable
as List<String>,geometry: null == geometry ? _self.geometry : geometry // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [Zone].
extension ZonePatterns on Zone {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Zone value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Zone() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Zone value)  $default,){
final _that = this;
switch (_that) {
case _Zone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Zone value)?  $default,){
final _that = this;
switch (_that) {
case _Zone() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String venueId,  String name,  String type,  int maxCapacity,  List<String> beaconIds,  Map<String, dynamic> geometry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Zone() when $default != null:
return $default(_that.id,_that.venueId,_that.name,_that.type,_that.maxCapacity,_that.beaconIds,_that.geometry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String venueId,  String name,  String type,  int maxCapacity,  List<String> beaconIds,  Map<String, dynamic> geometry)  $default,) {final _that = this;
switch (_that) {
case _Zone():
return $default(_that.id,_that.venueId,_that.name,_that.type,_that.maxCapacity,_that.beaconIds,_that.geometry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String venueId,  String name,  String type,  int maxCapacity,  List<String> beaconIds,  Map<String, dynamic> geometry)?  $default,) {final _that = this;
switch (_that) {
case _Zone() when $default != null:
return $default(_that.id,_that.venueId,_that.name,_that.type,_that.maxCapacity,_that.beaconIds,_that.geometry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Zone implements Zone {
  const _Zone({required this.id, required this.venueId, required this.name, required this.type, required this.maxCapacity, final  List<String> beaconIds = const [], final  Map<String, dynamic> geometry = const {}}): _beaconIds = beaconIds,_geometry = geometry;
  factory _Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);

@override final  String id;
@override final  String venueId;
@override final  String name;
@override final  String type;
@override final  int maxCapacity;
 final  List<String> _beaconIds;
@override@JsonKey() List<String> get beaconIds {
  if (_beaconIds is EqualUnmodifiableListView) return _beaconIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_beaconIds);
}

 final  Map<String, dynamic> _geometry;
@override@JsonKey() Map<String, dynamic> get geometry {
  if (_geometry is EqualUnmodifiableMapView) return _geometry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_geometry);
}


/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneCopyWith<_Zone> get copyWith => __$ZoneCopyWithImpl<_Zone>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZoneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Zone&&(identical(other.id, id) || other.id == id)&&(identical(other.venueId, venueId) || other.venueId == venueId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.maxCapacity, maxCapacity) || other.maxCapacity == maxCapacity)&&const DeepCollectionEquality().equals(other._beaconIds, _beaconIds)&&const DeepCollectionEquality().equals(other._geometry, _geometry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,venueId,name,type,maxCapacity,const DeepCollectionEquality().hash(_beaconIds),const DeepCollectionEquality().hash(_geometry));

@override
String toString() {
  return 'Zone(id: $id, venueId: $venueId, name: $name, type: $type, maxCapacity: $maxCapacity, beaconIds: $beaconIds, geometry: $geometry)';
}


}

/// @nodoc
abstract mixin class _$ZoneCopyWith<$Res> implements $ZoneCopyWith<$Res> {
  factory _$ZoneCopyWith(_Zone value, $Res Function(_Zone) _then) = __$ZoneCopyWithImpl;
@override @useResult
$Res call({
 String id, String venueId, String name, String type, int maxCapacity, List<String> beaconIds, Map<String, dynamic> geometry
});




}
/// @nodoc
class __$ZoneCopyWithImpl<$Res>
    implements _$ZoneCopyWith<$Res> {
  __$ZoneCopyWithImpl(this._self, this._then);

  final _Zone _self;
  final $Res Function(_Zone) _then;

/// Create a copy of Zone
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? venueId = null,Object? name = null,Object? type = null,Object? maxCapacity = null,Object? beaconIds = null,Object? geometry = null,}) {
  return _then(_Zone(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,venueId: null == venueId ? _self.venueId : venueId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,maxCapacity: null == maxCapacity ? _self.maxCapacity : maxCapacity // ignore: cast_nullable_to_non_nullable
as int,beaconIds: null == beaconIds ? _self._beaconIds : beaconIds // ignore: cast_nullable_to_non_nullable
as List<String>,geometry: null == geometry ? _self._geometry : geometry // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$ZoneDensitySnapshot {

 String get zoneId; double get density; int get personCount; double get predicted8min; DataSource get source; AlertLevel get alertLevel; DateTime get recordedAt;
/// Create a copy of ZoneDensitySnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneDensitySnapshotCopyWith<ZoneDensitySnapshot> get copyWith => _$ZoneDensitySnapshotCopyWithImpl<ZoneDensitySnapshot>(this as ZoneDensitySnapshot, _$identity);

  /// Serializes this ZoneDensitySnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneDensitySnapshot&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.density, density) || other.density == density)&&(identical(other.personCount, personCount) || other.personCount == personCount)&&(identical(other.predicted8min, predicted8min) || other.predicted8min == predicted8min)&&(identical(other.source, source) || other.source == source)&&(identical(other.alertLevel, alertLevel) || other.alertLevel == alertLevel)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,zoneId,density,personCount,predicted8min,source,alertLevel,recordedAt);

@override
String toString() {
  return 'ZoneDensitySnapshot(zoneId: $zoneId, density: $density, personCount: $personCount, predicted8min: $predicted8min, source: $source, alertLevel: $alertLevel, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class $ZoneDensitySnapshotCopyWith<$Res>  {
  factory $ZoneDensitySnapshotCopyWith(ZoneDensitySnapshot value, $Res Function(ZoneDensitySnapshot) _then) = _$ZoneDensitySnapshotCopyWithImpl;
@useResult
$Res call({
 String zoneId, double density, int personCount, double predicted8min, DataSource source, AlertLevel alertLevel, DateTime recordedAt
});




}
/// @nodoc
class _$ZoneDensitySnapshotCopyWithImpl<$Res>
    implements $ZoneDensitySnapshotCopyWith<$Res> {
  _$ZoneDensitySnapshotCopyWithImpl(this._self, this._then);

  final ZoneDensitySnapshot _self;
  final $Res Function(ZoneDensitySnapshot) _then;

/// Create a copy of ZoneDensitySnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zoneId = null,Object? density = null,Object? personCount = null,Object? predicted8min = null,Object? source = null,Object? alertLevel = null,Object? recordedAt = null,}) {
  return _then(_self.copyWith(
zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,density: null == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as double,personCount: null == personCount ? _self.personCount : personCount // ignore: cast_nullable_to_non_nullable
as int,predicted8min: null == predicted8min ? _self.predicted8min : predicted8min // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DataSource,alertLevel: null == alertLevel ? _self.alertLevel : alertLevel // ignore: cast_nullable_to_non_nullable
as AlertLevel,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ZoneDensitySnapshot].
extension ZoneDensitySnapshotPatterns on ZoneDensitySnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZoneDensitySnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZoneDensitySnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZoneDensitySnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ZoneDensitySnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZoneDensitySnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ZoneDensitySnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String zoneId,  double density,  int personCount,  double predicted8min,  DataSource source,  AlertLevel alertLevel,  DateTime recordedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZoneDensitySnapshot() when $default != null:
return $default(_that.zoneId,_that.density,_that.personCount,_that.predicted8min,_that.source,_that.alertLevel,_that.recordedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String zoneId,  double density,  int personCount,  double predicted8min,  DataSource source,  AlertLevel alertLevel,  DateTime recordedAt)  $default,) {final _that = this;
switch (_that) {
case _ZoneDensitySnapshot():
return $default(_that.zoneId,_that.density,_that.personCount,_that.predicted8min,_that.source,_that.alertLevel,_that.recordedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String zoneId,  double density,  int personCount,  double predicted8min,  DataSource source,  AlertLevel alertLevel,  DateTime recordedAt)?  $default,) {final _that = this;
switch (_that) {
case _ZoneDensitySnapshot() when $default != null:
return $default(_that.zoneId,_that.density,_that.personCount,_that.predicted8min,_that.source,_that.alertLevel,_that.recordedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZoneDensitySnapshot implements ZoneDensitySnapshot {
  const _ZoneDensitySnapshot({required this.zoneId, required this.density, required this.personCount, required this.predicted8min, required this.source, required this.alertLevel, required this.recordedAt});
  factory _ZoneDensitySnapshot.fromJson(Map<String, dynamic> json) => _$ZoneDensitySnapshotFromJson(json);

@override final  String zoneId;
@override final  double density;
@override final  int personCount;
@override final  double predicted8min;
@override final  DataSource source;
@override final  AlertLevel alertLevel;
@override final  DateTime recordedAt;

/// Create a copy of ZoneDensitySnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneDensitySnapshotCopyWith<_ZoneDensitySnapshot> get copyWith => __$ZoneDensitySnapshotCopyWithImpl<_ZoneDensitySnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZoneDensitySnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZoneDensitySnapshot&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.density, density) || other.density == density)&&(identical(other.personCount, personCount) || other.personCount == personCount)&&(identical(other.predicted8min, predicted8min) || other.predicted8min == predicted8min)&&(identical(other.source, source) || other.source == source)&&(identical(other.alertLevel, alertLevel) || other.alertLevel == alertLevel)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,zoneId,density,personCount,predicted8min,source,alertLevel,recordedAt);

@override
String toString() {
  return 'ZoneDensitySnapshot(zoneId: $zoneId, density: $density, personCount: $personCount, predicted8min: $predicted8min, source: $source, alertLevel: $alertLevel, recordedAt: $recordedAt)';
}


}

/// @nodoc
abstract mixin class _$ZoneDensitySnapshotCopyWith<$Res> implements $ZoneDensitySnapshotCopyWith<$Res> {
  factory _$ZoneDensitySnapshotCopyWith(_ZoneDensitySnapshot value, $Res Function(_ZoneDensitySnapshot) _then) = __$ZoneDensitySnapshotCopyWithImpl;
@override @useResult
$Res call({
 String zoneId, double density, int personCount, double predicted8min, DataSource source, AlertLevel alertLevel, DateTime recordedAt
});




}
/// @nodoc
class __$ZoneDensitySnapshotCopyWithImpl<$Res>
    implements _$ZoneDensitySnapshotCopyWith<$Res> {
  __$ZoneDensitySnapshotCopyWithImpl(this._self, this._then);

  final _ZoneDensitySnapshot _self;
  final $Res Function(_ZoneDensitySnapshot) _then;

/// Create a copy of ZoneDensitySnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zoneId = null,Object? density = null,Object? personCount = null,Object? predicted8min = null,Object? source = null,Object? alertLevel = null,Object? recordedAt = null,}) {
  return _then(_ZoneDensitySnapshot(
zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,density: null == density ? _self.density : density // ignore: cast_nullable_to_non_nullable
as double,personCount: null == personCount ? _self.personCount : personCount // ignore: cast_nullable_to_non_nullable
as int,predicted8min: null == predicted8min ? _self.predicted8min : predicted8min // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as DataSource,alertLevel: null == alertLevel ? _self.alertLevel : alertLevel // ignore: cast_nullable_to_non_nullable
as AlertLevel,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
