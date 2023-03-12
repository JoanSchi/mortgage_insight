// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'woning_lening_kosten.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_WoningLeningKosten _$$_WoningLeningKostenFromJson(
        Map<String, dynamic> json) =>
    _$_WoningLeningKosten(
      kosten: json['kosten'] == null
          ? const IListConst([])
          : IList<Waarde>.fromJson(json['kosten'],
              (value) => Waarde.fromJson(value as Map<String, dynamic>)),
      woningWaarde: (json['woningWaarde'] as num?)?.toDouble() ?? 0.0,
      lening: (json['lening'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$_WoningLeningKostenToJson(
        _$_WoningLeningKosten instance) =>
    <String, dynamic>{
      'kosten': instance.kosten.toJson(
        (value) => value,
      ),
      'woningWaarde': instance.woningWaarde,
      'lening': instance.lening,
    };
