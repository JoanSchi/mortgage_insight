import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/utilities/date.dart';
import '../../hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import '../hypotheek_document.dart';

mixin HypotheekDossierNotifier on StateNotifier<HypotheekDocument> {
  void hypotheekDossierToevoegen({
    required HypotheekDossier hypotheekDossier,
  }) {
    IMap<int, HypotheekDossier> map =
        state.hypotheekDossierOverzicht.hypotheekDossiers;

    int id = hypotheekDossier.id;

    if (id == -1) {
      id = dateID;
      for (int key in map.keys) {
        if (id <= key) {
          id = key + 1;
        }
      }
      hypotheekDossier = hypotheekDossier.copyWith(id: id);
    }

    state = state.copyWith.hypotheekDossierOverzicht(
        hypotheekDossiers: map.add(id, hypotheekDossier), geselecteerd: id);
  }

  void hypotheekDossierVerwijderen({
    required HypotheekDossier hypotheekDossier,
  }) {
    final overzicht = state.hypotheekDossierOverzicht;

    IMap<int, HypotheekDossier> map = overzicht.hypotheekDossiers
        .removeWhere((int id, _) => id == hypotheekDossier.id);

    int geselecteed = overzicht.geselecteerd;

    if (map.isEmpty) {
      geselecteed = -1;
    } else if (!map.containsKey(geselecteed)) {
      for (int key in map.keys) {
        if (geselecteed < key) {
          geselecteed = key;
        }
      }
    }

    state = state.copyWith.hypotheekDossierOverzicht(
        hypotheekDossiers: map, geselecteerd: geselecteed);
  }

  void selecteerHypotheekDossier(
    HypotheekDossier hypotheekDossier,
  ) {
    state = state.copyWith
        .hypotheekDossierOverzicht(geselecteerd: hypotheekDossier.id);
  }
}
