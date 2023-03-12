// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hypotheek_profiel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HypotheekProfiel _$HypotheekProfielFromJson(Map<String, dynamic> json) {
  return _HypotheekProfiel.fromJson(json);
}

/// @nodoc
mixin _$HypotheekProfiel {
  String get id => throw _privateConstructorUsedError;
  IMap<String, Hypotheek> get hypotheken => throw _privateConstructorUsedError;
  IList<Hypotheek> get eersteHypotheken => throw _privateConstructorUsedError;
  String get omschrijving => throw _privateConstructorUsedError;
  bool get inkomensNormToepassen => throw _privateConstructorUsedError;
  bool get woningWaardeNormToepassen => throw _privateConstructorUsedError;
  DoelHypotheekOverzicht get doelHypotheekOverzicht =>
      throw _privateConstructorUsedError;
  bool get starter => throw _privateConstructorUsedError;
  EigenWoningReserve get eigenWoningReserve =>
      throw _privateConstructorUsedError;
  WoningLeningKosten get vorigeWoningKosten =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HypotheekProfielCopyWith<HypotheekProfiel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HypotheekProfielCopyWith<$Res> {
  factory $HypotheekProfielCopyWith(
          HypotheekProfiel value, $Res Function(HypotheekProfiel) then) =
      _$HypotheekProfielCopyWithImpl<$Res, HypotheekProfiel>;
  @useResult
  $Res call(
      {String id,
      IMap<String, Hypotheek> hypotheken,
      IList<Hypotheek> eersteHypotheken,
      String omschrijving,
      bool inkomensNormToepassen,
      bool woningWaardeNormToepassen,
      DoelHypotheekOverzicht doelHypotheekOverzicht,
      bool starter,
      EigenWoningReserve eigenWoningReserve,
      WoningLeningKosten vorigeWoningKosten});

  $EigenWoningReserveCopyWith<$Res> get eigenWoningReserve;
  $WoningLeningKostenCopyWith<$Res> get vorigeWoningKosten;
}

/// @nodoc
class _$HypotheekProfielCopyWithImpl<$Res, $Val extends HypotheekProfiel>
    implements $HypotheekProfielCopyWith<$Res> {
  _$HypotheekProfielCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hypotheken = null,
    Object? eersteHypotheken = null,
    Object? omschrijving = null,
    Object? inkomensNormToepassen = null,
    Object? woningWaardeNormToepassen = null,
    Object? doelHypotheekOverzicht = null,
    Object? starter = null,
    Object? eigenWoningReserve = null,
    Object? vorigeWoningKosten = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hypotheken: null == hypotheken
          ? _value.hypotheken
          : hypotheken // ignore: cast_nullable_to_non_nullable
              as IMap<String, Hypotheek>,
      eersteHypotheken: null == eersteHypotheken
          ? _value.eersteHypotheken
          : eersteHypotheken // ignore: cast_nullable_to_non_nullable
              as IList<Hypotheek>,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      inkomensNormToepassen: null == inkomensNormToepassen
          ? _value.inkomensNormToepassen
          : inkomensNormToepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      woningWaardeNormToepassen: null == woningWaardeNormToepassen
          ? _value.woningWaardeNormToepassen
          : woningWaardeNormToepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      doelHypotheekOverzicht: null == doelHypotheekOverzicht
          ? _value.doelHypotheekOverzicht
          : doelHypotheekOverzicht // ignore: cast_nullable_to_non_nullable
              as DoelHypotheekOverzicht,
      starter: null == starter
          ? _value.starter
          : starter // ignore: cast_nullable_to_non_nullable
              as bool,
      eigenWoningReserve: null == eigenWoningReserve
          ? _value.eigenWoningReserve
          : eigenWoningReserve // ignore: cast_nullable_to_non_nullable
              as EigenWoningReserve,
      vorigeWoningKosten: null == vorigeWoningKosten
          ? _value.vorigeWoningKosten
          : vorigeWoningKosten // ignore: cast_nullable_to_non_nullable
              as WoningLeningKosten,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EigenWoningReserveCopyWith<$Res> get eigenWoningReserve {
    return $EigenWoningReserveCopyWith<$Res>(_value.eigenWoningReserve,
        (value) {
      return _then(_value.copyWith(eigenWoningReserve: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $WoningLeningKostenCopyWith<$Res> get vorigeWoningKosten {
    return $WoningLeningKostenCopyWith<$Res>(_value.vorigeWoningKosten,
        (value) {
      return _then(_value.copyWith(vorigeWoningKosten: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_HypotheekProfielCopyWith<$Res>
    implements $HypotheekProfielCopyWith<$Res> {
  factory _$$_HypotheekProfielCopyWith(
          _$_HypotheekProfiel value, $Res Function(_$_HypotheekProfiel) then) =
      __$$_HypotheekProfielCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      IMap<String, Hypotheek> hypotheken,
      IList<Hypotheek> eersteHypotheken,
      String omschrijving,
      bool inkomensNormToepassen,
      bool woningWaardeNormToepassen,
      DoelHypotheekOverzicht doelHypotheekOverzicht,
      bool starter,
      EigenWoningReserve eigenWoningReserve,
      WoningLeningKosten vorigeWoningKosten});

  @override
  $EigenWoningReserveCopyWith<$Res> get eigenWoningReserve;
  @override
  $WoningLeningKostenCopyWith<$Res> get vorigeWoningKosten;
}

/// @nodoc
class __$$_HypotheekProfielCopyWithImpl<$Res>
    extends _$HypotheekProfielCopyWithImpl<$Res, _$_HypotheekProfiel>
    implements _$$_HypotheekProfielCopyWith<$Res> {
  __$$_HypotheekProfielCopyWithImpl(
      _$_HypotheekProfiel _value, $Res Function(_$_HypotheekProfiel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hypotheken = null,
    Object? eersteHypotheken = null,
    Object? omschrijving = null,
    Object? inkomensNormToepassen = null,
    Object? woningWaardeNormToepassen = null,
    Object? doelHypotheekOverzicht = null,
    Object? starter = null,
    Object? eigenWoningReserve = null,
    Object? vorigeWoningKosten = null,
  }) {
    return _then(_$_HypotheekProfiel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      hypotheken: null == hypotheken
          ? _value.hypotheken
          : hypotheken // ignore: cast_nullable_to_non_nullable
              as IMap<String, Hypotheek>,
      eersteHypotheken: null == eersteHypotheken
          ? _value.eersteHypotheken
          : eersteHypotheken // ignore: cast_nullable_to_non_nullable
              as IList<Hypotheek>,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      inkomensNormToepassen: null == inkomensNormToepassen
          ? _value.inkomensNormToepassen
          : inkomensNormToepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      woningWaardeNormToepassen: null == woningWaardeNormToepassen
          ? _value.woningWaardeNormToepassen
          : woningWaardeNormToepassen // ignore: cast_nullable_to_non_nullable
              as bool,
      doelHypotheekOverzicht: null == doelHypotheekOverzicht
          ? _value.doelHypotheekOverzicht
          : doelHypotheekOverzicht // ignore: cast_nullable_to_non_nullable
              as DoelHypotheekOverzicht,
      starter: null == starter
          ? _value.starter
          : starter // ignore: cast_nullable_to_non_nullable
              as bool,
      eigenWoningReserve: null == eigenWoningReserve
          ? _value.eigenWoningReserve
          : eigenWoningReserve // ignore: cast_nullable_to_non_nullable
              as EigenWoningReserve,
      vorigeWoningKosten: null == vorigeWoningKosten
          ? _value.vorigeWoningKosten
          : vorigeWoningKosten // ignore: cast_nullable_to_non_nullable
              as WoningLeningKosten,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_HypotheekProfiel extends _HypotheekProfiel {
  const _$_HypotheekProfiel(
      {required this.id,
      this.hypotheken = const IMapConst({}),
      this.eersteHypotheken = const IListConst([]),
      this.omschrijving = '',
      this.inkomensNormToepassen = true,
      this.woningWaardeNormToepassen = true,
      this.doelHypotheekOverzicht = DoelHypotheekOverzicht.nieuweWoning,
      this.starter = false,
      this.eigenWoningReserve = const EigenWoningReserve(),
      this.vorigeWoningKosten = const WoningLeningKosten()})
      : super._();

  factory _$_HypotheekProfiel.fromJson(Map<String, dynamic> json) =>
      _$$_HypotheekProfielFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final IMap<String, Hypotheek> hypotheken;
  @override
  @JsonKey()
  final IList<Hypotheek> eersteHypotheken;
  @override
  @JsonKey()
  final String omschrijving;
  @override
  @JsonKey()
  final bool inkomensNormToepassen;
  @override
  @JsonKey()
  final bool woningWaardeNormToepassen;
  @override
  @JsonKey()
  final DoelHypotheekOverzicht doelHypotheekOverzicht;
  @override
  @JsonKey()
  final bool starter;
  @override
  @JsonKey()
  final EigenWoningReserve eigenWoningReserve;
  @override
  @JsonKey()
  final WoningLeningKosten vorigeWoningKosten;

  @override
  String toString() {
    return 'HypotheekProfiel(id: $id, hypotheken: $hypotheken, eersteHypotheken: $eersteHypotheken, omschrijving: $omschrijving, inkomensNormToepassen: $inkomensNormToepassen, woningWaardeNormToepassen: $woningWaardeNormToepassen, doelHypotheekOverzicht: $doelHypotheekOverzicht, starter: $starter, eigenWoningReserve: $eigenWoningReserve, vorigeWoningKosten: $vorigeWoningKosten)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HypotheekProfiel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hypotheken, hypotheken) ||
                other.hypotheken == hypotheken) &&
            const DeepCollectionEquality()
                .equals(other.eersteHypotheken, eersteHypotheken) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.inkomensNormToepassen, inkomensNormToepassen) ||
                other.inkomensNormToepassen == inkomensNormToepassen) &&
            (identical(other.woningWaardeNormToepassen,
                    woningWaardeNormToepassen) ||
                other.woningWaardeNormToepassen == woningWaardeNormToepassen) &&
            (identical(other.doelHypotheekOverzicht, doelHypotheekOverzicht) ||
                other.doelHypotheekOverzicht == doelHypotheekOverzicht) &&
            (identical(other.starter, starter) || other.starter == starter) &&
            (identical(other.eigenWoningReserve, eigenWoningReserve) ||
                other.eigenWoningReserve == eigenWoningReserve) &&
            (identical(other.vorigeWoningKosten, vorigeWoningKosten) ||
                other.vorigeWoningKosten == vorigeWoningKosten));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      hypotheken,
      const DeepCollectionEquality().hash(eersteHypotheken),
      omschrijving,
      inkomensNormToepassen,
      woningWaardeNormToepassen,
      doelHypotheekOverzicht,
      starter,
      eigenWoningReserve,
      vorigeWoningKosten);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HypotheekProfielCopyWith<_$_HypotheekProfiel> get copyWith =>
      __$$_HypotheekProfielCopyWithImpl<_$_HypotheekProfiel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_HypotheekProfielToJson(
      this,
    );
  }
}

abstract class _HypotheekProfiel extends HypotheekProfiel {
  const factory _HypotheekProfiel(
      {required final String id,
      final IMap<String, Hypotheek> hypotheken,
      final IList<Hypotheek> eersteHypotheken,
      final String omschrijving,
      final bool inkomensNormToepassen,
      final bool woningWaardeNormToepassen,
      final DoelHypotheekOverzicht doelHypotheekOverzicht,
      final bool starter,
      final EigenWoningReserve eigenWoningReserve,
      final WoningLeningKosten vorigeWoningKosten}) = _$_HypotheekProfiel;
  const _HypotheekProfiel._() : super._();

  factory _HypotheekProfiel.fromJson(Map<String, dynamic> json) =
      _$_HypotheekProfiel.fromJson;

  @override
  String get id;
  @override
  IMap<String, Hypotheek> get hypotheken;
  @override
  IList<Hypotheek> get eersteHypotheken;
  @override
  String get omschrijving;
  @override
  bool get inkomensNormToepassen;
  @override
  bool get woningWaardeNormToepassen;
  @override
  DoelHypotheekOverzicht get doelHypotheekOverzicht;
  @override
  bool get starter;
  @override
  EigenWoningReserve get eigenWoningReserve;
  @override
  WoningLeningKosten get vorigeWoningKosten;
  @override
  @JsonKey(ignore: true)
  _$$_HypotheekProfielCopyWith<_$_HypotheekProfiel> get copyWith =>
      throw _privateConstructorUsedError;
}
