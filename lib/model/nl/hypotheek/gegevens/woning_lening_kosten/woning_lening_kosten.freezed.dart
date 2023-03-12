// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'woning_lening_kosten.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

WoningLeningKosten _$WoningLeningKostenFromJson(Map<String, dynamic> json) {
  return _WoningLeningKosten.fromJson(json);
}

/// @nodoc
mixin _$WoningLeningKosten {
  IList<Waarde> get kosten => throw _privateConstructorUsedError;
  double get woningWaarde => throw _privateConstructorUsedError;
  double get lening => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WoningLeningKostenCopyWith<WoningLeningKosten> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WoningLeningKostenCopyWith<$Res> {
  factory $WoningLeningKostenCopyWith(
          WoningLeningKosten value, $Res Function(WoningLeningKosten) then) =
      _$WoningLeningKostenCopyWithImpl<$Res, WoningLeningKosten>;
  @useResult
  $Res call({IList<Waarde> kosten, double woningWaarde, double lening});
}

/// @nodoc
class _$WoningLeningKostenCopyWithImpl<$Res, $Val extends WoningLeningKosten>
    implements $WoningLeningKostenCopyWith<$Res> {
  _$WoningLeningKostenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kosten = null,
    Object? woningWaarde = null,
    Object? lening = null,
  }) {
    return _then(_value.copyWith(
      kosten: null == kosten
          ? _value.kosten
          : kosten // ignore: cast_nullable_to_non_nullable
              as IList<Waarde>,
      woningWaarde: null == woningWaarde
          ? _value.woningWaarde
          : woningWaarde // ignore: cast_nullable_to_non_nullable
              as double,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WoningLeningKostenCopyWith<$Res>
    implements $WoningLeningKostenCopyWith<$Res> {
  factory _$$_WoningLeningKostenCopyWith(_$_WoningLeningKosten value,
          $Res Function(_$_WoningLeningKosten) then) =
      __$$_WoningLeningKostenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IList<Waarde> kosten, double woningWaarde, double lening});
}

/// @nodoc
class __$$_WoningLeningKostenCopyWithImpl<$Res>
    extends _$WoningLeningKostenCopyWithImpl<$Res, _$_WoningLeningKosten>
    implements _$$_WoningLeningKostenCopyWith<$Res> {
  __$$_WoningLeningKostenCopyWithImpl(
      _$_WoningLeningKosten _value, $Res Function(_$_WoningLeningKosten) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? kosten = null,
    Object? woningWaarde = null,
    Object? lening = null,
  }) {
    return _then(_$_WoningLeningKosten(
      kosten: null == kosten
          ? _value.kosten
          : kosten // ignore: cast_nullable_to_non_nullable
              as IList<Waarde>,
      woningWaarde: null == woningWaarde
          ? _value.woningWaarde
          : woningWaarde // ignore: cast_nullable_to_non_nullable
              as double,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_WoningLeningKosten extends _WoningLeningKosten
    with DiagnosticableTreeMixin {
  const _$_WoningLeningKosten(
      {this.kosten = const IListConst([]),
      this.woningWaarde = 0.0,
      this.lening = 0.0})
      : super._();

  factory _$_WoningLeningKosten.fromJson(Map<String, dynamic> json) =>
      _$$_WoningLeningKostenFromJson(json);

  @override
  @JsonKey()
  final IList<Waarde> kosten;
  @override
  @JsonKey()
  final double woningWaarde;
  @override
  @JsonKey()
  final double lening;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WoningLeningKosten(kosten: $kosten, woningWaarde: $woningWaarde, lening: $lening)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WoningLeningKosten'))
      ..add(DiagnosticsProperty('kosten', kosten))
      ..add(DiagnosticsProperty('woningWaarde', woningWaarde))
      ..add(DiagnosticsProperty('lening', lening));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WoningLeningKosten &&
            const DeepCollectionEquality().equals(other.kosten, kosten) &&
            (identical(other.woningWaarde, woningWaarde) ||
                other.woningWaarde == woningWaarde) &&
            (identical(other.lening, lening) || other.lening == lening));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(kosten), woningWaarde, lening);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WoningLeningKostenCopyWith<_$_WoningLeningKosten> get copyWith =>
      __$$_WoningLeningKostenCopyWithImpl<_$_WoningLeningKosten>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WoningLeningKostenToJson(
      this,
    );
  }
}

abstract class _WoningLeningKosten extends WoningLeningKosten {
  const factory _WoningLeningKosten(
      {final IList<Waarde> kosten,
      final double woningWaarde,
      final double lening}) = _$_WoningLeningKosten;
  const _WoningLeningKosten._() : super._();

  factory _WoningLeningKosten.fromJson(Map<String, dynamic> json) =
      _$_WoningLeningKosten.fromJson;

  @override
  IList<Waarde> get kosten;
  @override
  double get woningWaarde;
  @override
  double get lening;
  @override
  @JsonKey(ignore: true)
  _$$_WoningLeningKostenCopyWith<_$_WoningLeningKosten> get copyWith =>
      throw _privateConstructorUsedError;
}
