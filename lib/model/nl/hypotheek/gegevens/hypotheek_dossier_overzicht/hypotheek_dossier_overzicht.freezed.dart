// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hypotheek_dossier_overzicht.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HypotheekDossierOverzicht _$HypotheekDossierOverzichtFromJson(
    Map<String, dynamic> json) {
  return _HypotheekDossierOverzicht.fromJson(json);
}

/// @nodoc
mixin _$HypotheekDossierOverzicht {
  IMap<int, HypotheekDossier> get hypotheekDossiers =>
      throw _privateConstructorUsedError;
  int get geselecteerd => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HypotheekDossierOverzichtCopyWith<HypotheekDossierOverzicht> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HypotheekDossierOverzichtCopyWith<$Res> {
  factory $HypotheekDossierOverzichtCopyWith(HypotheekDossierOverzicht value,
          $Res Function(HypotheekDossierOverzicht) then) =
      _$HypotheekDossierOverzichtCopyWithImpl<$Res, HypotheekDossierOverzicht>;
  @useResult
  $Res call({IMap<int, HypotheekDossier> hypotheekDossiers, int geselecteerd});
}

/// @nodoc
class _$HypotheekDossierOverzichtCopyWithImpl<$Res,
        $Val extends HypotheekDossierOverzicht>
    implements $HypotheekDossierOverzichtCopyWith<$Res> {
  _$HypotheekDossierOverzichtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hypotheekDossiers = null,
    Object? geselecteerd = null,
  }) {
    return _then(_value.copyWith(
      hypotheekDossiers: null == hypotheekDossiers
          ? _value.hypotheekDossiers
          : hypotheekDossiers // ignore: cast_nullable_to_non_nullable
              as IMap<int, HypotheekDossier>,
      geselecteerd: null == geselecteerd
          ? _value.geselecteerd
          : geselecteerd // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HypotheekDossierOverzichtCopyWith<$Res>
    implements $HypotheekDossierOverzichtCopyWith<$Res> {
  factory _$$_HypotheekDossierOverzichtCopyWith(
          _$_HypotheekDossierOverzicht value,
          $Res Function(_$_HypotheekDossierOverzicht) then) =
      __$$_HypotheekDossierOverzichtCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IMap<int, HypotheekDossier> hypotheekDossiers, int geselecteerd});
}

/// @nodoc
class __$$_HypotheekDossierOverzichtCopyWithImpl<$Res>
    extends _$HypotheekDossierOverzichtCopyWithImpl<$Res,
        _$_HypotheekDossierOverzicht>
    implements _$$_HypotheekDossierOverzichtCopyWith<$Res> {
  __$$_HypotheekDossierOverzichtCopyWithImpl(
      _$_HypotheekDossierOverzicht _value,
      $Res Function(_$_HypotheekDossierOverzicht) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hypotheekDossiers = null,
    Object? geselecteerd = null,
  }) {
    return _then(_$_HypotheekDossierOverzicht(
      hypotheekDossiers: null == hypotheekDossiers
          ? _value.hypotheekDossiers
          : hypotheekDossiers // ignore: cast_nullable_to_non_nullable
              as IMap<int, HypotheekDossier>,
      geselecteerd: null == geselecteerd
          ? _value.geselecteerd
          : geselecteerd // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_HypotheekDossierOverzicht extends _HypotheekDossierOverzicht {
  const _$_HypotheekDossierOverzicht(
      {this.hypotheekDossiers = const IMapConst({}), this.geselecteerd = -1})
      : super._();

  factory _$_HypotheekDossierOverzicht.fromJson(Map<String, dynamic> json) =>
      _$$_HypotheekDossierOverzichtFromJson(json);

  @override
  @JsonKey()
  final IMap<int, HypotheekDossier> hypotheekDossiers;
  @override
  @JsonKey()
  final int geselecteerd;

  @override
  String toString() {
    return 'HypotheekDossierOverzicht(hypotheekDossiers: $hypotheekDossiers, geselecteerd: $geselecteerd)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HypotheekDossierOverzicht &&
            (identical(other.hypotheekDossiers, hypotheekDossiers) ||
                other.hypotheekDossiers == hypotheekDossiers) &&
            (identical(other.geselecteerd, geselecteerd) ||
                other.geselecteerd == geselecteerd));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hypotheekDossiers, geselecteerd);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HypotheekDossierOverzichtCopyWith<_$_HypotheekDossierOverzicht>
      get copyWith => __$$_HypotheekDossierOverzichtCopyWithImpl<
          _$_HypotheekDossierOverzicht>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_HypotheekDossierOverzichtToJson(
      this,
    );
  }
}

abstract class _HypotheekDossierOverzicht extends HypotheekDossierOverzicht {
  const factory _HypotheekDossierOverzicht(
      {final IMap<int, HypotheekDossier> hypotheekDossiers,
      final int geselecteerd}) = _$_HypotheekDossierOverzicht;
  const _HypotheekDossierOverzicht._() : super._();

  factory _HypotheekDossierOverzicht.fromJson(Map<String, dynamic> json) =
      _$_HypotheekDossierOverzicht.fromJson;

  @override
  IMap<int, HypotheekDossier> get hypotheekDossiers;
  @override
  int get geselecteerd;
  @override
  @JsonKey(ignore: true)
  _$$_HypotheekDossierOverzichtCopyWith<_$_HypotheekDossierOverzicht>
      get copyWith => throw _privateConstructorUsedError;
}
