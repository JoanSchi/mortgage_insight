// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schulden.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SchuldenOverzicht _$$_SchuldenOverzichtFromJson(Map<String, dynamic> json) =>
    _$_SchuldenOverzicht(
      lijst: IList<Schuld>.fromJson(json['lijst'],
          (value) => Schuld.fromJson(value as Map<String, dynamic>)),
    );

Map<String, dynamic> _$$_SchuldenOverzichtToJson(
        _$_SchuldenOverzicht instance) =>
    <String, dynamic>{
      'lijst': instance.lijst.toJson(
        (value) => value,
      ),
    };

_$LeaseAuto _$$LeaseAutoFromJson(Map<String, dynamic> json) => _$LeaseAuto(
      id: json['id'] as int,
      categorie: $enumDecode(_$SchuldenCategorieEnumMap, json['categorie']),
      omschrijving: json['omschrijving'] as String,
      beginDatum: DateTime.parse(json['beginDatum'] as String),
      statusBerekening:
          $enumDecode(_$StatusBerekeningEnumMap, json['statusBerekening']),
      error: json['error'] as String,
      mndBedrag: (json['mndBedrag'] as num).toDouble(),
      jaren: json['jaren'] as int,
      maanden: json['maanden'] as int,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LeaseAutoToJson(_$LeaseAuto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categorie': _$SchuldenCategorieEnumMap[instance.categorie]!,
      'omschrijving': instance.omschrijving,
      'beginDatum': instance.beginDatum.toIso8601String(),
      'statusBerekening': _$StatusBerekeningEnumMap[instance.statusBerekening]!,
      'error': instance.error,
      'mndBedrag': instance.mndBedrag,
      'jaren': instance.jaren,
      'maanden': instance.maanden,
      'runtimeType': instance.$type,
    };

const _$SchuldenCategorieEnumMap = {
  SchuldenCategorie.aflopend_krediet: 'aflopend_krediet',
  SchuldenCategorie.doorlopend_krediet: 'doorlopend_krediet',
  SchuldenCategorie.verzendhuiskrediet: 'verzendhuiskrediet',
  SchuldenCategorie.operationele_autolease: 'operationele_autolease',
};

const _$StatusBerekeningEnumMap = {
  StatusBerekening.berekend: 'berekend',
  StatusBerekening.nietBerekend: 'nietBerekend',
  StatusBerekening.fout: 'fout',
};

_$VerzendKrediet _$$VerzendKredietFromJson(Map<String, dynamic> json) =>
    _$VerzendKrediet(
      id: json['id'] as int,
      categorie: $enumDecode(_$SchuldenCategorieEnumMap, json['categorie']),
      omschrijving: json['omschrijving'] as String,
      beginDatum: DateTime.parse(json['beginDatum'] as String),
      statusBerekening:
          $enumDecode(_$StatusBerekeningEnumMap, json['statusBerekening']),
      error: json['error'] as String,
      totaalBedrag: (json['totaalBedrag'] as num).toDouble(),
      mndBedrag: (json['mndBedrag'] as num).toDouble(),
      slotTermijn: (json['slotTermijn'] as num).toDouble(),
      maanden: json['maanden'] as int,
      minMaanden: json['minMaanden'] as int,
      maxMaanden: json['maxMaanden'] as int,
      isTotalbedrag: json['isTotalbedrag'] as bool,
      heeftSlotTermijn: json['heeftSlotTermijn'] as bool,
      decimalen: json['decimalen'] as int,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$VerzendKredietToJson(_$VerzendKrediet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categorie': _$SchuldenCategorieEnumMap[instance.categorie]!,
      'omschrijving': instance.omschrijving,
      'beginDatum': instance.beginDatum.toIso8601String(),
      'statusBerekening': _$StatusBerekeningEnumMap[instance.statusBerekening]!,
      'error': instance.error,
      'totaalBedrag': instance.totaalBedrag,
      'mndBedrag': instance.mndBedrag,
      'slotTermijn': instance.slotTermijn,
      'maanden': instance.maanden,
      'minMaanden': instance.minMaanden,
      'maxMaanden': instance.maxMaanden,
      'isTotalbedrag': instance.isTotalbedrag,
      'heeftSlotTermijn': instance.heeftSlotTermijn,
      'decimalen': instance.decimalen,
      'runtimeType': instance.$type,
    };

_$DoorlopendKrediet _$$DoorlopendKredietFromJson(Map<String, dynamic> json) =>
    _$DoorlopendKrediet(
      id: json['id'] as int,
      categorie: $enumDecode(_$SchuldenCategorieEnumMap, json['categorie']),
      omschrijving: json['omschrijving'] as String,
      beginDatum: DateTime.parse(json['beginDatum'] as String),
      statusBerekening:
          $enumDecode(_$StatusBerekeningEnumMap, json['statusBerekening']),
      error: json['error'] as String,
      bedrag: (json['bedrag'] as num).toDouble(),
      eindDatumGebruiker: DateTime.parse(json['eindDatumGebruiker'] as String),
      heeftEindDatum: json['heeftEindDatum'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DoorlopendKredietToJson(_$DoorlopendKrediet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categorie': _$SchuldenCategorieEnumMap[instance.categorie]!,
      'omschrijving': instance.omschrijving,
      'beginDatum': instance.beginDatum.toIso8601String(),
      'statusBerekening': _$StatusBerekeningEnumMap[instance.statusBerekening]!,
      'error': instance.error,
      'bedrag': instance.bedrag,
      'eindDatumGebruiker': instance.eindDatumGebruiker.toIso8601String(),
      'heeftEindDatum': instance.heeftEindDatum,
      'runtimeType': instance.$type,
    };

_$AflopendKrediet _$$AflopendKredietFromJson(Map<String, dynamic> json) =>
    _$AflopendKrediet(
      id: json['id'] as int,
      categorie: $enumDecode(_$SchuldenCategorieEnumMap, json['categorie']),
      omschrijving: json['omschrijving'] as String,
      beginDatum: DateTime.parse(json['beginDatum'] as String),
      statusBerekening:
          $enumDecode(_$StatusBerekeningEnumMap, json['statusBerekening']),
      error: json['error'] as String,
      lening: (json['lening'] as num).toDouble(),
      rente: (json['rente'] as num).toDouble(),
      termijnBedragMnd: (json['termijnBedragMnd'] as num).toDouble(),
      minTermijnBedragMnd: (json['minTermijnBedragMnd'] as num).toDouble(),
      maanden: json['maanden'] as int,
      minMaanden: json['minMaanden'] as int,
      maxMaanden: json['maxMaanden'] as int,
      minAflossenPerMaand: (json['minAflossenPerMaand'] as num).toDouble(),
      maxAflossenPerMaand: (json['maxAflossenPerMaand'] as num).toDouble(),
      defaultAflossenPerMaand:
          (json['defaultAflossenPerMaand'] as num).toDouble(),
      termijnen: IList<AKtermijnAnn>.fromJson(json['termijnen'],
          (value) => AKtermijnAnn.fromJson(value as Map<String, dynamic>)),
      somInterest: (json['somInterest'] as num).toDouble(),
      somAnn: (json['somAnn'] as num).toDouble(),
      slotTermijn: (json['slotTermijn'] as num).toDouble(),
      aflosTabelOpties:
          AflosTabelOpties.fromJson(json['aflosTabelOpties'] as String),
      decimalen: json['decimalen'] as int,
      renteGebrokenMaand: json['renteGebrokenMaand'] as bool,
      betaling: $enumDecode(_$AKbetalingEnumMap, json['betaling']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AflopendKredietToJson(_$AflopendKrediet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categorie': _$SchuldenCategorieEnumMap[instance.categorie]!,
      'omschrijving': instance.omschrijving,
      'beginDatum': instance.beginDatum.toIso8601String(),
      'statusBerekening': _$StatusBerekeningEnumMap[instance.statusBerekening]!,
      'error': instance.error,
      'lening': instance.lening,
      'rente': instance.rente,
      'termijnBedragMnd': instance.termijnBedragMnd,
      'minTermijnBedragMnd': instance.minTermijnBedragMnd,
      'maanden': instance.maanden,
      'minMaanden': instance.minMaanden,
      'maxMaanden': instance.maxMaanden,
      'minAflossenPerMaand': instance.minAflossenPerMaand,
      'maxAflossenPerMaand': instance.maxAflossenPerMaand,
      'defaultAflossenPerMaand': instance.defaultAflossenPerMaand,
      'termijnen': instance.termijnen.toJson(
        (value) => value,
      ),
      'somInterest': instance.somInterest,
      'somAnn': instance.somAnn,
      'slotTermijn': instance.slotTermijn,
      'aflosTabelOpties': instance.aflosTabelOpties,
      'decimalen': instance.decimalen,
      'renteGebrokenMaand': instance.renteGebrokenMaand,
      'betaling': _$AKbetalingEnumMap[instance.betaling]!,
      'runtimeType': instance.$type,
    };

const _$AKbetalingEnumMap = {
  AKbetaling.per_periode: 'per_periode',
  AKbetaling.per_maand: 'per_maand',
  AKbetaling.per_eerst_volgende_maand: 'per_eerst_volgende_maand',
};

_$_AKtermijnAnn _$$_AKtermijnAnnFromJson(Map<String, dynamic> json) =>
    _$_AKtermijnAnn(
      termijn: DateTime.parse(json['termijn'] as String),
      interest: (json['interest'] as num).toDouble(),
      aflossen: (json['aflossen'] as num).toDouble(),
      schuld: (json['schuld'] as num).toDouble(),
      termijnBedrag: (json['termijnBedrag'] as num).toDouble(),
    );

Map<String, dynamic> _$$_AKtermijnAnnToJson(_$_AKtermijnAnn instance) =>
    <String, dynamic>{
      'termijn': instance.termijn.toIso8601String(),
      'interest': instance.interest,
      'aflossen': instance.aflossen,
      'schuld': instance.schuld,
      'termijnBedrag': instance.termijnBedrag,
    };
