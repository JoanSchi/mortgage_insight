// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mortgage_insight/model/nl/hypotheek/gegevens/norm/norm.dart';

import '../gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import '../gegevens/status_lening/status_lening.dart';
import '../gegevens/verbouw_verduurzaam_kosten/verbouw_verduurzaam_kosten.dart';
import '../gegevens/woning_lening_kosten/woning_lening_kosten.dart';

class BerekenNormWoningWaarde {
  final HypotheekDossier hypotheekDossier;
  final List<StatusLening> statusParalleleLeningen;
  final WoningLeningKosten woningLeningKosten;
  final VerbouwVerduurzaamKosten verbouwVerduurzaamKosten;

  BerekenNormWoningWaarde({
    required this.hypotheekDossier,
    required this.statusParalleleLeningen,
    required this.woningLeningKosten,
    required this.verbouwVerduurzaamKosten,
  });

  NormWoningwaarde bereken() {
    return hypotheekDossier.woningWaardeNormToepassen
        ? _bereken()
        : const NormWoningwaarde(omschrijving: 'WoningWaarde');
  }

  NormWoningwaarde _bereken() {
    double lening =
        woningLeningKosten.woningWaarde < verbouwVerduurzaamKosten.taxatie
            ? verbouwVerduurzaamKosten.taxatie
            : woningLeningKosten.woningWaarde;

    double somVerduurzamen = statusParalleleLeningen.fold<double>(
        verbouwVerduurzaamKosten.verduurzaamKosten,
        (previousValue, element) => previousValue + element.verduurzaamKosten);

    double somParalleleLeningen = statusParalleleLeningen.fold<double>(
        0.0, (previousValue, element) => previousValue + element.lening);

    final ruimteVerduurzamen = lening * 0.06;

    final lenenVoorVerduurzamen = (somVerduurzamen > ruimteVerduurzamen)
        ? ruimteVerduurzamen
        : somVerduurzamen;

    final resterend = lening + lenenVoorVerduurzamen - somParalleleLeningen;

    return NormWoningwaarde(
        omschrijving: 'Woningwaarde',
        totaal: lening + lenenVoorVerduurzamen,
        resterend: resterend < 0.0 ? 0.0 : resterend,
        verduurzaam: lenenVoorVerduurzamen);
  }
}
