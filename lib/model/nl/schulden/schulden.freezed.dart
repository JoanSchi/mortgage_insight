// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schulden.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SchuldenOverzicht _$SchuldenOverzichtFromJson(Map<String, dynamic> json) {
  return _SchuldenOverzicht.fromJson(json);
}

/// @nodoc
mixin _$SchuldenOverzicht {
  IList<Schuld> get lijst => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchuldenOverzichtCopyWith<SchuldenOverzicht> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchuldenOverzichtCopyWith<$Res> {
  factory $SchuldenOverzichtCopyWith(
          SchuldenOverzicht value, $Res Function(SchuldenOverzicht) then) =
      _$SchuldenOverzichtCopyWithImpl<$Res, SchuldenOverzicht>;
  @useResult
  $Res call({IList<Schuld> lijst});
}

/// @nodoc
class _$SchuldenOverzichtCopyWithImpl<$Res, $Val extends SchuldenOverzicht>
    implements $SchuldenOverzichtCopyWith<$Res> {
  _$SchuldenOverzichtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lijst = null,
  }) {
    return _then(_value.copyWith(
      lijst: null == lijst
          ? _value.lijst
          : lijst // ignore: cast_nullable_to_non_nullable
              as IList<Schuld>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SchuldenOverzichtCopyWith<$Res>
    implements $SchuldenOverzichtCopyWith<$Res> {
  factory _$$_SchuldenOverzichtCopyWith(_$_SchuldenOverzicht value,
          $Res Function(_$_SchuldenOverzicht) then) =
      __$$_SchuldenOverzichtCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IList<Schuld> lijst});
}

/// @nodoc
class __$$_SchuldenOverzichtCopyWithImpl<$Res>
    extends _$SchuldenOverzichtCopyWithImpl<$Res, _$_SchuldenOverzicht>
    implements _$$_SchuldenOverzichtCopyWith<$Res> {
  __$$_SchuldenOverzichtCopyWithImpl(
      _$_SchuldenOverzicht _value, $Res Function(_$_SchuldenOverzicht) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lijst = null,
  }) {
    return _then(_$_SchuldenOverzicht(
      lijst: null == lijst
          ? _value.lijst
          : lijst // ignore: cast_nullable_to_non_nullable
              as IList<Schuld>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SchuldenOverzicht implements _SchuldenOverzicht {
  const _$_SchuldenOverzicht({required this.lijst});

  factory _$_SchuldenOverzicht.fromJson(Map<String, dynamic> json) =>
      _$$_SchuldenOverzichtFromJson(json);

  @override
  final IList<Schuld> lijst;

  @override
  String toString() {
    return 'SchuldenOverzicht(lijst: $lijst)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SchuldenOverzicht &&
            const DeepCollectionEquality().equals(other.lijst, lijst));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(lijst));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SchuldenOverzichtCopyWith<_$_SchuldenOverzicht> get copyWith =>
      __$$_SchuldenOverzichtCopyWithImpl<_$_SchuldenOverzicht>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SchuldenOverzichtToJson(
      this,
    );
  }
}

abstract class _SchuldenOverzicht implements SchuldenOverzicht {
  const factory _SchuldenOverzicht({required final IList<Schuld> lijst}) =
      _$_SchuldenOverzicht;

  factory _SchuldenOverzicht.fromJson(Map<String, dynamic> json) =
      _$_SchuldenOverzicht.fromJson;

  @override
  IList<Schuld> get lijst;
  @override
  @JsonKey(ignore: true)
  _$$_SchuldenOverzichtCopyWith<_$_SchuldenOverzicht> get copyWith =>
      throw _privateConstructorUsedError;
}

Schuld _$SchuldFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'leaseAuto':
      return LeaseAuto.fromJson(json);
    case 'verzendKrediet':
      return VerzendKrediet.fromJson(json);
    case 'doorlopendKrediet':
      return DoorlopendKrediet.fromJson(json);
    case 'aflopendKrediet':
      return AflopendKrediet.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'Schuld',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$Schuld {
  int get id => throw _privateConstructorUsedError;
  SchuldenCategorie get categorie => throw _privateConstructorUsedError;
  String get omschrijving => throw _privateConstructorUsedError;
  DateTime get beginDatum => throw _privateConstructorUsedError;
  StatusBerekening get statusBerekening => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)
        leaseAuto,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)
        verzendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)
        doorlopendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)
        aflopendKrediet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaseAuto value) leaseAuto,
    required TResult Function(VerzendKrediet value) verzendKrediet,
    required TResult Function(DoorlopendKrediet value) doorlopendKrediet,
    required TResult Function(AflopendKrediet value) aflopendKrediet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaseAuto value)? leaseAuto,
    TResult? Function(VerzendKrediet value)? verzendKrediet,
    TResult? Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult? Function(AflopendKrediet value)? aflopendKrediet,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaseAuto value)? leaseAuto,
    TResult Function(VerzendKrediet value)? verzendKrediet,
    TResult Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult Function(AflopendKrediet value)? aflopendKrediet,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SchuldCopyWith<Schuld> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchuldCopyWith<$Res> {
  factory $SchuldCopyWith(Schuld value, $Res Function(Schuld) then) =
      _$SchuldCopyWithImpl<$Res, Schuld>;
  @useResult
  $Res call(
      {int id,
      SchuldenCategorie categorie,
      String omschrijving,
      DateTime beginDatum,
      StatusBerekening statusBerekening,
      String error});
}

/// @nodoc
class _$SchuldCopyWithImpl<$Res, $Val extends Schuld>
    implements $SchuldCopyWith<$Res> {
  _$SchuldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categorie = null,
    Object? omschrijving = null,
    Object? beginDatum = null,
    Object? statusBerekening = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as SchuldenCategorie,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      beginDatum: null == beginDatum
          ? _value.beginDatum
          : beginDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusBerekening: null == statusBerekening
          ? _value.statusBerekening
          : statusBerekening // ignore: cast_nullable_to_non_nullable
              as StatusBerekening,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LeaseAutoCopyWith<$Res> implements $SchuldCopyWith<$Res> {
  factory _$$LeaseAutoCopyWith(
          _$LeaseAuto value, $Res Function(_$LeaseAuto) then) =
      __$$LeaseAutoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      SchuldenCategorie categorie,
      String omschrijving,
      DateTime beginDatum,
      StatusBerekening statusBerekening,
      String error,
      double mndBedrag,
      int jaren,
      int maanden});
}

/// @nodoc
class __$$LeaseAutoCopyWithImpl<$Res>
    extends _$SchuldCopyWithImpl<$Res, _$LeaseAuto>
    implements _$$LeaseAutoCopyWith<$Res> {
  __$$LeaseAutoCopyWithImpl(
      _$LeaseAuto _value, $Res Function(_$LeaseAuto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categorie = null,
    Object? omschrijving = null,
    Object? beginDatum = null,
    Object? statusBerekening = null,
    Object? error = null,
    Object? mndBedrag = null,
    Object? jaren = null,
    Object? maanden = null,
  }) {
    return _then(_$LeaseAuto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as SchuldenCategorie,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      beginDatum: null == beginDatum
          ? _value.beginDatum
          : beginDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusBerekening: null == statusBerekening
          ? _value.statusBerekening
          : statusBerekening // ignore: cast_nullable_to_non_nullable
              as StatusBerekening,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      mndBedrag: null == mndBedrag
          ? _value.mndBedrag
          : mndBedrag // ignore: cast_nullable_to_non_nullable
              as double,
      jaren: null == jaren
          ? _value.jaren
          : jaren // ignore: cast_nullable_to_non_nullable
              as int,
      maanden: null == maanden
          ? _value.maanden
          : maanden // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaseAuto extends LeaseAuto {
  const _$LeaseAuto(
      {required this.id,
      required this.categorie,
      required this.omschrijving,
      required this.beginDatum,
      required this.statusBerekening,
      required this.error,
      required this.mndBedrag,
      required this.jaren,
      required this.maanden,
      final String? $type})
      : $type = $type ?? 'leaseAuto',
        super._();

  factory _$LeaseAuto.fromJson(Map<String, dynamic> json) =>
      _$$LeaseAutoFromJson(json);

  @override
  final int id;
  @override
  final SchuldenCategorie categorie;
  @override
  final String omschrijving;
  @override
  final DateTime beginDatum;
  @override
  final StatusBerekening statusBerekening;
  @override
  final String error;
//
  @override
  final double mndBedrag;
  @override
  final int jaren;
  @override
  final int maanden;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Schuld.leaseAuto(id: $id, categorie: $categorie, omschrijving: $omschrijving, beginDatum: $beginDatum, statusBerekening: $statusBerekening, error: $error, mndBedrag: $mndBedrag, jaren: $jaren, maanden: $maanden)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaseAuto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.beginDatum, beginDatum) ||
                other.beginDatum == beginDatum) &&
            (identical(other.statusBerekening, statusBerekening) ||
                other.statusBerekening == statusBerekening) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.mndBedrag, mndBedrag) ||
                other.mndBedrag == mndBedrag) &&
            (identical(other.jaren, jaren) || other.jaren == jaren) &&
            (identical(other.maanden, maanden) || other.maanden == maanden));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, categorie, omschrijving,
      beginDatum, statusBerekening, error, mndBedrag, jaren, maanden);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaseAutoCopyWith<_$LeaseAuto> get copyWith =>
      __$$LeaseAutoCopyWithImpl<_$LeaseAuto>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)
        leaseAuto,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)
        verzendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)
        doorlopendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)
        aflopendKrediet,
  }) {
    return leaseAuto(id, categorie, omschrijving, beginDatum, statusBerekening,
        error, mndBedrag, jaren, maanden);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
  }) {
    return leaseAuto?.call(id, categorie, omschrijving, beginDatum,
        statusBerekening, error, mndBedrag, jaren, maanden);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
    required TResult orElse(),
  }) {
    if (leaseAuto != null) {
      return leaseAuto(id, categorie, omschrijving, beginDatum,
          statusBerekening, error, mndBedrag, jaren, maanden);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaseAuto value) leaseAuto,
    required TResult Function(VerzendKrediet value) verzendKrediet,
    required TResult Function(DoorlopendKrediet value) doorlopendKrediet,
    required TResult Function(AflopendKrediet value) aflopendKrediet,
  }) {
    return leaseAuto(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaseAuto value)? leaseAuto,
    TResult? Function(VerzendKrediet value)? verzendKrediet,
    TResult? Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult? Function(AflopendKrediet value)? aflopendKrediet,
  }) {
    return leaseAuto?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaseAuto value)? leaseAuto,
    TResult Function(VerzendKrediet value)? verzendKrediet,
    TResult Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult Function(AflopendKrediet value)? aflopendKrediet,
    required TResult orElse(),
  }) {
    if (leaseAuto != null) {
      return leaseAuto(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaseAutoToJson(
      this,
    );
  }
}

abstract class LeaseAuto extends Schuld {
  const factory LeaseAuto(
      {required final int id,
      required final SchuldenCategorie categorie,
      required final String omschrijving,
      required final DateTime beginDatum,
      required final StatusBerekening statusBerekening,
      required final String error,
      required final double mndBedrag,
      required final int jaren,
      required final int maanden}) = _$LeaseAuto;
  const LeaseAuto._() : super._();

  factory LeaseAuto.fromJson(Map<String, dynamic> json) = _$LeaseAuto.fromJson;

  @override
  int get id;
  @override
  SchuldenCategorie get categorie;
  @override
  String get omschrijving;
  @override
  DateTime get beginDatum;
  @override
  StatusBerekening get statusBerekening;
  @override
  String get error; //
  double get mndBedrag;
  int get jaren;
  int get maanden;
  @override
  @JsonKey(ignore: true)
  _$$LeaseAutoCopyWith<_$LeaseAuto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VerzendKredietCopyWith<$Res>
    implements $SchuldCopyWith<$Res> {
  factory _$$VerzendKredietCopyWith(
          _$VerzendKrediet value, $Res Function(_$VerzendKrediet) then) =
      __$$VerzendKredietCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      SchuldenCategorie categorie,
      String omschrijving,
      DateTime beginDatum,
      StatusBerekening statusBerekening,
      String error,
      double totaalBedrag,
      double mndBedrag,
      double slotTermijn,
      int maanden,
      int minMaanden,
      int maxMaanden,
      bool isTotalbedrag,
      bool heeftSlotTermijn,
      int decimalen});
}

/// @nodoc
class __$$VerzendKredietCopyWithImpl<$Res>
    extends _$SchuldCopyWithImpl<$Res, _$VerzendKrediet>
    implements _$$VerzendKredietCopyWith<$Res> {
  __$$VerzendKredietCopyWithImpl(
      _$VerzendKrediet _value, $Res Function(_$VerzendKrediet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categorie = null,
    Object? omschrijving = null,
    Object? beginDatum = null,
    Object? statusBerekening = null,
    Object? error = null,
    Object? totaalBedrag = null,
    Object? mndBedrag = null,
    Object? slotTermijn = null,
    Object? maanden = null,
    Object? minMaanden = null,
    Object? maxMaanden = null,
    Object? isTotalbedrag = null,
    Object? heeftSlotTermijn = null,
    Object? decimalen = null,
  }) {
    return _then(_$VerzendKrediet(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as SchuldenCategorie,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      beginDatum: null == beginDatum
          ? _value.beginDatum
          : beginDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusBerekening: null == statusBerekening
          ? _value.statusBerekening
          : statusBerekening // ignore: cast_nullable_to_non_nullable
              as StatusBerekening,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      totaalBedrag: null == totaalBedrag
          ? _value.totaalBedrag
          : totaalBedrag // ignore: cast_nullable_to_non_nullable
              as double,
      mndBedrag: null == mndBedrag
          ? _value.mndBedrag
          : mndBedrag // ignore: cast_nullable_to_non_nullable
              as double,
      slotTermijn: null == slotTermijn
          ? _value.slotTermijn
          : slotTermijn // ignore: cast_nullable_to_non_nullable
              as double,
      maanden: null == maanden
          ? _value.maanden
          : maanden // ignore: cast_nullable_to_non_nullable
              as int,
      minMaanden: null == minMaanden
          ? _value.minMaanden
          : minMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      maxMaanden: null == maxMaanden
          ? _value.maxMaanden
          : maxMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      isTotalbedrag: null == isTotalbedrag
          ? _value.isTotalbedrag
          : isTotalbedrag // ignore: cast_nullable_to_non_nullable
              as bool,
      heeftSlotTermijn: null == heeftSlotTermijn
          ? _value.heeftSlotTermijn
          : heeftSlotTermijn // ignore: cast_nullable_to_non_nullable
              as bool,
      decimalen: null == decimalen
          ? _value.decimalen
          : decimalen // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerzendKrediet extends VerzendKrediet {
  const _$VerzendKrediet(
      {required this.id,
      required this.categorie,
      required this.omschrijving,
      required this.beginDatum,
      required this.statusBerekening,
      required this.error,
      required this.totaalBedrag,
      required this.mndBedrag,
      required this.slotTermijn,
      required this.maanden,
      required this.minMaanden,
      required this.maxMaanden,
      required this.isTotalbedrag,
      required this.heeftSlotTermijn,
      required this.decimalen,
      final String? $type})
      : $type = $type ?? 'verzendKrediet',
        super._();

  factory _$VerzendKrediet.fromJson(Map<String, dynamic> json) =>
      _$$VerzendKredietFromJson(json);

  @override
  final int id;
  @override
  final SchuldenCategorie categorie;
  @override
  final String omschrijving;
  @override
  final DateTime beginDatum;
  @override
  final StatusBerekening statusBerekening;
  @override
  final String error;
//
  @override
  final double totaalBedrag;
  @override
  final double mndBedrag;
  @override
  final double slotTermijn;
  @override
  final int maanden;
  @override
  final int minMaanden;
  @override
  final int maxMaanden;
  @override
  final bool isTotalbedrag;
  @override
  final bool heeftSlotTermijn;
  @override
  final int decimalen;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Schuld.verzendKrediet(id: $id, categorie: $categorie, omschrijving: $omschrijving, beginDatum: $beginDatum, statusBerekening: $statusBerekening, error: $error, totaalBedrag: $totaalBedrag, mndBedrag: $mndBedrag, slotTermijn: $slotTermijn, maanden: $maanden, minMaanden: $minMaanden, maxMaanden: $maxMaanden, isTotalbedrag: $isTotalbedrag, heeftSlotTermijn: $heeftSlotTermijn, decimalen: $decimalen)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerzendKrediet &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.beginDatum, beginDatum) ||
                other.beginDatum == beginDatum) &&
            (identical(other.statusBerekening, statusBerekening) ||
                other.statusBerekening == statusBerekening) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.totaalBedrag, totaalBedrag) ||
                other.totaalBedrag == totaalBedrag) &&
            (identical(other.mndBedrag, mndBedrag) ||
                other.mndBedrag == mndBedrag) &&
            (identical(other.slotTermijn, slotTermijn) ||
                other.slotTermijn == slotTermijn) &&
            (identical(other.maanden, maanden) || other.maanden == maanden) &&
            (identical(other.minMaanden, minMaanden) ||
                other.minMaanden == minMaanden) &&
            (identical(other.maxMaanden, maxMaanden) ||
                other.maxMaanden == maxMaanden) &&
            (identical(other.isTotalbedrag, isTotalbedrag) ||
                other.isTotalbedrag == isTotalbedrag) &&
            (identical(other.heeftSlotTermijn, heeftSlotTermijn) ||
                other.heeftSlotTermijn == heeftSlotTermijn) &&
            (identical(other.decimalen, decimalen) ||
                other.decimalen == decimalen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      categorie,
      omschrijving,
      beginDatum,
      statusBerekening,
      error,
      totaalBedrag,
      mndBedrag,
      slotTermijn,
      maanden,
      minMaanden,
      maxMaanden,
      isTotalbedrag,
      heeftSlotTermijn,
      decimalen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VerzendKredietCopyWith<_$VerzendKrediet> get copyWith =>
      __$$VerzendKredietCopyWithImpl<_$VerzendKrediet>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)
        leaseAuto,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)
        verzendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)
        doorlopendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)
        aflopendKrediet,
  }) {
    return verzendKrediet(
        id,
        categorie,
        omschrijving,
        beginDatum,
        statusBerekening,
        error,
        totaalBedrag,
        mndBedrag,
        slotTermijn,
        maanden,
        minMaanden,
        maxMaanden,
        isTotalbedrag,
        heeftSlotTermijn,
        decimalen);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
  }) {
    return verzendKrediet?.call(
        id,
        categorie,
        omschrijving,
        beginDatum,
        statusBerekening,
        error,
        totaalBedrag,
        mndBedrag,
        slotTermijn,
        maanden,
        minMaanden,
        maxMaanden,
        isTotalbedrag,
        heeftSlotTermijn,
        decimalen);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
    required TResult orElse(),
  }) {
    if (verzendKrediet != null) {
      return verzendKrediet(
          id,
          categorie,
          omschrijving,
          beginDatum,
          statusBerekening,
          error,
          totaalBedrag,
          mndBedrag,
          slotTermijn,
          maanden,
          minMaanden,
          maxMaanden,
          isTotalbedrag,
          heeftSlotTermijn,
          decimalen);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaseAuto value) leaseAuto,
    required TResult Function(VerzendKrediet value) verzendKrediet,
    required TResult Function(DoorlopendKrediet value) doorlopendKrediet,
    required TResult Function(AflopendKrediet value) aflopendKrediet,
  }) {
    return verzendKrediet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaseAuto value)? leaseAuto,
    TResult? Function(VerzendKrediet value)? verzendKrediet,
    TResult? Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult? Function(AflopendKrediet value)? aflopendKrediet,
  }) {
    return verzendKrediet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaseAuto value)? leaseAuto,
    TResult Function(VerzendKrediet value)? verzendKrediet,
    TResult Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult Function(AflopendKrediet value)? aflopendKrediet,
    required TResult orElse(),
  }) {
    if (verzendKrediet != null) {
      return verzendKrediet(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$VerzendKredietToJson(
      this,
    );
  }
}

abstract class VerzendKrediet extends Schuld {
  const factory VerzendKrediet(
      {required final int id,
      required final SchuldenCategorie categorie,
      required final String omschrijving,
      required final DateTime beginDatum,
      required final StatusBerekening statusBerekening,
      required final String error,
      required final double totaalBedrag,
      required final double mndBedrag,
      required final double slotTermijn,
      required final int maanden,
      required final int minMaanden,
      required final int maxMaanden,
      required final bool isTotalbedrag,
      required final bool heeftSlotTermijn,
      required final int decimalen}) = _$VerzendKrediet;
  const VerzendKrediet._() : super._();

  factory VerzendKrediet.fromJson(Map<String, dynamic> json) =
      _$VerzendKrediet.fromJson;

  @override
  int get id;
  @override
  SchuldenCategorie get categorie;
  @override
  String get omschrijving;
  @override
  DateTime get beginDatum;
  @override
  StatusBerekening get statusBerekening;
  @override
  String get error; //
  double get totaalBedrag;
  double get mndBedrag;
  double get slotTermijn;
  int get maanden;
  int get minMaanden;
  int get maxMaanden;
  bool get isTotalbedrag;
  bool get heeftSlotTermijn;
  int get decimalen;
  @override
  @JsonKey(ignore: true)
  _$$VerzendKredietCopyWith<_$VerzendKrediet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoorlopendKredietCopyWith<$Res>
    implements $SchuldCopyWith<$Res> {
  factory _$$DoorlopendKredietCopyWith(
          _$DoorlopendKrediet value, $Res Function(_$DoorlopendKrediet) then) =
      __$$DoorlopendKredietCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      SchuldenCategorie categorie,
      String omschrijving,
      DateTime beginDatum,
      StatusBerekening statusBerekening,
      String error,
      double bedrag,
      DateTime eindDatumGebruiker,
      bool heeftEindDatum});
}

/// @nodoc
class __$$DoorlopendKredietCopyWithImpl<$Res>
    extends _$SchuldCopyWithImpl<$Res, _$DoorlopendKrediet>
    implements _$$DoorlopendKredietCopyWith<$Res> {
  __$$DoorlopendKredietCopyWithImpl(
      _$DoorlopendKrediet _value, $Res Function(_$DoorlopendKrediet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categorie = null,
    Object? omschrijving = null,
    Object? beginDatum = null,
    Object? statusBerekening = null,
    Object? error = null,
    Object? bedrag = null,
    Object? eindDatumGebruiker = null,
    Object? heeftEindDatum = null,
  }) {
    return _then(_$DoorlopendKrediet(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as SchuldenCategorie,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      beginDatum: null == beginDatum
          ? _value.beginDatum
          : beginDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusBerekening: null == statusBerekening
          ? _value.statusBerekening
          : statusBerekening // ignore: cast_nullable_to_non_nullable
              as StatusBerekening,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      bedrag: null == bedrag
          ? _value.bedrag
          : bedrag // ignore: cast_nullable_to_non_nullable
              as double,
      eindDatumGebruiker: null == eindDatumGebruiker
          ? _value.eindDatumGebruiker
          : eindDatumGebruiker // ignore: cast_nullable_to_non_nullable
              as DateTime,
      heeftEindDatum: null == heeftEindDatum
          ? _value.heeftEindDatum
          : heeftEindDatum // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DoorlopendKrediet extends DoorlopendKrediet {
  const _$DoorlopendKrediet(
      {required this.id,
      required this.categorie,
      required this.omschrijving,
      required this.beginDatum,
      required this.statusBerekening,
      required this.error,
      required this.bedrag,
      required this.eindDatumGebruiker,
      required this.heeftEindDatum,
      final String? $type})
      : $type = $type ?? 'doorlopendKrediet',
        super._();

  factory _$DoorlopendKrediet.fromJson(Map<String, dynamic> json) =>
      _$$DoorlopendKredietFromJson(json);

  @override
  final int id;
  @override
  final SchuldenCategorie categorie;
  @override
  final String omschrijving;
  @override
  final DateTime beginDatum;
  @override
  final StatusBerekening statusBerekening;
  @override
  final String error;
//
  @override
  final double bedrag;
  @override
  final DateTime eindDatumGebruiker;
  @override
  final bool heeftEindDatum;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Schuld.doorlopendKrediet(id: $id, categorie: $categorie, omschrijving: $omschrijving, beginDatum: $beginDatum, statusBerekening: $statusBerekening, error: $error, bedrag: $bedrag, eindDatumGebruiker: $eindDatumGebruiker, heeftEindDatum: $heeftEindDatum)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoorlopendKrediet &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.beginDatum, beginDatum) ||
                other.beginDatum == beginDatum) &&
            (identical(other.statusBerekening, statusBerekening) ||
                other.statusBerekening == statusBerekening) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.bedrag, bedrag) || other.bedrag == bedrag) &&
            (identical(other.eindDatumGebruiker, eindDatumGebruiker) ||
                other.eindDatumGebruiker == eindDatumGebruiker) &&
            (identical(other.heeftEindDatum, heeftEindDatum) ||
                other.heeftEindDatum == heeftEindDatum));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      categorie,
      omschrijving,
      beginDatum,
      statusBerekening,
      error,
      bedrag,
      eindDatumGebruiker,
      heeftEindDatum);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DoorlopendKredietCopyWith<_$DoorlopendKrediet> get copyWith =>
      __$$DoorlopendKredietCopyWithImpl<_$DoorlopendKrediet>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)
        leaseAuto,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)
        verzendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)
        doorlopendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)
        aflopendKrediet,
  }) {
    return doorlopendKrediet(id, categorie, omschrijving, beginDatum,
        statusBerekening, error, bedrag, eindDatumGebruiker, heeftEindDatum);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
  }) {
    return doorlopendKrediet?.call(id, categorie, omschrijving, beginDatum,
        statusBerekening, error, bedrag, eindDatumGebruiker, heeftEindDatum);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
    required TResult orElse(),
  }) {
    if (doorlopendKrediet != null) {
      return doorlopendKrediet(id, categorie, omschrijving, beginDatum,
          statusBerekening, error, bedrag, eindDatumGebruiker, heeftEindDatum);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaseAuto value) leaseAuto,
    required TResult Function(VerzendKrediet value) verzendKrediet,
    required TResult Function(DoorlopendKrediet value) doorlopendKrediet,
    required TResult Function(AflopendKrediet value) aflopendKrediet,
  }) {
    return doorlopendKrediet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaseAuto value)? leaseAuto,
    TResult? Function(VerzendKrediet value)? verzendKrediet,
    TResult? Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult? Function(AflopendKrediet value)? aflopendKrediet,
  }) {
    return doorlopendKrediet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaseAuto value)? leaseAuto,
    TResult Function(VerzendKrediet value)? verzendKrediet,
    TResult Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult Function(AflopendKrediet value)? aflopendKrediet,
    required TResult orElse(),
  }) {
    if (doorlopendKrediet != null) {
      return doorlopendKrediet(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DoorlopendKredietToJson(
      this,
    );
  }
}

abstract class DoorlopendKrediet extends Schuld {
  const factory DoorlopendKrediet(
      {required final int id,
      required final SchuldenCategorie categorie,
      required final String omschrijving,
      required final DateTime beginDatum,
      required final StatusBerekening statusBerekening,
      required final String error,
      required final double bedrag,
      required final DateTime eindDatumGebruiker,
      required final bool heeftEindDatum}) = _$DoorlopendKrediet;
  const DoorlopendKrediet._() : super._();

  factory DoorlopendKrediet.fromJson(Map<String, dynamic> json) =
      _$DoorlopendKrediet.fromJson;

  @override
  int get id;
  @override
  SchuldenCategorie get categorie;
  @override
  String get omschrijving;
  @override
  DateTime get beginDatum;
  @override
  StatusBerekening get statusBerekening;
  @override
  String get error; //
  double get bedrag;
  DateTime get eindDatumGebruiker;
  bool get heeftEindDatum;
  @override
  @JsonKey(ignore: true)
  _$$DoorlopendKredietCopyWith<_$DoorlopendKrediet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AflopendKredietCopyWith<$Res>
    implements $SchuldCopyWith<$Res> {
  factory _$$AflopendKredietCopyWith(
          _$AflopendKrediet value, $Res Function(_$AflopendKrediet) then) =
      __$$AflopendKredietCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      SchuldenCategorie categorie,
      String omschrijving,
      DateTime beginDatum,
      StatusBerekening statusBerekening,
      String error,
      double lening,
      double rente,
      double termijnBedragMnd,
      double minTermijnBedragMnd,
      int maanden,
      int minMaanden,
      int maxMaanden,
      double minAflossenPerMaand,
      double maxAflossenPerMaand,
      double defaultAflossenPerMaand,
      IList<AKtermijnAnn> termijnen,
      double somInterest,
      double somAnn,
      double slotTermijn,
      AflosTabelOpties aflosTabelOpties,
      int decimalen,
      bool renteGebrokenMaand,
      AKbetaling betaling});
}

/// @nodoc
class __$$AflopendKredietCopyWithImpl<$Res>
    extends _$SchuldCopyWithImpl<$Res, _$AflopendKrediet>
    implements _$$AflopendKredietCopyWith<$Res> {
  __$$AflopendKredietCopyWithImpl(
      _$AflopendKrediet _value, $Res Function(_$AflopendKrediet) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categorie = null,
    Object? omschrijving = null,
    Object? beginDatum = null,
    Object? statusBerekening = null,
    Object? error = null,
    Object? lening = null,
    Object? rente = null,
    Object? termijnBedragMnd = null,
    Object? minTermijnBedragMnd = null,
    Object? maanden = null,
    Object? minMaanden = null,
    Object? maxMaanden = null,
    Object? minAflossenPerMaand = null,
    Object? maxAflossenPerMaand = null,
    Object? defaultAflossenPerMaand = null,
    Object? termijnen = null,
    Object? somInterest = null,
    Object? somAnn = null,
    Object? slotTermijn = null,
    Object? aflosTabelOpties = null,
    Object? decimalen = null,
    Object? renteGebrokenMaand = null,
    Object? betaling = null,
  }) {
    return _then(_$AflopendKrediet(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as SchuldenCategorie,
      omschrijving: null == omschrijving
          ? _value.omschrijving
          : omschrijving // ignore: cast_nullable_to_non_nullable
              as String,
      beginDatum: null == beginDatum
          ? _value.beginDatum
          : beginDatum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statusBerekening: null == statusBerekening
          ? _value.statusBerekening
          : statusBerekening // ignore: cast_nullable_to_non_nullable
              as StatusBerekening,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      lening: null == lening
          ? _value.lening
          : lening // ignore: cast_nullable_to_non_nullable
              as double,
      rente: null == rente
          ? _value.rente
          : rente // ignore: cast_nullable_to_non_nullable
              as double,
      termijnBedragMnd: null == termijnBedragMnd
          ? _value.termijnBedragMnd
          : termijnBedragMnd // ignore: cast_nullable_to_non_nullable
              as double,
      minTermijnBedragMnd: null == minTermijnBedragMnd
          ? _value.minTermijnBedragMnd
          : minTermijnBedragMnd // ignore: cast_nullable_to_non_nullable
              as double,
      maanden: null == maanden
          ? _value.maanden
          : maanden // ignore: cast_nullable_to_non_nullable
              as int,
      minMaanden: null == minMaanden
          ? _value.minMaanden
          : minMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      maxMaanden: null == maxMaanden
          ? _value.maxMaanden
          : maxMaanden // ignore: cast_nullable_to_non_nullable
              as int,
      minAflossenPerMaand: null == minAflossenPerMaand
          ? _value.minAflossenPerMaand
          : minAflossenPerMaand // ignore: cast_nullable_to_non_nullable
              as double,
      maxAflossenPerMaand: null == maxAflossenPerMaand
          ? _value.maxAflossenPerMaand
          : maxAflossenPerMaand // ignore: cast_nullable_to_non_nullable
              as double,
      defaultAflossenPerMaand: null == defaultAflossenPerMaand
          ? _value.defaultAflossenPerMaand
          : defaultAflossenPerMaand // ignore: cast_nullable_to_non_nullable
              as double,
      termijnen: null == termijnen
          ? _value.termijnen
          : termijnen // ignore: cast_nullable_to_non_nullable
              as IList<AKtermijnAnn>,
      somInterest: null == somInterest
          ? _value.somInterest
          : somInterest // ignore: cast_nullable_to_non_nullable
              as double,
      somAnn: null == somAnn
          ? _value.somAnn
          : somAnn // ignore: cast_nullable_to_non_nullable
              as double,
      slotTermijn: null == slotTermijn
          ? _value.slotTermijn
          : slotTermijn // ignore: cast_nullable_to_non_nullable
              as double,
      aflosTabelOpties: null == aflosTabelOpties
          ? _value.aflosTabelOpties
          : aflosTabelOpties // ignore: cast_nullable_to_non_nullable
              as AflosTabelOpties,
      decimalen: null == decimalen
          ? _value.decimalen
          : decimalen // ignore: cast_nullable_to_non_nullable
              as int,
      renteGebrokenMaand: null == renteGebrokenMaand
          ? _value.renteGebrokenMaand
          : renteGebrokenMaand // ignore: cast_nullable_to_non_nullable
              as bool,
      betaling: null == betaling
          ? _value.betaling
          : betaling // ignore: cast_nullable_to_non_nullable
              as AKbetaling,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AflopendKrediet extends AflopendKrediet {
  const _$AflopendKrediet(
      {required this.id,
      required this.categorie,
      required this.omschrijving,
      required this.beginDatum,
      required this.statusBerekening,
      required this.error,
      required this.lening,
      required this.rente,
      required this.termijnBedragMnd,
      required this.minTermijnBedragMnd,
      required this.maanden,
      required this.minMaanden,
      required this.maxMaanden,
      required this.minAflossenPerMaand,
      required this.maxAflossenPerMaand,
      required this.defaultAflossenPerMaand,
      required this.termijnen,
      required this.somInterest,
      required this.somAnn,
      required this.slotTermijn,
      required this.aflosTabelOpties,
      required this.decimalen,
      required this.renteGebrokenMaand,
      required this.betaling,
      final String? $type})
      : $type = $type ?? 'aflopendKrediet',
        super._();

  factory _$AflopendKrediet.fromJson(Map<String, dynamic> json) =>
      _$$AflopendKredietFromJson(json);

  @override
  final int id;
  @override
  final SchuldenCategorie categorie;
  @override
  final String omschrijving;
  @override
  final DateTime beginDatum;
  @override
  final StatusBerekening statusBerekening;
  @override
  final String error;
//
  @override
  final double lening;
  @override
  final double rente;
  @override
  final double termijnBedragMnd;
  @override
  final double minTermijnBedragMnd;
  @override
  final int maanden;
  @override
  final int minMaanden;
  @override
  final int maxMaanden;
  @override
  final double minAflossenPerMaand;
  @override
  final double maxAflossenPerMaand;
  @override
  final double defaultAflossenPerMaand;
  @override
  final IList<AKtermijnAnn> termijnen;
  @override
  final double somInterest;
  @override
  final double somAnn;
  @override
  final double slotTermijn;
  @override
  final AflosTabelOpties aflosTabelOpties;
  @override
  final int decimalen;
  @override
  final bool renteGebrokenMaand;
  @override
  final AKbetaling betaling;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Schuld.aflopendKrediet(id: $id, categorie: $categorie, omschrijving: $omschrijving, beginDatum: $beginDatum, statusBerekening: $statusBerekening, error: $error, lening: $lening, rente: $rente, termijnBedragMnd: $termijnBedragMnd, minTermijnBedragMnd: $minTermijnBedragMnd, maanden: $maanden, minMaanden: $minMaanden, maxMaanden: $maxMaanden, minAflossenPerMaand: $minAflossenPerMaand, maxAflossenPerMaand: $maxAflossenPerMaand, defaultAflossenPerMaand: $defaultAflossenPerMaand, termijnen: $termijnen, somInterest: $somInterest, somAnn: $somAnn, slotTermijn: $slotTermijn, aflosTabelOpties: $aflosTabelOpties, decimalen: $decimalen, renteGebrokenMaand: $renteGebrokenMaand, betaling: $betaling)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AflopendKrediet &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categorie, categorie) ||
                other.categorie == categorie) &&
            (identical(other.omschrijving, omschrijving) ||
                other.omschrijving == omschrijving) &&
            (identical(other.beginDatum, beginDatum) ||
                other.beginDatum == beginDatum) &&
            (identical(other.statusBerekening, statusBerekening) ||
                other.statusBerekening == statusBerekening) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.lening, lening) || other.lening == lening) &&
            (identical(other.rente, rente) || other.rente == rente) &&
            (identical(other.termijnBedragMnd, termijnBedragMnd) ||
                other.termijnBedragMnd == termijnBedragMnd) &&
            (identical(other.minTermijnBedragMnd, minTermijnBedragMnd) ||
                other.minTermijnBedragMnd == minTermijnBedragMnd) &&
            (identical(other.maanden, maanden) || other.maanden == maanden) &&
            (identical(other.minMaanden, minMaanden) ||
                other.minMaanden == minMaanden) &&
            (identical(other.maxMaanden, maxMaanden) ||
                other.maxMaanden == maxMaanden) &&
            (identical(other.minAflossenPerMaand, minAflossenPerMaand) ||
                other.minAflossenPerMaand == minAflossenPerMaand) &&
            (identical(other.maxAflossenPerMaand, maxAflossenPerMaand) ||
                other.maxAflossenPerMaand == maxAflossenPerMaand) &&
            (identical(
                    other.defaultAflossenPerMaand, defaultAflossenPerMaand) ||
                other.defaultAflossenPerMaand == defaultAflossenPerMaand) &&
            const DeepCollectionEquality().equals(other.termijnen, termijnen) &&
            (identical(other.somInterest, somInterest) ||
                other.somInterest == somInterest) &&
            (identical(other.somAnn, somAnn) || other.somAnn == somAnn) &&
            (identical(other.slotTermijn, slotTermijn) ||
                other.slotTermijn == slotTermijn) &&
            (identical(other.aflosTabelOpties, aflosTabelOpties) ||
                other.aflosTabelOpties == aflosTabelOpties) &&
            (identical(other.decimalen, decimalen) ||
                other.decimalen == decimalen) &&
            (identical(other.renteGebrokenMaand, renteGebrokenMaand) ||
                other.renteGebrokenMaand == renteGebrokenMaand) &&
            (identical(other.betaling, betaling) ||
                other.betaling == betaling));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        categorie,
        omschrijving,
        beginDatum,
        statusBerekening,
        error,
        lening,
        rente,
        termijnBedragMnd,
        minTermijnBedragMnd,
        maanden,
        minMaanden,
        maxMaanden,
        minAflossenPerMaand,
        maxAflossenPerMaand,
        defaultAflossenPerMaand,
        const DeepCollectionEquality().hash(termijnen),
        somInterest,
        somAnn,
        slotTermijn,
        aflosTabelOpties,
        decimalen,
        renteGebrokenMaand,
        betaling
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AflopendKredietCopyWith<_$AflopendKrediet> get copyWith =>
      __$$AflopendKredietCopyWithImpl<_$AflopendKrediet>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)
        leaseAuto,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)
        verzendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)
        doorlopendKrediet,
    required TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)
        aflopendKrediet,
  }) {
    return aflopendKrediet(
        id,
        categorie,
        omschrijving,
        beginDatum,
        statusBerekening,
        error,
        lening,
        rente,
        termijnBedragMnd,
        minTermijnBedragMnd,
        maanden,
        minMaanden,
        maxMaanden,
        minAflossenPerMaand,
        maxAflossenPerMaand,
        defaultAflossenPerMaand,
        termijnen,
        somInterest,
        somAnn,
        slotTermijn,
        aflosTabelOpties,
        decimalen,
        renteGebrokenMaand,
        betaling);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult? Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
  }) {
    return aflopendKrediet?.call(
        id,
        categorie,
        omschrijving,
        beginDatum,
        statusBerekening,
        error,
        lening,
        rente,
        termijnBedragMnd,
        minTermijnBedragMnd,
        maanden,
        minMaanden,
        maxMaanden,
        minAflossenPerMaand,
        maxAflossenPerMaand,
        defaultAflossenPerMaand,
        termijnen,
        somInterest,
        somAnn,
        slotTermijn,
        aflosTabelOpties,
        decimalen,
        renteGebrokenMaand,
        betaling);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double mndBedrag,
            int jaren,
            int maanden)?
        leaseAuto,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double totaalBedrag,
            double mndBedrag,
            double slotTermijn,
            int maanden,
            int minMaanden,
            int maxMaanden,
            bool isTotalbedrag,
            bool heeftSlotTermijn,
            int decimalen)?
        verzendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double bedrag,
            DateTime eindDatumGebruiker,
            bool heeftEindDatum)?
        doorlopendKrediet,
    TResult Function(
            int id,
            SchuldenCategorie categorie,
            String omschrijving,
            DateTime beginDatum,
            StatusBerekening statusBerekening,
            String error,
            double lening,
            double rente,
            double termijnBedragMnd,
            double minTermijnBedragMnd,
            int maanden,
            int minMaanden,
            int maxMaanden,
            double minAflossenPerMaand,
            double maxAflossenPerMaand,
            double defaultAflossenPerMaand,
            IList<AKtermijnAnn> termijnen,
            double somInterest,
            double somAnn,
            double slotTermijn,
            AflosTabelOpties aflosTabelOpties,
            int decimalen,
            bool renteGebrokenMaand,
            AKbetaling betaling)?
        aflopendKrediet,
    required TResult orElse(),
  }) {
    if (aflopendKrediet != null) {
      return aflopendKrediet(
          id,
          categorie,
          omschrijving,
          beginDatum,
          statusBerekening,
          error,
          lening,
          rente,
          termijnBedragMnd,
          minTermijnBedragMnd,
          maanden,
          minMaanden,
          maxMaanden,
          minAflossenPerMaand,
          maxAflossenPerMaand,
          defaultAflossenPerMaand,
          termijnen,
          somInterest,
          somAnn,
          slotTermijn,
          aflosTabelOpties,
          decimalen,
          renteGebrokenMaand,
          betaling);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaseAuto value) leaseAuto,
    required TResult Function(VerzendKrediet value) verzendKrediet,
    required TResult Function(DoorlopendKrediet value) doorlopendKrediet,
    required TResult Function(AflopendKrediet value) aflopendKrediet,
  }) {
    return aflopendKrediet(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaseAuto value)? leaseAuto,
    TResult? Function(VerzendKrediet value)? verzendKrediet,
    TResult? Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult? Function(AflopendKrediet value)? aflopendKrediet,
  }) {
    return aflopendKrediet?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaseAuto value)? leaseAuto,
    TResult Function(VerzendKrediet value)? verzendKrediet,
    TResult Function(DoorlopendKrediet value)? doorlopendKrediet,
    TResult Function(AflopendKrediet value)? aflopendKrediet,
    required TResult orElse(),
  }) {
    if (aflopendKrediet != null) {
      return aflopendKrediet(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AflopendKredietToJson(
      this,
    );
  }
}

abstract class AflopendKrediet extends Schuld {
  const factory AflopendKrediet(
      {required final int id,
      required final SchuldenCategorie categorie,
      required final String omschrijving,
      required final DateTime beginDatum,
      required final StatusBerekening statusBerekening,
      required final String error,
      required final double lening,
      required final double rente,
      required final double termijnBedragMnd,
      required final double minTermijnBedragMnd,
      required final int maanden,
      required final int minMaanden,
      required final int maxMaanden,
      required final double minAflossenPerMaand,
      required final double maxAflossenPerMaand,
      required final double defaultAflossenPerMaand,
      required final IList<AKtermijnAnn> termijnen,
      required final double somInterest,
      required final double somAnn,
      required final double slotTermijn,
      required final AflosTabelOpties aflosTabelOpties,
      required final int decimalen,
      required final bool renteGebrokenMaand,
      required final AKbetaling betaling}) = _$AflopendKrediet;
  const AflopendKrediet._() : super._();

  factory AflopendKrediet.fromJson(Map<String, dynamic> json) =
      _$AflopendKrediet.fromJson;

  @override
  int get id;
  @override
  SchuldenCategorie get categorie;
  @override
  String get omschrijving;
  @override
  DateTime get beginDatum;
  @override
  StatusBerekening get statusBerekening;
  @override
  String get error; //
  double get lening;
  double get rente;
  double get termijnBedragMnd;
  double get minTermijnBedragMnd;
  int get maanden;
  int get minMaanden;
  int get maxMaanden;
  double get minAflossenPerMaand;
  double get maxAflossenPerMaand;
  double get defaultAflossenPerMaand;
  IList<AKtermijnAnn> get termijnen;
  double get somInterest;
  double get somAnn;
  double get slotTermijn;
  AflosTabelOpties get aflosTabelOpties;
  int get decimalen;
  bool get renteGebrokenMaand;
  AKbetaling get betaling;
  @override
  @JsonKey(ignore: true)
  _$$AflopendKredietCopyWith<_$AflopendKrediet> get copyWith =>
      throw _privateConstructorUsedError;
}

AKtermijnAnn _$AKtermijnAnnFromJson(Map<String, dynamic> json) {
  return _AKtermijnAnn.fromJson(json);
}

/// @nodoc
mixin _$AKtermijnAnn {
  DateTime get termijn => throw _privateConstructorUsedError;
  double get interest => throw _privateConstructorUsedError;
  double get aflossen => throw _privateConstructorUsedError;
  double get schuld => throw _privateConstructorUsedError;
  double get termijnBedrag => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AKtermijnAnnCopyWith<AKtermijnAnn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AKtermijnAnnCopyWith<$Res> {
  factory $AKtermijnAnnCopyWith(
          AKtermijnAnn value, $Res Function(AKtermijnAnn) then) =
      _$AKtermijnAnnCopyWithImpl<$Res, AKtermijnAnn>;
  @useResult
  $Res call(
      {DateTime termijn,
      double interest,
      double aflossen,
      double schuld,
      double termijnBedrag});
}

/// @nodoc
class _$AKtermijnAnnCopyWithImpl<$Res, $Val extends AKtermijnAnn>
    implements $AKtermijnAnnCopyWith<$Res> {
  _$AKtermijnAnnCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termijn = null,
    Object? interest = null,
    Object? aflossen = null,
    Object? schuld = null,
    Object? termijnBedrag = null,
  }) {
    return _then(_value.copyWith(
      termijn: null == termijn
          ? _value.termijn
          : termijn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      interest: null == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as double,
      aflossen: null == aflossen
          ? _value.aflossen
          : aflossen // ignore: cast_nullable_to_non_nullable
              as double,
      schuld: null == schuld
          ? _value.schuld
          : schuld // ignore: cast_nullable_to_non_nullable
              as double,
      termijnBedrag: null == termijnBedrag
          ? _value.termijnBedrag
          : termijnBedrag // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AKtermijnAnnCopyWith<$Res>
    implements $AKtermijnAnnCopyWith<$Res> {
  factory _$$_AKtermijnAnnCopyWith(
          _$_AKtermijnAnn value, $Res Function(_$_AKtermijnAnn) then) =
      __$$_AKtermijnAnnCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime termijn,
      double interest,
      double aflossen,
      double schuld,
      double termijnBedrag});
}

/// @nodoc
class __$$_AKtermijnAnnCopyWithImpl<$Res>
    extends _$AKtermijnAnnCopyWithImpl<$Res, _$_AKtermijnAnn>
    implements _$$_AKtermijnAnnCopyWith<$Res> {
  __$$_AKtermijnAnnCopyWithImpl(
      _$_AKtermijnAnn _value, $Res Function(_$_AKtermijnAnn) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? termijn = null,
    Object? interest = null,
    Object? aflossen = null,
    Object? schuld = null,
    Object? termijnBedrag = null,
  }) {
    return _then(_$_AKtermijnAnn(
      termijn: null == termijn
          ? _value.termijn
          : termijn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      interest: null == interest
          ? _value.interest
          : interest // ignore: cast_nullable_to_non_nullable
              as double,
      aflossen: null == aflossen
          ? _value.aflossen
          : aflossen // ignore: cast_nullable_to_non_nullable
              as double,
      schuld: null == schuld
          ? _value.schuld
          : schuld // ignore: cast_nullable_to_non_nullable
              as double,
      termijnBedrag: null == termijnBedrag
          ? _value.termijnBedrag
          : termijnBedrag // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AKtermijnAnn implements _AKtermijnAnn {
  const _$_AKtermijnAnn(
      {required this.termijn,
      required this.interest,
      required this.aflossen,
      required this.schuld,
      required this.termijnBedrag});

  factory _$_AKtermijnAnn.fromJson(Map<String, dynamic> json) =>
      _$$_AKtermijnAnnFromJson(json);

  @override
  final DateTime termijn;
  @override
  final double interest;
  @override
  final double aflossen;
  @override
  final double schuld;
  @override
  final double termijnBedrag;

  @override
  String toString() {
    return 'AKtermijnAnn(termijn: $termijn, interest: $interest, aflossen: $aflossen, schuld: $schuld, termijnBedrag: $termijnBedrag)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AKtermijnAnn &&
            (identical(other.termijn, termijn) || other.termijn == termijn) &&
            (identical(other.interest, interest) ||
                other.interest == interest) &&
            (identical(other.aflossen, aflossen) ||
                other.aflossen == aflossen) &&
            (identical(other.schuld, schuld) || other.schuld == schuld) &&
            (identical(other.termijnBedrag, termijnBedrag) ||
                other.termijnBedrag == termijnBedrag));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, termijn, interest, aflossen, schuld, termijnBedrag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AKtermijnAnnCopyWith<_$_AKtermijnAnn> get copyWith =>
      __$$_AKtermijnAnnCopyWithImpl<_$_AKtermijnAnn>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AKtermijnAnnToJson(
      this,
    );
  }
}

abstract class _AKtermijnAnn implements AKtermijnAnn {
  const factory _AKtermijnAnn(
      {required final DateTime termijn,
      required final double interest,
      required final double aflossen,
      required final double schuld,
      required final double termijnBedrag}) = _$_AKtermijnAnn;

  factory _AKtermijnAnn.fromJson(Map<String, dynamic> json) =
      _$_AKtermijnAnn.fromJson;

  @override
  DateTime get termijn;
  @override
  double get interest;
  @override
  double get aflossen;
  @override
  double get schuld;
  @override
  double get termijnBedrag;
  @override
  @JsonKey(ignore: true)
  _$$_AKtermijnAnnCopyWith<_$_AKtermijnAnn> get copyWith =>
      throw _privateConstructorUsedError;
}
