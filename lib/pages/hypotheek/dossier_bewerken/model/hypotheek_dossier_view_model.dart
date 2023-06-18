// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:animated_sliver_box/sliver_box_controller.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/gereedschap/datum_id.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_sliver_box_model.dart';
import '../../../../my_widgets/animated_sliver_widgets/box_properties_constants.dart';
import '../../../../my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';
import 'hypotheek_dossier_view_state.dart';

final hypotheekDossierProvider = StateNotifierProvider<
    HypotheekDossierBewerkenNotifier, HypotheekDossierViewState>((ref) {
  return HypotheekDossierBewerkenNotifier(HypotheekDossierViewState(
      hypotheekDossier: const HypotheekDossier(),
      controllerVorigeWoningKosten:
          SliverBoxController<DossierSliverBoxModel>()));
});

class HypotheekDossierBewerkenNotifier
    extends StateNotifier<HypotheekDossierViewState> {
  HypotheekDossierBewerkenNotifier(super.state);

  void bewerken(
      {IMap<String, HypotheekDossier>? dossiers,
      HypotheekDossier? hypotheekDossier}) {
    assert((hypotheekDossier == null && dossiers != null) ||
        hypotheekDossier != null);

    state = state.copyWith(
        hypotheekDossier: hypotheekDossier ??
            HypotheekDossier(
                id: '${DatumId.toDayId(
              dossiers?.keys ?? const <String>[],
              toString: (String value) => value,
            )}'));
  }

  void verandering(
      {String? omschrijving,
      DoelHypotheekOverzicht? doelHypotheekOverzicht,
      bool? inkomensNormToepassen,
      bool? woningWaardeNormToepassen,
      bool? starter,
      bool? eigenWoning,
      double? woningWaarde,
      double? oorspronkelijkeHoofdsom,
      double? restSchuld,
      bool? ewrToepassen,
      bool? ewrBerekenen,
      double? ewr}) {
    final hd = state.hypotheekDossier;

    final lOmschrijving = omschrijving ?? hd.omschrijving;
    final lDoelHypotheekOverzicht =
        doelHypotheekOverzicht ?? hd.doelHypotheekOverzicht;
    final lInkomensNormToepassen =
        inkomensNormToepassen ?? hd.inkomensNormToepassen;
    final lWoningWaardeNormToepassen =
        woningWaardeNormToepassen ?? hd.woningWaardeNormToepassen;

    final lWoningWaarde = woningWaarde ?? hd.woningWaarde;
    final lOorspronkelijkeHoofdsom =
        oorspronkelijkeHoofdsom ?? hd.oorspronkelijkeHoofdsom;
    final lRestSchuld = restSchuld ?? hd.restSchuld;

    bool lEwrBerekenen = ewrBerekenen ?? hd.ewrBerekenen;
    double lEwr = ewr ?? hd.ewr;

    if (starter == true) {
      eigenWoning = false;
      ewrToepassen = false;
    } else if (eigenWoning == true) {
      starter = false;
      ewrToepassen = false;
    } else if (ewrToepassen == true) {
      starter = false;
      eigenWoning = false;
    }
    final lStarter = starter ?? hd.starter;
    final lEigenWoning = eigenWoning ?? hd.eigenWoning;
    final lEwrToepassen = ewrToepassen ?? hd.ewrToepassen;

    final volgende = hd.copyWith(
        doelHypotheekOverzicht: lDoelHypotheekOverzicht,
        omschrijving: lOmschrijving,
        inkomensNormToepassen: lInkomensNormToepassen,
        woningWaardeNormToepassen: lWoningWaardeNormToepassen,
        starter: lStarter,
        eigenWoning: lEigenWoning,
        woningWaarde: lWoningWaarde,
        ewrToepassen: lEwrToepassen,
        ewrBerekenen: lEwrBerekenen,
        ewr: lEwr,
        oorspronkelijkeHoofdsom: lOorspronkelijkeHoofdsom,
        restSchuld: lRestSchuld);

    if (evaluateBoxVisibility(
        hd, volgende, state.controllerVorigeWoningKosten)) {
      state = state.copyWith(hypotheekDossier: volgende);
    }
  }

  veranderingKostenToevoegen(List<Waarde> lijst, {Waarde? positie}) {
    final hypotheekDossier = state.hypotheekDossier;
    IList<Waarde> kosten = hypotheekDossier.kosten;

    int index = (positie != null)
        ? hypotheekDossier.kosten.indexOf(positie)
        : kosten.length;

    int id =
        DatumId.toDayId(hypotheekDossier.kosten, toString: (Waarde v) => v.id);

    lijst = [
      for (Waarde w in lijst) w.standaard ? w : w.copyWith(id: '${id++}')
    ];

    final feedback = state.controllerVorigeWoningKosten.feedBackTryModel(
        (DossierSliverBoxModel model) =>
            model.changeGroups(changeSingleBoxModels: [
              ChangeSingleModel<String, KostenItemBoxProperties>(
                  model.dossierBox, (List<KostenItemBoxProperties> list) {
                list.insertAll(index, [
                  for (Waarde w in lijst)
                    KostenItemBoxProperties(
                        single: true,
                        value: w,
                        transitionStatus: BoxItemTransitionState.insert,
                        id: w.id,
                        panel: BoxPropertiesPanels.edit)
                ]);
              }, SliverBoxAction.animate)
            ], checkAllGroups: false));

    if (feedback == SliverBoxRequestFeedBack.accepted ||
        feedback == SliverBoxRequestFeedBack.noModel) {
      kosten = kosten.insertAll(index, lijst);

      state = state.copyWith(
          hypotheekDossier: hypotheekDossier.copyWith(kosten: kosten));
    } else {
      debugPrint('Insertion not accepted, because busy with $feedback');
    }
  }

  void veranderingKostenVerwijderen(Waarde verwijderen) {
    final hypotheekDossier = state.hypotheekDossier;

    final feedback = state.controllerVorigeWoningKosten.feedBackTryModel(
        (DossierSliverBoxModel model) =>
            model.changeSingleModel<KostenItemBoxProperties>(
                singleBoxModel: model.dossierBox,
                change: (List<KostenItemBoxProperties> list) {
                  for (KostenItemBoxProperties properties in list) {
                    if (verwijderen == properties.value) {
                      properties
                        ..single = true
                        ..transitionStatus = BoxItemTransitionState.remove;
                    }
                  }
                },
                evaluateVisibleItems: true));

    if (feedback == SliverBoxRequestFeedBack.accepted) {
      state = state.copyWith(
          hypotheekDossier: hypotheekDossier.copyWith(
              kosten: hypotheekDossier.kosten.remove(verwijderen)));
    } else {
      debugPrint('Insertion not accepted, because busy with $feedback');
    }
  }

  Waarde veranderingWaarde(
      {required Waarde waarde,
      String? omschrijving,
      double? getal,
      Eenheid? eenheid,
      bool? aftrekbaar}) {
    final hp = state.hypotheekDossier;

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

    IList<Waarde> kosten = hp.kosten.replaceFirstWhere(
        (Waarde w) => waarde == w, (Waarde? w) => nieuwWaarde,
        addIfNotFound: true);

    final items = state.controllerVorigeWoningKosten.tryModel?.dossierBox.items;

    if (items != null) {
      for (var properties in items) {
        if (properties.value == waarde) {
          properties.value = nieuwWaarde;
        }
      }
    }

    state = state.copyWith(hypotheekDossier: hp.copyWith(kosten: kosten));

    return nieuwWaarde;
  }

  bool evaluateBoxVisibility(HypotheekDossier hd, HypotheekDossier volgende,
      SliverBoxController<DossierSliverBoxModel> sliverBoxController) {
    IdIterator idIterator;

    if (volgende.eigenWoning) {
      idIterator = IdIterator(
          transition: BoxItemTransitionState.appear,
          except: volgende.inkomensNormToepassen
              ? [
                  IdRange(
                      firstId: volgende.ewrBerekenen
                          ? 'ewr'
                          : 'oorspronkelijkeHoofdsom')
                ]
              : [
                  IdRange(firstId: 'ewrTitle', lastId: 'ewr'),
                  IdRange(firstId: 'oorspronkelijkeHoofdsom')
                ]);
    } else if (volgende.ewrToepassen && volgende.inkomensNormToepassen) {
      if (volgende.ewrBerekenen) {
        idIterator = IdIterator(
            transition: BoxItemTransitionState.appear,
            except: [IdRange(firstId: 'ewr')]);
      } else {
        idIterator = IdIterator(
            transition: BoxItemTransitionState.appear,
            except: [IdRange(firstId: 'woningTitle', lastId: 'totaleKosten')]);
      }
    } else {
      idIterator =
          IdIterator(transition: BoxItemTransitionState.disappear, except: []);
    }

    SliverBoxRequestFeedBack feedback =
        sliverBoxController.feedBackTryModel((model) {
      return model.changeGroups(
          groupModelAction: SliverBoxAction.appear,
          changeGroupModelProperties:
              (List<BoxItemProperties> list, String tag) {
            for (var box in list) {
              idIterator.evaluate(box..prepareForReBuild());
            }
          },
          checkAllGroups: true);
    });

    assert(feedback != SliverBoxRequestFeedBack.multipleModels,
        'Evaluate Box Visibility Multible Models!');

    return feedback == SliverBoxRequestFeedBack.accepted ||
        feedback == SliverBoxRequestFeedBack.noModel;
  }
}

class IdIterator {
  final BoxItemTransitionState transition;
  final List<IdRange> except;
  bool inRange = false;
  int index = 0;
  int numberOfChanges = 0;

  IdIterator({required this.transition, required this.except});

  void evaluate(BoxItemProperties box) {
    if (index == except.length) {
      _adjustTransition(box, false);
      return;
    }

    final idRange = except[index];

    if (box.id == idRange.firstId) {
      if (idRange.isRange) {
        inRange = true;
      } else {
        index++;
      }
      //implement skip first if desired
      _adjustTransition(box, true);
    } else if (box.id == except[index].lastId) {
      inRange = false;
      index++;
      //implement skip last if desired
      _adjustTransition(box, true);
    } else {
      _adjustTransition(box, inRange);
    }
  }

  void _adjustTransition(BoxItemProperties box, bool opposite) {
    switch (transition) {
      case BoxItemTransitionState.appear:
        {
          if (!opposite &&
              box.transitionStatus != BoxItemTransitionState.visible) {
            box.transitionStatus = BoxItemTransitionState.appear;
            numberOfChanges++;
          } else if (opposite &&
              box.transitionStatus != BoxItemTransitionState.invisible) {
            box.transitionStatus = BoxItemTransitionState.disappear;
            numberOfChanges++;
          }
        }
      case BoxItemTransitionState.disappear:
        {
          if (!opposite &&
              box.transitionStatus != BoxItemTransitionState.invisible) {
            box.transitionStatus = BoxItemTransitionState.disappear;
            numberOfChanges++;
          } else if (opposite &&
              box.transitionStatus != BoxItemTransitionState.visible) {
            box.transitionStatus = BoxItemTransitionState.appear;
            numberOfChanges++;
          }
        }
      default:
        {}
    }
  }

  bool get changed => numberOfChanges > 0;
}

class IdRange {
  final String firstId;
  final String? _lastId;

  IdRange({
    required this.firstId,
    String? lastId,
  }) : _lastId = lastId;

  bool get isRange => _lastId != null && firstId != _lastId;

  String get lastId => _lastId ?? firstId;
}

// class HypotheekDossierViewModel with ChangeNotifier {
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
