// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'eigenwoningreserve.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EigenWoningReserve _$EigenWoningReserveFromJson(Map<String, dynamic> json) {
  return _EigenWoningReserve.fromJson(json);
}

/// @nodoc
mixin _$EigenWoningReserve {
  bool get ewrToepassen => throw _privateConstructorUsedError;
  bool get ewrBerekenen => throw _privateConstructorUsedError;
  double get ewr => throw _privateConstructorUsedError;
  double get oorspronkelijkeHoofdsom => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EigenWoningReserveCopyWith<EigenWoningReserve> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EigenWoningReserveCopyWith<$Res> {
  factory $EigenWoningReserveCopyWith(
          EigenWoningReserve value, $Res Function(EigenWoningReserve) then) =
      _$EigenWoningReserveCopyWithImpl<$Res, EigenWoningReserve>;
  @useResult
  $Res call(
      {bool ewrToepassen,
      bool ewrBerekenen,
      double ewr,
      double oorspronkelijkeHoofdsom});
}

/// @nodoc
class _$EigenWoningReserveCopyWithImpl<$Res, $Val extends EigenWoningReserve>
    implements $EigenWoningReserveCopyWith<$Res> {
  _$EigenWoningReserveCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ewrToepassen = null,
    Object? ewrBerekenen = null,
    Object? ewr = null,
    Object? oorspronkelijkeHoofdsom = null,
  }) {
    return _then(_value.copyWith(
      ewrToepassen: null == ewrToepassen
          ? _value.ewrToepassen
          : ewrToepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      ewrBerekenen: null == ewrBerekenen
          ? _value.ewrBerekenen
          : ewrBerekenen // ignore: cast_nullable_to_non_nullable
              as bool,
      ewr: null == ewr
          ? _value.ewr
          : ewr // ignore: cast_nullable_to_non_nullable
              as double,
      oorspronkelijkeHoofdsom: null == oorspronkelijkeHoofdsom
          ? _value.oorspronkelijkeHoofdsom
          : oorspronkelijkeHoofdsom // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EigenWoningReserveCopyWith<$Res>
    implements $EigenWoningReserveCopyWith<$Res> {
  factory _$$_EigenWoningReserveCopyWith(_$_EigenWoningReserve value,
          $Res Function(_$_EigenWoningReserve) then) =
      __$$_EigenWoningReserveCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool ewrToepassen,
      bool ewrBerekenen,
      double ewr,
      double oorspronkelijkeHoofdsom});
}

/// @nodoc
class __$$_EigenWoningReserveCopyWithImpl<$Res>
    extends _$EigenWoningReserveCopyWithImpl<$Res, _$_EigenWoningReserve>
    implements _$$_EigenWoningReserveCopyWith<$Res> {
  __$$_EigenWoningReserveCopyWithImpl(
      _$_EigenWoningReserve _value, $Res Function(_$_EigenWoningReserve) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ewrToepassen = null,
    Object? ewrBerekenen = null,
    Object? ewr = null,
    Object? oorspronkelijkeHoofdsom = null,
  }) {
    return _then(_$_EigenWoningReserve(
      ewrToepassen: null == ewrToepassen
          ? _value.ewrToepassen
          : ewrToepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      ewrBerekenen: null == ewrBerekenen
          ? _value.ewrBerekenen
          : ewrBerekenen // ignore: cast_nullable_to_non_nullable
              as bool,
      ewr: null == ewr
          ? _value.ewr
          : ewr // ignore: cast_nullable_to_non_nullable
              as double,
      oorspronkelijkeHoofdsom: null == oorspronkelijkeHoofdsom
          ? _value.oorspronkelijkeHoofdsom
          : oorspronkelijkeHoofdsom // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EigenWoningReserve
    with DiagnosticableTreeMixin
    implements _EigenWoningReserve {
  const _$_EigenWoningReserve(
      {this.ewrToepassen = true,
      this.ewrBerekenen = false,
      this.ewr = 0.0,
      this.oorspronkelijkeHoofdsom = 0.0});

  factory _$_EigenWoningReserve.fromJson(Map<String, dynamic> json) =>
      _$$_EigenWoningReserveFromJson(json);

  @override
  @JsonKey()
  final bool ewrToepassen;
  @override
  @JsonKey()
  final bool ewrBerekenen;
  @override
  @JsonKey()
  final double ewr;
  @override
  @JsonKey()
  final double oorspronkelijkeHoofdsom;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'EigenWoningReserve(ewrToepassen: $ewrToepassen, ewrBerekenen: $ewrBerekenen, ewr: $ewr, oorspronkelijkeHoofdsom: $oorspronkelijkeHoofdsom)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'EigenWoningReserve'))
      ..add(DiagnosticsProperty('ewrToepassen', ewrToepassen))
      ..add(DiagnosticsProperty('ewrBerekenen', ewrBerekenen))
      ..add(DiagnosticsProperty('ewr', ewr))
      ..add(DiagnosticsProperty(
          'oorspronkelijkeHoofdsom', oorspronkelijkeHoofdsom));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EigenWoningReserve &&
            (identical(other.ewrToepassen, ewrToepassen) ||
                other.ewrToepassen == ewrToepassen) &&
            (identical(other.ewrBerekenen, ewrBerekenen) ||
                other.ewrBerekenen == ewrBerekenen) &&
            (identical(other.ewr, ewr) || other.ewr == ewr) &&
            (identical(
                    other.oorspronkelijkeHoofdsom, oorspronkelijkeHoofdsom) ||
                other.oorspronkelijkeHoofdsom == oorspronkelijkeHoofdsom));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, ewrToepassen, ewrBerekenen, ewr, oorspronkelijkeHoofdsom);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EigenWoningReserveCopyWith<_$_EigenWoningReserve> get copyWith =>
      __$$_EigenWoningReserveCopyWithImpl<_$_EigenWoningReserve>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EigenWoningReserveToJson(
      this,
    );
  }
}

abstract class _EigenWoningReserve implements EigenWoningReserve {
  const factory _EigenWoningReserve(
      {final bool ewrToepassen,
      final bool ewrBerekenen,
      final double ewr,
      final double oorspronkelijkeHoofdsom}) = _$_EigenWoningReserve;

  factory _EigenWoningReserve.fromJson(Map<String, dynamic> json) =
      _$_EigenWoningReserve.fromJson;

  @override
  bool get ewrToepassen;
  @override
  bool get ewrBerekenen;
  @override
  double get ewr;
  @override
  double get oorspronkelijkeHoofdsom;
  @override
  @JsonKey(ignore: true)
  _$$_EigenWoningReserveCopyWith<_$_EigenWoningReserve> get copyWith =>
      throw _privateConstructorUsedError;
}
