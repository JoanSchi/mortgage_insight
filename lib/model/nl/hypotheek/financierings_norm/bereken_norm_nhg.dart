import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mortgage_insight/model/nl/hypotheek/gegevens/norm/norm.dart';

import '../gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import '../gegevens/status_lening/status_lening.dart';
import '../gegevens/verbouw_verduurzaam_kosten/verbouw_verduurzaam_kosten.dart';
import '../gegevens/woning_lening_kosten/woning_lening_kosten.dart';

class BerekenNormNhg {
  final HypotheekDossier hypotheekDossier;
  final List<StatusLening> statusParalleleLeningen;
  final WoningLeningKosten woningLeningKosten;
  final VerbouwVerduurzaamKosten verbouwVerduurzaamKosten;

  BerekenNormNhg({
    required this.hypotheekDossier,
    required this.statusParalleleLeningen,
    required this.woningLeningKosten,
    required this.verbouwVerduurzaamKosten,
  });

  NormNhg bereken() {
    const maxNHG = 405000.0;

    double lening = woningLeningKosten.woningWaarde;
    double lenenVoorVerduurzamen = 0.0;

    if (lening > maxNHG) {
      return NormNhg(
          omschrijving: 'NHG',
          bericht: ['NHG: Maximaal $maxNHG + 6% verduurzamen'].lock);
    }

    if (verbouwVerduurzaamKosten.toepassen) {
      double somVerduurzamen = statusParalleleLeningen.fold<double>(
          verbouwVerduurzaamKosten.verduurzaamKosten,
          (previousValue, element) =>
              previousValue + element.verduurzaamKosten);

      lening = (verbouwVerduurzaamKosten.taxatie > lening)
          ? verbouwVerduurzaamKosten.taxatie
          : lening;

      if (lening >= maxNHG) {
        lening = maxNHG;
      }

      lenenVoorVerduurzamen =
          somVerduurzamen > lening * 0.06 ? lening * 0.06 : somVerduurzamen;

      lening += lenenVoorVerduurzamen;
    }

    double somParalleleLeningen = statusParalleleLeningen.fold<double>(
        0.0, (previousValue, element) => previousValue + element.lening);

    final resterend = lening - somParalleleLeningen;

    return NormNhg(
        omschrijving: 'NHG',
        toepassen: true,
        totaal: lening,
        resterend: resterend,
        verduurzaam: lenenVoorVerduurzamen);
  }
}
