// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termijn.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Termijn _$$_TermijnFromJson(Map<String, dynamic> json) => _$_Termijn(
      startPeriode: DateTime.parse(json['startPeriode'] as String),
      eindPeriode: DateTime.parse(json['eindPeriode'] as String),
      startDatum: DateTime.parse(json['startDatum'] as String),
      eindDatum: DateTime.parse(json['eindDatum'] as String),
      hypotheekVorm: $enumDecode(_$HypotheekVormEnumMap, json['hypotheekVorm']),
      rente: (json['rente'] as num).toDouble(),
      extraAflossenIngevuld: (json['extraAflossenIngevuld'] as num).toDouble(),
      maandRenteBedragRatio: (json['maandRenteBedragRatio'] as num).toDouble(),
      lening: (json['lening'] as num).toDouble(),
      aflossen: (json['aflossen'] as num).toDouble(),
      extraAflossen: (json['extraAflossen'] as num).toDouble(),
      nettoMaand: (json['nettoMaand'] as num).toDouble(),
      volledigAfgelost: json['volledigAfgelost'] as bool? ?? false,
      periode: json['periode'] as int,
      aflossenTotaal: (json['aflossenTotaal'] as num).toDouble(),
      renteTotaal: (json['renteTotaal'] as num).toDouble(),
    );

Map<String, dynamic> _$$_TermijnToJson(_$_Termijn instance) =>
    <String, dynamic>{
      'startPeriode': instance.startPeriode.toIso8601String(),
      'eindPeriode': instance.eindPeriode.toIso8601String(),
      'startDatum': instance.startDatum.toIso8601String(),
      'eindDatum': instance.eindDatum.toIso8601String(),
      'hypotheekVorm': _$HypotheekVormEnumMap[instance.hypotheekVorm]!,
      'rente': instance.rente,
      'extraAflossenIngevuld': instance.extraAflossenIngevuld,
      'maandRenteBedragRatio': instance.maandRenteBedragRatio,
      'lening': instance.lening,
      'aflossen': instance.aflossen,
      'extraAflossen': instance.extraAflossen,
      'nettoMaand': instance.nettoMaand,
      'volledigAfgelost': instance.volledigAfgelost,
      'periode': instance.periode,
      'aflossenTotaal': instance.aflossenTotaal,
      'renteTotaal': instance.renteTotaal,
    };

const _$HypotheekVormEnumMap = {
  HypotheekVorm.aflosvrij: 'aflosvrij',
  HypotheekVorm.linear: 'linear',
  HypotheekVorm.annuity: 'annuity',
};
