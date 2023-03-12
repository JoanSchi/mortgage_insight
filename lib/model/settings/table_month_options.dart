import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'table_month_options.freezed.dart';
part 'table_month_options.g.dart';

@freezed
class TableMonthOptions with _$TableMonthOptions {
  const TableMonthOptions._();

  const factory TableMonthOptions(
      {required IList<bool> monthsVisible,
      required bool startEnd,
      required bool deviate}) = _TableMonthOptions;

  factory TableMonthOptions.fromJson(Map<String, Object?> json) =>
      _$TableMonthOptionsFromJson(json);

  bool monthVisible(int month) => monthsVisible[month - 1];
}
