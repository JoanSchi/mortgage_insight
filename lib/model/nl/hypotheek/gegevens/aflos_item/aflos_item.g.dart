// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aflos_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AflosItem _$$_AflosItemFromJson(Map<String, dynamic> json) => _$_AflosItem(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      terms: json['terms'] as int,
      periodInMonths: json['periodInMonths'] as int,
    );

Map<String, dynamic> _$$_AflosItemToJson(_$_AflosItem instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'terms': instance.terms,
      'periodInMonths': instance.periodInMonths,
    };
