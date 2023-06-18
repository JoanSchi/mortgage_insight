const _dagenInMaanden = <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

enum DayOptions { addDays, keepLastDay, keepDayInMonth }

enum PeriodeOpties {
  volgende,
  eind,
  eersteDag,
  laatsteDag,
}

class Kalender {
  static int dagenPerMaand({required int jaar, required int maand}) {
    // De schrikkeldag valt in de gregoriaanse kalender op 29 februari en komt voor als het jaartal restloos deelbaar is door 4,
    // maar niet door 100 – tenzij het jaartal restloos deelbaar door 400 is. Zo waren 2004, 2008, 2012 en 2016
    // (allemaal deelbaar door 4, maar niet door 100) schrikkeljaren. Ook 1600 (deelbaar door 400) was een schrikkeljaar.
    // 1700, 1800 en 1900 waren dat niet (deelbaar door 100, maar niet door 400) en 2000 weer wel.

    if (maand == 2) {
      bool deelbaarDoorVier = jaar % 4 == 0;
      bool deelbaarDoorHonderd = jaar % 100 == 0;
      bool deelbaarDoorVierHonderd = jaar % 400 == 0;

      return _dagenInMaanden[maand - 1] +
          ((deelbaarDoorVier && !deelbaarDoorHonderd) || deelbaarDoorVierHonderd
              ? 1
              : 0);
    }

    return _dagenInMaanden[maand - 1];
  }

  static DateTime voegPeriodeToe(DateTime dateTime,
      {int jaren = 0, int maanden = 0, required PeriodeOpties periodeOpties}) {
    final huidigeJaar = dateTime.year;
    final huidigeMaand = dateTime.month;
    final huidigeDag = dateTime.day;

    switch (periodeOpties) {
      case PeriodeOpties.volgende:
        {
          DateTime dt =
              DateTime(huidigeJaar + jaren, huidigeMaand + maanden, 1);
          final aantalDagenInNieuweMaand =
              dagenPerMaand(jaar: dt.year, maand: dt.month);

          final dag = huidigeDag > aantalDagenInNieuweMaand
              ? aantalDagenInNieuweMaand
              : huidigeDag;

          return DateTime(huidigeJaar + jaren, huidigeMaand + maanden, dag);
        }
      case PeriodeOpties.eersteDag:
        {
          return DateTime(huidigeJaar + jaren, huidigeMaand + maanden, 1);
        }
      case PeriodeOpties.laatsteDag:
        {
          return DateTime(
              huidigeJaar + jaren,
              huidigeMaand + maanden,
              dagenPerMaand(
                  jaar: huidigeJaar + jaren, maand: huidigeMaand + maanden));
        }
      default:
        {
          DateTime dt =
              DateTime(huidigeJaar + jaren, huidigeMaand + maanden, 1);
          final aantalDagenInNieuweMaand =
              dagenPerMaand(jaar: dt.year, maand: dt.month);

          final dag = huidigeDag - 1 > aantalDagenInNieuweMaand
              ? aantalDagenInNieuweMaand - 1
              : huidigeDag - 1;

          return DateTime(huidigeJaar + jaren, huidigeMaand + maanden, dag);
        }
    }
  }

  static String looptijdInTekst(int mnd) {
    int jaren = mnd ~/ 12;
    int maanden = mnd % 12;

    if (maanden == 0) {
      return 'Looptijd $jaren jaar';
    } else if (jaren == 0) {
      int maand = mnd % 12;
      return 'Looptijd $maand ${maand == 1 ? 'maand' : 'maanden'}.';
    } else {
      return 'Looptijd $jaren jaar en $maanden ${maanden == 1 ? 'maand' : 'maanden'}.';
    }
  }

  static int aantalDagen(DateTime dt1, DateTime dt2) =>
      (dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch).abs() ~/
          Duration.millisecondsPerDay +
      1;

  static int verschilDagen(DateTime dt1, DateTime dt2) =>
      (dt2.millisecondsSinceEpoch - dt1.millisecondsSinceEpoch) ~/
      Duration.millisecondsPerDay;

  static int maandDelta(DateTime startDatum, DateTime eindDatum) {
    return (eindDatum.year - startDatum.year) * 12 +
        eindDatum.month -
        startDatum.month;
  }
}
