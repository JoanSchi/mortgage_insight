import 'package:flutter/widgets.dart';
import 'package:mortgage_insight/model/nl/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import '../../inkomen/inkomen.dart';
import '../gegevens/hypotheek/hypotheek.dart';
import '../gegevens/norm/norm.dart';
import '../gegevens/norm/norm_inkomen/inkomens_op_datum.dart';
import '../gegevens/status_lening/status_lening.dart';
import 'financierings_last_tabel.dart';
import 'dart:math' as math;

class BerekenNormInkomen {
  // NormInkomen gegevens;
  DateTime startDatum;
  InkomensOpDatum inkomensOpDatum;
  FinancieringsLast financieringsLast;
  HypotheekDossier hypotheekDossier;
  double initieleLening = 0.0;
  double lening = 0.0;
  double somParalleleLeningen;
  double erw = 0.0;
  double schuldenMnd = 0.0;
  List<StatusLening> statusParalleleLeningen;
  HypotheekVorm hypotheekVorm;
  int aflosTermijnInMaanden;

  BerekenNormInkomen(
      {required this.startDatum,
      required this.hypotheekDossier,
      required this.inkomensOpDatum,
      required this.statusParalleleLeningen,
      required this.hypotheekVorm,
      required this.aflosTermijnInMaanden,
      required this.erw})
      : financieringsLast = FinancieringsLast(
            startDatum: startDatum,
            inkomen: inkomensOpDatum,
            alleenstaande: false),
        somParalleleLeningen = statusParalleleLeningen.fold<double>(
            0.0, (previousValue, element) => previousValue + element.lening);

  NormInkomen bereken() {
    if (hypotheekDossier.inkomensNormToepassen) {
      _iteratieMaxLeningInkomen();
      return NormInkomen(
          omschrijving: 'Inkomen',
          periode: 0,
          toepassen: true,
          totaal: lening,
          resterend: lening - somParalleleLeningen);
    } else {
      return const NormInkomen(
          omschrijving: 'Inkomen', periode: 0, toepassen: false);
    }
  }

  void _iteratieMaxLeningInkomen() {
    int i = 0;
    double laagsteLening = 0.0;
    double hoogsteLening = 300000;
    double lening = hoogsteLening;

    double last = _berekenAfwijkingLast();

    while (last < 0.0 && i <= 75) {
      laagsteLening = lening;
      hoogsteLening = lening = lening * 1.5;
      last = _berekenAfwijkingLast();
      i++;
    }

    while (i <= 75) {
      lening = (laagsteLening + hoogsteLening) / 2.0;

      last = _berekenAfwijkingLast();

      if (last < -0.01 && (lening - laagsteLening) > 0.5) {
        laagsteLening = lening;
      } else if (last > 0.01 && (hoogsteLening - lening) > 0.5) {
        hoogsteLening = lening;
      } else {
        break;
      }
      i++;
    }

    if (i > 75) {
      // gegevens.fout = 'Optimale lening niet gevonden, iteraties > 75';
    }

    // debugPrint('Iterations: $i ${gegevens.optimalisatieLast.lening}');

    // berekenInitieleLening();
  }

  double _berekenAfwijkingLast() {
    //Last berekenen
    final somLeningen =
        SomLeningen(aftrekbaar: lening + somParalleleLeningen - erw);

    for (var statusLening in statusParalleleLeningen) {
      berekenIndividueleLast(
          hypotheekVorm: statusLening.hypotheekVorm,
          lening: statusLening.lening,
          periode: statusLening.periode,
          toetsRente: statusLening.toetsRente,
          aflosTermijnInMaanden: statusLening.aflosTermijnInMaanden,
          somLeningen: somLeningen);
    }

    berekenIndividueleLast(
        hypotheekVorm: hypotheekVorm,
        lening: lening,
        aflosTermijnInMaanden: aflosTermijnInMaanden,
        periode: 0,
        toetsRente: 5,
        somLeningen: somLeningen);

    //Afwijking berekenen

    final List<InkomenPot> inkomenPotten = inkomensOpDatum
        .toIterable()
        .map((Inkomen e) => InkomenPot(
            inkomen: e.indexatieTotaalBrutoJaar(startDatum),
            pensioen: e.pensioen))
        .toList();

    double lastenBox1 = somLeningen.somLastBox1;

    late List<LastenVerrekenPot> verrekenPotten;

    bool box1 = false;

    if (lastenBox1 > 0.0) {
      box1 = true;
      verrekenPotten = inkomenPotten.map((InkomenPot e) {
        FinancieringsLastTabel tabel =
            financieringsLast.finanancieringsLastPercentage(
          aow: e.pensioen,
          box3: false,
          toetsRente: somLeningen.rente,
        );

        return LastenVerrekenPot(percentage: tabel.percentageLast, pot: e);
      }).toList();

      for (LastenVerrekenPot p in verrekenPotten) {
        final f = p.aftrekken(lastenBox1);
        lastenBox1 -= f;
        if (lastenBox1 <= 0.0) break;
      }
    }

    // ToDo Schulden tovoegen;
    double lastenBox3 = somLeningen.somLastBox3;

    if (lastenBox3 > 0.0 || !box1) {
      verrekenPotten = inkomenPotten.map((InkomenPot e) {
        FinancieringsLastTabel tabel =
            financieringsLast.finanancieringsLastPercentage(
          aow: e.pensioen,
          box3: true,
          toetsRente: somLeningen.rente,
        );

        return LastenVerrekenPot(percentage: tabel.percentageLast, pot: e);
      }).toList();

      for (LastenVerrekenPot p in verrekenPotten) {
        final f = p.aftrekken(lastenBox3);
        lastenBox3 -= f;
        if (lastenBox3 <= 0.0) break;
      }
    }

    double lastenTeBesteden = 0.0;

    for (LastenVerrekenPot p in verrekenPotten) {
      lastenTeBesteden -= p.opmaken();
    }

    debugPrint(
        'lastenBox1: $lastenBox1 lastenBox3: $lastenBox3 lastenTeBesteden: $lastenTeBesteden');

    return lastenBox1 + lastenBox3 + lastenTeBesteden;
  }

  // void berekenInitieleLening() {
  //   const statusLening = StatusLening(
  //       id: 'id',
  //       lening: 5555,
  //       periode: 0,
  //       rente: 5.0,
  //       toetsRente: 5.0,
  //       aflosTermijnInMaanden: 12,
  //       hypotheekVorm: HypotheekVorm.annuity);

  //   double initieleLening;

  //   if (statusLening.periode == 0) {
  //     initieleLening = statusLening.lening;
  //   } else {
  //     switch (statusLening.hypotheekVorm) {
  //       case HypotheekVorm.aflosvrij:
  //         initieleLening = statusLening.lening;
  //         break;
  //       case HypotheekVorm.linear:
  //         initieleLening = statusLening.lening *
  //             (statusLening.aflosTermijnInMaanden) /
  //             (statusLening.aflosTermijnInMaanden - statusLening.periode);
  //         break;
  //       case HypotheekVorm.annuity:
  //         double r = statusLening.rente / 100.0 / 12.0;
  //         initieleLening = statusLening.lening *
  //             (1.0 - math.pow(1.0 + r, -statusLening.aflosTermijnInMaanden)) /
  //             (1.0 -
  //                 math.pow(
  //                     1.0 + r,
  //                     -(statusLening.aflosTermijnInMaanden -
  //                         statusLening.periode)));
  //         break;
  //     }
  //   }
  //   if (initieleLening.isInfinite) {
  //     gegevens.fout = 'Terugbereken niet gelukt';
  //   } else {
  //     ol.initieleLening = initieleLening.roundToDouble();
  //   }
  // }

  // berekenVerduurzamen() {
  //   final vvk = hypotheek.verbouwVerduurzaamKosten;
  //   final ol = gegevens.optimalisatieLast;
  //   if (vvk.toepassen) {
  //     ol.verduurzaamLening = financieringsLast.verduurzamen(
  //         verduurzaamKosten: gegevens.parallelLeningen.somVerduurzaamKosten +
  //             hypotheek.verbouwVerduurzaamKosten.totaleVerduurzaamKosten,
  //         energieClassificering: vvk.energieClassificering);
  //   }
  // }
}

berekenIndividueleLast(
    {required double lening,
    required double toetsRente,
    required int aflosTermijnInMaanden,
    required int periode,
    required HypotheekVorm hypotheekVorm,
    required SomLeningen somLeningen}) {
  final annuiteitMnd = berekenAnnuiteit(
      lening: lening,
      toetsRente: toetsRente,
      aflosTermijnInMaanden: aflosTermijnInMaanden,
      periode: periode);

  double annuiteitMndBox1 = 0.0;
  double annuiteitMndBox3 = 0.0;

  if (somLeningen.aftrekbaar > 0.0 &&
      hypotheekVorm != HypotheekVorm.aflosvrij) {
    if (lening < somLeningen.aftrekbaar) {
      annuiteitMndBox1 = annuiteitMnd;
      somLeningen.aftrekbaar -= lening;
    } else {
      annuiteitMndBox1 = berekenAnnuiteit(
          lening: somLeningen.aftrekbaar,
          toetsRente: toetsRente,
          aflosTermijnInMaanden: aflosTermijnInMaanden,
          periode: periode);

      if (lening - somLeningen.aftrekbaar > 0.0) {
        annuiteitMndBox3 = berekenAnnuiteit(
            lening: lening - somLeningen.aftrekbaar,
            toetsRente: toetsRente,
            aflosTermijnInMaanden: aflosTermijnInMaanden,
            periode: periode);
      }

      somLeningen.aftrekbaar = 0.0;
    }
  } else {
    annuiteitMndBox3 = annuiteitMnd;
  }

  double box1 = annuiteitMndBox1 * 12.0;
  double box3 = annuiteitMndBox3 * 12.0;

  somLeningen
    ..somLastBox1 += box1
    ..somLastBox3 += box3
    ..somLening += lening;
  // ToDo
  // ..somToetsRente += toetsRenteBedrag;
}

double berekenAnnuiteit(
    {required double lening,
    required double toetsRente,
    required int aflosTermijnInMaanden,
    required int periode}) {
  final double maandRente = toetsRente / 12.0;

  return lening /
      100.0 *
      maandRente /
      (1.0 -
          (math.pow(
              1.0 + maandRente / 100.0, -(aflosTermijnInMaanden - periode))));
}

class SomLeningen {
  double somLening;
  double somToetsRente;
  double somLastBox1;
  double somLastBox3;
  double aftrekbaar;

  SomLeningen({
    this.somLening = 0.0,
    this.somToetsRente = 0.0,
    this.somLastBox1 = 0.0,
    this.somLastBox3 = 0.0,
    this.aftrekbaar = 0.0,
  });

  double get rente => somToetsRente / somLening * 100.0;

  double get somLast => somLastBox1 + somLastBox3;

  SomLeningen copyWith({
    double? somLening,
    double? somToetsRente,
    double? somLastBox1,
    double? somLastBox3,
    double? aftrekbaar,
  }) {
    return SomLeningen(
      somLening: somLening ?? this.somLening,
      somToetsRente: somToetsRente ?? this.somToetsRente,
      somLastBox1: somLastBox1 ?? this.somLastBox1,
      somLastBox3: somLastBox3 ?? this.somLastBox3,
      aftrekbaar: aftrekbaar ?? this.aftrekbaar,
    );
  }
}

class LastenVerrekenPot {
  double percentage;
  InkomenPot pot;

  LastenVerrekenPot({
    required this.percentage,
    required this.pot,
  });

  double aftrekken(double last) {
    final maxLast = pot.inkomen / 100.0 * percentage;

    if (last < maxLast) {
      final lastNaarInkomen = last * 100.0 / percentage;
      pot.inkomen -= lastNaarInkomen;
      return last;
    } else {
      pot.inkomen = 0.0;
      return maxLast;
    }
  }

  double opmaken() {
    final maxLast = pot.inkomen / 100.0 * percentage;
    pot.inkomen = 0.0;
    return maxLast;
  }

  double resterendeLast() => pot.inkomen / 100.0 * percentage;
}

class InkomenPot {
  double inkomen;
  bool pensioen;

  InkomenPot({
    required this.inkomen,
    required this.pensioen,
  });

  bool get isNotEmpty => inkomen > 0.0;
}
