// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; String get userId; String get stallId; List<Map<String, dynamic>> get items; double get totalAmount; String get seatZone; String get seatNumber; OrderStatus get status; String? get paymentId; String? get trackingWsUrl; DateTime? get createdAt; DateTime? get deliveredAt;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.stallId, stallId) || other.stallId == stallId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.seatZone, seatZone) || other.seatZone == seatZone)&&(identical(other.seatNumber, seatNumber) || other.seatNumber == seatNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.trackingWsUrl, trackingWsUrl) || other.trackingWsUrl == trackingWsUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,stallId,const DeepCollectionEquality().hash(items),totalAmount,seatZone,seatNumber,status,paymentId,trackingWsUrl,createdAt,deliveredAt);

@override
String toString() {
  return 'Order(id: $id, userId: $userId, stallId: $stallId, items: $items, totalAmount: $totalAmount, seatZone: $seatZone, seatNumber: $seatNumber, status: $status, paymentId: $paymentId, trackingWsUrl: $trackingWsUrl, createdAt: $createdAt, deliveredAt: $deliveredAt)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String stallId, List<Map<String, dynamic>> items, double totalAmount, String seatZone, String seatNumber, OrderStatus status, String? paymentId, String? trackingWsUrl, DateTime? createdAt, DateTime? deliveredAt
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? stallId = null,Object? items = null,Object? totalAmount = null,Object? seatZone = null,Object? seatNumber = null,Object? status = null,Object? paymentId = freezed,Object? trackingWsUrl = freezed,Object? createdAt = freezed,Object? deliveredAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,stallId: null == stallId ? _self.stallId : stallId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,seatZone: null == seatZone ? _self.seatZone : seatZone // ignore: cast_nullable_to_non_nullable
as String,seatNumber: null == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,trackingWsUrl: freezed == trackingWsUrl ? _self.trackingWsUrl : trackingWsUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String stallId,  List<Map<String, dynamic>> items,  double totalAmount,  String seatZone,  String seatNumber,  OrderStatus status,  String? paymentId,  String? trackingWsUrl,  DateTime? createdAt,  DateTime? deliveredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.userId,_that.stallId,_that.items,_that.totalAmount,_that.seatZone,_that.seatNumber,_that.status,_that.paymentId,_that.trackingWsUrl,_that.createdAt,_that.deliveredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String stallId,  List<Map<String, dynamic>> items,  double totalAmount,  String seatZone,  String seatNumber,  OrderStatus status,  String? paymentId,  String? trackingWsUrl,  DateTime? createdAt,  DateTime? deliveredAt)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.userId,_that.stallId,_that.items,_that.totalAmount,_that.seatZone,_that.seatNumber,_that.status,_that.paymentId,_that.trackingWsUrl,_that.createdAt,_that.deliveredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String stallId,  List<Map<String, dynamic>> items,  double totalAmount,  String seatZone,  String seatNumber,  OrderStatus status,  String? paymentId,  String? trackingWsUrl,  DateTime? createdAt,  DateTime? deliveredAt)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.userId,_that.stallId,_that.items,_that.totalAmount,_that.seatZone,_that.seatNumber,_that.status,_that.paymentId,_that.trackingWsUrl,_that.createdAt,_that.deliveredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.userId, required this.stallId, required final  List<Map<String, dynamic>> items, required this.totalAmount, required this.seatZone, required this.seatNumber, this.status = OrderStatus.pending, this.paymentId, this.trackingWsUrl, this.createdAt, this.deliveredAt}): _items = items;
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String stallId;
 final  List<Map<String, dynamic>> _items;
@override List<Map<String, dynamic>> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalAmount;
@override final  String seatZone;
@override final  String seatNumber;
@override@JsonKey() final  OrderStatus status;
@override final  String? paymentId;
@override final  String? trackingWsUrl;
@override final  DateTime? createdAt;
@override final  DateTime? deliveredAt;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.stallId, stallId) || other.stallId == stallId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.seatZone, seatZone) || other.seatZone == seatZone)&&(identical(other.seatNumber, seatNumber) || other.seatNumber == seatNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.trackingWsUrl, trackingWsUrl) || other.trackingWsUrl == trackingWsUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,stallId,const DeepCollectionEquality().hash(_items),totalAmount,seatZone,seatNumber,status,paymentId,trackingWsUrl,createdAt,deliveredAt);

@override
String toString() {
  return 'Order(id: $id, userId: $userId, stallId: $stallId, items: $items, totalAmount: $totalAmount, seatZone: $seatZone, seatNumber: $seatNumber, status: $status, paymentId: $paymentId, trackingWsUrl: $trackingWsUrl, createdAt: $createdAt, deliveredAt: $deliveredAt)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String stallId, List<Map<String, dynamic>> items, double totalAmount, String seatZone, String seatNumber, OrderStatus status, String? paymentId, String? trackingWsUrl, DateTime? createdAt, DateTime? deliveredAt
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? stallId = null,Object? items = null,Object? totalAmount = null,Object? seatZone = null,Object? seatNumber = null,Object? status = null,Object? paymentId = freezed,Object? trackingWsUrl = freezed,Object? createdAt = freezed,Object? deliveredAt = freezed,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,stallId: null == stallId ? _self.stallId : stallId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,seatZone: null == seatZone ? _self.seatZone : seatZone // ignore: cast_nullable_to_non_nullable
as String,seatNumber: null == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,trackingWsUrl: freezed == trackingWsUrl ? _self.trackingWsUrl : trackingWsUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$QueueInfo {

 String get stallId; String get stallName; double get waitMins; int get queueLength; double get forecast15min; String get source; List<String> get alternativeStallIds;
/// Create a copy of QueueInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueInfoCopyWith<QueueInfo> get copyWith => _$QueueInfoCopyWithImpl<QueueInfo>(this as QueueInfo, _$identity);

  /// Serializes this QueueInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueInfo&&(identical(other.stallId, stallId) || other.stallId == stallId)&&(identical(other.stallName, stallName) || other.stallName == stallName)&&(identical(other.waitMins, waitMins) || other.waitMins == waitMins)&&(identical(other.queueLength, queueLength) || other.queueLength == queueLength)&&(identical(other.forecast15min, forecast15min) || other.forecast15min == forecast15min)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.alternativeStallIds, alternativeStallIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stallId,stallName,waitMins,queueLength,forecast15min,source,const DeepCollectionEquality().hash(alternativeStallIds));

@override
String toString() {
  return 'QueueInfo(stallId: $stallId, stallName: $stallName, waitMins: $waitMins, queueLength: $queueLength, forecast15min: $forecast15min, source: $source, alternativeStallIds: $alternativeStallIds)';
}


}

/// @nodoc
abstract mixin class $QueueInfoCopyWith<$Res>  {
  factory $QueueInfoCopyWith(QueueInfo value, $Res Function(QueueInfo) _then) = _$QueueInfoCopyWithImpl;
@useResult
$Res call({
 String stallId, String stallName, double waitMins, int queueLength, double forecast15min, String source, List<String> alternativeStallIds
});




}
/// @nodoc
class _$QueueInfoCopyWithImpl<$Res>
    implements $QueueInfoCopyWith<$Res> {
  _$QueueInfoCopyWithImpl(this._self, this._then);

  final QueueInfo _self;
  final $Res Function(QueueInfo) _then;

/// Create a copy of QueueInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stallId = null,Object? stallName = null,Object? waitMins = null,Object? queueLength = null,Object? forecast15min = null,Object? source = null,Object? alternativeStallIds = null,}) {
  return _then(_self.copyWith(
stallId: null == stallId ? _self.stallId : stallId // ignore: cast_nullable_to_non_nullable
as String,stallName: null == stallName ? _self.stallName : stallName // ignore: cast_nullable_to_non_nullable
as String,waitMins: null == waitMins ? _self.waitMins : waitMins // ignore: cast_nullable_to_non_nullable
as double,queueLength: null == queueLength ? _self.queueLength : queueLength // ignore: cast_nullable_to_non_nullable
as int,forecast15min: null == forecast15min ? _self.forecast15min : forecast15min // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,alternativeStallIds: null == alternativeStallIds ? _self.alternativeStallIds : alternativeStallIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueInfo].
extension QueueInfoPatterns on QueueInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueInfo value)  $default,){
final _that = this;
switch (_that) {
case _QueueInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueInfo value)?  $default,){
final _that = this;
switch (_that) {
case _QueueInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String stallId,  String stallName,  double waitMins,  int queueLength,  double forecast15min,  String source,  List<String> alternativeStallIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueInfo() when $default != null:
return $default(_that.stallId,_that.stallName,_that.waitMins,_that.queueLength,_that.forecast15min,_that.source,_that.alternativeStallIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String stallId,  String stallName,  double waitMins,  int queueLength,  double forecast15min,  String source,  List<String> alternativeStallIds)  $default,) {final _that = this;
switch (_that) {
case _QueueInfo():
return $default(_that.stallId,_that.stallName,_that.waitMins,_that.queueLength,_that.forecast15min,_that.source,_that.alternativeStallIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String stallId,  String stallName,  double waitMins,  int queueLength,  double forecast15min,  String source,  List<String> alternativeStallIds)?  $default,) {final _that = this;
switch (_that) {
case _QueueInfo() when $default != null:
return $default(_that.stallId,_that.stallName,_that.waitMins,_that.queueLength,_that.forecast15min,_that.source,_that.alternativeStallIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueInfo implements QueueInfo {
  const _QueueInfo({required this.stallId, required this.stallName, required this.waitMins, required this.queueLength, required this.forecast15min, required this.source, final  List<String> alternativeStallIds = const []}): _alternativeStallIds = alternativeStallIds;
  factory _QueueInfo.fromJson(Map<String, dynamic> json) => _$QueueInfoFromJson(json);

@override final  String stallId;
@override final  String stallName;
@override final  double waitMins;
@override final  int queueLength;
@override final  double forecast15min;
@override final  String source;
 final  List<String> _alternativeStallIds;
@override@JsonKey() List<String> get alternativeStallIds {
  if (_alternativeStallIds is EqualUnmodifiableListView) return _alternativeStallIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternativeStallIds);
}


/// Create a copy of QueueInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueInfoCopyWith<_QueueInfo> get copyWith => __$QueueInfoCopyWithImpl<_QueueInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueInfo&&(identical(other.stallId, stallId) || other.stallId == stallId)&&(identical(other.stallName, stallName) || other.stallName == stallName)&&(identical(other.waitMins, waitMins) || other.waitMins == waitMins)&&(identical(other.queueLength, queueLength) || other.queueLength == queueLength)&&(identical(other.forecast15min, forecast15min) || other.forecast15min == forecast15min)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._alternativeStallIds, _alternativeStallIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stallId,stallName,waitMins,queueLength,forecast15min,source,const DeepCollectionEquality().hash(_alternativeStallIds));

@override
String toString() {
  return 'QueueInfo(stallId: $stallId, stallName: $stallName, waitMins: $waitMins, queueLength: $queueLength, forecast15min: $forecast15min, source: $source, alternativeStallIds: $alternativeStallIds)';
}


}

/// @nodoc
abstract mixin class _$QueueInfoCopyWith<$Res> implements $QueueInfoCopyWith<$Res> {
  factory _$QueueInfoCopyWith(_QueueInfo value, $Res Function(_QueueInfo) _then) = __$QueueInfoCopyWithImpl;
@override @useResult
$Res call({
 String stallId, String stallName, double waitMins, int queueLength, double forecast15min, String source, List<String> alternativeStallIds
});




}
/// @nodoc
class __$QueueInfoCopyWithImpl<$Res>
    implements _$QueueInfoCopyWith<$Res> {
  __$QueueInfoCopyWithImpl(this._self, this._then);

  final _QueueInfo _self;
  final $Res Function(_QueueInfo) _then;

/// Create a copy of QueueInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stallId = null,Object? stallName = null,Object? waitMins = null,Object? queueLength = null,Object? forecast15min = null,Object? source = null,Object? alternativeStallIds = null,}) {
  return _then(_QueueInfo(
stallId: null == stallId ? _self.stallId : stallId // ignore: cast_nullable_to_non_nullable
as String,stallName: null == stallName ? _self.stallName : stallName // ignore: cast_nullable_to_non_nullable
as String,waitMins: null == waitMins ? _self.waitMins : waitMins // ignore: cast_nullable_to_non_nullable
as double,queueLength: null == queueLength ? _self.queueLength : queueLength // ignore: cast_nullable_to_non_nullable
as int,forecast15min: null == forecast15min ? _self.forecast15min : forecast15min // ignore: cast_nullable_to_non_nullable
as double,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,alternativeStallIds: null == alternativeStallIds ? _self._alternativeStallIds : alternativeStallIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
