// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combi_rest_schuld.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CombiRestSchuld _$$_CombiRestSchuldFromJson(Map<String, dynamic> json) =>
    _$_CombiRestSchuld(
      datum: DateTime.parse(json['datum'] as String),
      restSchuld: (json['restSchuld'] as num).toDouble(),
      idLijst:
          IList<String>.fromJson(json['idLijst'], (value) => value as String),
    );

Map<String, dynamic> _$$_CombiRestSchuldToJson(_$_CombiRestSchuld instance) =>
    <String, dynamic>{
      'datum': instance.datum.toIso8601String(),
      'restSchuld': instance.restSchuld,
      'idLijst': instance.idLijst.toJson(
        (value) => value,
      ),
    };
