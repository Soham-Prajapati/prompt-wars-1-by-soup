// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  userId: json['userId'] as String,
  stallId: json['stallId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  seatZone: json['seatZone'] as String,
  seatNumber: json['seatNumber'] as String,
  status:
      $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
      OrderStatus.pending,
  paymentId: json['paymentId'] as String?,
  trackingWsUrl: json['trackingWsUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  deliveredAt: json['deliveredAt'] == null
      ? null
      : DateTime.parse(json['deliveredAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'stallId': instance.stallId,
  'items': instance.items,
  'totalAmount': instance.totalAmount,
  'seatZone': instance.seatZone,
  'seatNumber': instance.seatNumber,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'paymentId': instance.paymentId,
  'trackingWsUrl': instance.trackingWsUrl,
  'createdAt': instance.createdAt?.toIso8601String(),
  'deliveredAt': instance.deliveredAt?.toIso8601String(),
};

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.delivering: 'delivering',
  OrderStatus.delivered: 'delivered',
  OrderStatus.cancelled: 'cancelled',
};

_QueueInfo _$QueueInfoFromJson(Map<String, dynamic> json) => _QueueInfo(
  stallId: json['stallId'] as String,
  stallName: json['stallName'] as String,
  waitMins: (json['waitMins'] as num).toDouble(),
  queueLength: (json['queueLength'] as num).toInt(),
  forecast15min: (json['forecast15min'] as num).toDouble(),
  source: json['source'] as String,
  alternativeStallIds:
      (json['alternativeStallIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$QueueInfoToJson(_QueueInfo instance) =>
    <String, dynamic>{
      'stallId': instance.stallId,
      'stallName': instance.stallName,
      'waitMins': instance.waitMins,
      'queueLength': instance.queueLength,
      'forecast15min': instance.forecast15min,
      'source': instance.source,
      'alternativeStallIds': instance.alternativeStallIds,
    };
