import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_lease_auto.dart';

import '../../../model/nl/schulden/schulden.dart';
import 'lease_auto.dart';

class LeaseAutoModel with ChangeNotifier {
  final OperationalLeaseAuto ola;
  LeasAutoInvulPanelState? leasAutoPanelState;

  LeaseAutoModel({
    required this.ola,
  });

  void veranderingOmschrijving(String value) {
    calculatedAndNotify(() => ola.omschrijving = value);
  }

  void veranderingDatum(DateTime value) {
    calculatedAndNotify(() {
      ola.beginDatum = DateUtils.dateOnly(value);
      ola.berekenen();
    });
  }

  void veranderingBedrag(double value) {
    calculatedAndNotify(() {
      ola.mndBedrag = value;
      ola.berekenen();
    });
  }

  void veranderingJaren(int value) {
    calculatedAndNotify(() {
      ola.jaren = value;
      ola.berekenen();
    });
  }

  void veranderingMaanden(int value) {
    calculatedAndNotify(() {
      ola.maanden = value;
      ola.berekenen();
    });
  }

  calculatedAndNotify(VoidCallback berekening) {
    final old = ola.copyWith();

    try {
      berekening();
    } catch (e) {
      ola.berekend = Calculated.withError;
      ola.error = Schuld.unknownError;
    }

    if (old != ola) {
      notifyListeners();
    }
  }
}
