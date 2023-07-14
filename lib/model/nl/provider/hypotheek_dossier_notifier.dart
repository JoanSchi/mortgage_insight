import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier_overzicht/hypotheek_dossier_overzicht.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_verwerken.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheekdossier_verwerken.dart';
import 'package:hypotheek_berekeningen/hypotheek_document/hypotheek_document.dart';

mixin HypotheekDossierNotifier on StateNotifier<HypotheekDocument> {
  void hypotheekDossierToevoegen({
    required HypotheekDossier hypotheekDossier,
  }) {
    IMap<String, HypotheekDossier> map =
        state.hypotheekDossierOverzicht.hypotheekDossiers;

    final id = hypotheekDossier.id;

    state = state.copyWith.hypotheekDossierOverzicht(
        hypotheekDossiers: map.add(id, hypotheekDossier), geselecteerd: id);
  }

  void hypotheekDossierVerwijderen({
    required HypotheekDossier hypotheekDossier,
  }) {
    final overzicht = state.hypotheekDossierOverzicht;

    IMap<String, HypotheekDossier> map = overzicht.hypotheekDossiers
        .removeWhere((String id, _) => id == hypotheekDossier.id);

    String geselecteerd = overzicht.geselecteerd;

    if (map.isEmpty) {
      geselecteerd = '';
    } else if (!map.containsKey(geselecteerd)) {
      geselecteerd = map.keys.last;
    }

    state = state.copyWith.hypotheekDossierOverzicht(
        hypotheekDossiers: map, geselecteerd: geselecteerd);
  }

  void selecteerHypotheekDossier(
    HypotheekDossier hypotheekDossier,
  ) {
    state = state.copyWith
        .hypotheekDossierOverzicht(geselecteerd: hypotheekDossier.id);
  }

  bool hypotheekVerwijderen(Hypotheek hypotheek) {
    HypotheekDossierOverzicht overzicht = state.hypotheekDossierOverzicht;
    HypotheekDossier? hypotheekDossier = overzicht.hypotheekDossierGeselecteerd;

    if (hypotheekDossier == null) {
      return false;
    }

    bool vervolgVerwijderd = false;
    (hypotheekDossier, vervolgVerwijderd) =
        HypotheekDossierVerwerken.hypotheekVerwijderen(
            hypotheekDossier, hypotheek);

    state = state.copyWith(
        hypotheekDossierOverzicht: overzicht.copyWith(
            hypotheekDossiers: overzicht.hypotheekDossiers
                .add(overzicht.geselecteerd, hypotheekDossier)));

    return vervolgVerwijderd;
  }
}
