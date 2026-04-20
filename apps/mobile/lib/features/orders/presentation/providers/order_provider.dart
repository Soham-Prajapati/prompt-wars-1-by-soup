import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stadium_iq/features/orders/domain/entities/order.dart';

class OrderNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async => [];

  Future<String?> placeOrder({
    required String stallId,
    required List<Map<String, dynamic>> items,
    required String seatZone,
    required String seatNumber,
  }) async {
    state = const AsyncLoading();
    try {
      // : call POST /orders via Dio
      final mockOrder = Order(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current_user',
        stallId: stallId,
        items: items,
        totalAmount: items.fold(0.0, (sum, i) => sum + (i['price'] as num)),
        seatZone: seatZone,
        seatNumber: seatNumber,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
      );
      final current = state.value ?? [];
      state = AsyncData([...current, mockOrder]);
      return mockOrder.id;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  void updateStatus(String orderId, OrderStatus newStatus) {
    final current = state.value ?? [];
    state = AsyncData(current.map((o) {
      return o.id == orderId ? o.copyWith(status: newStatus) : o;
    }).toList());
  }
}

final orderProvider =
    AsyncNotifierProvider<OrderNotifier, List<Order>>(OrderNotifier.new);

final activeOrderProvider = Provider<Order?>((ref) {
  final orders = ref.watch(orderProvider).value ?? [];
  return orders.where((o) =>
    o.status != OrderStatus.delivered &&
    o.status != OrderStatus.cancelled).lastOrNull;
});
