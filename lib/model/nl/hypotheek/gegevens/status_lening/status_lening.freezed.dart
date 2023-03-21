// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_lening.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ParallelLeningen _$ParallelLeningenFromJson(Map<String, dynamic> json) {
  return _ParallelLeningen.fromJson(json);
}

/// @nodoc
mixin _$ParallelLeningen {
  IList<StatusLening> get list => throw _privateConstructorUsedError;
  double get somLeningen => throw _privateConstructorUsedError;
  double get somVerduurzaamKosten => throw _privateConstructorUsedError;
  double get somVerbouwKosten => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParallelLeningenCopyWith<ParallelLeningen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParallelLeningenCopyWith<$Res> {
  factory $ParallelLeningenCopyWith(
          ParallelLeningen value, $Res Function(ParallelLeningen) then) =
      _$ParallelLeningenCopyWithImpl<$Res, ParallelLeningen>;
  @useResult
  $Res call(
      {IList<StatusLening> list,
      double somLeningen,
      double somVerduurzaamKosten,
      double somVerbouwKosten});
}

/// @nodoc
class _$ParallelLeningenCopyWithImpl<$Res, $Val extends ParallelLeningen>
    implements $ParallelLeningenCopyWith<$Res> {
  _$ParallelLeningenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? somLeningen = null,
    Object? somVerduurzaamKosten = null,
    Object? somVerbouwKosten = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as IList<StatusLening>,
      somLeningen: null == somLeningen
          ? _value.somLeningen
          : somLeningen // ignore: cast_nullable_to_non_nullable
              as double,
      somVerduurzaamKosten: null == somVerduurzaamKosten
          ? _value.somVerduurzaamKosten
          : somVerduurzaamKosten // ignore: cast_nullable_to_non_nullable
              as double,
      somVerbouwKosten: null == somVerbouwKosten
          ? _value.somVerbouwKosten
          : somVerbouwKosten // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ParallelLeningenCopyWith<$Res>
    implements $ParallelLeningenCopyWith<$Res> {
  factory _$$_ParallelLeningenCopyWith(
          _$_ParallelLeningen value, $Res Function(_$_ParallelLeningen) then) =
      __$$_ParallelLeningenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {IList<StatusLening> list,
      double somLeningen,
      double somVerduurzaamKosten,
      double somVerbouwKosten});
}

/// @nodoc
class __$$_ParallelLeningenCopyWithImpl<$Res>
    extends _$ParallelLeningenCopyWithImpl<$Res, _$_ParallelLeningen>
    implements _$$_ParallelLeningenCopyWith<$Res> {
  __$$_ParallelLeningenCopyWithImpl(
      _$_ParallelLeningen _value, $Res Function(_$_ParallelLeningen) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? somLeningen = null,
    Object? somVerduurzaamKosten = null,
    Object? somVerbouwKosten = null,
  }) {
    return _then(_$_ParallelLeningen(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as IList<StatusLening>,
      somLeningen: null == somLeningen
          ? _value.somLeningen
          : somLeningen // ignore: cast_nullable_to_non_nullable
              as double,
      somVerduurzaamKosten: null == somVerduurzaamKosten
          ? _value.somVerduurzaamKosten
          : somVerduurzaamKosten // ignore: cast_nullable_to_non_nullable
              as double,
      somVerbouwKosten: null == somVerbouwKosten
          ? _value.somVerbouwKosten
          : somVerbouwKosten // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ParallelLeningen
    with DiagnosticableTreeMixin
    implements _ParallelLeningen {
  const _$_ParallelLeningen(
      {required this.list,
      required this.somLeningen,
      required this.somVerduurzaamKosten,
      required this.somVerbouwKosten});

  factory _$_ParallelLeningen.fromJson(Map<String, dynamic> json) =>
      _$$_ParallelLeningenFromJson(json);

  @override
  final IList<StatusLening> list;
  @override
  final double somLeningen;
  @override
  final double somVerduurzaamKosten;
  @override
  final double somVerbouwKosten;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ParallelLeningen(list: $list, somLeningen: $somLeningen, somVerduurzaamKosten: $somVerduurzaamKosten, somVerbouwKosten: $somVerbouwKosten)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ParallelLeningen'))
      ..add(DiagnosticsProperty('list', list))
      ..add(DiagnosticsProperty('somLeningen', somLeningen))
      ..add(DiagnosticsProperty('somVerduurzaamKosten', somVerduurzaamKosten))
      ..add(DiagnosticsProperty('somVerbouwKosten', somVerbouwKosten));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ParallelLeningen &&
            const DeepCollectionEquality().equals(other.list, list) &&
            (identical(other.somLeningen, somLeningen) ||
                other.somLeningen == somLeningen) &&
            (identical(other.somVerduurzaamKosten, somVerduurzaamKosten) ||
                other.somVerduurzaamKosten == somVerduurzaamKosten) &&
            (identical(other.somVerbouwKosten, somVerbouwKosten) ||
                other.somVerbouwKosten == somVerbouwKosten));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(list),
      somLeningen,
      somVerduurzaamKosten,
      somVerbouwKosten);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ParallelLeningenCopyWith<_$_ParallelLeningen> get copyWith =>
      __$$_ParallelLeningenCopyWithImpl<_$_ParallelLeningen>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ParallelLeningenToJson(
      this,
    );
  }
}

abstract class _ParallelLeningen implements ParallelLeningen {
  const factory _ParallelLeningen(
      {required final IList<StatusLening> list,
      required final double somLeningen,
      required final double somVerduurzaamKosten,
      required final double somVerbouwKosten}) = _$_ParallelLeningen;

  factory _ParallelLeningen.fromJson(Map<String, dynamic> json) =
      _$_ParallelLeningen.fromJson;

  @override
  IList<StatusLening> get list;
  @override
  double get somLeningen;
  @override
  double get somVerduurzaamKosten;
  @override
  double get somVerbouwKosten;
  @override
  @JsonKey(ignore: true)
  _$$_ParallelLeningenCopyWith<_$_ParallelLeningen> get copyWith =>
      throw _privateConstructorUsedError;
}

StatusLening _$StatusLeningFromJson(Map<String, dynamic> json) {
  return _StatusLening.fromJson(json);
}

/// @nodoc
mixin _$StatusLening {
  String get id => throw _privateConstructorUsedError;
  double get lening => throw _privateConstructorUsedError;
  int get periode => throw _privateConstructorUsedError;
  double get rente => throw _privateConstructorUsedError;
  double get toetsRente => throw _privateConstructorUsedError;
  int get aflosTermijnInMaanden => throw _privateConstructorUsedError;
  HypotheekVorm get hypotheekVorm => throw _privateConstructorUsedError;
  double get verduurzaamKosten => throw _privateConstructorUsedError;
  double get verbouwKosten => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatusLeningCopyWith<StatusLening> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatusLeningCopyWith<$Res> {
  factory $StatusLeningCopyWith(
          StatusLening value, $Res Function(StatusLening) then) =
      _$StatusLeningCopyWithImpl<$Res, StatusLening>;
  @useResult
  $Res call(
      {String id,
      double lening,
      int periode,
      double rente,
      double toetsRente,
      int aflosTermijnInMaanden,
      HypotheekVorm hypotheekVorm,
      double verduurzaamKosten,
      double verbouwKosten});
}

/// @nodoc
class _$StatusLeningCopyWithImpl<$Res, $Val extends StatusLening>
    implements $StatusLeningCopyWith<$Res> {
  _$StatusLeningCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lening = null,
    Object? periode = null,
    Object? rente = null,
    Object? toetsRente = null,
    Object? aflosTermijnInMaanden = null,
    Object? hypotheekVorm = null,
    Object? verduurzaamKosten = null,
    Object? verbouwKosten = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
      periode: null == periode
          ? _value.periode
          : periode // ignore: cast_nullable_to_non_nullable
              as int,
      rente: null == rente
          ? _value.rente
          : rente // ignore: cast_nullable_to_non_nullable
              as double,
      toetsRente: null == toetsRente
          ? _value.toetsRente
          : toetsRente // ignore: cast_nullable_to_non_nullable
              as double,
      aflosTermijnInMaanden: null == aflosTermijnInMaanden
          ? _value.aflosTermijnInMaanden
          : aflosTermijnInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      hypotheekVorm: null == hypotheekVorm
          ? _value.hypotheekVorm
          : hypotheekVorm // ignore: cast_nullable_to_non_nullable
              as HypotheekVorm,
      verduurzaamKosten: null == verduurzaamKosten
          ? _value.verduurzaamKosten
          : verduurzaamKosten // ignore: cast_nullable_to_non_nullable
              as double,
      verbouwKosten: null == verbouwKosten
          ? _value.verbouwKosten
          : verbouwKosten // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_StatusLeningCopyWith<$Res>
    implements $StatusLeningCopyWith<$Res> {
  factory _$$_StatusLeningCopyWith(
          _$_StatusLening value, $Res Function(_$_StatusLening) then) =
      __$$_StatusLeningCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double lening,
      int periode,
      double rente,
      double toetsRente,
      int aflosTermijnInMaanden,
      HypotheekVorm hypotheekVorm,
      double verduurzaamKosten,
      double verbouwKosten});
}

/// @nodoc
class __$$_StatusLeningCopyWithImpl<$Res>
    extends _$StatusLeningCopyWithImpl<$Res, _$_StatusLening>
    implements _$$_StatusLeningCopyWith<$Res> {
  __$$_StatusLeningCopyWithImpl(
      _$_StatusLening _value, $Res Function(_$_StatusLening) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lening = null,
    Object? periode = null,
    Object? rente = null,
    Object? toetsRente = null,
    Object? aflosTermijnInMaanden = null,
    Object? hypotheekVorm = null,
    Object? verduurzaamKosten = null,
    Object? verbouwKosten = null,
  }) {
    return _then(_$_StatusLening(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
      periode: null == periode
          ? _value.periode
          : periode // ignore: cast_nullable_to_non_nullable
              as int,
      rente: null == rente
          ? _value.rente
          : rente // ignore: cast_nullable_to_non_nullable
              as double,
      toetsRente: null == toetsRente
          ? _value.toetsRente
          : toetsRente // ignore: cast_nullable_to_non_nullable
              as double,
      aflosTermijnInMaanden: null == aflosTermijnInMaanden
          ? _value.aflosTermijnInMaanden
          : aflosTermijnInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      hypotheekVorm: null == hypotheekVorm
          ? _value.hypotheekVorm
          : hypotheekVorm // ignore: cast_nullable_to_non_nullable
              as HypotheekVorm,
      verduurzaamKosten: null == verduurzaamKosten
          ? _value.verduurzaamKosten
          : verduurzaamKosten // ignore: cast_nullable_to_non_nullable
              as double,
      verbouwKosten: null == verbouwKosten
          ? _value.verbouwKosten
          : verbouwKosten // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_StatusLening with DiagnosticableTreeMixin implements _StatusLening {
  const _$_StatusLening(
      {required this.id,
      required this.lening,
      required this.periode,
      required this.rente,
      required this.toetsRente,
      required this.aflosTermijnInMaanden,
      required this.hypotheekVorm,
      required this.verduurzaamKosten,
      required this.verbouwKosten});

  factory _$_StatusLening.fromJson(Map<String, dynamic> json) =>
      _$$_StatusLeningFromJson(json);

  @override
  final String id;
  @override
  final double lening;
  @override
  final int periode;
  @override
  final double rente;
  @override
  final double toetsRente;
  @override
  final int aflosTermijnInMaanden;
  @override
  final HypotheekVorm hypotheekVorm;
  @override
  final double verduurzaamKosten;
  @override
  final double verbouwKosten;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StatusLening(id: $id, lening: $lening, periode: $periode, rente: $rente, toetsRente: $toetsRente, aflosTermijnInMaanden: $aflosTermijnInMaanden, hypotheekVorm: $hypotheekVorm, verduurzaamKosten: $verduurzaamKosten, verbouwKosten: $verbouwKosten)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StatusLening'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('lening', lening))
      ..add(DiagnosticsProperty('periode', periode))
      ..add(DiagnosticsProperty('rente', rente))
      ..add(DiagnosticsProperty('toetsRente', toetsRente))
      ..add(DiagnosticsProperty('aflosTermijnInMaanden', aflosTermijnInMaanden))
      ..add(DiagnosticsProperty('hypotheekVorm', hypotheekVorm))
      ..add(DiagnosticsProperty('verduurzaamKosten', verduurzaamKosten))
      ..add(DiagnosticsProperty('verbouwKosten', verbouwKosten));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_StatusLening &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lening, lening) || other.lening == lening) &&
            (identical(other.periode, periode) || other.periode == periode) &&
            (identical(other.rente, rente) || other.rente == rente) &&
            (identical(other.toetsRente, toetsRente) ||
                other.toetsRente == toetsRente) &&
            (identical(other.aflosTermijnInMaanden, aflosTermijnInMaanden) ||
                other.aflosTermijnInMaanden == aflosTermijnInMaanden) &&
            (identical(other.hypotheekVorm, hypotheekVorm) ||
                other.hypotheekVorm == hypotheekVorm) &&
            (identical(other.verduurzaamKosten, verduurzaamKosten) ||
                other.verduurzaamKosten == verduurzaamKosten) &&
            (identical(other.verbouwKosten, verbouwKosten) ||
                other.verbouwKosten == verbouwKosten));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      lening,
      periode,
      rente,
      toetsRente,
      aflosTermijnInMaanden,
      hypotheekVorm,
      verduurzaamKosten,
      verbouwKosten);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_StatusLeningCopyWith<_$_StatusLening> get copyWith =>
      __$$_StatusLeningCopyWithImpl<_$_StatusLening>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StatusLeningToJson(
      this,
    );
  }
}

abstract class _StatusLening implements StatusLening {
  const factory _StatusLening(
      {required final String id,
      required final double lening,
      required final int periode,
      required final double rente,
      required final double toetsRente,
      required final int aflosTermijnInMaanden,
      required final HypotheekVorm hypotheekVorm,
      required final double verduurzaamKosten,
      required final double verbouwKosten}) = _$_StatusLening;

  factory _StatusLening.fromJson(Map<String, dynamic> json) =
      _$_StatusLening.fromJson;

  @override
  String get id;
  @override
  double get lening;
  @override
  int get periode;
  @override
  double get rente;
  @override
  double get toetsRente;
  @override
  int get aflosTermijnInMaanden;
  @override
  HypotheekVorm get hypotheekVorm;
  @override
  double get verduurzaamKosten;
  @override
  double get verbouwKosten;
  @override
  @JsonKey(ignore: true)
  _$$_StatusLeningCopyWith<_$_StatusLening> get copyWith =>
      throw _privateConstructorUsedError;
}
