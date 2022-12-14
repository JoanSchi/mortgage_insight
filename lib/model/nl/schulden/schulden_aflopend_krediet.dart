import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import 'package:mortgage_insight/model/nl/schulden/schulden.dart';

import '../../../../utilities/Kalender.dart';

class AflopendKrediet extends Schuld {
  static const int termijnBedragTelaagError = 3;
  double lening;
  double rente;
  double termijnBedragMnd;
  double minTermijnBedragMnd;
  int maanden;
  int minMaanden;
  int maxMaanden;
  double minAflossenPerMaand;
  double maxAflossenPerMaand;
  double defaultAflossenPerMaand;
  List<AKtermijnAnn> termijnen;
  double somInterest;
  double somAnn;
  double slotTermijn;
  AflosTabelOpties aflosTabelOpties;
  int decimalen;
  bool renteGebrokenMaand;
  AKbetaling betaling;

  AflopendKrediet({
    int id = 0,
    required SchuldenCategorie categorie,
    String subCategorie = '',
    String omschrijving: '',
    DateTime? beginDatum,
    Calculated berekend: Calculated.no,
    this.lening: 0.0,
    this.rente: 0.0,
    this.termijnBedragMnd: 0.0,
    this.minTermijnBedragMnd: 0.0,
    this.maanden: 12,
    this.minMaanden: 1,
    this.maxMaanden = 120,
    this.minAflossenPerMaand: 10.0,
    this.maxAflossenPerMaand: 2000.0,
    this.defaultAflossenPerMaand: 50.0,
    List<AKtermijnAnn>? termijnen,
    this.somInterest = 0.0,
    this.somAnn = 0.0,
    this.slotTermijn = 0.0,
    AflosTabelOpties? aflosTabelOpties,
    this.decimalen: 0,
    this.renteGebrokenMaand: true,
    this.betaling: AKbetaling.per_periode,
    int error = 0,
  })  : termijnen = termijnen ?? [],
        aflosTabelOpties = aflosTabelOpties ?? AflosTabelOpties(),
        super(
          id: id,
          categorie: categorie,
          subCategorie: subCategorie,
          omschrijving: omschrijving,
          beginDatum: beginDatum,
          berekend: berekend,
          error: error,
        );

  double maandLast(DateTime huidige) {
    if (huidige.compareTo(beginDatum) < 0 || huidige.compareTo(eindDatum) > 0) {
      return 0.0;
    } else {
      final last = termijnen.length - 1;
      final begin = math.max(0, last - 3);
      double termijnBedrag = 0.0;

      for (int i = last; i >= begin; i--) {
        final tb = termijnen[i];
        if (tb.termijn.compareTo(huidige) <= 0) {
          if (termijnBedrag < tb.termijnBedrag) {
            termijnBedrag = tb.termijnBedrag;
          }
        } else {
          break;
        }
      }
      return termijnBedrag;
    }
  }

  @override
  DateTime get eindDatum {
    return termijnen.last.termijn;
  }

  void berekenenTermijnBedrag() {
    berekend = Calculated.no;

    if (lening == 0.0 || rente == 0.0 || maanden == 0.0) return;

    termijnBedragMnd = _akBerekenAnnuiteit(decimalen, lening, rente, maanden);

    _berekenenTermijnen();
  }

  void berekenLooptijd() {
    berekend = Calculated.no;

    if (lening == 0.0 || rente == 0.0 || termijnBedragMnd == 0.0) return;

    minTermijnBedragMnd =
        _akBerekenAnnuiteit(decimalen, lening, rente, maxMaanden);

    if (termijnBedragMnd < minTermijnBedragMnd) {
      berekend = Calculated.withError;
      error = termijnBedragTelaagError;
      return;
    }

    int mndCalculated =
        _akBerekenenMnd(decimalen, lening, rente, termijnBedragMnd);

    int mnd;

    if (mndCalculated.isNaN || mndCalculated > maxMaanden) {
      mnd = 240;
      termijnBedragMnd =
          _akBerekenAnnuiteit(decimalen, lening, rente, mnd).ceilToDouble();
    } else {
      mnd = mndCalculated;
    }

    if (maanden != mnd) {
      maanden = mnd;
    }

    _berekenenTermijnen();
  }

  setAfronden(int decimalen) {
    this.decimalen = decimalen;

    if (lening != 0.0 &&
        rente != 0.0 &&
        termijnBedragMnd != 0.0 &&
        maanden != 0) {
      termijnBedragMnd = akAfronden(decimalen, termijnBedragMnd);
      maanden = _akBerekenenMnd(decimalen, lening, rente, termijnBedragMnd);
      _berekenenTermijnen();
    }
  }

  set berekend(Calculated berekend) {
    super.berekend = berekend;

    if (berekend == Calculated.no) {
      somAnn = 0;
      somInterest = 0;
      termijnen.clear();
    }
  }

  bereken() {
    if (lening != 0.0 &&
        rente != 0.0 &&
        termijnBedragMnd != 0.0 &&
        maanden != 0) {
      _berekenenTermijnen();
    }
  }

  _berekenenTermijnen() {
    if (termijnBedragMnd == 0.0 && lening == 0.0 && rente == 0.0) return;

    double schuld = lening;
    termijnen.clear();

    bool volgende = true;
    int index = 0;
    somInterest = 0.0;
    somAnn = 0.0;
    slotTermijn = 0.0;

    int maandenVolgensTermijnen = 0;

    termijnen.add(AKtermijnAnn(termijn: beginDatum, schuld: schuld));

    switch (betaling) {
      case AKbetaling.per_periode:
        {
          do {
            final interest = schuld / 100 * rente / 12;
            double aflossen = termijnBedragMnd - interest;
            maandenVolgensTermijnen++;

            if (schuld >= aflossen) {
              schuld -= aflossen;
              somInterest += interest;
              somAnn += termijnBedragMnd;

              termijnen.add(AKtermijnAnn(
                  termijn:
                      Kalender.voegPeriodeToe(beginDatum, maanden: index + 1),
                  termijnBedrag: termijnBedragMnd,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));
            } else {
              aflossen = schuld;
              schuld = 0;
              final termijnBedrag = aflossen + interest;
              slotTermijn = termijnBedrag;

              somInterest += interest;
              somAnn += termijnBedrag;
              termijnen.add(AKtermijnAnn(
                  termijn:
                      Kalender.voegPeriodeToe(beginDatum, maanden: index + 1),
                  termijnBedrag: termijnBedrag,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));
              volgende = false;
              break;
            }

            if (schuld < 0.001) {
              volgende = false;
              break;
            }

            if (index > maxMaanden) {
              volgende = false;
            }

            if (index > maanden) {
              volgende = false;
            }

            index++;
          } while (volgende);

          break;
        }
      case AKbetaling.per_maand:
        {
          bool eersteMaand = true;
          bool extraMaand = false;
          //bool halveMaand = false;
          double beginFractie = 0.0;
          DateTime datum = beginDatum;

          do {
            double fractie = 1.0;

            if (eersteMaand && datum.day > 1) {
              extraMaand = true;
              int dag = datum.day;
              int dagenMaand =
                  Kalender.dagenPerMaand(jaar: datum.year, maand: datum.month);

              beginFractie = (dagenMaand - dag + 1) / dagenMaand;
              fractie = beginFractie;
              //halveMaand = true;
            }

            eersteMaand = false;

            final termijnBedrag = termijnBedragMnd * fractie;

            final interest = schuld / 100 * rente / 12 * fractie;
            double aflossen = termijnBedrag - interest;
            maandenVolgensTermijnen++;

            if (schuld >= aflossen) {
              schuld -= aflossen;
              somInterest += interest;
              somAnn += termijnBedrag;

              datum = Kalender.voegPeriodeToe(datum,
                  maanden: 1, periodeOpties: PeriodeOpties.EERSTEDAG);

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  termijnBedrag: termijnBedrag,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));
            } else {
              aflossen = schuld;
              schuld = 0;
              final termijnBedrag = aflossen + interest;
              slotTermijn = termijnBedrag;

              somInterest += interest;
              somAnn += termijnBedrag;

              //datum = DateTime(datum.year, datum.month, _beginDatum.day);

              datum = Kalender.voegPeriodeToe(datum,
                  maanden: 1, periodeOpties: PeriodeOpties.EERSTEDAG);

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  termijnBedrag: termijnBedrag,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));
              volgende = false;
              break;
            }

            if (index > maanden + (extraMaand ? 1 : 0)) {
              volgende = false;
            }

            index++;
          } while (volgende);

          maandenVolgensTermijnen -= (extraMaand ? 1 : 0);
          break;
        }
      case AKbetaling.per_eerst_volgende_maand:
        {
          DateTime datum = beginDatum;

          if (datum.day > 1) {
            if (renteGebrokenMaand) {
              final dag = beginDatum.day;
              final dagenMaand =
                  Kalender.dagenPerMaand(jaar: datum.year, maand: datum.month);
              print('dagen in maand $dagenMaand');
              final fractie = (dagenMaand - dag + 1) / dagenMaand;
              final interest = schuld / 100 * rente / 12 * fractie;
              somInterest += interest;
              somAnn += interest;

              datum = Kalender.voegPeriodeToe(datum,
                  maanden: 1, periodeOpties: PeriodeOpties.EERSTEDAG);

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  interest: interest,
                  schuld: schuld,
                  termijnBedrag: interest));
            } else {
              datum = Kalender.voegPeriodeToe(datum,
                  maanden: 1, periodeOpties: PeriodeOpties.EERSTEDAG);

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  termijnBedrag: termijnBedragMnd,
                  schuld: schuld));
            }
          }

          do {
            final interest = schuld / 100 * rente / 12;
            double aflossen = termijnBedragMnd - interest;

            datum = Kalender.voegPeriodeToe(datum,
                maanden: 1, periodeOpties: PeriodeOpties.EERSTEDAG);

            maandenVolgensTermijnen++;

            if (schuld >= aflossen) {
              schuld -= aflossen;
              somInterest += interest;
              somAnn += termijnBedragMnd;

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  termijnBedrag: termijnBedragMnd,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));
            } else {
              aflossen = schuld;
              schuld = 0;
              final termijnBedrag = aflossen + interest;
              slotTermijn = termijnBedrag;

              somInterest += interest;
              somAnn += termijnBedrag;

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  termijnBedrag: termijnBedrag,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));
              volgende = false;
              break;
            }

            if (index > maanden) {
              volgende = false;
            }
            index++;
          } while (volgende);

          break;
        }
      default:
        {}
    }

    if (maanden != maandenVolgensTermijnen) {
      debugPrint(
          'Maanden ingevuld/berekend $maanden is anders dan maanden bepaald met termijnen: $maandenVolgensTermijnen');
      maanden = maandenVolgensTermijnen;
    }

    assert(termijnen.length >= 2, 'Termijnen lijst moet minimaal 2 zijn');

    double termijnBedragVolgensTermijnen =
        termijnen[termijnen.length == 2 ? 1 : termijnen.length - 2]
            .termijnBedrag;

    if (termijnBedragMnd != termijnBedragVolgensTermijnen) {
      debugPrint(
          'Termijnbedrag ingevuld/berekend $termijnBedragMnd is anders dan 1st termijnbedrag bepaald met termijnen: $termijnBedragVolgensTermijnen');

      termijnBedragMnd = termijnBedragVolgensTermijnen;
    }

    berekend = Calculated.yes;
  }

  double interestPercentage() {
    return somInterest / lening * 100.0;
  }

  bool maandZichtbaarAflosTabel(AKtermijnAnn t) {
    if (aflosTabelOpties.maandZichtbaar(t.termijn.month)) {
      return true;
    } else if (aflosTabelOpties.startEind &&
        (termijnen.first.termijn.compareTo(t.termijn) == 0 ||
            termijnen.last.termijn.compareTo(t.termijn) == 0)) {
      return true;
    } else if (aflosTabelOpties.afwijkend) {
      if (termijnen.first.termijn.compareTo(t.termijn) != 0) {
        final vorige = termijnen[termijnen.indexOf(t) - 1];

        if (vorige.termijnBedrag != t.termijnBedrag) {
          return true;
        }
      }
    }

    return false;
  }

  @override
  AflopendKrediet copyWith({
    int? id,
    SchuldenCategorie? categorie,
    String? subCategorie,
    String? omschrijving,
    DateTime? beginDatum,
    Calculated? berekend,
    double? lening,
    double? rente,
    double? termijnBedragMnd,
    double? minTermijnBedragMnd,
    int? maanden,
    int? minMaanden,
    int? maxMaanden,
    double? minAflossenPerMaand,
    double? maxAflossenPerMaand,
    double? defaultAflossenPerMaand,
    List<AKtermijnAnn>? termijnen,
    double? somInterest,
    double? somAnn,
    double? slotTermijn,
    AflosTabelOpties? aflosTabelOpties,
    int? decimalen,
    bool? renteGebrokenMaand,
    AKbetaling? betaling,
    int? error,
  }) {
    return AflopendKrediet(
      id: id ?? this.id,
      categorie: categorie ?? this.categorie,
      subCategorie: subCategorie ?? this.subCategorie,
      omschrijving: omschrijving ?? this.omschrijving,
      beginDatum: beginDatum ?? this.beginDatum,
      berekend: berekend ?? this.berekend,
      lening: lening ?? this.lening,
      rente: rente ?? this.rente,
      termijnBedragMnd: termijnBedragMnd ?? this.termijnBedragMnd,
      minTermijnBedragMnd: minTermijnBedragMnd ?? this.minTermijnBedragMnd,
      maanden: maanden ?? this.maanden,
      minMaanden: minMaanden ?? this.minMaanden,
      maxMaanden: maxMaanden ?? this.maxMaanden,
      minAflossenPerMaand: minAflossenPerMaand ?? this.minAflossenPerMaand,
      maxAflossenPerMaand: maxAflossenPerMaand ?? this.maxAflossenPerMaand,
      defaultAflossenPerMaand:
          defaultAflossenPerMaand ?? this.defaultAflossenPerMaand,
      termijnen: termijnen ?? List.from(this.termijnen),
      somInterest: somInterest ?? this.somInterest,
      somAnn: somAnn ?? this.somAnn,
      slotTermijn: slotTermijn ?? this.slotTermijn,
      aflosTabelOpties: aflosTabelOpties ?? this.aflosTabelOpties,
      decimalen: decimalen ?? this.decimalen,
      renteGebrokenMaand: renteGebrokenMaand ?? this.renteGebrokenMaand,
      betaling: betaling ?? this.betaling,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AflopendKrediet &&
        other.id == id &&
        other.lening == lening &&
        other.rente == rente &&
        other.termijnBedragMnd == termijnBedragMnd &&
        other.minTermijnBedragMnd == minTermijnBedragMnd &&
        other.maanden == maanden &&
        other.minMaanden == minMaanden &&
        other.maxMaanden == maxMaanden &&
        other.minAflossenPerMaand == minAflossenPerMaand &&
        other.maxAflossenPerMaand == maxAflossenPerMaand &&
        other.defaultAflossenPerMaand == defaultAflossenPerMaand &&
        listEquals(other.termijnen, termijnen) &&
        other.somInterest == somInterest &&
        other.somAnn == somAnn &&
        other.slotTermijn == slotTermijn &&
        other.aflosTabelOpties == aflosTabelOpties &&
        other.decimalen == decimalen &&
        other.renteGebrokenMaand == renteGebrokenMaand &&
        other.betaling == betaling &&
        other.error == error;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lening.hashCode ^
        rente.hashCode ^
        termijnBedragMnd.hashCode ^
        minTermijnBedragMnd.hashCode ^
        maanden.hashCode ^
        minMaanden.hashCode ^
        maxMaanden.hashCode ^
        minAflossenPerMaand.hashCode ^
        maxAflossenPerMaand.hashCode ^
        defaultAflossenPerMaand.hashCode ^
        termijnen.hashCode ^
        somInterest.hashCode ^
        somAnn.hashCode ^
        slotTermijn.hashCode ^
        aflosTabelOpties.hashCode ^
        decimalen.hashCode ^
        renteGebrokenMaand.hashCode ^
        betaling.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categorie': categorie.index,
      'subCategorie': subCategorie,
      'omschrijving': omschrijving,
      'beginDatum': beginDatum.toIso8601String(),
      'berekend': berekend.index,
      'error': error,
      //Aflopend Krediet
      'lening': lening,
      'rente': rente,
      'termijnBedragMnd': termijnBedragMnd,
      'minTermijnBedragMnd': minTermijnBedragMnd,
      'maanden': maanden,
      'minMaanden': minMaanden,
      'maxMaanden': maxMaanden,
      'minAflossenPerMaand': minAflossenPerMaand,
      'maxAflossenPerMaand': maxAflossenPerMaand,
      'defaultAflossenPerMaand': defaultAflossenPerMaand,
      'termijnen': termijnen.map((x) => x.toMap()).toList(),
      'somInterest': somInterest,
      'somAnn': somAnn,
      'slotTermijn': slotTermijn,
      'aflosTabelOpties': aflosTabelOpties.toMap(),
      'decimalen': decimalen,
      'renteGebrokenMaand': renteGebrokenMaand,
      'betaling': betaling.index,
    };
  }

  factory AflopendKrediet.fromMap(Map<String, dynamic> map) {
    return AflopendKrediet(
      id: map['id']?.toInt(),
      categorie: SchuldenCategorie.values[map['categorie'].toInt()],
      subCategorie: map['subCategorie'],
      omschrijving: map['omschrijving'],
      beginDatum: DateTime.parse(map['beginDatum']).toLocal(),
      berekend: Calculated.values[map['berekend'].toInt()],
      error: map['error']?.toInt(),
      //Aflopend Krediet
      lening: map['lening']?.toDouble(),
      rente: map['rente']?.toDouble(),
      termijnBedragMnd: map['termijnBedragMnd']?.toDouble(),
      minTermijnBedragMnd: map['minTermijnBedragMnd']?.toDouble(),
      maanden: map['maanden']?.toInt(),
      minMaanden: map['minMaanden']?.toInt(),
      maxMaanden: map['maxMaanden']?.toInt(),
      minAflossenPerMaand: map['minAflossenPerMaand']?.toDouble(),
      maxAflossenPerMaand: map['maxAflossenPerMaand']?.toDouble(),
      defaultAflossenPerMaand: map['defaultAflossenPerMaand']?.toDouble(),
      termijnen: List<AKtermijnAnn>.from(
          map['termijnen'].map((x) => AKtermijnAnn.fromMap(x))),
      somInterest: map['somInterest']?.toDouble(),
      somAnn: map['somAnn']?.toDouble(),
      slotTermijn: map['slotTermijn']?.toDouble(),
      aflosTabelOpties: AflosTabelOpties.fromMap(map['aflosTabelOpties']),
      decimalen: map['decimalen']?.toInt(),
      renteGebrokenMaand: map['renteGebrokenMaand'],
      betaling: AKbetaling.values[map['betaling'].toInt()],
    );
  }

  String toJson() => json.encode(toMap());

  factory AflopendKrediet.fromJson(String source) =>
      AflopendKrediet.fromMap(json.decode(source));
}

double _akBerekenAnnuiteit(
    int decimalen, double lening, double rente, num mnd) {
  final a = 1 + rente / 100 / 12;
  final b = rente / 100 / 12;

  double annBerekend = lening / ((1 - 1 / math.pow(a, mnd)) / b);

  return akAfronden(decimalen, annBerekend);
}

double akAfronden(int decimalen, double bedrag) {
  double factor = 1.0;

  for (int i = 0; i < decimalen; i++) {
    factor *= 10;
  }

  return (bedrag * factor).ceilToDouble() / factor;
}

int _akBerekenenMnd(int betaling, double lening, double rente, double ann) {
  final A = 1 + rente / 100 / 12;
  final B = rente / 100 / 12;

//  double mnd = false
//      ? log(1 / (1 - (lening - ann) / ann * B)) / log(A)
//      : log(1 / (1 - lening / ann * B)) / log(A);

  double mnd = math.log(1 / (1 - lening / ann * B)) / math.log(A);

  double rest = mnd % 1.0;

  return (rest < 0.01) ? mnd.floor() : mnd.ceil();
}

// double _akModel(double maanden, double rente) {
//   return 5.0 * maanden + maanden * maanden * rente / 100.0;
// }

class AKtermijnAnn {
  final DateTime termijn;
  final double interest;
  final double aflossen;
  final double schuld;
  final double termijnBedrag;

  //double get termijnBedrag => (aflossen?? 0.0) + (interest?? 0.0);

  AKtermijnAnn(
      {required this.termijn,
      this.interest: 0.0,
      this.aflossen: 0.0,
      required this.schuld,
      this.termijnBedrag: 0.0});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'termijn': termijn.toIso8601String(),
      'interest': interest,
      'aflossen': aflossen,
      'schuld': schuld,
      'termijnBedrag': termijnBedrag,
    };
  }

  factory AKtermijnAnn.fromMap(Map<String, dynamic> map) {
    return AKtermijnAnn(
      termijn: DateTime.parse(map['termijn']),
      interest: map['interest']?.toDouble(),
      aflossen: map['aflossen']?.toDouble(),
      schuld: map['schuld']?.toDouble(),
      termijnBedrag: map['termijnBedrag']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AKtermijnAnn.fromJson(String source) =>
      AKtermijnAnn.fromMap(json.decode(source));
}

class AflosTabelOpties {
  List<bool> maandenZichtbaar;
  bool startEind;
  bool afwijkend;

  AflosTabelOpties(
      {List<bool>? maandenZichtbaar,
      this.startEind: true,
      this.afwijkend: true})
      : maandenZichtbaar = maandenZichtbaar ??
            [
              true,
              false,
              false,
              false,
              false,
              false,
              true,
              false,
              false,
              false,
              false,
              false
            ];

  bool maandZichtbaar(int maand) => maandenZichtbaar[maand - 1];

  @override
  String toString() =>
      'AflosTabelOpties(maandenZichtbaar: $maandenZichtbaar, startEind: $startEind, afwijkend: $afwijkend)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maandenZichtbaar': maandenZichtbaar,
      'startEind': startEind,
      'afwijkend': afwijkend,
    };
  }

  factory AflosTabelOpties.fromMap(Map<String, dynamic> map) {
    return AflosTabelOpties(
      maandenZichtbaar: List<bool>.from(map['maandenZichtbaar']),
      startEind: map['startEind'],
      afwijkend: map['afwijkend'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AflosTabelOpties.fromJson(String source) =>
      AflosTabelOpties.fromMap(json.decode(source));
}
