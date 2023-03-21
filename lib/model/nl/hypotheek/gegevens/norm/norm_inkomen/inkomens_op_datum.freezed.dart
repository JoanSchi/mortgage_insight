// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inkomens_op_datum.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

InkomensOpDatum _$InkomensOpDatumFromJson(Map<String, dynamic> json) {
  return _InkomensOpDatum.fromJson(json);
}

/// @nodoc
mixin _$InkomensOpDatum {
  DateTime get datum => throw _privateConstructorUsedError;
  Inkomen? get inkomen => throw _privateConstructorUsedError;
  Inkomen? get inkomenPartner => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InkomensOpDatumCopyWith<InkomensOpDatum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InkomensOpDatumCopyWith<$Res> {
  factory $InkomensOpDatumCopyWith(
          InkomensOpDatum value, $Res Function(InkomensOpDatum) then) =
      _$InkomensOpDatumCopyWithImpl<$Res, InkomensOpDatum>;
  @useResult
  $Res call({DateTime datum, Inkomen? inkomen, Inkomen? inkomenPartner});

  $InkomenCopyWith<$Res>? get inkomen;
  $InkomenCopyWith<$Res>? get inkomenPartner;
}

/// @nodoc
class _$InkomensOpDatumCopyWithImpl<$Res, $Val extends InkomensOpDatum>
    implements $InkomensOpDatumCopyWith<$Res> {
  _$InkomensOpDatumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? inkomen = freezed,
    Object? inkomenPartner = freezed,
  }) {
    return _then(_value.copyWith(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      inkomen: freezed == inkomen
          ? _value.inkomen
          : inkomen // ignore: cast_nullable_to_non_nullable
              as Inkomen?,
      inkomenPartner: freezed == inkomenPartner
          ? _value.inkomenPartner
          : inkomenPartner // ignore: cast_nullable_to_non_nullable
              as Inkomen?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InkomenCopyWith<$Res>? get inkomen {
    if (_value.inkomen == null) {
      return null;
    }

    return $InkomenCopyWith<$Res>(_value.inkomen!, (value) {
      return _then(_value.copyWith(inkomen: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $InkomenCopyWith<$Res>? get inkomenPartner {
    if (_value.inkomenPartner == null) {
      return null;
    }

    return $InkomenCopyWith<$Res>(_value.inkomenPartner!, (value) {
      return _then(_value.copyWith(inkomenPartner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InkomensOpDatumCopyWith<$Res>
    implements $InkomensOpDatumCopyWith<$Res> {
  factory _$$_InkomensOpDatumCopyWith(
          _$_InkomensOpDatum value, $Res Function(_$_InkomensOpDatum) then) =
      __$$_InkomensOpDatumCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime datum, Inkomen? inkomen, Inkomen? inkomenPartner});

  @override
  $InkomenCopyWith<$Res>? get inkomen;
  @override
  $InkomenCopyWith<$Res>? get inkomenPartner;
}

/// @nodoc
class __$$_InkomensOpDatumCopyWithImpl<$Res>
    extends _$InkomensOpDatumCopyWithImpl<$Res, _$_InkomensOpDatum>
    implements _$$_InkomensOpDatumCopyWith<$Res> {
  __$$_InkomensOpDatumCopyWithImpl(
      _$_InkomensOpDatum _value, $Res Function(_$_InkomensOpDatum) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? inkomen = freezed,
    Object? inkomenPartner = freezed,
  }) {
    return _then(_$_InkomensOpDatum(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      inkomen: freezed == inkomen
          ? _value.inkomen
          : inkomen // ignore: cast_nullable_to_non_nullable
              as Inkomen?,
      inkomenPartner: freezed == inkomenPartner
          ? _value.inkomenPartner
          : inkomenPartner // ignore: cast_nullable_to_non_nullable
              as Inkomen?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_InkomensOpDatum extends _InkomensOpDatum with DiagnosticableTreeMixin {
  const _$_InkomensOpDatum(
      {required this.datum,
      required this.inkomen,
      required this.inkomenPartner})
      : super._();

  factory _$_InkomensOpDatum.fromJson(Map<String, dynamic> json) =>
      _$$_InkomensOpDatumFromJson(json);

  @override
  final DateTime datum;
  @override
  final Inkomen? inkomen;
  @override
  final Inkomen? inkomenPartner;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InkomensOpDatum(datum: $datum, inkomen: $inkomen, inkomenPartner: $inkomenPartner)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InkomensOpDatum'))
      ..add(DiagnosticsProperty('datum', datum))
      ..add(DiagnosticsProperty('inkomen', inkomen))
      ..add(DiagnosticsProperty('inkomenPartner', inkomenPartner));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InkomensOpDatum &&
            (identical(other.datum, datum) || other.datum == datum) &&
            (identical(other.inkomen, inkomen) || other.inkomen == inkomen) &&
            (identical(other.inkomenPartner, inkomenPartner) ||
                other.inkomenPartner == inkomenPartner));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, datum, inkomen, inkomenPartner);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InkomensOpDatumCopyWith<_$_InkomensOpDatum> get copyWith =>
      __$$_InkomensOpDatumCopyWithImpl<_$_InkomensOpDatum>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InkomensOpDatumToJson(
      this,
    );
  }
}

abstract class _InkomensOpDatum extends InkomensOpDatum {
  const factory _InkomensOpDatum(
      {required final DateTime datum,
      required final Inkomen? inkomen,
      required final Inkomen? inkomenPartner}) = _$_InkomensOpDatum;
  const _InkomensOpDatum._() : super._();

  factory _InkomensOpDatum.fromJson(Map<String, dynamic> json) =
      _$_InkomensOpDatum.fromJson;

  @override
  DateTime get datum;
  @override
  Inkomen? get inkomen;
  @override
  Inkomen? get inkomenPartner;
  @override
  @JsonKey(ignore: true)
  _$$_InkomensOpDatumCopyWith<_$_InkomensOpDatum> get copyWith =>
      throw _privateConstructorUsedError;
}
