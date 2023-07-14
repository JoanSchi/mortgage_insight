// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/animated_sliver_box_goodies/sliver_box_resize_switcher.dart';
import 'package:animated_sliver_box/animated_sliver_box_goodies/sliver_box_transfer_widget.dart';
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:beamer/beamer.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_box.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_clip.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_outside.dart';
import 'package:custom_sliver/sliver_layer/sliver_layer_padding.dart';
import 'package:custom_sliver/sliver_padding_constrain_align.dart';
import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/gereedschap/kalender.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/norm/normen_toepassen.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/vervolg_lening/vervolg_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_bewerken.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheek_verwerken.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/my_widgets/animated_scale_resize_switcher.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/box_properties_constants.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/lening_kosten_sliver_box_model.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/vervolg_hypotheek_sliver_box_model.dart';
import 'package:mortgage_insight/pages/route_fout/route_fout.dart';
import 'package:mortgage_insight/platform_page_format/default_match_page_properties.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import '../../../my_widgets/animated_sliver_widgets/kosten_dialog.dart';
import '../../../my_widgets/animated_sliver_widgets/standard_kosten_item.dart';
import '../../../my_widgets/end_focus.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../my_widgets/selectable_widgets/single_checkbox.dart';
import '../../../platform_page_format/default_page.dart';
import '../../../platform_page_format/page_actions.dart';
import '../../../utilities/device_info.dart';
import '../../../utilities/my_number_format.dart';
import 'abstract_hypotheek_consumer.dart';
import 'hypotheek_kosten_item_bewerken.dart';
import 'hypotheek_verleng_card.dart';
import 'model/hypotheek_view_model.dart';
import 'model/hypotheek_view_state.dart';
import 'overzicht_hypotheek.dart';
import 'overzicht_hypotheek_tabel.dart';

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
    bool geenHypotheek = ref.watch(
        hypotheekBewerkenProvider.select((value) => value.hypotheek == null));

    if (geenHypotheek) {
      return const RouteFout(
        routeFoutOpties: RouteFoutOpties.afsnijden,
      );
    }

    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;

    final save =
        PageActionItem(text: 'Opslaan', icon: Icons.done, voidCallback: _save);

    final cancel = PageActionItem(
        text: 'Annuleren', icon: Icons.arrow_back, voidCallback: _pop);

    return DefaultPage(
        title: 'Lening',
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
        SliverPadding(
            padding: padding.copyWith(
              top: 0.0,
              bottom: 0.0,
            ),
            sliver: const HypotheekDatumEnVervolg()),
        SliverPadding(
            padding: padding.copyWith(
              top: 0.0,
              bottom: 0.0,
            ),
            sliver: const VormRentePeriodePanel()),
        SliverPadding(
          padding: padding.copyWith(
            top: 0.0,
            bottom: 0.0,
          ),
          sliver: const FinancieringsNormPanel(),
        ),

        SliverPaddingConstrainAlign(
          padding: padding.copyWith(top: 0.0, bottom: 8.0),
          maxCrossSize: 900.0,
          sliver: const HypotheekKostenPanel(),
        ),

        // const VerduurzamenPanel(),
        SliverPadding(
          padding: padding.copyWith(
            top: 8.0,
            bottom: 0.0,
          ),
          sliver: const TeLenenPanel(),
        ),
        // SpacerFinancieringsTabel(),
        // FinancieringsNormTable(),
        // VerdelingLeningen(),
        const OverzichtHypotheek(),
        const OverzichtHypotheekTabel()
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
      Center(
        child: Text(
          'Hypotheek',
          style: headlineMedium,
        ),
      ),
    ];

    final firstDate =
        HypotheekVerwerken.eersteKalenderDatum(hypotheekDossier, hypotheek);
    final lastDate =
        HypotheekVerwerken.laatsteKalenderDatum(hypotheekDossier, hypotheek);

    if (hypotheekViewState.teVerlengen.isNotEmpty) {
      children.addAll([
        const SizedBox(
          height: 12.0,
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
            getGroupLayoutProperties: (targetPlatform, formFactorType) =>
                GroupLayoutProperties.horizontal(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    options: const SelectableGroupOptions(
                        selectedGroupTheme: SelectedGroupTheme.button,
                        space: 6.0))),
        if (hypotheekViewState.teHerFinancieren.isNotEmpty)
          AnimatedScaleResizeSwitcher(
              child: hypotheek.optiesHypotheekToevoegen ==
                      OptiesHypotheekToevoegen.nieuw
                  ? DateInputPicker(
                      date: hypotheek.startDatum,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      changeDate: _veranderingStartDatum,
                      saveDate: _veranderingStartDatum,
                    )
                  : const SizedBox.shrink()),
        const SizedBox(
          height: 8.0,
        )
      ]);
    } else {
      children.addAll([
        const SizedBox(
          height: 12.0,
        ),
        DateInputPicker(
          date: hypotheek.startDatum,
          firstDate: firstDate,
          lastDate: lastDate,
          changeDate: _veranderingStartDatum,
          saveDate: _veranderingStartDatum,
        ),
        const SizedBox(
          height: 12.0,
        ),
      ]);
    }

    return SliverList(
      delegate: SliverChildListDelegate.fixed(children),
    );
  }

  _veranderingOmschrijving(String value) {
    notifier.verandering(omschrijving: value);
  }

  _veranderingHypotheekToevoegen(OptiesHypotheekToevoegen? value) {
    notifier.verandering(optiesHypotheekToevoegen: value);
  }

  _veranderingStartDatum(DateTime? value) {
    notifier.verandering(startDatum: value);
  }
}

/// Vervolg hypotheek
///
///
///
///
///
///

class HypotheekDatumEnVervolg extends ConsumerStatefulWidget {
  const HypotheekDatumEnVervolg({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      HypotheekBewerkDatumVerlengenState();
}

class HypotheekBewerkDatumVerlengenState
    extends AbstractHypotheekConsumerState<HypotheekDatumEnVervolg>
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
  void didUpdateWidget(covariant HypotheekDatumEnVervolg oldWidget) {
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

    List<Widget> slivers = [
      // if (hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw)

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
              changed: (DateTime? value) {
                notifier.verandering(startDatum: value);
              },
              hypotheekDossier: hypotheekViewState.hypotheekDossier,
              herfinancieren: herFinancieren,
              selected: hypotheekViewState.hypotheek?.startDatum,
            ),
            'hf_${herFinancieren.id}'
          ),
        (LeningVerlengen leningVerlengen) => (
            VerlengCard(
                changed: (String? v) {
                  notifier.verandering(vorige: v);
                },
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
}

/// Termijn, Periode, NHG en Verduurzamen
///
///
///
///
///
///

class VormRentePeriodePanel extends ConsumerStatefulWidget {
  const VormRentePeriodePanel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      VormRentePeriodeState();
}

class VormRentePeriodeState
    extends AbstractHypotheekConsumerState<VormRentePeriodePanel> {
  late final TextEditingController _tecAflosTermijnInJaren;
  late final FocusNode _fnAflosTermijnInJaren;
  late final TextEditingController _tecPeriodeInJaren;
  late final FocusNode _fnPeriodeInJaren;
  late final TextEditingController _tecRente;
  late final FocusNode _fnRente;
  late final TextEditingController _tecLening;
  late final FocusNode _fnLening;

  @override
  void initState() {
    _tecAflosTermijnInJaren = TextEditingController(
        text: intToText((hypotheek) => hypotheek.aflosTermijnInJaren));

    _fnAflosTermijnInJaren = FocusNode()
      ..addListener(() {
        if (!_fnAflosTermijnInJaren.hasFocus) {
          _veranderenAflosTermijnInJaren(
            value: int.tryParse(_tecAflosTermijnInJaren.text),
          );
        }
      });

    _tecLening = TextEditingController(
        text: doubleToText((hypotheek) => hypotheek.gewensteLening));

    _fnLening = FocusNode()
      ..addListener(() {
        if (!_fnLening.hasFocus) {
          _veranderingLening(
            _tecLening.text,
          );
        }
      });

    _tecPeriodeInJaren = TextEditingController(
        text: intToText((hypotheek) => hypotheek.periodeInJaren));

    _fnPeriodeInJaren = FocusNode()
      ..addListener(() {
        if (!_fnPeriodeInJaren.hasFocus) {
          _veranderenPeriodeInJaren(
            value: int.tryParse(_tecPeriodeInJaren.text),
          );
        }
      });

    _tecRente = TextEditingController(
        text: doubleToText((Hypotheek hypotheek) => hypotheek.rente));

    _fnRente = FocusNode()
      ..addListener(() {
        if (!_fnRente.hasFocus) {
          _veranderingRente(_tecRente.text);
        }
      });

    super.initState();
  }

  // int? get maxTermijnenInJaren {
  //   final hypotheekBewerken = ref.read(hypotheekBewerkenProvider);
  //   final hp = hypotheekBewerken.hypotheekDossier;
  //   final hypotheek = hypotheekBewerken.hypotheek;

  //   return hp != null && hypotheek != null
  //       ? HypotheekVerwerken.maxTermijnenInJaren(hp, hypotheek)
  //       : null;
  // }

  @override
  void dispose() {
    _tecAflosTermijnInJaren.dispose();
    _fnAflosTermijnInJaren.dispose();

    _tecPeriodeInJaren.dispose();
    _fnPeriodeInJaren.dispose();
    _tecLening.dispose();
    _fnLening.dispose();
    _tecRente.dispose();
    _fnRente.dispose();
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

    double? nextLening = HypotheekBewerken.leningGewenstOfVast(hypotheek);

    if (nextLening != null && nextLening != nf.parsToDouble(_tecLening.text)) {
      _tecLening.text = nf.parseDblToText(nextLening);
    }
  }

  @override
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
    ref.listen<Hypotheek?>(
        hypotheekBewerkenProvider
            .select((HypotheekViewState value) => value.hypotheek),
        listen);

    final theme = Theme.of(context);
    final headlineMedium = theme.textTheme.headlineMedium;
    final maxTermijnenInJaren =
        HypotheekVerwerken.maxTermijnenInMaanden(hypotheekDossier, hypotheek) ~/
            12;

    List<Widget> children = [
      const SizedBox(
        height: 8.0,
      ),
      // const SizedBox(
      //   height: 16.0,
      // ),
      Text(
        'Vorm',
        style: headlineMedium,
      ),
      // const SizedBox(
      //   height: 6.0,
      // ),
      UndefinedSelectableGroup(
        groups: [
          MyRadioGroup<HypotheekVorm>(
              groupValue: hypotheek.hypotheekvorm,
              list: [
                RadioSelectable(
                    text: 'Annuïteit', value: HypotheekVorm.annuiteit),
                RadioSelectable(text: 'Lineair', value: HypotheekVorm.lineair),
                RadioSelectable(
                  text: 'Aflosvrij',
                  value: HypotheekVorm.aflosvrij,
                )
              ],
              onChange: _veranderingHypotheekvorm)
        ],
      ),
      Row(
        children: [
          Expanded(
            child: TextFormField(
                textAlign: TextAlign.end,
                controller: _tecLening,
                focusNode: _fnLening,
                onSaved: _veranderingLening,
                validator: (String? value) {
                  double lening = value == null ? 0.0 : nf.parsToDouble(value);
                  return (lening <= 0.0) ? 'Lening?' : null;
                },
                decoration: InputDecoration(
                    hintText: 'Bedrag',
                    labelText:
                        hypotheek.afgesloten ? 'Lening' : 'Gewenste lening'),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  MyNumberFormat(context).numberInputFormat('#.00')
                ],
                textInputAction: TextInputAction.next),
          ),
          const SizedBox(
            width: 16.0,
          ),
          SizedBox(
            width: 80.0,
            child: TextFormField(
                textAlign: TextAlign.end,
                controller: _tecRente,
                focusNode: _fnRente,
                onSaved: _veranderingRente,
                validator: (String? value) {
                  double rente = value == null ? 0.0 : nf.parsToDouble(value);
                  return (rente < 0.0 || rente > 10) ? '0-10%' : null;
                },
                decoration: const InputDecoration(
                    hintText: '%', labelText: 'Rente (%)'),
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  MyNumberFormat(context).numberInputFormat('#.00')
                ],
                textInputAction: TextInputAction.done),
          ),
        ],
      ),
      const SizedBox(
        height: 12.0,
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
                            divisions: maxTermijnenInJaren - 1 < 1
                                ? 1
                                : maxTermijnenInJaren - 1,
                            onChanged: (double value) =>
                                _veranderenAflosTermijnInJaren(
                                  value: value.toInt(),
                                ))),
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
                    // const SizedBox(
                    //   width: 16.0,
                    // )
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
              onChanged: (double value) =>
                  _veranderenPeriodeInJaren(value: value.toInt())),
        ),
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
      ]),
    ];

    return SliverList(
      delegate: SliverChildListDelegate.fixed(children),
    );
  }

  _veranderingHypotheekvorm(HypotheekVorm? value) {
    notifier.verandering(hypotheekvorm: value);
  }

  _veranderingLening(String? value) {
    notifier.verandering(gewensteLening: nf.parsToDouble(value));
  }

  _veranderingRente(String? value) {
    notifier.verandering(rente: nf.parsToDouble(value));
  }

  _veranderenAflosTermijnInJaren({required int? value}) {
    if (value == null) return;
    notifier.verandering(aflosTermijnInMaanden: value * 12);
  }

  _veranderenPeriodeInJaren({required int? value}) {
    if (value == null) return;
    notifier.verandering(periodeInMaanden: value * 12);
  }
}
/* FinancieringsNorm
 *
 *
 *
 *
 *
 *
 */

class FinancieringsNormPanel extends ConsumerStatefulWidget {
  const FinancieringsNormPanel({
    super.key,
  });

  @override
  ConsumerState<FinancieringsNormPanel> createState() =>
      FinancieringsNormPanelState();
}

class FinancieringsNormPanelState
    extends AbstractHypotheekConsumerState<FinancieringsNormPanel> {
  @override
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
    final theme = Theme.of(context);
    final headlineMedium = theme.textTheme.headlineMedium;

    NormenToepassen? toepassen =
        HypotheekBewerken.opDatumOphalen<NormenToepassen>(
            hypotheekDossier.dNormenToepassen,
            hypotheek: hypotheek);

    Widget child = hypotheek.afgesloten || toepassen == null
        ? const SizedBox.shrink()
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Financieringsnorm',
              style: headlineMedium,
            ),
            const SizedBox(
              height: 4.0,
            ),
            UndefinedSelectableGroup(
              groups: [
                MyCheckGroup<String>(
                    list: [
                      CheckSelectable<String>(
                          identifier: 'inkomen',
                          text: 'Inkomen',
                          value: toepassen.inkomen),
                      CheckSelectable<String>(
                          identifier: 'woningwaarde',
                          text: 'Woningwaarde',
                          value: toepassen.woningWaarde)
                    ],
                    onChange: (String identifier, bool value) {
                      switch (identifier) {
                        case 'inkomen':
                          {
                            notifier.verandering(normInkomenToepassen: !value);
                            break;
                          }
                        case 'woningwaarde':
                          {
                            notifier.verandering(
                                normWoningWaardeToepassen: !value);
                            break;
                          }
                      }
                    })
              ],
            ),
          ]);

    return SliverToBoxAdapter(child: AnimatedScaleResizeSwitcher(child: child));
  }
}

/* Kosten
 *
 *
 *
 *
 *
 *
 */

class HypotheekKostenPanel extends ConsumerStatefulWidget {
  const HypotheekKostenPanel({
    super.key,
  });

  @override
  ConsumerState<HypotheekKostenPanel> createState() =>
      HypotheekKostenPanelState();
}

class HypotheekKostenPanelState
    extends AbstractHypotheekConsumerState<HypotheekKostenPanel> {
  late final TextEditingController _tecWoningWaarde;

  late final FocusNode _fnWoningWaarde;

  @override
  void initState() {
    final hypotheekViewState = ref.read(hypotheekBewerkenProvider);

    _tecWoningWaarde = TextEditingController(
        text: doubleToText((Hypotheek hypotheek) =>
            HypotheekBewerken.woningWaardeOpDatum(
                hypotheekDossier: hypotheekViewState.hypotheekDossier,
                hypotheek: hypotheekViewState.hypotheek)));

    _fnWoningWaarde = FocusNode()
      ..addListener(() {
        if (!_fnWoningWaarde.hasFocus) {
          _veranderingWoningwaardeWoning(_tecWoningWaarde.text);
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _tecWoningWaarde.dispose();
    _fnWoningWaarde.dispose();
    super.dispose();
  }

  @override
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
    final sliver = AnimatedSliverBox<HypotheekKostenSliverBoxModel>(
        controllerSliverRowBox: hypotheekViewState.kostenSliverBoxController,
        createSliverRowBoxModel: (sliverBoxContext, axis) {
          final visible = !(hypotheekViewState.hypotheek?.afgesloten ?? false);

          return HypotheekKostenSliverBoxModel(
              sliverBoxContext: sliverBoxContext,
              topBox: SingleBoxModel<String, DefaultBoxItemProperties>(
                  items: createTop(hypotheekViewState, visible),
                  tag: 'top',
                  buildStateItem: _buildTopBottom(hypotheekViewState)),
              gedeeldeKosten: [
                SingleBoxModel<String, KostenItemBoxProperties>(
                    items: [
                      for (var k in (hypotheekDossier
                              .dKosten[hypotheek.startDatum]?.kosten ??
                          <Waarde>[]))
                        KostenItemBoxProperties(
                            id: k.id,
                            panel: BoxPropertiesPanels.standard,
                            value: k)
                    ],
                    tag: Kalender.datumNaTekst(hypotheek.startDatum),
                    buildStateItem: _buildItem(hypotheekViewState))
              ],
              bottomBox: SingleBoxModel<String, DefaultBoxItemProperties>(
                  items: createBottom(hypotheekViewState, visible),
                  tag: 'bottom',
                  buildStateItem: _buildTopBottom(hypotheekViewState)),
              axis: axis,
              duration: const Duration(milliseconds: 300));
        },
        updateSliverRowBoxModel: (model, axis) {
          for (var single in model.gedeeldeKosten) {
            single.buildStateItem = _buildItem(hypotheekViewState);
          }
          final buildTopBottom = _buildTopBottom(hypotheekViewState);
          model
            ..topBox.buildStateItem = buildTopBottom
            ..bottomBox.buildStateItem = buildTopBottom;
        });

    return SliverLayerBox(
      children: [
        SliverLayerOutside(
            beginOutside: 10.0,
            endOutside: 10.0,
            child: Container(
                decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
              color: Color.fromARGB(255, 241, 250, 250),
            ))),
        SliverLayerPadding(
            padding: const EdgeInsets.all(6.0),
            sliver: SliverLayerClipRRect(
                borderRadius: BorderRadius.circular(32.0), sliver: sliver))
      ],
    );
  }

  List<DefaultBoxItemProperties> createTop(
      HypotheekViewState hypotheekViewState, bool visible) {
    final status = visible
        ? BoxItemTransitionState.visible
        : BoxItemTransitionState.invisible;
    return [
      DefaultBoxItemProperties(
          id: 'titleWoning', size: 56.0, transitionStatus: status),
      DefaultBoxItemProperties(
          id: 'woning', size: 56.0, transitionStatus: status),
      DefaultBoxItemProperties(
          id: 'nhg', size: 1.0, transitionStatus: status, useSizeOfChild: true),
      DefaultBoxItemProperties(
          id: 'kostenTitle', size: 42.0, transitionStatus: status),
    ];
  }

  List<DefaultBoxItemProperties> createBottom(
      HypotheekViewState hypotheekViewState, bool visible) {
    return [
      DefaultBoxItemProperties(
          id: 'unfocus',
          size: 0.0,
          transitionStatus: visible
              ? BoxItemTransitionState.visible
              : BoxItemTransitionState.invisible),
      DefaultBoxItemProperties(
          id: 'bottom',
          size: 56.0,
          transitionStatus: visible
              ? BoxItemTransitionState.visible
              : BoxItemTransitionState.invisible)
    ];
  }

  BuildStateItem<String, KostenItemBoxProperties> _buildItem(
      HypotheekViewState hypotheekViewState) {
    return (
        {required BuildContext buildContext,
        Animation<double>? animation,
        required AnimatedSliverBoxModel<String> model,
        required KostenItemBoxProperties properties,
        required SingleBoxModel<String, KostenItemBoxProperties> singleBoxModel,
        required int index}) {
      Widget child;
      //
      //
      //
      //

      var (String omschrijving, String bedrag, String sup) =
          switch (properties.value) {
        (Waarde w) when w.eenheid == Eenheid.percentageWoningWaarde => (
            w.omschrijving,
            nf.parseDblToText(HypotheekBewerken.woningWaardeOpDatum(
                    hypotheekDossier: hypotheekViewState.hypotheekDossier,
                    hypotheek: hypotheekViewState.hypotheek) /
                100.0 *
                w.getal),
            '${nf.parseDblToText(w.getal)}%'
          ),
        (Waarde w) when w.eenheid == Eenheid.percentageLening => (
            w.omschrijving,
            nf.parseDblToText((hypotheekViewState.hypotheek?.lening ?? 0.0) /
                100.0 *
                w.getal),
            '${nf.parseDblToText(w.getal)}%'
          ),
        (Waarde w) => (w.omschrijving, nf.parseDblToText(w.getal), '')
      };

      Widget standard(bool complete) => StandardKostenItem(
            height: properties.suggestedSize(model.axis),
            omschrijving: omschrijving,
            bedrag: bedrag,
            sup: sup,
            changePanel: () {
              setState(() {
                properties.setToPanel(BoxPropertiesPanels.edit);
              });
            },
          );

      Widget edit(bool complete) => HypotheekKostenItemBewerken(
            properties: properties,
            changePanel: () => setState(() {
              properties.setToPanel(BoxPropertiesPanels.standard);
            }),
          );

      if (properties.transfer) {
        child = SliverBoxResizeAbSwitcher(
          animateOnInitiation: properties.animateOnInitiation,
          first: standard,
          second: edit,
          crossFadeState: properties.panel == BoxPropertiesPanels.standard
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          stateChange: () {
            properties.fixPanel();
          },
        );
      } else if (properties.panel == BoxPropertiesPanels.standard) {
        child = standard(false);
      } else {
        child = edit(false);
      }

      return SliverBoxTransferWidget(
        key: Key('item_${properties.id}'),
        model: model,
        boxItemProperties: properties,
        animation: animation,
        singleBoxModel: singleBoxModel,
        child: child,
      );
    };
  }

  BuildStateItem<String, DefaultBoxItemProperties> _buildTopBottom(
      HypotheekViewState hypotheekViewState) {
    return (
        {required BuildContext buildContext,
        Animation<double>? animation,
        required AnimatedSliverBoxModel<String> model,
        required DefaultBoxItemProperties properties,
        required SingleBoxModel<String, DefaultBoxItemProperties>
            singleBoxModel,
        required int index}) {
      switch (properties.id) {
        // case 'topPadding':
        //   {
        //     return const SizedBox(
        //       height: 16.0,
        //     );
        //   }
        case 'titleWoning':
          {
            final theme = Theme.of(context);
            final displaySmall = theme.textTheme.displaySmall;

            final child = SizedBox(
              height: properties.size(model.axis),
              child: Center(
                  child: Text(
                'Woning',
                style: displaySmall,
                textAlign: TextAlign.center,
              )),
            );

            return SliverBoxTransferWidget(
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: child,
            );
          }
        case 'woning':
          {
            final child = KeepAlive(
                keepAlive: true,
                child: SizedBox(
                  height: properties.size(model.axis),
                  child: TextFormField(
                    textAlign: TextAlign.right,
                    controller: _tecWoningWaarde,
                    focusNode: _fnWoningWaarde,
                    decoration: const InputDecoration(
                        hintText: 'Bedrag', labelText: 'Woningwaarde'),
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: [
                      MyNumberFormat(context).numberInputFormat('#.00')
                    ],
                    validator: (String? value) {
                      NormenToepassen? toepassen =
                          HypotheekBewerken.opDatumOphalen<NormenToepassen>(
                              hypotheekViewState
                                  .hypotheekDossier.dNormenToepassen,
                              hypotheek: hypotheek);
                      if ((toepassen?.woningWaarde ?? false) &&
                          nf.parsToDouble(value) == 0.0) {
                        return 'Geen bedrag > 0';
                      }
                      return null;
                    },
                  ),
                ));

            return SliverBoxTransferWidget(
                model: model,
                animation: animation,
                key: Key(properties.id),
                boxItemProperties: properties,
                singleBoxModel: singleBoxModel,
                child: child);
          }

        case 'nhg':
          {
            var (bool toepasbaar, double? nghBedrag) =
                HypotheekBewerken.nhgToepasbaarAankoopBedrag(
                    hypotheekDossier: hypotheekViewState.hypotheekDossier,
                    hypotheek: hypotheekViewState.hypotheek);

            final child = toepasbaar
                ? MyCheckbox(
                    text: 'Nationale hypotheek garantie (NHG)',
                    value: false, //hypotheek.normNhg.toepassen,
                    onChanged: _veranderingToepassenNHG)
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Text('NHG aankoopbedrag: €${nghBedrag?.toInt()},-'),
                  );

            return SliverBoxTransferWidget(
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: child,
            );
          }
        case 'kostenTitle':
          {
            {
              final theme = Theme.of(context);
              final displaySmall = theme.textTheme.displaySmall;

              final child = SizedBox(
                height: properties.size(model.axis),
                child: Center(
                  child: Text(
                    'Kosten',
                    style: displaySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              );

              return SliverBoxTransferWidget(
                  model: model,
                  animation: animation,
                  key: Key(properties.id),
                  boxItemProperties: properties,
                  singleBoxModel: singleBoxModel,
                  child: child);
            }
          }
        case 'unfocus':
          {
            return const EndFocus();
          }

        case 'bottom':
          {
            final child = SizedBox(
                height: properties.size(model.axis),
                child: TotaleKostenEnToevoegen(
                    totaleKosten: HypotheekBewerken.totaleKosten(
                        hypotheekDossier: hypotheekViewState.hypotheekDossier,
                        hypotheek: hypotheekViewState.hypotheek),
                    toevoegen: () => toevoegKostenItem(hypotheekViewState)));

            return SliverBoxTransferWidget(
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: child,
            );
          }
        // case 'totaleKosten':
        //   {
        //     final child = TotaleKostenRowItem(
        //       backgroundColor: const Color.fromARGB(255, 239, 249, 253),
        //       totaleKosten: hypotheek.woningLeningKosten.totaleKosten,
        //     );

        //     return InsertRemoveVisibleAnimatedSliverRowItem(
        //         model: model,
        //         animation: animation,
        //         key: Key('item_${state.key}'),
        //         state: state,
        //         child: SliverRowItemBackground(
        //           key: Key(state.key),
        //           backgroundColor: const Color.fromARGB(255, 239, 249, 253),
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //             child: child,
        //           ),
        //         ));
        //   }
        default:
          {
            return const Text(':(');
          }
      }
    };
  }

  void toevoegKostenItem(HypotheekViewState hypotheekViewState) {
    final hypotheek = hypotheekViewState.hypotheek;
    if (hypotheek == null) {
      return;
    }
    final resterend = HypotheekVerwerken.suggestieKosten(
        hypotheekDossier: hypotheekViewState.hypotheekDossier,
        hypotheek: hypotheek);

    if (resterend.length == 1) {
      notifier.verandering(gedeeldeKostenToevoegen: resterend);
    } else {
      showKosten(
              context: context,
              lijst: resterend,
              image: Image.asset('graphics/kapot_varken.png'),
              title: 'Kosten')
          .then((List<Waarde>? value) {
        if (value != null && value.isNotEmpty) {
          notifier.verandering(gedeeldeKostenToevoegen: value);
        }
      });
    }
  }

  _veranderingWoningwaardeWoning(String? value) {
    notifier.verandering(woningWaarde: nf.parsToDouble(value));
  }

  _veranderingToepassenNHG(bool? value) {
    notifier.verandering(toepassenNhg: value);
  }
}

/* Telenen 
 *
 *
 *
 * 
 *
 *
 */

class TeLenenPanel extends ConsumerStatefulWidget {
  const TeLenenPanel({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => TeLenenPanelState();
}

class TeLenenPanelState extends AbstractHypotheekConsumerState<TeLenenPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
    final theme = Theme.of(context);
    final displaySmall = theme.textTheme.displaySmall;

    final child =
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        'Lening',
        style: displaySmall,
      ),
      SizedBox(
          height: 150.0,
          child: CustomMultiChildLayout(
              delegate: _TeLenenLayoutDelegate(logoToLeft: 24.0),
              children: [
                LayoutId(
                    id: 'logo',
                    child: Image(
                        image: const AssetImage(
                          'graphics/fit_geldzak.png',
                        ),
                        color: theme.colorScheme.onSurface)),
                LayoutId(
                    id: 'bedrag',
                    child: Text(
                      nf.parseDblToText(hypotheek.lening, format: '#0'),
                      style: displaySmall,
                    )),
                if (!hypotheek.afgesloten)
                  LayoutId(
                    id: 'max',
                    child: TextButton(
                      onPressed: veranderingMax,
                      child: const Text('Max'),
                    ),
                  ),
              ]))
      // SizedBox(
      //   height: 150.0,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Flexible(
      //           flex: 1,

      //           child: Stack(
      //             children: [
      //               Positioned(

      //                 top: 0.0,
      //                 right: 0.0,
      //                 bottom: 0.0,
      //                 child: Align(
      //                   alignment: Alignment.centerRight,
      // child: Text(
      //   nf.parseDblToText(hypotheek.lening),
      //   style: displaySmall,
      // ),
      //                 ),
      //               ),
      //               Positioned(
      //                 bottom: 8.0,
      //                 right: 8.0,
      //                 child: TextButton(
      //                     child: const Text('Max'), onPressed: veranderingMax),
      //               )
      //             ],
      //           )),
      //       Flexible(
      //           flex: 1,
      //           child: Align(
      //             alignment: Alignment.centerLeft,
      //             child: Image(
      //                 image: const AssetImage(
      //                   'graphics/fit_geldzak.png',
      //                 ),
      //                 color: theme.colorScheme.onSurface),
      //           ))
      //     ],
      //   ),
      // )
    ]);

    return SliverToBoxAdapter(
      child: child,
    );
  }

  veranderingMax() {
    notifier.verandering(zetMaximaleLening: true);
  }
}

class _TeLenenLayoutDelegate extends MultiChildLayoutDelegate {
  final double logoToLeft;
  _TeLenenLayoutDelegate({required this.logoToLeft});

  @override
  void performLayout(Size size) {
    layoutChild(
      'logo',
      BoxConstraints(maxHeight: size.height, maxWidth: size.width),
    );

    positionChild('logo', Offset(size.width / 2.0 - logoToLeft, 0.0));

    final bedragSize = layoutChild(
      'bedrag',
      BoxConstraints(maxHeight: size.height, maxWidth: size.width / 2.0),
    );

    positionChild(
        'bedrag',
        Offset(size.width / 2.0 - bedragSize.width,
            (size.height - bedragSize.height) / 2.0));

    if (hasChild('max')) {
      final maxSize = layoutChild(
        'max',
        BoxConstraints(maxHeight: size.height, maxWidth: size.width / 2.0),
      );

      positionChild(
          'max',
          Offset(size.width / 2.0 - maxSize.width - 4.0,
              (size.height - maxSize.height) - 8.0));
    }
  }

  @override
  bool shouldRelayout(_TeLenenLayoutDelegate oldDelegate) {
    return oldDelegate.logoToLeft != logoToLeft;
  }
}


// class LeningPanel extends ConsumerStatefulWidget {
//   const LeningPanel({super.key});

//   @override
//   ConsumerState<LeningPanel> createState() => LeningPanelState();
// }

// class LeningPanelState extends AbstractHypotheekConsumerState<LeningPanel> {
//   late final TextEditingController _tecLening;
//   late final FocusNode _fnLening;

//   bool focusLening = false;

//   @override
//   void initState() {
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

//     super.dispose();
//   }

//   @override
//   Widget buildHypotheek(
//       BuildContext context,
//       HypotheekViewState hypotheekViewState,
//       HypotheekDossier hypotheekDossier,
//       Hypotheek hypotheek) {
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
//               // child: _renteField(),
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
//         // _renteField(),
//         const SizedBox(
//           height: 8.0,
//         ),
//         LeningInfo(hypotheekDossier: hypotheekDossier, hypotheek: hypotheek),
//       ],
//     );
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
//               nf.parseDoubleToText(maxLening.normLening, '#0'),
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
