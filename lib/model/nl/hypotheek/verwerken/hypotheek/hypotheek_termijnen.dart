// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math' as math;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mortgage_insight/model/nl/hypotheek/gegevens/lening_aanpassen/lening_aanpassen.dart';

import '../../../../../utilities/kalender.dart';
import '../../gegevens/hypotheek/hypotheek.dart';
import '../../gegevens/termijn/termijn.dart';

class HypotheekTermijnen {
  final double hoofdsom;
  final double rente;
  final DateTime startDatum;
  final DateTime datumLening;
  final HypotheekVorm hypotheekVorm;
  final int aflosTermijnInMaanden;
  final int periodeInMaanden;
  final bool geheleMaand;
  final bool aflossenGebrokenMaand;
  double aflossenTotaal = 0.0;
  double renteTotaal = 0.0;
  double periodeAflossen = 0.0;
  double periodeRenteBedrag = 0.0;
  double periodeExtraAflossen = 0.0;
  DateTime beginPeriodeTelling;
  double lening;
  List<Termijn> termijnen = [];
  IteratieLeningAanpassen leningAanpassen;

  HypotheekTermijnen({
    required this.hoofdsom,
    required this.rente,
    required this.startDatum,
    required this.datumLening,
    required this.hypotheekVorm,
    required this.aflosTermijnInMaanden,
    required this.periodeInMaanden,
    required this.geheleMaand,
    required this.aflossenGebrokenMaand,
    required this.aflossenTotaal,
    required this.renteTotaal,
  })  : beginPeriodeTelling = startDatum,
        lening = hoofdsom,
        leningAanpassen = IteratieLeningAanpassen(
            leningAanpasItems: IList<LeningAanpassen>([]),
            startDatum: startDatum,
            boeteVrijAflosen: 188000);

  ttt() {
    switch (hypotheekVorm) {
      case HypotheekVorm.aflosvrij:
        if (startDatum.compareTo(datumLening) < 0) {}
        break;
      case HypotheekVorm.linear:
        // TODO: Handle this case.
        break;
      case HypotheekVorm.annuity:
        // TODO: Handle this case.
        break;
    }
  }

  toTTT() {
    DateTime startPeriode = startDatum;
    DateTime eindPeriode = startDatum;

    int periode = 0;
    double periodeRatio = 0.0;

    DateTime eindDatum =
        Kalender.voegPeriodeToe(startDatum, maanden: periodeInMaanden);

    if (geheleMaand && beginPeriodeTelling.day > 1) {
      startPeriode = Kalender.voegPeriodeToe(startPeriode,
          periodeOpties: PeriodeOpties.eersteDag);
      eindPeriode = Kalender.voegPeriodeToe(eindPeriode,
          periodeOpties: PeriodeOpties.laatsteDag);

      beginPeriodeTelling = startPeriode;

      periodeRatio = startDatum.day /
          DateUtils.getDaysInMonth(startDatum.year, startDatum.month);

      if (datumLening.compareTo(beginPeriodeTelling) <= 0) {
        //t
      } else {
        toevoegen(startPeriode, eindPeriode, startDatum, eindPeriode, -1, 0,
            periodeRatio);
      }
      periode++;
    } else {
      beginPeriodeTelling = startDatum;
    }

    int delta = DateUtils.monthDelta(beginPeriodeTelling, datumLening) -
        (datumLening.day);

    startPeriode = Kalender.voegPeriodeToe(beginPeriodeTelling,
        maanden: periode, periodeOpties: PeriodeOpties.volgende);

    eindPeriode =
        Kalender.voegPeriodeToe(beginPeriodeTelling, maanden: periode + 1, periodeOpties: PeriodeOpties.eind);

    while (startPeriode.compareTo(eindDatum) <= 0) {
      toevoegen(
          startPeriode,
          eindPeriode,
          startPeriode,
          eindDatum.compareTo(eindPeriode) < 0 ? eindDatum : eindPeriode,
          periode - 1,
          periode,
          periodeRatio);
    }
  }

  void toevoegen(
      DateTime startPeriode,
      DateTime eindPeriode,
      DateTime startDatum,
      DateTime eindDatum,
      int vorigePeriode,
      int periode,
      double periodeRatio) {
    periodeAflossen = 0.0;
    periodeRenteBedrag = 0.0;

    leningAanpassen.aanpassen(
        startDatum: startDatum,
        eindDatum: eindPeriode,
        termijnToevoegen:
            (DateTime start, DateTime end, double aflossen, double verhogen) {
          termijnen.add(_annuiteitGebrokenTermijn(
              startPeriode: startPeriode,
              eindPeriode: eindPeriode,
              startDatum: start,
              eindDatum: end,
              vorigePeriode: vorigePeriode,
              periode: periode,
              periodeRatio: periodeRatio,
              extraAflossen: aflossen,
              verhogen: verhogen));
          if (lening < 0.01) {
            return true;
          }
          return false;
        });
  }

  Termijn _annuiteitGebrokenTermijn({
    required DateTime startPeriode,
    required DateTime eindPeriode,
    required DateTime startDatum,
    required DateTime eindDatum,
    required double extraAflossen,
    required double verhogen,
    required int vorigePeriode,
    required int periode,
    required double periodeRatio,
  }) {
    if (extraAflossen > 0.0) {
      if (lening - extraAflossen < 1.0) {
        extraAflossen = lening;
        lening = 0;
      } else {
        lening -= extraAflossen;
      }
    }

    if (verhogen > 0.0) {
      lening += verhogen;
    }

    final DateTime eindDatumVorige;
    final DateTime startDatumVolgende;

    if (periodeRatio != 0.0) {
      eindDatumVorige = startPeriode.add(Duration(
          days: (((Kalender.verschilDagen(startPeriode, eindDatum) + 1) *
                      periodeRatio) +
                  0.01)
              .floor()));

      startDatumVolgende = eindDatumVorige.add(const Duration(days: 1));
    } else {
      eindDatumVorige = startPeriode;
      startDatumVolgende = startPeriode;
    }

    void ratioAnnuiteit(int periode, DateTime start, DateTime eind) {
      final ratio = _ratio(startPeriode, eindPeriode, start, eind);
      final maandRente = rente / 12.0;
      final l = lening - periodeAflossen;

      if (l <= 0.0) return;

      final double maandRenteBedragRatio = l / 100.0 * maandRente * ratio;

      final annuity = l /
          100.0 *
          maandRente /
          (1.0 -
              (math.pow(1.0 + maandRente / 100.0,
                  -(aflosTermijnInMaanden - periode)))) *
          ratio;
      final aflossenRatio = annuity - maandRenteBedragRatio;

      periodeAflossen += aflossenRatio;
      periodeRenteBedrag = maandRenteBedragRatio;
    }

    if (vorigePeriode != -1 && startDatum.compareTo(eindDatumVorige) <= 0) {
      ratioAnnuiteit(vorigePeriode, startDatum, eindDatumVorige);
    }

    if (periode != -1 && startDatumVolgende.compareTo(eindDatum) <= 0) {
      ratioAnnuiteit(
        periode,
        startDatumVolgende,
        eindDatum,
      );
    }

    if (eindDatum.compareTo(eindPeriode) < 0 && lening > 0.0) {
      return Termijn(
          startPeriode: startPeriode,
          eindPeriode: eindPeriode,
          startDatum: startDatum,
          eindDatum: eindDatum,
          hypotheekVorm: hypotheekVorm,
          aflossen: 0.0,
          extraAflossen: extraAflossen,
          maandRenteBedragRatio: 0,
          periode: periode,
          lening: lening,
          rente: rente,
          volledigAfgelost: false,
          aflossenTotaal: aflossenTotaal,
          renteTotaal: renteTotaal);
    } else {
      if (lening - periodeAflossen < 0.0) {
        periodeAflossen = lening;
      }

      lening = lening - periodeAflossen;
      return Termijn(
          startPeriode: startPeriode,
          eindPeriode: eindPeriode,
          startDatum: startDatum,
          eindDatum: eindDatum,
          hypotheekVorm: hypotheekVorm,
          aflossen: periodeAflossen,
          extraAflossen: extraAflossen,
          maandRenteBedragRatio: periodeRenteBedrag,
          periode: periode,
          lening: lening,
          rente: rente,
          volledigAfgelost: false,
          aflossenTotaal: aflossenTotaal,
          renteTotaal: renteTotaal);
    }
  }

  Termijn _lineairGebrokenTermijn({
    required DateTime startPeriode,
    required DateTime eindPeriode,
    required DateTime startDatum,
    required DateTime eindDatum,
    required double extraAflossen,
    required double verhogen,
    required int periode,
    required double verlopen,
  }) {
    if (extraAflossen > 0.0) {
      if (lening - extraAflossen < 1.0) {
        extraAflossen = lening;
        lening = 0;
      } else {
        lening -= extraAflossen;
      }
    }

    if (verhogen > 0.0) {
      lening += verhogen;
    }

    final l = lening - periodeAflossen;

    if (l > 0.0) {
      final ratio = _ratio(startPeriode, eindPeriode, startDatum, eindDatum);
      final maandRente = rente / 12.0;
      final double maandRenteBedragRatio = l / 100.0 * maandRente * ratio;
      final aflossenRatio = l / (aflosTermijnInMaanden - verlopen) * ratio;

      periodeAflossen += aflossenRatio;
      periodeRenteBedrag = maandRenteBedragRatio;
    }

    if (eindDatum.compareTo(eindPeriode) < 0 && lening > 0.0) {
      return Termijn(
          startPeriode: startPeriode,
          eindPeriode: eindPeriode,
          startDatum: startDatum,
          eindDatum: eindDatum,
          hypotheekVorm: hypotheekVorm,
          aflossen: 0.0,
          extraAflossen: extraAflossen,
          maandRenteBedragRatio: 0,
          periode: periode,
          lening: lening,
          rente: rente,
          volledigAfgelost: false,
          aflossenTotaal: aflossenTotaal,
          renteTotaal: renteTotaal);
    } else {
      if (lening - periodeAflossen < 0.0) {
        periodeAflossen = lening;
      }

      lening = lening - periodeAflossen;
      return Termijn(
          startPeriode: startPeriode,
          eindPeriode: eindPeriode,
          startDatum: startDatum,
          eindDatum: eindDatum,
          hypotheekVorm: hypotheekVorm,
          aflossen: periodeAflossen,
          extraAflossen: extraAflossen,
          maandRenteBedragRatio: periodeRenteBedrag,
          periode: periode,
          lening: lening,
          rente: rente,
          volledigAfgelost: false,
          aflossenTotaal: aflossenTotaal,
          renteTotaal: renteTotaal);
    }
  }

  double _ratio(
    DateTime startPeriode,
    DateTime eindPeriode,
    DateTime begin,
    DateTime eind,
  ) {
    return (Kalender.verschilDagen(begin, eind) + 1) /
            Kalender.verschilDagen(startPeriode, eindPeriode) +
        1; //+1
  }

  // List<Termijn> termijnenAanmaken() {
  //   DateTime startPeriode = startDatum;
  //   DateTime optelDatum = startDatum;

  //   int periode = 0;
  //   IteratieLeningAanpassen leningAanpassen = IteratieLeningAanpassen(
  //       leningAanpasItems: IList<LeningAanpassen>([]),
  //       startDatum: startDatum,
  //       boeteVrijAflosen: 188000);

  //   List<Termijn> termijnen = [];

  //   if (true && startPeriode.day != 1) {
  //     optelDatum = startPeriode = Kalender.voegPeriodeToe(startDatum,
  //         periodeOpties: PeriodeOpties.eersteDag);
  //     DateTime eindPeriode = Kalender.voegPeriodeToe(startDatum,
  //         periodeOpties: PeriodeOpties.laatsteDag);

  //     /// StartDatum is startDatum om ratio uit te rekenen.
  //     ///
  //     ///
  //     ///

  //     leningAanpassen.aanpassen(
  //         startDatum: startDatum,
  //         eindDatum: eindPeriode,
  //         termijnToevoegen:
  //             (DateTime start, DateTime end, double aflossen, double verhogen) {
  //           Termijn termijn = _termijnBerekenen(
  //             startPeriode: startPeriode,
  //             eindPeriode: eindPeriode,
  //             extraAflossen: aflossen,
  //             verhogen: verhogen,
  //             periode: periode,
  //             startDatum: start,
  //             eindDatum: end,
  //           );

  //           if (termijn.volledigAfgelost) {
  //             return termijnen;
  //           }

  //           termijnen.add(termijn);

  //           if (hoofdsom < 0.1) {
  //             return termijnen;
  //           }
  //         });

  //     periode++;
  //     startPeriode = Kalender.voegPeriodeToe(optelDatum,
  //         maanden: periode, periodeOpties: PeriodeOpties.eersteDag);
  //   }

  //   int aflosTermijnenCorrectie = aflosTermijnInMaanden + periode;

  //   while (periode < aflosTermijnenCorrectie) {
  //     DateTime eindPeriode = Kalender.voegPeriodeToe(startPeriode,
  //         periodeOpties: PeriodeOpties.tot);

  //     leningAanpassen.aanpassen(
  //         startDatum: startPeriode,
  //         eindDatum: eindPeriode,
  //         termijnToevoegen:
  //             (DateTime start, DateTime end, double aflossen, double verhogen) {
  //           Termijn termijn = _termijnBerekenen(
  //               startPeriode: startPeriode,
  //               eindPeriode: eindPeriode,
  //               extraAflossen: aflossen,
  //               verhogen: verhogen,
  //               periode: periode,
  //               startDatum: start,
  //               eindDatum: end);

  //           if (termijn.volledigAfgelost) {
  //             return termijnen;
  //           }

  //           termijnen.add(termijn);

  //           if (hoofdsom < 0.1) {
  //             return termijnen;
  //           }
  //         });

  //     periode++;
  //     startPeriode = Kalender.voegPeriodeToe(optelDatum,
  //         maanden: periode, periodeOpties: PeriodeOpties.tm);
  //   }

  //   return termijnen;
  // }

  // Termijn _termijnBerekenen({
  //   required DateTime startPeriode,
  //   required DateTime eindPeriode,
  //   required DateTime startDatum,
  //   required DateTime eindDatum,
  //   required double extraAflossen,
  //   required double verhogen,
  //   required double periode,
  // }) {
  //   bool volledigAfgelost = false;

  //   if (extraAflossen > 0.0) {
  //     if (hoofdsom - extraAflossen < 1.0) {
  //       extraAflossen = hoofdsom;
  //       hoofdsom = 0;
  //       volledigAfgelost = true;
  //     } else {
  //       hoofdsom -= extraAflossen;
  //     }
  //   }

  //   int dagen = Kalender.verschilDagen(eindDatum, startDatum) + 1; //+1

  //   int dagenInPeriode =
  //       Kalender.verschilDagen(eindPeriode, startPeriode) + 1; //+1

  //   double ratio = dagen / dagenInPeriode;

  //   double maandRente = rente / 12.0;
  //   double aflossen = 0.0;

  //   final double maandRenteBedragRatio = hoofdsom / 100.0 * maandRente * ratio;

  //   switch (hypotheekVorm) {
  //     case HypotheekVorm.annuity:
  //       {
  //         double annuity = hoofdsom /
  //             100.0 *
  //             maandRente /
  //             (1.0 -
  //                 (math.pow(1.0 + maandRente / 100.0,
  //                     -(aflosTermijnInMaanden - periode)))) *
  //             ratio;
  //         aflossen = annuity - maandRenteBedragRatio;
  //         break;
  //       }
  //     case HypotheekVorm.linear:
  //       {
  //         aflossen = hoofdsom / (aflosTermijnInMaanden - periode) * ratio;
  //         break;
  //       }
  //     default:
  //       {
  //         aflossen = 0.0;
  //       }
  //   }

  //   hoofdsom -= aflossen;
  //   aflossenTotaal += aflossen + extraAflossen;
  //   renteTotaal += maandRenteBedragRatio;

  //   return Termijn(
  //       startPeriode: startPeriode,
  //       eindPeriode: eindPeriode,
  //       startDatum: startDatum,
  //       eindDatum: eindDatum,
  //       hypotheekVorm: hypotheekVorm,
  //       aflossen: aflossen,
  //       extraAflossen: extraAflossen,
  //       maandRenteBedragRatio: ratio,
  //       periode: periode,
  //       lening: hoofdsom,
  //       rente: rente,
  //       volledigAfgelost: volledigAfgelost,
  //       aflossenTotaal: aflossenTotaal,
  //       renteTotaal: renteTotaal);
  // }
}

class IteratieLeningAanpassen {
  final List<LeningAanpassenEntry> aanpassingsItems;
  int aflosJaar = 0;
  double jaarAfgelost = 0.0;
  double boeteVrijAflosen = 0.0;
  DateTime eersteAanpasDatum = DateTime(4000);

  IteratieLeningAanpassen({
    required IList<LeningAanpassen> leningAanpasItems,
    required DateTime startDatum,
    required this.boeteVrijAflosen,
  }) : aanpassingsItems =
            generateEntry(leningAanpasItems, startDatum).toList() {
    for (LeningAanpassenEntry a in aanpassingsItems) {
      if (eersteAanpasDatum.compareTo(a.datum) > 0) {
        eersteAanpasDatum = a.datum;
      }
    }
  }

  static Iterable<LeningAanpassenEntry> generateEntry(
      IList<LeningAanpassen> leningAanpasItems, DateTime startDatum) sync* {
    for (LeningAanpassen a in leningAanpasItems) {
      final entry = a.map(
          termijnen: (termijnen) => LeningAanpassenInTermijnenEntry(
              leningAanpassen: termijnen, startDatum: startDatum),
          eenmalig: (eenmalig) => LeningAanpassEenmaligEntry(
              leningAanpassen: eenmalig, startDatum: startDatum));

      if (!entry.eind) {
        yield entry;
      }
    }
  }

  void aanpassen(
      {required DateTime startDatum,
      required DateTime eindDatum,
      required bool Function(
              DateTime start, DateTime end, double aflossen, double verhogen)
          termijnToevoegen}) {
    if (eersteAanpasDatum.compareTo(eindDatum) <= 0 ||
        aanpassingsItems.isEmpty) {
      termijnToevoegen(startDatum, eindDatum, 0.0, 0.0);
    }

    double vorigeAflossing = 0.0;
    double vorigeVerhoging = 0.0;
    bool opschonen = false;
    bool volgendeAanpassing = true;

    while (volgendeAanpassing && eersteAanpasDatum.compareTo(eindDatum) <= 0) {
      DateTime eersteVolgendeAanpasDatum = DateTime(4000);
      double aflossen = 0.0;
      double verhogen = 0.0;
      volgendeAanpassing = false;

      for (LeningAanpassenEntry a in aanpassingsItems) {
        if (a.datum == eersteAanpasDatum &&
            a.aanpasBedrag(
                startDatum,
                eindDatum,
                (double bedrag) => aflossen = bedrag,
                (double bedrag) => verhogen = bedrag)) {
          volgendeAanpassing = true;
        }

        if (a.eind) {
          opschonen = true;
        } else if (eersteVolgendeAanpasDatum.compareTo(a.datum) > 0) {
          eersteVolgendeAanpasDatum = a.datum;
        }
      }

      /// Boetevrijaflossen
      ///
      ///
      ///
      ///

      if (aflossen > 0.0) {
        if (aflosJaar != eersteAanpasDatum.year) {
          aflosJaar = eersteAanpasDatum.year;
          jaarAfgelost = 0.0;
        }

        if (jaarAfgelost + aflossen < boeteVrijAflosen) {
          jaarAfgelost += aflossen;
        } else {
          aflossen = boeteVrijAflosen - jaarAfgelost;
          jaarAfgelost = boeteVrijAflosen;
        }
      }

      /// Aanpassen
      ///
      /// De vorige aanpassing wordt toegepast
      ///
      ///

      if (aflossen != 0.0 || verhogen != 0.0) {
        if (startDatum.compareTo(eersteAanpasDatum) == 0) {
          vorigeAflossing = aflossen;
          vorigeVerhoging = verhogen;
        } else {
          termijnToevoegen(
              startDatum,
              DateUtils.addDaysToDate(eersteAanpasDatum, -1),
              vorigeAflossing,
              vorigeVerhoging);
          vorigeAflossing = aflossen;
          startDatum = eersteAanpasDatum;
        }
      }
      eersteAanpasDatum = eersteVolgendeAanpasDatum;
    }
    termijnToevoegen(startDatum, eindDatum, vorigeAflossing, vorigeVerhoging);

    if (opschonen) {
      aanpassingsItems.removeWhere((element) => element.eind);
    }
  }
}

abstract class LeningAanpassenEntry {
  bool get eind;
  DateTime get datum;
  bool aanpasBedrag(DateTime startDatum, DateTime eindDatum,
      Function(double bedrag) aflossen, Function(double bedrag) verhogen);
}

class LeningAanpassenInTermijnenEntry extends LeningAanpassenEntry {
  final LenningAanpassenInTermijnen leningAanpassen;
  int index = 0;

  @override
  DateTime datum;
  @override
  bool eind = false;

  LeningAanpassenInTermijnenEntry(
      {required this.leningAanpassen, required DateTime startDatum})
      : datum = leningAanpassen.datum {
    _naEerstVolgendeDatum(startDatum);
  }

  _naEerstVolgendeDatum(DateTime startDatum) {
    while (index < leningAanpassen.periodeInMaanden) {
      if (startDatum.compareTo(datum) < 0) {
        return;
      }
      datum = Kalender.voegPeriodeToe(leningAanpassen.datum,
          maanden: index * leningAanpassen.periodeInMaanden, periodeOpties: PeriodeOpties.volgende);

      index++;
    }
    eind = index == leningAanpassen.periodeInMaanden;
  }

  @override
  bool aanpasBedrag(DateTime startDatum, DateTime eindDatum,
      Function(double bedrag) aflossen, Function(double bedrag) verhogen) {
    if (eind) {
      return false;
    }

    if (datum.compareTo(startDatum) >= 0 && datum.compareTo(eindDatum) <= 0) {
      /// Datum ligt tussen periode
      /// Bepaal alvast volgende datum of het einde
      ///
      index++;

      if (index < leningAanpassen.periodeInMaanden) {
        datum = Kalender.voegPeriodeToe(leningAanpassen.datum,
            maanden: index * leningAanpassen.periodeInMaanden, periodeOpties: PeriodeOpties.volgende);
      } else {
        eind = true;
      }

      if (leningAanpassen.leningAanpassenOpties ==
          LeningAanpassenOpties.aflossen) {
        aflossen(leningAanpassen.bedrag);
      } else {
        verhogen(leningAanpassen.bedrag);
      }

      return true;
    }

    return false;
  }
}

class LeningAanpassEenmaligEntry extends LeningAanpassenEntry {
  final LenningAanpassenEenmalig leningAanpassen;

  @override
  DateTime datum;
  @override
  bool eind = false;

  LeningAanpassEenmaligEntry(
      {required this.leningAanpassen, required DateTime startDatum})
      : datum = leningAanpassen.datum {
    if (datum.compareTo(startDatum) < 0) {
      eind = true;
    }
  }

  @override
  bool aanpasBedrag(DateTime startDatum, DateTime eindDatum,
      Function(double bedrag) aflossen, Function(double bedrag) verhogen) {
    if (eind) {
      return false;
    }

    if (datum.compareTo(startDatum) >= 0 && datum.compareTo(eindDatum) <= 0) {
      eind = true;
      if (leningAanpassen.leningAanpassenOpties ==
          LeningAanpassenOpties.aflossen) {
        aflossen(leningAanpassen.bedrag);
      } else {
        verhogen(leningAanpassen.bedrag);
      }

      return true;
    }

    return false;
  }
}
