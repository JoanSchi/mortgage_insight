import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'eigenwoningreserve.freezed.dart';
part 'eigenwoningreserve.g.dart';

@freezed
class EigenWoningReserve with _$EigenWoningReserve {
  const factory EigenWoningReserve(
      {@Default(true) bool ewrToepassen,
      @Default(false) bool ewrBerekenen,
      @Default(0.0) double ewr,
      @Default(0.0) double oorspronkelijkeHoofdsom}) = _EigenWoningReserve;

  factory EigenWoningReserve.fromJson(Map<String, Object?> json) =>
      _$EigenWoningReserveFromJson(json);
}
