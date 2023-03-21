// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypotheek_dossier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HypotheekDossier _$$_HypotheekDossierFromJson(Map<String, dynamic> json) =>
    _$_HypotheekDossier(
      id: json['id'] as int? ?? -1,
      hypotheken: json['hypotheken'] == null
          ? const IMapConst({})
          : IMap<String, Hypotheek>.fromJson(
              json['hypotheken'] as Map<String, dynamic>,
              (value) => value as String,
              (value) => Hypotheek.fromJson(value as Map<String, dynamic>)),
      eersteHypotheken: json['eersteHypotheken'] == null
          ? const IListConst([])
          : IList<Hypotheek>.fromJson(json['eersteHypotheken'],
              (value) => Hypotheek.fromJson(value as Map<String, dynamic>)),
      omschrijving: json['omschrijving'] as String? ?? '',
      inkomensNormToepassen: json['inkomensNormToepassen'] as bool? ?? true,
      woningWaardeNormToepassen:
          json['woningWaardeNormToepassen'] as bool? ?? true,
      doelHypotheekOverzicht: $enumDecodeNullable(
              _$DoelHypotheekOverzichtEnumMap,
              json['doelHypotheekOverzicht']) ??
          DoelHypotheekOverzicht.nieuweWoning,
      starter: json['starter'] as bool? ?? false,
      eigenWoningReserve: json['eigenWoningReserve'] == null
          ? const EigenWoningReserve()
          : EigenWoningReserve.fromJson(
              json['eigenWoningReserve'] as Map<String, dynamic>),
      vorigeWoningKosten: json['vorigeWoningKosten'] == null
          ? const WoningLeningKosten()
          : WoningLeningKosten.fromJson(
              json['vorigeWoningKosten'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_HypotheekDossierToJson(_$_HypotheekDossier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hypotheken': instance.hypotheken.toJson(
        (value) => value,
        (value) => value,
      ),
      'eersteHypotheken': instance.eersteHypotheken.toJson(
        (value) => value,
      ),
      'omschrijving': instance.omschrijving,
      'inkomensNormToepassen': instance.inkomensNormToepassen,
      'woningWaardeNormToepassen': instance.woningWaardeNormToepassen,
      'doelHypotheekOverzicht':
          _$DoelHypotheekOverzichtEnumMap[instance.doelHypotheekOverzicht]!,
      'starter': instance.starter,
      'eigenWoningReserve': instance.eigenWoningReserve,
      'vorigeWoningKosten': instance.vorigeWoningKosten,
    };

const _$DoelHypotheekOverzichtEnumMap = {
  DoelHypotheekOverzicht.nieuweWoning: 'nieuweWoning',
  DoelHypotheekOverzicht.huidigeWoning: 'huidigeWoning',
};
