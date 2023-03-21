// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inkomens_op_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InkomensOpDatum _$$_InkomensOpDatumFromJson(Map<String, dynamic> json) =>
    _$_InkomensOpDatum(
      datum: DateTime.parse(json['datum'] as String),
      inkomen: json['inkomen'] == null
          ? null
          : Inkomen.fromJson(json['inkomen'] as Map<String, dynamic>),
      inkomenPartner: json['inkomenPartner'] == null
          ? null
          : Inkomen.fromJson(json['inkomenPartner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_InkomensOpDatumToJson(_$_InkomensOpDatum instance) =>
    <String, dynamic>{
      'datum': instance.datum.toIso8601String(),
      'inkomen': instance.inkomen,
      'inkomenPartner': instance.inkomenPartner,
    };
