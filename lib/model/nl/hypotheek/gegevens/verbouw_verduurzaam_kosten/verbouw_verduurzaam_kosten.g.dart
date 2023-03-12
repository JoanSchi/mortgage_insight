// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verbouw_verduurzaam_kosten.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_VerbouwVerduurzaamKosten _$$_VerbouwVerduurzaamKostenFromJson(
        Map<String, dynamic> json) =>
    _$_VerbouwVerduurzaamKosten(
      kosten: json['kosten'] == null
          ? const IListConst([])
          : IList<Waarde>.fromJson(json['kosten'],
              (value) => Waarde.fromJson(value as Map<String, dynamic>)),
      energieClassificering: json['energieClassificering'] as String? ?? '',
      toepassen: json['toepassen'] as bool? ?? false,
      taxatie: (json['taxatie'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_VerbouwVerduurzaamKostenToJson(
        _$_VerbouwVerduurzaamKosten instance) =>
    <String, dynamic>{
      'kosten': instance.kosten.toJson(
        (value) => value,
      ),
      'energieClassificering': instance.energieClassificering,
      'toepassen': instance.toepassen,
      'taxatie': instance.taxatie,
    };
