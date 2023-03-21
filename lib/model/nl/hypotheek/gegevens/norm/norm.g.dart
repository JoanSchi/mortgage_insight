// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'norm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NormInkomen _$$NormInkomenFromJson(Map<String, dynamic> json) =>
    _$NormInkomen(
      omschrijving: json['omschrijving'] as String,
      totaal: (json['totaal'] as num?)?.toDouble() ?? 0.0,
      resterend: (json['resterend'] as num?)?.toDouble() ?? 0.0,
      toepassen: json['toepassen'] ?? false,
      parameters: json['parameters'] ?? const IMapConst({}),
      bericht: json['bericht'] ?? const IListConst([]),
      periode: json['periode'] as int? ?? 0,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NormInkomenToJson(_$NormInkomen instance) =>
    <String, dynamic>{
      'omschrijving': instance.omschrijving,
      'totaal': instance.totaal,
      'resterend': instance.resterend,
      'toepassen': instance.toepassen,
      'parameters': instance.parameters,
      'bericht': instance.bericht,
      'periode': instance.periode,
      'runtimeType': instance.$type,
    };

_$NormWoningwaarde _$$NormWoningwaardeFromJson(Map<String, dynamic> json) =>
    _$NormWoningwaarde(
      omschrijving: json['omschrijving'] as String,
      totaal: (json['totaal'] as num?)?.toDouble() ?? 0.0,
      verduurzaam: (json['verduurzaam'] as num?)?.toDouble() ?? 0.0,
      resterend: (json['resterend'] as num?)?.toDouble() ?? 0.0,
      toepassen: json['toepassen'] ?? false,
      parameters: json['parameters'] ?? const IMapConst({}),
      bericht: json['bericht'] ?? const IListConst([]),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NormWoningwaardeToJson(_$NormWoningwaarde instance) =>
    <String, dynamic>{
      'omschrijving': instance.omschrijving,
      'totaal': instance.totaal,
      'verduurzaam': instance.verduurzaam,
      'resterend': instance.resterend,
      'toepassen': instance.toepassen,
      'parameters': instance.parameters,
      'bericht': instance.bericht,
      'runtimeType': instance.$type,
    };

_$NormNhg _$$NormNhgFromJson(Map<String, dynamic> json) => _$NormNhg(
      omschrijving: json['omschrijving'] as String,
      totaal: (json['totaal'] as num?)?.toDouble() ?? 0.0,
      verduurzaam: (json['verduurzaam'] as num?)?.toDouble() ?? 0.0,
      resterend: (json['resterend'] as num?)?.toDouble() ?? 0.0,
      toepassen: json['toepassen'] ?? false,
      parameters: json['parameters'] ?? const IMapConst({}),
      bericht: json['bericht'] ?? const IListConst([]),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NormNhgToJson(_$NormNhg instance) => <String, dynamic>{
      'omschrijving': instance.omschrijving,
      'totaal': instance.totaal,
      'verduurzaam': instance.verduurzaam,
      'resterend': instance.resterend,
      'toepassen': instance.toepassen,
      'parameters': instance.parameters,
      'bericht': instance.bericht,
      'runtimeType': instance.$type,
    };
