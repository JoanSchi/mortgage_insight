// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inkomen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

InkomensOverzicht _$InkomensOverzichtFromJson(Map<String, dynamic> json) {
  return _InkomensOverzicht.fromJson(json);
}

/// @nodoc
mixin _$InkomensOverzicht {
  IList<Inkomen> get inkomen => throw _privateConstructorUsedError;
  IList<Inkomen> get inkomenPartner => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InkomensOverzichtCopyWith<InkomensOverzicht> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InkomensOverzichtCopyWith<$Res> {
  factory $InkomensOverzichtCopyWith(
          InkomensOverzicht value, $Res Function(InkomensOverzicht) then) =
      _$InkomensOverzichtCopyWithImpl<$Res, InkomensOverzicht>;
  @useResult
  $Res call({IList<Inkomen> inkomen, IList<Inkomen> inkomenPartner});
}

/// @nodoc
class _$InkomensOverzichtCopyWithImpl<$Res, $Val extends InkomensOverzicht>
    implements $InkomensOverzichtCopyWith<$Res> {
  _$InkomensOverzichtCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inkomen = null,
    Object? inkomenPartner = null,
  }) {
    return _then(_value.copyWith(
      inkomen: null == inkomen
          ? _value.inkomen
          : inkomen // ignore: cast_nullable_to_non_nullable
              as IList<Inkomen>,
      inkomenPartner: null == inkomenPartner
          ? _value.inkomenPartner
          : inkomenPartner // ignore: cast_nullable_to_non_nullable
              as IList<Inkomen>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InkomensOverzichtCopyWith<$Res>
    implements $InkomensOverzichtCopyWith<$Res> {
  factory _$$_InkomensOverzichtCopyWith(_$_InkomensOverzicht value,
          $Res Function(_$_InkomensOverzicht) then) =
      __$$_InkomensOverzichtCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IList<Inkomen> inkomen, IList<Inkomen> inkomenPartner});
}

/// @nodoc
class __$$_InkomensOverzichtCopyWithImpl<$Res>
    extends _$InkomensOverzichtCopyWithImpl<$Res, _$_InkomensOverzicht>
    implements _$$_InkomensOverzichtCopyWith<$Res> {
  __$$_InkomensOverzichtCopyWithImpl(
      _$_InkomensOverzicht _value, $Res Function(_$_InkomensOverzicht) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inkomen = null,
    Object? inkomenPartner = null,
  }) {
    return _then(_$_InkomensOverzicht(
      inkomen: null == inkomen
          ? _value.inkomen
          : inkomen // ignore: cast_nullable_to_non_nullable
              as IList<Inkomen>,
      inkomenPartner: null == inkomenPartner
          ? _value.inkomenPartner
          : inkomenPartner // ignore: cast_nullable_to_non_nullable
              as IList<Inkomen>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_InkomensOverzicht extends _InkomensOverzicht
    with DiagnosticableTreeMixin {
  const _$_InkomensOverzicht(
      {this.inkomen = const IListConst([]),
      this.inkomenPartner = const IListConst([])})
      : super._();

  factory _$_InkomensOverzicht.fromJson(Map<String, dynamic> json) =>
      _$$_InkomensOverzichtFromJson(json);

  @override
  @JsonKey()
  final IList<Inkomen> inkomen;
  @override
  @JsonKey()
  final IList<Inkomen> inkomenPartner;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InkomensOverzicht(inkomen: $inkomen, inkomenPartner: $inkomenPartner)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InkomensOverzicht'))
      ..add(DiagnosticsProperty('inkomen', inkomen))
      ..add(DiagnosticsProperty('inkomenPartner', inkomenPartner));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InkomensOverzicht &&
            const DeepCollectionEquality().equals(other.inkomen, inkomen) &&
            const DeepCollectionEquality()
                .equals(other.inkomenPartner, inkomenPartner));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(inkomen),
      const DeepCollectionEquality().hash(inkomenPartner));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InkomensOverzichtCopyWith<_$_InkomensOverzicht> get copyWith =>
      __$$_InkomensOverzichtCopyWithImpl<_$_InkomensOverzicht>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InkomensOverzichtToJson(
      this,
    );
  }
}

abstract class _InkomensOverzicht extends InkomensOverzicht {
  const factory _InkomensOverzicht(
      {final IList<Inkomen> inkomen,
      final IList<Inkomen> inkomenPartner}) = _$_InkomensOverzicht;
  const _InkomensOverzicht._() : super._();

  factory _InkomensOverzicht.fromJson(Map<String, dynamic> json) =
      _$_InkomensOverzicht.fromJson;

  @override
  IList<Inkomen> get inkomen;
  @override
  IList<Inkomen> get inkomenPartner;
  @override
  @JsonKey(ignore: true)
  _$$_InkomensOverzichtCopyWith<_$_InkomensOverzicht> get copyWith =>
      throw _privateConstructorUsedError;
}

Inkomen _$InkomenFromJson(Map<String, dynamic> json) {
  return _Inkomen.fromJson(json);
}

/// @nodoc
mixin _$Inkomen {
  DateTime get datum => throw _privateConstructorUsedError;
  bool get partner => throw _privateConstructorUsedError;
  double get indexatie => throw _privateConstructorUsedError;
  bool get pensioen => throw _privateConstructorUsedError;
  PeriodeInkomen get periodeInkomen => throw _privateConstructorUsedError;
  double get brutoInkomen => throw _privateConstructorUsedError;
  bool get dertiendeMaand => throw _privateConstructorUsedError;
  bool get vakantiegeld => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InkomenCopyWith<Inkomen> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InkomenCopyWith<$Res> {
  factory $InkomenCopyWith(Inkomen value, $Res Function(Inkomen) then) =
      _$InkomenCopyWithImpl<$Res, Inkomen>;
  @useResult
  $Res call(
      {DateTime datum,
      bool partner,
      double indexatie,
      bool pensioen,
      PeriodeInkomen periodeInkomen,
      double brutoInkomen,
      bool dertiendeMaand,
      bool vakantiegeld});
}

/// @nodoc
class _$InkomenCopyWithImpl<$Res, $Val extends Inkomen>
    implements $InkomenCopyWith<$Res> {
  _$InkomenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? partner = null,
    Object? indexatie = null,
    Object? pensioen = null,
    Object? periodeInkomen = null,
    Object? brutoInkomen = null,
    Object? dertiendeMaand = null,
    Object? vakantiegeld = null,
  }) {
    return _then(_value.copyWith(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      partner: null == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as bool,
      indexatie: null == indexatie
          ? _value.indexatie
          : indexatie // ignore: cast_nullable_to_non_nullable
              as double,
      pensioen: null == pensioen
          ? _value.pensioen
          : pensioen // ignore: cast_nullable_to_non_nullable
              as bool,
      periodeInkomen: null == periodeInkomen
          ? _value.periodeInkomen
          : periodeInkomen // ignore: cast_nullable_to_non_nullable
              as PeriodeInkomen,
      brutoInkomen: null == brutoInkomen
          ? _value.brutoInkomen
          : brutoInkomen // ignore: cast_nullable_to_non_nullable
              as double,
      dertiendeMaand: null == dertiendeMaand
          ? _value.dertiendeMaand
          : dertiendeMaand // ignore: cast_nullable_to_non_nullable
              as bool,
      vakantiegeld: null == vakantiegeld
          ? _value.vakantiegeld
          : vakantiegeld // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_InkomenCopyWith<$Res> implements $InkomenCopyWith<$Res> {
  factory _$$_InkomenCopyWith(
          _$_Inkomen value, $Res Function(_$_Inkomen) then) =
      __$$_InkomenCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime datum,
      bool partner,
      double indexatie,
      bool pensioen,
      PeriodeInkomen periodeInkomen,
      double brutoInkomen,
      bool dertiendeMaand,
      bool vakantiegeld});
}

/// @nodoc
class __$$_InkomenCopyWithImpl<$Res>
    extends _$InkomenCopyWithImpl<$Res, _$_Inkomen>
    implements _$$_InkomenCopyWith<$Res> {
  __$$_InkomenCopyWithImpl(_$_Inkomen _value, $Res Function(_$_Inkomen) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? datum = null,
    Object? partner = null,
    Object? indexatie = null,
    Object? pensioen = null,
    Object? periodeInkomen = null,
    Object? brutoInkomen = null,
    Object? dertiendeMaand = null,
    Object? vakantiegeld = null,
  }) {
    return _then(_$_Inkomen(
      datum: null == datum
          ? _value.datum
          : datum // ignore: cast_nullable_to_non_nullable
              as DateTime,
      partner: null == partner
          ? _value.partner
          : partner // ignore: cast_nullable_to_non_nullable
              as bool,
      indexatie: null == indexatie
          ? _value.indexatie
          : indexatie // ignore: cast_nullable_to_non_nullable
              as double,
      pensioen: null == pensioen
          ? _value.pensioen
          : pensioen // ignore: cast_nullable_to_non_nullable
              as bool,
      periodeInkomen: null == periodeInkomen
          ? _value.periodeInkomen
          : periodeInkomen // ignore: cast_nullable_to_non_nullable
              as PeriodeInkomen,
      brutoInkomen: null == brutoInkomen
          ? _value.brutoInkomen
          : brutoInkomen // ignore: cast_nullable_to_non_nullable
              as double,
      dertiendeMaand: null == dertiendeMaand
          ? _value.dertiendeMaand
          : dertiendeMaand // ignore: cast_nullable_to_non_nullable
              as bool,
      vakantiegeld: null == vakantiegeld
          ? _value.vakantiegeld
          : vakantiegeld // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Inkomen extends _Inkomen with DiagnosticableTreeMixin {
  const _$_Inkomen(
      {required this.datum,
      required this.partner,
      required this.indexatie,
      required this.pensioen,
      required this.periodeInkomen,
      required this.brutoInkomen,
      required this.dertiendeMaand,
      required this.vakantiegeld})
      : super._();

  factory _$_Inkomen.fromJson(Map<String, dynamic> json) =>
      _$$_InkomenFromJson(json);

  @override
  final DateTime datum;
  @override
  final bool partner;
  @override
  final double indexatie;
  @override
  final bool pensioen;
  @override
  final PeriodeInkomen periodeInkomen;
  @override
  final double brutoInkomen;
  @override
  final bool dertiendeMaand;
  @override
  final bool vakantiegeld;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Inkomen(datum: $datum, partner: $partner, indexatie: $indexatie, pensioen: $pensioen, periodeInkomen: $periodeInkomen, brutoInkomen: $brutoInkomen, dertiendeMaand: $dertiendeMaand, vakantiegeld: $vakantiegeld)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Inkomen'))
      ..add(DiagnosticsProperty('datum', datum))
      ..add(DiagnosticsProperty('partner', partner))
      ..add(DiagnosticsProperty('indexatie', indexatie))
      ..add(DiagnosticsProperty('pensioen', pensioen))
      ..add(DiagnosticsProperty('periodeInkomen', periodeInkomen))
      ..add(DiagnosticsProperty('brutoInkomen', brutoInkomen))
      ..add(DiagnosticsProperty('dertiendeMaand', dertiendeMaand))
      ..add(DiagnosticsProperty('vakantiegeld', vakantiegeld));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Inkomen &&
            (identical(other.datum, datum) || other.datum == datum) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.indexatie, indexatie) ||
                other.indexatie == indexatie) &&
            (identical(other.pensioen, pensioen) ||
                other.pensioen == pensioen) &&
            (identical(other.periodeInkomen, periodeInkomen) ||
                other.periodeInkomen == periodeInkomen) &&
            (identical(other.brutoInkomen, brutoInkomen) ||
                other.brutoInkomen == brutoInkomen) &&
            (identical(other.dertiendeMaand, dertiendeMaand) ||
                other.dertiendeMaand == dertiendeMaand) &&
            (identical(other.vakantiegeld, vakantiegeld) ||
                other.vakantiegeld == vakantiegeld));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, datum, partner, indexatie,
      pensioen, periodeInkomen, brutoInkomen, dertiendeMaand, vakantiegeld);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InkomenCopyWith<_$_Inkomen> get copyWith =>
      __$$_InkomenCopyWithImpl<_$_Inkomen>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_InkomenToJson(
      this,
    );
  }
}

abstract class _Inkomen extends Inkomen {
  const factory _Inkomen(
      {required final DateTime datum,
      required final bool partner,
      required final double indexatie,
      required final bool pensioen,
      required final PeriodeInkomen periodeInkomen,
      required final double brutoInkomen,
      required final bool dertiendeMaand,
      required final bool vakantiegeld}) = _$_Inkomen;
  const _Inkomen._() : super._();

  factory _Inkomen.fromJson(Map<String, dynamic> json) = _$_Inkomen.fromJson;

  @override
  DateTime get datum;
  @override
  bool get partner;
  @override
  double get indexatie;
  @override
  bool get pensioen;
  @override
  PeriodeInkomen get periodeInkomen;
  @override
  double get brutoInkomen;
  @override
  bool get dertiendeMaand;
  @override
  bool get vakantiegeld;
  @override
  @JsonKey(ignore: true)
  _$$_InkomenCopyWith<_$_Inkomen> get copyWith =>
      throw _privateConstructorUsedError;
}
