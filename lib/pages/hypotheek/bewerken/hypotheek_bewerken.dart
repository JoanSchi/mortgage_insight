// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/layout/transition/scale_size_transition.dart';
import 'package:mortgage_insight/my_widgets/animated_scale_resize_switcher.dart';
import 'package:mortgage_insight/my_widgets/header_layout.dart';
import 'package:mortgage_insight/my_widgets/selectable_widgets/single_checkbox.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/pages/hypotheek/bewerken/financieringsnorm_tabel.dart';
import 'package:mortgage_insight/pages/hypotheek/bewerken/hypotheek_verleng_card.dart';
import 'package:mortgage_insight/pages/hypotheek/bewerken/overzicht_hypotheek.dart';
import 'package:mortgage_insight/pages/hypotheek/bewerken/overzicht_hypotheek_tabel.dart';
import 'package:mortgage_insight/pages/hypotheek/profiel_bewerken/kosten_lijst.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import 'package:sliver_row_box/sized_sliver_box.dart';
import 'package:sliver_row_box/sliver_item_row_insert_remove.dart';
import 'package:sliver_row_box/sliver_row_box.dart';
import 'package:sliver_row_box/sliver_row_item_background.dart';
import '../../../model/nl/hypotheek/financierings_norm/norm.dart';
import '../../../model/nl/hypotheek/gegevens/combi_rest_schuld/combi_rest_schuld.dart';
import '../../../model/nl/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import '../../../model/nl/hypotheek/gegevens/hypotheek/hypotheek.dart';
import '../../../model/nl/hypotheek/gegevens/hypotheek_profiel/hypotheek_profiel.dart';
import '../../../model/nl/hypotheek/hypotheek.dart';
import '../../../model/nl/hypotheek/kosten_hypotheek.dart';
import '../../../model/nl/hypotheek/verwerken/hypotheek_verwerken.dart';
import '../../../my_widgets/selectable_popupmenu.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../platform_page_format/default_page.dart';
import '../../../platform_page_format/page_actions.dart';
import '../../../platform_page_format/page_properties.dart';
import '../../../utilities/device_info.dart';
import '../../../utilities/match_properties.dart';
import 'abstract_hypotheek_consumer.dart';
import 'hypotheek_model.dart';
import 'verdeling_leningen.dart';

class BewerkHypotheek extends ConsumerStatefulWidget {
  const BewerkHypotheek({super.key});

  @override
  ConsumerState<BewerkHypotheek> createState() => BewerkHypotheekState();
}

class BewerkHypotheekState extends ConsumerState<BewerkHypotheek> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;

    final save = PageActionItem(
        text: 'Opslaan',
        icon: Icons.done,
        voidCallback: () => debugPrint('opslaan'));

    final cancel = PageActionItem(
        text: 'Annuleren',
        icon: Icons.arrow_back,
        voidCallback: () => debugPrint('Annuleren'));

    return DefaultPage(
        title: 'Toevoegen',
        imageBuilder: (_) => Image(
            image: const AssetImage(
              'graphics/fit_geldzak.png',
            ),
            color: theme.colorScheme.onSurface),
        matchPageProperties: [
          MatchPageProperties(
              pageProperties:
                  PageProperties(rightBottomActions: [cancel, save])),
        ],
        bodyBuilder: bodyBuilder);
  }

  Widget bodyBuilder(
      {required BuildContext context,
      required bool nested,
      required double topPadding,
      required double bottomPadding}) {
    return Form(
      key: _formKey,
      child: CustomScrollView(slivers: [
        if (nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        const HypotheekBewerkOmschrijvingToevoegOptie(),
        const HypotheekBewerkDatumVerlengen(),
        const TermijnPeriodePanel(),
        // HypotheekKostenPanel(),
        // const VerduurzamenPanel(),
        // LeningPanel(),
        // SpacerFinancieringsTabel(),
        // FinancieringsNormTable(),
        // VerdelingLeningen(),
        // OverzichtHypotheek(),
        // OverzichtHypotheekTabel()
      ]),
    );
  }
}

// class HypotheekBewerkPanel extends ConsumerStatefulWidget {
//   final bool nested;

//   const HypotheekBewerkPanel({
//     super.key,
//     required this.nested,
//   });

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _HypotheekBewerkPanelState();
// }

// class _HypotheekBewerkPanelState extends ConsumerState<HypotheekBewerkPanel> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScrollController? controller = PrimaryScrollController.of(context);

//     return AcceptCanelPanel(
//       accept: () {
//         if (_formKey.currentState?.validate() ?? false) {
//           _formKey.currentState?.save();
//           hypotheekViewModel.accept();
//           // TODO:
//           // ref
//           //     .read(removeHypotheekContainerProvider)
//           //     .updateHypotheekProfiel(hypotheekViewModel.profiel);

//           ref.read(pageHypotheekProvider).page = 1;

//           scheduleMicrotask(() {
//             context.pop();
//           });
//         }
//       },
//       cancel: () {
//         hypotheekViewModel.cancel();
//         scheduleMicrotask(() {
//           context.pop();
//         });
//       },
//       child: Form(
//         key: _formKey,
//         child: CustomScrollView(slivers: [
//           if (widget.nested)
//             SliverOverlapInjector(
//               // This is the flip side of the SliverOverlapAbsorber
//               // above.
//               handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//             ),
//           HypotheekBewerkOmschrijvingToevoegOptie(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           HypotheekBewerkDatumVerlengen(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           TermijnPeriodePanel(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           HypotheekKostenPanel(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           VerduurzamenPanel(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           LeningPanel(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           SpacerFinancieringsTabel(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           FinancieringsNormTable(
//             controller: controller,
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           VerdelingLeningen(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           OverzichtHypotheek(
//             hypotheekViewModel: hypotheekViewModel,
//           ),
//           OverzichtHypotheekTabel(
//               hypotheekViewModel: hypotheekViewModel, controller: controller)
//         ]),
//       ),
//     );
//   }
// }

/// Omschrijving HypotheekToevoegOpie
///
///
///
///
///
///

class HypotheekBewerkOmschrijvingToevoegOptie extends ConsumerStatefulWidget {
  const HypotheekBewerkOmschrijvingToevoegOptie({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      HypotheekBewerkOmschrijvingToevoegOptieState();
}

class HypotheekBewerkOmschrijvingToevoegOptieState
    extends AbstractHypotheekConsumerState<
        HypotheekBewerkOmschrijvingToevoegOptie> {
  late final TextEditingController _tecOmschrijving;
  late final FocusNode _fnOmschrijving;

  @override
  void initState() {
    _tecOmschrijving = TextEditingController(
        text: toText((hypotheek) => hypotheek.omschrijving));
    _fnOmschrijving = FocusNode()
      ..addListener(() {
        if (!_fnOmschrijving.hasFocus) {
          _veranderingOmschrijving(_tecOmschrijving.text);
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _tecOmschrijving.dispose();
    _fnOmschrijving.dispose();
    super.dispose();
  }

  @override
  Widget buildHypotheek(BuildContext context, HypotheekBewerken hb,
      HypotheekProfiel hp, Hypotheek hypotheek) {
    final theme = Theme.of(context);
    final headlineMedium = theme.textTheme.headlineMedium;

    List<Widget> children = [
      OmschrijvingTextField(
        textEditingController: _tecOmschrijving,
        focusNode: _fnOmschrijving,
      ),
      const SizedBox(
        height: 16.0,
      ),
      Text(
        'Hypotheek',
        style: headlineMedium,
      ),
    ];

    if (hb.verlengen.isNotEmpty) {
      children.addAll([
        const SizedBox(
          height: 8.0,
        ),
        UndefinedSelectableGroup(
          groups: [
            MyRadioGroup<OptiesHypotheekToevoegen>(
                list: [
                  RadioSelectable(
                      text: 'Nieuw', value: OptiesHypotheekToevoegen.nieuw),
                  RadioSelectable(
                      text: 'Verlengen',
                      value: OptiesHypotheekToevoegen.verlengen)
                ],
                groupValue: hypotheek.optiesHypotheekToevoegen,
                onChange: _veranderingHypotheekToevoegen)
          ],
          matchTargetWrap: [
            MatchTargetWrap<GroupLayoutProperties>(
                object: GroupLayoutProperties.horizontal(
                    options: const SelectableGroupOptions(
                        selectedGroupTheme: SelectedGroupTheme.button))),
          ],
        ),
      ]);
    }

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ));
  }

  _veranderingOmschrijving(String value) {
    notifier.verandering(omschrijving: value);
  }

  _veranderingHypotheekToevoegen(OptiesHypotheekToevoegen? value) {
    notifier.verandering(optiesHypotheekToevoegen: value);
  }
}

/// Datum en Verlengen
///
///
///
///
///
///

class HypotheekBewerkDatumVerlengen extends ConsumerStatefulWidget {
  const HypotheekBewerkDatumVerlengen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      HypotheekBewerkDatumVerlengenState();
}

class HypotheekBewerkDatumVerlengenState
    extends AbstractHypotheekConsumerState<HypotheekBewerkDatumVerlengen> {
  @override
  Widget buildHypotheek(BuildContext context, HypotheekBewerken hb,
      HypotheekProfiel hp, Hypotheek hypotheek) {
    final firstDate = HypotheekVerwerken.eersteKalenderDatum(hp, hypotheek);
    final lastDate = HypotheekVerwerken.laatsteKalenderDatum(hp, hypotheek);
    final theme = Theme.of(context);
    final headerlineMedium = theme.textTheme.headlineMedium;

    Widget vorigeOfDatum;

    if (hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw) {
      vorigeOfDatum = DateInputPicker(
        date: hypotheek.startDatum,
        firstDate: firstDate,
        lastDate: lastDate,
        changeDate: _veranderingStartDatum,
        saveDate: _veranderingStartDatum,
      );

      if (hb.restSchulden.isNotEmpty) {
        vorigeOfDatum = Column(children: [
          vorigeOfDatum,
          const SizedBox(
            height: 16.0,
          ),
          Text('Oversluiten', style: headerlineMedium),
          const SizedBox(
            height: 8.0,
          ),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;

            const max = 150.0;
            const inner = 6.0;

            final r = 1.0 + ((width - max) / (max + inner)).floorToDouble();

            final w = (width - r * inner + inner) / r;

            return Wrap(spacing: 6.0, children: [
              for (CombiRestSchuld r in hb.restSchulden.values)
                SizedBox(
                  width: w,
                  height: w / 3.0 * 2.0,
                  child: RestSchuldCard(
                    restSchuld: r,
                    selected: hypotheek.startDatum,
                    changed: _veranderingStartDatum,
                  ),
                )
            ]);
          })
        ]);
      }
    } else {
      vorigeOfDatum = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;

        const max = 300.0;
        const inner = 6.0;

        final r = 1.0 + ((width - max) / (max + inner)).floorToDouble();

        final w = (width - r * inner + inner) / r;

        return Wrap(
            spacing: 6.0,
            children: hb.verlengen
                .map((Hypotheek e) => SizedBox(
                      width: w,
                      height: w / 3.0 * 2.0,
                      child: VerlengCard(
                        hypotheek: e,
                        selected: hypotheek.vorige,
                        changed: _veranderingVorigeHypotheek,
                      ),
                    ))
                .toList());
      });
    }

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AnimatedScaleResizeSwitcher(
        child: vorigeOfDatum,
      ),
    ));
  }

  _veranderingStartDatum(DateTime? value) {
    notifier.verandering(startDatum: value);
  }

  _veranderingVorigeHypotheek(String? value) {
    notifier.verandering(vorige: value ?? '');
  }
}

/// Termijn, Periode, NHG en Verduurzamen
///
///
///
///
///
///

class TermijnPeriodePanel extends ConsumerStatefulWidget {
  const TermijnPeriodePanel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TermijnPeriodePanelState();
}

class TermijnPeriodePanelState
    extends AbstractHypotheekConsumerState<TermijnPeriodePanel> {
  late final TextEditingController _tecAflosTermijnInJaren;
  late final FocusNode _fnAflosTermijnInJaren;
  late final TextEditingController _tecPeriodeInJaren;
  late final FocusNode _fnPeriodeInJaren;

  @override
  void initState() {
    _tecAflosTermijnInJaren = TextEditingController(
        text: intToText((hypotheek) => hypotheek.aflosTermijnInJaren));

    _fnAflosTermijnInJaren = FocusNode()
      ..addListener(() {
        if (!_fnAflosTermijnInJaren.hasFocus) {
          _veranderenAflosTermijnInJaren(
              value: int.tryParse(_tecAflosTermijnInJaren.text),
              max: maxTermijnenInJaren);
        }
      });

    _tecPeriodeInJaren = TextEditingController(
        text: intToText((hypotheek) => hypotheek.periodeInJaren));

    _fnPeriodeInJaren = FocusNode()
      ..addListener(() {
        if (!_fnPeriodeInJaren.hasFocus) {
          _veranderenPeriodeInJaren(
              value: int.tryParse(_tecPeriodeInJaren.text),
              max: maxTermijnenInJaren);
        }
      });

    super.initState();
  }

  int? get maxTermijnenInJaren {
    final hypotheekBewerken = ref.read(hypotheekBewerkenProvider);
    final hp = hypotheekBewerken.profiel;
    final hypotheek = hypotheekBewerken.hypotheek;

    return hp != null && hypotheek != null
        ? HypotheekVerwerken.maxTermijnenInJaren(hp, hypotheek)
        : null;
  }

  @override
  void dispose() {
    _tecAflosTermijnInJaren.dispose();
    _fnAflosTermijnInJaren.dispose();
    _tecPeriodeInJaren.dispose();
    _fnPeriodeInJaren.dispose();
    super.dispose();
  }

  listen(Hypotheek? previous, Hypotheek? next) {
    if (next == null) return;

    if (previous?.aflosTermijnInJaren != next.aflosTermijnInJaren &&
        nf.parsToInt(_tecAflosTermijnInJaren.text) !=
            next.aflosTermijnInJaren) {
      _tecAflosTermijnInJaren.text = '${next.aflosTermijnInJaren}';
    }

    if (previous?.periodeInJaren != next.periodeInJaren &&
        nf.parsToInt(_tecPeriodeInJaren.text) != next.periodeInJaren) {
      _tecPeriodeInJaren.text = '${next.periodeInJaren}';
    }
  }

  @override
  Widget buildHypotheek(BuildContext context, HypotheekBewerken hb,
      HypotheekProfiel hp, Hypotheek hypotheek) {
    ref.listen<Hypotheek?>(
        hypotheekBewerkenProvider
            .select((HypotheekBewerken value) => value.hypotheek),
        listen);

    final maxTermijnenInJaren =
        HypotheekVerwerken.maxTermijnenInJaren(hp, hypotheek);

    List<Widget> children = [
      const SizedBox(
        height: 8.0,
      ),
      AnimatedScaleResizeSwitcher(
          child: hypotheek.optiesHypotheekToevoegen ==
                  OptiesHypotheekToevoegen.verlengen
              ? const SizedBox.shrink()
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Aflostermijn (jaren)'),
                  Row(children: [
                    Expanded(
                        child: Slider(
                            min: 1.0,
                            max: maxTermijnenInJaren.toDouble(),
                            value: hypotheek.aflosTermijnInJaren.toDouble(),
                            divisions: hypotheek.aflosTermijnInJaren - 1 < 1
                                ? 1
                                : hypotheek.aflosTermijnInJaren - 1,
                            onChanged: (double value) =>
                                _veranderenAflosTermijnInJaren(
                                    value: value.toInt(),
                                    max: maxTermijnenInJaren))),
                    SizedBox(
                      width: 50.0,
                      child: TextFormField(
                          controller: _tecAflosTermijnInJaren,
                          focusNode: _fnAflosTermijnInJaren,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: '1-$maxTermijnenInJaren',
                              labelText: 'Termijn'),
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: false,
                          ),
                          inputFormatters: [nf.numberInputFormat('#0')],
                          textInputAction: TextInputAction.next),
                    ),
                    const SizedBox(
                      width: 16.0,
                    )
                  ]),
                  const SizedBox(
                    height: 8.0,
                  ),
                ])),
      const Text('Rentevaste periode (jaren)'),
      Row(children: [
        Expanded(
            child: Slider(
                min: 1.0,
                max: hypotheek.aflosTermijnInJaren.toDouble(),
                value: hypotheek.periodeInJaren.toDouble(),
                divisions: hypotheek.aflosTermijnInJaren - 1 < 1
                    ? 1
                    : hypotheek.aflosTermijnInJaren - 1,
                onChanged: (double value) => _veranderenPeriodeInJaren(
                    value: value.toInt(), max: maxTermijnenInJaren))),
        SizedBox(
          width: 50.0,
          child: TextFormField(
              textAlign: TextAlign.center,
              controller: _tecPeriodeInJaren,
              focusNode: _fnPeriodeInJaren,
              decoration: InputDecoration(
                  hintText: '1-${hypotheek.aflosTermijnInJaren}',
                  labelText: 'Periode'),
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              inputFormatters: [nf.numberInputFormat('#0')],
              textInputAction: TextInputAction.next),
        ),
        const SizedBox(
          width: 16.0,
        )
      ]),
      const SizedBox(
        height: 4.0,
      ),
      AnimatedScaleResizeSwitcher(
          child: hypotheek.afgesloten
              ? const SizedBox.shrink()
              : MyCheckbox(
                  text: 'Nationale hypotheek garantie (NHG)',
                  value: hypotheek.toepassenNhg,
                  onChanged: _veranderingToepassenNHG)),
    ];

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ));
  }

  _veranderenAflosTermijnInJaren({required int? value, required int? max}) {
    if (value == null || max == null) return;

    if (value < 1) {
      value = 1;
      _tecAflosTermijnInJaren.text = '1';
    } else if (value > max) {
      value = max;
      _tecAflosTermijnInJaren.text = max.toString();
    }
    notifier.verandering(aflosTermijnInMaanden: value * 12);
  }

  _veranderenPeriodeInJaren({required int? value, required int? max}) {
    if (value == null || max == null) return;

    if (value < 1) {
      value = 1;
      _tecPeriodeInJaren.text = '1';
    } else if (value > max) {
      value = max;
      _tecPeriodeInJaren.text = max.toString();
    }
    notifier.verandering(periodeInMaanden: value * 12);
  }

  _veranderingToepassenNHG(bool? value) {
    notifier.verandering(toepassenNhg: value);
  }
}

/// Verduurzamen
///
///
///
///
///
///

// class VerduurzamenPanel extends ConsumerStatefulWidget {
//   const VerduurzamenPanel({
//     super.key,
//   });

//   @override
//   ConsumerState<VerduurzamenPanel> createState() => VerduurzamenPanelState();
// }

// class VerduurzamenPanelState
//     extends AbstractHypotheekConsumerState<VerduurzamenPanel>
//     with SingleTickerProviderStateMixin {
//   late List<SliverBoxItemState<Waarde>> sliverBoxList;

//   TextEditingController? _tecTaxatie;

//   TextEditingController get tecTaxatie {
//     _tecTaxatie ??= TextEditingController(
//         text: doubleToText((hypotheek) => hypotheek.verduurzaamKosten.taxatie));
//     return _tecTaxatie!;
//   }

//   FocusNode? _fnTaxatie;

//   FocusNode get fnTaxatie {
//     _fnTaxatie ??= FocusNode()
//       ..addListener(() {
//         if (!_fnTaxatie!.hasFocus) {
//           _veranderingTaxatie(nf.parsToDouble(tecTaxatie.text));
//         }
//       });
//     return _fnTaxatie!;
//   }

//   @override
//   void initState() {
//     sliverBoxList = hypotheek?.verduurzaamKosten.kosten
//             .map<SliverBoxItemState<Waarde>>((Waarde e) =>
//                 SliverBoxItemState(key: e.id, value: e, height: 72.0))
//             .toList() ??
//         [];

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tecTaxatie?.dispose();
//     _fnTaxatie?.dispose();
//     super.dispose();
//   }

//   // bool get zichtbaar =>
//   //     hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw &&
//   //     !hypotheek.afgesloten;

//   @override
//   Widget buildHypotheek(BuildContext context, HypotheekBewerken hb,
//       HypotheekProfiel hp, Hypotheek hypotheek) {
//     return SliverRowBox<String, Waarde>(

//         // visible: zichtbaar && hypotheek.verbouwVerduurzaamKosten.toepassen,
//         // visibleAnimated: true,
//         itemList: sliverBoxList,
//         topList: [
//           SliverBoxItemState(
//               height: 72, key: 'topPadding', value: 'topPadding'),
//           SliverBoxItemState(height: 72, key: 'title', value: 'title'),
//         ],
//         bottomList: [
//           SliverBoxItemState(
//               key: 'totaleKosten', height: 72.0, value: 'totaleKosten'),
//           SliverBoxItemState(key: 'bottom', height: 72.0, value: 'bottom'),
//         ],
//         buildSliverBoxItem: (
//                 {Animation? animation,
//                 required int index,
//                 required int length,
//                 required SliverBoxItemState<Waarde> state}) =>
//             _buildItem(
//                 animation: animation,
//                 index: index,
//                 length: length,
//                 state: state,
//                 hypotheek: hypotheek),
//         buildSliverBoxTopBottom: (
//                 {Animation? animation,
//                 required int index,
//                 required int length,
//                 required SliverBoxItemState<String> state}) =>
//             _buildTopBottom(
//                 animation: animation,
//                 index: index,
//                 length: length,
//                 state: state,
//                 hypotheek: hypotheek));
//   }

//   Widget _buildItem(
//       {Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<Waarde> state,
//       required Hypotheek hypotheek}) {
//     final child = DefaultKostenRowItem(
//         key: Key(state.key),
//         state: state,
//         button: (SliverBoxItemState<Waarde> state) =>
//             VerbouwenVerduurzamenKostenMenu(
//               aanpassenWaarde:
//                   (SelectedMenuPopupIdentifierValue<String, dynamic> v) =>
//                       _aanpassenWaardeOpties(state: state, iv: v),
//               waarde: state.value,
//             ),
//         omschrijvingAanpassen: (String v) => _veranderingOmschrijving(
//               waarde: state.value,
//               tekst: v,
//             ),
//         waardeAanpassen: (double value) => _veranderingWaarde(
//               waarde: state.value,
//               value: value,
//             ));

//     return SliverRowItemBackground(
//         backgroundColor: const Color.fromARGB(255, 244, 254, 251),
//         child: InsertRemoveVisibleAnimatedSliverRowItem(
//             animation: animation,
//             key: Key('item_${state.key}'),
//             state: state,
//             child: SizedSliverBox(height: state.height, child: child)));
//   }

//   Widget _buildTopBottom(
//       {Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<String> state,
//       required Hypotheek hypotheek}) {
//     switch (state.key) {
//       case 'topPadding':
//         {
//           return const SizedBox(
//             height: 16.0,
//           );
//         }
//       case 'title':
//         {
//           final theme = Theme.of(context);
//           final displaySmall = theme.textTheme.displaySmall;

//           Widget child = Padding(
//               padding: const EdgeInsets.only(
//                   left: 8.0, top: 16.0, right: 8.0, bottom: 16.0),
//               child: HeaderLayout(children: [
//                 HeaderLayoutDataWidget(
//                     id: HeaderLayoutID.title,
//                     child: Text(
//                       softWrap: true,
//                       'Verbouwen / Verduurzamen',
//                       style: displaySmall,
//                       textAlign: TextAlign.center,
//                     )),
//                 HeaderLayoutDataWidget(
//                     id: HeaderLayoutID.right,
//                     child: Switch(
//                       value: hypotheek.verduurzaamKosten.toepassen,
//                       onChanged: _veranderingVerduurzamenToepassen,
//                     )),
//               ]));

//           return SliverRowItemBackground(
//             backgroundColor: const Color.fromARGB(255, 244, 254, 251),
//             child: InsertRemoveVisibleAnimatedSliverRowItem(
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: SizedSliverBox(height: state.height, child: child),
//             ),
//           );
//         }

//       case 'bottom':
//         {
//           final child = Column(
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 ToevoegenKostenButton(
//                     icon: const Icon(Icons.list),
//                     color: const Color(0XFFBABD42),
//                     roundedRight: 0.0,
//                     pressed: toevoegenVerduurzaamKosten),
//                 const SizedBox(
//                   width: 1.0,
//                 ),
//                 ToevoegenKostenButton(
//                     roundedLeft: 0.0, pressed: toevoegenVerduurzaamKosten)
//               ]),
//               AnimatedScaleResizeSwitcher(
//                 child: hypotheek.verduurzaamKosten.toepassen
//                     ? const SizedBox.shrink()
//                     : Padding(
//                         padding: const EdgeInsets.only(
//                             left: 16.0, right: 16.0, bottom: 16.0),
//                         child: TextFormField(
//                             controller: _tecTaxatie,
//                             focusNode: _fnTaxatie,
//                             decoration: const InputDecoration(
//                                 hintText: 'Wonigwaarde na verb./verd.',
//                                 labelText: 'Taxatie'),
//                             keyboardType: const TextInputType.numberWithOptions(
//                               signed: true,
//                               decimal: true,
//                             ),
//                             inputFormatters: [
//                               MyNumberFormat(context).numberInputFormat('#')
//                             ],
//                             textInputAction: TextInputAction.done),
//                       ),
//               ),
//             ],
//           );

//           return SliverRowItemBackground(
//             radialbottom: 32.0,
//             key: Key(state.key),
//             backgroundColor: const Color.fromARGB(255, 244, 254, 251),
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
//               child: child,
//             ),
//           );
//         }
//       case 'totaleKosten':
//         {
//           final child = TotaleKostenRowItem(
//             backgroundColor: const Color.fromARGB(255, 244, 254, 251),
//             totaleKosten: hypotheek.verduurzaamKosten.totaleKosten,
//           );

//           return SliverRowItemBackground(
//             key: Key(state.key),
//             backgroundColor: const Color.fromARGB(255, 244, 254, 251),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: child,
//             ),
//           );
//         }

//       default:
//         {
//           return const Text(':(');
//         }
//     }
//   }

//   toevoegenVerduurzaamKosten() {
//     // List<RemoveWaarde> resterend = [];
//     // List<RemoveWaarde> lijst = hypotheek.verbouwVerduurzaamKosten.kosten;
//     // List<RemoveWaarde> suggestieLijst =
//     //     VerbouwVerduurzaamKosten.suggestieVerduurzamen;

//     // for (RemoveWaarde w in suggestieLijst) {
//     //   if (lijst.indexWhere((RemoveWaarde aanwezig) => aanwezig.id == w.id) ==
//     //       -1) {
//     //     resterend.add(w);
//     //   }
//     // }
//     // resterend.addAll(VerbouwVerduurzaamKosten.leegVerduurzamen);

//     // if (resterend.length == 1) {
//     //   _toevoegenWaardes(resterend);
//     // } else {
//     //   showKosten(
//     //           context: context,
//     //           lijst: resterend,
//     //           image: Image.asset('graphics/plant_groei.png'),
//     //           title: 'Kosten')
//     //       .then((List<RemoveWaarde>? value) {
//     //     if (value != null && value.isNotEmpty) {
//     //       _toevoegenWaardes(value);
//     //     }
//     //   });
//     // }
//   }

//   _toevoegenWaardes(List<RemoveWaarde> lijst) {
//     // hvm.veranderingVerduurzamenToevoegen(lijst);
//   }

//   _veranderingVerduurzamenToepassen(bool? value) {
//     // hvm.veranderingVerduurzamenToepassen(value!);
//   }

//   _veranderingOmschrijving({required Waarde waarde, required String tekst}) {
//     // hvm.veranderingKosten(waarde: waarde, name: tekst);
//   }

//   _veranderingWaarde({required Waarde waarde, required double value}) {
//     // hvm.veranderingKosten(waarde: waarde, value: value);
//   }

//   _aanpassenWaardeOpties(
//       {required SliverBoxItemState<Waarde> state,
//       required SelectedMenuPopupIdentifierValue iv}) {
//     // switch (iv.identifier) {
//     //   case 'verduurzamen':
//     //     {
//     //       hvm.veranderingVerduurzamen(
//     //           waarde: state.value, verduurzamen: iv.value);
//     //       break;
//     //     }
//     //   case 'verwijderen':
//     //     {
//     //       hvm.veranderingVerduurzamenVerwijderen([state.value]);
//     //       state.enabled = false;
//     //       break;
//     //     }
//     // }
//   }

//   _veranderingTaxatie(double value) {
//     // hvm.veranderingTaxatie(value);
//   }
// }

/* Lenning
 *
 *
 *
 * 
 *
 *
 */

// class LeningPanel extends StatefulWidget {
//   final HypotheekViewModel hypotheekViewModel;

//   LeningPanel({Key? key, required this.hypotheekViewModel}) : super(key: key);

//   @override
//   State<LeningPanel> createState() => LeningPanelState();
// }

// class LeningPanelState extends State<LeningPanel> {
//   late HypotheekViewModel hvm;
//   late final MyNumberFormat nf = MyNumberFormat(context);

//   late TextEditingController _tecRente = TextEditingController(
//       text: hypotheek.rente == 0.0 ? '' : nf.parseDblToText(hypotheek.rente));

//   late final FocusNode _fnRente = FocusNode()
//     ..addListener(() {
//       if (!_fnRente.hasFocus) {
//         _veranderingRente(_tecRente.text);
//       }
//     });

//   late TextEditingController _tecLening = TextEditingController(
//       text: hypotheek.gewensteLening == 0
//           ? ''
//           : nf.parseDblToText(hypotheek.gewensteLening));

//   bool focusLening = false;
//   late final FocusNode _fnLening = FocusNode()
//     ..addListener(() {
//       if (_fnLening.hasFocus) {
//         focusLening = true;
//       } else if (!_fnLening.hasFocus && focusLening) {
//         _veranderingLening(_tecLening.text);
//         focusLening = false;
//       }
//     });

//   RemoveHypotheek get hypotheek => hvm.hypotheek;

//   RemoveHypotheekProfiel get profiel => hvm.profiel;

//   @override
//   void initState() {
//     hvm = widget.hypotheekViewModel..leningPanelState = this;
//     super.initState();
//   }

//   @override
//   void dispose() {
//     hvm.leningPanelState = null;
//     _tecLening.dispose();
//     _fnLening.dispose();
//     _tecRente.dispose();
//     _fnRente.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final headerTextStyle = theme.textTheme.headline4;
//     Widget leningWidget;

//     switch (hypotheek.optiesHypotheekToevoegen) {
//       case OptiesHypotheekToevoegen.nieuw:
//         leningWidget =
//             hvm.isBestaandeHypotheek || !hypotheek.maxLening.toepassen
//                 ? _bestaandeLening(context)
//                 : _nieuwLening(context);
//         break;
//       case OptiesHypotheekToevoegen.verlengen:
//         leningWidget = _verlengenLening(context);
//         break;
//     }

//     List<Widget> children = [
//       SizedBox(
//         height: 16.0,
//       ),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: _horizontal),
//         child: Text(
//           'Hypotheekvorm',
//           style: headerTextStyle,
//         ),
//       ),
//       SizedBox(
//         height: 8.0,
//       ),
//       _vorm(),
//       AnimatedScaleResizeSwitcher(
//         child: leningWidget,
//       )
//     ];

//     return SliverToBoxAdapter(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: children,
//     ));
//   }

//   _nieuwLening(BuildContext context) {
//     return Column(
//       key: Key('NieuwLening'),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: _renteField(),
//         ),
//         SizedBox(
//           height: 8.0,
//         ),
//         PinkLeningInfo(profiel: profiel, hypotheek: hypotheek),
//         Row(
//           children: [
//             SizedBox(
//               width: _horizontal,
//             ),
//             Expanded(child: _leningField()),
//             TextButton(
//                 child: Text('Max'),
//                 onPressed: () => _veranderingMaxLening(100.0)),
//             SizedBox(
//               width: _horizontal,
//             ),
//           ],
//         )
//       ],
//     );
//   }

//   _bestaandeLening(context) {
//     final firstDate = hypotheek.startDatum;
//     final lastDate = hvm.eindDatumDeelsAfgelosteLening();

//     Widget dateWidget = hypotheek.deelsAfgelosteLening
//         ? DateInputPicker(
//             labelText: 'Datum',
//             date: hypotheek.datumDeelsAfgelosteLening,
//             firstDate: firstDate,
//             lastDate: lastDate,
//             saveDate: _veranderingDatumDeelsAfgelosteLening,
//             changeDate: _veranderingDatumDeelsAfgelosteLening)
//         : SizedBox.shrink();

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: _horizontal),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (firstDate.compareTo(lastDate) < 0)
//             SelectableCheckGroup(
//               selectableItems: [
//                 SelectableCheckItem(
//                     text: 'Deels afgeloste lening invullen',
//                     value: hypotheek.deelsAfgelosteLening,
//                     changeChecked: _veranderingDeelsAfgelost)
//               ],
//             ),
//           AnimatedScaleResizeSwitcher(child: dateWidget),
//           Row(
//             children: [
//               Expanded(child: _leningField()),
//               SizedBox(
//                 width: 16.0,
//               ),
//               SizedBox(
//                 width: 80.0,
//                 child: _renteField(),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   _verlengenLening(BuildContext context) {
//     return Column(
//       key: Key('verlengenLening'),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: _horizontal),
//           child: _renteField(),
//         ),
//         SizedBox(
//           height: 8.0,
//         ),
//         PinkLeningInfo(profiel: profiel, hypotheek: hypotheek),
//       ],
//     );
//   }

//   Widget _vorm() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: _horizontal),
//       child: UndefinedSelectableGroup(
//         children: [
//           RemoveSelectedRadioBox<HypotheekVorm>(
//               text: 'Annuïteit',
//               value: HypotheekVorm.annuity,
//               groupValue: hypotheek.hypotheekvorm,
//               onChange: _veranderingHypotheekvorm),
//           RemoveSelectedRadioBox<HypotheekVorm>(
//               text: 'Lineair',
//               value: HypotheekVorm.linear,
//               groupValue: hypotheek.hypotheekvorm,
//               onChange: _veranderingHypotheekvorm),
//           AnimatedScaleResizeSwitcher(
//             child: hypotheek.maxLeningNHG.toepassen
//                 ? SizedBox.shrink()
//                 : RemoveSelectedRadioBox<HypotheekVorm>(
//                     text: 'Aflosvrij',
//                     value: HypotheekVorm.aflosvrij,
//                     groupValue: hypotheek.hypotheekvorm,
//                     onChange: _veranderingHypotheekvorm),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _renteField() {
//     return TextFormField(
//         controller: _tecRente,
//         focusNode: _fnRente,
//         onSaved: _veranderingRente,
//         validator: (String? value) {
//           double rente = value == null ? 0.0 : nf.parsToDouble(value);
//           return (rente < 0.0 || rente > 10) ? '0-10%' : null;
//         },
//         decoration: new InputDecoration(hintText: '%', labelText: 'Rente (%)'),
//         keyboardType: TextInputType.numberWithOptions(
//           signed: true,
//           decimal: true,
//         ),
//         inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
//         textInputAction: TextInputAction.done);
//   }

//   Widget _leningField() {
//     return TextFormField(
//         onSaved: _veranderingLening,
//         validator: (String? value) =>
//             (value != null && nf.parsToDouble(value) == 0.0) ? '> 0.0' : null,
//         controller: _tecLening,
//         focusNode: _fnLening,
//         decoration: InputDecoration(hintText: 'Bedrag', labelText: 'Lening'),
//         keyboardType: TextInputType.numberWithOptions(
//           signed: true,
//           decimal: true,
//         ),
//         inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
//         textInputAction: TextInputAction.done);
//   }

//   _veranderingHypotheekvorm(HypotheekVorm? value) {
//     if (value == null) return;
//     hvm.veranderingHypotheekvorm(value);
//   }

//   _veranderingRente(String? value) {
//     if (value == null) return;
//     hvm.veranderingRente(nf.parsToDouble(value));
//   }

//   _veranderingLening(String? value) {
//     if (value == null) return;
//     hvm.veranderingLening(nf.parsToDouble(value));
//   }

//   setLening(double value) {
//     if ((nf.parsToDouble(_tecLening.text) - value).abs() > 0.009) {
//       _tecLening.text = nf.parseDblToText(value);
//     }
//   }

//   _veranderingMaxLening(double value) {
//     hvm.veranderingMaximaleLening(value);
//   }

//   _veranderingDeelsAfgelost(bool? value) {
//     hvm.veranderingDeelsAfgelost(value!);
//   }

//   _veranderingDatumDeelsAfgelosteLening(DateTime? value) {
//     if (value == null) return;
//     hvm.veranderingDatumDeelsAfgelosteLening(value);
//   }

//   void updateState() {
//     setState(() {});
//   }
// }

// /* Kosten
//  *
//  *
//  *
//  * 
//  *
//  *
//  */

// class HypotheekKostenPanel extends StatefulWidget {
//   const HypotheekKostenPanel({super.key});

//   @override
//   State<HypotheekKostenPanel> createState() => HypotheekKostenPanelState();
// }

// class HypotheekKostenPanelState extends State<HypotheekKostenPanel> {
//   late final MyNumberFormat nf = MyNumberFormat(context);
//   late HypotheekViewModel hvm;

//   RemoveHypotheek get hypotheek => hvm.hypotheek;
//   RemoveHypotheekProfiel get profiel => hvm.profiel;

//   late TextEditingController _tecWoningWaarde = TextEditingController(
//       text: hypotheek.woningLeningKosten.woningWaarde == 0.0
//           ? ''
//           : nf.parseDblToText(hypotheek.woningLeningKosten.woningWaarde));

//   late FocusNode _fnWoningWaarde = FocusNode()
//     ..addListener(() {
//       if (!_fnWoningWaarde.hasFocus) {
//         _veranderingWoningwaardeWoning(_tecWoningWaarde.text);
//       }
//     });

//   late List<SliverBoxItemState<RemoveWaarde>> sliverBoxList;

//   @override
//   void initState() {
//     hvm = widget.hypotheekViewModel..hypotheekKostenPanelState = this;

//     sliverBoxList = hypotheek.woningLeningKosten.kosten
//         .map((RemoveWaarde e) => SliverBoxItemState<RemoveWaarde>(
//             key: '${e.id}_${e.index}',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: e))
//         .toList();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tecWoningWaarde.dispose();
//     _fnWoningWaarde.dispose();
//     hvm.hypotheekKostenPanelState = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RemoveSliverRowBox<String, RemoveWaarde>(
//       heightItem: 72.0,
//       visible: true,
//       visibleAnimated: false,
//       itemList: sliverBoxList,
//       topList: [
//         SliverBoxItemState(
//             key: 'topPadding',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: 'topPadding'),
//         SliverBoxItemState(
//             key: 'woningTitle',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: 'woningTitle'),
//         SliverBoxItemState(
//             key: 'woning',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: 'woning'),
//         SliverBoxItemState(
//             key: 'kostenTitle',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: 'kostenTitle'),
//       ],
//       bottomList: [
//         SliverBoxItemState(
//             key: 'totaleKosten',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: 'totaleKosten'),
//         SliverBoxItemState(
//             key: 'bottom',
//             insertRemoveAnimation: 1.0,
//             enabled: true,
//             value: 'bottom'),
//       ],
//       buildSliverBoxItem: _buildItem,
//       buildSliverBoxTopBottom: _buildTopBottom,
//     );
//   }

//   Widget _buildItem(
//       {Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<RemoveWaarde> state}) {
//     final child = DefaultKostenRowItem(
//         key: Key(state.key),
//         state: state,
//         button: (SliverBoxItemState<RemoveWaarde> state) => StandaardKostenMenu(
//               aanpassenWaarde:
//                   (SelectedMenuPopupIdentifierValue<String, dynamic> v) =>
//                       _veranderingWaardeOpties(state: state, iv: v),
//               waarde: state.value,
//             ),
//         omschrijvingAanpassen: (String v) => _veranderingOmschrijving(
//               waarde: state.value,
//               text: v,
//             ),
//         waardeAanpassen: (double value) => _veranderingWaarde(
//               waarde: state.value,
//               value: value,
//             ));

//     return SliverRowItemBackground(
//         key: Key(state.key),
//         backgroundColor: Color.fromARGB(255, 239, 249, 253),
//         radialTop: 0.0,
//         radialbottom: 0.0,
//         child: InsertRemoveVisibleAnimatedSliverRowItem(
//             state: state, child: child, enableAnimation: animation));
//   }

//   Widget _buildTopBottom(
//       {Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<String> state}) {
//     switch (state.key) {
//       case 'topPadding':
//         {
//           return SizedBox(
//             height: 16.0,
//           );
//         }
//       case 'woningTitle':
//         {
//           final theme = Theme.of(context);
//           final headline3 = theme.textTheme.headline3;

//           final child = Center(
//               child: Text(
//             'Woning',
//             style: headline3,
//             textAlign: TextAlign.center,
//           ));

//           return SliverRowItemBackground(
//               radialTop: 32.0,
//               key: Key(state.key),
//               backgroundColor: Color.fromARGB(255, 239, 249, 253),
//               child: VisibleAnimatedSliverRowItem(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: child,
//                 ),
//                 enableAnimation: animation,
//               ));
//         }
//       case 'woning':
//         {
//           final child = TextFormField(
//             controller: _tecWoningWaarde,
//             focusNode: _fnWoningWaarde,
//             decoration:
//                 InputDecoration(hintText: 'Bedrag', labelText: 'Woningwaarde'),
//             keyboardType: TextInputType.numberWithOptions(
//               signed: true,
//               decimal: true,
//             ),
//             inputFormatters: [
//               MyNumberFormat(context).numberInputFormat('#.00')
//             ],
//             validator: (String? value) {
//               if (profiel.woningWaardeNormToepassen &&
//                   nf.parsToDouble(value) == 0.0) {
//                 return 'Geen bedrag > 0';
//               }
//               return null;
//             },
//           );

//           return SliverRowItemBackground(
//               key: Key(state.key),
//               backgroundColor: Color.fromARGB(255, 239, 249, 253),
//               child: VisibleAnimatedSliverRowItem(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 16.0, top: 4.0, right: 16.0, bottom: 2.0),
//                   child: child,
//                 ),
//                 enableAnimation: animation,
//               ));
//         }
//       case 'kostenTitle':
//         {
//           {
//             final theme = Theme.of(context);
//             final headline3 = theme.textTheme.headline3;

//             final child = Center(
//                 child: Text(
//               'Kosten',
//               style: headline3,
//               textAlign: TextAlign.center,
//             ));

//             return SliverRowItemBackground(
//                 key: Key(state.key),
//                 backgroundColor: Color.fromARGB(255, 239, 249, 253),
//                 child: VisibleAnimatedSliverRowItem(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: child,
//                   ),
//                   enableAnimation: animation,
//                 ));
//           }
//         }

//       case 'bottom':
//         {
//           return SliverRowItemBackground(
//               radialbottom: 32.0,
//               key: Key(state.key),
//               backgroundColor: Color.fromARGB(255, 239, 249, 253),
//               child: VisibleAnimatedSliverRowItem(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
//                   child: Center(
//                       child: ToevoegenKostenButton(pressed: toevoegKostenItem)),
//                 ),
//                 enableAnimation: animation,
//               ));
//         }
//       case 'totaleKosten':
//         {
//           final child = TotaleKostenRowItem(
//             backgroundColor: Color.fromARGB(255, 239, 249, 253),
//             enableAnimation: animation,
//             state: state,
//             totaleKosten: hypotheek.woningLeningKosten.totaleKosten,
//           );

//           return SliverRowItemBackground(
//               key: Key(state.key),
//               backgroundColor: Color.fromARGB(255, 239, 249, 253),
//               child: VisibleAnimatedSliverRowItem(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: child,
//                 ),
//                 enableAnimation: animation,
//               ));
//         }
//       default:
//         {
//           return Text(':(');
//         }
//     }
//   }

//   toevoegKostenItem() {
//     List<RemoveWaarde> lijst = hypotheek.woningLeningKosten.kosten;
//     List<RemoveWaarde> suggestieLijst =
//         WoningLeningKostenGegevens.suggestieKosten(
//             overdrachtBelasting: hvm.suggestieOverdrachtBelasting,
//             nhg: hypotheek.maxLeningNHG.toepassen);

//     List<RemoveWaarde> resterend = [];

//     for (RemoveWaarde w in suggestieLijst) {
//       if (lijst.indexWhere((RemoveWaarde aanwezig) => aanwezig.id == w.id) ==
//           -1) {
//         resterend.add(w);
//       }
//     }
//     resterend.add(leegKosten);

//     if (resterend.length == 1) {
//       _toevoegenWaardes(resterend);
//     } else {
//       showKosten(
//               context: context,
//               lijst: resterend,
//               image: Image.asset('graphics/kapot_varken.png'),
//               title: 'Kosten')
//           .then((List<RemoveWaarde>? value) {
//         if (value != null && value.isNotEmpty) {
//           _toevoegenWaardes(value);
//         }
//       });
//     }
//   }

//   _toevoegenWaardes(List<RemoveWaarde> lijst) {
//     hvm.veranderingKostenToevoegen(lijst);
//   }

//   _veranderingWoningwaardeWoning(String? value) {
//     hvm.veranderingWoningwaardeWoning(nf.parsToDouble(value));
//   }

//   _veranderingOmschrijving(
//       {required RemoveWaarde waarde, required String text}) {
//     hvm.veranderingKosten(waarde: waarde, name: text);
//   }

//   _veranderingWaarde({required RemoveWaarde waarde, required double value}) {
//     hvm.veranderingKosten(waarde: waarde, value: value);
//   }

//   _veranderingWaardeOpties(
//       {required SliverBoxItemState<RemoveWaarde> state,
//       required SelectedMenuPopupIdentifierValue<String, dynamic> iv}) {
//     switch (iv.identifier) {
//       case 'eenheid':
//         {
//           hvm.veranderingKosten(waarde: state.value, eenheid: iv.value);
//           break;
//         }
//       case 'aftrekken':
//         {
//           hvm.veranderingKosten(waarde: state.value, aftrekbaar: iv.value);
//           break;
//         }
//       case 'verwijderen':
//         {
//           hvm.veranderingKostenVerwijderen([state.value]);
//           state.enabled = false;
//           break;
//         }
//     }
//   }

//   void updateState() {
//     setState(() {});
//   }
// }

// class PinkLeningInfo extends StatelessWidget {
//   final RemoveHypotheekProfiel profiel;
//   final RemoveHypotheek hypotheek;

//   const PinkLeningInfo(
//       {Key? key, required this.profiel, required this.hypotheek})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final nf = MyNumberFormat(context);

//     List<Widget> errorMessage = [];

//     void foutMeldingToevoegen(Norm norm) {
//       if (norm.fouten.isNotEmpty) {
//         errorMessage.addAll(norm.fouten.map((String fout) => Text(fout,
//             style: theme.textTheme.bodyText2
//                 ?.copyWith(color: Color.fromARGB(255, 159, 24, 14)))));
//       }
//     }

//     foutMeldingToevoegen(hypotheek.maxLeningInkomen);
//     foutMeldingToevoegen(hypotheek.maxLeningWoningWaarde);

//     final maxLening = hypotheek.maxLening;

//     Widget child;

//     if (maxLening.toepassen && maxLening.fouten.isEmpty) {
//       final m = DefaultTextStyle(
//           style: theme.textTheme.bodyText2!
//               .copyWith(color: Colors.brown[900], fontSize: 18.0),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('Maximale Lening:'),
//             Text(
//               nf.parseDoubleToText(maxLening.resterend, '#0'),
//               textScaleFactor: 2.0,
//             )
//           ]));

//       child = Stack(children: [
//         Positioned(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: m),
//         if (errorMessage.isNotEmpty)
//           Positioned(
//               left: 16.0,
//               right: 16.0,
//               bottom: 0.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.warning, color: Color.fromARGB(255, 159, 24, 14)),
//                   SizedBox(
//                     width: 8.0,
//                   ),
//                   Column(
//                       mainAxisSize: MainAxisSize.min, children: errorMessage),
//                 ],
//               ))
//       ]);
//     } else {
//       child = Center(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.warning,
//                 color: Color.fromARGB(255, 159, 24, 14),
//                 size: 128.0,
//               ),
//               ...errorMessage
//             ]),
//       );
//     }

//     return AnimatedSwitcher(
//         duration: const Duration(milliseconds: 200),
//         child: (hypotheek.rente == 0.0)
//             ? SizedBox.shrink()
//             : Material(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(32.0)),
//                 color: Color.fromARGB(
//                     255, 255, 231, 229), //Color.fromARGB(255, 253, 227, 56),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                   child: SizedBox(
//                     height: 200,
//                     child: child,
//                   ),
//                 )));
//   }
// }
