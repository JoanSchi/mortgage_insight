import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utilities/date.dart';
import '../../schulden/schulden.dart';
import '../hypotheek_document.dart';

mixin SchuldNotifier on StateNotifier<HypotheekDocument> {
  schuldToevoegen(Schuld schuld) {
    IList<Schuld> list = state.schuldenOverzicht.lijst;

    if (schuld.id == -1) {
      int dt = dateID;

      while (true) {
        if (list.indexWhere((Schuld s) => s.id == dt) == -1) {
          list = list.add(schuld.copyWith(id: dt));
          break;
        }
        dt++;
      }
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
