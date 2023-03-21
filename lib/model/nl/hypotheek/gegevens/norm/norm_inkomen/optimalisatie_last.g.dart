// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimalisatie_last.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OptimalisatieLast _$$_OptimalisatieLastFromJson(Map<String, dynamic> json) =>
    _$_OptimalisatieLast(
      statusLening:
          StatusLening.fromJson(json['statusLening'] as Map<String, dynamic>),
      toetsRente: (json['toetsRente'] as num).toDouble(),
      verduurzaamLening: (json['verduurzaamLening'] as num?)?.toDouble() ?? 0.0,
      box1: (json['box1'] as num?)?.toDouble() ?? 0.0,
      box3: (json['box3'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_OptimalisatieLastToJson(
        _$_OptimalisatieLast instance) =>
    <String, dynamic>{
      'statusLening': instance.statusLening,
      'toetsRente': instance.toetsRente,
      'verduurzaamLening': instance.verduurzaamLening,
      'box1': instance.box1,
      'box3': instance.box3,
    };
