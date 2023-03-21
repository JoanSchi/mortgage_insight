import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'extra_of_kosten_lening.freezed.dart';
part 'extra_of_kosten_lening.g.dart';

enum Eenheid {
  percentageTaxatie,
  percentageWoningWaarde,
  percentageLening,
  bedrag
}

@freezed
class Waarde with _$Waarde {
  const Waarde._();

  const factory Waarde({
    required String id,
    required int index,
    required String omschrijving,
    required double getal,
    required Eenheid eenheid,
    @Default(false) bool aftrekbaar,
    @Default(false) bool standaard,
    @Default(false) bool verduurzamen,
  }) = _Waarde;

  factory Waarde.fromJson(Map<String, Object?> json) => _$WaardeFromJson(json);

  String get key => '$index$id';
}
