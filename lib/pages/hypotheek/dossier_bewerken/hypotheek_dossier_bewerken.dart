// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/animated_sliver_box_goodies/sliver_box_resize_switcher.dart';
import 'package:animated_sliver_box/animated_sliver_box_goodies/sliver_box_transfer_widget.dart';
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/uitwerken/hypotheekdossier_verwerken.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_sliver_box_model.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/alleen_bedrag.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/edit_box_properties.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/box_properties_constants.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_view_model.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/dossier_kosten_item_bewerken.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/utilities/match_properties.dart';
import '../../../my_widgets/animated_sliver_widgets/kosten_dialog.dart';
import '../../../my_widgets/animated_sliver_widgets/standard_kosten_item.dart';
import '../../../my_widgets/end_focus.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../platform_page_format/default_match_page_properties.dart';
import '../../../utilities/device_info.dart';
import 'abstract_hypotheek_dossier_consumer.dart';
import 'model/hypotheek_dossier_view_state.dart';

const _horizontal = 8.0;

class HypotheekDossierBewerken extends ConsumerStatefulWidget {
  const HypotheekDossierBewerken({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HypotheekDossierBewerkenState();
}

class _HypotheekDossierBewerkenState
    extends ConsumerState<HypotheekDossierBewerken> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final FocusScopeNode focusNodeScope;

  @override
  void initState() {
    focusNodeScope = FocusScopeNode(
        canRequestFocus: true,
        traversalEdgeBehavior: TraversalEdgeBehavior.leaveFlutterView);
    super.initState();
  }

  @override
  void dispose() {
    focusNodeScope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;

    return DefaultPage(
        title: 'Dossier',
        imageBuilder: (_) => Image(
            image: const AssetImage(
              'graphics/profiel.png',
            ),
            color: theme.colorScheme.onSurface),
        sliversBuilder: (
                {required BuildContext context,
                required EdgeInsets padding,
                Widget? appBar}) =>
            Form(
              key: _formKey,
              child: FocusScope(
                node: focusNodeScope,
                child: FocusTraversalGroup(
                  policy: ReadingOrderTraversalPolicy(),
                  child: CustomScrollView(slivers: [
                    if (appBar != null) appBar,
                    // if (nested)
                    //   SliverOverlapInjector(
                    //     // This is the flip side of the SliverOverlapAbsorber
                    //     // above.
                    //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    //         context),
                    //   ),
                    SliverPadding(
                        padding: padding.copyWith(bottom: 0.0),
                        sliver: const HypotheekDossierOptiePanel()),
                    SliverPadding(
                        padding: padding.copyWith(top: 0.0),
                        sliver:
                            const DossierHypotheekErwWoningLeningKostenPanel()),
                  ]),
                ),
              ),
            ),
        getPageProperties: (
                {required hasScrollBars,
                required formFactorType,
                required orientation,
                required bottom}) =>
            hypotheekPageProperties(
                hasScrollBars: hasScrollBars,
                formFactorType: formFactorType,
                orientation: orientation,
                bottom: bottom,
                leftTopActions: [
                  PageActionItem(voidCallback: cancel, icon: Icons.arrow_back)
                ],
                rightTopActions: [
                  PageActionItem(voidCallback: save, icon: Icons.save_alt)
                ]));
  }

  save() {
    if (_formKey.currentState?.validate() ?? false) {
      final hypotheekDossier =
          ref.read(hypotheekDossierProvider).hypotheekDossier;

      ref
          .read(hypotheekDocumentProvider.notifier)
          .hypotheekDossierToevoegen(hypotheekDossier: hypotheekDossier);

      scheduleMicrotask(() {
        Beamer.of(context, root: true).popToNamed('/document/hypotheek/lening');
      });
    }
  }

  cancel() {
    Beamer.of(context, root: true).popToNamed(
      '/document/hypotheek/dossier',
    );
  }
}

class HypotheekDossierOptiePanel extends ConsumerStatefulWidget {
  const HypotheekDossierOptiePanel({
    super.key,
  });

  @override
  ConsumerState<HypotheekDossierOptiePanel> createState() =>
      _HypotheekDossierOptiePanelState();
}

class _HypotheekDossierOptiePanelState
    extends AbstractHypotheekDossierConsumerState<HypotheekDossierOptiePanel> {
  late TextEditingController _tecOmschrijving;
  late FocusNode _fnOmschrijving;

  @override
  void initState() {
    _tecOmschrijving = TextEditingController(
        text: toText(
      (hd) => hd.omschrijving,
    ));

    _fnOmschrijving = FocusNode()
      ..addListener(() {
        if (!_fnOmschrijving.hasFocus) {
          notifier.verandering(omschrijving: _tecOmschrijving.text);
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
  Widget buildHypotheekDossier(BuildContext context,
      HypotheekDossierViewState bewerken, HypotheekDossier hd) {
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
              groupValue: hd.doelHypotheekOverzicht,
              onChange: (DoelHypotheekOverzicht? value) =>
                  notifier.verandering(doelHypotheekOverzicht: value))
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
                    value: hd.inkomensNormToepassen),
                CheckSelectable<String>(
                    identifier: 'woningwaarde',
                    text: 'Woningwaarde',
                    value: hd.woningWaardeNormToepassen)
              ],
              onChange: (String identifier, bool value) {
                switch (identifier) {
                  case 'inkomen':
                    {
                      notifier.verandering(inkomensNormToepassen: !value);
                      break;
                    }
                  case 'woningwaarde':
                    {
                      notifier.verandering(woningWaardeNormToepassen: !value);
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
      UndefinedSelectableGroup(
        groups: [
          MyCheckGroup<String>(
              list: [
                CheckSelectable<String>(
                    identifier: 'starter', text: 'Starter', value: hd.starter),
                CheckSelectable<String>(
                    identifier: 'eigenwoning',
                    text: hd.doelHypotheekOverzicht ==
                            DoelHypotheekOverzicht.nieuweWoning
                        ? 'Huidige/Vorige Eigenwoning'
                        : 'Vorige Eigenwoning',
                    value: hd.eigenWoning),
                CheckSelectable<String>(
                    identifier: 'ewr',
                    text: 'Eigenwoningreserve',
                    value: hd.ewrToepassen)
              ],
              onChange: (String identifier, bool value) {
                switch (identifier) {
                  case 'starter':
                    {
                      notifier.verandering(starter: !value);
                      break;
                    }
                  case 'eigenwoning':
                    {
                      notifier.verandering(eigenWoning: !value);
                      break;
                    }
                  case 'ewr':
                    {
                      notifier.verandering(ewrToepassen: !value);
                      break;
                    }
                }
              })
        ],
      ),
    ];

    return SliverToBoxAdapter(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }
}

/// Vorige woning
///
///
///
///
///

class DossierHypotheekErwWoningLeningKostenPanel
    extends ConsumerStatefulWidget {
  const DossierHypotheekErwWoningLeningKostenPanel({
    super.key,
  });

  @override
  ConsumerState<DossierHypotheekErwWoningLeningKostenPanel> createState() =>
      DossierHypotheekErwWoningLeningKostenState();
}

class DossierHypotheekErwWoningLeningKostenState
    extends AbstractHypotheekDossierConsumerState<
        DossierHypotheekErwWoningLeningKostenPanel> {
  final backgroundColor = const Color(0xFFf0f8ff);

  @override
  void initState() {
    super.initState();
  }

  BoxItemTransitionState toVisibleState(bool value) =>
      value ? BoxItemTransitionState.visible : BoxItemTransitionState.invisible;

  List<EditableBoxProperties> createTop(HypotheekDossier? hypotheekDossier) {
    if (hypotheekDossier == null) return [];

    final ewrVisible = hypotheekDossier.inkomensNormToepassen &&
        (hypotheekDossier.ewrToepassen || hypotheekDossier.eigenWoning);

    final woningLeningKostenVisible = hypotheekDossier.eigenWoning ||
        (hypotheekDossier.ewrToepassen && hypotheekDossier.ewrBerekenen);

    return [
      EditableBoxProperties(
        id: 'ewrTitle',
        transitionStatus: toVisibleState(ewrVisible),
        sizeStandardPanel: 112.0,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'ewr',
        transitionStatus: toVisibleState(ewrVisible),
        sizeStandardPanel: 48.0,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'woningTitle',
        transitionStatus: toVisibleState(woningLeningKostenVisible),
        sizeStandardPanel: 48.0,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'woning',
        transitionStatus: toVisibleState(woningLeningKostenVisible),
        sizeStandardPanel: 48.0,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'oorspronkelijkeHoofdsom',
        transitionStatus:
            toVisibleState(woningLeningKostenVisible && ewrVisible),
        sizeStandardPanel: 48.0,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'restschuld',
        transitionStatus: toVisibleState(woningLeningKostenVisible),
        sizeStandardPanel: 48.0,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'unfocus',
        sizeStandardPanel: 0.0,
        transitionStatus: BoxItemTransitionState.visible,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'kostenTitle',
        transitionStatus: toVisibleState(woningLeningKostenVisible),
        sizeStandardPanel: 64.0,
        panel: BoxPropertiesPanels.standard,
      ),
    ];
  }

  List<EditableBoxProperties> createBottom(HypotheekDossier? hypotheekDossier) {
    if (hypotheekDossier == null) return [];

    final woningLeningKostenVisible = hypotheekDossier.eigenWoning ||
        (hypotheekDossier.ewrToepassen && hypotheekDossier.ewrBerekenen);

    return [
      EditableBoxProperties(
        id: 'unfocus',
        sizeStandardPanel: 0.0,
        transitionStatus: BoxItemTransitionState.visible,
        panel: BoxPropertiesPanels.standard,
      ),
      EditableBoxProperties(
        id: 'bottom',
        sizeStandardPanel: 48.0,
        transitionStatus: toVisibleState(woningLeningKostenVisible),
        panel: BoxPropertiesPanels.standard,
      ),
    ];
  }

  List<KostenItemBoxProperties> createBody(HypotheekDossier? hypotheekDossier) {
    if (hypotheekDossier == null) return [];

    final woningLeningKostenVisible = hypotheekDossier.eigenWoning ||
        (hypotheekDossier.ewrToepassen && hypotheekDossier.ewrBerekenen);

    return hypotheekDossier.kosten
        .map((Waarde e) => KostenItemBoxProperties(
            id: e.key,
            value: e,
            transitionStatus: toVisibleState(woningLeningKostenVisible),
            panel: BoxPropertiesPanels.standard))
        .toList();
  }

  @override
  void didUpdateWidget(DossierHypotheekErwWoningLeningKostenPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildHypotheekDossier(BuildContext context,
      HypotheekDossierViewState bewerken, HypotheekDossier hd) {
    return AnimatedSliverBox<DossierSliverBoxModel>(
        controllerSliverRowBox: bewerken.controllerVorigeWoningKosten,
        createSliverRowBoxModel:
            ((sliverBoxContext, axis) =>
                DossierSliverBoxModel(
                    sliverBoxContext: sliverBoxContext,
                    topBox: SingleBoxModel<String, EditableBoxProperties>(
                        items: createTop(bewerken.hypotheekDossier),
                        tag: 'top',
                        buildStateItem: _buildTopBottom),
                    dossierBox: SingleBoxModel<String, KostenItemBoxProperties>(
                        tag: 'body',
                        items: createBody(bewerken.hypotheekDossier),
                        buildStateItem: _buildItem),
                    bottomBox: SingleBoxModel<String, EditableBoxProperties>(
                        items: createBottom(bewerken.hypotheekDossier),
                        tag: 'bottom',
                        buildStateItem: _buildTopBottom),
                    axis: axis,
                    duration: const Duration(milliseconds: 300))),
        updateSliverRowBoxModel: (model, axis) => {});
  }

  Widget _buildItem(
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

    Widget standard(bool complete) => StandardKostenItem(
          properties: properties,
          changePanel: () {
            setState(() {
              properties.setToPanel(BoxPropertiesPanels.edit);
            });
          },
        );

    Widget edit(bool complete) => DossierKostenItemBewerken(
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
  }

  Widget _buildTopBottom(
      {required BuildContext buildContext,
      Animation<double>? animation,
      required AnimatedSliverBoxModel<String> model,
      required EditableBoxProperties properties,
      required SingleBoxModel<String, EditableBoxProperties> singleBoxModel,
      required int index}) {
    switch (properties.id) {
      case 'ewrTitle':
        {
          final theme = Theme.of(context);
          final displaySmall = theme.textTheme.displaySmall;
          Widget child = SizedBox(
            height: properties.sizeStandardPanel,
            child: Column(
              children: [
                Text(
                  'Eigenwoningreserve',
                  style: displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                UndefinedSelectableGroup(
                  groups: [
                    MyRadioGroup<bool>(
                        primaryColor: theme.colorScheme.onSurface,
                        onPrimaryColor: theme.colorScheme.surface,
                        list: [
                          RadioSelectable(text: 'Invullen', value: false),
                          RadioSelectable(text: 'Berekenen', value: true)
                        ],
                        groupValue: hd.ewrBerekenen,
                        onChange: (bool? value) {
                          notifier.verandering(ewrBerekenen: value);
                        })
                  ],
                  matchTargetWrap: [
                    MatchTargetWrap<GroupLayoutProperties>(
                        object: GroupLayoutProperties.horizontal(
                            options: const SelectableGroupOptions(
                                space: 4.0,
                                selectedGroupTheme:
                                    SelectedGroupTheme.button))),
                  ],
                ),
                const SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          );

          return SliverBoxTransferWidget(
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: child,
              ));
        }
      case 'ewr':
        {
          Widget standard(_) => AlleenBedrag(
                height: properties.sizeStandardPanel,
                bedrag: hd.ewr,
                changePanel: () {
                  setState(() {
                    properties.setToPanel(BoxPropertiesPanels.edit);
                  });
                },
                nf: nf,
                omschrijving: 'Eigenwoningreserve',
              );

          Widget edit(bool complete) => AlleenBedragBewerken(
              bedrag: hd.ewr,
              hintText: 'Bedrag',
              labelText: 'Eigenwoningreserve',
              animationComplete: complete,
              veranderingBedrag: (double value) {
                properties.setToPanel(BoxPropertiesPanels.standard);
                notifier.verandering(ewr: value);
              });

          Widget child;

          if (properties.innerTransition) {
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
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: child);
        }

      case 'woningTitle':
        {
          final theme = Theme.of(context);
          final displaySmall = theme.textTheme.displaySmall;

          final child = SizedBox(
            height: properties.sizeStandardPanel,
            child: Center(
                child: Text(
              hd.doelHypotheekOverzicht == DoelHypotheekOverzicht.nieuweWoning
                  ? 'Huidige Woning'
                  : 'Vorige Woning',
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
          Widget standard(_) => AlleenBedrag(
                height: properties.sizeStandardPanel,
                bedrag: hd.woningWaarde,
                validator: () => (hd.woningWaarde == 0.0)
                    ? 'Geen woningwaarde: > 0.0'
                    : null,
                changePanel: () {
                  setState(() {
                    properties.setToPanel(BoxPropertiesPanels.edit);
                  });
                },
                nf: nf,
                omschrijving: 'Woningwaarde',
              );

          Widget edit(bool complete) => AlleenBedragBewerken(
              validator: (double? value) => (value == null || value == 0.0)
                  ? 'Geen woningwaarde: > 0.0'
                  : null,
              bedrag: hd.woningWaarde,
              animationComplete: complete,
              hintText: 'Bedrag',
              labelText: 'Woningwaarde',
              veranderingBedrag: (double value) {
                properties.setToPanel(BoxPropertiesPanels.standard);
                notifier.verandering(woningWaarde: value);
              });

          Widget child;

          if (properties.innerTransition) {
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

          return KeepAlive(
            key: Key(properties.id),
            keepAlive: true,
            child: SliverBoxTransferWidget(
                model: model,
                animation: animation,
                key: Key(properties.id),
                boxItemProperties: properties,
                singleBoxModel: singleBoxModel,
                child: child),
          );
        }

      case 'oorspronkelijkeHoofdsom':
        {
          Widget standard(_) => AlleenBedrag(
                height: properties.sizeStandardPanel,
                bedrag: hd.oorspronkelijkeHoofdsom,
                changePanel: () {
                  setState(() {
                    properties.setToPanel(BoxPropertiesPanels.edit);
                  });
                },
                nf: nf,
                omschrijving: 'OorspronkelijkeHoofdsom',
              );

          Widget edit(bool complete) => AlleenBedragBewerken(
              bedrag: hd.oorspronkelijkeHoofdsom,
              hintText: 'Bedrag',
              labelText: 'OorspronkelijkeHoofdsom (Lening)',
              animationComplete: complete,
              veranderingBedrag: (double value) {
                properties.setToPanel(BoxPropertiesPanels.standard);
                notifier.verandering(oorspronkelijkeHoofdsom: value);
              });

          Widget child;

          if (properties.innerTransition) {
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
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: child);
        }
      case 'restschuld':
        {
          Widget standard(_) => AlleenBedrag(
                height: properties.sizeStandardPanel,
                bedrag: hd.restSchuld,
                changePanel: () {
                  setState(() {
                    properties.setToPanel(BoxPropertiesPanels.edit);
                  });
                },
                nf: nf,
                omschrijving: 'Restschuld lening(en)',
              );

          Widget edit(bool complete) => AlleenBedragBewerken(
              bedrag: hd.restSchuld,
              hintText: 'Bedrag',
              labelText: 'Restschuld lening(en)',
              animationComplete: complete,
              veranderingBedrag: (double value) {
                properties.setToPanel(BoxPropertiesPanels.standard);
                notifier.verandering(restSchuld: value);
              });

          Widget child;

          if (properties.innerTransition) {
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
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: child);
        }

      case 'kostenTitle':
        {
          {
            final theme = Theme.of(context);
            final displaySmall = theme.textTheme.displaySmall;

            final child = SizedBox(
              height: properties.sizeStandardPanel,
              child: Center(
                  child: Text(
                'Kosten',
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
        }

      case 'unfocus':
        {
          return const EndFocus();
        }

      case 'bottom':
        {
          final child = TotaleKostenEnToevoegen(
              totaleKosten: hd.kosten.isEmpty ? null : hd.totaleKosten,
              toevoegen: () => toevoegKostenItem(hd));

          return SliverBoxTransferWidget(
              model: model,
              animation: animation,
              key: Key(properties.id),
              boxItemProperties: properties,
              singleBoxModel: singleBoxModel,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: child,
              ));
        }

      default:
        {
          return const Text(':(');
        }
    }
  }

  void toevoegKostenItem(HypotheekDossier hd) {
    final resterend = HypotheekDossierVerwerken.suggestieKosten(hd);

    if (resterend.length == 1) {
      notifier.veranderingKostenToevoegen(resterend);
    } else {
      showKosten(
              context: context,
              lijst: resterend,
              image: Image.asset('graphics/kapot_varken.png'),
              title: 'Kosten')
          .then((List<Waarde>? value) {
        if (value != null && value.isNotEmpty) {
          notifier.veranderingKostenToevoegen(value);
        }
      });
    }
  }
}
