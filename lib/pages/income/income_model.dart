import 'package:flutter/material.dart';

import '../../model/nl/inkomen/inkomen.dart';
import '../../utilities/Kalender.dart';
import '../../utilities/date.dart';
import 'income_fields.dart';

class BewerkenInkomen {
  List<Inkomen> lijst;
  DateTime? origineleDatum;
  Inkomen inkomen;
  bool partner;

  BewerkenInkomen.bestaand(
      {required this.lijst, required this.partner, required Inkomen inkomen})
      : origineleDatum = inkomen.datum,
        inkomen = inkomen.copyWith();

  BewerkenInkomen.nieuw({required this.lijst, required this.partner})
      : inkomen = _nieuw(lijst, partner);

  static Inkomen _nieuw(List<Inkomen> list, bool partner) {
    DateTime datum = monthYear(DateTime.now());
    DetailsInkomen inkomen;
    DetailsInkomen pensioenInkomen;
    bool pensioen;

    if (list.isNotEmpty) {
      final last = list.last;

      datum = datum.compareTo(last.datum) <= 0
          ? Kalender.voegPeriodeToe(last.datum, maanden: 1)
          : datum;

      inkomen = last.specificatie.copyWith(brutoJaar: 0.0, brutoMaand: 0.0);

      pensioenInkomen =
          last.pensioenSpecificatie.copyWith(brutoJaar: 0.0, brutoMaand: 0.0);

      pensioen = last.pensioen;
    } else {
      pensioen = false;
      inkomen = DetailsInkomen();
      pensioenInkomen = DetailsInkomen();
    }
    return Inkomen(
        datum: datum,
        partner: partner,
        pensioen: pensioen,
        indexatie: 0.01,
        specificatie: inkomen,
        pensioenSpecificatie: pensioenInkomen);
  }

  DateTime get datum => inkomen.datum;
}

class InkomenModel with ChangeNotifier {
  final BewerkenInkomen bewerkenInkomen;
  late PensioenEvaluatie pensioenEvaluatie;
  IncomeFieldFormState? incomeFieldFormState;

  Inkomen get inkomen => bewerkenInkomen.inkomen;

  List<Inkomen> get lijst => bewerkenInkomen.lijst;

  bool get partner => bewerkenInkomen.partner;

  DateTime? get origineleDatum => bewerkenInkomen.origineleDatum;

  InkomenModel({
    required this.bewerkenInkomen,
  }) {
    evaluatiePensioenOptie();
  }

  void veranderingDatum(DateTime value) {
    calculatedAndNotify(() {
      inkomen.datum = value;
      evaluatiePensioenOptie();
      vervangAlsDatumBestaat();
    });
  }

  void veranderingJaarInkomenUit(JaarInkomenUit value, bool pensioen) {
    calculatedAndNotify(() {
      (pensioen ? inkomen.pensioenSpecificatie : inkomen.specificatie)
          .jaarInkomenUit = value;
    });
  }

  void veranderingBrutoJaar(double value, bool pensioen) {
    calculatedAndNotify(() {
      (pensioen ? inkomen.pensioenSpecificatie : inkomen.specificatie)
          .brutoJaar = value;
    });
  }

  void veranderingBrutoMaand(double value, bool pensioen) {
    calculatedAndNotify(() {
      (pensioen ? inkomen.pensioenSpecificatie : inkomen.specificatie)
          .brutoMaand = value;
    });
  }

  void veranderingVakantiegeld(bool value) {
    calculatedAndNotify(() {
      inkomen.specificatie.vakantiegeld = value;
    });
  }

  void veranderingDertiendeMaand(bool value) {
    calculatedAndNotify(() {
      inkomen.specificatie.dertiendeMaand = value;
    });
  }

  calculatedAndNotify(VoidCallback berekening) {
    final old = inkomen.copyWith();

    try {
      berekening();
      bool refreshState = false;

      if (old.pensioen != inkomen.pensioen) {
        refreshState = true;
      }

      if (old.specificatie.jaarInkomenUit !=
          inkomen.specificatie.jaarInkomenUit) {
        refreshState = true;
      }

      if (old.pensioenSpecificatie.jaarInkomenUit !=
          inkomen.pensioenSpecificatie.jaarInkomenUit) {
        refreshState = true;
      }

      if (old.specificatie.brutoJaar != inkomen.specificatie.brutoJaar) {
        incomeFieldFormState
            ?.setBrutoJaarInkomen(inkomen.specificatie.brutoJaar);
      }

      if (old.specificatie.brutoMaand != inkomen.specificatie.brutoMaand) {
        incomeFieldFormState
            ?.setBrutoMaandInkomen(inkomen.specificatie.brutoMaand);
      }

      if (old.specificatie.vakantiegeld != inkomen.specificatie.vakantiegeld) {
        refreshState = true;
      }

      if (old.specificatie.dertiendeMaand !=
          inkomen.specificatie.dertiendeMaand) {
        refreshState = true;
      }

      if (old.pensioenSpecificatie.brutoJaar !=
          inkomen.pensioenSpecificatie.brutoJaar) {
        incomeFieldFormState?.setBrutoJaarInkomenPensioen(
            inkomen.pensioenSpecificatie.brutoJaar);
      }

      if (old.specificatie.brutoMaand != inkomen.specificatie.brutoMaand) {
        incomeFieldFormState?.setBrutoMaandInkomenPensioen(
            inkomen.pensioenSpecificatie.brutoMaand);
      }

      if (refreshState) {
        incomeFieldFormState?.refreshState();
      }
    } catch (e) {
      // dk.berekend = Calculated.withError;
      // dk.error = Schuld.unknownError;
    }

    if (old != inkomen) {
      notifyListeners();
    }
  }

  void evaluatiePensioenOptie() {
    for (Inkomen i in lijst) {
      int delta = DateUtils.monthDelta(inkomen.datum, i.datum);

      if (delta < 0 && i.pensioen) {
        //Negative delta: date after item date.

        pensioenEvaluatie =
            PensioenEvaluatie(enable: false, pensioen: true, blockItem: i);
      } else if (delta > 0) {
        //Positive delta: date before item date.
        if (i.pensioen) {
          pensioenEvaluatie = PensioenEvaluatie(enable: true, blockItem: i);
        } else {
          pensioenEvaluatie =
              PensioenEvaluatie(enable: false, pensioen: false, blockItem: i);
        }
      }
    }

    pensioenEvaluatie = PensioenEvaluatie(enable: true);

    if (pensioenEvaluatie.pensioen != null) {
      inkomen.pensioen = pensioenEvaluatie.pensioen!;
    }
  }

  void vervangAlsDatumBestaat() {
    for (Inkomen i in lijst) {
      if (DateUtils.monthDelta(inkomen.datum, i.datum) == 0) {
        bewerkenInkomen.inkomen = i.copyWith();
        bewerkenInkomen.origineleDatum = i.datum;
        break;
      }
    }
  }
}

class PensioenEvaluatie {
  bool enable;
  bool? pensioen;
  Inkomen? blockItem;

  PensioenEvaluatie({
    required this.enable,
    this.pensioen,
    this.blockItem,
  });
}
