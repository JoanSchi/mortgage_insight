import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/gereedschap/datum_id.dart';
import 'package:hypotheek_berekeningen/hypotheek_document/hypotheek_document.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';

mixin SchuldNotifier on StateNotifier<HypotheekDocument> {
  schuldToevoegen(Schuld schuld) {
    IList<Schuld> list = state.schuldenOverzicht.lijst;

    if (schuld.id.isEmpty) {
      list = list.add(schuld.copyWith(
          id: DatumId.toDayIdToString<Schuld>(list,
              toString: (Schuld schuld) => schuld.id)));
    } else {
      final index = list.indexWhere((Schuld s) => s.id == schuld.id);
      if (index == -1) {
        list = list.add(schuld);
      } else {
        list = list.replace(index, schuld);
      }
    }
    state = state.copyWith.schuldenOverzicht(lijst: list);
  }

  schuldVerwijderen(Schuld schuld) {
    state = state.copyWith.schuldenOverzicht(
        lijst: state.schuldenOverzicht.lijst
            .removeWhere((Schuld s) => s.id == schuld.id));
  }
}
