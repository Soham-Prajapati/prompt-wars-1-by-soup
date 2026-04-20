import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stadium_iq/features/crowd/domain/entities/zone.dart';

// ── Zone density state ─────────────────────────────────────────────────────────

class ZoneDensityNotifier extends AsyncNotifier<List<ZoneDensitySnapshot>> {
  @override
  Future<List<ZoneDensitySnapshot>> build() async {
    // Subscribe to Supabase Realtime channel
    // ref.onDispose(() => _subscription?.cancel());
    return _fetchLatestDensity();
  }

  Future<List<ZoneDensitySnapshot>> _fetchLatestDensity() async {
    // TO DO: replace with Supabase Realtime subscription
    // final supabase = Supabase.instance.client;
    // return supabase.from('zone_density_snapshots')
    //   .select().order('recorded_at', ascending: false).limit(50);
    return [];
  }

  void updateFromRealtime(Map<String, dynamic> payload) {
    final snapshot = ZoneDensitySnapshot.fromJson(payload);
    final current = state.value ?? [];
    final updated = current.map((z) {
      return z.zoneId == snapshot.zoneId ? snapshot : z;
    }).toList();
    state = AsyncData(updated);
  }
}

final zoneDensityProvider =
    AsyncNotifierProvider<ZoneDensityNotifier, List<ZoneDensitySnapshot>>(
  ZoneDensityNotifier.new,
);

// ── Derived providers ──────────────────────────────────────────────────────────

final criticalZonesProvider = Provider<List<ZoneDensitySnapshot>>((ref) {
  final zones = ref.watch(zoneDensityProvider).value ?? [];
  return zones.where((z) => z.density >= 0.85).toList();
});

final avgDensityProvider = Provider<double>((ref) {
  final zones = ref.watch(zoneDensityProvider).value ?? [];
  if (zones.isEmpty) return 0.0;
  return zones.map((z) => z.density).reduce((a, b) => a + b) / zones.length;
});
