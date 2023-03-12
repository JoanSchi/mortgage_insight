import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../../../utilities/kalender.dart';
import '../gegevens/combi_rest_schuld/combi_rest_schuld.dart';
import '../gegevens/hypotheek/hypotheek.dart';
import '../gegevens/hypotheek_profiel/hypotheek_profiel.dart';

class HypotheekVerwerken {
  static List<Hypotheek> teVerlengenHypotheek(
      HypotheekProfiel hp, Hypotheek hypotheek) {
    List<Hypotheek> verlengen = [];

    zoek(String id) {
      if (id == hypotheek.id) return;

      final h = hp.hypotheken[id];

      assert(h != null,
          'By initialiseren te verlengen hypotheken moet zoeken op id niet null opleveren!');

      if (h == null) return;

      if (h.volgende.isEmpty || h.volgende == hypotheek.id) {
        if (h.restSchuld > 1.0) {
          verlengen.add(h);
        }
        return;
      }

      zoek(h.volgende);
    }

    for (Hypotheek h in hp.eersteHypotheken) {
      zoek(h.id);
    }
    return verlengen;
  }

  static Map<DateTime, CombiRestSchuld> restSchuldInventarisatie(
      HypotheekProfiel hp, Hypotheek hypotheek) {
    Map<DateTime, CombiRestSchuld> restSchulden = {};

    for (var h in hp.hypotheken.values) {
      if (h != hypotheek && h.restSchuld > 0.0) {
        CombiRestSchuld? r = restSchulden[h.eindDatum];

        if (r != null) {
          restSchulden[h.eindDatum] = r.toevoegen(hypotheek);
        } else {
          restSchulden[h.eindDatum] = CombiRestSchuld(
              datum: hypotheek.eindDatum,
              restSchuld: hypotheek.restSchuld,
              idLijst: [hypotheek.id].lock);
        }
      }
    }

    for (var h in hp.hypotheken.values) {
      if (h != hypotheek) {
        restSchulden[h.startDatum]?.verwijderen(hypotheek);
      }
    }

    return restSchulden..removeWhere((key, value) => value.restSchuld < 0.01);
  }

  static DateTime eersteKalenderDatum(
      HypotheekProfiel hp, Hypotheek hypotheek) {
    return Kalender.voegPeriodeToe(DateTime.now(),
        jaren: -maxTermijnenInJaren(hp, hypotheek));
  }

  static DateTime laatsteKalenderDatum(
      HypotheekProfiel hp, Hypotheek hypotheek) {
    int jaar = hypotheek.startDatum.year;
    int maand = hypotheek.startDatum.month;
    int maxJaren = maxTermijnenInJaren(hp, hypotheek);

    return DateTime(jaar + maxJaren, maand,
        Kalender.dagenPerMaand(jaar: jaar + maxJaren, maand: maand));
  }

  static int maxTermijnenInJaren(HypotheekProfiel hp, Hypotheek hypotheek) =>
      hp.starter ? 40 : 30;
}
