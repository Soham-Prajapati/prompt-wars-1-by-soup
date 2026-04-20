import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';
part 'zone.g.dart';

enum AlertLevel { low, moderate, high, critical }
enum DataSource { ble, wifi, cctv, pos }

@freezed
abstract class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String venueId,
    required String name,
    required String type,
    required int maxCapacity,
    @Default([]) List<String> beaconIds,
    @Default({}) Map<String, dynamic> geometry,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
}

@freezed
abstract class ZoneDensitySnapshot with _$ZoneDensitySnapshot {
  const factory ZoneDensitySnapshot({
    required String zoneId,
    required double density,
    required int personCount,
    required double predicted8min,
    required DataSource source,
    required AlertLevel alertLevel,
    required DateTime recordedAt,
  }) = _ZoneDensitySnapshot;

  factory ZoneDensitySnapshot.fromJson(Map<String, dynamic> json) =>
      _$ZoneDensitySnapshotFromJson(json);
}
