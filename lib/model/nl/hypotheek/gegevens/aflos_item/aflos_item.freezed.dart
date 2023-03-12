// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aflos_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AflosItem _$AflosItemFromJson(Map<String, dynamic> json) {
  return _AflosItem.fromJson(json);
}

/// @nodoc
mixin _$AflosItem {
  DateTime get date => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  int get terms => throw _privateConstructorUsedError;
  int get periodInMonths => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AflosItemCopyWith<AflosItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AflosItemCopyWith<$Res> {
  factory $AflosItemCopyWith(AflosItem value, $Res Function(AflosItem) then) =
      _$AflosItemCopyWithImpl<$Res, AflosItem>;
  @useResult
  $Res call({DateTime date, double value, int terms, int periodInMonths});
}

/// @nodoc
class _$AflosItemCopyWithImpl<$Res, $Val extends AflosItem>
    implements $AflosItemCopyWith<$Res> {
  _$AflosItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? terms = null,
    Object? periodInMonths = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      terms: null == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as int,
      periodInMonths: null == periodInMonths
          ? _value.periodInMonths
          : periodInMonths // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AflosItemCopyWith<$Res> implements $AflosItemCopyWith<$Res> {
  factory _$$_AflosItemCopyWith(
          _$_AflosItem value, $Res Function(_$_AflosItem) then) =
      __$$_AflosItemCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, double value, int terms, int periodInMonths});
}

/// @nodoc
class __$$_AflosItemCopyWithImpl<$Res>
    extends _$AflosItemCopyWithImpl<$Res, _$_AflosItem>
    implements _$$_AflosItemCopyWith<$Res> {
  __$$_AflosItemCopyWithImpl(
      _$_AflosItem _value, $Res Function(_$_AflosItem) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? value = null,
    Object? terms = null,
    Object? periodInMonths = null,
  }) {
    return _then(_$_AflosItem(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      terms: null == terms
          ? _value.terms
          : terms // ignore: cast_nullable_to_non_nullable
              as int,
      periodInMonths: null == periodInMonths
          ? _value.periodInMonths
          : periodInMonths // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AflosItem extends _AflosItem with DiagnosticableTreeMixin {
  const _$_AflosItem(
      {required this.date,
      required this.value,
      required this.terms,
      required this.periodInMonths})
      : super._();

  factory _$_AflosItem.fromJson(Map<String, dynamic> json) =>
      _$$_AflosItemFromJson(json);

  @override
  final DateTime date;
  @override
  final double value;
  @override
  final int terms;
  @override
  final int periodInMonths;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AflosItem(date: $date, value: $value, terms: $terms, periodInMonths: $periodInMonths)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AflosItem'))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('value', value))
      ..add(DiagnosticsProperty('terms', terms))
      ..add(DiagnosticsProperty('periodInMonths', periodInMonths));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AflosItem &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.terms, terms) || other.terms == terms) &&
            (identical(other.periodInMonths, periodInMonths) ||
                other.periodInMonths == periodInMonths));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, value, terms, periodInMonths);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AflosItemCopyWith<_$_AflosItem> get copyWith =>
      __$$_AflosItemCopyWithImpl<_$_AflosItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AflosItemToJson(
      this,
    );
  }
}

abstract class _AflosItem extends AflosItem {
  const factory _AflosItem(
      {required final DateTime date,
      required final double value,
      required final int terms,
      required final int periodInMonths}) = _$_AflosItem;
  const _AflosItem._() : super._();

  factory _AflosItem.fromJson(Map<String, dynamic> json) =
      _$_AflosItem.fromJson;

  @override
  DateTime get date;
  @override
  double get value;
  @override
  int get terms;
  @override
  int get periodInMonths;
  @override
  @JsonKey(ignore: true)
  _$$_AflosItemCopyWith<_$_AflosItem> get copyWith =>
      throw _privateConstructorUsedError;
}
