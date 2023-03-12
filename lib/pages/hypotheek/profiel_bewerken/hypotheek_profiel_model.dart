import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_row_box/sliver_row_box_controller.dart';
import '../../../model/nl/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import '../../../model/nl/hypotheek/gegevens/hypotheek_profiel/hypotheek_profiel.dart';
import '../../../model/nl/hypotheek/verwerken/profiel_verwerken.dart';

final profielBewerkenProvider =
    StateNotifierProvider<ProfielBewerkNotifier, HypotheekProfielBewerken>(
        (ref) {
  return ProfielBewerkNotifier(HypotheekProfielBewerken.nieuw());
});

class ProfielBewerkNotifier extends StateNotifier<HypotheekProfielBewerken> {
  ProfielBewerkNotifier(super.state);

  void nieuw() {
    state = HypotheekProfielBewerken.nieuw();
  }

  void verandering({
    String? omschrijving,
    DoelHypotheekOverzicht? doelHypotheekOverzicht,
    bool? inkomensNormToepassen,
    bool? woningWaardeNormToepassen,
    bool? starter,
    required ControllerSliverRowBox controllerSliverRowBox,
  }) {
    final vorige = state.hypotheekProfiel;

    if (vorige == null) {
      return;
    }

    final lOmschrijving = omschrijving ?? vorige.omschrijving;
    final lDoelHypotheekOverzicht =
        doelHypotheekOverzicht ?? vorige.doelHypotheekOverzicht;
    final lInkomensNormToepassen =
        inkomensNormToepassen ?? vorige.inkomensNormToepassen;
    final lWoningWaardeNormToepassen =
        woningWaardeNormToepassen ?? vorige.woningWaardeNormToepassen;
    final lStarter = starter ?? vorige.starter;

    final volgende = vorige.copyWith(
      doelHypotheekOverzicht: lDoelHypotheekOverzicht,
      omschrijving: lOmschrijving,
      inkomensNormToepassen: lInkomensNormToepassen,
      woningWaardeNormToepassen: lWoningWaardeNormToepassen,
      starter: lStarter,
    );

    if (evaluateBoxVisibility(vorige, volgende, controllerSliverRowBox)) {
      state = state.copyWith(hypotheekProfiel: volgende);
    }
  }

  void veranderingEwr({
    bool? ewrToepassing,
    bool? ewrBerekenen,
    double? ewr,
    double? oorspronkelijkeHoofdsom,
    required ControllerSliverRowBox controllerSliverRowBox,
  }) {
    final vorige = state.hypotheekProfiel;
    if (vorige == null) {
      return;
    }

    final e = vorige.eigenWoningReserve;

    bool lEwrToepassen = ewrToepassing ?? e.ewrToepassen;
    bool lEwrBerekenen = ewrBerekenen ?? e.ewrBerekenen;
    double lEwr = ewr ?? e.ewr;
    double lOorspronkelijkeHoofdsom =
        oorspronkelijkeHoofdsom ?? e.oorspronkelijkeHoofdsom;

    final volgende = vorige.copyWith(
        eigenWoningReserve: e.copyWith(
            ewrToepassen: lEwrToepassen,
            ewrBerekenen: lEwrBerekenen,
            ewr: lEwr,
            oorspronkelijkeHoofdsom: lOorspronkelijkeHoofdsom));

    if (evaluateBoxVisibility(vorige, volgende, controllerSliverRowBox)) {
      state = state.copyWith(hypotheekProfiel: volgende);
    }
  }

  void veranderingVorigeWoningKosten({
    double? lening,
    double? woningWaarde,
    List<Waarde>? toevoegen,
    List<Waarde>? verwijderen,
  }) {
    final vorige = state.hypotheekProfiel;
    if (vorige == null) {
      return;
    }
    final k = vorige.vorigeWoningKosten;

    IList<Waarde> kosten = k.kosten;
    if (toevoegen != null) {
      kosten =
          kosten.addAll(toevoegen).sort((a, b) => a.index.compareTo(a.index));
    } else if (verwijderen != null) {
      kosten = kosten.removeAll(verwijderen);
    }

    double lLening = lening ?? k.lening;
    double lWoningWaarde = woningWaarde ?? k.woningWaarde;

    state = state.copyWith(
        hypotheekProfiel: vorige.copyWith(
            vorigeWoningKosten: k.copyWith(
                lening: lLening, woningWaarde: lWoningWaarde, kosten: kosten)));
  }

  Waarde veranderingWaarde(
      {required Waarde waarde,
      String? omschrijving,
      double? getal,
      Eenheid? eenheid,
      bool? aftrekbaar}) {
    final hp = state.hypotheekProfiel;
    if (hp == null) {
      assert(false, 'veranderingWaarde hp is null!');
      return waarde;
    }

    final k = hp.vorigeWoningKosten;
    final lOmschrijving = omschrijving ?? waarde.omschrijving;
    final lGetal = getal ?? waarde.getal;
    final lEenheid = eenheid ?? waarde.eenheid;
    final lAftrekbaar = aftrekbaar ?? waarde.aftrekbaar;

    Waarde nieuwWaarde = waarde.copyWith(
      omschrijving: lOmschrijving,
      getal: lGetal,
      eenheid: lEenheid,
      aftrekbaar: lAftrekbaar,
    );

    IList<Waarde> kosten = k.kosten
        .remove(waarde)
        .add(nieuwWaarde)
        .sort((a, b) => a.index.compareTo(a.index));

    state = state.copyWith(
        hypotheekProfiel:
            hp.copyWith(vorigeWoningKosten: k.copyWith(kosten: kosten)));

    return nieuwWaarde;
  }

  bool evaluateBoxVisibility(HypotheekProfiel vorige, HypotheekProfiel volgende,
      ControllerSliverRowBox controllerSliverRowBox) {
    final zichtbaarVorige =
        HypotheekProfielVerwerken.woningGegevensZichtbaar(vorige);
    final zichtbaarVolgende =
        HypotheekProfielVerwerken.woningGegevensZichtbaar(volgende);

    if (zichtbaarVorige == zichtbaarVolgende) {
      return true;
    }

    final SliverBoxRowRequestFeedBack feedback;

    if (zichtbaarVolgende) {
      feedback = controllerSliverRowBox.appear();
    } else {
      feedback = controllerSliverRowBox.disappear();
    }

    assert(feedback != SliverBoxRowRequestFeedBack.multipleModels,
        'Evaluate Box Visibility Multible Models!');

    return feedback == SliverBoxRowRequestFeedBack.accepted ||
        feedback == SliverBoxRowRequestFeedBack.noModel;
  }
}

class HypotheekProfielBewerken {
  HypotheekProfiel? hypotheekProfiel;

  HypotheekProfielBewerken.nieuw({
    HypotheekProfiel? hypotheekProfiel,
  }) : hypotheekProfiel = const HypotheekProfiel(
          id: '',
        );

  HypotheekProfielBewerken({
    required this.hypotheekProfiel,
  });

  HypotheekProfielBewerken copyWith({
    HypotheekProfiel? hypotheekProfiel,
  }) {
    return HypotheekProfielBewerken(
      hypotheekProfiel: hypotheekProfiel ?? this.hypotheekProfiel,
    );
  }
}

// class HypotheekProfielViewModel with ChangeNotifier {
//   Map<String, dynamic> map = {};

//   RemoveHypotheekProfielen hypotheekProfielen;
//   RemoveHypotheekProfiel? profielOrigineel;
//   late RemoveHypotheekProfiel profiel;

//   bool get isNieuw => profielOrigineel == null;

//   VoidCallback? updateOptieState;
//   HypotheekProfielVorigeWoningPanelState? vorigeWoningPanel;
//   HypotheekProfielEigenWoningReservePanelState? eigenWoningReservePanel;

//   HypotheekProfielViewModel(
//       {required this.hypotheekProfielen, RemoveHypotheekProfiel? profiel})
//       : profielOrigineel = profiel {
//     this.profiel = profiel?.copyWith() ??
//         RemoveHypotheekProfiel(omschrijving: suggestieOmschrijving);

//     bewarenERW();
//   }

//   String get suggestieOmschrijving {
//     //\s whitespace alleen op eind$
//     RegExp exp = RegExp("[0-9]+\\s*\$");

//     int number = 0;

//     for (HypotheekProfielContainer c in hypotheekProfielen.profielen.values) {
//       final match = exp.firstMatch(c.profiel.omschrijving);

//       if (match != null) {
//         final value = match.group(0);

//         if (value != null) {
//           int n = int.parse(value);
//           if (n > number) {
//             number = n;
//           }
//         }
//       }
//     }
//     number++;

//     return 'Profiel $number';
//   }

//   /* Profiel
//    *
//    */

//   void eigenWoningReserveBerekenen(bool value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.eigenReserveWoning.erwBerekenen = value;
//     });
//   }

//   void veranderingOmschrijving(String value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.omschrijving = value;
//     });
//   }

//   void veranderingDoelProfiel(DoelProfielOverzicht value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.doelOverzicht = value;

//       bewarenERW();

//       // kostenAanpassen(
//       //     toevoegen: value == DoelProfielOverzicht.nieuw,
//       //     waarde: WoningGegevens.overdrachtBelasting,
//       //     kostenlijst: profiel.woningGegevens.kosten);

//       aanpassenERW();
//     });
//   }

//   void veranderingDatumWoningKopen(DateTime value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.datumWoningKopen = value;
//     });
//   }

//   void veranderingInkomensNorm(bool value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.inkomensNormToepassen = value;
//     });
//   }

//   void veranderingWoningWaardeToepassen(bool value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.woningWaardeNormToepassen = value;
//     });
//   }

//   // void veranderingNhgToepassen(bool value) {
//   //   calculatedAndNotify(() {
//   //     profiel.nhgToepassen = value;
//   //   });
//   // }

//   void veranderingSituatie(Situatie value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       bewarenERW();
//       profiel.situatie = value;

//       // if (old.situatie == Situatie.starter || value == Situatie.starter) {
//       //   kostenAanpassen(
//       //       toevoegen: value != Situatie.starter,
//       //       waarde: WoningGegevens.overdrachtBelasting,
//       //       kostenlijst: profiel.woningGegevens.kosten);
//       // }
//       aanpassenERW();
//     });
//   }

//   void veranderingERW(bool value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.eigenReserveWoning.erwToepassing = value;
//     });
//   }

//   /// Vorige woning (te verkopen woning)
//   ///
//   ///
//   ///
//   ///
//   void veranderingWoningWaarde(double value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.vorigeWoningGegevens.woningWaarde = value;
//     });
//   }

//   void veranderingHypotheek(double value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.vorigeWoningGegevens.lening = value;
//     });
//   }

//   void veranderingEigenWoningReserve(double value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.eigenReserveWoning.erw = value;
//     });
//   }

//   void veranderingOorspronkelijkeLening(double value) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       profiel.eigenReserveWoning.oorspronkelijkeHoofdsom = value;
//     });
//   }

//   void veranderingToevoegenKostenVorigeWoning(List<RemoveWaarde> toevoegen) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       List<RemoveWaarde> lijst = profiel.vorigeWoningGegevens.kosten;

//       int indexEigenKosten = lijst.isEmpty || lijst.last.index < 1000
//           ? 1000
//           : lijst.last.index + 1;

//       final List<RemoveWaarde> kopie = toevoegen
//           .map((v) => v.id == leegKosten.id
//               ? v.copyWith(index: indexEigenKosten++)
//               : v.copyWith())
//           .toList();

//       _toevoegenKostenVorigeWoningPanel(kopie);

//       kostenToevoegen(
//           toevoegen: kopie, lijst: profiel.vorigeWoningGegevens.kosten);
//     });
//   }

//   _toevoegenKostenVorigeWoningPanel(List<RemoveWaarde> lijst) {
//     vorigeWoningPanel?.itemList
//       ?..addAll(lijst.map((RemoveWaarde v) => SliverBoxItemState<RemoveWaarde>(
//           key: v.key, insertRemoveAnimation: 0.0, value: v, enabled: true)))
//       ..sort((SliverBoxItemState<RemoveWaarde> a,
//               SliverBoxItemState<RemoveWaarde> b) =>
//           a.value.index - b.value.index);
//   }

//   void veranderingVerwijderenKostenVorigeWoning(
//       List<RemoveWaarde> verwijderen) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       kostenVerwijderen(
//           verwijderen: verwijderen, lijst: profiel.vorigeWoningGegevens.kosten);
//     });
//   }

//   veranderingWaardepWoning(
//       {required RemoveWaarde waarde,
//       String? name,
//       double? value,
//       Eenheid? eenheid,
//       bool? aftrekbaar}) {
//     calculatedAndNotify((RemoveHypotheekProfiel old) {
//       waarde.setWaardes(
//           name: name, value: value, eenheid: eenheid, aftrekbaar: aftrekbaar);
//     });
//   }

//   /* Calculate and Notify
//    *
//    */

//   calculatedAndNotify(ValueChanged<RemoveHypotheekProfiel> berekening) {
//     final old = profiel.copyWith();
//     berekening(old);

//     bool _updateOptieState = false;
//     bool _updateEigenWoningReserve = false;
//     bool _updateVorigeWoningState = false;
//     bool berekenen = false;

//     if (old.doelOverzicht != profiel.doelOverzicht) {
//       _updateOptieState = true;
//       _updateEigenWoningReserve = true;
//       _updateVorigeWoningState = true;
//     }

//     if (old.situatie != profiel.situatie) {
//       _updateOptieState = true;
//       _updateEigenWoningReserve = true;
//       _updateVorigeWoningState = true;
//     }

//     if (old.inkomensNormToepassen != profiel.inkomensNormToepassen) {
//       _updateOptieState = true;
//     }

//     if (old.woningWaardeNormToepassen != profiel.woningWaardeNormToepassen) {
//       _updateOptieState = true;
//       berekenen = true;
//     }

//     /// Eigenwoningreserve
//     ///
//     ///

//     if (profiel.eigenReserveWoning != old.eigenReserveWoning) {
//       _updateOptieState = true;
//       _updateEigenWoningReserve = true;
//       _updateVorigeWoningState = true;
//       berekenen = true;
//     }

//     /// Te verkopen / Vorige Woning
//     ///
//     ///

//     if (profiel.vorigeWoningGegevens != old.vorigeWoningGegevens) {
//       _updateVorigeWoningState = true;
//       _updateEigenWoningReserve = true;
//       berekenen = true;
//     }

//     if (profiel.vorigeWoningGegevens.woningWaarde !=
//             old.vorigeWoningGegevens.woningWaarde ||
//         profiel.vorigeWoningGegevens.totaleKosten !=
//             old.vorigeWoningGegevens.totaleKosten) {}

//     /// Bereken hypotheken door
//     ///
//     ///

//     if (berekenen) {
//       // profiel.controleerHypotheken();
//     }

//     /// Update
//     ///
//     ///

//     if (_updateOptieState && updateOptieState != null) {
//       updateOptieState?.call();
//     }

//     if (_updateEigenWoningReserve) {
//       eigenWoningReservePanel?.updateState();
//     }

//     if (_updateVorigeWoningState) {
//       vorigeWoningPanel?.updateState();
//     }
//   }

//   void kostenToevoegen(
//       {required List<RemoveWaarde> toevoegen,
//       required List<RemoveWaarde> lijst}) {
//     lijst
//       ..addAll(toevoegen)
//       ..sort((a, b) => a.index - b.index);
//   }

//   void kostenVerwijderen(
//       {required List<RemoveWaarde> verwijderen,
//       required List<RemoveWaarde> lijst}) {
//     for (RemoveWaarde v in verwijderen) {
//       lijst.remove(v);
//     }
//   }

//   valueToMap(String text, value) {
//     map[text] = value;
//   }

//   valueFromMap(String text, {to, dv}) {
//     final value = map[text];
//     if (value != null || dv != null) {
//       to(value ?? dv);
//     }
//   }

//   void bewarenERW() {
//     switch (profiel.doelOverzicht) {
//       case DoelProfielOverzicht.nieuw:
//         if (profiel.situatie == Situatie.geenKoopwoning) {
//           valueToMap(
//               'erw_geenkoopwoning', profiel.eigenReserveWoning.erwToepassing);
//         }

//         break;
//       case DoelProfielOverzicht.bestaand:
//         valueToMap('erw_bestaand', profiel.eigenReserveWoning.erwToepassing);
//         break;
//     }
//   }

//   void aanpassenERW() {
//     if (profiel.inkomensNormToepassen) {
//       switch (profiel.doelOverzicht) {
//         case DoelProfielOverzicht.nieuw:
//           switch (profiel.situatie) {
//             case Situatie.starter:
//               profiel.eigenReserveWoning.erwToepassing = false;
//               break;
//             case Situatie.koopwoning:
//               profiel.eigenReserveWoning.erwToepassing = true;
//               break;
//             case Situatie.geenKoopwoning:
//               valueFromMap('erw_geenkoopwoning',
//                   to: (v) => profiel.eigenReserveWoning.erwToepassing = v,
//                   dv: false);
//               break;
//           }
//           break;
//         case DoelProfielOverzicht.bestaand:
//           valueFromMap('erw_bestaand',
//               to: (v) => profiel.eigenReserveWoning.erwToepassing = v,
//               dv: false);

//           break;
//       }
//     }
//   }

//   DateTime get datumWoningKopen {
//     final huidigeDatum = DateUtils.dateOnly(DateTime.now());

//     if (profiel.datumWoningKopen.compareTo(huidigeDatum) < 0) {
//       profiel.datumWoningKopen = hypotheekDatumSuggestie;
//     }

//     return profiel.datumWoningKopen;
//   }

//   DateTime get beginDatumWoningKopen => DateUtils.dateOnly(DateTime.now());

//   DateTime get eindDatumWoningKopen =>
//       Kalender.voegPeriodeToe(DateTime.now(), jaren: 5);
// }
