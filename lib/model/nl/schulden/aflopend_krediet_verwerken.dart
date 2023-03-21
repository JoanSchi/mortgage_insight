// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden.dart';
import '../../../utilities/kalender.dart';

class AflopendKredietVerwerken {
  static AflopendKrediet verandering(AflopendKrediet ak,
      {DateTime? beginDatum,
      double? lening,
      double? rente,
      double? termijnBedragMnd,
      int? maanden,
      AKbetaling? betaling,
      bool? eersteGebrokenMaandAlleenRente,
      int? decimalen}) {
    DateTime lBeginDatum = beginDatum ?? ak.beginDatum;
    double lLening = lening ?? ak.lening;
    double lRente = rente ?? ak.rente;
    double lTermijnBedragMnd = termijnBedragMnd ?? ak.termijnBedragMnd;
    int lMaanden = maanden ?? ak.maanden;
    AKbetaling localBetaling = betaling ?? ak.betaling;
    bool lEersteGebrokenMaandAlleenRente =
        eersteGebrokenMaandAlleenRente ?? ak.eersteGebrokenMaandAlleenRente;
    int lDecimalen = decimalen ?? ak.decimalen;
    String fout = '';
    bool heeftFout = false;

    if (decimalen != null) {
      lTermijnBedragMnd = _afronden(decimalen, lTermijnBedragMnd);
    }

    if (lMaanden < ak.minMaanden || lMaanden > ak.maxMaanden) {
      fout = 'Looptijd buiten ${ak.minMaanden} - ${ak.maxMaanden} mnd';
      heeftFout = true;
    }

    //Vergroot aantal decimalen indien ingevoerde termijnbedrag meer decimalen heeft
    if (termijnBedragMnd != null) {
      int suggestieDecimalen = 0;
      if (termijnBedragMnd * 10 % 1 != 0.0) {
        suggestieDecimalen = 2;
      } else if (termijnBedragMnd % 1 != 0.0) {
        suggestieDecimalen = 1;
      } else {
        suggestieDecimalen = 0;
      }
      lDecimalen = math.max(lDecimalen, suggestieDecimalen);
    }

    // Probeer maanden te berekenen
    bool termijnIsBerekend = false;

    // Probeer termijn te berekenen
    if (!heeftFout &&
        (maanden != null || rente != null || lening != null) &&
        lLening > 0.0 &&
        lRente > 0.0 &&
        lMaanden > 0) {
      lTermijnBedragMnd =
          _akBerekenAnnuiteit(lDecimalen, lLening, lRente, lMaanden);
      termijnIsBerekend = true;
    }

    if (!heeftFout &&
        !termijnIsBerekend &&
        (termijnBedragMnd != null) &&
        maanden == null &&
        lLening > 0.0 &&
        lTermijnBedragMnd > 0.0) {
      final pair = berekenLooptijd(
          decimalen: lDecimalen,
          lening: lLening,
          termijnBedragMnd: lTermijnBedragMnd,
          rente: lRente,
          maxMaanden: ak.maxMaanden);

      lMaanden = pair.a;
      lTermijnBedragMnd = pair.b;
      fout = pair.error ?? '';
      heeftFout = pair.hasError;
    }

    if (!heeftFout &&
        lTermijnBedragMnd > 0.0 &&
        lLening > 0.0 &&
        lRente > 0.0 &&
        lMaanden > 0) {
      return _berekenenTermijnen(
        ak,
        beginDatum: lBeginDatum,
        lening: lLening,
        rente: lRente,
        termijnBedragMnd: lTermijnBedragMnd,
        maanden: lMaanden,
        betaling: localBetaling,
        eersteGebrokenMaandAlleenRente: lEersteGebrokenMaandAlleenRente,
        decimalen: lDecimalen,
      );
    }

    return ak.copyWith(
        beginDatum: lBeginDatum,
        statusBerekening: StatusBerekening.nietBerekend,
        eersteGebrokenMaandAlleenRente: lEersteGebrokenMaandAlleenRente,
        lening: lLening,
        rente: lRente,
        termijnBedragMnd: lTermijnBedragMnd,
        maanden: lMaanden,
        betaling: localBetaling,
        decimalen: lDecimalen,
        error: fout);
  }

  static AflopendKrediet _berekenenTermijnen(
    AflopendKrediet ak, {
    required DateTime beginDatum,
    required double lening,
    required double rente,
    required double termijnBedragMnd,
    required int maanden,
    required AKbetaling betaling,
    required bool eersteGebrokenMaandAlleenRente,
    required int decimalen,
  }) {
    double schuld = lening;
    List<AKtermijnAnn> termijnen = [];

    bool volgende = true;
    int index = 0;
    double somInterest = 0.0;
    double somAnn = 0.0;
    double slotTermijn = 0.0;

    int maandenVolgensTermijnen = 0;

    // termijnen.add(AKtermijnAnn(
    //     termijn: beginDatum,
    //     schuld: schuld,
    //     aflossen: 0.0,
    //     interest: 0.0,
    //     termijnBedrag: 0.0));

    switch (betaling) {
      case AKbetaling.ingangsdatum:
        {
          do {
            final interest = schuld / 100.0 * rente / 12.0;
            double aflossen = termijnBedragMnd - interest;
            maandenVolgensTermijnen++;

            if (schuld >= aflossen) {
              somInterest += interest;
              somAnn += termijnBedragMnd;

              termijnen.add(AKtermijnAnn(
                  termijn: Kalender.voegPeriodeToe(beginDatum, maanden: index,periodeOpties: PeriodeOpties.volgende),
                  termijnBedrag: termijnBedragMnd,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));

              schuld -= aflossen;
            } else {
              aflossen = schuld;

              final termijnBedrag = aflossen + interest;
              slotTermijn = termijnBedrag;

              somInterest += interest;
              somAnn += termijnBedrag;
              termijnen.add(AKtermijnAnn(
                  termijn: Kalender.voegPeriodeToe(beginDatum, maanden: index, periodeOpties: PeriodeOpties.volgende),
                  termijnBedrag: termijnBedrag,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));

              schuld = 0.0;
              volgende = false;
              break;
            }

            if (schuld < 0.01 || index == ak.maxMaanden) {
              volgende = false;
              break;
            }

            // if (index > ak.maxMaanden) {
            //   volgende = false;
            // }

            // if (index > maanden) {
            //   volgende = false;
            // }

            index++;
          } while (volgende);

          break;
        }

      case AKbetaling.perEerstVolgendeMaand:
        {
          DateTime datum = beginDatum;

          if (datum.day > 1) {
            final dag = beginDatum.day;
            final dagenMaand =
                Kalender.dagenPerMaand(jaar: datum.year, maand: datum.month);

            final fractie = (dagenMaand - dag + 1) / dagenMaand;
            final interest = schuld / 100 * rente / 12 * fractie;
            somInterest += interest;

            double termijnBedragFractie;
            double aflossen;

            if (eersteGebrokenMaandAlleenRente) {
              aflossen = 0.0;
              termijnBedragFractie = interest;
              somAnn += interest;
            } else {
              termijnBedragFractie = termijnBedragMnd * fractie;
              somAnn += termijnBedragFractie;
              aflossen = termijnBedragFractie - interest;
              schuld -= aflossen;
            }

            termijnen.add(AKtermijnAnn(
                termijn: datum,
                interest: interest,
                schuld: schuld,
                termijnBedrag: termijnBedragFractie,
                aflossen: aflossen));

            datum = Kalender.voegPeriodeToe(datum,
                maanden: 1, periodeOpties: PeriodeOpties.eersteDag);
          }

          do {
            final interest = schuld / 100.0 * rente / 12.0;
            double aflossen = termijnBedragMnd - interest;

            maandenVolgensTermijnen++;

            if (schuld >= aflossen) {
              somInterest += interest;
              somAnn += termijnBedragMnd;

              termijnen.add(AKtermijnAnn(
                  termijn: datum,
                  termijnBedrag: termijnBedragMnd,
                  interest: interest,
                  aflossen: aflossen,
                  schuld: schuld));

              schuld -= aflossen;
            } else {
              aflossen = schuld;

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

              schuld = 0;

              volgende = false;
              break;
            }

            datum = Kalender.voegPeriodeToe(datum,
                maanden: 1, periodeOpties: PeriodeOpties.eersteDag);

            if (schuld < 0.01 || index == ak.maxMaanden) {
              volgende = false;
            }
            index++;
          } while (volgende);

          break;
        }
    }

    if (maanden != maandenVolgensTermijnen) {
      debugPrint(
          'Maanden ingevuld/berekend $maanden is anders dan maanden bepaald met termijnen: $maandenVolgensTermijnen');
      maanden = maandenVolgensTermijnen;
    }

    assert(termijnen.isNotEmpty, 'Termijnen lijst moet minimaal 1 zijn');

    double termijnBedragVolgensTermijnen =
        termijnen[termijnen.length == 1 ? 0 : termijnen.length - 2]
            .termijnBedrag;

    if (termijnBedragMnd != termijnBedragVolgensTermijnen) {
      debugPrint(
          'Termijnbedrag ingevuld/berekend $termijnBedragMnd is anders dan 1st termijnbedrag bepaald met termijnen: $termijnBedragVolgensTermijnen');

      termijnBedragMnd = termijnBedragVolgensTermijnen;
    }

    return ak.copyWith(
        beginDatum: beginDatum,
        statusBerekening: StatusBerekening.berekend,
        eersteGebrokenMaandAlleenRente: eersteGebrokenMaandAlleenRente,
        decimalen: decimalen,
        lening: lening,
        rente: rente,
        termijnBedragMnd: termijnBedragMnd,
        termijnen: termijnen.lock,
        maanden: maanden,
        betaling: betaling,
        somAnn: somAnn,
        somInterest: somInterest,
        slotTermijn: slotTermijn);
  }

  static DateTime eindDatum(AflopendKrediet ak) {
    return ak.termijnen.isEmpty ? DateTime(0) : ak.termijnen.last.termijn;
  }

  static double maandLast(AflopendKrediet ak, DateTime huidige) {
    if (huidige.compareTo(ak.beginDatum) < 0 ||
        huidige.compareTo(ak.eindDatum) > 0) {
      return 0.0;
    } else {
      final last = ak.termijnen.length - 1;
      final begin = math.max(0, last - 1);
      double termijnBedrag = 0.0;

      for (int i = last; i >= begin; i--) {
        final tb = ak.termijnen[i];
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

  static PairError<int, double, String?> berekenLooptijd(
      {required int decimalen,
      required double lening,
      required double termijnBedragMnd,
      required double rente,
      required int maxMaanden}) {
    double minTermijnBedragMnd =
        _akBerekenAnnuiteit(decimalen, lening, rente, maxMaanden);

    if (termijnBedragMnd < minTermijnBedragMnd) {
      return PairError(
          a: -1, b: termijnBedragMnd, hasError: true, error: 'fout');
    }

    int mndCalculated =
        _akBerekenenMnd(decimalen, lening, rente, termijnBedragMnd);

    if (mndCalculated.isNaN || mndCalculated > maxMaanden) {
      return PairError(
          a: maxMaanden,
          b: _akBerekenAnnuiteit(decimalen, lening, rente, maxMaanden)
              .ceilToDouble());
    } else {
      return PairError(a: mndCalculated, b: termijnBedragMnd);
    }
  }

  static int _akBerekenenMnd(
      int betaling, double lening, double rente, double ann) {
    final a = 1 + rente / 100 / 12;
    final b = rente / 100 / 12;

    double mnd = math.log(1 / (1 - lening / ann * b)) / math.log(a);

    double rest = mnd % 1.0;

    return (rest < 0.01) ? mnd.floor() : mnd.ceil();
  }

  static double _akBerekenAnnuiteit(
      int decimalen, double lening, double rente, int mnd) {
    final a = 1.0 + rente / 100.0 / 12.0;
    final b = rente / 100.0 / 12.0;

    double annBerekend = lening / ((1.0 - 1.0 / math.pow(a, mnd)) / b);

    return _afronden(decimalen, annBerekend);
  }

  static double _afronden(int decimalen, double bedrag) {
    double factor = 1.0;

    for (int i = 0; i < decimalen; i++) {
      factor *= 10.0;
    }

    return (bedrag * factor).ceilToDouble() / factor;
  }

  static double interestPercentage(AflopendKrediet ak) {
    return ak.somInterest / ak.lening * 100.0;
  }
}

class PairError<A, B, E> {
  final A a;
  final B b;
  final E? error;
  final bool hasError;

  PairError(
      {required this.a, required this.b, this.error, this.hasError = false});
}
