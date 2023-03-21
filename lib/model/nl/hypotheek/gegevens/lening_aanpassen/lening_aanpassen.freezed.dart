// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lening_aanpassen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LeningAanpassen _$LeningAanpassenFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'termijnen':
      return LenningAanpassenInTermijnen.fromJson(json);
    case 'eenmalig':
      return LenningAanpassenEenmalig.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'LeningAanpassen',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$LeningAanpassen {
  DateTime get datum => throw _privateConstructorUsedError;
  LeningAanpassenOpties get leningAanpassenOpties =>
      throw _privateConstructorUsedError;
  double get bedrag => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)
        termijnen,
    required TResult Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)
        eenmalig,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)?
        termijnen,
    TResult? Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)?
        eenmalig,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)?
        termijnen,
    TResult Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)?
        eenmalig,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LenningAanpassenInTermijnen value) termijnen,
    required TResult Function(LenningAanpassenEenmalig value) eenmalig,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LenningAanpassenInTermijnen value)? termijnen,
    TResult? Function(LenningAanpassenEenmalig value)? eenmalig,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LenningAanpassenInTermijnen value)? termijnen,
    TResult Function(LenningAanpassenEenmalig value)? eenmalig,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeningAanpassenCopyWith<LeningAanpassen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeningAanpassenCopyWith<$Res> {
  factory $LeningAanpassenCopyWith(
          LeningAanpassen value, $Res Function(LeningAanpassen) then) =
      _$LeningAanpassenCopyWithImpl<$Res, LeningAanpassen>;
  @useResult
  $Res call(
      {DateTime datum,
      LeningAanpassenOpties leningAanpassenOpties,
      double bedrag});
}

/// @nodoc
class _$LeningAanpassenCopyWithImpl<$Res, $Val extends LeningAanpassen>
    implements $LeningAanpassenCopyWith<$Res> {
  _$LeningAanpassenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? leningAanpassenOpties = null,
    Object? bedrag = null,
  }) {
    return _then(_value.copyWith(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      leningAanpassenOpties: null == leningAanpassenOpties
          ? _value.leningAanpassenOpties
          : leningAanpassenOpties // ignore: cast_nullable_to_non_nullable
              as LeningAanpassenOpties,
      bedrag: null == bedrag
          ? _value.bedrag
          : bedrag // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LenningAanpassenInTermijnenCopyWith<$Res>
    implements $LeningAanpassenCopyWith<$Res> {
  factory _$$LenningAanpassenInTermijnenCopyWith(
          _$LenningAanpassenInTermijnen value,
          $Res Function(_$LenningAanpassenInTermijnen) then) =
      __$$LenningAanpassenInTermijnenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime datum,
      LeningAanpassenOpties leningAanpassenOpties,
      double bedrag,
      int termijnen,
      int periodeInMaanden});
}

/// @nodoc
class __$$LenningAanpassenInTermijnenCopyWithImpl<$Res>
    extends _$LeningAanpassenCopyWithImpl<$Res, _$LenningAanpassenInTermijnen>
    implements _$$LenningAanpassenInTermijnenCopyWith<$Res> {
  __$$LenningAanpassenInTermijnenCopyWithImpl(
      _$LenningAanpassenInTermijnen _value,
      $Res Function(_$LenningAanpassenInTermijnen) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? leningAanpassenOpties = null,
    Object? bedrag = null,
    Object? termijnen = null,
    Object? periodeInMaanden = null,
  }) {
    return _then(_$LenningAanpassenInTermijnen(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      leningAanpassenOpties: null == leningAanpassenOpties
          ? _value.leningAanpassenOpties
          : leningAanpassenOpties // ignore: cast_nullable_to_non_nullable
              as LeningAanpassenOpties,
      bedrag: null == bedrag
          ? _value.bedrag
          : bedrag // ignore: cast_nullable_to_non_nullable
              as double,
      termijnen: null == termijnen
          ? _value.termijnen
          : termijnen // ignore: cast_nullable_to_non_nullable
              as int,
      periodeInMaanden: null == periodeInMaanden
          ? _value.periodeInMaanden
          : periodeInMaanden // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LenningAanpassenInTermijnen extends LenningAanpassenInTermijnen
    with DiagnosticableTreeMixin {
  const _$LenningAanpassenInTermijnen(
      {required this.datum,
      this.leningAanpassenOpties = LeningAanpassenOpties.aflossen,
      required this.bedrag,
      required this.termijnen,
      required this.periodeInMaanden,
      final String? $type})
      : $type = $type ?? 'termijnen',
        super._();

  factory _$LenningAanpassenInTermijnen.fromJson(Map<String, dynamic> json) =>
      _$$LenningAanpassenInTermijnenFromJson(json);

  @override
  final DateTime datum;
  @override
  @JsonKey()
  final LeningAanpassenOpties leningAanpassenOpties;
  @override
  final double bedrag;
  @override
  final int termijnen;
  @override
  final int periodeInMaanden;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LeningAanpassen.termijnen(datum: $datum, leningAanpassenOpties: $leningAanpassenOpties, bedrag: $bedrag, termijnen: $termijnen, periodeInMaanden: $periodeInMaanden)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LeningAanpassen.termijnen'))
      ..add(DiagnosticsProperty('datum', datum))
      ..add(DiagnosticsProperty('leningAanpassenOpties', leningAanpassenOpties))
      ..add(DiagnosticsProperty('bedrag', bedrag))
      ..add(DiagnosticsProperty('termijnen', termijnen))
      ..add(DiagnosticsProperty('periodeInMaanden', periodeInMaanden));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LenningAanpassenInTermijnen &&
            (identical(other.datum, datum) || other.datum == datum) &&
            (identical(other.leningAanpassenOpties, leningAanpassenOpties) ||
                other.leningAanpassenOpties == leningAanpassenOpties) &&
            (identical(other.bedrag, bedrag) || other.bedrag == bedrag) &&
            (identical(other.termijnen, termijnen) ||
                other.termijnen == termijnen) &&
            (identical(other.periodeInMaanden, periodeInMaanden) ||
                other.periodeInMaanden == periodeInMaanden));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, datum, leningAanpassenOpties,
      bedrag, termijnen, periodeInMaanden);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LenningAanpassenInTermijnenCopyWith<_$LenningAanpassenInTermijnen>
      get copyWith => __$$LenningAanpassenInTermijnenCopyWithImpl<
          _$LenningAanpassenInTermijnen>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)
        termijnen,
    required TResult Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)
        eenmalig,
  }) {
    return termijnen(
        datum, leningAanpassenOpties, bedrag, this.termijnen, periodeInMaanden);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)?
        termijnen,
    TResult? Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)?
        eenmalig,
  }) {
    return termijnen?.call(
        datum, leningAanpassenOpties, bedrag, this.termijnen, periodeInMaanden);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)?
        termijnen,
    TResult Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)?
        eenmalig,
    required TResult orElse(),
  }) {
    if (termijnen != null) {
      return termijnen(datum, leningAanpassenOpties, bedrag, this.termijnen,
          periodeInMaanden);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LenningAanpassenInTermijnen value) termijnen,
    required TResult Function(LenningAanpassenEenmalig value) eenmalig,
  }) {
    return termijnen(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LenningAanpassenInTermijnen value)? termijnen,
    TResult? Function(LenningAanpassenEenmalig value)? eenmalig,
  }) {
    return termijnen?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LenningAanpassenInTermijnen value)? termijnen,
    TResult Function(LenningAanpassenEenmalig value)? eenmalig,
    required TResult orElse(),
  }) {
    if (termijnen != null) {
      return termijnen(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LenningAanpassenInTermijnenToJson(
      this,
    );
  }
}

abstract class LenningAanpassenInTermijnen extends LeningAanpassen {
  const factory LenningAanpassenInTermijnen(
      {required final DateTime datum,
      final LeningAanpassenOpties leningAanpassenOpties,
      required final double bedrag,
      required final int termijnen,
      required final int periodeInMaanden}) = _$LenningAanpassenInTermijnen;
  const LenningAanpassenInTermijnen._() : super._();

  factory LenningAanpassenInTermijnen.fromJson(Map<String, dynamic> json) =
      _$LenningAanpassenInTermijnen.fromJson;

  @override
  DateTime get datum;
  @override
  LeningAanpassenOpties get leningAanpassenOpties;
  @override
  double get bedrag;
  int get termijnen;
  int get periodeInMaanden;
  @override
  @JsonKey(ignore: true)
  _$$LenningAanpassenInTermijnenCopyWith<_$LenningAanpassenInTermijnen>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LenningAanpassenEenmaligCopyWith<$Res>
    implements $LeningAanpassenCopyWith<$Res> {
  factory _$$LenningAanpassenEenmaligCopyWith(_$LenningAanpassenEenmalig value,
          $Res Function(_$LenningAanpassenEenmalig) then) =
      __$$LenningAanpassenEenmaligCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime datum,
      LeningAanpassenOpties leningAanpassenOpties,
      double bedrag});
}

/// @nodoc
class __$$LenningAanpassenEenmaligCopyWithImpl<$Res>
    extends _$LeningAanpassenCopyWithImpl<$Res, _$LenningAanpassenEenmalig>
    implements _$$LenningAanpassenEenmaligCopyWith<$Res> {
  __$$LenningAanpassenEenmaligCopyWithImpl(_$LenningAanpassenEenmalig _value,
      $Res Function(_$LenningAanpassenEenmalig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? leningAanpassenOpties = null,
    Object? bedrag = null,
  }) {
    return _then(_$LenningAanpassenEenmalig(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      leningAanpassenOpties: null == leningAanpassenOpties
          ? _value.leningAanpassenOpties
          : leningAanpassenOpties // ignore: cast_nullable_to_non_nullable
              as LeningAanpassenOpties,
      bedrag: null == bedrag
          ? _value.bedrag
          : bedrag // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LenningAanpassenEenmalig extends LenningAanpassenEenmalig
    with DiagnosticableTreeMixin {
  const _$LenningAanpassenEenmalig(
      {required this.datum,
      this.leningAanpassenOpties = LeningAanpassenOpties.aflossen,
      required this.bedrag,
      final String? $type})
      : $type = $type ?? 'eenmalig',
        super._();

  factory _$LenningAanpassenEenmalig.fromJson(Map<String, dynamic> json) =>
      _$$LenningAanpassenEenmaligFromJson(json);

  @override
  final DateTime datum;
  @override
  @JsonKey()
  final LeningAanpassenOpties leningAanpassenOpties;
  @override
  final double bedrag;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LeningAanpassen.eenmalig(datum: $datum, leningAanpassenOpties: $leningAanpassenOpties, bedrag: $bedrag)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LeningAanpassen.eenmalig'))
      ..add(DiagnosticsProperty('datum', datum))
      ..add(DiagnosticsProperty('leningAanpassenOpties', leningAanpassenOpties))
      ..add(DiagnosticsProperty('bedrag', bedrag));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LenningAanpassenEenmalig &&
            (identical(other.datum, datum) || other.datum == datum) &&
            (identical(other.leningAanpassenOpties, leningAanpassenOpties) ||
                other.leningAanpassenOpties == leningAanpassenOpties) &&
            (identical(other.bedrag, bedrag) || other.bedrag == bedrag));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, datum, leningAanpassenOpties, bedrag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LenningAanpassenEenmaligCopyWith<_$LenningAanpassenEenmalig>
      get copyWith =>
          __$$LenningAanpassenEenmaligCopyWithImpl<_$LenningAanpassenEenmalig>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)
        termijnen,
    required TResult Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)
        eenmalig,
  }) {
    return eenmalig(datum, leningAanpassenOpties, bedrag);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)?
        termijnen,
    TResult? Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)?
        eenmalig,
  }) {
    return eenmalig?.call(datum, leningAanpassenOpties, bedrag);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties,
            double bedrag,
            int termijnen,
            int periodeInMaanden)?
        termijnen,
    TResult Function(DateTime datum,
            LeningAanpassenOpties leningAanpassenOpties, double bedrag)?
        eenmalig,
    required TResult orElse(),
  }) {
    if (eenmalig != null) {
      return eenmalig(datum, leningAanpassenOpties, bedrag);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LenningAanpassenInTermijnen value) termijnen,
    required TResult Function(LenningAanpassenEenmalig value) eenmalig,
  }) {
    return eenmalig(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LenningAanpassenInTermijnen value)? termijnen,
    TResult? Function(LenningAanpassenEenmalig value)? eenmalig,
  }) {
    return eenmalig?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LenningAanpassenInTermijnen value)? termijnen,
    TResult Function(LenningAanpassenEenmalig value)? eenmalig,
    required TResult orElse(),
  }) {
    if (eenmalig != null) {
      return eenmalig(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LenningAanpassenEenmaligToJson(
      this,
    );
  }
}

abstract class LenningAanpassenEenmalig extends LeningAanpassen {
  const factory LenningAanpassenEenmalig(
      {required final DateTime datum,
      final LeningAanpassenOpties leningAanpassenOpties,
      required final double bedrag}) = _$LenningAanpassenEenmalig;
  const LenningAanpassenEenmalig._() : super._();

  factory LenningAanpassenEenmalig.fromJson(Map<String, dynamic> json) =
      _$LenningAanpassenEenmalig.fromJson;

  @override
  DateTime get datum;
  @override
  LeningAanpassenOpties get leningAanpassenOpties;
  @override
  double get bedrag;
  @override
  @JsonKey(ignore: true)
  _$$LenningAanpassenEenmaligCopyWith<_$LenningAanpassenEenmalig>
      get copyWith => throw _privateConstructorUsedError;
}
