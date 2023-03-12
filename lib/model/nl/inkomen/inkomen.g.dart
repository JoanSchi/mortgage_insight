// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inkomen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InkomensOverzicht _$$_InkomensOverzichtFromJson(Map<String, dynamic> json) =>
    _$_InkomensOverzicht(
      inkomen: json['inkomen'] == null
          ? const IListConst([])
          : IList<Inkomen>.fromJson(json['inkomen'],
              (value) => Inkomen.fromJson(value as Map<String, dynamic>)),
      inkomenPartner: json['inkomenPartner'] == null
          ? const IListConst([])
          : IList<Inkomen>.fromJson(json['inkomenPartner'],
              (value) => Inkomen.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$$_InkomensOverzichtToJson(
        _$_InkomensOverzicht instance) =>
    <String, dynamic>{
      'inkomen': instance.inkomen.toJson(
        (value) => value,
      ),
      'inkomenPartner': instance.inkomenPartner.toJson(
        (value) => value,
      ),
    };

_$_Inkomen _$$_InkomenFromJson(Map<String, dynamic> json) => _$_Inkomen(
      datum: DateTime.parse(json['datum'] as String),
      partner: json['partner'] as bool,
      indexatie: (json['indexatie'] as num).toDouble(),
      pensioen: json['pensioen'] as bool,
      periodeInkomen:
          $enumDecode(_$PeriodeInkomenEnumMap, json['periodeInkomen']),
      brutoInkomen: (json['brutoInkomen'] as num).toDouble(),
      dertiendeMaand: json['dertiendeMaand'] as bool,
      vakantiegeld: json['vakantiegeld'] as bool,
    );

Map<String, dynamic> _$$_InkomenToJson(_$_Inkomen instance) =>
    <String, dynamic>{
      'datum': instance.datum.toIso8601String(),
      'partner': instance.partner,
      'indexatie': instance.indexatie,
      'pensioen': instance.pensioen,
      'periodeInkomen': _$PeriodeInkomenEnumMap[instance.periodeInkomen]!,
      'brutoInkomen': instance.brutoInkomen,
      'dertiendeMaand': instance.dertiendeMaand,
      'vakantiegeld': instance.vakantiegeld,
    };

const _$PeriodeInkomenEnumMap = {
  PeriodeInkomen.maand: 'maand',
  PeriodeInkomen.jaar: 'jaar',
};
