import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'aflos_item.freezed.dart';
part 'aflos_item.g.dart';

@freezed
class AflosItem with _$AflosItem {
  const AflosItem._();

  const factory AflosItem(
      {required DateTime date,
      required double value,
      required int terms,
      required int periodInMonths}) = _AflosItem;

  factory AflosItem.fromJson(Map<String, Object?> json) =>
      _$AflosItemFromJson(json);
}
