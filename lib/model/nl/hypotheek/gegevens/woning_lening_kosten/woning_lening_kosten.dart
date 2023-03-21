import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../extra_of_kosten_lening/extra_of_kosten_lening.dart';

part 'woning_lening_kosten.freezed.dart';
part 'woning_lening_kosten.g.dart';

@freezed
class WoningLeningKosten with _$WoningLeningKosten {
  const WoningLeningKosten._();

  const factory WoningLeningKosten({
    @Default(IListConst([])) IList<Waarde> kosten,
    @Default(0.0) double woningWaarde,
    @Default(0.0) double lening,
  }) = _WoningLeningKosten;

  factory WoningLeningKosten.fromJson(Map<String, Object?> json) =>
      _$WoningLeningKostenFromJson(json);

  double get totaleKosten => kosten.fold(0.0, (double previous, Waarde w) {
        double value;
        switch (w.eenheid) {
          case Eenheid.percentageTaxatie:
          case Eenheid.percentageWoningWaarde:
            value = woningWaarde / 100.0 * w.getal;
            break;
          case Eenheid.bedrag:
            value = w.getal;
            break;
          case Eenheid.percentageLening:
            value = lening / 100.0 * w.getal;
            break;
        }
        return previous + value;
      });

  double get verschil => woningWaarde - lening - totaleKosten;
}
