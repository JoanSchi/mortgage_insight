// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hypotheek_dossier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

HypotheekDossier _$HypotheekDossierFromJson(Map<String, dynamic> json) {
  return _HypotheekDossier.fromJson(json);
}

/// @nodoc
mixin _$HypotheekDossier {
  int get id => throw _privateConstructorUsedError;
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
  $HypotheekDossierCopyWith<HypotheekDossier> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HypotheekDossierCopyWith<$Res> {
  factory $HypotheekDossierCopyWith(
          HypotheekDossier value, $Res Function(HypotheekDossier) then) =
      _$HypotheekDossierCopyWithImpl<$Res, HypotheekDossier>;
  @useResult
  $Res call(
      {int id,
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
class _$HypotheekDossierCopyWithImpl<$Res, $Val extends HypotheekDossier>
    implements $HypotheekDossierCopyWith<$Res> {
  _$HypotheekDossierCopyWithImpl(this._value, this._then);

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
              as int,
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
abstract class _$$_HypotheekDossierCopyWith<$Res>
    implements $HypotheekDossierCopyWith<$Res> {
  factory _$$_HypotheekDossierCopyWith(
          _$_HypotheekDossier value, $Res Function(_$_HypotheekDossier) then) =
      __$$_HypotheekDossierCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
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
class __$$_HypotheekDossierCopyWithImpl<$Res>
    extends _$HypotheekDossierCopyWithImpl<$Res, _$_HypotheekDossier>
    implements _$$_HypotheekDossierCopyWith<$Res> {
  __$$_HypotheekDossierCopyWithImpl(
      _$_HypotheekDossier _value, $Res Function(_$_HypotheekDossier) _then)
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
    return _then(_$_HypotheekDossier(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$_HypotheekDossier extends _HypotheekDossier {
  const _$_HypotheekDossier(
      {this.id = -1,
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

  factory _$_HypotheekDossier.fromJson(Map<String, dynamic> json) =>
      _$$_HypotheekDossierFromJson(json);

  @override
  @JsonKey()
  final int id;
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
    return 'HypotheekDossier(id: $id, hypotheken: $hypotheken, eersteHypotheken: $eersteHypotheken, omschrijving: $omschrijving, inkomensNormToepassen: $inkomensNormToepassen, woningWaardeNormToepassen: $woningWaardeNormToepassen, doelHypotheekOverzicht: $doelHypotheekOverzicht, starter: $starter, eigenWoningReserve: $eigenWoningReserve, vorigeWoningKosten: $vorigeWoningKosten)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HypotheekDossier &&
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
  _$$_HypotheekDossierCopyWith<_$_HypotheekDossier> get copyWith =>
      __$$_HypotheekDossierCopyWithImpl<_$_HypotheekDossier>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_HypotheekDossierToJson(
      this,
    );
  }
}

abstract class _HypotheekDossier extends HypotheekDossier {
  const factory _HypotheekDossier(
      {final int id,
      final IMap<String, Hypotheek> hypotheken,
      final IList<Hypotheek> eersteHypotheken,
      final String omschrijving,
      final bool inkomensNormToepassen,
      final bool woningWaardeNormToepassen,
      final DoelHypotheekOverzicht doelHypotheekOverzicht,
      final bool starter,
      final EigenWoningReserve eigenWoningReserve,
      final WoningLeningKosten vorigeWoningKosten}) = _$_HypotheekDossier;
  const _HypotheekDossier._() : super._();

  factory _HypotheekDossier.fromJson(Map<String, dynamic> json) =
      _$_HypotheekDossier.fromJson;

  @override
  int get id;
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
  _$$_HypotheekDossierCopyWith<_$_HypotheekDossier> get copyWith =>
      throw _privateConstructorUsedError;
}
