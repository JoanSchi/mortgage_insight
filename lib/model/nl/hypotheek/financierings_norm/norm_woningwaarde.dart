import 'package:mortgage_insight/model/nl/hypotheek/financierings_norm/norm.dart';
import '../hypotheek.dart';

class BerekenNormWoningWaarde {
  Hypotheek hypotheek;
  HypotheekProfiel profiel;
  List<Hypotheek> parallelHypotheken;
  DefaultNorm norm;

  BerekenNormWoningWaarde({
    required this.hypotheek,
    required this.profiel,
    required this.parallelHypotheken,
  }) : norm = hypotheek.maxLeningWoningWaarde {
    norm.toepassen = profiel.woningWaardeNormToepassen;

    if (norm.toepassen && !hypotheek.afgesloten) {
      bereken();
    } else {
      norm.wissen();
    }
  }

  bereken() {
    final wk = hypotheek.woningLeningKosten;
    final vvk = hypotheek.verbouwVerduurzaamKosten;
    double lening =
        wk.woningWaarde < vvk.taxatie ? vvk.taxatie : wk.woningWaarde;

    double totaleVerduurzaamKosten =
        hypotheek.parallelLeningen.somVerduurzaamKosten +
            hypotheek.verbouwVerduurzaamKosten.totaleVerduurzaamKosten;

    final ruimteVerduurzamen = lening * 0.06;

    final lenenVoorVerduurzamen = (totaleVerduurzaamKosten > ruimteVerduurzamen)
        ? ruimteVerduurzamen
        : totaleVerduurzaamKosten;

    final resterend = lening +
        totaleVerduurzaamKosten -
        hypotheek.parallelLeningen.somLeningen;

    hypotheek.maxLeningWoningWaarde
      ..totaal = lening + lenenVoorVerduurzamen
      ..resterend = resterend < 0.0 ? 0.0 : resterend
      ..verduurzaamKosten = lenenVoorVerduurzamen
      ..fouten.clear();
  }
}
