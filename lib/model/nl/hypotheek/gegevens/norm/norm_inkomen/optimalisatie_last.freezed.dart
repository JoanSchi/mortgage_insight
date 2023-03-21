// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimalisatie_last.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OptimalisatieLast _$OptimalisatieLastFromJson(Map<String, dynamic> json) {
  return _OptimalisatieLast.fromJson(json);
}

/// @nodoc
mixin _$OptimalisatieLast {
  StatusLening get statusLening => throw _privateConstructorUsedError;
  double get toetsRente => throw _privateConstructorUsedError;
  double get verduurzaamLening => throw _privateConstructorUsedError;
  double get box1 => throw _privateConstructorUsedError;
  double get box3 => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OptimalisatieLastCopyWith<OptimalisatieLast> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptimalisatieLastCopyWith<$Res> {
  factory $OptimalisatieLastCopyWith(
          OptimalisatieLast value, $Res Function(OptimalisatieLast) then) =
      _$OptimalisatieLastCopyWithImpl<$Res, OptimalisatieLast>;
  @useResult
  $Res call(
      {StatusLening statusLening,
      double toetsRente,
      double verduurzaamLening,
      double box1,
      double box3});

  $StatusLeningCopyWith<$Res> get statusLening;
}

/// @nodoc
class _$OptimalisatieLastCopyWithImpl<$Res, $Val extends OptimalisatieLast>
    implements $OptimalisatieLastCopyWith<$Res> {
  _$OptimalisatieLastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusLening = null,
    Object? toetsRente = null,
    Object? verduurzaamLening = null,
    Object? box1 = null,
    Object? box3 = null,
  }) {
    return _then(_value.copyWith(
      statusLening: null == statusLening
          ? _value.statusLening
          : statusLening // ignore: cast_nullable_to_non_nullable
              as StatusLening,
      toetsRente: null == toetsRente
          ? _value.toetsRente
          : toetsRente // ignore: cast_nullable_to_non_nullable
              as double,
      verduurzaamLening: null == verduurzaamLening
          ? _value.verduurzaamLening
          : verduurzaamLening // ignore: cast_nullable_to_non_nullable
              as double,
      box1: null == box1
          ? _value.box1
          : box1 // ignore: cast_nullable_to_non_nullable
              as double,
      box3: null == box3
          ? _value.box3
          : box3 // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StatusLeningCopyWith<$Res> get statusLening {
    return $StatusLeningCopyWith<$Res>(_value.statusLening, (value) {
      return _then(_value.copyWith(statusLening: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_OptimalisatieLastCopyWith<$Res>
    implements $OptimalisatieLastCopyWith<$Res> {
  factory _$$_OptimalisatieLastCopyWith(_$_OptimalisatieLast value,
          $Res Function(_$_OptimalisatieLast) then) =
      __$$_OptimalisatieLastCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StatusLening statusLening,
      double toetsRente,
      double verduurzaamLening,
      double box1,
      double box3});

  @override
  $StatusLeningCopyWith<$Res> get statusLening;
}

/// @nodoc
class __$$_OptimalisatieLastCopyWithImpl<$Res>
    extends _$OptimalisatieLastCopyWithImpl<$Res, _$_OptimalisatieLast>
    implements _$$_OptimalisatieLastCopyWith<$Res> {
  __$$_OptimalisatieLastCopyWithImpl(
      _$_OptimalisatieLast _value, $Res Function(_$_OptimalisatieLast) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusLening = null,
    Object? toetsRente = null,
    Object? verduurzaamLening = null,
    Object? box1 = null,
    Object? box3 = null,
  }) {
    return _then(_$_OptimalisatieLast(
      statusLening: null == statusLening
          ? _value.statusLening
          : statusLening // ignore: cast_nullable_to_non_nullable
              as StatusLening,
      toetsRente: null == toetsRente
          ? _value.toetsRente
          : toetsRente // ignore: cast_nullable_to_non_nullable
              as double,
      verduurzaamLening: null == verduurzaamLening
          ? _value.verduurzaamLening
          : verduurzaamLening // ignore: cast_nullable_to_non_nullable
              as double,
      box1: null == box1
          ? _value.box1
          : box1 // ignore: cast_nullable_to_non_nullable
              as double,
      box3: null == box3
          ? _value.box3
          : box3 // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_OptimalisatieLast
    with DiagnosticableTreeMixin
    implements _OptimalisatieLast {
  const _$_OptimalisatieLast(
      {required this.statusLening,
      required this.toetsRente,
      this.verduurzaamLening = 0.0,
      this.box1 = 0.0,
      this.box3 = 0.0});

  factory _$_OptimalisatieLast.fromJson(Map<String, dynamic> json) =>
      _$$_OptimalisatieLastFromJson(json);

  @override
  final StatusLening statusLening;
  @override
  final double toetsRente;
  @override
  @JsonKey()
  final double verduurzaamLening;
  @override
  @JsonKey()
  final double box1;
  @override
  @JsonKey()
  final double box3;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OptimalisatieLast(statusLening: $statusLening, toetsRente: $toetsRente, verduurzaamLening: $verduurzaamLening, box1: $box1, box3: $box3)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OptimalisatieLast'))
      ..add(DiagnosticsProperty('statusLening', statusLening))
      ..add(DiagnosticsProperty('toetsRente', toetsRente))
      ..add(DiagnosticsProperty('verduurzaamLening', verduurzaamLening))
      ..add(DiagnosticsProperty('box1', box1))
      ..add(DiagnosticsProperty('box3', box3));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OptimalisatieLast &&
            (identical(other.statusLening, statusLening) ||
                other.statusLening == statusLening) &&
            (identical(other.toetsRente, toetsRente) ||
                other.toetsRente == toetsRente) &&
            (identical(other.verduurzaamLening, verduurzaamLening) ||
                other.verduurzaamLening == verduurzaamLening) &&
            (identical(other.box1, box1) || other.box1 == box1) &&
            (identical(other.box3, box3) || other.box3 == box3));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, statusLening, toetsRente, verduurzaamLening, box1, box3);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_OptimalisatieLastCopyWith<_$_OptimalisatieLast> get copyWith =>
      __$$_OptimalisatieLastCopyWithImpl<_$_OptimalisatieLast>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OptimalisatieLastToJson(
      this,
    );
  }
}

abstract class _OptimalisatieLast implements OptimalisatieLast {
  const factory _OptimalisatieLast(
      {required final StatusLening statusLening,
      required final double toetsRente,
      final double verduurzaamLening,
      final double box1,
      final double box3}) = _$_OptimalisatieLast;

  factory _OptimalisatieLast.fromJson(Map<String, dynamic> json) =
      _$_OptimalisatieLast.fromJson;

  @override
  StatusLening get statusLening;
  @override
  double get toetsRente;
  @override
  double get verduurzaamLening;
  @override
  double get box1;
  @override
  double get box3;
  @override
  @JsonKey(ignore: true)
  _$$_OptimalisatieLastCopyWith<_$_OptimalisatieLast> get copyWith =>
      throw _privateConstructorUsedError;
}
