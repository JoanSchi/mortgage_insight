// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:animated_sliver_box/sliver_box_controller.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/gereedschap/datum_id.dart';
import 'package:hypotheek_berekeningen/gereedschap/kalender.dart';
import 'package:hypotheek_berekeningen/hypotheek/financierings_norm/norm_inkomen/vind_inkomens_op_datum.dart';
import 'package:hypotheek_berekeningen/hypotheek/financierings_norm/norm_nhg/norm_nhg.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/gedeeld/kosten_woning_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/gedeeld/woningwaarde.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/norm/norm_inkomen/inkomens_op_datum.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/norm/normen_toepassen.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/vervolg_lening/vervolg_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_bewerken.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_verwerken.dart';
import 'package:hypotheek_berekeningen/hypotheek_document/hypotheek_document.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/box_properties_constants.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/hypotheek_kosten_item_bewerken.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/lening_kosten_sliver_box_model.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/lening_verbouw_sliver_box_model.dart';

import '../../../../my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';
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
    final hd = hypotheekDocument
        .hypotheekDossierOverzicht.hypotheekDossierGeselecteerd;

    assert(hd != null,
        'Hypotheek bewerken (of nieuw): Geselecteerde HypotheekDossier kan niet null zijn!');

    if (hd == null) {
      return;
    }

    List<InkomenOpDatum> inkomensOpDatum = VindInkomensOpDatum(
      startDatum: Kalender.datumAlleen(DateTime.now()),
      inkomenLijst: hypotheekDocument.inkomenOverzicht.inkomen,
      inkomenLijstPartner: hypotheekDocument.inkomenOverzicht.inkomenPartner,
    ).zoek();

    HypotheekDossier hypotheekDossier = hd;
    String id = hypotheek?.id ?? '';

    final teHerFinancieren =
        HypotheekVerwerken.herFinancieren(hypotheekDossier, id);

    final teVerlengen =
        HypotheekVerwerken.teVerlengenHypotheek(hypotheekDossier, id);

    if (hypotheek == null) {
      (
        hypotheekDossier,
        id,
      ) = HypotheekBewerken.nieuw(
          inkomensOpDatum: inkomensOpDatum,
          vorigeHypotheekDossier: hypotheekDossier,
          teHerFinancieren: teHerFinancieren,
          teVerlengen: teVerlengen);

      hypotheek = hypotheekDossier.hypotheken[id];
    } else {
      id = hypotheek.id;
    }

    final heightVervolg = HypotheekViewModelVerwerken.heightVervolgLening(
        optiesHypotheekToevoegen: hypotheek?.optiesHypotheekToevoegen,
        teHerFinancieren: teHerFinancieren,
        teVerlengen: teVerlengen);

    state = state.copyWith(
      inkomensOpDatum: inkomensOpDatum,
      heightVervolg: heightVervolg,
      teHerFinancieren: teHerFinancieren,
      teVerlengen: teVerlengen,
      hypotheekDossier: hypotheekDossier,
      id: id,
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
    double? woningWaarde,
    List<Waarde>? gedeeldeKostenToevoegen,
    bool? normInkomenToepassen,
    bool? normWoningWaardeToepassen,
    bool? zetMaximaleLening,
  }) {
    if (state.hypotheek == null) {
      return;
    }
    SliverBoxRequestFeedBack feedback = SliverBoxRequestFeedBack.nothingToDo;

    HypotheekDossier hypotheekDossier = state.hypotheekDossier;
    Hypotheek hypotheek = state.hypotheek!;

    if (omschrijving != null ||
        hypotheekvorm != null ||
        gewensteLening != null ||
        rente != null) {
      (hypotheekDossier, hypotheek) = addHypotheek(
          hypotheekDossier,
          hypotheek.copyWith(
              omschrijving: omschrijving ?? hypotheek.omschrijving,
              hypotheekvorm: hypotheekvorm ?? hypotheek.hypotheekvorm,
              gewensteLening: gewensteLening ?? hypotheek.gewensteLening,
              rente: rente ?? hypotheek.rente));
    }

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

    /// Vervolg Relink Height VervolgHypotheek
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

    /// startDatum, afgesloten, zichtbaar
    ///
    /// Datum kan verandert zijn door verlengen
    ///

    if (startDatum != null && startDatum != state.hypotheek?.startDatum) {
      (hypotheekDossier, hypotheek) = HypotheekBewerken.datumAanpassen(
          hypotheekDossier: hypotheekDossier,
          hypotheek: hypotheek,
          startDatum: startDatum);
    }

    /// Kosten Lening Woning
    ///
    ///
    ///
    ///

    if (state.hypotheek!.startDatum != hypotheek.startDatum ||
        state.hypotheek!.afgesloten != hypotheek.afgesloten) {
      kostenLeningWoningZichtbaar(hypotheekDossier, hypotheek);
    }

    /// WoningWaarde
    ///
    ///
    ///
    ///

    if (woningWaarde != null) {
      hypotheekDossier = hypotheekDossier.copyWith(
          dWoningWaarde: hypotheekDossier.dWoningWaarde.add(
              hypotheek.startDatum,
              switch (hypotheekDossier.dWoningWaarde[hypotheek.startDatum]) {
                (WoningWaarde w) => w.copyWith(waarde: woningWaarde),
                (_) => WoningWaarde(waarde: woningWaarde),
              }));

      // nhgMogelijk = !hypotheek.afgesloten &&
      //     woningWaarde <=
      //         (NhgNormTabel.nhgNorm(hypotheek.startDatum)?.aankoopBedrag ?? -1);
    }

    /// Norm
    ///
    ///
    ///
    ///

    if (normInkomenToepassen != null || normWoningWaardeToepassen != null) {
      var (dNormenToepassen, normenToepasen) =
          HypotheekBewerken.opDatumOphalenToevoegen<NormenToepassen>(
              hypotheekDossier.dNormenToepassen, hypotheek.startDatum,
              nieuw: () => NormenToepassen(
                  inkomen: normInkomenToepassen ?? false,
                  woningWaarde: normWoningWaardeToepassen ?? false),
              aanpassen: (NormenToepassen a) {
                return a.copyWith(
                    inkomen: normInkomenToepassen ?? a.inkomen,
                    woningWaarde: normWoningWaardeToepassen ?? a.woningWaarde);
              });
      hypotheekDossier =
          hypotheekDossier.copyWith(dNormenToepassen: dNormenToepassen);
    }

    /// Periode en Termijnen
    ///
    ///
    ///
    ///

    int lPeriodeInMaanden = periodeInMaanden ?? hypotheek.periodeInMaanden;
    int lAflosTermijnInMaanden;

    if (aflosTermijnInMaanden != null) {
      final max =
          HypotheekVerwerken.maxTermijnenInMaanden(hypotheekDossier, hypotheek);

      if (aflosTermijnInMaanden > max) {
        aflosTermijnInMaanden = max;
      } else if (aflosTermijnInMaanden < 1) {
        aflosTermijnInMaanden = 1;
      }
      lAflosTermijnInMaanden = aflosTermijnInMaanden;

      if (aflosTermijnInMaanden < lPeriodeInMaanden) {
        lPeriodeInMaanden = aflosTermijnInMaanden;
      }
    } else {
      lAflosTermijnInMaanden = hypotheek.aflosTermijnInMaanden;
    }

    if (periodeInMaanden != null || aflosTermijnInMaanden != null) {
      (hypotheekDossier, hypotheek) = addHypotheek(
          hypotheekDossier,
          hypotheek.copyWith(
              periodeInMaanden: lPeriodeInMaanden,
              aflosTermijnInMaanden: lAflosTermijnInMaanden));
    }

    /// Kosten
    ///
    ///
    ///
    ///

    if (gedeeldeKostenToevoegen != null && gedeeldeKostenToevoegen.isNotEmpty) {
      KostenWoningLening kostenWoningLening;
      List<Waarde> lGedeeldeKostenToevoegen = gedeeldeKostenToevoegen;

      switch (hypotheekDossier.dKosten[hypotheek.startDatum]) {
        case (KostenWoningLening k):
          {
            lGedeeldeKostenToevoegen = [
              for (Waarde w in lGedeeldeKostenToevoegen)
                w.standaard
                    ? w
                    : w.copyWith(
                        id: DatumId.toDayIdToString(k.kosten,
                            toString: (Waarde w) => w.id))
            ];

            kostenWoningLening =
                k.copyWith(kosten: k.kosten.addAll(lGedeeldeKostenToevoegen));
            break;
          }
        case (_):
          {
            lGedeeldeKostenToevoegen = [
              for (Waarde w in lGedeeldeKostenToevoegen)
                w.standaard
                    ? w
                    : w.copyWith(
                        id: DatumId.toDayIdToString(const <Waarde>[],
                            toString: (Waarde w) => w.id))
            ];
            kostenWoningLening =
                KostenWoningLening(kosten: lGedeeldeKostenToevoegen.lock);
          }
      }

      feedback = state.kostenSliverBoxController.feedBackTryModel((model) {
        final tekstDatum = Kalender.datumNaTekst(hypotheek.startDatum);

        SingleBoxModel<String, KostenItemBoxProperties> single;

        if (model.gedeeldeKosten.isEmpty) {
          single = SingleBoxModel<String, KostenItemBoxProperties>(
              tag: tekstDatum, items: []);
          model.gedeeldeKosten.add(single);
        } else {
          single = model.gedeeldeKosten.first;
        }

        assert(single.tag == tekstDatum,
            'Tag ${single.tag} single is niet gelijk aan $tekstDatum');

        if (single.tag != tekstDatum) {
          return SliverBoxRequestFeedBack.error;
        }

        return model.changeGroups(
            animateInsertDeleteAbove: false,
            changeSingleBoxModels: [
              ChangeSingleModel<String, KostenItemBoxProperties>(single,
                  (list) {
                list.addAll([
                  for (var k in lGedeeldeKostenToevoegen)
                    KostenItemBoxProperties(
                        id: k.id,
                        panel: BoxPropertiesPanels.edit,
                        value: k,
                        transitionStatus: BoxItemTransitionState.appear)
                ]);
              }, SliverBoxAction.appear)
            ],
            checkAllGroups: true);
      });

      hypotheekDossier = hypotheekDossier.copyWith(
          dKosten: hypotheekDossier.dKosten
              .add(hypotheek.startDatum, kostenWoningLening));
    }

    if (feedback == SliverBoxRequestFeedBack.nothingToDo ||
        feedback == SliverBoxRequestFeedBack.accepted ||
        feedback == SliverBoxRequestFeedBack.noModel) {
      (hypotheekDossier, hypotheek) =
          HypotheekBewerken.vergelijkTmHypotheekEnBereken(
              vorigeHypotheekDossier: state.hypotheekDossier,
              hypotheekDossier: hypotheekDossier,
              hypotheek: hypotheek,
              inkomensOpDatum: state.inkomensOpDatum,
              zetMaximaleLening: zetMaximaleLening ?? false);

      state = state.copyWith(
          heightVervolg: heightVervolg, hypotheekDossier: hypotheekDossier);
    }
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

  // SliverBoxRequestFeedBack _veranderingKosten({
  //   required List<Waarde> kosten,
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

  /// Kosten Woning Lening
  ///
  ///
  ///
  ///

  veranderingKostenItem(Waarde waarde,
      {String? omschrijving,
      double? getal,
      Eenheid? eenheid,
      bool? aftrekbaar,
      KostenItemAction kostenItemAction = KostenItemAction.aanpassen}) {
    final hypotheekDossier = state.hypotheekDossier;
    final startDatum = state.hypotheek?.startDatum;

    if (startDatum == null) {
      return;
    }

    KostenWoningLening? kostenWoningLening =
        state.hypotheekDossier.dKosten[startDatum];

    if (kostenWoningLening == null) {
      return;
    }

    SliverBoxRequestFeedBack feedback = SliverBoxRequestFeedBack.nothingToDo;

    switch (kostenItemAction) {
      case KostenItemAction.toevoegen:
        {
          final nieuw = Waarde(
              id: DatumId.toDayIdToString(kostenWoningLening.kosten,
                  toString: (Waarde w) => w.id));

          int index = kostenWoningLening.kosten
              .indexWhere((element) => element.id == waarde.id);
          if (index != -1) {
            kostenWoningLening = kostenWoningLening.copyWith(
                kosten: kostenWoningLening.kosten.insert(index, nieuw));
          }

          feedback = kostenLijstAanpassen((list) {
            int index =
                list.indexWhere((element) => element.value.id == waarde.id);

            list.insert(
                index,
                KostenItemBoxProperties(
                    id: nieuw.id,
                    value: nieuw,
                    transitionStatus: BoxItemTransitionState.insert,
                    panel: BoxPropertiesPanels.edit));
          }, startDatum);
          break;
        }
      case KostenItemAction.verwijderen:
        {
          kostenWoningLening = kostenWoningLening.copyWith(
              kosten: kostenWoningLening.kosten.remove(waarde));

          feedback = kostenLijstAanpassen((list) {
            for (KostenItemBoxProperties properties in list) {
              if (properties.value.id == waarde.id) {
                properties.transitionStatus = BoxItemTransitionState.remove;
                break;
              }
            }
          }, startDatum);

          break;
        }
      default:
        {
          Waarde aangepast = waarde.copyWith(
              omschrijving: omschrijving ?? waarde.omschrijving,
              getal: getal ?? waarde.getal,
              eenheid: eenheid ?? waarde.eenheid,
              aftrekbaar: aftrekbaar ?? waarde.aftrekbaar);

          kostenWoningLening = kostenWoningLening.copyWith(
              kosten: kostenWoningLening.kosten.replaceFirstWhere(
                  (item) => item.id == waarde.id, (item) => aangepast));

          feedback = state.kostenSliverBoxController.feedBackTryModel((model) {
            final singleModel = model.gedeeldeKosten.firstOrNull;
            if (singleModel == null) {
              return SliverBoxRequestFeedBack.noModel;
            }
            if (singleModel.tag == Kalender.datumNaTekst(startDatum)) {
              for (int i = 0; i < singleModel.items.length; i++) {
                if (singleModel.items[i].value.id == aangepast.id) {
                  singleModel.items[i].value = aangepast;
                  break;
                }
              }
              return SliverBoxRequestFeedBack.accepted;
            }
            return SliverBoxRequestFeedBack.error;
          });
        }
    }

    if (feedback == SliverBoxRequestFeedBack.accepted ||
        feedback == SliverBoxRequestFeedBack.noModel) {
      state = state.copyWith.hypotheekDossier(
          dKosten:
              hypotheekDossier.dKosten.add(startDatum, kostenWoningLening));
    }
  }

  SliverBoxRequestFeedBack kostenLijstAanpassen(
      Function(List<KostenItemBoxProperties> list) changeList, DateTime datum) {
    return state.kostenSliverBoxController.feedBackTryModel((model) {
      final single = model.gedeeldeKosten.firstOrNull;

      if (single == null) {
        return SliverBoxRequestFeedBack.noModel;
      }

      assert(single.tag == Kalender.datumNaTekst(datum),
          'Tag datum: ${single.tag} komt niet overeen met datum: ${Kalender.datumNaTekst(datum)}');

      return (single.tag != Kalender.datumNaTekst(datum))
          ? SliverBoxRequestFeedBack.error
          : model.changeGroups(changeSingleBoxModels: [
              ChangeSingleModel<String, KostenItemBoxProperties>(
                  single, changeList, SliverBoxAction.animate)
            ], checkAllGroups: false);
    });
  }

  kostenLeningWoningZichtbaar(
      HypotheekDossier hypotheekDossier, Hypotheek hypotheek) {
    String tag = Kalender.datumNaTekst(hypotheek.startDatum);

    state.kostenSliverBoxController.feedBackTryModel((model) {
      if (hypotheek.afgesloten) {
        /// Afgesloten
        /// Top/ bottom ontzichtbaar
        /// Verwijder kosten
        ///

        final changeSingleModels = [
          ChangeSingleModel<String, DefaultBoxItemProperties>(model.topBox,
              (List<DefaultBoxItemProperties> list) {
            for (var properties in list) {
              properties.setTransitionStatus(BoxItemTransitionState.disappear);
            }
          }, SliverBoxAction.disappear),
          for (SingleBoxModel<String, KostenItemBoxProperties> single
              in model.gedeeldeKosten)
            ChangeSingleModel<String, KostenItemBoxProperties>(single,
                (List<KostenItemBoxProperties> list) {
              for (var properties in list) {
                properties.setTransitionStatus(BoxItemTransitionState.remove);
              }
            }, SliverBoxAction.dispose),
          ChangeSingleModel<String, DefaultBoxItemProperties>(model.bottomBox,
              (List<DefaultBoxItemProperties> list) {
            for (var properties in list) {
              properties.setTransitionStatus(BoxItemTransitionState.disappear);
            }
          }, SliverBoxAction.disappear),
        ];

        return model.changeGroups(
          changeSingleBoxModels: changeSingleModels,
          checkAllGroups: true,
        );
      } else {
        /// Niet afgesloten
        ///  - Top zichtbaar
        ///  - Check juiste datum of voeg juiste datum toe
        ///  - Bottom zichtbaar
        ///

        bool juisteDatumGevonden = false;

        SingleBoxModel<String, KostenItemBoxProperties>? add;

        List<ChangeSingleModel<String, BoxItemProperties>> changeSingleModels =
            [
          ChangeSingleModel<String, DefaultBoxItemProperties>(model.topBox,
              (List<DefaultBoxItemProperties> list) {
            for (var properties in list) {
              properties.setTransitionStatus(BoxItemTransitionState.appear);
            }
          }, SliverBoxAction.appear),
        ];

        for (SingleBoxModel<String, KostenItemBoxProperties> single
            in model.gedeeldeKosten) {
          if (single.tag == tag) {
            juisteDatumGevonden = true;
          } else {
            changeSingleModels.add(
                ChangeSingleModel<String, KostenItemBoxProperties>(single,
                    (List<KostenItemBoxProperties> list) {
              for (var properties in list) {
                properties.setTransitionStatus(BoxItemTransitionState.remove);
              }
            }, SliverBoxAction.dispose));
          }
        }

        if (!juisteDatumGevonden) {
          //nieuw datum toevoegen
          add =
              SingleBoxModel<String, KostenItemBoxProperties>(tag: tag, items: [
            for (Waarde waarde
                in hypotheekDossier.dKosten[hypotheek.startDatum]?.kosten ??
                    <Waarde>[])
              KostenItemBoxProperties(
                  id: waarde.id,
                  panel: BoxPropertiesPanels.standard,
                  value: waarde,
                  transitionStatus: BoxItemTransitionState.insert)
          ]);

          changeSingleModels.add(
              ChangeSingleModel<String, KostenItemBoxProperties>(
                  add,
                  (List<KostenItemBoxProperties> list) {},
                  SliverBoxAction.appear));
        }

        changeSingleModels.add(
            ChangeSingleModel<String, DefaultBoxItemProperties>(model.bottomBox,
                (List<DefaultBoxItemProperties> list) {
          for (var properties in list) {
            properties.setTransitionStatus(BoxItemTransitionState.appear);
          }
        }, SliverBoxAction.appear));

        return model.changeGroups(
            changeSingleBoxModels: changeSingleModels,
            checkAllGroups: true,
            insertModel: () {
              if (add != null) {
                model.gedeeldeKosten.insert(0, add);
              }
            });
      }
    });
  }
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
