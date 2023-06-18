// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:animated_sliver_box/sliver_box_controller.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/norm/norm.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/vervolg_lening/vervolg_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_bewerken.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_verwerken.dart';
import 'package:hypotheek_berekeningen/hypotheek_document/hypotheek_document.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/box_properties_constants.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/lening_kosten_sliver_box_model.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/lening_verbouw_sliver_box_model.dart';

import '../../../../utilities/kalender.dart';
import 'hypotheek_view_state.dart';
import 'vervolg_hypotheek_sliver_box_model.dart';

// required String id,
//     required String omschrijving,
//     required OptiesHypotheekToevoegen optiesHypotheekToevoegen,
//     required double lening,
//     required double gewensteLening,
//     required double maxLeningInkomen,
//     required double maxLeningWoningWaarde,
//     required double maxLeningNHG,
//     required DateTime startDatum,
//     required DateTime startDatumAflossen,
//     required DateTime eindDatum,
//     required int periodeInMaanden,
//     required int aflosTermijnInMaanden,
//     required HypotheekVorm hypotheekvorm,
//     @Default(IListConst([])) IList<Termijn> termijnen,
//     required double rente,
//     required double boeteVrijPercentage,
//     required bool usePeriodeInMaanden,
//     required double minLening,
//     required IList<AflosItem> extraAflossen,
//     @Default("") String volgende,
//     @Default("") String vorige,
//     @Default(IMapConst({})) IMap<String, int> order,
//     @Default(WoningLeningKosten()) WoningLeningKosten woningLeningKosten,
//     @Default(VerbouwVerduurzaamKosten())
//         VerbouwVerduurzaamKosten verduurzaamKosten,
//     required bool deelsAfgelosteLening,
//     required DateTime datumDeelsAfgelosteLening,
//     required ParallelLeningen parallelLeningen,
//     required bool afgesloten,
//     @Default(0.0) double restSchuld,

final hypotheekBewerkenProvider =
    StateNotifierProvider<HypotheekViewStateNotifier, HypotheekViewState>(
        (ref) {
  return HypotheekViewStateNotifier(
    HypotheekViewState(
        hypotheekDossier: const HypotheekDossier(),
        kostenSliverBoxController:
            SliverBoxController<HypotheekKostenSliverBoxModel>(),
        verbouwKostenSliverBoxController:
            SliverBoxController<HypotheekVerbouwKostenSliverBoxModel>(),
        vervolgHypotheekSliverBoxController:
            SliverBoxController<VervolgHypotheekSliverBoxModel>()),
  );
});

class HypotheekViewStateNotifier extends StateNotifier<HypotheekViewState> {
  HypotheekViewStateNotifier(super.state);

  void bewerken(
      {required HypotheekDocument hypotheekDocument, Hypotheek? hypotheek}) {
    HypotheekBewerken hb;

    if (hypotheek == null) {
      hb = HypotheekBewerken(hypotheekDocument: hypotheekDocument)..nieuw();
    } else {
      hb = HypotheekBewerken(hypotheekDocument: hypotheekDocument)
        ..bewerken(hypotheek);
    }

    final heightVervolg = HypotheekViewModelVerwerken.heightVervolgLening(
        optiesHypotheekToevoegen: hb.hypotheek?.optiesHypotheekToevoegen,
        teHerFinancieren: hb.teHerFinancieren,
        teVerlengen: hb.teVerlengen);

    state = state.copyWith(
      heightVervolg: heightVervolg,
      teHerFinancieren: hb.teHerFinancieren,
      teVerlengen: hb.teVerlengen,
      hypotheekDossier: hb.hypotheekDossier,
      id: hb.hypotheekId,
    );
  }

  void verandering({
    String? omschrijving,
    DateTime? startDatum,
    OptiesHypotheekToevoegen? optiesHypotheekToevoegen,
    double? gewensteLening,
    double? rente,
    int? periodeInMaanden,
    int? aflosTermijnInMaanden,
    HypotheekVorm? hypotheekvorm,
    String? volgende,
    String? vorige,
    bool? toepassenNhg,
    bool? deelsAfgelosteLening,
    DateTime? datumDeelsAfgelosteLening,
    double? percentageMaximumLening,
    bool? verbouwenVerduurzamenToepassen,
  }) {
    if (state.hypotheek == null) {
      return;
    }
    HypotheekDossier hypotheekDossier = state.hypotheekDossier;
    Hypotheek hypotheek = state.hypotheek!;

    String lOmschrijving = omschrijving ?? hypotheek.omschrijving;

    OptiesHypotheekToevoegen lOptiesHypotheekToevoegen =
        optiesHypotheekToevoegen ?? hypotheek.optiesHypotheekToevoegen;
    double lGewensteLening = gewensteLening ?? hypotheek.gewensteLening;
    double lRente = rente ?? hypotheek.rente;
    int lPeriodeInMaanden = periodeInMaanden ?? hypotheek.periodeInMaanden;
    int lAflosTermijnInMaanden;

    HypotheekVorm lHypotheekVorm = hypotheekvorm ?? hypotheek.hypotheekvorm;
    String lVolgende = volgende ?? hypotheek.volgende;
    String lVorige = vorige ?? hypotheek.vorige;

    /// Relink
    ///
    ///
    ///
    ///
    ///
    if (vorige != null || optiesHypotheekToevoegen != null) {
      (hypotheekDossier, hypotheek) = HypotheekBewerken.aanpassenVerlengen(
          hypotheekDossier: hypotheekDossier,
          hypotheek: hypotheek,
          vorige: vorige,
          optiesHypotheekToevoegen: optiesHypotheekToevoegen);
    }

    /// startDatum, afgesloten, zichtbaar
    ///
    /// Datum kan verandert zijn door verlengen
    ///

    DateTime lStartDatum = startDatum ?? hypotheek.startDatum;

    if (lStartDatum != state.hypotheek?.startDatum) {
      bool lAfgesloten =
          lStartDatum.compareTo(DateUtils.dateOnly(DateTime.now())) <= 0;

      (hypotheekDossier, hypotheek) = addHypotheek(hypotheekDossier,
          hypotheek.copyWith(startDatum: lStartDatum, afgesloten: lAfgesloten));
    }

    ///
    ///
    ///
    ///
    ///

    double heightVervolg = state.heightVervolg;

    if (optiesHypotheekToevoegen != null) {
      bool accept;
      (accept, heightVervolg) = vervolgLeningToevoegen(
          optiesHypotheekToevoegen: optiesHypotheekToevoegen,
          teHerFinancieren: state.teHerFinancieren,
          teVerlengen: state.teVerlengen);

      if (!accept) {
        return;
      }
    }

    /// Norm Nhg toepassen
    ///
    ///
    ///
    // NormNhg normNhg = hypotheek.normNhg;
    // WoningLeningKosten woningLeningKosten =
    //     hypotheekDossier.woningLeningKosten(startDatum);

    // if (toepassenNhg != null) {
    //   IList<Waarde> kosten = hypotheek.woningLeningKosten.kosten;
    //   final int indexBorgNHG =
    //       kosten.indexWhere((Waarde w) => w.id == 'borgNHG');

    //   if (toepassenNhg) {
    //     if (indexBorgNHG == -1) {
    //       final feedback = _veranderingKostenToevoegen(
    //           kosten: hypotheek.woningLeningKosten.kosten,
    //           controllerSliver: state.controllerKostenLijst,
    //           lijst: [HypotheekVerwerken.borgNHG],
    //           toevoegenToegestaan: (List<Waarde> lijst) {
    //             kosten = kosten.add(HypotheekVerwerken.borgNHG);
    //           });

    //       if (feedback != SliverBoxRowRequestFeedBack.accepted &&
    //           feedback != SliverBoxRowRequestFeedBack.noModel) {
    //         debugPrint(
    //             'BorgNHG niet geselecteerd door Feedback niet geaccepteerd ');
    //         return;
    //       }
    //     }
    //   } else {
    //     if (indexBorgNHG != -1) {
    //       final feedback = _veranderingKostenVerwijderen(
    //           kosten: hypotheek.woningLeningKosten.kosten,
    //           controllerSliver: state.controllerKostenLijst,
    //           verwijderen: kosten[indexBorgNHG],
    //           verwijderenToegestaan: (Waarde waarde) {
    //             kosten = kosten.remove(waarde);
    //           });

    //       if (feedback != SliverBoxRowRequestFeedBack.accepted &&
    //           feedback != SliverBoxRowRequestFeedBack.noModel) {
    //         debugPrint(
    //             'BorgNHG niet gedeselecteerd door Feedback niet geaccepteerd');
    //         return;
    //       }
    //     }
    //   }
    //   woningLeningKosten = woningLeningKosten.copyWith(kosten: kosten);
    //   normNhg = hypotheek.normNhg.copyWith(
    //     toepassen: toepassenNhg,
    //   );
    // }

    // bool lAfgesloten = (startDatum ?? hypotheek.startDatum)
    //         .compareTo(DateUtils.dateOnly(DateTime.now())) <=
    //     0;

    // VerbouwVerduurzaamKosten? verbouwVerduurzaamKosten =
    //     hypotheekDossier.verbouwVerduurzaamKostenOpDatum[lStartDatum];

    // if (verbouwVerduurzaamKosten != null &&
    //     (startDatum != null || lAfgesloten != hypotheek.afgesloten)) {
    //   final s = startDatum ?? hypotheek.startDatum;
    //   if (lAfgesloten != hypotheek.afgesloten) {
    //     if (state.controllerKostenLijst.isEmptyOrAdjustable &&
    //         state.controllerVerbouwVerduurzamen.isEmptyOrAdjustable) {
    //       zichtBaarBoxAanpassen(
    //           controller: state.controllerVerbouwVerduurzamen,
    //           zichtbaar: !lAfgesloten,
    //           excludeKey: !lAfgesloten && !verbouwVerduurzaamKosten
    //               ? ['totaleKosten', 'toevoegenTaxatie']
    //               : []);
    //       zichtBaarBoxAanpassen(
    //           controller: state.controllerKostenLijst, zichtbaar: !lAfgesloten);
    //       lStartDatum = s;
    //     } else {
    //       return;
    //     }
    //   } else {
    //     lStartDatum = s;
    //   }
    // }

    /// Verbouwen Verduurzamen toepassen
    ///
    ///
    ///

    //   VerbouwVerduurzaamKosten verbouwVerduurzaamKosten =
    //       hypotheek.verbouwVerduurzaamKosten;

    //   if (verbouwenVerduurzamenToepassen != null) {
    //     bool zichtbaarToepassen = !lAfgesloten && verbouwenVerduurzamenToepassen;

    //     if (zichtBaarBoxAanpassen(
    //         controller: state.controllerVerbouwVerduurzamen,
    //         zichtbaar: zichtbaarToepassen,
    //         includeKey: ['totaleKosten', 'toevoegenTaxatie'])) {
    //       verbouwVerduurzaamKosten = verbouwVerduurzaamKosten.copyWith(
    //           toepassen: verbouwenVerduurzamenToepassen);
    //     } else {
    //       debugPrint('Aanpassing niet geaccepteerd');
    //       return;
    //     }
    //   }

    //   bool lDeelsAfgelosteLening =
    //       deelsAfgelosteLening ?? hypotheek.deelsAfgelosteLening;
    //   DateTime lDatumDeelsAfgelosteLening =
    //       datumDeelsAfgelosteLening ?? hypotheek.datumDeelsAfgelosteLening;

    //   if (aflosTermijnInMaanden != null) {
    //     final max = HypotheekVerwerken.maxTermijnenInJaren(hypotheekDossier,
    //             vorige: hypotheek.vorige) *
    //         12;

    //     if (aflosTermijnInMaanden > max) {
    //       aflosTermijnInMaanden = max;
    //     } else if (aflosTermijnInMaanden < 1) {
    //       aflosTermijnInMaanden = 1;
    //     }
    //     lAflosTermijnInMaanden = aflosTermijnInMaanden;

    //     if (aflosTermijnInMaanden < lPeriodeInMaanden) {
    //       lPeriodeInMaanden = aflosTermijnInMaanden;
    //     }
    //   } else {
    //     lAflosTermijnInMaanden = hypotheek.aflosTermijnInMaanden;
    //   }

    //   if (percentageMaximumLening != null) {
    //     lGewensteLening = HypotheekVerwerken.maxLening(hypotheek);
    //   }

    // hypotheek.copyWith(
    //   omschrijving: lOmschrijving,
    //   startDatum: lStartDatum,
    //   optiesHypotheekToevoegen: lOptiesHypotheekToevoegen,
    //   gewensteLening: lGewensteLening,
    //   rente: lRente,
    //   periodeInMaanden: lPeriodeInMaanden,
    //   // aflosTermijnInMaanden: lAflosTermijnInMaanden,
    //   hypotheekvorm: lHypotheekVorm,
    //   volgende: lVolgende,
    //   vorige: lVorige,
    //   // normNhg: normNhg,
    //   // deelsAfgelosteLening: lDeelsAfgelosteLening,
    //   // datumDeelsAfgelosteLening: lDatumDeelsAfgelosteLening,
    //   afgesloten: lAfgesloten
    // )

    state = state.copyWith(
        heightVervolg: heightVervolg, hypotheekDossier: hypotheekDossier);
  }

  // void veranderingWoningLening({double? lening, double? woningWaarde}) {
  //   final hypotheek = state.hypotheek;
  //   if (hypotheek == null) return;

  //   double lLening = lening ?? hypotheek.woningLeningKosten.lening;
  //   double lWoningWaarde =
  //       woningWaarde ?? hypotheek.woningLeningKosten.woningWaarde;

  //   copyHypotheek(hypotheek.copyWith
  //       .woningLeningKosten(woningWaarde: lWoningWaarde, lening: lLening));
  // }

  // void veranderingKostenToevoegen(List<Waarde> lijst) {
  //   final hypotheek = state.hypotheek;

  //   if (hypotheek == null) return;

  //   _veranderingKostenToevoegen(
  //       kosten: hypotheek.woningLeningKosten.kosten,
  //       controllerSliver: state.controllerKostenLijst,
  //       lijst: lijst,
  //       toevoegenToegestaan: (List<Waarde> lijst) {
  //         copyHypotheek(hypotheek.copyWith.woningLeningKosten(
  //             kosten: hypotheek.woningLeningKosten.kosten.addAll(lijst)));
  //       });
  // }

  // SliverBoxRowRequestFeedBack _veranderingKostenToevoegen({
  //   required IList<Waarde> kosten,
  //   required List<Waarde> lijst,
  //   required Function(List<Waarde> lijst) toevoegenToegestaan,
  //   required ControllerSliverRowBox<String, Waarde> controllerSliver,
  // }) {
  //   int index = kosten.fold<int>(
  //       1000,
  //       (previousValue, element) => previousValue < element.index + 1
  //           ? element.index + 1
  //           : previousValue);

  //   lijst = [
  //     for (Waarde w in lijst) w.standaard ? w : w.copyWith(index: index++)
  //   ];

  //   final feedback = controllerSliver.insertGroup(
  //       body: (List<SliverBoxItemState<Waarde>> list) {
  //     list
  //       ..addAll([
  //         for (Waarde w in lijst)
  //           SliverBoxItemState<Waarde>(
  //               single: true,
  //               height: 72.0,
  //               value: w,
  //               key: w.key,
  //               status: ItemStatusSliverBox.insert)
  //       ])
  //       ..sort((a, b) => a.value.index.compareTo(b.value.index));
  //   });

  //   if (feedback == SliverBoxRowRequestFeedBack.accepted ||
  //       feedback == SliverBoxRowRequestFeedBack.noModel) {
  //     toevoegenToegestaan(lijst);
  //   } else {
  //     debugPrint('Insertion not accepted, because busy with $feedback');
  //   }
  //   return feedback;
  // }

  // void veranderingKostenVerwijderen(Waarde verwijderen) {
  //   final hypotheek = state.hypotheek;

  //   if (hypotheek == null) return;
  //   _veranderingKostenVerwijderen(
  //       kosten: hypotheek.woningLeningKosten.kosten,
  //       controllerSliver: state.controllerKostenLijst,
  //       verwijderen: verwijderen,
  //       verwijderenToegestaan: (Waarde waarde) {
  //         copyHypotheek(hypotheek.copyWith.woningLeningKosten(
  //             kosten: hypotheek.woningLeningKosten.kosten.remove(verwijderen)));
  //       });
  // }

  // SliverBoxRowRequestFeedBack _veranderingKostenVerwijderen({
  //   required IList<Waarde> kosten,
  //   required Waarde verwijderen,
  //   required Function(Waarde waarde) verwijderenToegestaan,
  //   required ControllerSliverRowBox<String, Waarde> controllerSliver,
  // }) {
  //   final feedback = controllerSliver.changeIndividual(
  //       body: (List<SliverBoxItemState<Waarde>> list) {
  //     for (SliverBoxItemState<Waarde> state in list) {
  //       if (verwijderen == state.value) {
  //         state
  //           ..single = true
  //           ..status = ItemStatusSliverBox.remove;
  //       }
  //     }
  //   });

  //   if (feedback == SliverBoxRowRequestFeedBack.accepted ||
  //       feedback == SliverBoxRowRequestFeedBack.noModel) {
  //     verwijderenToegestaan(verwijderen);
  //   } else {
  //     debugPrint('Insertion not accepted, because busy with $feedback');
  //   }

  //   return feedback;
  // }

  (bool accepted, double height) vervolgLeningToevoegen({
    required OptiesHypotheekToevoegen optiesHypotheekToevoegen,
    required List<HerFinancieren> teHerFinancieren,
    required List<LeningVerlengen> teVerlengen,
  }) {
    var (
      String tag,
      List<VervolgHypotheekItemBoxProperties> items,
      double height
    ) = HypotheekViewModelVerwerken.vervolgBoxItems(
        optiesHypotheekToevoegen: optiesHypotheekToevoegen,
        teHerFinancieren: teHerFinancieren,
        teVerlengen: teVerlengen,
        transitionState: BoxItemTransitionState.appear);

    itemsToModel(VervolgHypotheekSliverBoxModel model) {
      final single = SingleBoxModel<String, VervolgHypotheekItemBoxProperties>(
          tag: tag, items: items);

      return model.changeGroups(
          animateInsertDeleteAbove: false,
          changeSingleBoxModels: [
            ChangeSingleModel(single, (list) {
              for (var properties in list) {
                properties.transitionStatus =
                    BoxItemTransitionState.insertFront;
              }
            }, SliverBoxAction.appear),
            for (var single in model.iterator())
              ChangeSingleModel(single, (list) {
                for (var property in list) {
                  if (property.transitionStatus !=
                      BoxItemTransitionState.invisible) {
                    property.transitionStatus =
                        BoxItemTransitionState.disappear;
                  }
                }
              }, SliverBoxAction.dispose)
          ],
          checkAllGroups: false,
          insertModel: () {
            model.boxList.insert(0, single);
          });

      //   for (SingleBoxModel<String, VervolgHypotheekItemBoxProperties> single
      //       in model.iterator()) {
      //     SliverBoxRequestFeedBack disposeSingleModel() {
      //       return (single.sliverBoxAction != SliverBoxAction.dispose)
      //           ? model.changeSingleModel(
      //               singleBoxModel: single,
      //               change: (List<VervolgHypotheekItemBoxProperties> list) {
      //                 for (var i in list) {
      //                   i.setTransition(BoxItemTransitionState.remove, false);
      //                 }
      //                 single
      //                   ..tag = 'dispose_${single.tag}'
      //                   ..sliverBoxAction = SliverBoxAction.dispose;
      //               },
      //               evaluateVisibleItems: true)
      //           : SliverBoxRequestFeedBack.accepted;
      //     }

      //     if (tag == single.tag) {
      //       found = true;

      //       if (items.isEmpty) {
      //         feedback = disposeSingleModel();
      //       }
      //     } else {
      //       feedback = disposeSingleModel();
      //     }
      //   }

      //   if (feedback != SliverBoxRequestFeedBack.accepted) {
      //     return feedback;
      //   }

      //   if (!found) {
      //     model.boxList.add(
      //         SingleBoxModel<String, VervolgHypotheekItemBoxProperties>(
      //             tag: tag, items: items));
      //   }

      //   return feedback;
    }

    final feedback = state.vervolgHypotheekSliverBoxController
        .feedBackTryModel(itemsToModel);

    return (
      feedback == SliverBoxRequestFeedBack.accepted ||
          feedback == SliverBoxRequestFeedBack.noModel,
      height
    );
  }

  (HypotheekDossier, Hypotheek) addHypotheek(
          HypotheekDossier hypotheekDossier, Hypotheek hypotheek) =>
      (
        hypotheekDossier.copyWith(
            hypotheken:
                hypotheekDossier.hypotheken.add(hypotheek.id, hypotheek)),
        hypotheek
      );
}

class HypotheekViewModelVerwerken {
  static (
    String tag,
    List<VervolgHypotheekItemBoxProperties> items,
    double height
  ) vervolgBoxItems(
          {OptiesHypotheekToevoegen? optiesHypotheekToevoegen,
          required List<HerFinancieren> teHerFinancieren,
          required List<LeningVerlengen> teVerlengen,
          required BoxItemTransitionState transitionState}) =>
      switch (optiesHypotheekToevoegen) {
        OptiesHypotheekToevoegen.nieuw => (
            'herFinancieren',
            [
              for (HerFinancieren hf in teHerFinancieren)
                VervolgHypotheekItemBoxProperties(
                    transitionStatus: transitionState,
                    id: hf.ids.toString(),
                    panel: BoxPropertiesPanels.standard,
                    vervolgLening: hf)
            ],
            teHerFinancieren.isEmpty ? 0.0 : 200.0
          ),
        OptiesHypotheekToevoegen.verlengen => (
            'verlengen',
            [
              for (LeningVerlengen verlengen in teVerlengen)
                VervolgHypotheekItemBoxProperties(
                    transitionStatus: transitionState,
                    id: verlengen.hypotheek.id,
                    panel: BoxPropertiesPanels.standard,
                    vervolgLening: verlengen)
            ],
            teVerlengen.isEmpty ? 0.0 : 300.0
          ),
        (_) => ('', const [], 0.0)
      };

  static double heightVervolgLening(
          {required OptiesHypotheekToevoegen? optiesHypotheekToevoegen,
          required List<HerFinancieren> teHerFinancieren,
          required List<LeningVerlengen> teVerlengen}) =>
      switch (optiesHypotheekToevoegen) {
        OptiesHypotheekToevoegen.nieuw =>
          teHerFinancieren.isEmpty ? 0.0 : 200.0,
        OptiesHypotheekToevoegen.verlengen => teVerlengen.isEmpty ? 0.0 : 300.0,
        (_) => 0.0
      };
}
