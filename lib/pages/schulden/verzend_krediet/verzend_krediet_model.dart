import 'package:flutter/material.dart';
import 'package:mortgage_insight/pages/schulden/verzend_krediet/verzend_krediet.dart';
import 'package:mortgage_insight/model/nl/schulden/remove_schulden_verzend_krediet.dart';
import '../../../model/nl/schulden/remove_schulden.dart';
import '../../../model/nl/schulden/schulden.dart';

class VerzendhuisKredietModel with ChangeNotifier {
  final RemoveVerzendhuisKrediet vk;
  VerzendKredietOptiePanelState? verzendKredietOptiePanelState;

  VerzendhuisKredietModel({
    required this.vk,
  });

  veranderingOmschrijving(String value) {
    calculatedAndNotify(() {
      vk.omschrijving = value;
    });
  }

  veranderingDatum(DateTime value) {
    calculatedAndNotify(() {
      vk.beginDatum = DateUtils.dateOnly(value);
    });
  }

  veranderingAfronden(int value) {
    calculatedAndNotify(() {
      vk.decimalen = value;
      vk.berekenen();
    });
  }

  void veranderingSlottermijn(double value) {
    calculatedAndNotify(() {
      vk.slotTermijn = value;
      vk.berekenen();
    });
  }

  void veranderingBedrag(double value) {
    calculatedAndNotify(() {
      vk.bedrag = value;
      vk.berekenen();
    });
  }

  void veranderingSlotTermijnOptie(bool value) {
    calculatedAndNotify(() {
      vk.heeftSlotTermijn = value;
      vk.berekenen();
    });
  }

  void veranderingMaanden(int value) {
    calculatedAndNotify(() {
      vk.maanden = value;
      vk.berekenen();
    });
  }

  void veranderingBedragPerMaandOfTotaal(bool value) {
    calculatedAndNotify(() {
      vk.isTotalbedrag = value;

      vk.heeftSlotTermijn =
          vk.slotTermijn != 0.0 && vk.slotTermijn != vk.mndBedrag;
    });
  }

  calculatedAndNotify(VoidCallback berekening) {
    final old = vk.copyWith();

    try {
      berekening();
      bool refreshState = false;

      if (old.bedrag != vk.bedrag) {
        verzendKredietOptiePanelState?.setBedrag(vk.bedrag);
      }

      if (old.slotTermijn != vk.slotTermijn) {
        verzendKredietOptiePanelState?.setSlottermijnWaarde(vk.slotTermijn);
        refreshState = true;
      }

      if (old.heeftSlotTermijn != vk.heeftSlotTermijn) {
        verzendKredietOptiePanelState?.showSlotTermijnEditBox();
        refreshState = true;
      }

      if (old.isTotalbedrag != vk.isTotalbedrag) {
        verzendKredietOptiePanelState
            ?.setBedragPerMaandOfTotaal(vk.isTotalbedrag);
        refreshState = true;
      }

      if (old.maanden != vk.maanden) {
        verzendKredietOptiePanelState?.setMaanden(vk.maanden);
        refreshState = true;
      }

      if (old.decimalen != vk.decimalen) {
        refreshState = true;
      }

      if (refreshState) {
        verzendKredietOptiePanelState?.refreshState();
      }
    } catch (e) {
      vk.berekend = StatusBerekening.fout;
      vk.error = RemoveSchuld.unknownError;
    }

    if (old != vk) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    verzendKredietOptiePanelState = null;
    super.dispose();
  }
}
