// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verbouw_verduurzaam_kosten.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

VerbouwVerduurzaamKosten _$VerbouwVerduurzaamKostenFromJson(
    Map<String, dynamic> json) {
  return _VerbouwVerduurzaamKosten.fromJson(json);
}

/// @nodoc
mixin _$VerbouwVerduurzaamKosten {
  IList<Waarde> get kosten => throw _privateConstructorUsedError;
  String get energieClassificering => throw _privateConstructorUsedError;
  bool get toepassen => throw _privateConstructorUsedError;
  double get taxatie => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VerbouwVerduurzaamKostenCopyWith<VerbouwVerduurzaamKosten> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerbouwVerduurzaamKostenCopyWith<$Res> {
  factory $VerbouwVerduurzaamKostenCopyWith(VerbouwVerduurzaamKosten value,
          $Res Function(VerbouwVerduurzaamKosten) then) =
      _$VerbouwVerduurzaamKostenCopyWithImpl<$Res, VerbouwVerduurzaamKosten>;
  @useResult
  $Res call(
      {IList<Waarde> kosten,
      String energieClassificering,
      bool toepassen,
      double taxatie});
}

/// @nodoc
class _$VerbouwVerduurzaamKostenCopyWithImpl<$Res,
        $Val extends VerbouwVerduurzaamKosten>
    implements $VerbouwVerduurzaamKostenCopyWith<$Res> {
  _$VerbouwVerduurzaamKostenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kosten = null,
    Object? energieClassificering = null,
    Object? toepassen = null,
    Object? taxatie = null,
  }) {
    return _then(_value.copyWith(
      kosten: null == kosten
          ? _value.kosten
          : kosten // ignore: cast_nullable_to_non_nullable
              as IList<Waarde>,
      energieClassificering: null == energieClassificering
          ? _value.energieClassificering
          : energieClassificering // ignore: cast_nullable_to_non_nullable
              as String,
      toepassen: null == toepassen
          ? _value.toepassen
          : toepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      taxatie: null == taxatie
          ? _value.taxatie
          : taxatie // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_VerbouwVerduurzaamKostenCopyWith<$Res>
    implements $VerbouwVerduurzaamKostenCopyWith<$Res> {
  factory _$$_VerbouwVerduurzaamKostenCopyWith(
          _$_VerbouwVerduurzaamKosten value,
          $Res Function(_$_VerbouwVerduurzaamKosten) then) =
      __$$_VerbouwVerduurzaamKostenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {IList<Waarde> kosten,
      String energieClassificering,
      bool toepassen,
      double taxatie});
}

/// @nodoc
class __$$_VerbouwVerduurzaamKostenCopyWithImpl<$Res>
    extends _$VerbouwVerduurzaamKostenCopyWithImpl<$Res,
        _$_VerbouwVerduurzaamKosten>
    implements _$$_VerbouwVerduurzaamKostenCopyWith<$Res> {
  __$$_VerbouwVerduurzaamKostenCopyWithImpl(_$_VerbouwVerduurzaamKosten _value,
      $Res Function(_$_VerbouwVerduurzaamKosten) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kosten = null,
    Object? energieClassificering = null,
    Object? toepassen = null,
    Object? taxatie = null,
  }) {
    return _then(_$_VerbouwVerduurzaamKosten(
      kosten: null == kosten
          ? _value.kosten
          : kosten // ignore: cast_nullable_to_non_nullable
              as IList<Waarde>,
      energieClassificering: null == energieClassificering
          ? _value.energieClassificering
          : energieClassificering // ignore: cast_nullable_to_non_nullable
              as String,
      toepassen: null == toepassen
          ? _value.toepassen
          : toepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      taxatie: null == taxatie
          ? _value.taxatie
          : taxatie // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_VerbouwVerduurzaamKosten extends _VerbouwVerduurzaamKosten
    with DiagnosticableTreeMixin {
  const _$_VerbouwVerduurzaamKosten(
      {this.kosten = const IListConst([]),
      this.energieClassificering = '',
      this.toepassen = false,
      this.taxatie = 0.0})
      : super._();

  factory _$_VerbouwVerduurzaamKosten.fromJson(Map<String, dynamic> json) =>
      _$$_VerbouwVerduurzaamKostenFromJson(json);

  @override
  @JsonKey()
  final IList<Waarde> kosten;
  @override
  @JsonKey()
  final String energieClassificering;
  @override
  @JsonKey()
  final bool toepassen;
  @override
  @JsonKey()
  final double taxatie;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VerbouwVerduurzaamKosten(kosten: $kosten, energieClassificering: $energieClassificering, toepassen: $toepassen, taxatie: $taxatie)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VerbouwVerduurzaamKosten'))
      ..add(DiagnosticsProperty('kosten', kosten))
      ..add(DiagnosticsProperty('energieClassificering', energieClassificering))
      ..add(DiagnosticsProperty('toepassen', toepassen))
      ..add(DiagnosticsProperty('taxatie', taxatie));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_VerbouwVerduurzaamKosten &&
            const DeepCollectionEquality().equals(other.kosten, kosten) &&
            (identical(other.energieClassificering, energieClassificering) ||
                other.energieClassificering == energieClassificering) &&
            (identical(other.toepassen, toepassen) ||
                other.toepassen == toepassen) &&
            (identical(other.taxatie, taxatie) || other.taxatie == taxatie));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(kosten),
      energieClassificering,
      toepassen,
      taxatie);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_VerbouwVerduurzaamKostenCopyWith<_$_VerbouwVerduurzaamKosten>
      get copyWith => __$$_VerbouwVerduurzaamKostenCopyWithImpl<
          _$_VerbouwVerduurzaamKosten>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_VerbouwVerduurzaamKostenToJson(
      this,
    );
  }
}

abstract class _VerbouwVerduurzaamKosten extends VerbouwVerduurzaamKosten {
  const factory _VerbouwVerduurzaamKosten(
      {final IList<Waarde> kosten,
      final String energieClassificering,
      final bool toepassen,
      final double taxatie}) = _$_VerbouwVerduurzaamKosten;
  const _VerbouwVerduurzaamKosten._() : super._();

  factory _VerbouwVerduurzaamKosten.fromJson(Map<String, dynamic> json) =
      _$_VerbouwVerduurzaamKosten.fromJson;

  @override
  IList<Waarde> get kosten;
  @override
  String get energieClassificering;
  @override
  bool get toepassen;
  @override
  double get taxatie;
  @override
  @JsonKey(ignore: true)
  _$$_VerbouwVerduurzaamKostenCopyWith<_$_VerbouwVerduurzaamKosten>
      get copyWith => throw _privateConstructorUsedError;
}
