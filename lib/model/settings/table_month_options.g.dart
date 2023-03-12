// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_month_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TableMonthOptions _$$_TableMonthOptionsFromJson(Map<String, dynamic> json) =>
    _$_TableMonthOptions(
      monthsVisible:
          IList<bool>.fromJson(json['monthsVisible'], (value) => value as bool),
      startEnd: json['startEnd'] as bool,
      deviate: json['deviate'] as bool,
    );

Map<String, dynamic> _$$_TableMonthOptionsToJson(
        _$_TableMonthOptions instance) =>
    <String, dynamic>{
      'monthsVisible': instance.monthsVisible.toJson(
        (value) => value,
      ),
      'startEnd': instance.startEnd,
      'deviate': instance.deviate,
    };
