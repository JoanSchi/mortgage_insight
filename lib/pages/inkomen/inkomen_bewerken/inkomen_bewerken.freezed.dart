// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inkomen_bewerken.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$InkomenBewerken {
  Inkomen get inkomen => throw _privateConstructorUsedError;
  bool get pensioenKeuze => throw _privateConstructorUsedError;
  IList<Inkomen> get lijst => throw _privateConstructorUsedError;
  DateTime get origineleDatum => throw _privateConstructorUsedError;
  DateTime get blokDatum => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InkomenBewerkenCopyWith<InkomenBewerken> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InkomenBewerkenCopyWith<$Res> {
  factory $InkomenBewerkenCopyWith(
          InkomenBewerken value, $Res Function(InkomenBewerken) then) =
      _$InkomenBewerkenCopyWithImpl<$Res, InkomenBewerken>;
  @useResult
  $Res call(
      {Inkomen inkomen,
      bool pensioenKeuze,
      IList<Inkomen> lijst,
      DateTime origineleDatum,
      DateTime blokDatum});

  $InkomenCopyWith<$Res> get inkomen;
}

/// @nodoc
class _$InkomenBewerkenCopyWithImpl<$Res, $Val extends InkomenBewerken>
    implements $InkomenBewerkenCopyWith<$Res> {
  _$InkomenBewerkenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inkomen = null,
    Object? pensioenKeuze = null,
    Object? lijst = null,
    Object? origineleDatum = null,
    Object? blokDatum = null,
  }) {
    return _then(_value.copyWith(
      inkomen: null == inkomen
          ? _value.inkomen
          : inkomen // ignore: cast_nullable_to_non_nullable
              as Inkomen,
      pensioenKeuze: null == pensioenKeuze
          ? _value.pensioenKeuze
          : pensioenKeuze // ignore: cast_nullable_to_non_nullable
              as bool,
      lijst: null == lijst
          ? _value.lijst
          : lijst // ignore: cast_nullable_to_non_nullable
              as IList<Inkomen>,
      origineleDatum: null == origineleDatum
          ? _value.origineleDatum
          : origineleDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      blokDatum: null == blokDatum
          ? _value.blokDatum
          : blokDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InkomenCopyWith<$Res> get inkomen {
    return $InkomenCopyWith<$Res>(_value.inkomen, (value) {
      return _then(_value.copyWith(inkomen: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_InkomenBewerkenCopyWith<$Res>
    implements $InkomenBewerkenCopyWith<$Res> {
  factory _$$_InkomenBewerkenCopyWith(
          _$_InkomenBewerken value, $Res Function(_$_InkomenBewerken) then) =
      __$$_InkomenBewerkenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Inkomen inkomen,
      bool pensioenKeuze,
      IList<Inkomen> lijst,
      DateTime origineleDatum,
      DateTime blokDatum});

  @override
  $InkomenCopyWith<$Res> get inkomen;
}

/// @nodoc
class __$$_InkomenBewerkenCopyWithImpl<$Res>
    extends _$InkomenBewerkenCopyWithImpl<$Res, _$_InkomenBewerken>
    implements _$$_InkomenBewerkenCopyWith<$Res> {
  __$$_InkomenBewerkenCopyWithImpl(
      _$_InkomenBewerken _value, $Res Function(_$_InkomenBewerken) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inkomen = null,
    Object? pensioenKeuze = null,
    Object? lijst = null,
    Object? origineleDatum = null,
    Object? blokDatum = null,
  }) {
    return _then(_$_InkomenBewerken(
      inkomen: null == inkomen
          ? _value.inkomen
          : inkomen // ignore: cast_nullable_to_non_nullable
              as Inkomen,
      pensioenKeuze: null == pensioenKeuze
          ? _value.pensioenKeuze
          : pensioenKeuze // ignore: cast_nullable_to_non_nullable
              as bool,
      lijst: null == lijst
          ? _value.lijst
          : lijst // ignore: cast_nullable_to_non_nullable
              as IList<Inkomen>,
      origineleDatum: null == origineleDatum
          ? _value.origineleDatum
          : origineleDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      blokDatum: null == blokDatum
          ? _value.blokDatum
          : blokDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_InkomenBewerken
    with DiagnosticableTreeMixin
    implements _InkomenBewerken {
  const _$_InkomenBewerken(
      {required this.inkomen,
      required this.pensioenKeuze,
      required this.lijst,
      required this.origineleDatum,
      required this.blokDatum});

  @override
  final Inkomen inkomen;
  @override
  final bool pensioenKeuze;
  @override
  final IList<Inkomen> lijst;
  @override
  final DateTime origineleDatum;
  @override
  final DateTime blokDatum;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InkomenBewerken(inkomen: $inkomen, pensioenKeuze: $pensioenKeuze, lijst: $lijst, origineleDatum: $origineleDatum, blokDatum: $blokDatum)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InkomenBewerken'))
      ..add(DiagnosticsProperty('inkomen', inkomen))
      ..add(DiagnosticsProperty('pensioenKeuze', pensioenKeuze))
      ..add(DiagnosticsProperty('lijst', lijst))
      ..add(DiagnosticsProperty('origineleDatum', origineleDatum))
      ..add(DiagnosticsProperty('blokDatum', blokDatum));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InkomenBewerken &&
            (identical(other.inkomen, inkomen) || other.inkomen == inkomen) &&
            (identical(other.pensioenKeuze, pensioenKeuze) ||
                other.pensioenKeuze == pensioenKeuze) &&
            const DeepCollectionEquality().equals(other.lijst, lijst) &&
            (identical(other.origineleDatum, origineleDatum) ||
                other.origineleDatum == origineleDatum) &&
            (identical(other.blokDatum, blokDatum) ||
                other.blokDatum == blokDatum));
  }

  @override
  int get hashCode => Object.hash(runtimeType, inkomen, pensioenKeuze,
      const DeepCollectionEquality().hash(lijst), origineleDatum, blokDatum);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InkomenBewerkenCopyWith<_$_InkomenBewerken> get copyWith =>
      __$$_InkomenBewerkenCopyWithImpl<_$_InkomenBewerken>(this, _$identity);
}

abstract class _InkomenBewerken implements InkomenBewerken {
  const factory _InkomenBewerken(
      {required final Inkomen inkomen,
      required final bool pensioenKeuze,
      required final IList<Inkomen> lijst,
      required final DateTime origineleDatum,
      required final DateTime blokDatum}) = _$_InkomenBewerken;

  @override
  Inkomen get inkomen;
  @override
  bool get pensioenKeuze;
  @override
  IList<Inkomen> get lijst;
  @override
  DateTime get origineleDatum;
  @override
  DateTime get blokDatum;
  @override
  @JsonKey(ignore: true)
  _$$_InkomenBewerkenCopyWith<_$_InkomenBewerken> get copyWith =>
      throw _privateConstructorUsedError;
}
