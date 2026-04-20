import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

enum OrderStatus { pending, confirmed, preparing, delivering, delivered, cancelled }

@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required String stallId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String seatZone,
    required String seatNumber,
    @Default(OrderStatus.pending) OrderStatus status,
    String? paymentId,
    String? trackingWsUrl,
    DateTime? createdAt,
    DateTime? deliveredAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
abstract class QueueInfo with _$QueueInfo {
  const factory QueueInfo({
    required String stallId,
    required String stallName,
    required double waitMins,
    required int queueLength,
    required double forecast15min,
    required String source,
    @Default([]) List<String> alternativeStallIds,
  }) = _QueueInfo;

  factory QueueInfo.fromJson(Map<String, dynamic> json) =>
      _$QueueInfoFromJson(json);
}
