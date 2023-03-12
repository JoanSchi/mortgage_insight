import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../extra_of_kosten_lening/extra_of_kosten_lening.dart';

part 'verbouw_verduurzaam_kosten.freezed.dart';
part 'verbouw_verduurzaam_kosten.g.dart';

@freezed
class VerbouwVerduurzaamKosten with _$VerbouwVerduurzaamKosten {
  const VerbouwVerduurzaamKosten._();

  const factory VerbouwVerduurzaamKosten({
    @Default(IListConst([])) IList<Waarde> kosten,
    @Default('') String energieClassificering,
    @Default(false) bool toepassen,
    @Default(0.0) double taxatie,
  }) = _VerbouwVerduurzaamKosten;

  factory VerbouwVerduurzaamKosten.fromJson(Map<String, Object?> json) =>
      _$VerbouwVerduurzaamKostenFromJson(json);

  double get totaleKosten => kosten.fold(0.0, (double previous, Waarde w) {
        double value;
        switch (w.eenheid) {
          case Eenheid.percentageWoningWaarde:
            value = taxatie / 100.0 * w.getal;
            break;
          case Eenheid.bedrag:
            value = w.getal;
            break;
          case Eenheid.percentageLening:
            assert(false,
                'Eenheid.percentageLening niet geimplementeerd in VerbouwVerduurzaamKosten');
            value = 0.0; //lening / 100.0 * w.value;
            break;
        }
        return previous + value;
      });
}
