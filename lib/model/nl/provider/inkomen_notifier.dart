import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek_document/hypotheek_document.dart';
import 'package:hypotheek_berekeningen/inkomen/gegevens/inkomen.dart';

mixin InkomenNotifier on StateNotifier<HypotheekDocument> {
  IList<Inkomen> inkomenLijst(bool partner) => (partner
      ? state.inkomenOverzicht.inkomenPartner
      : state.inkomenOverzicht.inkomen);

  void inkomenToevoegen({
    required DateTime? oldDate,
    required Inkomen newItem,
  }) {
    IList<Inkomen> lijst = (newItem.partner
        ? state.inkomenOverzicht.inkomenPartner
        : state.inkomenOverzicht.inkomen);

    if (oldDate != null) {
      final totalMonthsOldDate = oldDate.year * 12 + oldDate.month;

      lijst = lijst.removeWhere((element) {
        final totalMonths = element.datum.year * 12 + element.datum.month;
        return totalMonthsOldDate == totalMonths;
      });
    }

    merged:
    {
      int length = lijst.length;

      final totalMonthsNewItem = newItem.datum.year * 12 + newItem.datum.month;

      for (int i = 0; i < length; i++) {
        final element = lijst[i];

        final totalMonthsOfElement =
            element.datum.year * 12 + element.datum.month;

        if (totalMonthsNewItem == totalMonthsOfElement) {
          lijst = lijst.replace(i, newItem);
          break merged;
        } else if (totalMonthsNewItem < totalMonthsOfElement) {
          lijst = lijst.insert(i, newItem);
          break merged;
        }
      }

      lijst = lijst.add(newItem);
    }

    state = (newItem.partner)
        ? state.copyWith(
            inkomenOverzicht:
                state.inkomenOverzicht.copyWith(inkomenPartner: lijst))
        : state.copyWith(
            inkomenOverzicht: state.inkomenOverzicht.copyWith(inkomen: lijst));
  }

  void inkomenVerwijderen({required Inkomen inkomen, required bool partner}) {
    IList<Inkomen> lijst = (partner
        ? state.inkomenOverzicht.inkomenPartner
        : state.inkomenOverzicht.inkomen);

    lijst = lijst.removeWhere((Inkomen element) {
      final totalMonthsOfElement =
          element.datum.year * 12 + element.datum.month;

      final totalMonthsNewItem = inkomen.datum.year * 12 + inkomen.datum.month;

      return totalMonthsOfElement == totalMonthsNewItem;
    });

    state = (inkomen.partner)
        ? state.copyWith(
            inkomenOverzicht:
                state.inkomenOverzicht.copyWith(inkomenPartner: lijst))
        : state.copyWith(
            inkomenOverzicht: state.inkomenOverzicht.copyWith(inkomen: lijst));
  }
}
