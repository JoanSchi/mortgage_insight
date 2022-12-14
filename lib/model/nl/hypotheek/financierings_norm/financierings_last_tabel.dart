import 'aow_box3_tabel.dart';
import 'aow_tabel.dart';
import 'niet_aow_box3_tabel.dart';
import 'niet_aow_tabel.dart';
import 'norm_inkomen.dart';
import 'dart:math' as math;

class FinNormInk {
  static const bereik = 'bereik',
      jaar = 'jaar',
      versie = 'versie',
      toetsRente = 'toetsRente',
      brutoInkomen = 'brutoInkomen',
      percentage = 'percentage';

  static const nietAOW = 'nietAow',
      nietAowBox3 = 'nietAowBox3',
      aow = 'aow',
      aowBox3 = 'aowBox3';
}

class FinancieringsLastTabel {
  Map tabel;
  bool aow;
  bool box3;
  double toetsInkomen;
  int indexInkomen;
  double toetsRente;
  int indexRente;
  int jaar;
  int toetsJaar;

  FinancieringsLastTabel({
    required this.tabel,
    required this.aow,
    required this.box3,
    this.indexInkomen = -1,
    this.toetsInkomen = 0.0,
    this.indexRente = -1,
    this.toetsRente = 0.0,
    this.jaar = -1,
    this.toetsJaar = -1,
  });

  setJaar(int v) {
    if (jaar != v) {
      jaar = v;
      List<int> bereik = nietAowTabel[FinNormInk.bereik] as List<int>;

      toetsJaar =
          bereik.firstWhere((element) => element == v, orElse: () => bereik[1]);
    }
  }

  setInkomen(double v) {
    if (v != toetsInkomen) {
      toetsInkomen = v;

      indexInkomen = tabel[toetsJaar][FinNormInk.brutoInkomen]
          .lastIndexWhere((brutoInkomenUitLijst) => v >= brutoInkomenUitLijst);
    }
  }

  setToetsRente(double v) {
    if (v != toetsRente) {
      toetsRente = v;

      indexRente = tabel[toetsJaar][FinNormInk.toetsRente]
          .lastIndexWhere((renteLijst) => v >= renteLijst);
    }
  }

  double get percentageLast {
    return tabel[toetsJaar][FinNormInk.percentage][indexInkomen][indexRente];
  }
}

class FinancieringsLast {
  DateTime startDatum;
  InkomensOpDatum inkomen;
  bool alleenstaande;
  FinancieringsLastTabel inkomenNietAow =
      FinancieringsLastTabel(tabel: nietAowTabel, aow: false, box3: false);
  FinancieringsLastTabel inkomenNietAowBox3 =
      FinancieringsLastTabel(tabel: nietAowBox3Tabel, aow: false, box3: true);
  FinancieringsLastTabel inkomenAow =
      FinancieringsLastTabel(tabel: aowTabel, aow: true, box3: false);
  FinancieringsLastTabel inkomenAowBox3 =
      FinancieringsLastTabel(tabel: aowBox3Tabel, aow: true, box3: true);

  static const String energieClassificeringNulopdeMeter = 'NulopdeMeter';
  static const String energieClassificeringEnergieIndex = 'EnergieIndex';

  FinancieringsLast({
    required this.startDatum,
    required this.inkomen,
    required this.alleenstaande,
  });

  FinancieringsLastTabel finanancieringsLastPercentage({
    bool box3: false,
    bool aow = false,
    required double toetsRente,
  }) {
    FinancieringsLastTabel tabel = aow
        ? (box3 ? inkomenAowBox3 : inkomenAow)
        : (box3 ? inkomenNietAowBox3 : inkomenNietAow);

    tabel
      ..setJaar(startDatum.year)
      ..setInkomen(totaalToetsInkomen)
      ..setToetsRente(toetsRente);

    return tabel;
  }

  double get totaalInkomen => inkomen.totaal;

  double get totaalToetsInkomen {
    return inkomen.hoogsteBrutoInkomen + inkomen.laagsteBrutoInkomen * 0.9;
  }

  static double toetsRente({required int periodesMnd, required double rente}) {
    if (periodesMnd < 10 * 12 && rente < 5.0) {
      return 5.0;
    } else {
      return rente;
    }
  }

  double verduurzamen(
      {required double verduurzaamKosten, String energieClassificering = ''}) {
    double verduurzamen;
    if (totaalToetsInkomen < 33000) {
      verduurzamen = 0.0;
    } else {
      switch (energieClassificering) {
        case energieClassificeringNulopdeMeter:
          {
            verduurzamen = math.min(25000, verduurzaamKosten);
            break;
          }
        case energieClassificeringEnergieIndex:
          {
            verduurzamen = math.min(15000, verduurzaamKosten);
            break;
          }
        default:
          {
            verduurzamen = math.min(9000, verduurzaamKosten);
          }
      }
    }
    return verduurzamen;
  }
}
