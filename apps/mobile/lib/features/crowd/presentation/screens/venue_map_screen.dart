import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stadium_iq/features/crowd/domain/entities/zone.dart';
import 'package:stadium_iq/features/crowd/presentation/providers/zone_density_provider.dart';

class VenueMapScreen extends ConsumerWidget {
  const VenueMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesAsync = ref.watch(zoneDensityProvider);
    final avgDensity = ref.watch(avgDensityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Map'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Avg Density: ${(avgDensity * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: zonesAsync.when(
        data: (zones) {
          if (zones.isEmpty) {
            return const Center(child: Text('No zone data available.'));
          }
          return ListView.builder(
            itemCount: zones.length,
            itemBuilder: (context, index) {
              final zone = zones[index];
              return _ZoneCard(zone: zone);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading map data: $error'),
        ),
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  final ZoneDensitySnapshot zone;

  const _ZoneCard({required this.zone});

  Color _getColorForDensity(double density) {
    if (density >= 0.85) return Colors.red;
    if (density >= 0.65) return Colors.orange;
    if (density >= 0.40) return Colors.yellow.shade700;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForDensity(zone.density);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            '${(zone.density * 100).toInt()}%',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        title: Text(zone.zoneId, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('People: ${zone.personCount} | Source: ${zone.source.name}'),
        trailing: Icon(
          zone.alertLevel == AlertLevel.critical || zone.alertLevel == AlertLevel.high
              ? Icons.warning
              : Icons.check_circle,
          color: color,
        ),
      ),
    );
  }
}
