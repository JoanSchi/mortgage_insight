// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/animated_sliver_box_goodies/sliver_box_transfer_widget.dart';
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:beamer/beamer.dart';
import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/vervolg_lening/vervolg_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_verwerken.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/vervolg_hypotheek_sliver_box_model.dart';
import 'package:mortgage_insight/platform_page_format/default_match_page_properties.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../platform_page_format/default_page.dart';
import '../../../platform_page_format/page_actions.dart';
import '../../../utilities/device_info.dart';
import '../../../utilities/match_properties.dart';
import 'abstract_hypotheek_consumer.dart';
import 'hypotheek_verleng_card.dart';
import 'model/hypotheek_view_model.dart';
import 'model/hypotheek_view_state.dart';

class BewerkHypotheek extends ConsumerStatefulWidget {
  const BewerkHypotheek({super.key});

  @override
  ConsumerState<BewerkHypotheek> createState() => BewerkHypotheekState();
}

class BewerkHypotheekState extends ConsumerState<BewerkHypotheek> {
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;

    final save =
        PageActionItem(text: 'Opslaan', icon: Icons.done, voidCallback: _save);

    final cancel = PageActionItem(
        text: 'Annuleren', icon: Icons.arrow_back, voidCallback: _pop);

    return DefaultPage(
        title: 'Toevoegen',
        imageBuilder: (_) => Image(
            image: const AssetImage(
              'graphics/fit_geldzak.png',
            ),
            color: theme.colorScheme.onSurface),
        getPageProperties: (
                {required bool hasScrollBars,
                required FormFactorType formFactorType,
                required Orientation orientation,
                required double bottom}) =>
            hypotheekPageProperties(
                hasScrollBars: hasScrollBars,
                formFactorType: formFactorType,
                orientation: orientation,
                bottom: bottom,
                leftTopActions: [cancel],
                rightTopActions: [save]),
        bodyBuilder: bodyBuilder);
  }

  Widget bodyBuilder(
      {required BuildContext context, required EdgeInsets padding}) {
    return Form(
      key: _formKey,
      child: CustomScrollView(slivers: [
        SliverPadding(
            padding: padding.copyWith(bottom: 0.0),
            sliver: const HypotheekBewerkOmschrijvingToevoegOptie()),
        const HypotheekBewerkDatumVerlengen(),
        // const TermijnPeriodePanel(),
        // const HypotheekKostenPanel(),
        // const VerduurzamenPanel(),
        // const LeningPanel(),
        // SpacerFinancieringsTabel(),
        // FinancieringsNormTable(),
        // VerdelingLeningen(),
        // OverzichtHypotheek(),
        // OverzichtHypotheekTabel()
      ]),
    );
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      HypotheekViewState viewState = ref.read(hypotheekBewerkenProvider);

      final hypotheekDossier = viewState.hypotheekDossier;
      final hypotheek = viewState.hypotheek;

      if (hypotheek == null) {
        return;
      }

      ref
          .read(hypotheekDocumentProvider.notifier)
          .hypotheekDossierToevoegen(hypotheekDossier: hypotheekDossier);

      _pop();
    }
  }

  void _pop() {
    scheduleMicrotask(() {
      Beamer.of(context, root: true).popToNamed('/document/hypotheek/lening');
    });
  }
}

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
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
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

    if (hypotheekViewState.teVerlengen.isNotEmpty) {
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
                        selectedGroupTheme: SelectedGroupTheme.button,
                        space: 6.0))),
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
    extends AbstractHypotheekConsumerState<HypotheekBewerkDatumVerlengen>
    with SingleTickerProviderStateMixin {
  late VervolgHypotheekSliverBoxModel vervolgHypotheekSliverBoxModel;
  late final AnimationController animationController;
  late Tween<double> tweenHeight;
  late Animation<double> animation;

  @override
  void initState() {
    final height = ref.read(hypotheekBewerkenProvider).heightVervolg;
    tweenHeight = Tween(begin: height, end: height);

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    animation = animationController.drive(tweenHeight);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant HypotheekBewerkDatumVerlengen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void checkHeight(double toHeight) {
    if (toHeight != tweenHeight.end) {
      animationController.stop();

      tweenHeight
        ..begin = animation.value
        ..end = toHeight;

      animationController
        ..value = 0.0
        ..forward();
    }
  }

  VervolgHypotheekSliverBoxModel createSliverRowBoxModel(
      HypotheekViewState hypotheekViewState,
      AnimatedSliverBoxState<VervolgHypotheekSliverBoxModel> sliverBoxContext,
      Axis axis) {
    var (String tag, List<VervolgHypotheekItemBoxProperties> items, _) =
        hypotheekViewState.vervolgBoxItems(
      transitionState: BoxItemTransitionState.visible,
    );

    return VervolgHypotheekSliverBoxModel(
        axis: axis,
        sliverBoxContext: sliverBoxContext,
        box: (items.isNotEmpty)
            ? SingleBoxModel<String, VervolgHypotheekItemBoxProperties>(
                tag: tag,
                items: items,
                buildStateItem: _buildStateItem(hypotheekViewState))
            : null,
        duration: const Duration(milliseconds: 300));
  }

  updateSliverRowBoxModel(HypotheekViewState hypotheekViewState,
      VervolgHypotheekSliverBoxModel model, Axis axis) {
    for (var single in model.iterator()) {
      single.buildStateItem = _buildStateItem(hypotheekViewState);
    }
  }

  @override
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
    ref.listen(hypotheekBewerkenProvider.select((value) => value.heightVervolg),
        (previous, next) {
      if (previous != next) {
        checkHeight(next);
      }
    });
    final firstDate =
        HypotheekVerwerken.eersteKalenderDatum(hypotheekDossier, hypotheek);
    final lastDate =
        HypotheekVerwerken.laatsteKalenderDatum(hypotheekDossier, hypotheek);
    final theme = Theme.of(context);
    final headerlineMedium = theme.textTheme.headlineMedium;

    Widget vorigeOfDatum;

    List<Widget> slivers = [
      // if (hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw)
      DateInputPicker(
        date: hypotheek.startDatum,
        firstDate: firstDate,
        lastDate: lastDate,
        changeDate: _veranderingStartDatum,
        saveDate: _veranderingStartDatum,
      ),
      AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) => SizedBox(
              key: const Key('vervolgBox'),
              height: animation.value,
              child: child),
          child: CustomScrollView(scrollDirection: Axis.horizontal, slivers: [
            AnimatedSliverBox<VervolgHypotheekSliverBoxModel>(
              controllerSliverRowBox:
                  hypotheekViewState.vervolgHypotheekSliverBoxController,
              createSliverRowBoxModel:
                  (AnimatedSliverBoxState<VervolgHypotheekSliverBoxModel>
                              sliverBoxContext,
                          Axis axis) =>
                      createSliverRowBoxModel(
                          hypotheekViewState, sliverBoxContext, axis),
              updateSliverRowBoxModel:
                  (VervolgHypotheekSliverBoxModel model, Axis axis) =>
                      updateSliverRowBoxModel(hypotheekViewState, model, axis),
              axis: Axis.horizontal,
            ),
          ]))
    ];

    //   Map<DateTime, RestSchuldHypotheken> restSchuldHypotheken =
    //       HypotheekVerwerken.restSchuldInventarisatie(
    //           hypotheekBewerken.hypotheekDossier, hypotheekBewerken.id);

    //   if (restSchuldHypotheken.isNotEmpty) {
    //     vorigeOfDatum = Column(children: [
    //       vorigeOfDatum,
    //       const SizedBox(
    //         height: 16.0,
    //       ),
    //       Text('Oversluiten', style: headerlineMedium),
    //       const SizedBox(
    //         height: 8.0,
    //       ),
    //       LayoutBuilder(
    //           builder: (BuildContext context, BoxConstraints constraints) {
    //         double width = constraints.maxWidth;

    //         const max = 150.0;
    //         const inner = 6.0;

    //         final r = 1.0 + ((width - max) / (max + inner)).floorToDouble();

    //         final w = (width - r * inner + inner) / r;

    //         return Wrap(spacing: 6.0, children: [
    //           for (CombiRestSchuld r in hypotheekBewerken.restSchulden.values)
    //             SizedBox(
    //               width: w,
    //               height: w / 3.0 * 2.0,
    //               child: RestSchuldHypotheekCard(
    //                 hypotheekDossier: hypotheekDossier,
    //                 restSchuld: r,
    //                 selected: hypotheek.startDatum,
    //                 changed: _veranderingStartDatum,
    //               ),
    //             )
    //         ]);
    //       })
    //     ]);
    //   }
    // } else {
    //   vorigeOfDatum = LayoutBuilder(
    //       builder: (BuildContext context, BoxConstraints constraints) {
    //     double width = constraints.maxWidth;

    //     const max = 300.0;
    //     const inner = 6.0;

    //     final r = 1.0 + ((width - max) / (max + inner)).floorToDouble();

    //     final w = (width - r * inner + inner) / r;

    //     return Wrap(
    //         spacing: 6.0,
    //         children: hypotheekBewerken.teVerlengen
    //             .map((Hypotheek e) => SizedBox(
    //                   width: w,
    //                   height: w / 3.0 * 2.0,
    //                   child: VerlengCard(
    //                     hypotheek: e,
    //                     selected: hypotheek.vorige,
    //                     changed: _veranderingVorigeHypotheek,
    //                   ),
    //                 ))
    //             .toList());
    //   });
    // }

    return SliverList(
      delegate: SliverChildListDelegate.fixed(slivers),
    );
  }

  BuildStateItem<String, VervolgHypotheekItemBoxProperties> _buildStateItem(
      HypotheekViewState hypotheekViewState) {
    return (
        {required BuildContext buildContext,
        Animation<double>? animation,
        required AnimatedSliverBoxModel<String> model,
        required VervolgHypotheekItemBoxProperties properties,
        required SingleBoxModel<String, VervolgHypotheekItemBoxProperties>
            singleBoxModel,
        required int index}) {
      var (Widget child, String id) = switch (properties.vervolgLening) {
        (HerFinancieren herFinancieren) => (
            HerfinancierenCard(
              changed: (DateTime? value) {},
              hypotheekDossier: hypotheekViewState.hypotheekDossier,
              herfinancieren: herFinancieren,
              selected: null,
            ),
            'hf_${herFinancieren.id}'
          ),
        (LeningVerlengen leningVerlengen) => (
            VerlengCard(
                changed: (String? v) {},
                leningVerlengen: leningVerlengen,
                selected: hypotheekViewState.hypotheek?.vorige),
            'vl_${leningVerlengen.id}'
          )
      };

      return SliverBoxTransferWidget(
          key: Key(id),
          model: model,
          boxItemProperties: properties,
          animation: animation,
          singleBoxModel: singleBoxModel,
          child: SizedBox(width: properties.size(model.axis), child: child));
    };
  }

  _veranderingStartDatum(DateTime? value) {
    notifier.verandering(startDatum: value);
  }

  _veranderingVorigeHypotheek(String? value) {
    notifier.verandering(vorige: value ?? '');
  }
}

// /// Termijn, Periode, NHG en Verduurzamen
// ///
// ///
// ///
// ///
// ///
// ///

// class TermijnPeriodePanel extends ConsumerStatefulWidget {
//   const TermijnPeriodePanel({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       TermijnPeriodePanelState();
// }

// class TermijnPeriodePanelState
//     extends AbstractHypotheekConsumerState<TermijnPeriodePanel> {
//   late final TextEditingController _tecAflosTermijnInJaren;
//   late final FocusNode _fnAflosTermijnInJaren;
//   late final TextEditingController _tecPeriodeInJaren;
//   late final FocusNode _fnPeriodeInJaren;

//   @override
//   void initState() {
//     _tecAflosTermijnInJaren = TextEditingController(
//         text: intToText((hypotheek) => hypotheek.aflosTermijnInJaren));

//     _fnAflosTermijnInJaren = FocusNode()
//       ..addListener(() {
//         if (!_fnAflosTermijnInJaren.hasFocus) {
//           _veranderenAflosTermijnInJaren(
//             value: int.tryParse(_tecAflosTermijnInJaren.text),
//           );
//         }
//       });

//     _tecPeriodeInJaren = TextEditingController(
//         text: intToText((hypotheek) => hypotheek.periodeInJaren));

//     _fnPeriodeInJaren = FocusNode()
//       ..addListener(() {
//         if (!_fnPeriodeInJaren.hasFocus) {
//           _veranderenPeriodeInJaren(
//             value: int.tryParse(_tecPeriodeInJaren.text),
//           );
//         }
//       });

//     super.initState();
//   }

//   // int? get maxTermijnenInJaren {
//   //   final hypotheekBewerken = ref.read(hypotheekBewerkenProvider);
//   //   final hp = hypotheekBewerken.hypotheekDossier;
//   //   final hypotheek = hypotheekBewerken.hypotheek;

//   //   return hp != null && hypotheek != null
//   //       ? HypotheekVerwerken.maxTermijnenInJaren(hp, hypotheek)
//   //       : null;
//   // }

//   @override
//   void dispose() {
//     _tecAflosTermijnInJaren.dispose();
//     _fnAflosTermijnInJaren.dispose();
//     _tecPeriodeInJaren.dispose();
//     _fnPeriodeInJaren.dispose();
//     super.dispose();
//   }

//   listen(Hypotheek? previous, Hypotheek? next) {
//     if (next == null) return;

//     if (previous?.aflosTermijnInJaren != next.aflosTermijnInJaren &&
//         nf.parsToInt(_tecAflosTermijnInJaren.text) !=
//             next.aflosTermijnInJaren) {
//       _tecAflosTermijnInJaren.text = '${next.aflosTermijnInJaren}';
//     }

//     if (previous?.periodeInJaren != next.periodeInJaren &&
//         nf.parsToInt(_tecPeriodeInJaren.text) != next.periodeInJaren) {
//       _tecPeriodeInJaren.text = '${next.periodeInJaren}';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewState = ref.watch(hypotheekBewerkenProvider);
//     final hp = viewState.hypotheekDossier;
//     final hypotheek = viewState.hypotheek;

//     return (hypotheek != null)
//         ? buildHypotheek(context, viewState, hp, hypotheek)
//         : ohno();
//   }

//   Widget buildHypotheek(BuildContext context, HypotheekViewState viewState,
//       HypotheekDossier hypotheekDossier, Hypotheek hypotheek) {
//     ref.listen<Hypotheek?>(
//         hypotheekBewerkenProvider
//             .select((HypotheekViewState value) => value.hypotheek),
//         listen);

//     final maxTermijnenInJaren = HypotheekVerwerken.maxTermijnenInJaren(
//         hypotheekDossier,
//         vorige: hypotheek.vorige);

//     List<Widget> children = [
//       const SizedBox(
//         height: 8.0,
//       ),
//       AnimatedScaleResizeSwitcher(
//           child: hypotheek.optiesHypotheekToevoegen ==
//                   OptiesHypotheekToevoegen.verlengen
//               ? const SizedBox.shrink()
//               : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   const Text('Aflostermijn (jaren)'),
//                   Row(children: [
//                     Expanded(
//                         child: Slider(
//                             min: 1.0,
//                             max: maxTermijnenInJaren.toDouble(),
//                             value: hypotheek.aflosTermijnInJaren.toDouble(),
//                             divisions: maxTermijnenInJaren - 1 < 1
//                                 ? 1
//                                 : maxTermijnenInJaren - 1,
//                             onChanged: (double value) =>
//                                 _veranderenAflosTermijnInJaren(
//                                   value: value.toInt(),
//                                 ))),
//                     SizedBox(
//                       width: 50.0,
//                       child: TextFormField(
//                           controller: _tecAflosTermijnInJaren,
//                           focusNode: _fnAflosTermijnInJaren,
//                           textAlign: TextAlign.center,
//                           decoration: InputDecoration(
//                               hintText: '1-$maxTermijnenInJaren',
//                               labelText: 'Termijn'),
//                           keyboardType: const TextInputType.numberWithOptions(
//                             signed: true,
//                             decimal: false,
//                           ),
//                           inputFormatters: [nf.numberInputFormat('#0')],
//                           textInputAction: TextInputAction.next),
//                     ),
//                     const SizedBox(
//                       width: 16.0,
//                     )
//                   ]),
//                   const SizedBox(
//                     height: 8.0,
//                   ),
//                 ])),
//       const Text('Rentevaste periode (jaren)'),
//       Row(children: [
//         Expanded(
//           child: Slider(
//               min: 1.0,
//               max: hypotheek.aflosTermijnInJaren.toDouble(),
//               value: hypotheek.periodeInJaren.toDouble(),
//               divisions: hypotheek.aflosTermijnInJaren - 1 < 1
//                   ? 1
//                   : hypotheek.aflosTermijnInJaren - 1,
//               onChanged: (double value) =>
//                   _veranderenPeriodeInJaren(value: value.toInt())),
//         ),
//         SizedBox(
//           width: 50.0,
//           child: TextFormField(
//               textAlign: TextAlign.center,
//               controller: _tecPeriodeInJaren,
//               focusNode: _fnPeriodeInJaren,
//               decoration: InputDecoration(
//                   hintText: '1-${hypotheek.aflosTermijnInJaren}',
//                   labelText: 'Periode'),
//               keyboardType: const TextInputType.numberWithOptions(
//                 signed: true,
//                 decimal: false,
//               ),
//               inputFormatters: [nf.numberInputFormat('#0')],
//               textInputAction: TextInputAction.next),
//         ),
//         const SizedBox(
//           width: 16.0,
//         )
//       ]),
//       const SizedBox(
//         height: 4.0,
//       ),
//       AnimatedScaleResizeSwitcher(
//           child: hypotheek.afgesloten
//               ? const SizedBox.shrink()
//               : MyCheckbox(
//                   text: 'Nationale hypotheek garantie (NHG)',
//                   value: hypotheek.normNhg.toepassen,
//                   onChanged: _veranderingToepassenNHG)),
//     ];

//     return SliverToBoxAdapter(
//         child: Padding(
//       padding: const EdgeInsets.only(top: 4.0, bottom: 0.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: children,
//       ),
//     ));
//   }

//   _veranderenAflosTermijnInJaren({required int? value}) {
//     if (value == null) return;
//     notifier.verandering(aflosTermijnInMaanden: value * 12);
//   }

//   _veranderenPeriodeInJaren({required int? value}) {
//     if (value == null) return;
//     notifier.verandering(periodeInMaanden: value * 12);
//   }

//   _veranderingToepassenNHG(bool? value) {
//     notifier.verandering(toepassenNhg: value);
//   }
// }

// /* Lenning
//  *
//  *
//  *
//  * 
//  *
//  *
//  */

// class LeningPanel extends ConsumerStatefulWidget {
//   const LeningPanel({super.key});

//   @override
//   ConsumerState<LeningPanel> createState() => LeningPanelState();
// }

// class LeningPanelState extends AbstractHypotheekConsumerState<LeningPanel> {
//   late final TextEditingController _tecRente;
//   late final FocusNode _fnRente;
//   late final TextEditingController _tecLening;
//   late final FocusNode _fnLening;

//   bool focusLening = false;

//   @override
//   void initState() {
//     _tecRente = TextEditingController(
//         text: doubleToText((Hypotheek hypotheek) => hypotheek.rente));

//     _fnRente = FocusNode()
//       ..addListener(() {
//         if (!_fnRente.hasFocus) {
//           _veranderingRente(_tecRente.text);
//         }
//       });

//     _tecLening = TextEditingController(
//         text: doubleToText((Hypotheek hypotheek) => hypotheek.gewensteLening));

//     _fnLening = FocusNode()
//       ..addListener(() {
//         if (_fnLening.hasFocus) {
//           focusLening = true;
//         } else if (!_fnLening.hasFocus && focusLening) {
//           _veranderingLening(_tecLening.text);
//           focusLening = false;
//         }
//       });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tecLening.dispose();
//     _fnLening.dispose();
//     _tecRente.dispose();
//     _fnRente.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewState = ref.watch(hypotheekBewerkenProvider);
//     final hp = viewState.hypotheekDossier;
//     final hypotheek = viewState.hypotheek;

//     return (hypotheek != null)
//         ? buildHypotheek(context, viewState, hp, hypotheek)
//         : ohno();
//   }

//   Widget buildHypotheek(BuildContext context, HypotheekViewState viewState,
//       HypotheekDossier hypotheekDossier, Hypotheek hypotheek) {
//     final theme = Theme.of(context);
//     final headerTextStyle = theme.textTheme.headlineMedium;
//     Widget leningWidget;

//     switch (hypotheek.optiesHypotheekToevoegen) {
//       case OptiesHypotheekToevoegen.nieuw:
//         leningWidget = hypotheekDossier.doelHypotheekOverzicht ==
//                 DoelHypotheekOverzicht.huidigeWoning
//             ? _bestaandeLening(context, hypotheekDossier, hypotheek)
//             : _nieuwLening(context, hypotheekDossier, hypotheek);
//         break;
//       case OptiesHypotheekToevoegen.verlengen:
//         leningWidget = _verlengenLening(context, hypotheekDossier, hypotheek);
//         break;
//     }

//     List<Widget> children = [
//       const SizedBox(
//         height: 16.0,
//       ),
//       Text(
//         'Hypotheekvorm',
//         style: headerTextStyle,
//       ),
//       const SizedBox(
//         height: 8.0,
//       ),
//       _vorm(context, hypotheekDossier, hypotheek),
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

//   _nieuwLening(BuildContext context, HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
//     return Column(
//       key: const Key('NieuwLening'),
//       children: [
//         _renteField(),
//         const SizedBox(
//           height: 8.0,
//         ),
//         LeningInfo(hypotheekDossier: hypotheekDossier, hypotheek: hypotheek),
//         Row(
//           children: [
//             Expanded(child: _leningField()),
//             TextButton(
//                 child: const Text('Max'),
//                 onPressed: () => _veranderingMaxLening(100.0)),
//           ],
//         )
//       ],
//     );
//   }

//   _bestaandeLening(BuildContext context, HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
//     final firstDate = hypotheek.startDatum;
//     final lastDate =
//         HypotheekVerwerken.eindDatumDeelsAfgelosteLening(hypotheek);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (firstDate.compareTo(lastDate) < 0)
//           MyCheckbox(
//               text: 'Deels afgeloste lening invullen',
//               value: hypotheek.deelsAfgelosteLening,
//               onChanged: _veranderingDeelsAfgelost),
//         AnimatedScaleResizeSwitcher(
//             child: hypotheek.deelsAfgelosteLening
//                 ? DateInputPicker(
//                     labelText: 'Datum',
//                     date: hypotheek.datumDeelsAfgelosteLening,
//                     firstDate: firstDate,
//                     lastDate: lastDate,
//                     saveDate: _veranderingDatumDeelsAfgelosteLening,
//                     changeDate: _veranderingDatumDeelsAfgelosteLening)
//                 : const SizedBox.shrink()),
//         Row(
//           children: [
//             Expanded(child: _leningField()),
//             const SizedBox(
//               width: 16.0,
//             ),
//             SizedBox(
//               width: 80.0,
//               child: _renteField(),
//             )
//           ],
//         ),
//       ],
//     );
//   }

//   _verlengenLening(BuildContext context, HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
//     return Column(
//       key: const Key('verlengenLening'),
//       children: [
//         _renteField(),
//         const SizedBox(
//           height: 8.0,
//         ),
//         LeningInfo(hypotheekDossier: hypotheekDossier, hypotheek: hypotheek),
//       ],
//     );
//   }

//   Widget _vorm(BuildContext context, HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
//     return UndefinedSelectableGroup(
//       groups: [
//         MyRadioGroup<HypotheekVorm>(
//             groupValue: hypotheek.hypotheekvorm,
//             list: [
//               RadioSelectable(
//                   text: 'Annuïteit', value: HypotheekVorm.annuiteit),
//               RadioSelectable(text: 'Lineair', value: HypotheekVorm.lineair),
//               RadioSelectable(
//                 text: 'Aflosvrij',
//                 value: HypotheekVorm.aflosvrij,
//               )
//             ],
//             onChange: _veranderingHypotheekvorm)
//       ],
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
//         decoration:
//             const InputDecoration(hintText: '%', labelText: 'Rente (%)'),
//         keyboardType: const TextInputType.numberWithOptions(
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
//         decoration:
//             const InputDecoration(hintText: 'Bedrag', labelText: 'Lening'),
//         keyboardType: const TextInputType.numberWithOptions(
//           signed: true,
//           decimal: true,
//         ),
//         inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
//         textInputAction: TextInputAction.done);
//   }

//   _veranderingHypotheekvorm(HypotheekVorm? value) {
//     notifier.verandering(hypotheekvorm: value);
//   }

//   _veranderingRente(String? value) {
//     notifier.verandering(rente: nf.parsToDouble(value));
//   }

//   _veranderingLening(String? value) {
//     notifier.verandering(gewensteLening: nf.parsToDouble(value));
//   }

//   _veranderingMaxLening(double value) {
//     notifier.verandering(percentageMaximumLening: value);
//   }

//   _veranderingDeelsAfgelost(bool? value) {
//     notifier.verandering(deelsAfgelosteLening: value);
//   }

//   _veranderingDatumDeelsAfgelosteLening(DateTime? value) {
//     notifier.verandering(datumDeelsAfgelosteLening: value);
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

// class HypotheekKostenPanel extends ConsumerStatefulWidget {
//   const HypotheekKostenPanel({
//     super.key,
//   });

//   @override
//   ConsumerState<HypotheekKostenPanel> createState() =>
//       HypotheekKostenPanelState();
// }

// class HypotheekKostenPanelState
//     extends AbstractHypotheekConsumerState<HypotheekKostenPanel> {
//   late final TextEditingController _tecWoningWaarde;

//   late final FocusNode _fnWoningWaarde;

//   late List<SliverBoxItemState<String>> topList;
//   late List<SliverBoxItemState<Waarde>> bodyList;
//   late List<SliverBoxItemState<String>> bottomList;

//   @override
//   void initState() {
//     _tecWoningWaarde = TextEditingController(
//         text: doubleToText((Hypotheek hypotheek) =>
//             hypotheek.woningLeningKosten.woningWaarde));

//     _fnWoningWaarde = FocusNode()
//       ..addListener(() {
//         if (!_fnWoningWaarde.hasFocus) {
//           _veranderingWoningwaardeWoning(_tecWoningWaarde.text);
//         }
//       });

//     topList = HypotheekVerwerken.createTopKosten(hypotheek, true);
//     bodyList = HypotheekVerwerken.createBodyKosten(hypotheek, true);
//     bottomList = HypotheekVerwerken.createBottomKosten(hypotheek, true);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tecWoningWaarde.dispose();
//     _fnWoningWaarde.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bewerken = ref.watch(hypotheekBewerkenProvider);
//     final hp = bewerken.hypotheekDossier;
//     final hypotheek = bewerken.hypotheek;

//     return (hypotheek != null)
//         ? buildHypotheek(context, bewerken.controllerKostenLijst, hp, hypotheek)
//         : ohno();
//   }

//   Widget buildHypotheek(
//       BuildContext context,
//       ControllerSliverRowBox<String, Waarde> controllerKostenLijst,
//       HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
//     return SliverRowBox<String, Waarde>(
//       controller: controllerKostenLijst,
//       topList: topList,
//       bodyList: bodyList,
//       bottomList: bottomList,
//       buildSliverBoxItem: ({
//         required SliverRowBoxModel<String, Waarde> model,
//         Animation? animation,
//         required int index,
//         required int length,
//         required SliverBoxItemState<Waarde> state,
//       }) =>
//           _buildItem(
//               model: model,
//               animation: animation,
//               index: index,
//               length: length,
//               state: state),
//       buildSliverBoxTopBottom: ({
//         required SliverRowBoxModel<String, Waarde> model,
//         Animation? animation,
//         required int index,
//         required int length,
//         required SliverBoxItemState<String> state,
//       }) =>
//           _buildTopBottom(
//               model: model,
//               hypotheekDossier: hypotheekDossier,
//               hypotheek: hypotheek,
//               animation: animation,
//               index: index,
//               length: length,
//               state: state),
//     );
//   }

//   Widget _buildItem(
//       {required SliverRowBoxModel<String, Waarde> model,
//       Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<Waarde> state}) {
//     final child = DefaultKostenRowItem(
//         key: Key(state.key),
//         properties: state,
//         button: (SliverBoxItemState<Waarde> state) => StandaardKostenMenu(
//               aanpassenWaarde:
//                   (SelectedMenuPopupIdentifierValue<String, dynamic> v) =>
//                       _veranderingWaardeOpties(state: state, iv: v),
//               waarde: state.value,
//             ),
//         omschrijvingAanpassen: (String v) => _veranderingOmschrijving(
//               state: state,
//               text: v,
//             ),
//         waardeAanpassen: (double value) => _veranderingWaarde(
//               state: state,
//               value: value,
//             ));

//     return InsertRemoveVisibleAnimatedSliverRowItem(
//       model: model,
//       animation: animation,
//       key: Key('item_${state.key}'),
//       state: state,
//       child: SliverRowItemBackground(
//         key: Key(state.key),
//         backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//         child: SizedSliverBox(height: state.height, child: child),
//       ),
//     );
//   }

//   Widget _buildTopBottom({
//     required SliverRowBoxModel<String, Waarde> model,
//     required HypotheekDossier hypotheekDossier,
//     required Hypotheek hypotheek,
//     Animation? animation,
//     required int index,
//     required int length,
//     required SliverBoxItemState<String> state,
//   }) {
//     switch (state.key) {
//       case 'topPadding':
//         {
//           return const SizedBox(
//             height: 16.0,
//           );
//         }
//       case 'woningTitle':
//         {
//           final theme = Theme.of(context);
//           final displaySmall = theme.textTheme.displaySmall;

//           final child = Center(
//               child: Text(
//             'Woning',
//             style: displaySmall,
//             textAlign: TextAlign.center,
//           ));

//           return InsertRemoveVisibleAnimatedSliverRowItem(
//               model: model,
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: SliverRowItemBackground(
//                 radialTop: 32.0,
//                 key: Key(state.key),
//                 backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 16.0),
//                   child: child,
//                 ),
//               ));
//         }
//       case 'woning':
//         {
//           final child = TextFormField(
//             controller: _tecWoningWaarde,
//             focusNode: _fnWoningWaarde,
//             decoration: const InputDecoration(
//                 hintText: 'Bedrag', labelText: 'Woningwaarde'),
//             keyboardType: const TextInputType.numberWithOptions(
//               signed: true,
//               decimal: true,
//             ),
//             inputFormatters: [
//               MyNumberFormat(context).numberInputFormat('#.00')
//             ],
//             validator: (String? value) {
//               if (hypotheekDossier.woningWaardeNormToepassen &&
//                   nf.parsToDouble(value) == 0.0) {
//                 return 'Geen bedrag > 0';
//               }
//               return null;
//             },
//           );

//           return InsertRemoveVisibleAnimatedSliverRowItem(
//               model: model,
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: SliverRowItemBackground(
//                 key: Key(state.key),
//                 backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       left: 16.0, top: 4.0, right: 16.0, bottom: 2.0),
//                   child: child,
//                 ),
//               ));
//         }
//       case 'kostenTitle':
//         {
//           {
//             final theme = Theme.of(context);
//             final displaySmall = theme.textTheme.displaySmall;

//             final child = Center(
//                 child: Text(
//               'Kosten',
//               style: displaySmall,
//               textAlign: TextAlign.center,
//             ));

//             return InsertRemoveVisibleAnimatedSliverRowItem(
//                 model: model,
//                 animation: animation,
//                 key: Key('item_${state.key}'),
//                 state: state,
//                 child: SliverRowItemBackground(
//                   key: Key(state.key),
//                   backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
//                     child: child,
//                   ),
//                 ));
//           }
//         }

//       case 'bottom':
//         {
//           return InsertRemoveVisibleAnimatedSliverRowItem(
//               model: model,
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: SliverRowItemBackground(
//                 radialbottom: 32.0,
//                 key: Key(state.key),
//                 backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
//                   child: Center(
//                       child: ToevoegenKostenButton(
//                           pressed: () => toevoegKostenItem(hypotheek))),
//                 ),
//               ));
//         }
//       case 'totaleKosten':
//         {
//           final child = TotaleKostenRowItem(
//             backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//             totaleKosten: hypotheek.woningLeningKosten.totaleKosten,
//           );

//           return InsertRemoveVisibleAnimatedSliverRowItem(
//               model: model,
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: SliverRowItemBackground(
//                 key: Key(state.key),
//                 backgroundColor: const Color.fromARGB(255, 239, 249, 253),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: child,
//                 ),
//               ));
//         }
//       default:
//         {
//           return const Text(':(');
//         }
//     }
//   }

//   void toevoegKostenItem(Hypotheek hypotheek) {
//     final resterend = HypotheekVerwerken.suggestieKosten(hypotheek);

//     if (resterend.length == 1) {
//       notifier.veranderingKostenToevoegen(resterend);
//     } else {
//       showKosten(
//               context: context,
//               lijst: resterend,
//               image: Image.asset('graphics/kapot_varken.png'),
//               title: 'Kosten')
//           .then((List<Waarde>? value) {
//         if (value != null && value.isNotEmpty) {
//           notifier.veranderingKostenToevoegen(value);
//         }
//       });
//     }
//   }

//   _veranderingWoningwaardeWoning(String? value) {
//     notifier.veranderingWoningLening(woningWaarde: nf.parsToDouble(value));
//   }

//   _veranderingOmschrijving(
//       {required SliverBoxItemState<Waarde> state, required String text}) {
//     state.value = notifier.veranderingKostenWaarde(
//         waarde: state.value, omschrijving: text);
//   }

//   _veranderingWaarde(
//       {required SliverBoxItemState<Waarde> state, required double value}) {
//     state.value =
//         notifier.veranderingKostenWaarde(waarde: state.value, getal: value);
//   }

//   _veranderingWaardeOpties(
//       {required SliverBoxItemState<Waarde> state,
//       required SelectedMenuPopupIdentifierValue<String, dynamic> iv}) {
//     switch (iv.identifier) {
//       case 'eenheid':
//         {
//           state.value = notifier.veranderingKostenWaarde(
//               waarde: state.value, eenheid: iv.value);
//           break;
//         }
//       case 'aftrekken':
//         {
//           state.value = notifier.veranderingKostenWaarde(
//               waarde: state.value, aftrekbaar: iv.value);
//           break;
//         }
//       case 'verwijderen':
//         {
//           notifier.veranderingKostenVerwijderen(state.value);
//           break;
//         }
//     }
//   }
// }

// /// Verduurzamen
// ///
// ///
// ///
// ///
// ///
// ///

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
//   late List<SliverBoxItemState<String>> topList;
//   late List<SliverBoxItemState<Waarde>> bodyList;
//   late List<SliverBoxItemState<String>> bottomList;
//   static const backgroundBox = Color.fromARGB(255, 244, 254, 251);

//   TextEditingController? _tecTaxatie;

//   TextEditingController get tecTaxatie {
//     _tecTaxatie ??= TextEditingController(
//         text: doubleToText(
//             (hypotheek) => hypotheek.verbouwVerduurzaamKosten.taxatie));
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
//     topList = HypotheekVerwerken.createTopVerbouwVerduurzamen(hypotheek, true);
//     bodyList =
//         HypotheekVerwerken.createBodyVerbouwVerduurzamen(hypotheek, true);
//     bottomList =
//         HypotheekVerwerken.createBottomVerbouwVerduurzamen(hypotheek, true);

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
//   Widget build(BuildContext context) {
//     final bewerken = ref.watch(hypotheekBewerkenProvider);
//     final hp = bewerken.hypotheekDossier;
//     final hypotheek = bewerken.hypotheek;

//     return (hp != null && hypotheek != null)
//         ? buildHypotheek(
//             context, bewerken.controllerVerbouwVerduurzamen, hp, hypotheek)
//         : ohno();
//   }

//   Widget buildHypotheek(
//       BuildContext context,
//       ControllerSliverRowBox<String, Waarde> controllerVerbouwVerduurzamen,
//       HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
//     return SliverRowBox<String, Waarde>(
//         controller: controllerVerbouwVerduurzamen,
//         topList: topList,
//         bodyList: bodyList,
//         bottomList: bottomList,
//         buildSliverBoxItem: (
//                 {Animation? animation,
//                 required int index,
//                 required int length,
//                 required SliverBoxItemState<Waarde> state,
//                 required SliverRowBoxModel<String, Waarde> model}) =>
//             _buildItem(
//                 animation: animation,
//                 index: index,
//                 length: length,
//                 state: state,
//                 model: model,
//                 hypotheek: hypotheek),
//         buildSliverBoxTopBottom: (
//                 {Animation? animation,
//                 required int index,
//                 required int length,
//                 required SliverBoxItemState<String> state,
//                 required SliverRowBoxModel<String, Waarde> model}) =>
//             _buildTopBottom(
//                 animation: animation,
//                 index: index,
//                 length: length,
//                 state: state,
//                 model: model,
//                 hypotheek: hypotheek));
//   }

//   Widget _buildItem(
//       {Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<Waarde> state,
//       required SliverRowBoxModel<String, Waarde> model,
//       required Hypotheek hypotheek}) {
//     final child = DefaultKostenRowItem(
//         key: Key(state.key),
//         properties: state,
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
//             model: model,
//             child: SizedSliverBox(height: state.height, child: child)));
//   }

//   Widget _buildTopBottom(
//       {Animation? animation,
//       required int index,
//       required int length,
//       required SliverBoxItemState<String> state,
//       required SliverRowBoxModel<String, Waarde> model,
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
//                       value: hypotheek.verbouwVerduurzaamKosten.toepassen,
//                       onChanged: _veranderingVerduurzamenToepassen,
//                     )),
//               ]));

//           return InsertRemoveVisibleAnimatedSliverRowItem(
//             model: model,
//             animation: animation,
//             key: Key('item_${state.key}'),
//             state: state,
//             child: SliverRowItemBackground(
//               radialTop: 32.0,
//               backgroundColor: backgroundBox,
//               child: SizedSliverBox(height: state.height, child: child),
//             ),
//           );
//         }
//       case 'totaleKosten':
//         {
//           final child = TotaleKostenRowItem(
//             backgroundColor: backgroundBox,
//             totaleKosten: hypotheek.verbouwVerduurzaamKosten.totaleKosten,
//           );

//           return SliverRowItemBackground(
//             key: Key(state.key),
//             backgroundColor: backgroundBox,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: child,
//             ),
//           );
//         }
//       case 'toevoegenTaxatie':
//         {
//           final child = Column(
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 ToevoegenKostenButton(
//                     icon: Icons.list,
//                     color: backgroundBox,
//                     roundedRight: 0.0,
//                     pressed: toevoegenVerduurzaamKosten),
//                 const SizedBox(
//                   width: 1.0,
//                 ),
//                 ToevoegenKostenButton(
//                     roundedLeft: 0.0, pressed: toevoegenVerduurzaamKosten)
//               ]),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 16.0, right: 16.0, bottom: 16.0),
//                 child: TextFormField(
//                     controller: _tecTaxatie,
//                     focusNode: _fnTaxatie,
//                     decoration: const InputDecoration(
//                         hintText: 'Wonigwaarde na verb./verd.',
//                         labelText: 'Taxatie'),
//                     keyboardType: const TextInputType.numberWithOptions(
//                       signed: true,
//                       decimal: true,
//                     ),
//                     inputFormatters: [
//                       MyNumberFormat(context).numberInputFormat('#')
//                     ],
//                     textInputAction: TextInputAction.done),
//               ),
//             ],
//           );

//           return InsertRemoveVisibleAnimatedSliverRowItem(
//               model: model,
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: SliverRowItemBackground(
//                 backgroundColor: backgroundBox,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
//                   child: child,
//                 ),
//               ));
//         }

//       case 'bottom':
//         {
//           return InsertRemoveVisibleAnimatedSliverRowItem(
//               model: model,
//               animation: animation,
//               key: Key('item_${state.key}'),
//               state: state,
//               child: const SliverRowItemBackground(
//                 radialbottom: 32.0,
//                 backgroundColor: backgroundBox,
//                 child: SizedBox(
//                   height: 32.0,
//                 ),
//               ));
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

//   _toevoegenWaardes(List<Waarde> lijst) {
//     // hvm.veranderingVerduurzamenToevoegen(lijst);
//   }

//   _veranderingVerduurzamenToepassen(bool? value) {
//     notifier.verandering(verbouwenVerduurzamenToepassen: value);
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

// class LeningInfo extends StatelessWidget {
//   final HypotheekDossier hypotheekDossier;
//   final Hypotheek hypotheek;

//   const LeningInfo(
//       {super.key, required this.hypotheekDossier, required this.hypotheek});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final nf = MyNumberFormat(context);

//     final berichten = <String>[
//       ...hypotheek.normInkomen.berichten,
//       ...hypotheek.normWoningwaarde.berichten
//     ];
//     final maxLening = HypotheekVerwerken.limiterendeNorm(hypotheek);

//     Widget child;

//     if (maxLening.toepassen && !maxLening.fout) {
//       final m = DefaultTextStyle(
//           style: theme.textTheme.bodyMedium!
//               .copyWith(color: Colors.brown[900], fontSize: 18.0),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             const Text('Maximale Lening:'),
//             Text(
//               nf.parseDoubleToText(maxLening.resterend, '#0'),
//               textScaleFactor: 2.0,
//             )
//           ]));

//       child = Stack(children: [
//         Positioned(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: m),
//         if (berichten.isNotEmpty)
//           Positioned(
//               left: 16.0,
//               right: 16.0,
//               bottom: 0.0,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.warning,
//                       color: Color.fromARGB(255, 159, 24, 14)),
//                   const SizedBox(
//                     width: 8.0,
//                   ),
//                   Column(mainAxisSize: MainAxisSize.min, children: [
//                     for (String bericht in berichten)
//                       Text(bericht,
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                               color: const Color.fromARGB(255, 159, 24, 14)))
//                   ]),
//                 ],
//               ))
//       ]);
//     } else {
//       child = Center(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.warning,
//                 color: Color.fromARGB(255, 159, 24, 14),
//                 size: 128.0,
//               ),
//               for (String bericht in berichten)
//                 Text(bericht,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                         color: const Color.fromARGB(255, 159, 24, 14)))
//             ]),
//       );
//     }

//     return AnimatedSwitcher(
//         duration: const Duration(milliseconds: 200),
//         child: (hypotheek.rente == 0.0)
//             ? const SizedBox.shrink()
//             : Material(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(32.0)),
//                 color: const Color.fromARGB(
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
