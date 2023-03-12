// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'combi_rest_schuld.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CombiRestSchuld _$CombiRestSchuldFromJson(Map<String, dynamic> json) {
  return _CombiRestSchuld.fromJson(json);
}

/// @nodoc
mixin _$CombiRestSchuld {
  DateTime get datum => throw _privateConstructorUsedError;
  double get restSchuld => throw _privateConstructorUsedError;
  IList<String> get idLijst => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CombiRestSchuldCopyWith<CombiRestSchuld> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CombiRestSchuldCopyWith<$Res> {
  factory $CombiRestSchuldCopyWith(
          CombiRestSchuld value, $Res Function(CombiRestSchuld) then) =
      _$CombiRestSchuldCopyWithImpl<$Res, CombiRestSchuld>;
  @useResult
  $Res call({DateTime datum, double restSchuld, IList<String> idLijst});
}

/// @nodoc
class _$CombiRestSchuldCopyWithImpl<$Res, $Val extends CombiRestSchuld>
    implements $CombiRestSchuldCopyWith<$Res> {
  _$CombiRestSchuldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? restSchuld = null,
    Object? idLijst = null,
  }) {
    return _then(_value.copyWith(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      restSchuld: null == restSchuld
          ? _value.restSchuld
          : restSchuld // ignore: cast_nullable_to_non_nullable
              as double,
      idLijst: null == idLijst
          ? _value.idLijst
          : idLijst // ignore: cast_nullable_to_non_nullable
              as IList<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CombiRestSchuldCopyWith<$Res>
    implements $CombiRestSchuldCopyWith<$Res> {
  factory _$$_CombiRestSchuldCopyWith(
          _$_CombiRestSchuld value, $Res Function(_$_CombiRestSchuld) then) =
      __$$_CombiRestSchuldCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime datum, double restSchuld, IList<String> idLijst});
}

/// @nodoc
class __$$_CombiRestSchuldCopyWithImpl<$Res>
    extends _$CombiRestSchuldCopyWithImpl<$Res, _$_CombiRestSchuld>
    implements _$$_CombiRestSchuldCopyWith<$Res> {
  __$$_CombiRestSchuldCopyWithImpl(
      _$_CombiRestSchuld _value, $Res Function(_$_CombiRestSchuld) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? restSchuld = null,
    Object? idLijst = null,
  }) {
    return _then(_$_CombiRestSchuld(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      restSchuld: null == restSchuld
          ? _value.restSchuld
          : restSchuld // ignore: cast_nullable_to_non_nullable
              as double,
      idLijst: null == idLijst
          ? _value.idLijst
          : idLijst // ignore: cast_nullable_to_non_nullable
              as IList<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CombiRestSchuld extends _CombiRestSchuld {
  const _$_CombiRestSchuld(
      {required this.datum, required this.restSchuld, required this.idLijst})
      : super._();

  factory _$_CombiRestSchuld.fromJson(Map<String, dynamic> json) =>
      _$$_CombiRestSchuldFromJson(json);

  @override
  final DateTime datum;
  @override
  final double restSchuld;
  @override
  final IList<String> idLijst;

  @override
  String toString() {
    return 'CombiRestSchuld(datum: $datum, restSchuld: $restSchuld, idLijst: $idLijst)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CombiRestSchuld &&
            (identical(other.datum, datum) || other.datum == datum) &&
            (identical(other.restSchuld, restSchuld) ||
                other.restSchuld == restSchuld) &&
            const DeepCollectionEquality().equals(other.idLijst, idLijst));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, datum, restSchuld,
      const DeepCollectionEquality().hash(idLijst));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CombiRestSchuldCopyWith<_$_CombiRestSchuld> get copyWith =>
      __$$_CombiRestSchuldCopyWithImpl<_$_CombiRestSchuld>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CombiRestSchuldToJson(
      this,
    );
  }
}

abstract class _CombiRestSchuld extends CombiRestSchuld {
  const factory _CombiRestSchuld(
      {required final DateTime datum,
      required final double restSchuld,
      required final IList<String> idLijst}) = _$_CombiRestSchuld;
  const _CombiRestSchuld._() : super._();

  factory _CombiRestSchuld.fromJson(Map<String, dynamic> json) =
      _$_CombiRestSchuld.fromJson;

  @override
  DateTime get datum;
  @override
  double get restSchuld;
  @override
  IList<String> get idLijst;
  @override
  @JsonKey(ignore: true)
  _$$_CombiRestSchuldCopyWith<_$_CombiRestSchuld> get copyWith =>
      throw _privateConstructorUsedError;
}
