// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'table_month_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TableMonthOptions _$TableMonthOptionsFromJson(Map<String, dynamic> json) {
  return _TableMonthOptions.fromJson(json);
}

/// @nodoc
mixin _$TableMonthOptions {
  IList<bool> get monthsVisible => throw _privateConstructorUsedError;
  bool get startEnd => throw _privateConstructorUsedError;
  bool get deviate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TableMonthOptionsCopyWith<TableMonthOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TableMonthOptionsCopyWith<$Res> {
  factory $TableMonthOptionsCopyWith(
          TableMonthOptions value, $Res Function(TableMonthOptions) then) =
      _$TableMonthOptionsCopyWithImpl<$Res, TableMonthOptions>;
  @useResult
  $Res call({IList<bool> monthsVisible, bool startEnd, bool deviate});
}

/// @nodoc
class _$TableMonthOptionsCopyWithImpl<$Res, $Val extends TableMonthOptions>
    implements $TableMonthOptionsCopyWith<$Res> {
  _$TableMonthOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthsVisible = null,
    Object? startEnd = null,
    Object? deviate = null,
  }) {
    return _then(_value.copyWith(
      monthsVisible: null == monthsVisible
          ? _value.monthsVisible
          : monthsVisible // ignore: cast_nullable_to_non_nullable
              as IList<bool>,
      startEnd: null == startEnd
          ? _value.startEnd
          : startEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      deviate: null == deviate
          ? _value.deviate
          : deviate // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TableMonthOptionsCopyWith<$Res>
    implements $TableMonthOptionsCopyWith<$Res> {
  factory _$$_TableMonthOptionsCopyWith(_$_TableMonthOptions value,
          $Res Function(_$_TableMonthOptions) then) =
      __$$_TableMonthOptionsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IList<bool> monthsVisible, bool startEnd, bool deviate});
}

/// @nodoc
class __$$_TableMonthOptionsCopyWithImpl<$Res>
    extends _$TableMonthOptionsCopyWithImpl<$Res, _$_TableMonthOptions>
    implements _$$_TableMonthOptionsCopyWith<$Res> {
  __$$_TableMonthOptionsCopyWithImpl(
      _$_TableMonthOptions _value, $Res Function(_$_TableMonthOptions) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? monthsVisible = null,
    Object? startEnd = null,
    Object? deviate = null,
  }) {
    return _then(_$_TableMonthOptions(
      monthsVisible: null == monthsVisible
          ? _value.monthsVisible
          : monthsVisible // ignore: cast_nullable_to_non_nullable
              as IList<bool>,
      startEnd: null == startEnd
          ? _value.startEnd
          : startEnd // ignore: cast_nullable_to_non_nullable
              as bool,
      deviate: null == deviate
          ? _value.deviate
          : deviate // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TableMonthOptions extends _TableMonthOptions {
  const _$_TableMonthOptions(
      {required this.monthsVisible,
      required this.startEnd,
      required this.deviate})
      : super._();

  factory _$_TableMonthOptions.fromJson(Map<String, dynamic> json) =>
      _$$_TableMonthOptionsFromJson(json);

  @override
  final IList<bool> monthsVisible;
  @override
  final bool startEnd;
  @override
  final bool deviate;

  @override
  String toString() {
    return 'TableMonthOptions(monthsVisible: $monthsVisible, startEnd: $startEnd, deviate: $deviate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TableMonthOptions &&
            const DeepCollectionEquality()
                .equals(other.monthsVisible, monthsVisible) &&
            (identical(other.startEnd, startEnd) ||
                other.startEnd == startEnd) &&
            (identical(other.deviate, deviate) || other.deviate == deviate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(monthsVisible), startEnd, deviate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TableMonthOptionsCopyWith<_$_TableMonthOptions> get copyWith =>
      __$$_TableMonthOptionsCopyWithImpl<_$_TableMonthOptions>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TableMonthOptionsToJson(
      this,
    );
  }
}

abstract class _TableMonthOptions extends TableMonthOptions {
  const factory _TableMonthOptions(
      {required final IList<bool> monthsVisible,
      required final bool startEnd,
      required final bool deviate}) = _$_TableMonthOptions;
  const _TableMonthOptions._() : super._();

  factory _TableMonthOptions.fromJson(Map<String, dynamic> json) =
      _$_TableMonthOptions.fromJson;

  @override
  IList<bool> get monthsVisible;
  @override
  bool get startEnd;
  @override
  bool get deviate;
  @override
  @JsonKey(ignore: true)
  _$$_TableMonthOptionsCopyWith<_$_TableMonthOptions> get copyWith =>
      throw _privateConstructorUsedError;
}
