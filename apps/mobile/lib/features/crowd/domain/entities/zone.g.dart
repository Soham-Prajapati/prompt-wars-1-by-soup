// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Zone _$ZoneFromJson(Map<String, dynamic> json) => _Zone(
  id: json['id'] as String,
  venueId: json['venueId'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  maxCapacity: (json['maxCapacity'] as num).toInt(),
  beaconIds:
      (json['beaconIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  geometry: json['geometry'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$ZoneToJson(_Zone instance) => <String, dynamic>{
  'id': instance.id,
  'venueId': instance.venueId,
  'name': instance.name,
  'type': instance.type,
  'maxCapacity': instance.maxCapacity,
  'beaconIds': instance.beaconIds,
  'geometry': instance.geometry,
};

_ZoneDensitySnapshot _$ZoneDensitySnapshotFromJson(Map<String, dynamic> json) =>
    _ZoneDensitySnapshot(
      zoneId: json['zoneId'] as String,
      density: (json['density'] as num).toDouble(),
      personCount: (json['personCount'] as num).toInt(),
      predicted8min: (json['predicted8min'] as num).toDouble(),
      source: $enumDecode(_$DataSourceEnumMap, json['source']),
      alertLevel: $enumDecode(_$AlertLevelEnumMap, json['alertLevel']),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );

Map<String, dynamic> _$ZoneDensitySnapshotToJson(
  _ZoneDensitySnapshot instance,
) => <String, dynamic>{
  'zoneId': instance.zoneId,
  'density': instance.density,
  'personCount': instance.personCount,
  'predicted8min': instance.predicted8min,
  'source': _$DataSourceEnumMap[instance.source]!,
  'alertLevel': _$AlertLevelEnumMap[instance.alertLevel]!,
  'recordedAt': instance.recordedAt.toIso8601String(),
};

const _$DataSourceEnumMap = {
  DataSource.ble: 'ble',
  DataSource.wifi: 'wifi',
  DataSource.cctv: 'cctv',
  DataSource.pos: 'pos',
};

const _$AlertLevelEnumMap = {
  AlertLevel.low: 'low',
  AlertLevel.moderate: 'moderate',
  AlertLevel.high: 'high',
  AlertLevel.critical: 'critical',
};
