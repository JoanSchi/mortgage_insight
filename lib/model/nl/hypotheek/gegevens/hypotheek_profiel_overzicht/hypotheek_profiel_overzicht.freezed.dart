// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hypotheek_profiel_overzicht.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HypotheekProfielOverzicht _$HypotheekProfielOverzichtFromJson(
    Map<String, dynamic> json) {
  return _HypotheekProfielOverzicht.fromJson(json);
}

/// @nodoc
mixin _$HypotheekProfielOverzicht {
  IMap<String, HypotheekProfiel> get hypotheekProfielen =>
      throw _privateConstructorUsedError;
  String get actief => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HypotheekProfielOverzichtCopyWith<HypotheekProfielOverzicht> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HypotheekProfielOverzichtCopyWith<$Res> {
  factory $HypotheekProfielOverzichtCopyWith(HypotheekProfielOverzicht value,
          $Res Function(HypotheekProfielOverzicht) then) =
      _$HypotheekProfielOverzichtCopyWithImpl<$Res, HypotheekProfielOverzicht>;
  @useResult
  $Res call({IMap<String, HypotheekProfiel> hypotheekProfielen, String actief});
}

/// @nodoc
class _$HypotheekProfielOverzichtCopyWithImpl<$Res,
        $Val extends HypotheekProfielOverzicht>
    implements $HypotheekProfielOverzichtCopyWith<$Res> {
  _$HypotheekProfielOverzichtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hypotheekProfielen = null,
    Object? actief = null,
  }) {
    return _then(_value.copyWith(
      hypotheekProfielen: null == hypotheekProfielen
          ? _value.hypotheekProfielen
          : hypotheekProfielen // ignore: cast_nullable_to_non_nullable
              as IMap<String, HypotheekProfiel>,
      actief: null == actief
          ? _value.actief
          : actief // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HypotheekProfielOverzichtCopyWith<$Res>
    implements $HypotheekProfielOverzichtCopyWith<$Res> {
  factory _$$_HypotheekProfielOverzichtCopyWith(
          _$_HypotheekProfielOverzicht value,
          $Res Function(_$_HypotheekProfielOverzicht) then) =
      __$$_HypotheekProfielOverzichtCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IMap<String, HypotheekProfiel> hypotheekProfielen, String actief});
}

/// @nodoc
class __$$_HypotheekProfielOverzichtCopyWithImpl<$Res>
    extends _$HypotheekProfielOverzichtCopyWithImpl<$Res,
        _$_HypotheekProfielOverzicht>
    implements _$$_HypotheekProfielOverzichtCopyWith<$Res> {
  __$$_HypotheekProfielOverzichtCopyWithImpl(
      _$_HypotheekProfielOverzicht _value,
      $Res Function(_$_HypotheekProfielOverzicht) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hypotheekProfielen = null,
    Object? actief = null,
  }) {
    return _then(_$_HypotheekProfielOverzicht(
      hypotheekProfielen: null == hypotheekProfielen
          ? _value.hypotheekProfielen
          : hypotheekProfielen // ignore: cast_nullable_to_non_nullable
              as IMap<String, HypotheekProfiel>,
      actief: null == actief
          ? _value.actief
          : actief // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_HypotheekProfielOverzicht extends _HypotheekProfielOverzicht {
  const _$_HypotheekProfielOverzicht(
      {this.hypotheekProfielen = const IMapConst({}), this.actief = ''})
      : super._();

  factory _$_HypotheekProfielOverzicht.fromJson(Map<String, dynamic> json) =>
      _$$_HypotheekProfielOverzichtFromJson(json);

  @override
  @JsonKey()
  final IMap<String, HypotheekProfiel> hypotheekProfielen;
  @override
  @JsonKey()
  final String actief;

  @override
  String toString() {
    return 'HypotheekProfielOverzicht(hypotheekProfielen: $hypotheekProfielen, actief: $actief)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HypotheekProfielOverzicht &&
            (identical(other.hypotheekProfielen, hypotheekProfielen) ||
                other.hypotheekProfielen == hypotheekProfielen) &&
            (identical(other.actief, actief) || other.actief == actief));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hypotheekProfielen, actief);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HypotheekProfielOverzichtCopyWith<_$_HypotheekProfielOverzicht>
      get copyWith => __$$_HypotheekProfielOverzichtCopyWithImpl<
          _$_HypotheekProfielOverzicht>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_HypotheekProfielOverzichtToJson(
      this,
    );
  }
}

abstract class _HypotheekProfielOverzicht extends HypotheekProfielOverzicht {
  const factory _HypotheekProfielOverzicht(
      {final IMap<String, HypotheekProfiel> hypotheekProfielen,
      final String actief}) = _$_HypotheekProfielOverzicht;
  const _HypotheekProfielOverzicht._() : super._();

  factory _HypotheekProfielOverzicht.fromJson(Map<String, dynamic> json) =
      _$_HypotheekProfielOverzicht.fromJson;

  @override
  IMap<String, HypotheekProfiel> get hypotheekProfielen;
  @override
  String get actief;
  @override
  @JsonKey(ignore: true)
  _$$_HypotheekProfielOverzichtCopyWith<_$_HypotheekProfielOverzicht>
      get copyWith => throw _privateConstructorUsedError;
}
