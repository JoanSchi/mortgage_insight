import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/hypotheek/gegevens/woning_lening_kosten/woning_lening_kosten.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek_iterator.dart';
import '../../../../../utilities/kalender.dart';
import '../../../inkomen/inkomen.dart';
import '../../financierings_norm/bereken_norm_inkomen.dart';
import '../../financierings_norm/financierings_last_tabel.dart';
import '../../financierings_norm/bereken_norm_woningwaarde.dart';
import '../../gegevens/combi_rest_schuld/combi_rest_schuld.dart';
import '../../gegevens/hypotheek/hypotheek.dart';
import '../../gegevens/hypotheek_dossier/hypotheek_dossier.dart';

import '../../gegevens/norm/norm.dart';
import '../../gegevens/norm/norm_inkomen/inkomens_op_datum.dart';
import '../../gegevens/status_lening/status_lening.dart';
import '../../gegevens/termijn/termijn.dart';
import '../../gegevens/verbouw_verduurzaam_kosten/verbouw_verduurzaam_kosten.dart';
import 'dart:math' as math;

class HypotheekVerwerken {
  
  static DateTime get hypotheekDatumSuggestie => DateUtils.dateOnly(
        Kalender.voegPeriodeToe(DateTime.now(),
            maanden: 3, periodeOpties: PeriodeOpties.eersteDag),
      );

  static List<Hypotheek> teVerlengenHypotheek(
      HypotheekDossier hd, Hypotheek? hypotheek) {
    final String hypotheekId = hypotheek?.id ?? '';
    List<Hypotheek> verlengen = [];

    zoek(String id) {
      if (id == hypotheekId) return;

      final h = hd.hypotheken[id];

      assert(h != null,
          'By initialiseren te verlengen hypotheken moet zoeken op id niet null opleveren!');

      if (h == null) return;

      if (h.volgende.isEmpty || h.volgende == hypotheekId) {
        if (h.restSchuld > 1.0) {
          verlengen.add(h);
        }
        return;
      }

      zoek(h.volgende);
    }

    for (Hypotheek h in hd.eersteHypotheken) {
      zoek(h.id);
    }
    return verlengen;
  }

  static Map<DateTime, CombiRestSchuld> restSchuldInventarisatie(
      HypotheekDossier hd, Hypotheek? hypotheek) {
    Map<DateTime, CombiRestSchuld> restSchulden = {};

    for (var h in hd.hypotheken.values) {
      if (h != hypotheek && h.restSchuld > 0.0) {
        CombiRestSchuld? r = restSchulden[h.eindDatum];

        if (r != null) {
          restSchulden[h.eindDatum] = r.toevoegen(h);
        } else {
          restSchulden[h.eindDatum] = CombiRestSchuld(
              datum: h.eindDatum,
              restSchuld: h.restSchuld,
              idLijst: [h.id].lock);
        }
      }
    }

    return restSchulden..removeWhere((key, value) => value.restSchuld < 0.01);
  }

  static DateTime eersteKalenderDatum(
      HypotheekDossier hd, Hypotheek hypotheek) {
    return Kalender.voegPeriodeToe(DateTime.now(),
        jaren: -maxTermijnenInJaren(hd, hypotheek),periodeOpties: PeriodeOpties.volgende);
  }

  static DateTime laatsteKalenderDatum(
      HypotheekDossier hp, Hypotheek hypotheek) {
    int jaar = hypotheek.startDatum.year;
    int maand = hypotheek.startDatum.month;
    int maxJaren = maxTermijnenInJaren(hp, hypotheek);

    return DateTime(jaar + maxJaren, maand,
        Kalender.dagenPerMaand(jaar: jaar + maxJaren, maand: maand));
  }

  static int maxTermijnenInJaren(HypotheekDossier hd, Hypotheek hypotheek) =>
      hd.starter ? 40 : 30;

  static statusParralleleLeningen(
      DateTime startDatum, List<Hypotheek> parallelHypotheken) {
    List<StatusLening> list = [];

    for (Hypotheek h in parallelHypotheken) {
      Termijn? termijn;

      for (Termijn t in h.termijnen) {
        if (t.startDatum.compareTo(startDatum) <= 0) {
          termijn = t;
        } else {
          break;
        }
      }

      if (termijn != null) {
        double verduurzamenKosten;
        double verbouwKosten;

        if (startDatum.compareTo(h.startDatum) == 0) {
          verbouwKosten = h.verbouwVerduurzaamKosten.totaleKosten;
          verduurzamenKosten = h.verbouwVerduurzaamKosten.verduurzaamKosten;
        } else {
          verduurzamenKosten = 0.0;
          verbouwKosten = 0.0;
        }

        final statusLening = StatusLening(
          id: h.id,
          hypotheekVorm: h.hypotheekvorm,
          lening: termijn.lening,
          periode: termijn.periode,
          rente: h.rente,
          toetsRente: FinancieringsLast.toetsRente(
              periodesMnd: h.periodeInMaanden - termijn.periode,
              rente: h.rente),
          aflosTermijnInMaanden: h.aflosTermijnInMaanden,
          verduurzaamKosten: verduurzamenKosten,
          verbouwKosten: verbouwKosten,
        );

        list.add(statusLening);
      }
    }
    return list;
  }
}
