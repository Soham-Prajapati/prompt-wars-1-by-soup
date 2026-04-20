import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stadium_iq/features/crowd/domain/entities/zone.dart';
import 'package:stadium_iq/features/crowd/presentation/providers/zone_density_provider.dart';
import 'package:stadium_iq/features/orders/presentation/providers/order_provider.dart';
import 'package:stadium_iq/features/orders/domain/entities/order.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

ZoneDensitySnapshot _makeZone(String id, double density) =>
    ZoneDensitySnapshot(
      zoneId: id,
      density: density,
      personCount: (density * 1000).toInt(),
      predicted8min: density + 0.05,
      source: DataSource.wifi,
      alertLevel: density >= 0.85
          ? AlertLevel.critical
          : density >= 0.70
              ? AlertLevel.high
              : AlertLevel.low,
      recordedAt: DateTime.now(),
    );

// ── ZoneDensityProvider tests ─────────────────────────────────────────────────

void main() {
  group('ZoneDensityProvider', () {
    test('starts with empty list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = await container.read(zoneDensityProvider.future);
      expect(state, isEmpty);
    });

    test('criticalZonesProvider filters zones with density >= 0.85', () {
      final container = ProviderContainer(
        overrides: [
          zoneDensityProvider.overrideWith(() => _FakeZoneDensityNotifier([
            _makeZone('Z1', 0.40),
            _makeZone('Z2', 0.88),
            _makeZone('Z3', 0.95),
            _makeZone('Z4', 0.60),
          ])),
        ],
      );
      addTearDown(container.dispose);

      final critical = container.read(criticalZonesProvider);
      expect(critical.length, 2);
      expect(critical.map((z) => z.zoneId), containsAll(['Z2', 'Z3']));
    });

    test('avgDensityProvider calculates correct average', () {
      final zones = [
        _makeZone('Z1', 0.4),
        _makeZone('Z2', 0.6),
        _makeZone('Z3', 0.8),
      ];
      final container = ProviderContainer(
        overrides: [
          zoneDensityProvider
              .overrideWith(() => _FakeZoneDensityNotifier(zones)),
        ],
      );
      addTearDown(container.dispose);

      final avg = container.read(avgDensityProvider);
      expect(avg, closeTo(0.6, 0.01));
    });

    test('updateFromRealtime replaces snapshot for matching zoneId', () async {
      final initial = [_makeZone('Z1', 0.4), _makeZone('Z2', 0.5)];
      final container = ProviderContainer(
        overrides: [
          zoneDensityProvider
              .overrideWith(() => _FakeZoneDensityNotifier(initial)),
        ],
      );
      addTearDown(container.dispose);
      
      await container.read(zoneDensityProvider.future);

      container
          .read(zoneDensityProvider.notifier)
          .updateFromRealtime(_makeZone('Z1', 0.91).toJson());

      final updated = container.read(zoneDensityProvider).value!;
      final z1 = updated.firstWhere((z) => z.zoneId == 'Z1');
      expect(z1.density, closeTo(0.91, 0.001));
    });
  });

  // ── OrderProvider tests ───────────────────────────────────────────────────
  group('OrderProvider', () {
    test('starts with empty list', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final orders = await container.read(orderProvider.future);
      expect(orders, isEmpty);
    });

    test('activeOrderProvider returns null when no orders', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(activeOrderProvider), isNull);
    });

    test('updateStatus changes order status correctly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      await container.read(orderProvider.future);

      final orderId = await container.read(orderProvider.notifier).placeOrder(
        stallId: 'S1',
        items: [{'name': 'Burger', 'price': 120}],
        seatZone: 'A',
        seatNumber: '12',
      );

      expect(orderId, isNotNull);

      container
          .read(orderProvider.notifier)
          .updateStatus(orderId!, OrderStatus.preparing);

      final orders = container.read(orderProvider).value!;
      final order = orders.firstWhere((o) => o.id == orderId);
      expect(order.status, OrderStatus.preparing);
    });

    test('cancelled order does not appear in activeOrderProvider', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final orderId = await container.read(orderProvider.notifier).placeOrder(
        stallId: 'S2',
        items: [{'name': 'Tea', 'price': 30}],
        seatZone: 'B',
        seatNumber: '5',
      );
      container
          .read(orderProvider.notifier)
          .updateStatus(orderId!, OrderStatus.cancelled);

      expect(container.read(activeOrderProvider), isNull);
    });
  });
}

// ── Fake notifier for test overrides ──────────────────────────────────────────

class _FakeZoneDensityNotifier extends ZoneDensityNotifier {
  final List<ZoneDensitySnapshot> _zones;
  _FakeZoneDensityNotifier(this._zones);

  @override
  Future<List<ZoneDensitySnapshot>> build() async => _zones;
}
