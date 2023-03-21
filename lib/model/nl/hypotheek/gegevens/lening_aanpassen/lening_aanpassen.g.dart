// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lening_aanpassen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LenningAanpassenInTermijnen _$$LenningAanpassenInTermijnenFromJson(
        Map<String, dynamic> json) =>
    _$LenningAanpassenInTermijnen(
      datum: DateTime.parse(json['datum'] as String),
      leningAanpassenOpties: $enumDecodeNullable(
              _$LeningAanpassenOptiesEnumMap, json['leningAanpassenOpties']) ??
          LeningAanpassenOpties.aflossen,
      bedrag: (json['bedrag'] as num).toDouble(),
      termijnen: json['termijnen'] as int,
      periodeInMaanden: json['periodeInMaanden'] as int,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LenningAanpassenInTermijnenToJson(
        _$LenningAanpassenInTermijnen instance) =>
    <String, dynamic>{
      'datum': instance.datum.toIso8601String(),
      'leningAanpassenOpties':
          _$LeningAanpassenOptiesEnumMap[instance.leningAanpassenOpties]!,
      'bedrag': instance.bedrag,
      'termijnen': instance.termijnen,
      'periodeInMaanden': instance.periodeInMaanden,
      'runtimeType': instance.$type,
    };

const _$LeningAanpassenOptiesEnumMap = {
  LeningAanpassenOpties.aflossen: 'aflossen',
  LeningAanpassenOpties.verhogen: 'verhogen',
};

_$LenningAanpassenEenmalig _$$LenningAanpassenEenmaligFromJson(
        Map<String, dynamic> json) =>
    _$LenningAanpassenEenmalig(
      datum: DateTime.parse(json['datum'] as String),
      leningAanpassenOpties: $enumDecodeNullable(
              _$LeningAanpassenOptiesEnumMap, json['leningAanpassenOpties']) ??
          LeningAanpassenOpties.aflossen,
      bedrag: (json['bedrag'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LenningAanpassenEenmaligToJson(
        _$LenningAanpassenEenmalig instance) =>
    <String, dynamic>{
      'datum': instance.datum.toIso8601String(),
      'leningAanpassenOpties':
          _$LeningAanpassenOptiesEnumMap[instance.leningAanpassenOpties]!,
      'bedrag': instance.bedrag,
      'runtimeType': instance.$type,
    };
