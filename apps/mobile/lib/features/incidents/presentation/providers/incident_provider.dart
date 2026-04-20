import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stadium_iq/features/crowd/domain/entities/zone.dart';

// ── Incident entity ────────────────────────────────────────────────────────────
enum IncidentType { medical, fight, fire, lostPerson, crowdCrush, other }
enum IncidentStatus { active, responding, resolved }

class Incident {
  final String id;
  final String venueId;
  final String zoneId;
  final IncidentType type;
  final int severity;   // 1-4
  final IncidentStatus status;
  final String? geminiInstruction;
  final DateTime createdAt;

  const Incident({
    required this.id,
    required this.venueId,
    required this.zoneId,
    required this.type,
    required this.severity,
    required this.status,
    this.geminiInstruction,
    required this.createdAt,
  });
}

// ── Incident notifier ──────────────────────────────────────────────────────────
class IncidentNotifier extends AsyncNotifier<List<Incident>> {
  @override
  Future<List<Incident>> build() async {
    // TODO: subscribe to Supabase Realtime incidents channel
    return [];
  }

  void addFromRealtime(Map<String, dynamic> payload) {
    final incident = Incident(
      id: payload['id'],
      venueId: payload['venue_id'],
      zoneId: payload['zone_id'],
      type: IncidentType.values.firstWhere(
        (t) => t.name == payload['type'],
        orElse: () => IncidentType.other,
      ),
      severity: payload['severity'] as int,
      status: IncidentStatus.active,
      geminiInstruction: payload['gemini_instruction'],
      createdAt: DateTime.parse(payload['created_at']),
    );
    final current = state.valueOrNull ?? [];
    state = AsyncData([incident, ...current]);
  }
}

final incidentProvider =
    AsyncNotifierProvider<IncidentNotifier, List<Incident>>(
  IncidentNotifier.new,
);

final activeIncidentsProvider = Provider<List<Incident>>((ref) {
  final incidents = ref.watch(incidentProvider).valueOrNull ?? [];
  return incidents.where((i) => i.status == IncidentStatus.active).toList();
});

final criticalIncidentsProvider = Provider<List<Incident>>((ref) {
  return ref.watch(activeIncidentsProvider)
      .where((i) => i.severity >= 3)
      .toList();
});
