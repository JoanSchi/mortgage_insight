import 'package:flutter/material.dart';
import '../../model/nl/schulden/schulden.dart';
import '../../model/nl/schulden/schulden_doorlopend_krediet.dart';
import 'doorlopend_krediet.dart';

class DoorlopendKredietModel with ChangeNotifier {
  final DoorlopendKrediet dk;
  DoorlopendKredietInvulPanelState? doorlopendKredietInvulPanelState;

  DoorlopendKredietModel({
    required this.dk,
  });

  void veranderingOmschrijving(String value) {
    calculatedAndNotify(() => dk.omschrijving = value);
  }

  void veranderingBegindatum(DateTime value) {
    calculatedAndNotify(() {
      dk.beginDatum = DateUtils.dateOnly(value);
      dk.berekenen();
    });
  }

  void veranderingEinddatum(DateTime value) {
    calculatedAndNotify(() {
      dk.eindDatum = DateUtils.dateOnly(value);
      dk.berekenen();
    });
  }

  void veranderingHeeftEinddatum(bool value) {
    calculatedAndNotify(() {
      dk.heeftEindDatum = value;
      dk.berekenen();
    });
  }

  void veranderingBedrag(double value) {
    calculatedAndNotify(() {
      dk.bedrag = value;
      dk.berekenen();
    });
  }

  calculatedAndNotify(VoidCallback berekening) {
    final old = dk.copyWith();

    try {
      berekening();

      if (old.heeftEindDatum != dk.heeftEindDatum) {
        doorlopendKredietInvulPanelState?.setHeeftEinddatum(dk.heeftEindDatum);
      }

      if (dk.heeftEindDatum) {
        DateTime newEindDatum = dk.eindDatumInbeReik();

        if (newEindDatum != dk.eindDatum) {
          dk.eindDatum = newEindDatum;
          doorlopendKredietInvulPanelState?.setNieuwEindDatum(newEindDatum);
        }
      }
    } catch (e) {
      dk.berekend = Calculated.withError;
      dk.error = Schuld.unknownError;
    }

    if (old != dk) {
      notifyListeners();
    }
  }
}
