// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import 'package:sliver_row_box/sized_sliver_box.dart';
import 'package:sliver_row_box/sliver_item_row_insert_remove.dart';
import 'package:sliver_row_box/sliver_row_box.dart';
import 'package:sliver_row_box/sliver_row_box_controller.dart';
import 'package:sliver_row_box/sliver_row_box_model.dart';
import 'package:sliver_row_box/sliver_row_item_background.dart';
import 'package:mortgage_insight/model/nl/hypotheek/verwerken/profiel_verwerken.dart';
import 'package:mortgage_insight/my_widgets/selectable_widgets/single_checkbox.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/pages/hypotheek/profiel_bewerken/hypotheek_profiel_model.dart';
import 'package:mortgage_insight/pages/hypotheek/profiel_bewerken/kosten_lijst.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/utilities/match_properties.dart';

import '../../../model/nl/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import '../../../model/nl/hypotheek/gegevens/hypotheek_profiel/hypotheek_profiel.dart';
import '../../../my_widgets/animated_scale_resize_switcher.dart';
import '../../../my_widgets/selectable_popupmenu.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../utilities/device_info.dart';
import 'abstract_hypotheek_profiel_consumer.dart';

const _horizontal = 8.0;

class BewerkHypotheekProfiel extends ConsumerStatefulWidget {
  const BewerkHypotheekProfiel({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BewerkHypotheekProfielState();
}

class _BewerkHypotheekProfielState
    extends ConsumerState<BewerkHypotheekProfiel> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  ControllerSliverRowBox<String, Waarde> controllerSliverRowBox =
      ControllerSliverRowBox();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controllerSliverRowBox.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;

    return DefaultPage(
        title: 'Profiel',
        imageBuilder: (_) => Image(
            image: const AssetImage(
              'graphics/profiel.png',
            ),
            color: theme.colorScheme.onSurface),
        bodyBuilder: (
                {required BuildContext context,
                required bool nested,
                required double topPadding,
                required double bottomPadding}) =>
            AcceptCanelPanel(
              accept: () {
                // if (_formKey.currentState?.validate() ?? false) {
                //   final hypotheekContainer =
                //       ref.read(removeHypotheekContainerProvider);

                //   if (nieuwHypotheekProfielViewModel.isNieuw) {
                //     scheduleMicrotask(() {
                //       // TODO: Fix
                //       //   ref.read(routeEditPageProvider.notifier).editState =
                //       //       EditRouteState(
                //       //           route: routeMortgageEdit,
                //       //           object: HypotheekViewModel(
                //       //               inkomenLijst: hypotheekContainer.inkomenLijst(),
                //       //               inkomenLijstPartner: hypotheekContainer
                //       //                   .inkomenLijst(partner: true),
                //       //               profiel: hypotheekContainer
                //       //                   .huidigeHypotheekProfielContainer!.profiel,
                //       //               schuldenLijst:
                //       //                   hypotheekContainer.schuldenContainer.list));
                //     });
                //   } else {
                //     scheduleMicrotask(() {
                //       context.pop();
                //     });
                //   }
                // }
              },
              cancel: () {
                scheduleMicrotask(() {
                  context.pop();
                });
              },
              child: Form(
                key: _formKey,
                child: CustomScrollView(slivers: [
                  if (nested)
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                  HypotheekProfielOptiePanel(
                    controllerSliverRowBox: controllerSliverRowBox,
                  ),
                  HypotheekProfielEigenWoningReservePanel(
                      controllerSliverRowBox: controllerSliverRowBox),
                  HypotheekProfielVorigeWoningPanel(
                    controllerSliverRowBox: controllerSliverRowBox,
                  ),
                ]),
              ),
            ));
  }
}

class HypotheekProfielOptiePanel extends ConsumerStatefulWidget {
  final ControllerSliverRowBox<String, Waarde> controllerSliverRowBox;

  const HypotheekProfielOptiePanel({
    super.key,
    required this.controllerSliverRowBox,
  });

  @override
  ConsumerState<HypotheekProfielOptiePanel> createState() =>
      _HypotheekProfielOptiePanelState();
}

class _HypotheekProfielOptiePanelState
    extends AbstractHypotheekProfielConsumerState<HypotheekProfielOptiePanel> {
  late TextEditingController _tecOmschrijving;
  late FocusNode _fnOmschrijving;

  @override
  void initState() {
    _tecOmschrijving = TextEditingController(
        text: toText(
      (hp) => hp.omschrijving,
    ));

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
  @override
  Widget buildHypotheekProfiel(BuildContext context,
      HypotheekProfielBewerken bewerken, HypotheekProfiel hp) {
    final theme = Theme.of(context);
    final headlineMedium = theme.textTheme.headlineMedium;

    List<Widget> children = [
      const SizedBox(
        height: 12.0,
      ),
      OmschrijvingTextField(
        textEditingController: _tecOmschrijving,
        focusNode: _fnOmschrijving,
      ),
      const SizedBox(
        height: 16.0,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: Text('Doel', style: headlineMedium)),
      const SizedBox(
        height: 4.0,
      ),
      UndefinedSelectableGroup(
        groups: [
          MyRadioGroup<DoelHypotheekOverzicht>(
              list: [
                RadioSelectable(
                    text: 'Woning kopen',
                    value: DoelHypotheekOverzicht.nieuweWoning),
                RadioSelectable(
                    text: 'Overzicht bestaande hypotheek(en)',
                    value: DoelHypotheekOverzicht.huidigeWoning)
              ],
              groupValue: hp.doelHypotheekOverzicht,
              onChange: _veranderingDoelOverzicht)
        ],
      ),
      const SizedBox(
        height: 16.0,
      ),
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
                    value: hp.inkomensNormToepassen),
                CheckSelectable<String>(
                    identifier: 'woningwaarde',
                    text: 'Woningwaarde',
                    value: hp.woningWaardeNormToepassen)
              ],
              onChange: (String identifier, bool value) {
                switch (identifier) {
                  case 'inkomen':
                    {
                      _veranderingInkomensNorm(!value);
                      break;
                    }
                  case 'woningwaarde':
                    {
                      _veranderingWoningWaardeNormToepassen(!value);
                      break;
                    }
                }
              })
        ],
      ),
      const SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontal,
        ),
        child: Text(
          'Gegevens',
          style: headlineMedium,
        ),
      ),
      const SizedBox(
        height: 4.0,
      ),
      MyCheckbox(
          text: 'Starter', value: hp.starter, onChanged: _veranderingStarter),
      AnimatedScaleResizeSwitcher(
          child: HypotheekProfielVerwerken.eigenwoningReserveOptie(hp)
              ? MyCheckbox(
                  text: 'Eigenwoningreserve',
                  value: hp.eigenWoningReserve.ewrToepassen,
                  onChanged: _veranderingEwrToepassen)
              : const SizedBox.shrink())
    ];

    return SliverToBoxAdapter(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  _veranderingDoelOverzicht(DoelHypotheekOverzicht? doelHypotheekOverzicht) {
    notifier.verandering(
        doelHypotheekOverzicht: doelHypotheekOverzicht,
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingOmschrijving(String omschrijving) {
    notifier.verandering(
        omschrijving: omschrijving,
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingInkomensNorm(bool? value) {
    notifier.verandering(
        inkomensNormToepassen: value,
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingWoningWaardeNormToepassen(bool? value) {
    notifier.verandering(
        woningWaardeNormToepassen: value,
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingStarter(bool? value) {
    notifier.verandering(
        starter: value, controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingEwrToepassen(bool? value) {
    notifier.veranderingEwr(
        ewrToepassing: value!,
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }
}

/// Eigen Woning Reserve
///
///
///
///
///

class HypotheekProfielEigenWoningReservePanel extends ConsumerStatefulWidget {
  final ControllerSliverRowBox<String, Waarde> controllerSliverRowBox;

  const HypotheekProfielEigenWoningReservePanel({
    super.key,
    required this.controllerSliverRowBox,
  });

  @override
  ConsumerState<HypotheekProfielEigenWoningReservePanel> createState() =>
      HypotheekProfielEigenWoningReservePanelState();
}

class HypotheekProfielEigenWoningReservePanelState
    extends AbstractHypotheekProfielConsumerState<
        HypotheekProfielEigenWoningReservePanel> {
  TextEditingController? _tecEigenwoningReserve;

  TextEditingController get tecEigenwoningReserve {
    _tecEigenwoningReserve ??= TextEditingController(
        text: doubleToText((hp) => hp.eigenWoningReserve.ewr));
    return _tecEigenwoningReserve!;
  }

  FocusNode? _fnEigenWoningReserve;

  FocusNode get fnEigenWoningReserve {
    _fnEigenWoningReserve ??= FocusNode()
      ..addListener(() {
        if (!_fnEigenWoningReserve!.hasFocus) {
          _veranderingEigenWoningReserve(_tecEigenwoningReserve?.text ?? '');
        }
      });
    return _fnEigenWoningReserve!;
  }

  TextEditingController? _tecOorspronkelijkeLening;

  TextEditingController get tecOorspronkelijkeLening {
    _tecOorspronkelijkeLening ??= TextEditingController(
        text: doubleToText(
            (hp) => hp.eigenWoningReserve.oorspronkelijkeHoofdsom));
    return _tecOorspronkelijkeLening!;
  }

  FocusNode? _fnOorspronkelijkeLening;

  FocusNode get fnOorspronkelijkeLening {
    _fnOorspronkelijkeLening ??= FocusNode()
      ..addListener(() {
        if (!_fnOorspronkelijkeLening!.hasFocus) {
          _veranderingOorsprongelijkelLening(
              _tecOorspronkelijkeLening?.text ?? '');
        }
      });
    return _fnOorspronkelijkeLening!;
  }

  @override
  void dispose() {
    _tecEigenwoningReserve?.dispose();
    _fnEigenWoningReserve?.dispose();
    _tecOorspronkelijkeLening?.dispose();
    _fnOorspronkelijkeLening?.dispose();
    super.dispose();
  }

  @override
  Widget buildHypotheekProfiel(BuildContext context,
      HypotheekProfielBewerken bewerken, HypotheekProfiel hp) {
    return SliverToBoxAdapter(
        child: AnimatedScaleResizeSwitcher(
            child: HypotheekProfielVerwerken.eigenwoningReserveZichtbaar(hp)
                ? _eigenWoningReserve(context, hp)
                : const SizedBox.shrink()));
  }

  _eigenWoningReserve(BuildContext context, HypotheekProfiel hp) {
    final theme = Theme.of(context);
    final displaySmall = theme.textTheme.displaySmall;
    final erwBerekenen = hp.eigenWoningReserve.ewrBerekenen;

    final children = <Widget>[
      Text(
        'Eigenwoningreserve',
        style: displaySmall,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 24.0,
      ),
      UndefinedSelectableGroup(
        groups: [
          MyRadioGroup<bool>(
              primaryColor: theme.colorScheme.onSecondary,
              onPrimaryColor: theme.colorScheme.onInverseSurface,
              list: [
                RadioSelectable(text: 'Invullen', value: false),
                RadioSelectable(text: 'Berekenen', value: true)
              ],
              groupValue: erwBerekenen,
              onChange: _eigenWoningReserveBerekenen)
        ],
        matchTargetWrap: [
          MatchTargetWrap<GroupLayoutProperties>(
              object: GroupLayoutProperties.horizontal(
                  options: const SelectableGroupOptions(
                      space: 4.0,
                      selectedGroupTheme: SelectedGroupTheme.button))),
        ],
      ),
      erwBerekenen
          ? _initieleLeningInvullen(hp)
          : _eigenWoningReserveInvullen(),
      const SizedBox(
        height: 8.0,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Material(
        color: const Color.fromARGB(
            255, 239, 249, 253), //Color.fromARGB(255, 250, 247, 232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _initieleLeningInvullen(HypotheekProfiel hp) {
    return Padding(
      key: const Key('OorspronkelijkeHoofdsom'),
      padding: const EdgeInsets.symmetric(horizontal: _horizontal),
      child: TextFormField(
        controller: tecOorspronkelijkeLening,
        focusNode: fnOorspronkelijkeLening,
        decoration: InputDecoration(
            hintText: 'bedrag',
            labelText:
                hp.doelHypotheekOverzicht == DoelHypotheekOverzicht.nieuweWoning
                    ? 'Oorspronkelijke lening'
                    : 'Oorspronkelijke lening vorige woning'),
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [nf.numberInputFormat('#.00')],
        validator: (String? value) {
          if (nf.parsToDouble(value) < 0.0) {
            return 'Hoofdsom >= 0.0';
          }
          return null;
        },
      ),
    );
  }

  Widget _eigenWoningReserveInvullen() {
    return Padding(
      key: const Key('WoningReserve'),
      padding: const EdgeInsets.symmetric(horizontal: _horizontal),
      child: TextFormField(
        controller: tecEigenwoningReserve,
        focusNode: _fnEigenWoningReserve,
        decoration: const InputDecoration(
            hintText: 'bedrag', labelText: 'Eigenwoningreserve'),
        keyboardType: const TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [nf.numberInputFormat('#.00')],
        validator: (String? value) {
          if (nf.parsToDouble(value) < 0.0) {
            return 'Bedrag >= 0.0';
          }
          return null;
        },
      ),
    );
  }

  _eigenWoningReserveBerekenen(bool? value) {
    notifier.veranderingEwr(
        ewrBerekenen: value,
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingEigenWoningReserve(String? value) {
    notifier.veranderingEwr(
        ewr: nf.parsToDouble(value),
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }

  _veranderingOorsprongelijkelLening(String? value) {
    notifier.veranderingEwr(
        oorspronkelijkeHoofdsom: nf.parsToDouble(value),
        controllerSliverRowBox: widget.controllerSliverRowBox);
  }
}

/// Vorige woning
///
///
///
///
///

class HypotheekProfielVorigeWoningPanel extends ConsumerStatefulWidget {
  final ControllerSliverRowBox<String, Waarde> controllerSliverRowBox;

  const HypotheekProfielVorigeWoningPanel({
    super.key,
    required this.controllerSliverRowBox,
  });

  @override
  ConsumerState<HypotheekProfielVorigeWoningPanel> createState() =>
      HypotheekProfielVorigeWoningPanelState();
}

class HypotheekProfielVorigeWoningPanelState
    extends AbstractHypotheekProfielConsumerState<
        HypotheekProfielVorigeWoningPanel> {
  late TextEditingController _tecWoningWaarde;
  late FocusNode _fnWoningWaarde;
  late TextEditingController _tecRestSchuldLening;
  late FocusNode _fnRestSchuldLening;

  late List<SliverBoxItemState<String>> topList;
  late List<SliverBoxItemState<Waarde>> bodyList;
  late List<SliverBoxItemState<String>> bottomList;

  bool woningGegevensZichtbaar = false;

  @override
  void initState() {
    _tecWoningWaarde = TextEditingController(
        text: doubleToText((hp) => hp.vorigeWoningKosten.woningWaarde));

    _fnWoningWaarde = FocusNode()
      ..addListener(() {
        bool f = _fnWoningWaarde.hasFocus;
        if (!f) {
          _veranderingWoningwaarde(_tecWoningWaarde.text);
        }
      });

    _tecRestSchuldLening = TextEditingController(
        text: doubleToText((hp) => hp.vorigeWoningKosten.lening));

    _fnRestSchuldLening = FocusNode()
      ..addListener(() {
        if (!_fnRestSchuldLening.hasFocus) {
          _veranderingLening(_tecRestSchuldLening.text);
        }
      });

    woningGegevensZichtbaar =
        HypotheekProfielVerwerken.woningGegevensZichtbaar(hp);

    topList = HypotheekProfielVerwerken.createTop(hp, woningGegevensZichtbaar);
    bodyList =
        HypotheekProfielVerwerken.createBody(hp, woningGegevensZichtbaar);
    bottomList =
        HypotheekProfielVerwerken.createBottom(hp, woningGegevensZichtbaar);

    super.initState();
  }

  @override
  void didUpdateWidget(HypotheekProfielVorigeWoningPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tecWoningWaarde.dispose();
    _fnWoningWaarde.dispose();
    _tecRestSchuldLening.dispose();
    _fnRestSchuldLening.dispose();

    super.dispose();
  }

  @override
  Widget buildHypotheekProfiel(BuildContext context,
      HypotheekProfielBewerken bewerken, HypotheekProfiel hp) {
    return SliverRowBox<String, Waarde>(
      controller: widget.controllerSliverRowBox,
      bodyList: bodyList,
      topList: topList,
      bottomList: bottomList,
      buildSliverBoxItem: ({
        required SliverRowBoxModel<String, Waarde> model,
        Animation? animation,
        required int index,
        required int length,
        required SliverBoxItemState<Waarde> state,
      }) =>
          _buildItem(
              model: model,
              hp: hp,
              animation: animation,
              index: index,
              length: length,
              state: state),
      buildSliverBoxTopBottom: ({
        required SliverRowBoxModel<String, Waarde> model,
        Animation? animation,
        required int index,
        required int length,
        required SliverBoxItemState<String> state,
      }) =>
          _buildTopBottom(
              model: model,
              hp: hp,
              animation: animation,
              index: index,
              length: length,
              state: state),
    );
  }

  Widget _buildItem(
      {required SliverRowBoxModel<String, Waarde> model,
      required HypotheekProfiel hp,
      Animation? animation,
      required int index,
      required int length,
      required SliverBoxItemState<Waarde> state}) {
    final child = DefaultKostenRowItem(
        key: Key(state.key),
        state: state,
        button: (SliverBoxItemState<Waarde> state) => StandaardKostenMenu(
              aanpassenWaarde:
                  (SelectedMenuPopupIdentifierValue<String, dynamic> v) =>
                      _veranderingWaardeOpties(state: state, iv: v),
              waarde: state.value,
            ),
        omschrijvingAanpassen: (String v) => _veranderingOmschrijving(
              state: state,
              text: v,
            ),
        waardeAanpassen: (double value) => _veranderingWaarde(
              state: state,
              value: value,
            ));

    return InsertRemoveVisibleAnimatedSliverRowItem(
      model: model,
      animation: animation,
      key: Key('item_${state.key}'),
      state: state,
      child: SliverRowItemBackground(
        key: Key(state.key),
        backgroundColor: const Color.fromARGB(255, 239, 249, 253),
        child: SizedSliverBox(height: state.height, child: child),
      ),
    );
  }

  Widget _buildTopBottom({
    required SliverRowBoxModel<String, Waarde> model,
    required HypotheekProfiel hp,
    Animation? animation,
    required int index,
    required int length,
    required SliverBoxItemState<String> state,
  }) {
    switch (state.key) {
      case 'topPadding':
        {
          return const SizedBox(
            height: 16.0,
          );
        }
      case 'woningTitle':
        {
          final theme = Theme.of(context);
          final displaySmall = theme.textTheme.displaySmall;

          final child = Center(
              child: Text(
            hp.doelHypotheekOverzicht == DoelHypotheekOverzicht.nieuweWoning
                ? 'Huidige Woning'
                : 'Vorige Woning',
            style: displaySmall,
            textAlign: TextAlign.center,
          ));

          return InsertRemoveVisibleAnimatedSliverRowItem(
              model: model,
              animation: animation,
              key: Key('item_${state.key}'),
              state: state,
              child: SliverRowItemBackground(
                radialTop: 32.0,
                key: Key(state.key),
                backgroundColor: const Color.fromARGB(255, 239, 249, 253),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: child,
                ),
              ));
        }
      case 'woning':
        {
          final child = TextFormField(
            controller: _tecWoningWaarde,
            focusNode: _fnWoningWaarde,
            decoration: const InputDecoration(
                hintText: 'Bedrag', labelText: 'Woningwaarde'),
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputFormatters: [nf.numberInputFormat('#.00')],
            validator: (String? value) {
              if (nf.parsToDouble(value) == 0.0) {
                return 'Geen bedrag';
              }
              return null;
            },
          );

          return InsertRemoveVisibleAnimatedSliverRowItem(
              model: model,
              animation: animation,
              key: Key('item_${state.key}'),
              state: state,
              child: SliverRowItemBackground(
                key: Key(state.key),
                backgroundColor: const Color.fromARGB(255, 239, 249, 253),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 4.0, right: 16.0, bottom: 2.0),
                  child: child,
                ),
              ));
        }
      case 'kostenTitle':
        {
          {
            final theme = Theme.of(context);
            final displaySmall = theme.textTheme.displaySmall;

            final child = Center(
                child: Text(
              'Kosten',
              style: displaySmall,
              textAlign: TextAlign.center,
            ));

            return InsertRemoveVisibleAnimatedSliverRowItem(
                model: model,
                animation: animation,
                key: Key('item_${state.key}'),
                state: state,
                child: SliverRowItemBackground(
                  key: Key(state.key),
                  backgroundColor: const Color.fromARGB(255, 239, 249, 253),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: child,
                  ),
                ));
          }
        }

      case 'lening':
        {
          final child = TextFormField(
              key: const Key('hypotheekInvullen'),
              controller: _tecRestSchuldLening,
              focusNode: _fnRestSchuldLening,
              decoration: const InputDecoration(
                  hintText: 'Bedrag', labelText: 'Restschuld lening(en)'),
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatters: [nf.numberInputFormat('#.00')],
              validator: (String? value) {
                if (nf.parsToDouble(value) < 0.0) {
                  return 'Bedrag >= 0.0';
                }
                return null;
              });

          return InsertRemoveVisibleAnimatedSliverRowItem(
              model: model,
              animation: animation,
              key: Key('item_${state.key}'),
              state: state,
              child: SliverRowItemBackground(
                radialTop: 0,
                key: Key(state.key),
                backgroundColor: const Color.fromARGB(255, 239, 249, 253),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: child,
                ),
              ));
        }
      case 'bottom':
        {
          return InsertRemoveVisibleAnimatedSliverRowItem(
              model: model,
              animation: animation,
              key: Key('item_${state.key}'),
              state: state,
              child: SliverRowItemBackground(
                radialbottom: 32.0,
                key: Key(state.key),
                backgroundColor: const Color.fromARGB(255, 239, 249, 253),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Center(
                      child: ToevoegenKostenButton(
                          pressed: () => toevoegKostenItem(hp))),
                ),
              ));
        }
      case 'totaleKosten':
        {
          final child = TotaleKostenRowItem(
            backgroundColor: const Color.fromARGB(255, 239, 249, 253),
            totaleKosten: hp.vorigeWoningKosten.totaleKosten,
          );

          return InsertRemoveVisibleAnimatedSliverRowItem(
              model: model,
              animation: animation,
              key: Key('item_${state.key}'),
              state: state,
              child: SliverRowItemBackground(
                key: Key(state.key),
                backgroundColor: const Color.fromARGB(255, 239, 249, 253),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: child,
                ),
              ));
        }
      default:
        {
          return const Text(':(');
        }
    }
  }

  void toevoegKostenItem(HypotheekProfiel hp) {
    final resterend = HypotheekProfielVerwerken.suggestieKosten(hp);

    if (resterend.length == 1) {
      _toevoegenWaardes(resterend);
    } else {
      showKosten(
              context: context,
              lijst: resterend,
              image: Image.asset('graphics/kapot_varken.png'),
              title: 'Kosten')
          .then((List<Waarde>? value) {
        if (value != null && value.isNotEmpty) {
          _toevoegenWaardes(value);
        }
      });
    }
  }

  _toevoegenWaardes(List<Waarde> lijst) {
    final fhp = hp;

    if (fhp == null) return;

    int index = fhp.vorigeWoningKosten.kosten.fold<int>(
        1000,
        (previousValue, element) => previousValue < element.index + 1
            ? element.index + 1
            : previousValue);

    lijst = [
      for (Waarde w in lijst) w.standaard ? w : w.copyWith(index: index++)
    ];

    final feedback = widget.controllerSliverRowBox.insertGroup(
        body: (List<SliverBoxItemState<Waarde>> list) {
      list
        ..addAll([
          for (Waarde w in lijst)
            SliverBoxItemState<Waarde>(
                single: true,
                height: 72.0,
                value: w,
                key: w.key,
                status: ItemStatusSliverBox.insert)
        ])
        ..sort((a, b) => a.value.index.compareTo(b.value.index));
    });

    if (feedback == SliverBoxRowRequestFeedBack.accepted) {
      notifier.veranderingVorigeWoningKosten(toevoegen: lijst);
    } else {
      debugPrint('Insertion not accepted, because busy with $feedback');
    }
  }

  SliverBoxRowRequestFeedBack _verwijderWaardes(List<Waarde> lijst) {
    return widget.controllerSliverRowBox.removeGroup(
        body: (List<SliverBoxItemState<Waarde>> list) {
      for (SliverBoxItemState<Waarde> state in list) {
        if (lijst.contains(state.value)) {
          state
            ..single = true
            ..status = ItemStatusSliverBox.remove;
        }
      }
    });
  }

  _veranderingWoningwaarde(String value) {
    notifier.veranderingVorigeWoningKosten(
        woningWaarde: nf.parsToDouble(value));
  }

  _veranderingLening(String value) {
    notifier.veranderingVorigeWoningKosten(lening: nf.parsToDouble(value));
  }

  _veranderingOmschrijving(
      {required SliverBoxItemState<Waarde> state, required String text}) {
    state.value =
        notifier.veranderingWaarde(waarde: state.value, omschrijving: text);
  }

  _veranderingWaarde(
      {required SliverBoxItemState<Waarde> state, required double value}) {
    state.value = notifier.veranderingWaarde(waarde: state.value, getal: value);
  }

  _veranderingWaardeOpties(
      {required SliverBoxItemState<Waarde> state,
      required SelectedMenuPopupIdentifierValue<String, dynamic> iv}) {
    switch (iv.identifier) {
      case 'eenheid':
        {
          state.value = notifier.veranderingWaarde(
              waarde: state.value, eenheid: iv.value);
          break;
        }
      case 'aftrekbaar':
        {
          state.value = notifier.veranderingWaarde(
              waarde: state.value, aftrekbaar: iv.value);
          break;
        }
      case 'verwijderen':
        {
          if (_verwijderWaardes([state.value]) ==
              SliverBoxRowRequestFeedBack.accepted) {
            state.key = '${state.value.key}_remove';
            notifier.veranderingVorigeWoningKosten(verwijderen: [state.value]);
          } else {
            debugPrint('Remove not accepted');
          }
          break;
        }
    }
  }
}
