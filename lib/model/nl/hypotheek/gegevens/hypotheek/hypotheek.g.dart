// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypotheek.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$$Hypotheek _$$$HypotheekFromJson(Map<String, dynamic> json) => _$$Hypotheek(
      id: json['id'] as String,
      omschrijving: json['omschrijving'] as String,
      optiesHypotheekToevoegen: $enumDecode(
          _$OptiesHypotheekToevoegenEnumMap, json['optiesHypotheekToevoegen']),
      lening: (json['lening'] as num).toDouble(),
      gewensteLening: (json['gewensteLening'] as num).toDouble(),
      maxLeningInkomen: (json['maxLeningInkomen'] as num).toDouble(),
      maxLeningWoningWaarde: (json['maxLeningWoningWaarde'] as num).toDouble(),
      maxLeningNgh: (json['maxLeningNgh'] as num?)?.toDouble() ?? 0.0,
      toepassenNhg: json['toepassenNhg'] as bool? ?? true,
      startDatum: DateTime.parse(json['startDatum'] as String),
      startDatumAflossen: DateTime.parse(json['startDatumAflossen'] as String),
      eindDatum: DateTime.parse(json['eindDatum'] as String),
      periodeInMaanden: json['periodeInMaanden'] as int,
      aflosTermijnInMaanden: json['aflosTermijnInMaanden'] as int,
      hypotheekvorm: $enumDecode(_$HypotheekVormEnumMap, json['hypotheekvorm']),
      termijnen: json['termijnen'] == null
          ? const IListConst([])
          : IList<Termijn>.fromJson(json['termijnen'],
              (value) => Termijn.fromJson(value as Map<String, dynamic>)),
      rente: (json['rente'] as num).toDouble(),
      boeteVrijPercentage: (json['boeteVrijPercentage'] as num).toDouble(),
      usePeriodeInMaanden: json['usePeriodeInMaanden'] as bool,
      minLening: (json['minLening'] as num).toDouble(),
      extraAflossen: IList<AflosItem>.fromJson(json['extraAflossen'],
          (value) => AflosItem.fromJson(value as Map<String, dynamic>)),
      volgende: json['volgende'] as String? ?? "",
      vorige: json['vorige'] as String? ?? "",
      order: json['order'] == null
          ? const IMapConst({})
          : IMap<String, int>.fromJson(json['order'] as Map<String, dynamic>,
              (value) => value as String, (value) => value as int),
      woningLeningKosten: json['woningLeningKosten'] == null
          ? const WoningLeningKosten()
          : WoningLeningKosten.fromJson(
              json['woningLeningKosten'] as Map<String, dynamic>),
      verduurzaamKosten: json['verduurzaamKosten'] == null
          ? const VerbouwVerduurzaamKosten()
          : VerbouwVerduurzaamKosten.fromJson(
              json['verduurzaamKosten'] as Map<String, dynamic>),
      deelsAfgelosteLening: json['deelsAfgelosteLening'] as bool,
      datumDeelsAfgelosteLening:
          DateTime.parse(json['datumDeelsAfgelosteLening'] as String),
      parallelLeningen: ParallelLeningen.fromJson(
          json['parallelLeningen'] as Map<String, dynamic>),
      afgesloten: json['afgesloten'] as bool,
      restSchuld: (json['restSchuld'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$$HypotheekToJson(_$$Hypotheek instance) =>
    <String, dynamic>{
      'id': instance.id,
      'omschrijving': instance.omschrijving,
      'optiesHypotheekToevoegen':
          _$OptiesHypotheekToevoegenEnumMap[instance.optiesHypotheekToevoegen]!,
      'lening': instance.lening,
      'gewensteLening': instance.gewensteLening,
      'maxLeningInkomen': instance.maxLeningInkomen,
      'maxLeningWoningWaarde': instance.maxLeningWoningWaarde,
      'maxLeningNgh': instance.maxLeningNgh,
      'toepassenNhg': instance.toepassenNhg,
      'startDatum': instance.startDatum.toIso8601String(),
      'startDatumAflossen': instance.startDatumAflossen.toIso8601String(),
      'eindDatum': instance.eindDatum.toIso8601String(),
      'periodeInMaanden': instance.periodeInMaanden,
      'aflosTermijnInMaanden': instance.aflosTermijnInMaanden,
      'hypotheekvorm': _$HypotheekVormEnumMap[instance.hypotheekvorm]!,
      'termijnen': instance.termijnen.toJson(
        (value) => value,
      ),
      'rente': instance.rente,
      'boeteVrijPercentage': instance.boeteVrijPercentage,
      'usePeriodeInMaanden': instance.usePeriodeInMaanden,
      'minLening': instance.minLening,
      'extraAflossen': instance.extraAflossen.toJson(
        (value) => value,
      ),
      'volgende': instance.volgende,
      'vorige': instance.vorige,
      'order': instance.order.toJson(
        (value) => value,
        (value) => value,
      ),
      'woningLeningKosten': instance.woningLeningKosten,
      'verduurzaamKosten': instance.verduurzaamKosten,
      'deelsAfgelosteLening': instance.deelsAfgelosteLening,
      'datumDeelsAfgelosteLening':
          instance.datumDeelsAfgelosteLening.toIso8601String(),
      'parallelLeningen': instance.parallelLeningen,
      'afgesloten': instance.afgesloten,
      'restSchuld': instance.restSchuld,
    };

const _$OptiesHypotheekToevoegenEnumMap = {
  OptiesHypotheekToevoegen.nieuw: 'nieuw',
  OptiesHypotheekToevoegen.verlengen: 'verlengen',
};

const _$HypotheekVormEnumMap = {
  HypotheekVorm.aflosvrij: 'aflosvrij',
  HypotheekVorm.linear: 'linear',
  HypotheekVorm.annuity: 'annuity',
};
