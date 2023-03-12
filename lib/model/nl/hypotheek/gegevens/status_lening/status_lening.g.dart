// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_lening.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ParallelLeningen _$$_ParallelLeningenFromJson(Map<String, dynamic> json) =>
    _$_ParallelLeningen(
      list: IList<StatusLening>.fromJson(json['list'],
          (value) => StatusLening.fromJson(value as Map<String, dynamic>)),
      somLeningen: (json['somLeningen'] as num).toDouble(),
      somVerduurzaamKosten: (json['somVerduurzaamKosten'] as num).toDouble(),
      somVerbouwKosten: (json['somVerbouwKosten'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ParallelLeningenToJson(_$_ParallelLeningen instance) =>
    <String, dynamic>{
      'list': instance.list.toJson(
        (value) => value,
      ),
      'somLeningen': instance.somLeningen,
      'somVerduurzaamKosten': instance.somVerduurzaamKosten,
      'somVerbouwKosten': instance.somVerbouwKosten,
    };

_$_StatusLening _$$_StatusLeningFromJson(Map<String, dynamic> json) =>
    _$_StatusLening(
      id: json['id'] as String,
      lening: (json['lening'] as num).toDouble(),
      periode: json['periode'] as int,
      rente: (json['rente'] as num).toDouble(),
      aflosTermijnInMaanden: json['aflosTermijnInMaanden'] as int,
      hypotheekVorm: $enumDecode(_$HypotheekVormEnumMap, json['hypotheekVorm']),
    );

Map<String, dynamic> _$$_StatusLeningToJson(_$_StatusLening instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lening': instance.lening,
      'periode': instance.periode,
      'rente': instance.rente,
      'aflosTermijnInMaanden': instance.aflosTermijnInMaanden,
      'hypotheekVorm': _$HypotheekVormEnumMap[instance.hypotheekVorm]!,
    };

const _$HypotheekVormEnumMap = {
  HypotheekVorm.aflosvrij: 'aflosvrij',
  HypotheekVorm.linear: 'linear',
  HypotheekVorm.annuity: 'annuity',
};
