// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eigenwoningreserve.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EigenWoningReserve _$$_EigenWoningReserveFromJson(
        Map<String, dynamic> json) =>
    _$_EigenWoningReserve(
      ewrToepassen: json['ewrToepassen'] as bool? ?? true,
      ewrBerekenen: json['ewrBerekenen'] as bool? ?? false,
      ewr: (json['ewr'] as num?)?.toDouble() ?? 0.0,
      oorspronkelijkeHoofdsom:
          (json['oorspronkelijkeHoofdsom'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_EigenWoningReserveToJson(
        _$_EigenWoningReserve instance) =>
    <String, dynamic>{
      'ewrToepassen': instance.ewrToepassen,
      'ewrBerekenen': instance.ewrBerekenen,
      'ewr': instance.ewr,
      'oorspronkelijkeHoofdsom': instance.oorspronkelijkeHoofdsom,
    };
