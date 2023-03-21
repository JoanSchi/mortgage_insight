// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'norm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Norm _$NormFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'normInkomen':
      return NormInkomen.fromJson(json);
    case 'normWoningwaarde':
      return NormWoningwaarde.fromJson(json);
    case 'normNhg':
      return NormNhg.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Norm',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Norm {
  String get omschrijving => throw _privateConstructorUsedError;
  double get totaal => throw _privateConstructorUsedError;
  double get resterend => throw _privateConstructorUsedError;
  dynamic get toepassen => throw _privateConstructorUsedError;
  dynamic get parameters => throw _privateConstructorUsedError;
  dynamic get bericht => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)
        normInkomen,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normWoningwaarde,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normNhg,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NormInkomen value) normInkomen,
    required TResult Function(NormWoningwaarde value) normWoningwaarde,
    required TResult Function(NormNhg value) normNhg,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NormInkomen value)? normInkomen,
    TResult? Function(NormWoningwaarde value)? normWoningwaarde,
    TResult? Function(NormNhg value)? normNhg,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NormInkomen value)? normInkomen,
    TResult Function(NormWoningwaarde value)? normWoningwaarde,
    TResult Function(NormNhg value)? normNhg,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NormCopyWith<Norm> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NormCopyWith<$Res> {
  factory $NormCopyWith(Norm value, $Res Function(Norm) then) =
      _$NormCopyWithImpl<$Res, Norm>;
  @useResult
  $Res call(
      {String omschrijving,
      double totaal,
      double resterend,
      dynamic toepassen,
      dynamic parameters,
      dynamic bericht});
}

/// @nodoc
class _$NormCopyWithImpl<$Res, $Val extends Norm>
    implements $NormCopyWith<$Res> {
  _$NormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? omschrijving = null,
    Object? totaal = null,
    Object? resterend = null,
    Object? toepassen = freezed,
    Object? parameters = freezed,
    Object? bericht = freezed,
  }) {
    return _then(_value.copyWith(
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      totaal: null == totaal
          ? _value.totaal
          : totaal // ignore: cast_nullable_to_non_nullable
              as double,
      resterend: null == resterend
          ? _value.resterend
          : resterend // ignore: cast_nullable_to_non_nullable
              as double,
      toepassen: freezed == toepassen
          ? _value.toepassen
          : toepassen // ignore: cast_nullable_to_non_nullable
              as dynamic,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as dynamic,
      bericht: freezed == bericht
          ? _value.bericht
          : bericht // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NormInkomenCopyWith<$Res> implements $NormCopyWith<$Res> {
  factory _$$NormInkomenCopyWith(
          _$NormInkomen value, $Res Function(_$NormInkomen) then) =
      __$$NormInkomenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String omschrijving,
      double totaal,
      double resterend,
      dynamic toepassen,
      dynamic parameters,
      dynamic bericht,
      int periode});
}

/// @nodoc
class __$$NormInkomenCopyWithImpl<$Res>
    extends _$NormCopyWithImpl<$Res, _$NormInkomen>
    implements _$$NormInkomenCopyWith<$Res> {
  __$$NormInkomenCopyWithImpl(
      _$NormInkomen _value, $Res Function(_$NormInkomen) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? omschrijving = null,
    Object? totaal = null,
    Object? resterend = null,
    Object? toepassen = freezed,
    Object? parameters = freezed,
    Object? bericht = freezed,
    Object? periode = null,
  }) {
    return _then(_$NormInkomen(
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      totaal: null == totaal
          ? _value.totaal
          : totaal // ignore: cast_nullable_to_non_nullable
              as double,
      resterend: null == resterend
          ? _value.resterend
          : resterend // ignore: cast_nullable_to_non_nullable
              as double,
      toepassen: freezed == toepassen ? _value.toepassen! : toepassen,
      parameters: freezed == parameters ? _value.parameters! : parameters,
      bericht: freezed == bericht ? _value.bericht! : bericht,
      periode: null == periode
          ? _value.periode
          : periode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NormInkomen with DiagnosticableTreeMixin implements NormInkomen {
  const _$NormInkomen(
      {required this.omschrijving,
      this.totaal = 0.0,
      this.resterend = 0.0,
      this.toepassen = false,
      this.parameters = const IMapConst({}),
      this.bericht = const IListConst([]),
      this.periode = 0,
      final String? $type})
      : $type = $type ?? 'normInkomen';

  factory _$NormInkomen.fromJson(Map<String, dynamic> json) =>
      _$$NormInkomenFromJson(json);

  @override
  final String omschrijving;
  @override
  @JsonKey()
  final double totaal;
  @override
  @JsonKey()
  final double resterend;
  @override
  @JsonKey()
  final dynamic toepassen;
  @override
  @JsonKey()
  final dynamic parameters;
  @override
  @JsonKey()
  final dynamic bericht;
  @override
  @JsonKey()
  final int periode;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Norm.normInkomen(omschrijving: $omschrijving, totaal: $totaal, resterend: $resterend, toepassen: $toepassen, parameters: $parameters, bericht: $bericht, periode: $periode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Norm.normInkomen'))
      ..add(DiagnosticsProperty('omschrijving', omschrijving))
      ..add(DiagnosticsProperty('totaal', totaal))
      ..add(DiagnosticsProperty('resterend', resterend))
      ..add(DiagnosticsProperty('toepassen', toepassen))
      ..add(DiagnosticsProperty('parameters', parameters))
      ..add(DiagnosticsProperty('bericht', bericht))
      ..add(DiagnosticsProperty('periode', periode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NormInkomen &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.totaal, totaal) || other.totaal == totaal) &&
            (identical(other.resterend, resterend) ||
                other.resterend == resterend) &&
            const DeepCollectionEquality().equals(other.toepassen, toepassen) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters) &&
            const DeepCollectionEquality().equals(other.bericht, bericht) &&
            (identical(other.periode, periode) || other.periode == periode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      omschrijving,
      totaal,
      resterend,
      const DeepCollectionEquality().hash(toepassen),
      const DeepCollectionEquality().hash(parameters),
      const DeepCollectionEquality().hash(bericht),
      periode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NormInkomenCopyWith<_$NormInkomen> get copyWith =>
      __$$NormInkomenCopyWithImpl<_$NormInkomen>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)
        normInkomen,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normWoningwaarde,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normNhg,
  }) {
    return normInkomen(omschrijving, totaal, resterend, toepassen, parameters,
        bericht, periode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
  }) {
    return normInkomen?.call(omschrijving, totaal, resterend, toepassen,
        parameters, bericht, periode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
    required TResult orElse(),
  }) {
    if (normInkomen != null) {
      return normInkomen(omschrijving, totaal, resterend, toepassen, parameters,
          bericht, periode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NormInkomen value) normInkomen,
    required TResult Function(NormWoningwaarde value) normWoningwaarde,
    required TResult Function(NormNhg value) normNhg,
  }) {
    return normInkomen(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NormInkomen value)? normInkomen,
    TResult? Function(NormWoningwaarde value)? normWoningwaarde,
    TResult? Function(NormNhg value)? normNhg,
  }) {
    return normInkomen?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NormInkomen value)? normInkomen,
    TResult Function(NormWoningwaarde value)? normWoningwaarde,
    TResult Function(NormNhg value)? normNhg,
    required TResult orElse(),
  }) {
    if (normInkomen != null) {
      return normInkomen(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NormInkomenToJson(
      this,
    );
  }
}

abstract class NormInkomen implements Norm {
  const factory NormInkomen(
      {required final String omschrijving,
      final double totaal,
      final double resterend,
      final dynamic toepassen,
      final dynamic parameters,
      final dynamic bericht,
      final int periode}) = _$NormInkomen;

  factory NormInkomen.fromJson(Map<String, dynamic> json) =
      _$NormInkomen.fromJson;

  @override
  String get omschrijving;
  @override
  double get totaal;
  @override
  double get resterend;
  @override
  dynamic get toepassen;
  @override
  dynamic get parameters;
  @override
  dynamic get bericht;
  int get periode;
  @override
  @JsonKey(ignore: true)
  _$$NormInkomenCopyWith<_$NormInkomen> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NormWoningwaardeCopyWith<$Res>
    implements $NormCopyWith<$Res> {
  factory _$$NormWoningwaardeCopyWith(
          _$NormWoningwaarde value, $Res Function(_$NormWoningwaarde) then) =
      __$$NormWoningwaardeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String omschrijving,
      double totaal,
      double verduurzaam,
      double resterend,
      dynamic toepassen,
      dynamic parameters,
      dynamic bericht});
}

/// @nodoc
class __$$NormWoningwaardeCopyWithImpl<$Res>
    extends _$NormCopyWithImpl<$Res, _$NormWoningwaarde>
    implements _$$NormWoningwaardeCopyWith<$Res> {
  __$$NormWoningwaardeCopyWithImpl(
      _$NormWoningwaarde _value, $Res Function(_$NormWoningwaarde) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? omschrijving = null,
    Object? totaal = null,
    Object? verduurzaam = null,
    Object? resterend = null,
    Object? toepassen = freezed,
    Object? parameters = freezed,
    Object? bericht = freezed,
  }) {
    return _then(_$NormWoningwaarde(
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      totaal: null == totaal
          ? _value.totaal
          : totaal // ignore: cast_nullable_to_non_nullable
              as double,
      verduurzaam: null == verduurzaam
          ? _value.verduurzaam
          : verduurzaam // ignore: cast_nullable_to_non_nullable
              as double,
      resterend: null == resterend
          ? _value.resterend
          : resterend // ignore: cast_nullable_to_non_nullable
              as double,
      toepassen: freezed == toepassen ? _value.toepassen! : toepassen,
      parameters: freezed == parameters ? _value.parameters! : parameters,
      bericht: freezed == bericht ? _value.bericht! : bericht,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NormWoningwaarde
    with DiagnosticableTreeMixin
    implements NormWoningwaarde {
  const _$NormWoningwaarde(
      {required this.omschrijving,
      this.totaal = 0.0,
      this.verduurzaam = 0.0,
      this.resterend = 0.0,
      this.toepassen = false,
      this.parameters = const IMapConst({}),
      this.bericht = const IListConst([]),
      final String? $type})
      : $type = $type ?? 'normWoningwaarde';

  factory _$NormWoningwaarde.fromJson(Map<String, dynamic> json) =>
      _$$NormWoningwaardeFromJson(json);

  @override
  final String omschrijving;
  @override
  @JsonKey()
  final double totaal;
  @override
  @JsonKey()
  final double verduurzaam;
  @override
  @JsonKey()
  final double resterend;
  @override
  @JsonKey()
  final dynamic toepassen;
  @override
  @JsonKey()
  final dynamic parameters;
  @override
  @JsonKey()
  final dynamic bericht;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Norm.normWoningwaarde(omschrijving: $omschrijving, totaal: $totaal, verduurzaam: $verduurzaam, resterend: $resterend, toepassen: $toepassen, parameters: $parameters, bericht: $bericht)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Norm.normWoningwaarde'))
      ..add(DiagnosticsProperty('omschrijving', omschrijving))
      ..add(DiagnosticsProperty('totaal', totaal))
      ..add(DiagnosticsProperty('verduurzaam', verduurzaam))
      ..add(DiagnosticsProperty('resterend', resterend))
      ..add(DiagnosticsProperty('toepassen', toepassen))
      ..add(DiagnosticsProperty('parameters', parameters))
      ..add(DiagnosticsProperty('bericht', bericht));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NormWoningwaarde &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.totaal, totaal) || other.totaal == totaal) &&
            (identical(other.verduurzaam, verduurzaam) ||
                other.verduurzaam == verduurzaam) &&
            (identical(other.resterend, resterend) ||
                other.resterend == resterend) &&
            const DeepCollectionEquality().equals(other.toepassen, toepassen) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters) &&
            const DeepCollectionEquality().equals(other.bericht, bericht));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      omschrijving,
      totaal,
      verduurzaam,
      resterend,
      const DeepCollectionEquality().hash(toepassen),
      const DeepCollectionEquality().hash(parameters),
      const DeepCollectionEquality().hash(bericht));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NormWoningwaardeCopyWith<_$NormWoningwaarde> get copyWith =>
      __$$NormWoningwaardeCopyWithImpl<_$NormWoningwaarde>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)
        normInkomen,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normWoningwaarde,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normNhg,
  }) {
    return normWoningwaarde(omschrijving, totaal, verduurzaam, resterend,
        toepassen, parameters, bericht);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
  }) {
    return normWoningwaarde?.call(omschrijving, totaal, verduurzaam, resterend,
        toepassen, parameters, bericht);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
    required TResult orElse(),
  }) {
    if (normWoningwaarde != null) {
      return normWoningwaarde(omschrijving, totaal, verduurzaam, resterend,
          toepassen, parameters, bericht);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NormInkomen value) normInkomen,
    required TResult Function(NormWoningwaarde value) normWoningwaarde,
    required TResult Function(NormNhg value) normNhg,
  }) {
    return normWoningwaarde(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NormInkomen value)? normInkomen,
    TResult? Function(NormWoningwaarde value)? normWoningwaarde,
    TResult? Function(NormNhg value)? normNhg,
  }) {
    return normWoningwaarde?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NormInkomen value)? normInkomen,
    TResult Function(NormWoningwaarde value)? normWoningwaarde,
    TResult Function(NormNhg value)? normNhg,
    required TResult orElse(),
  }) {
    if (normWoningwaarde != null) {
      return normWoningwaarde(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NormWoningwaardeToJson(
      this,
    );
  }
}

abstract class NormWoningwaarde implements Norm {
  const factory NormWoningwaarde(
      {required final String omschrijving,
      final double totaal,
      final double verduurzaam,
      final double resterend,
      final dynamic toepassen,
      final dynamic parameters,
      final dynamic bericht}) = _$NormWoningwaarde;

  factory NormWoningwaarde.fromJson(Map<String, dynamic> json) =
      _$NormWoningwaarde.fromJson;

  @override
  String get omschrijving;
  @override
  double get totaal;
  double get verduurzaam;
  @override
  double get resterend;
  @override
  dynamic get toepassen;
  @override
  dynamic get parameters;
  @override
  dynamic get bericht;
  @override
  @JsonKey(ignore: true)
  _$$NormWoningwaardeCopyWith<_$NormWoningwaarde> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NormNhgCopyWith<$Res> implements $NormCopyWith<$Res> {
  factory _$$NormNhgCopyWith(_$NormNhg value, $Res Function(_$NormNhg) then) =
      __$$NormNhgCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String omschrijving,
      double totaal,
      double verduurzaam,
      double resterend,
      dynamic toepassen,
      dynamic parameters,
      dynamic bericht});
}

/// @nodoc
class __$$NormNhgCopyWithImpl<$Res> extends _$NormCopyWithImpl<$Res, _$NormNhg>
    implements _$$NormNhgCopyWith<$Res> {
  __$$NormNhgCopyWithImpl(_$NormNhg _value, $Res Function(_$NormNhg) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? omschrijving = null,
    Object? totaal = null,
    Object? verduurzaam = null,
    Object? resterend = null,
    Object? toepassen = freezed,
    Object? parameters = freezed,
    Object? bericht = freezed,
  }) {
    return _then(_$NormNhg(
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      totaal: null == totaal
          ? _value.totaal
          : totaal // ignore: cast_nullable_to_non_nullable
              as double,
      verduurzaam: null == verduurzaam
          ? _value.verduurzaam
          : verduurzaam // ignore: cast_nullable_to_non_nullable
              as double,
      resterend: null == resterend
          ? _value.resterend
          : resterend // ignore: cast_nullable_to_non_nullable
              as double,
      toepassen: freezed == toepassen ? _value.toepassen! : toepassen,
      parameters: freezed == parameters ? _value.parameters! : parameters,
      bericht: freezed == bericht ? _value.bericht! : bericht,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NormNhg with DiagnosticableTreeMixin implements NormNhg {
  const _$NormNhg(
      {required this.omschrijving,
      this.totaal = 0.0,
      this.verduurzaam = 0.0,
      this.resterend = 0.0,
      this.toepassen = false,
      this.parameters = const IMapConst({}),
      this.bericht = const IListConst([]),
      final String? $type})
      : $type = $type ?? 'normNhg';

  factory _$NormNhg.fromJson(Map<String, dynamic> json) =>
      _$$NormNhgFromJson(json);

  @override
  final String omschrijving;
  @override
  @JsonKey()
  final double totaal;
  @override
  @JsonKey()
  final double verduurzaam;
  @override
  @JsonKey()
  final double resterend;
  @override
  @JsonKey()
  final dynamic toepassen;
  @override
  @JsonKey()
  final dynamic parameters;
  @override
  @JsonKey()
  final dynamic bericht;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Norm.normNhg(omschrijving: $omschrijving, totaal: $totaal, verduurzaam: $verduurzaam, resterend: $resterend, toepassen: $toepassen, parameters: $parameters, bericht: $bericht)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Norm.normNhg'))
      ..add(DiagnosticsProperty('omschrijving', omschrijving))
      ..add(DiagnosticsProperty('totaal', totaal))
      ..add(DiagnosticsProperty('verduurzaam', verduurzaam))
      ..add(DiagnosticsProperty('resterend', resterend))
      ..add(DiagnosticsProperty('toepassen', toepassen))
      ..add(DiagnosticsProperty('parameters', parameters))
      ..add(DiagnosticsProperty('bericht', bericht));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NormNhg &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.totaal, totaal) || other.totaal == totaal) &&
            (identical(other.verduurzaam, verduurzaam) ||
                other.verduurzaam == verduurzaam) &&
            (identical(other.resterend, resterend) ||
                other.resterend == resterend) &&
            const DeepCollectionEquality().equals(other.toepassen, toepassen) &&
            const DeepCollectionEquality()
                .equals(other.parameters, parameters) &&
            const DeepCollectionEquality().equals(other.bericht, bericht));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      omschrijving,
      totaal,
      verduurzaam,
      resterend,
      const DeepCollectionEquality().hash(toepassen),
      const DeepCollectionEquality().hash(parameters),
      const DeepCollectionEquality().hash(bericht));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NormNhgCopyWith<_$NormNhg> get copyWith =>
      __$$NormNhgCopyWithImpl<_$NormNhg>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)
        normInkomen,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normWoningwaarde,
    required TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)
        normNhg,
  }) {
    return normNhg(omschrijving, totaal, verduurzaam, resterend, toepassen,
        parameters, bericht);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult? Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
  }) {
    return normNhg?.call(omschrijving, totaal, verduurzaam, resterend,
        toepassen, parameters, bericht);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String omschrijving,
            double totaal,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht,
            int periode)?
        normInkomen,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normWoningwaarde,
    TResult Function(
            String omschrijving,
            double totaal,
            double verduurzaam,
            double resterend,
            dynamic toepassen,
            dynamic parameters,
            dynamic bericht)?
        normNhg,
    required TResult orElse(),
  }) {
    if (normNhg != null) {
      return normNhg(omschrijving, totaal, verduurzaam, resterend, toepassen,
          parameters, bericht);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NormInkomen value) normInkomen,
    required TResult Function(NormWoningwaarde value) normWoningwaarde,
    required TResult Function(NormNhg value) normNhg,
  }) {
    return normNhg(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NormInkomen value)? normInkomen,
    TResult? Function(NormWoningwaarde value)? normWoningwaarde,
    TResult? Function(NormNhg value)? normNhg,
  }) {
    return normNhg?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NormInkomen value)? normInkomen,
    TResult Function(NormWoningwaarde value)? normWoningwaarde,
    TResult Function(NormNhg value)? normNhg,
    required TResult orElse(),
  }) {
    if (normNhg != null) {
      return normNhg(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NormNhgToJson(
      this,
    );
  }
}

abstract class NormNhg implements Norm {
  const factory NormNhg(
      {required final String omschrijving,
      final double totaal,
      final double verduurzaam,
      final double resterend,
      final dynamic toepassen,
      final dynamic parameters,
      final dynamic bericht}) = _$NormNhg;

  factory NormNhg.fromJson(Map<String, dynamic> json) = _$NormNhg.fromJson;

  @override
  String get omschrijving;
  @override
  double get totaal;
  double get verduurzaam;
  @override
  double get resterend;
  @override
  dynamic get toepassen;
  @override
  dynamic get parameters;
  @override
  dynamic get bericht;
  @override
  @JsonKey(ignore: true)
  _$$NormNhgCopyWith<_$NormNhg> get copyWith =>
      throw _privateConstructorUsedError;
}
