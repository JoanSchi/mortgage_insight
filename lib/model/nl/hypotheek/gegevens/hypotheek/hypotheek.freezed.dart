// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hypotheek.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Hypotheek _$HypotheekFromJson(Map<String, dynamic> json) {
  return $Hypotheek.fromJson(json);
}

/// @nodoc
mixin _$Hypotheek {
  String get id => throw _privateConstructorUsedError;
  String get omschrijving => throw _privateConstructorUsedError;
  OptiesHypotheekToevoegen get optiesHypotheekToevoegen =>
      throw _privateConstructorUsedError;
  double get lening => throw _privateConstructorUsedError;
  double get gewensteLening => throw _privateConstructorUsedError;
  NormInkomen get normInkomen => throw _privateConstructorUsedError;
  NormWoningwaarde get normWoningwaarde => throw _privateConstructorUsedError;
  NormNhg get normNhg => throw _privateConstructorUsedError;
  DateTime get startDatum => throw _privateConstructorUsedError;
  DateTime get startDatumAflossen => throw _privateConstructorUsedError;
  DateTime get eindDatum => throw _privateConstructorUsedError;
  int get periodeInMaanden => throw _privateConstructorUsedError;
  int get aflosTermijnInMaanden => throw _privateConstructorUsedError;
  HypotheekVorm get hypotheekvorm => throw _privateConstructorUsedError;
  IList<Termijn> get termijnen => throw _privateConstructorUsedError;
  double get rente => throw _privateConstructorUsedError;
  double get boeteVrijPercentage => throw _privateConstructorUsedError;
  bool get usePeriodeInMaanden => throw _privateConstructorUsedError;
  double get minLening => throw _privateConstructorUsedError;
  IList<LeningAanpassen> get aanpassenLening =>
      throw _privateConstructorUsedError;
  String get volgende => throw _privateConstructorUsedError;
  String get vorige => throw _privateConstructorUsedError;
  IMap<String, int> get order => throw _privateConstructorUsedError;
  WoningLeningKosten get woningLeningKosten =>
      throw _privateConstructorUsedError;
  VerbouwVerduurzaamKosten get verbouwVerduurzaamKosten =>
      throw _privateConstructorUsedError;
  bool get deelsAfgelosteLening => throw _privateConstructorUsedError;
  DateTime get datumDeelsAfgelosteLening => throw _privateConstructorUsedError;
  bool get afgesloten => throw _privateConstructorUsedError;
  double get restSchuld => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HypotheekCopyWith<Hypotheek> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HypotheekCopyWith<$Res> {
  factory $HypotheekCopyWith(Hypotheek value, $Res Function(Hypotheek) then) =
      _$HypotheekCopyWithImpl<$Res, Hypotheek>;
  @useResult
  $Res call(
      {String id,
      String omschrijving,
      OptiesHypotheekToevoegen optiesHypotheekToevoegen,
      double lening,
      double gewensteLening,
      NormInkomen normInkomen,
      NormWoningwaarde normWoningwaarde,
      NormNhg normNhg,
      DateTime startDatum,
      DateTime startDatumAflossen,
      DateTime eindDatum,
      int periodeInMaanden,
      int aflosTermijnInMaanden,
      HypotheekVorm hypotheekvorm,
      IList<Termijn> termijnen,
      double rente,
      double boeteVrijPercentage,
      bool usePeriodeInMaanden,
      double minLening,
      IList<LeningAanpassen> aanpassenLening,
      String volgende,
      String vorige,
      IMap<String, int> order,
      WoningLeningKosten woningLeningKosten,
      VerbouwVerduurzaamKosten verbouwVerduurzaamKosten,
      bool deelsAfgelosteLening,
      DateTime datumDeelsAfgelosteLening,
      bool afgesloten,
      double restSchuld});

  $WoningLeningKostenCopyWith<$Res> get woningLeningKosten;
  $VerbouwVerduurzaamKostenCopyWith<$Res> get verbouwVerduurzaamKosten;
}

/// @nodoc
class _$HypotheekCopyWithImpl<$Res, $Val extends Hypotheek>
    implements $HypotheekCopyWith<$Res> {
  _$HypotheekCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? omschrijving = null,
    Object? optiesHypotheekToevoegen = null,
    Object? lening = null,
    Object? gewensteLening = null,
    Object? normInkomen = freezed,
    Object? normWoningwaarde = freezed,
    Object? normNhg = freezed,
    Object? startDatum = null,
    Object? startDatumAflossen = null,
    Object? eindDatum = null,
    Object? periodeInMaanden = null,
    Object? aflosTermijnInMaanden = null,
    Object? hypotheekvorm = null,
    Object? termijnen = null,
    Object? rente = null,
    Object? boeteVrijPercentage = null,
    Object? usePeriodeInMaanden = null,
    Object? minLening = null,
    Object? aanpassenLening = null,
    Object? volgende = null,
    Object? vorige = null,
    Object? order = null,
    Object? woningLeningKosten = null,
    Object? verbouwVerduurzaamKosten = null,
    Object? deelsAfgelosteLening = null,
    Object? datumDeelsAfgelosteLening = null,
    Object? afgesloten = null,
    Object? restSchuld = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      optiesHypotheekToevoegen: null == optiesHypotheekToevoegen
          ? _value.optiesHypotheekToevoegen
          : optiesHypotheekToevoegen // ignore: cast_nullable_to_non_nullable
              as OptiesHypotheekToevoegen,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
      gewensteLening: null == gewensteLening
          ? _value.gewensteLening
          : gewensteLening // ignore: cast_nullable_to_non_nullable
              as double,
      normInkomen: freezed == normInkomen
          ? _value.normInkomen
          : normInkomen // ignore: cast_nullable_to_non_nullable
              as NormInkomen,
      normWoningwaarde: freezed == normWoningwaarde
          ? _value.normWoningwaarde
          : normWoningwaarde // ignore: cast_nullable_to_non_nullable
              as NormWoningwaarde,
      normNhg: freezed == normNhg
          ? _value.normNhg
          : normNhg // ignore: cast_nullable_to_non_nullable
              as NormNhg,
      startDatum: null == startDatum
          ? _value.startDatum
          : startDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDatumAflossen: null == startDatumAflossen
          ? _value.startDatumAflossen
          : startDatumAflossen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eindDatum: null == eindDatum
          ? _value.eindDatum
          : eindDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodeInMaanden: null == periodeInMaanden
          ? _value.periodeInMaanden
          : periodeInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      aflosTermijnInMaanden: null == aflosTermijnInMaanden
          ? _value.aflosTermijnInMaanden
          : aflosTermijnInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      hypotheekvorm: null == hypotheekvorm
          ? _value.hypotheekvorm
          : hypotheekvorm // ignore: cast_nullable_to_non_nullable
              as HypotheekVorm,
      termijnen: null == termijnen
          ? _value.termijnen
          : termijnen // ignore: cast_nullable_to_non_nullable
              as IList<Termijn>,
      rente: null == rente
          ? _value.rente
          : rente // ignore: cast_nullable_to_non_nullable
              as double,
      boeteVrijPercentage: null == boeteVrijPercentage
          ? _value.boeteVrijPercentage
          : boeteVrijPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      usePeriodeInMaanden: null == usePeriodeInMaanden
          ? _value.usePeriodeInMaanden
          : usePeriodeInMaanden // ignore: cast_nullable_to_non_nullable
              as bool,
      minLening: null == minLening
          ? _value.minLening
          : minLening // ignore: cast_nullable_to_non_nullable
              as double,
      aanpassenLening: null == aanpassenLening
          ? _value.aanpassenLening
          : aanpassenLening // ignore: cast_nullable_to_non_nullable
              as IList<LeningAanpassen>,
      volgende: null == volgende
          ? _value.volgende
          : volgende // ignore: cast_nullable_to_non_nullable
              as String,
      vorige: null == vorige
          ? _value.vorige
          : vorige // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as IMap<String, int>,
      woningLeningKosten: null == woningLeningKosten
          ? _value.woningLeningKosten
          : woningLeningKosten // ignore: cast_nullable_to_non_nullable
              as WoningLeningKosten,
      verbouwVerduurzaamKosten: null == verbouwVerduurzaamKosten
          ? _value.verbouwVerduurzaamKosten
          : verbouwVerduurzaamKosten // ignore: cast_nullable_to_non_nullable
              as VerbouwVerduurzaamKosten,
      deelsAfgelosteLening: null == deelsAfgelosteLening
          ? _value.deelsAfgelosteLening
          : deelsAfgelosteLening // ignore: cast_nullable_to_non_nullable
              as bool,
      datumDeelsAfgelosteLening: null == datumDeelsAfgelosteLening
          ? _value.datumDeelsAfgelosteLening
          : datumDeelsAfgelosteLening // ignore: cast_nullable_to_non_nullable
              as DateTime,
      afgesloten: null == afgesloten
          ? _value.afgesloten
          : afgesloten // ignore: cast_nullable_to_non_nullable
              as bool,
      restSchuld: null == restSchuld
          ? _value.restSchuld
          : restSchuld // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WoningLeningKostenCopyWith<$Res> get woningLeningKosten {
    return $WoningLeningKostenCopyWith<$Res>(_value.woningLeningKosten,
        (value) {
      return _then(_value.copyWith(woningLeningKosten: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $VerbouwVerduurzaamKostenCopyWith<$Res> get verbouwVerduurzaamKosten {
    return $VerbouwVerduurzaamKostenCopyWith<$Res>(
        _value.verbouwVerduurzaamKosten, (value) {
      return _then(_value.copyWith(verbouwVerduurzaamKosten: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$$HypotheekCopyWith<$Res> implements $HypotheekCopyWith<$Res> {
  factory _$$$HypotheekCopyWith(
          _$$Hypotheek value, $Res Function(_$$Hypotheek) then) =
      __$$$HypotheekCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String omschrijving,
      OptiesHypotheekToevoegen optiesHypotheekToevoegen,
      double lening,
      double gewensteLening,
      NormInkomen normInkomen,
      NormWoningwaarde normWoningwaarde,
      NormNhg normNhg,
      DateTime startDatum,
      DateTime startDatumAflossen,
      DateTime eindDatum,
      int periodeInMaanden,
      int aflosTermijnInMaanden,
      HypotheekVorm hypotheekvorm,
      IList<Termijn> termijnen,
      double rente,
      double boeteVrijPercentage,
      bool usePeriodeInMaanden,
      double minLening,
      IList<LeningAanpassen> aanpassenLening,
      String volgende,
      String vorige,
      IMap<String, int> order,
      WoningLeningKosten woningLeningKosten,
      VerbouwVerduurzaamKosten verbouwVerduurzaamKosten,
      bool deelsAfgelosteLening,
      DateTime datumDeelsAfgelosteLening,
      bool afgesloten,
      double restSchuld});

  @override
  $WoningLeningKostenCopyWith<$Res> get woningLeningKosten;
  @override
  $VerbouwVerduurzaamKostenCopyWith<$Res> get verbouwVerduurzaamKosten;
}

/// @nodoc
class __$$$HypotheekCopyWithImpl<$Res>
    extends _$HypotheekCopyWithImpl<$Res, _$$Hypotheek>
    implements _$$$HypotheekCopyWith<$Res> {
  __$$$HypotheekCopyWithImpl(
      _$$Hypotheek _value, $Res Function(_$$Hypotheek) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? omschrijving = null,
    Object? optiesHypotheekToevoegen = null,
    Object? lening = null,
    Object? gewensteLening = null,
    Object? normInkomen = freezed,
    Object? normWoningwaarde = freezed,
    Object? normNhg = freezed,
    Object? startDatum = null,
    Object? startDatumAflossen = null,
    Object? eindDatum = null,
    Object? periodeInMaanden = null,
    Object? aflosTermijnInMaanden = null,
    Object? hypotheekvorm = null,
    Object? termijnen = null,
    Object? rente = null,
    Object? boeteVrijPercentage = null,
    Object? usePeriodeInMaanden = null,
    Object? minLening = null,
    Object? aanpassenLening = null,
    Object? volgende = null,
    Object? vorige = null,
    Object? order = null,
    Object? woningLeningKosten = null,
    Object? verbouwVerduurzaamKosten = null,
    Object? deelsAfgelosteLening = null,
    Object? datumDeelsAfgelosteLening = null,
    Object? afgesloten = null,
    Object? restSchuld = null,
  }) {
    return _then(_$$Hypotheek(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      optiesHypotheekToevoegen: null == optiesHypotheekToevoegen
          ? _value.optiesHypotheekToevoegen
          : optiesHypotheekToevoegen // ignore: cast_nullable_to_non_nullable
              as OptiesHypotheekToevoegen,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
      gewensteLening: null == gewensteLening
          ? _value.gewensteLening
          : gewensteLening // ignore: cast_nullable_to_non_nullable
              as double,
      normInkomen: freezed == normInkomen
          ? _value.normInkomen
          : normInkomen // ignore: cast_nullable_to_non_nullable
              as NormInkomen,
      normWoningwaarde: freezed == normWoningwaarde
          ? _value.normWoningwaarde
          : normWoningwaarde // ignore: cast_nullable_to_non_nullable
              as NormWoningwaarde,
      normNhg: freezed == normNhg
          ? _value.normNhg
          : normNhg // ignore: cast_nullable_to_non_nullable
              as NormNhg,
      startDatum: null == startDatum
          ? _value.startDatum
          : startDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startDatumAflossen: null == startDatumAflossen
          ? _value.startDatumAflossen
          : startDatumAflossen // ignore: cast_nullable_to_non_nullable
              as DateTime,
      eindDatum: null == eindDatum
          ? _value.eindDatum
          : eindDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      periodeInMaanden: null == periodeInMaanden
          ? _value.periodeInMaanden
          : periodeInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      aflosTermijnInMaanden: null == aflosTermijnInMaanden
          ? _value.aflosTermijnInMaanden
          : aflosTermijnInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      hypotheekvorm: null == hypotheekvorm
          ? _value.hypotheekvorm
          : hypotheekvorm // ignore: cast_nullable_to_non_nullable
              as HypotheekVorm,
      termijnen: null == termijnen
          ? _value.termijnen
          : termijnen // ignore: cast_nullable_to_non_nullable
              as IList<Termijn>,
      rente: null == rente
          ? _value.rente
          : rente // ignore: cast_nullable_to_non_nullable
              as double,
      boeteVrijPercentage: null == boeteVrijPercentage
          ? _value.boeteVrijPercentage
          : boeteVrijPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      usePeriodeInMaanden: null == usePeriodeInMaanden
          ? _value.usePeriodeInMaanden
          : usePeriodeInMaanden // ignore: cast_nullable_to_non_nullable
              as bool,
      minLening: null == minLening
          ? _value.minLening
          : minLening // ignore: cast_nullable_to_non_nullable
              as double,
      aanpassenLening: null == aanpassenLening
          ? _value.aanpassenLening
          : aanpassenLening // ignore: cast_nullable_to_non_nullable
              as IList<LeningAanpassen>,
      volgende: null == volgende
          ? _value.volgende
          : volgende // ignore: cast_nullable_to_non_nullable
              as String,
      vorige: null == vorige
          ? _value.vorige
          : vorige // ignore: cast_nullable_to_non_nullable
              as String,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as IMap<String, int>,
      woningLeningKosten: null == woningLeningKosten
          ? _value.woningLeningKosten
          : woningLeningKosten // ignore: cast_nullable_to_non_nullable
              as WoningLeningKosten,
      verbouwVerduurzaamKosten: null == verbouwVerduurzaamKosten
          ? _value.verbouwVerduurzaamKosten
          : verbouwVerduurzaamKosten // ignore: cast_nullable_to_non_nullable
              as VerbouwVerduurzaamKosten,
      deelsAfgelosteLening: null == deelsAfgelosteLening
          ? _value.deelsAfgelosteLening
          : deelsAfgelosteLening // ignore: cast_nullable_to_non_nullable
              as bool,
      datumDeelsAfgelosteLening: null == datumDeelsAfgelosteLening
          ? _value.datumDeelsAfgelosteLening
          : datumDeelsAfgelosteLening // ignore: cast_nullable_to_non_nullable
              as DateTime,
      afgesloten: null == afgesloten
          ? _value.afgesloten
          : afgesloten // ignore: cast_nullable_to_non_nullable
              as bool,
      restSchuld: null == restSchuld
          ? _value.restSchuld
          : restSchuld // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$$Hypotheek extends $Hypotheek with DiagnosticableTreeMixin {
  const _$$Hypotheek(
      {required this.id,
      required this.omschrijving,
      required this.optiesHypotheekToevoegen,
      this.lening = 0,
      this.gewensteLening = 0,
      this.normInkomen = const NormInkomen(omschrijving: 'Inkomen'),
      this.normWoningwaarde =
          const NormWoningwaarde(omschrijving: 'Woningwaarde'),
      this.normNhg = const NormNhg(omschrijving: 'NHG'),
      required this.startDatum,
      required this.startDatumAflossen,
      required this.eindDatum,
      required this.periodeInMaanden,
      required this.aflosTermijnInMaanden,
      required this.hypotheekvorm,
      this.termijnen = const IListConst([]),
      required this.rente,
      required this.boeteVrijPercentage,
      required this.usePeriodeInMaanden,
      required this.minLening,
      this.aanpassenLening = const IListConst([]),
      this.volgende = "",
      this.vorige = "",
      this.order = const IMapConst({}),
      this.woningLeningKosten = const WoningLeningKosten(),
      this.verbouwVerduurzaamKosten = const VerbouwVerduurzaamKosten(),
      required this.deelsAfgelosteLening,
      required this.datumDeelsAfgelosteLening,
      required this.afgesloten,
      this.restSchuld = 0.0})
      : super._();

  factory _$$Hypotheek.fromJson(Map<String, dynamic> json) =>
      _$$$HypotheekFromJson(json);

  @override
  final String id;
  @override
  final String omschrijving;
  @override
  final OptiesHypotheekToevoegen optiesHypotheekToevoegen;
  @override
  @JsonKey()
  final double lening;
  @override
  @JsonKey()
  final double gewensteLening;
  @override
  @JsonKey()
  final NormInkomen normInkomen;
  @override
  @JsonKey()
  final NormWoningwaarde normWoningwaarde;
  @override
  @JsonKey()
  final NormNhg normNhg;
  @override
  final DateTime startDatum;
  @override
  final DateTime startDatumAflossen;
  @override
  final DateTime eindDatum;
  @override
  final int periodeInMaanden;
  @override
  final int aflosTermijnInMaanden;
  @override
  final HypotheekVorm hypotheekvorm;
  @override
  @JsonKey()
  final IList<Termijn> termijnen;
  @override
  final double rente;
  @override
  final double boeteVrijPercentage;
  @override
  final bool usePeriodeInMaanden;
  @override
  final double minLening;
  @override
  @JsonKey()
  final IList<LeningAanpassen> aanpassenLening;
  @override
  @JsonKey()
  final String volgende;
  @override
  @JsonKey()
  final String vorige;
  @override
  @JsonKey()
  final IMap<String, int> order;
  @override
  @JsonKey()
  final WoningLeningKosten woningLeningKosten;
  @override
  @JsonKey()
  final VerbouwVerduurzaamKosten verbouwVerduurzaamKosten;
  @override
  final bool deelsAfgelosteLening;
  @override
  final DateTime datumDeelsAfgelosteLening;
  @override
  final bool afgesloten;
  @override
  @JsonKey()
  final double restSchuld;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Hypotheek(id: $id, omschrijving: $omschrijving, optiesHypotheekToevoegen: $optiesHypotheekToevoegen, lening: $lening, gewensteLening: $gewensteLening, normInkomen: $normInkomen, normWoningwaarde: $normWoningwaarde, normNhg: $normNhg, startDatum: $startDatum, startDatumAflossen: $startDatumAflossen, eindDatum: $eindDatum, periodeInMaanden: $periodeInMaanden, aflosTermijnInMaanden: $aflosTermijnInMaanden, hypotheekvorm: $hypotheekvorm, termijnen: $termijnen, rente: $rente, boeteVrijPercentage: $boeteVrijPercentage, usePeriodeInMaanden: $usePeriodeInMaanden, minLening: $minLening, aanpassenLening: $aanpassenLening, volgende: $volgende, vorige: $vorige, order: $order, woningLeningKosten: $woningLeningKosten, verbouwVerduurzaamKosten: $verbouwVerduurzaamKosten, deelsAfgelosteLening: $deelsAfgelosteLening, datumDeelsAfgelosteLening: $datumDeelsAfgelosteLening, afgesloten: $afgesloten, restSchuld: $restSchuld)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Hypotheek'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('omschrijving', omschrijving))
      ..add(DiagnosticsProperty(
          'optiesHypotheekToevoegen', optiesHypotheekToevoegen))
      ..add(DiagnosticsProperty('lening', lening))
      ..add(DiagnosticsProperty('gewensteLening', gewensteLening))
      ..add(DiagnosticsProperty('normInkomen', normInkomen))
      ..add(DiagnosticsProperty('normWoningwaarde', normWoningwaarde))
      ..add(DiagnosticsProperty('normNhg', normNhg))
      ..add(DiagnosticsProperty('startDatum', startDatum))
      ..add(DiagnosticsProperty('startDatumAflossen', startDatumAflossen))
      ..add(DiagnosticsProperty('eindDatum', eindDatum))
      ..add(DiagnosticsProperty('periodeInMaanden', periodeInMaanden))
      ..add(DiagnosticsProperty('aflosTermijnInMaanden', aflosTermijnInMaanden))
      ..add(DiagnosticsProperty('hypotheekvorm', hypotheekvorm))
      ..add(DiagnosticsProperty('termijnen', termijnen))
      ..add(DiagnosticsProperty('rente', rente))
      ..add(DiagnosticsProperty('boeteVrijPercentage', boeteVrijPercentage))
      ..add(DiagnosticsProperty('usePeriodeInMaanden', usePeriodeInMaanden))
      ..add(DiagnosticsProperty('minLening', minLening))
      ..add(DiagnosticsProperty('aanpassenLening', aanpassenLening))
      ..add(DiagnosticsProperty('volgende', volgende))
      ..add(DiagnosticsProperty('vorige', vorige))
      ..add(DiagnosticsProperty('order', order))
      ..add(DiagnosticsProperty('woningLeningKosten', woningLeningKosten))
      ..add(DiagnosticsProperty(
          'verbouwVerduurzaamKosten', verbouwVerduurzaamKosten))
      ..add(DiagnosticsProperty('deelsAfgelosteLening', deelsAfgelosteLening))
      ..add(DiagnosticsProperty(
          'datumDeelsAfgelosteLening', datumDeelsAfgelosteLening))
      ..add(DiagnosticsProperty('afgesloten', afgesloten))
      ..add(DiagnosticsProperty('restSchuld', restSchuld));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$$Hypotheek &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(
                    other.optiesHypotheekToevoegen, optiesHypotheekToevoegen) ||
                other.optiesHypotheekToevoegen == optiesHypotheekToevoegen) &&
            (identical(other.lening, lening) || other.lening == lening) &&
            (identical(other.gewensteLening, gewensteLening) ||
                other.gewensteLening == gewensteLening) &&
            const DeepCollectionEquality()
                .equals(other.normInkomen, normInkomen) &&
            const DeepCollectionEquality()
                .equals(other.normWoningwaarde, normWoningwaarde) &&
            const DeepCollectionEquality().equals(other.normNhg, normNhg) &&
            (identical(other.startDatum, startDatum) ||
                other.startDatum == startDatum) &&
            (identical(other.startDatumAflossen, startDatumAflossen) ||
                other.startDatumAflossen == startDatumAflossen) &&
            (identical(other.eindDatum, eindDatum) ||
                other.eindDatum == eindDatum) &&
            (identical(other.periodeInMaanden, periodeInMaanden) ||
                other.periodeInMaanden == periodeInMaanden) &&
            (identical(other.aflosTermijnInMaanden, aflosTermijnInMaanden) ||
                other.aflosTermijnInMaanden == aflosTermijnInMaanden) &&
            (identical(other.hypotheekvorm, hypotheekvorm) ||
                other.hypotheekvorm == hypotheekvorm) &&
            const DeepCollectionEquality().equals(other.termijnen, termijnen) &&
            (identical(other.rente, rente) || other.rente == rente) &&
            (identical(other.boeteVrijPercentage, boeteVrijPercentage) ||
                other.boeteVrijPercentage == boeteVrijPercentage) &&
            (identical(other.usePeriodeInMaanden, usePeriodeInMaanden) ||
                other.usePeriodeInMaanden == usePeriodeInMaanden) &&
            (identical(other.minLening, minLening) ||
                other.minLening == minLening) &&
            const DeepCollectionEquality()
                .equals(other.aanpassenLening, aanpassenLening) &&
            (identical(other.volgende, volgende) ||
                other.volgende == volgende) &&
            (identical(other.vorige, vorige) || other.vorige == vorige) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.woningLeningKosten, woningLeningKosten) ||
                other.woningLeningKosten == woningLeningKosten) &&
            (identical(
                    other.verbouwVerduurzaamKosten, verbouwVerduurzaamKosten) ||
                other.verbouwVerduurzaamKosten == verbouwVerduurzaamKosten) &&
            (identical(other.deelsAfgelosteLening, deelsAfgelosteLening) ||
                other.deelsAfgelosteLening == deelsAfgelosteLening) &&
            (identical(other.datumDeelsAfgelosteLening,
                    datumDeelsAfgelosteLening) ||
                other.datumDeelsAfgelosteLening == datumDeelsAfgelosteLening) &&
            (identical(other.afgesloten, afgesloten) ||
                other.afgesloten == afgesloten) &&
            (identical(other.restSchuld, restSchuld) ||
                other.restSchuld == restSchuld));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        omschrijving,
        optiesHypotheekToevoegen,
        lening,
        gewensteLening,
        const DeepCollectionEquality().hash(normInkomen),
        const DeepCollectionEquality().hash(normWoningwaarde),
        const DeepCollectionEquality().hash(normNhg),
        startDatum,
        startDatumAflossen,
        eindDatum,
        periodeInMaanden,
        aflosTermijnInMaanden,
        hypotheekvorm,
        const DeepCollectionEquality().hash(termijnen),
        rente,
        boeteVrijPercentage,
        usePeriodeInMaanden,
        minLening,
        const DeepCollectionEquality().hash(aanpassenLening),
        volgende,
        vorige,
        order,
        woningLeningKosten,
        verbouwVerduurzaamKosten,
        deelsAfgelosteLening,
        datumDeelsAfgelosteLening,
        afgesloten,
        restSchuld
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$$HypotheekCopyWith<_$$Hypotheek> get copyWith =>
      __$$$HypotheekCopyWithImpl<_$$Hypotheek>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$$HypotheekToJson(
      this,
    );
  }
}

abstract class $Hypotheek extends Hypotheek {
  const factory $Hypotheek(
      {required final String id,
      required final String omschrijving,
      required final OptiesHypotheekToevoegen optiesHypotheekToevoegen,
      final double lening,
      final double gewensteLening,
      final NormInkomen normInkomen,
      final NormWoningwaarde normWoningwaarde,
      final NormNhg normNhg,
      required final DateTime startDatum,
      required final DateTime startDatumAflossen,
      required final DateTime eindDatum,
      required final int periodeInMaanden,
      required final int aflosTermijnInMaanden,
      required final HypotheekVorm hypotheekvorm,
      final IList<Termijn> termijnen,
      required final double rente,
      required final double boeteVrijPercentage,
      required final bool usePeriodeInMaanden,
      required final double minLening,
      final IList<LeningAanpassen> aanpassenLening,
      final String volgende,
      final String vorige,
      final IMap<String, int> order,
      final WoningLeningKosten woningLeningKosten,
      final VerbouwVerduurzaamKosten verbouwVerduurzaamKosten,
      required final bool deelsAfgelosteLening,
      required final DateTime datumDeelsAfgelosteLening,
      required final bool afgesloten,
      final double restSchuld}) = _$$Hypotheek;
  const $Hypotheek._() : super._();

  factory $Hypotheek.fromJson(Map<String, dynamic> json) =
      _$$Hypotheek.fromJson;

  @override
  String get id;
  @override
  String get omschrijving;
  @override
  OptiesHypotheekToevoegen get optiesHypotheekToevoegen;
  @override
  double get lening;
  @override
  double get gewensteLening;
  @override
  NormInkomen get normInkomen;
  @override
  NormWoningwaarde get normWoningwaarde;
  @override
  NormNhg get normNhg;
  @override
  DateTime get startDatum;
  @override
  DateTime get startDatumAflossen;
  @override
  DateTime get eindDatum;
  @override
  int get periodeInMaanden;
  @override
  int get aflosTermijnInMaanden;
  @override
  HypotheekVorm get hypotheekvorm;
  @override
  IList<Termijn> get termijnen;
  @override
  double get rente;
  @override
  double get boeteVrijPercentage;
  @override
  bool get usePeriodeInMaanden;
  @override
  double get minLening;
  @override
  IList<LeningAanpassen> get aanpassenLening;
  @override
  String get volgende;
  @override
  String get vorige;
  @override
  IMap<String, int> get order;
  @override
  WoningLeningKosten get woningLeningKosten;
  @override
  VerbouwVerduurzaamKosten get verbouwVerduurzaamKosten;
  @override
  bool get deelsAfgelosteLening;
  @override
  DateTime get datumDeelsAfgelosteLening;
  @override
  bool get afgesloten;
  @override
  double get restSchuld;
  @override
  @JsonKey(ignore: true)
  _$$$HypotheekCopyWith<_$$Hypotheek> get copyWith =>
      throw _privateConstructorUsedError;
}
