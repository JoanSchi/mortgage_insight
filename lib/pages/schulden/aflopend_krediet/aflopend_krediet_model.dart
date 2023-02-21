import 'package:flutter/material.dart';
import '../../../model/nl/schulden/remove_schulden.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../model/nl/schulden/remove_schulden_aflopend_krediet.dart';
import 'aflopend_krediet_segmenten.dart';

class AflopendKredietModel with ChangeNotifier {
  final RemoveAflopendKrediet ak;
  AflopendkredietInvulPanelState? aflopendkredietInvulPanelState;
  AflopendKredietOptiePanelState? aflopendKredietOptiePanelState;

  AflopendKredietModel({
    required this.ak,
  });

  void veranderingOmschrijving(String value) {
    calculatedAndNotify(() => ak.omschrijving = value);
  }

  void veranderingAfronden(int afronding) {
    calculatedAndNotify(() => ak.setAfronden(afronding));
  }

  void veranderingBetaling(AKbetaling betaling) {
    calculatedAndNotify(() => ak
      ..betaling = betaling
      ..bereken());
  }

  void veranderingRenteGebrokenMaand(bool value) {
    calculatedAndNotify(() => ak
      ..renteGebrokenMaand = value
      ..bereken());
  }

  void veranderingDate(DateTime date) {
    if (ak.beginDatum != date) {
      calculatedAndNotify(() {
        ak.beginDatum = DateUtils.dateOnly(date);
        ak.bereken();
      });
    }
  }

  veranderingLening(double value) {
    if (value != ak.lening || ak.berekend != StatusBerekening.berekend) {
      calculatedAndNotify(() => ak
        ..lening = value
        ..berekenenTermijnBedrag());
    }
  }

  veranderingRente(double value) {
    if (value != ak.rente || ak.berekend != StatusBerekening.berekend) {
      calculatedAndNotify(() => ak
        ..rente = value
        ..berekenenTermijnBedrag());
    }
  }

  veranderingTermijnBedrag(double value) {
    if (value != ak.termijnBedragMnd ||
        ak.berekend != StatusBerekening.berekend) {
      calculatedAndNotify(() => ak
        ..termijnBedragMnd = value
        ..berekenLooptijd());
    }
  }

  veranderingLooptijd(int value) {
    if (value != ak.maanden || ak.berekend != StatusBerekening.berekend) {
      calculatedAndNotify(() => ak
        ..maanden = value
        ..berekenenTermijnBedrag());
    }
  }

  calculatedAndNotify(VoidCallback berekening) {
    final old = ak.copyWith();

    try {
      berekening();

      if (old.decimalen != ak.decimalen) {
        aflopendKredietOptiePanelState?.setAfronden();
      }

      if (old.betaling != ak.betaling) {
        aflopendKredietOptiePanelState?.setBetaling();
      }

      if (old.lening != ak.lening) {
        aflopendkredietInvulPanelState?.setLening(ak.lening);
      }

      if (old.rente != ak.rente) {
        aflopendkredietInvulPanelState?.setRente(ak.rente);
      }

      if (old.termijnBedragMnd != ak.termijnBedragMnd) {
        aflopendkredietInvulPanelState?.setTermijnBedrag(ak.termijnBedragMnd);
      }

      if (old.maanden != ak.maanden) {
        aflopendkredietInvulPanelState?.setMaanden(ak.maanden);
      }
    } catch (e) {
      ak.berekend = StatusBerekening.fout;
      ak.error = RemoveSchuld.unknownError;
    }

    if (old != ak) {
      notifyListeners();
    }
  }
}
