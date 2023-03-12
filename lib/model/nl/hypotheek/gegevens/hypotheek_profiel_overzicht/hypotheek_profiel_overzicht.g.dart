// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypotheek_profiel_overzicht.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HypotheekProfielOverzicht _$$_HypotheekProfielOverzichtFromJson(
        Map<String, dynamic> json) =>
    _$_HypotheekProfielOverzicht(
      hypotheekProfielen: json['hypotheekProfielen'] == null
          ? const IMapConst({})
          : IMap<String, HypotheekProfiel>.fromJson(
              json['hypotheekProfielen'] as Map<String, dynamic>,
              (value) => value as String,
              (value) =>
                  HypotheekProfiel.fromJson(value as Map<String, dynamic>)),
      actief: json['actief'] as String? ?? '',
    );

Map<String, dynamic> _$$_HypotheekProfielOverzichtToJson(
        _$_HypotheekProfielOverzicht instance) =>
    <String, dynamic>{
      'hypotheekProfielen': instance.hypotheekProfielen.toJson(
        (value) => value,
        (value) => value,
      ),
      'actief': instance.actief,
    };
