// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_of_kosten_lening.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Waarde _$$_WaardeFromJson(Map<String, dynamic> json) => _$_Waarde(
      id: json['id'] as String,
      index: json['index'] as int,
      omschrijving: json['omschrijving'] as String,
      getal: (json['getal'] as num).toDouble(),
      eenheid: $enumDecode(_$EenheidEnumMap, json['eenheid']),
      aftrekbaar: json['aftrekbaar'] as bool? ?? false,
      standaard: json['standaard'] as bool? ?? false,
      verduurzamen: json['verduurzamen'] as bool? ?? false,
    );

Map<String, dynamic> _$$_WaardeToJson(_$_Waarde instance) => <String, dynamic>{
      'id': instance.id,
      'index': instance.index,
      'omschrijving': instance.omschrijving,
      'getal': instance.getal,
      'eenheid': _$EenheidEnumMap[instance.eenheid]!,
      'aftrekbaar': instance.aftrekbaar,
      'standaard': instance.standaard,
      'verduurzamen': instance.verduurzamen,
    };

const _$EenheidEnumMap = {
  Eenheid.percentageWoningWaarde: 'percentageWoningWaarde',
  Eenheid.percentageLening: 'percentageLening',
  Eenheid.bedrag: 'bedrag',
};
