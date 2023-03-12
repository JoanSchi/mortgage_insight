const _dagenInMaanden = <int>[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

enum DayOptions { addDays, keepLastDay, keepDayInMonth }

enum PeriodeOpties {
  tot,
  tm,
  eerstedag,
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
      {int jaren = 0,
      int maanden = 0,
      PeriodeOpties periodeOpties = PeriodeOpties.tot}) {
    final huidigeJaar = dateTime.year;
    final huidigeMaand = dateTime.month;
    final huidigeDag = dateTime.day;

    switch (periodeOpties) {
      case PeriodeOpties.tot:
        {
          DateTime dt =
              DateTime(huidigeJaar + jaren, huidigeMaand + maanden, 1);
          final aantalDagenInNieuweMaand =
              dagenPerMaand(jaar: dt.year, maand: dt.month);

          final dag = huidigeDag > aantalDagenInNieuweMaand
              ? aantalDagenInNieuweMaand + 1
              : huidigeDag;

          return DateTime(huidigeJaar + jaren, huidigeMaand + maanden, dag);
        }
      case PeriodeOpties.eerstedag:
        {
          return DateTime(huidigeJaar + jaren, huidigeMaand + maanden, 1);
        }
      default:
        {
          DateTime dt =
              DateTime(huidigeJaar + jaren, huidigeMaand + maanden, 1);
          final aantalDagenInNieuweMaand =
              dagenPerMaand(jaar: dt.year, maand: dt.month);

          final dag = huidigeDag - 1 > aantalDagenInNieuweMaand
              ? aantalDagenInNieuweMaand
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
}

//DateTime add(DateTime dateTime, {int years: 0, int months: 0, DayOptions dayOptions: DayOptions.ADDDAYS}){
//  final currentYear = dateTime.year;
//  final currentMonth = dateTime.month;
//  final currentDay = dateTime.day;
//
////  bool lastDay = dagenPerMaand(jaar: currentYear, maand: currentMonth) == currentDay;
//
////  int newYear;
////  int newMonth;
////  int newDay = currentDay + day;
//
////  if( month > 0){
////    newYear = currentYear + (currentMonth + month)~/12;
////    newMonth = (currentMonth + month)%12;
////  }else if(month < 0){
////    newYear = currentYear - (month)~/12;
////    int left = currentMonth - (month)%12;
////
////    if(left > 0){
////      newMonth = left;
////    }else{
////      newYear--;
////      newMonth = 12 - left;
////    }
////
////  }else{
////    newYear = currentYear;
////    newMonth = currentMonth;
////  }
//
//
//  switch(dayOptions){
//
//    case DayOptions.KEEP_LASTDAY:{
//      int aantalDagenInMaand = dagenPerMaand(jaar: currentYear, maand: currentMonth);
//
//      DateTime dt =  DateTime(currentYear + years, currentMonth + months, 1);
//
//      final aantalDagenInNieuweMaand = dagenPerMaand(jaar: dt.year, maand: dt.month);
//
//      int day =  aantalDagenInMaand == currentDay ? aantalDagenInNieuweMaand : ((aantalDagenInNieuweMaand < currentDay) ? aantalDagenInNieuweMaand : currentDay);
//
//      return DateTime(currentYear + years, currentMonth + months, day);
//
//    }
//
//    case DayOptions.KEEP_DAY_IN_MONTH:{
//      int aantalDagenInMaand = dagenPerMaand(jaar: currentYear, maand: currentMonth);
//
//      DateTime dt =  DateTime(currentYear + years, currentMonth + months, 1);
//
//      final aantalDagenInNieuweMaand = dagenPerMaand(jaar: dt.year, maand: dt.month);
//
//      int day = (aantalDagenInNieuweMaand + days) > aantalDagenInMaand
//            ? aantalDagenInMaand
//            : aantalDagenInNieuweMaand + days;
//
//
//      return DateTime(currentYear + years, currentMonth + months, day);
//  }
//    default:
//      return DateTime(currentYear + years, currentMonth + months, currentDay+ days);
//  }
//
//
//}