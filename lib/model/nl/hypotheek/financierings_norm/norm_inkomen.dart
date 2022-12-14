import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/hypotheek/financierings_norm/norm.dart';
import 'package:mortgage_insight/model/nl/inkomen/inkomen.dart';
import 'package:mortgage_insight/utilities/Kalender.dart';
import '../../schulden/schulden.dart';
import '../parallel_leningen.dart';
import 'financierings_last_tabel.dart';
import '../hypotheek.dart';

class BerekenNormInkomen {
  NormInkomen norm;
  Hypotheek hypotheek;
  HypotheekProfiel profiel;
  List<Hypotheek> parallelHypotheken;
  List<Inkomen> inkomenLijst;
  List<Inkomen> inkomenLijstPartner;
  List<Schuld> schuldenLijst;

  BerekenNormInkomen({
    required this.hypotheek,
    required this.profiel,
    required this.parallelHypotheken,
    required this.inkomenLijst,
    required this.inkomenLijstPartner,
    required this.schuldenLijst,
  }) : norm = hypotheek.maxLeningInkomen {
    norm.toepassen = profiel.inkomensNormToepassen;

    norm.wissen();

    double someSchuld = somSchuld();

    if (norm.toepassen && !hypotheek.afgesloten) {
      List<InkomensOpDatum> inkomensOpDatum = vindInkomen();

      norm.gegevens = inkomensOpDatum.map((e) {
        int periode = DateUtils.monthDelta(hypotheek.startDatum, e.datum);

        return GegevensNormInkomen.from(
          parallelHypotheken: parallelHypotheken,
          profiel: profiel,
          hypotheek: hypotheek,
          inkomenOpDatum: e,
          startDatum: e.datum,
          periode: periode,
          schuldenMnd: someSchuld,
        );
      }).toList();

      norm.gegevens.forEach((GegevensNormInkomen gegevensNormInkomen) {
        BerekenMaximaleLening(
            gegevens: gegevensNormInkomen, hypotheek: hypotheek);
      });

      norm.vindMaximumLening();
    }
  }

  List<InkomensOpDatum> vindInkomen() {
    Map<DateTime, InkomensOpDatum> map = {};

    final startDatum = hypotheek.startDatum;
    final stop = Kalender.voegPeriodeToe(hypotheek.startDatum, jaren: 10);

    /// Inkomen
    /// Vind eerste inkomen
    ///
    ///

    void inkomenToevoegen(
        {DateTime? datum, required Inkomen inkomen, bool partner = false}) {
      final DateTime _datum = datum ?? inkomen.datum;
      InkomensOpDatum? iod = map[datum];

      if (iod != null) {
        iod.inkomenToevoegen(inkomen: inkomen, partner: partner);
      } else {
        map[_datum] = InkomensOpDatum.individueel(
            datum: _datum, inkomen: inkomen, partner: partner);
      }
    }

    void iteratieInkomenLijst(
        {required List<Inkomen> lijst, bool partner: false}) {
      Inkomen? gk;

      int index = 0;
      int length = lijst.length;

      while (index < length) {
        final inkomen = lijst[index];

        if (inkomen.datum.compareTo(startDatum) <= 0) {
          gk = inkomen;
          index++;
        } else {
          break;
        }
      }

      if (gk == null) {
        return;
      }

      inkomenToevoegen(datum: startDatum, inkomen: gk, partner: partner);

      if (gk.pensioen) {
        return;
      }

      while (index < length) {
        final inkomen = lijst[index];

        if (inkomen.datum.isAfter(stop)) {
          break;
        } else if (inkomen.pensioen) {
          inkomenToevoegen(inkomen: inkomen, partner: partner);
          break;
        }
        index++;
      }
    }

    iteratieInkomenLijst(lijst: inkomenLijst);
    iteratieInkomenLijst(lijst: inkomenLijstPartner, partner: true);

    List<InkomensOpDatum> lijst = map.values.toList()
      ..sort(
          (InkomensOpDatum a, InkomensOpDatum b) => a.datum.compareTo(b.datum));

    inkomenZoeken(List<Inkomen> inkomenLijst, bool partner) {
      if (inkomenLijst.isEmpty) return;

      int index = 0;
      int i = -1;
      int length = inkomenLijst.length;

      lijst
          .where((element) => !element.heeftInkomen(partner))
          .forEach((InkomensOpDatum iod) {
        while (index < length) {
          if (inkomenLijst[index].datum.compareTo(iod.datum) <= 0) {
            i = index++;
          } else {
            break;
          }
        }
        if (i != -1) {
          iod.inkomenToevoegen(inkomen: inkomenLijst[i], partner: partner);
        }
      });
    }

    inkomenZoeken(inkomenLijst, false);
    inkomenZoeken(inkomenLijstPartner, true);

    return lijst;
  }

  Inkomen? zoekInkomen(
      {required List<Inkomen> inkomenLijst, required DateTime datum}) {
    Inkomen? inkomen;
    for (Inkomen i in inkomenLijst) {
      if (i.datum.compareTo(datum) <= 0) {
        inkomen = i;
      } else {
        break;
      }
    }
    return inkomen;
  }

  double somSchuld() => schuldenLijst.fold(
      0.0,
      (double previousValue, Schuld schuld) =>
          previousValue + schuld.maandLast(hypotheek.startDatum));
}

class InkomensOpDatum {
  DateTime datum;
  Inkomen? inkomen;
  Inkomen? inkomenPartner;

  InkomensOpDatum.individueel({
    required this.datum,
    required Inkomen inkomen,
    required bool partner,
  }) {
    if (partner) {
      inkomenPartner = inkomen;
    } else {
      this.inkomen = inkomen;
    }
  }

  InkomensOpDatum({
    required this.datum,
    this.inkomen,
    this.inkomenPartner,
  });

  void inkomenToevoegen({required Inkomen? inkomen, required bool partner}) {
    if (partner) {
      inkomenPartner = inkomen;
    } else {
      this.inkomen = inkomen;
    }
  }

  double get hoogsteBrutoInkomen {
    final a = inkomen?.brutoJaar(datum) ?? 0.0;
    final b = inkomenPartner?.brutoJaar(datum) ?? 0.0;
    return a < b ? b : a;
  }

  double get laagsteBrutoInkomen {
    final a = inkomen?.brutoJaar(datum) ?? 0.0;
    final b = inkomenPartner?.brutoJaar(datum) ?? 0.0;
    return a < b ? a : b;
  }

  double get totaal =>
      (inkomen?.brutoJaar(datum) ?? 0.0) +
      (inkomenPartner?.brutoJaar(datum) ?? 0.0);

  bool heeftInkomen(bool partner) =>
      (partner ? inkomenPartner : inkomen) != null;

  Iterable<Inkomen> toIterable() sync* {
    final _inkomen = inkomen;
    final _inkomenPartner = inkomenPartner;

    if (_inkomen != null && _inkomenPartner != null) {
      if (_inkomen.pensioen && !_inkomenPartner.pensioen) {
        yield _inkomenPartner;
        yield _inkomen;
      } else {
        yield _inkomen;
        yield _inkomenPartner;
      }
    } else if (_inkomen != null) {
      yield _inkomen;
    } else if (_inkomenPartner != null) {
      yield _inkomenPartner;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'datum': datum.millisecondsSinceEpoch,
      'inkomen': inkomen?.toMap(),
      'inkomenPartner': inkomenPartner?.toMap(),
    };
  }

  factory InkomensOpDatum.fromMap(Map<String, dynamic> map) {
    return InkomensOpDatum(
      datum: DateTime.fromMillisecondsSinceEpoch(map['datum'] as int),
      inkomen: map['inkomen'] != null
          ? Inkomen.fromMap(map['inkomen'] as Map<String, dynamic>)
          : null,
      inkomenPartner: map['inkomenPartner'] != null
          ? Inkomen.fromMap(map['inkomenPartner'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InkomensOpDatum.fromJson(String source) =>
      InkomensOpDatum.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BerekenMaximaleLening {
  GegevensNormInkomen gegevens;
  FinancieringsLast financieringsLast;
  Hypotheek hypotheek;

  BerekenMaximaleLening({
    required this.gegevens,
    required this.hypotheek,
  }) : financieringsLast = FinancieringsLast(
            startDatum: gegevens.startDatum,
            inkomen: gegevens.inkomenOpDatum,
            alleenstaande: false) {
    _iteratieMaxLeningInkomen();
  }

  void _iteratieMaxLeningInkomen() {
    int i = 0;
    double laagsteLening = 0.0;
    double hoogsteLening = 300000;
    double gemiddeldeLening = 0.0;

    double last = _berekenAfwijkingLast(hoogsteLening);

    while (last < 0.0 && i <= 75) {
      laagsteLening = hoogsteLening;
      hoogsteLening *= 1.5;
      last = _berekenAfwijkingLast(hoogsteLening);
      i++;
    }

    while (i <= 75) {
      gemiddeldeLening = (laagsteLening + hoogsteLening) / 2.0;

      last = _berekenAfwijkingLast(gemiddeldeLening);

      if (last < -0.01 && (gemiddeldeLening - laagsteLening) > 0.5) {
        laagsteLening = gemiddeldeLening;
      } else if (last > 0.01 && (hoogsteLening - gemiddeldeLening) > 0.5) {
        hoogsteLening = gemiddeldeLening;
      } else {
        break;
      }
      i++;
    }

    if (i > 75) {
      gegevens.fout = 'Optimale lening niet gevonden, iteraties > 75';
    }

    // debugPrint('Iterations: $i ${gegevens.optimalisatieLast.lening}');

    berekenInitieleLening();
  }

  double _berekenAfwijkingLast(double lening) {
    //Last berekenen
    final somLeningen = _SomLeningen(
        aftrekbaar:
            lening + gegevens.parallelLeningen.somLeningen - gegevens.erw);

    gegevens.parallelLeningen.list.forEach((OptimalisatieLast sl) {
      berekenIndividueleLast(sn: sl, somLeningen: somLeningen);
    });

    berekenIndividueleLast(
        sn: gegevens.optimalisatieLast..lening = lening,
        somLeningen: somLeningen);

    //Afwijking berekenen

    final List<InkomenPot> inkomenPotten = gegevens.inkomenOpDatum
        .toIterable()
        .map((Inkomen e) => InkomenPot(
            inkomen: e.brutoJaar(gegevens.startDatum), pensioen: e.pensioen))
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

    double lastenBox3 = somLeningen.somLastBox3 + gegevens.schulden;

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

  void berekenInitieleLening() {
    final ol = gegevens.optimalisatieLast;
    final statusLening = ol.statusLening;
    double initieleLening;
    if (statusLening.periode == 0) {
      initieleLening = ol.lening;
    } else {
      switch (statusLening.hypotheekVorm) {
        case HypotheekVorm.Aflosvrij:
          initieleLening = ol.lening;
          break;
        case HypotheekVorm.Linear:
          initieleLening = ol.lening *
              (statusLening.aflosTermijnInMaanden) /
              (statusLening.aflosTermijnInMaanden - statusLening.periode);
          break;
        case HypotheekVorm.Annuity:
          double r = statusLening.rente / 100.0 / 12.0;
          initieleLening = ol.lening *
              (1.0 - math.pow(1.0 + r, -statusLening.aflosTermijnInMaanden)) /
              (1.0 -
                  math.pow(
                      1.0 + r,
                      -(statusLening.aflosTermijnInMaanden -
                          statusLening.periode)));
          break;
      }
    }
    if (initieleLening.isInfinite) {
      gegevens.fout = 'Terugbereken niet gelukt';
    } else {
      ol.initieleLening = initieleLening.roundToDouble();
    }
  }

  berekenVerduurzamen() {
    final vvk = hypotheek.verbouwVerduurzaamKosten;
    final ol = gegevens.optimalisatieLast;
    if (vvk.toepassen) {
      ol.verduurzaamLening = financieringsLast.verduurzamen(
          verduurzaamKosten: gegevens.parallelLeningen.somVerduurzaamKosten +
              hypotheek.verbouwVerduurzaamKosten.totaleVerduurzaamKosten,
          energieClassificering: vvk.energieClassificering);
    }
  }
}

class GegevensNormInkomen {
  LastParallelLeningen parallelLeningen;
  OptimalisatieLast optimalisatieLast;
  InkomensOpDatum inkomenOpDatum;
  DateTime startDatum;
  int normVersie;
  String fout;
  double verduurzaamKosten;
  double erw;
  double schuldenMnd;

  GegevensNormInkomen({
    required this.parallelLeningen,
    required this.optimalisatieLast,
    required this.inkomenOpDatum,
    required this.startDatum,
    this.normVersie = 0,
    this.fout = '',
    this.verduurzaamKosten = 0.0,
    this.erw = 0.0,
    this.schuldenMnd = 0.0,
  });

  GegevensNormInkomen.from({
    required List<Hypotheek> parallelHypotheken,
    required HypotheekProfiel profiel,
    required Hypotheek hypotheek,
    required this.inkomenOpDatum,
    required DateTime startDatum,
    required int periode,
    required this.schuldenMnd,
  })  : parallelLeningen = LastParallelLeningen.from(
            parallelHypotheken: parallelHypotheken,
            hypotheek: hypotheek,
            datum: startDatum),
        startDatum = startDatum,
        normVersie = 0,
        optimalisatieLast = OptimalisatieLast(
          statusLening:
              StatusLening.from(hypotheek: hypotheek, periode: periode),
          toetsRente: FinancieringsLast.toetsRente(
              periodesMnd: hypotheek.periodeInMaanden, rente: hypotheek.rente),
        ),
        fout = '',
        erw = profiel.erw,
        verduurzaamKosten =
            hypotheek.verbouwVerduurzaamKosten.totaleVerduurzaamKosten;

  double get schulden => schuldenMnd * 12.0;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'parallelLeningen': parallelLeningen.toMap(),
      'optimalisatieLast': optimalisatieLast.toMap(),
      'inkomenOpDatum': inkomenOpDatum.toMap(),
      'startDatum': startDatum.millisecondsSinceEpoch,
      'normVersie': normVersie,
      'fout': fout,
      'verduurzaamKosten': verduurzaamKosten,
      'schuld': schuldenMnd,
      'erw': erw,
    };
  }

  factory GegevensNormInkomen.fromMap(Map<String, dynamic> map) {
    return GegevensNormInkomen(
      parallelLeningen: LastParallelLeningen.fromMap(
          map['parallelLeningen'] as Map<String, dynamic>),
      optimalisatieLast: OptimalisatieLast.fromMap(
          map['optimalisatieLast'] as Map<String, dynamic>),
      inkomenOpDatum: InkomensOpDatum.fromMap(
          map['inkomenOpDatum'] as Map<String, dynamic>),
      startDatum: DateTime.fromMillisecondsSinceEpoch(map['startDatum'] as int),
      normVersie: map['normVersie'] as int,
      fout: map['fout'],
      verduurzaamKosten: map['verduurzaamKosten'] as double,
      schuldenMnd: map['schuld'] as double,
      erw: map['erw'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory GegevensNormInkomen.fromJson(String source) =>
      GegevensNormInkomen.fromMap(json.decode(source) as Map<String, dynamic>);
}

class LastParallelLeningen {
  List<OptimalisatieLast> list;
  double somLeningen;
  double somVerduurzaamKosten;

  LastParallelLeningen({
    required this.list,
    this.somLeningen = 0.0,
    this.somVerduurzaamKosten = 0.0,
  });

  LastParallelLeningen.from(
      {required List<Hypotheek> parallelHypotheken,
      required Hypotheek hypotheek,
      required DateTime datum})
      : list = [],
        somLeningen = 0.0,
        somVerduurzaamKosten = 0.0 {
    for (Hypotheek h in parallelHypotheken) {
      Termijn? termijn;

      for (Termijn t in h.termijnen) {
        if (t.startDatum.compareTo(datum) <= 0) {
          termijn = t;
        } else {
          break;
        }
      }

      if (termijn != null) {
        final statusLening = OptimalisatieLast(
          statusLening: StatusLening(
              id: h.id,
              lening: termijn.lening,
              periode: termijn.periode,
              rente: h.rente,
              aflosTermijnInMaanden: h.aflosTermijnInMaanden,
              hypotheekVorm: h.hypotheekvorm),
          toetsRente: FinancieringsLast.toetsRente(
              periodesMnd: hypotheek.periodeInMaanden - termijn.periode,
              rente: h.rente),
        );

        somLeningen += termijn.lening;

        list.add(statusLening);
      }

      if (hypotheek.startDatum.compareTo(h.startDatum) == 0) {
        somVerduurzaamKosten +=
            h.verbouwVerduurzaamKosten.totaleVerduurzaamKosten;
      }
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'list': list.map((x) => x.toMap()).toList(),
      'somLeningen': somLeningen,
      'somVerduurzaamKosten': somVerduurzaamKosten,
    };
  }

  factory LastParallelLeningen.fromMap(Map<String, dynamic> map) {
    return LastParallelLeningen(
      list: List<OptimalisatieLast>.from(
        (map['list'] as List<int>).map<OptimalisatieLast>(
          (x) => OptimalisatieLast.fromMap(x as Map<String, dynamic>),
        ),
      ),
      somLeningen: map['somLeningen'] as double,
      somVerduurzaamKosten: map['somVerduurzaamKosten'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastParallelLeningen.fromJson(String source) =>
      LastParallelLeningen.fromMap(json.decode(source) as Map<String, dynamic>);
}

class OptimalisatieLast {
  StatusLening statusLening;
  double initieleLening;
  double lening;
  double verduurzaamLening;
  double toetsRente;
  double box1;
  double box3;

  OptimalisatieLast({
    required this.statusLening,
    required this.toetsRente,
    double? lening,
    this.initieleLening = 0.0,
    this.verduurzaamLening = 0.0,
    this.box1 = 0.0,
    this.box3 = 0.0,
  }) : lening = lening ?? statusLening.lening;

  double get toetsRenteBedrag => lening / 100.0 * toetsRente;

  OptimalisatieLast copyWith({
    StatusLening? statusLening,
    double? lening,
    double? initieleLening,
    double? verduurzaamLening,
    double? toetsRente,
    double? box1,
    double? box3,
    int? periode,
  }) {
    return OptimalisatieLast(
      statusLening: statusLening ?? this.statusLening,
      lening: lening ?? this.lening,
      initieleLening: initieleLening ?? this.initieleLening,
      verduurzaamLening: verduurzaamLening ?? this.verduurzaamLening,
      toetsRente: toetsRente ?? this.toetsRente,
      box1: box1 ?? this.box1,
      box3: box3 ?? this.box3,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusLening': statusLening.toMap(),
      'lening': lening,
      'initieleLening': initieleLening,
      'verduurzaamLening': verduurzaamLening,
      'toetsRente': toetsRente,
      'box1': box1,
      'box3': box3,
    };
  }

  factory OptimalisatieLast.fromMap(Map<String, dynamic> map) {
    return OptimalisatieLast(
      statusLening:
          StatusLening.fromMap(map['statusLening'] as Map<String, dynamic>),
      toetsRente: map['toetsRente'] as double,
      lening: map['lening'] as double,
      initieleLening: map['initieleLening'] as double,
      verduurzaamLening: map['verduurzaamLening'] as double,
      box1: map['box1'] as double,
      box3: map['box3'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OptimalisatieLast.fromJson(String source) =>
      OptimalisatieLast.fromMap(json.decode(source) as Map<String, dynamic>);
}

class _SomLeningen {
  double somLening;
  double somToetsRente;
  double somLastBox1;
  double somLastBox3;
  double aftrekbaar;

  _SomLeningen({
    this.somLening = 0.0,
    this.somToetsRente = 0.0,
    this.somLastBox1 = 0.0,
    this.somLastBox3 = 0.0,
    this.aftrekbaar = 0.0,
  });

  double get rente => somToetsRente / somLening * 100.0;

  double get somLast => somLastBox1 + somLastBox3;

  _SomLeningen copyWith({
    double? somLening,
    double? somToetsRente,
    double? somLastBox1,
    double? somLastBox3,
    double? aftrekbaar,
  }) {
    return _SomLeningen(
      somLening: somLening ?? this.somLening,
      somToetsRente: somToetsRente ?? this.somToetsRente,
      somLastBox1: somLastBox1 ?? this.somLastBox1,
      somLastBox3: somLastBox3 ?? this.somLastBox3,
      aftrekbaar: aftrekbaar ?? this.aftrekbaar,
    );
  }
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

berekenIndividueleLast(
    {required OptimalisatieLast sn, required _SomLeningen somLeningen}) {
  final statusLening = sn.statusLening;

  final annuiteitMnd = berekenAnnuiteit(
      lening: sn.lening,
      toetsRente: sn.toetsRente,
      aflosTermijnInMaanden: statusLening.aflosTermijnInMaanden,
      periode: statusLening.periode);

  double annuiteitMndBox1 = 0.0;
  double annuiteitMndBox3 = 0.0;

  if (somLeningen.aftrekbaar > 0.0 &&
      statusLening.hypotheekVorm != HypotheekVorm.Aflosvrij) {
    if (sn.lening < somLeningen.aftrekbaar) {
      annuiteitMndBox1 = annuiteitMnd;
      somLeningen.aftrekbaar -= sn.lening;
    } else {
      annuiteitMndBox1 = berekenAnnuiteit(
          lening: somLeningen.aftrekbaar,
          toetsRente: sn.toetsRente,
          aflosTermijnInMaanden: statusLening.aflosTermijnInMaanden,
          periode: statusLening.periode);

      if (sn.lening - somLeningen.aftrekbaar > 0.0) {
        annuiteitMndBox3 = berekenAnnuiteit(
            lening: sn.lening - somLeningen.aftrekbaar,
            toetsRente: sn.toetsRente,
            aflosTermijnInMaanden: statusLening.aflosTermijnInMaanden,
            periode: statusLening.periode);
      }

      somLeningen.aftrekbaar = 0.0;
    }
  } else {
    annuiteitMndBox3 = annuiteitMnd;
  }

  // double annuiteit = lening /
  //     100.0 *
  //     maandRente /
  //     (1.0 -
  //         (math.pow(1.0 + maandRente / 100.0,
  //             -(statusLening.aflosTermijnInMaanden - statusLening.periode))));

  sn.box1 = annuiteitMndBox1 * 12.0;
  sn.box3 = annuiteitMndBox3 * 12.0;

  somLeningen
    ..somLastBox1 += sn.box1
    ..somLastBox3 += sn.box3
    ..somLening += sn.lening
    ..somToetsRente += sn.toetsRenteBedrag;
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
