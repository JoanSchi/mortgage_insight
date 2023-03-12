// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extra_of_kosten_lening.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Waarde _$WaardeFromJson(Map<String, dynamic> json) {
  return _Waarde.fromJson(json);
}

/// @nodoc
mixin _$Waarde {
  String get id => throw _privateConstructorUsedError;
  int get index => throw _privateConstructorUsedError;
  String get omschrijving => throw _privateConstructorUsedError;
  double get getal => throw _privateConstructorUsedError;
  Eenheid get eenheid => throw _privateConstructorUsedError;
  bool get aftrekbaar => throw _privateConstructorUsedError;
  bool get standaard => throw _privateConstructorUsedError;
  bool get verduurzamen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WaardeCopyWith<Waarde> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WaardeCopyWith<$Res> {
  factory $WaardeCopyWith(Waarde value, $Res Function(Waarde) then) =
      _$WaardeCopyWithImpl<$Res, Waarde>;
  @useResult
  $Res call(
      {String id,
      int index,
      String omschrijving,
      double getal,
      Eenheid eenheid,
      bool aftrekbaar,
      bool standaard,
      bool verduurzamen});
}

/// @nodoc
class _$WaardeCopyWithImpl<$Res, $Val extends Waarde>
    implements $WaardeCopyWith<$Res> {
  _$WaardeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? omschrijving = null,
    Object? getal = null,
    Object? eenheid = null,
    Object? aftrekbaar = null,
    Object? standaard = null,
    Object? verduurzamen = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      getal: null == getal
          ? _value.getal
          : getal // ignore: cast_nullable_to_non_nullable
              as double,
      eenheid: null == eenheid
          ? _value.eenheid
          : eenheid // ignore: cast_nullable_to_non_nullable
              as Eenheid,
      aftrekbaar: null == aftrekbaar
          ? _value.aftrekbaar
          : aftrekbaar // ignore: cast_nullable_to_non_nullable
              as bool,
      standaard: null == standaard
          ? _value.standaard
          : standaard // ignore: cast_nullable_to_non_nullable
              as bool,
      verduurzamen: null == verduurzamen
          ? _value.verduurzamen
          : verduurzamen // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WaardeCopyWith<$Res> implements $WaardeCopyWith<$Res> {
  factory _$$_WaardeCopyWith(_$_Waarde value, $Res Function(_$_Waarde) then) =
      __$$_WaardeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int index,
      String omschrijving,
      double getal,
      Eenheid eenheid,
      bool aftrekbaar,
      bool standaard,
      bool verduurzamen});
}

/// @nodoc
class __$$_WaardeCopyWithImpl<$Res>
    extends _$WaardeCopyWithImpl<$Res, _$_Waarde>
    implements _$$_WaardeCopyWith<$Res> {
  __$$_WaardeCopyWithImpl(_$_Waarde _value, $Res Function(_$_Waarde) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? index = null,
    Object? omschrijving = null,
    Object? getal = null,
    Object? eenheid = null,
    Object? aftrekbaar = null,
    Object? standaard = null,
    Object? verduurzamen = null,
  }) {
    return _then(_$_Waarde(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      getal: null == getal
          ? _value.getal
          : getal // ignore: cast_nullable_to_non_nullable
              as double,
      eenheid: null == eenheid
          ? _value.eenheid
          : eenheid // ignore: cast_nullable_to_non_nullable
              as Eenheid,
      aftrekbaar: null == aftrekbaar
          ? _value.aftrekbaar
          : aftrekbaar // ignore: cast_nullable_to_non_nullable
              as bool,
      standaard: null == standaard
          ? _value.standaard
          : standaard // ignore: cast_nullable_to_non_nullable
              as bool,
      verduurzamen: null == verduurzamen
          ? _value.verduurzamen
          : verduurzamen // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Waarde extends _Waarde with DiagnosticableTreeMixin {
  const _$_Waarde(
      {required this.id,
      required this.index,
      required this.omschrijving,
      required this.getal,
      required this.eenheid,
      this.aftrekbaar = false,
      this.standaard = false,
      this.verduurzamen = false})
      : super._();

  factory _$_Waarde.fromJson(Map<String, dynamic> json) =>
      _$$_WaardeFromJson(json);

  @override
  final String id;
  @override
  final int index;
  @override
  final String omschrijving;
  @override
  final double getal;
  @override
  final Eenheid eenheid;
  @override
  @JsonKey()
  final bool aftrekbaar;
  @override
  @JsonKey()
  final bool standaard;
  @override
  @JsonKey()
  final bool verduurzamen;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Waarde(id: $id, index: $index, omschrijving: $omschrijving, getal: $getal, eenheid: $eenheid, aftrekbaar: $aftrekbaar, standaard: $standaard, verduurzamen: $verduurzamen)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Waarde'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('index', index))
      ..add(DiagnosticsProperty('omschrijving', omschrijving))
      ..add(DiagnosticsProperty('getal', getal))
      ..add(DiagnosticsProperty('eenheid', eenheid))
      ..add(DiagnosticsProperty('aftrekbaar', aftrekbaar))
      ..add(DiagnosticsProperty('standaard', standaard))
      ..add(DiagnosticsProperty('verduurzamen', verduurzamen));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Waarde &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.getal, getal) || other.getal == getal) &&
            (identical(other.eenheid, eenheid) || other.eenheid == eenheid) &&
            (identical(other.aftrekbaar, aftrekbaar) ||
                other.aftrekbaar == aftrekbaar) &&
            (identical(other.standaard, standaard) ||
                other.standaard == standaard) &&
            (identical(other.verduurzamen, verduurzamen) ||
                other.verduurzamen == verduurzamen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, index, omschrijving, getal,
      eenheid, aftrekbaar, standaard, verduurzamen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WaardeCopyWith<_$_Waarde> get copyWith =>
      __$$_WaardeCopyWithImpl<_$_Waarde>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_WaardeToJson(
      this,
    );
  }
}

abstract class _Waarde extends Waarde {
  const factory _Waarde(
      {required final String id,
      required final int index,
      required final String omschrijving,
      required final double getal,
      required final Eenheid eenheid,
      final bool aftrekbaar,
      final bool standaard,
      final bool verduurzamen}) = _$_Waarde;
  const _Waarde._() : super._();

  factory _Waarde.fromJson(Map<String, dynamic> json) = _$_Waarde.fromJson;

  @override
  String get id;
  @override
  int get index;
  @override
  String get omschrijving;
  @override
  double get getal;
  @override
  Eenheid get eenheid;
  @override
  bool get aftrekbaar;
  @override
  bool get standaard;
  @override
  bool get verduurzamen;
  @override
  @JsonKey(ignore: true)
  _$$_WaardeCopyWith<_$_Waarde> get copyWith =>
      throw _privateConstructorUsedError;
}
