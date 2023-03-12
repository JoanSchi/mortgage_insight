import 'package:mortgage_insight/model/nl/hypotheek/financierings_norm/norm.dart';

import '../hypotheek.dart';

class BerekenNormNhg {
  DefaultNorm norm;
  RemoveHypotheek hypotheek;
  RemoveHypotheekProfiel profiel;
  List<RemoveHypotheek> parallelHypotheken;

  BerekenNormNhg({
    required this.hypotheek,
    required this.profiel,
    required this.parallelHypotheken,
  }) : norm = hypotheek.maxLeningNHG {
    if (norm.toepassen && !hypotheek.afgesloten) {
      bereken();
    } else {
      norm.wissen();
    }
  }

  bereken() {
    const maxNHG = 355000.0;

    double lening = hypotheek.woningLeningKosten.woningWaarde;
    double lenenVoorVerduurzamen = 0.0;

    if (lening > maxNHG) {
      hypotheek.maxLeningNHG.fouten
        ..clear()
        ..add('NHG: Maximaal $maxNHG + 6% verduurzamen');
      return;
    }

    final vvk = hypotheek.verbouwVerduurzaamKosten;

    if (vvk.toepassen) {
      double leningTaxatie = (vvk.taxatie > lening) ? vvk.taxatie : lening;

      final totaalBenodigd = lening +
          hypotheek.parallelLeningen.somKosten +
          hypotheek.verbouwVerduurzaamKosten.totaleKosten;

      final totaleVerduurzaamKosten =
          hypotheek.parallelLeningen.somVerduurzaamKosten +
              hypotheek.verbouwVerduurzaamKosten.totaleVerduurzaamKosten;

      if (leningTaxatie >= maxNHG) {
        leningTaxatie = maxNHG;
      } else if (totaalBenodigd <= leningTaxatie) {
        lening = totaalBenodigd;
      } else {
        final ruimteVerduurzamen = leningTaxatie * 0.06;

        lenenVoorVerduurzamen = (totaleVerduurzaamKosten > ruimteVerduurzamen)
            ? ruimteVerduurzamen
            : totaleVerduurzaamKosten;

        if (leningTaxatie + lenenVoorVerduurzamen < maxNHG) {
          lening = leningTaxatie + lenenVoorVerduurzamen;
          lenenVoorVerduurzamen = lenenVoorVerduurzamen;
        } else {
          lening = maxNHG;
          lenenVoorVerduurzamen = maxNHG - leningTaxatie;
        }
      }
    }

    final resterend = lening - hypotheek.parallelLeningen.somLeningen;

    hypotheek.maxLeningNHG
      ..totaal = lening
      ..resterend = resterend < 0.0 ? 0.0 : resterend
      ..verduurzaamKosten = lenenVoorVerduurzamen
      ..fouten.clear();
  }
}
