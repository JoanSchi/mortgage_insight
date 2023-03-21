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
      lening: (json['lening'] as num?)?.toDouble() ?? 0,
      gewensteLening: (json['gewensteLening'] as num?)?.toDouble() ?? 0,
      normInkomen: json['normInkomen'] == null
          ? const NormInkomen(omschrijving: 'Inkomen')
          : NormInkomen.fromJson(json['normInkomen'] as Map<String, dynamic>),
      normWoningwaarde: json['normWoningwaarde'] == null
          ? const NormWoningwaarde(omschrijving: 'Woningwaarde')
          : NormWoningwaarde.fromJson(
              json['normWoningwaarde'] as Map<String, dynamic>),
      normNhg: json['normNhg'] == null
          ? const NormNhg(omschrijving: 'NHG')
          : NormNhg.fromJson(json['normNhg'] as Map<String, dynamic>),
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
      aanpassenLening: json['aanpassenLening'] == null
          ? const IListConst([])
          : IList<LeningAanpassen>.fromJson(
              json['aanpassenLening'],
              (value) =>
                  LeningAanpassen.fromJson(value as Map<String, dynamic>)),
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
      verbouwVerduurzaamKosten: json['verbouwVerduurzaamKosten'] == null
          ? const VerbouwVerduurzaamKosten()
          : VerbouwVerduurzaamKosten.fromJson(
              json['verbouwVerduurzaamKosten'] as Map<String, dynamic>),
      deelsAfgelosteLening: json['deelsAfgelosteLening'] as bool,
      datumDeelsAfgelosteLening:
          DateTime.parse(json['datumDeelsAfgelosteLening'] as String),
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
      'normInkomen': instance.normInkomen,
      'normWoningwaarde': instance.normWoningwaarde,
      'normNhg': instance.normNhg,
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
      'aanpassenLening': instance.aanpassenLening.toJson(
        (value) => value,
      ),
      'volgende': instance.volgende,
      'vorige': instance.vorige,
      'order': instance.order.toJson(
        (value) => value,
        (value) => value,
      ),
      'woningLeningKosten': instance.woningLeningKosten,
      'verbouwVerduurzaamKosten': instance.verbouwVerduurzaamKosten,
      'deelsAfgelosteLening': instance.deelsAfgelosteLening,
      'datumDeelsAfgelosteLening':
          instance.datumDeelsAfgelosteLening.toIso8601String(),
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
