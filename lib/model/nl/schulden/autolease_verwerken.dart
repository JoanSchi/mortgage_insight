import 'package:mortgage_insight/model/nl/schulden/schulden.dart';
import '../../../utilities/kalender.dart';

class LeaseAutoVerwerken {
  static datumVanafRegistratie(LeaseAuto leaseAuto,
      {required DateTime huidigeDatum,
      required Function bereken,
      required Function fout}) {
    final status = leaseAuto.dateStatus(huidigeDatum);

    DateTime datum;

    switch (status) {
      case DateStatus.now:
        datum = huidigeDatum;
        break;
      case DateStatus.before:
        datum = leaseAuto.beginDatum;
        break;
      case DateStatus.after:
        datum = leaseAuto.eindDatum;
        break;
    }

    DateTime vanaf = DateTime(2022, 4, 1);

    if (vanaf.compareTo(datum) <= 0) {
      return bereken(datum, vanaf, 100.0);
    }

    vanaf = DateTime(2016, 1, 1);

    if (vanaf.compareTo(datum) <= 0) {
      return bereken(datum, vanaf, 100.0);
    }

    return fout(datum, vanaf, 100.0);
  }

  static double maandLast(LeaseAuto leaseAuto, DateTime huidige) {
    if (huidige.compareTo(leaseAuto.beginDatum) < 0 ||
        huidige.compareTo(leaseAuto.eindDatum) > 0) {
      return 0.0;
    }

    DateTime vanaf = DateTime(2022, 4, 1);

    if (vanaf.compareTo(huidige) <= 0) {
      return leaseAuto.mndBedrag;
    }

    vanaf = DateTime(2016, 1, 1);

    if (vanaf.compareTo(huidige) <= 0) {
      return leaseAuto.mndBedrag * 0.65;
    }
    return -1;
  }

  static DateTime eindDatum(LeaseAuto leaseAuto) =>
      Kalender.voegPeriodeToe(leaseAuto.beginDatum,
          jaren: leaseAuto.jaren,
          maanden: leaseAuto.maanden,
          periodeOpties: PeriodeOpties.tot);

  static LeaseAuto verandering(LeaseAuto leaseAuto,
      {DateTime? datum, double? bedrag, int? jaren, int? maanden}) {
    final DateTime lDatum = datum ?? leaseAuto.beginDatum;
    final double lBedrag = bedrag ?? leaseAuto.mndBedrag;
    final int lJaren = jaren ?? leaseAuto.jaren;
    final int lMaanden = maanden ?? leaseAuto.maanden;

    return leaseAuto.copyWith(
        beginDatum: lDatum,
        mndBedrag: lBedrag,
        jaren: lJaren,
        maanden: lMaanden,
        statusBerekening:
            isBerekend(mndBedrag: lBedrag, jaren: lJaren, maanden: lMaanden));
  }

  static StatusBerekening isBerekend(
      {required double mndBedrag, required int jaren, required int maanden}) {
    if (mndBedrag > 0.0 && jaren > 0 || maanden > 0) {
      return StatusBerekening.berekend;
    } else {
      return StatusBerekening.nietBerekend;
    }
  }

  static Map<String, dynamic> overzicht(
      LeaseAuto leaseAuto, DateTime huidigeDatum) {
    if (leaseAuto.statusBerekening == StatusBerekening.fout) {
      return {'fout': 'Een onbekende fout is opgetreden.'};
    }

    return datumVanafRegistratie(leaseAuto,
        huidigeDatum: huidigeDatum,
        bereken:
            (DateTime datum, DateTime vanaf, double registratiePercentage) => {
                  'begin': leaseAuto.beginDatum,
                  'eind': leaseAuto.eindDatum,
                  'datum': datum,
                  'vanaf': vanaf,
                  'mndBedrag': leaseAuto.mndBedrag,
                  'maandlast':
                      leaseAuto.mndBedrag / 100.0 * registratiePercentage,
                  'registratiePercentage': registratiePercentage,
                  'registratieBedrag': leaseAuto.mndBedrag *
                      (leaseAuto.maanden + leaseAuto.jaren * 12.0) /
                      100.0 *
                      registratiePercentage
                },
        fout: (DateTime datum, DateTime vanaf, double registratiePercentage) =>
            {'fout': 'Maandlast kan pas vanaf 2016 berekend worden.'});
  }
}
