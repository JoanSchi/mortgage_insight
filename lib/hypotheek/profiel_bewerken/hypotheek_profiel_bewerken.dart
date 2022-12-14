import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/debts/date_picker.dart';
import 'package:mortgage_insight/hypotheek/profiel_bewerken/KostenLijst.dart';
import 'package:mortgage_insight/hypotheek/profiel_bewerken/hypotheek_profiel_model.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/my_widgets/my_page/my_page.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/routes/routes_items.dart';
import 'package:mortgage_insight/state_manager/widget_state.dart';
import 'package:mortgage_insight/utilities/MyNumberFormat.dart';
import 'package:go_router/go_router.dart';
import '../../layout/transition/scale_size_transition.dart';
import '../../model/nl/hypotheek/kosten_hypotheek.dart';
import '../../my_widgets/sliver_row_box.dart';
import '../../my_widgets/animated_scale_resize_switcher.dart';
import '../../my_widgets/selectable_button_group.dart';
import '../../my_widgets/selectable_popupmenu.dart';
import '../../utilities/device_info.dart';
import '../bewerken/hypotheek_model.dart';

const _horizontal = 8.0;

class BewerkHypotheekProfiel extends ConsumerStatefulWidget {
  BewerkHypotheekProfiel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BewerkHypotheekProfielState();
}

class _BewerkHypotheekProfielState
    extends ConsumerState<BewerkHypotheekProfiel> {
  late HypotheekProfielViewModel nieuwHypotheekProfielViewModel;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    nieuwHypotheekProfielViewModel = ref.read(routeEditPageProvider).object;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    Color? backgroundColor;

    switch (deviceScreen.formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
        break;
      default:
        backgroundColor = Colors.white;
        break;
    }

    return MyPage(
        hasNavigationBar: false,
        backgroundColor: backgroundColor,
        title: 'Profiel',
        imageName: 'graphics/fit_nieuw_profiel.png',
        body: AcceptCanelPanel(
          accept: () {
            if (_formKey.currentState?.validate() ?? false) {
              final hypotheekContainer = ref.read(hypotheekContainerProvider);

              hypotheekContainer
                  .addHypotheekProfiel(nieuwHypotheekProfielViewModel.profiel);

              if (nieuwHypotheekProfielViewModel.isNieuw) {
                scheduleMicrotask(() {
                  ref.read(routeEditPageProvider.notifier).editState =
                      EditRouteState(
                          route: routeMortgageEdit,
                          object: HypotheekViewModel(
                              inkomenLijst: hypotheekContainer.inkomenLijst(),
                              inkomenLijstPartner: hypotheekContainer
                                  .inkomenLijst(partner: true),
                              profiel: hypotheekContainer
                                  .huidigeHypotheekProfielContainer!.profiel,
                              schuldenLijst:
                                  hypotheekContainer.schuldenContainer.list));
                });
              } else {
                scheduleMicrotask(() {
                  context.pop();
                });
              }
            }
          },
          cancel: () {
            scheduleMicrotask(() {
              context.pop();
            });
          },
          child: Form(
            key: _formKey,
            child: CustomScrollView(slivers: [
              HypotheekProfielOptiePanel(
                  nieuwHypotheekProfielViewModel:
                      nieuwHypotheekProfielViewModel),
              HypotheekProfielEigenWoningReservePanel(
                  nieuwHypotheekProfielViewModel:
                      nieuwHypotheekProfielViewModel),
              HypotheekProfielVorigeWoningPanel(
                  nieuwHypotheekProfielViewModel:
                      nieuwHypotheekProfielViewModel),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 16.0,
              )),
            ]),
          ),
        ));
  }
}

class HypotheekProfielOptiePanel extends StatefulWidget {
  final HypotheekProfielViewModel nieuwHypotheekProfielViewModel;

  HypotheekProfielOptiePanel({
    Key? key,
    required this.nieuwHypotheekProfielViewModel,
  }) : super(key: key);

  @override
  State<HypotheekProfielOptiePanel> createState() =>
      _HypotheekProfielOptiePanelState();
}

class _HypotheekProfielOptiePanelState
    extends State<HypotheekProfielOptiePanel> {
  late HypotheekProfielViewModel nhpm;

  late TextEditingController _tecOmschrijving =
      TextEditingController(text: profiel.omschrijving);

  late FocusNode _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_tecOmschrijving.text);
      }
    });

  HypotheekProfiel get profiel => nhpm.profiel;

  @override
  void initState() {
    nhpm = widget.nieuwHypotheekProfielViewModel
      ..updateOptieState = updateState;
    super.initState();
  }

  @override
  void dispose() {
    _tecOmschrijving.dispose();
    nhpm.updateOptieState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headline4 = theme.textTheme.headline4;

    Widget erwVorigeWoning;

    if (profiel.doelOverzicht == DoelProfielOverzicht.nieuw) {
      erwVorigeWoning = _situatie(context, headline4);
    } else if (profiel.inkomensNormToepassen) {
      erwVorigeWoning = _erwBestaandeHypotheek(context);
    } else {
      erwVorigeWoning = SizedBox.shrink();
    }

    Widget datumWoningKopen;

    if (profiel.doelOverzicht == DoelProfielOverzicht.nieuw) {
      datumWoningKopen = Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: DateWidget(
              date: nhpm.datumWoningKopen,
              firstDate: nhpm.beginDatumWoningKopen,
              lastDate: nhpm.eindDatumWoningKopen,
              saveDate: _veranderingDatumWoningKopen));
    } else {
      datumWoningKopen = SizedBox.shrink();
    }

    List<Widget> children = [
      SizedBox(
        height: 12.0,
      ),
      OmschrijvingTextField(
        textEditingController: _tecOmschrijving,
        focusNode: _fnOmschrijving,
      ),
      SizedBox(
        height: 16.0,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: Text('Doel', style: headline4)),
      SizedBox(
        height: 4.0,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: SelectableRadioGroup(
            groupValue: profiel.doelOverzicht,
            selectableRadioItems: [
              SelectableRadioItem(
                text: 'Woning kopen',
                value: DoelProfielOverzicht.nieuw,
              ),
              SelectableRadioItem(
                text: 'Overzicht bestaande hypotheek(en)',
                value: DoelProfielOverzicht.bestaand,
              )
            ],
            onChange: _veranderingDoelProfiel,
          )),
      AnimatedScaleResizeSwitcher(child: datumWoningKopen),
      SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontal),
        child: Text(
          'Financieringsnorm',
          style: headline4,
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontal),
        child: SelectableCheckGroup(selectableItems: [
          SelectableCheckItem(
              text: 'Inkomen',
              value: profiel.inkomensNormToepassen,
              changeChecked: _veranderingInkomensNorm),
          SelectableCheckItem(
              text: 'Woningwaarde',
              value: profiel.woningWaardeNormToepassen,
              changeChecked: _veranderingWoningWaardeNormToepassen)
        ]),
      ),
      AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleResizedTransition(scale: animation, child: child),
            );
          },
          duration: const Duration(milliseconds: 200),
          child: erwVorigeWoning),
    ];

    return SliverToBoxAdapter(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  _situatie(BuildContext context, TextStyle? headline4) {
    List<Widget> children = [
      SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontal,
        ),
        child: Text(
          'Huidige situatie',
          style: headline4,
        ),
      ),
      SizedBox(
        height: 4.0,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontal,
          ),
          child: SelectableRadioGroup(selectableRadioItems: [
            SelectableRadioItem(text: 'Starter', value: Situatie.starter),
            SelectableRadioItem(
                text: 'Geen koopwoning', value: Situatie.geenKoopwoning),
            SelectableRadioItem(text: 'Koopwoning', value: Situatie.koopwoning),
          ], groupValue: profiel.situatie, onChange: _veranderingSituatie)),
      AnimatedScaleResizeSwitcher(
          child: profiel.situatie == Situatie.geenKoopwoning
              ? Padding(
                  padding: const EdgeInsets.only(
                      left: _horizontal + 16.0, top: 4.0, right: _horizontal),
                  child: SelectableCheckGroup(selectableItems: [
                    SelectableCheckItem(
                        text: 'Eigenwoningreserve',
                        value: profiel.eigenReserveWoning.erwToepassing,
                        changeChecked: _veranderingEWR)
                  ]),
                )
              : SizedBox.shrink()),
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  _erwBestaandeHypotheek(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: _horizontal + 16.0, top: 4.0, right: _horizontal),
      child: SelectableCheckGroup(selectableItems: [
        SelectableCheckItem(
            text: 'Eigenwoningreserve',
            value: profiel.eigenReserveWoning.erwToepassing,
            changeChecked: _veranderingEWR)
      ]),
    );
  }

  _veranderingOmschrijving(String value) {
    nhpm.veranderingOmschrijving(value);
  }

  _veranderingDoelProfiel(DoelProfielOverzicht? value) {
    nhpm.veranderingDoelProfiel(value!);
  }

  _veranderingDatumWoningKopen(DateTime value) {
    nhpm.veranderingDatumWoningKopen(value);
  }

  _veranderingInkomensNorm(bool? value) {
    nhpm.veranderingInkomensNorm(value!);
  }

  _veranderingWoningWaardeNormToepassen(bool? value) {
    nhpm.veranderingWoningWaardeToepassen(value!);
  }

  _veranderingSituatie(Situatie? value) {
    nhpm.veranderingSituatie(value!);
  }

  _veranderingEWR(bool? value) {
    nhpm.veranderingERW(value!);
  }

  updateState() {
    setState(() {});
  }
}

/// Eigen Woning Reserve
///
///
///
///
///

class HypotheekProfielEigenWoningReservePanel extends StatefulWidget {
  final HypotheekProfielViewModel nieuwHypotheekProfielViewModel;

  HypotheekProfielEigenWoningReservePanel({
    Key? key,
    required this.nieuwHypotheekProfielViewModel,
  }) : super(key: key);

  @override
  State<HypotheekProfielEigenWoningReservePanel> createState() =>
      HypotheekProfielEigenWoningReservePanelState();
}

class HypotheekProfielEigenWoningReservePanelState
    extends State<HypotheekProfielEigenWoningReservePanel> {
  late HypotheekProfielViewModel nhpm;
  HypotheekProfiel get profiel => nhpm.profiel;

  late final MyNumberFormat nf = MyNumberFormat(context);

  TextEditingController? _tecEigenwoningReserve;

  TextEditingController get tecEigenwoningReserve {
    if (_tecEigenwoningReserve == null) {
      final erw = profiel.eigenReserveWoning.erw;
      _tecEigenwoningReserve =
          TextEditingController(text: erw == 0.0 ? '' : nf.parseDblToText(erw));
    }
    return _tecEigenwoningReserve!;
  }

  FocusNode? _fnEigenWoningReserve;

  FocusNode get fnEigenWoningReserve {
    if (_fnEigenWoningReserve == null) {
      _fnEigenWoningReserve = FocusNode()
        ..addListener(() {
          if (!_fnEigenWoningReserve!.hasFocus) {
            _veranderingEigenWoningReserve(_tecEigenwoningReserve?.text ?? '');
          }
        });
    }
    return _fnEigenWoningReserve!;
  }

  TextEditingController? _tecOorspronkelijkeLening;

  TextEditingController get tecOorspronkelijkeLening {
    if (_tecOorspronkelijkeLening == null) {
      final o = profiel.eigenReserveWoning.oorspronkelijkeHoofdsom;
      _tecOorspronkelijkeLening =
          TextEditingController(text: o == 0.0 ? '' : nf.parseDblToText(o));
    }
    return _tecOorspronkelijkeLening!;
  }

  FocusNode? _fnOorspronkelijkeLening;

  FocusNode get fnOorspronkelijkeLening {
    if (_fnOorspronkelijkeLening == null) {
      _fnOorspronkelijkeLening = FocusNode()
        ..addListener(() {
          if (!_fnOorspronkelijkeLening!.hasFocus) {
            _veranderingOorsprongelijkelLening(
                _tecOorspronkelijkeLening?.text ?? '');
          }
        });
    }
    return _fnOorspronkelijkeLening!;
  }

  @override
  void initState() {
    nhpm = widget.nieuwHypotheekProfielViewModel
      ..eigenWoningReservePanel = this;
    super.initState();
  }

  @override
  void dispose() {
    nhpm.eigenWoningReservePanel = null;
    _tecEigenwoningReserve?.dispose();
    _fnEigenWoningReserve?.dispose();
    _tecOorspronkelijkeLening?.dispose();
    _fnOorspronkelijkeLening?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: AnimatedScaleResizeSwitcher(
            child: profiel.eigenReserveWoning.erwToepassing
                ? _eigenWoningReserve(context)
                : SizedBox.shrink()));
  }

  _eigenWoningReserve(BuildContext context) {
    final theme = Theme.of(context);
    final headline3 = theme.textTheme.headline3;
    final erwBerekenen = profiel.eigenReserveWoning.erwBerekenen;

    final children = [
      Text(
        'Eigenwoningreserve',
        style: headline3,
        textAlign: TextAlign.center,
      ),
      SizedBox(
        height: 24.0,
      ),
      SelectableButtonGroup<bool>(
        groupValue: erwBerekenen,
        selectableItems: [
          SelectableItem<bool>(child: Text('Invullen'), value: false),
          SelectableItem<bool>(child: Text('berekenen'), value: true)
        ],
        onChange: _eigenWoningReserveBerekenen,
      ),
      AnimatedScaleResizeSwitcher(
        child: erwBerekenen
            ? _initieleLeningInvullen()
            : _eigenWoningReserveInvullen(),
      ),
      SizedBox(
        height: 8.0,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Material(
        color: Color.fromARGB(
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

  Widget _initieleLeningInvullen() {
    return Padding(
      key: Key('OorspronkelijkeHoofdsom'),
      padding: const EdgeInsets.symmetric(horizontal: _horizontal),
      child: TextFormField(
        controller: tecOorspronkelijkeLening,
        focusNode: fnOorspronkelijkeLening,
        decoration: InputDecoration(
            hintText: 'bedrag',
            labelText: profiel.doelOverzicht == DoelProfielOverzicht.bestaand
                ? 'Oorspronkelijke lening vorige woning'
                : 'Oorspronkelijke lening'),
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
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
      key: Key('WoningReserve'),
      padding: const EdgeInsets.symmetric(horizontal: _horizontal),
      child: TextFormField(
        controller: tecEigenwoningReserve,
        focusNode: _fnEigenWoningReserve,
        decoration: InputDecoration(
            hintText: 'bedrag', labelText: 'Eigenwoningreserve'),
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
        validator: (String? value) {
          if (nf.parsToDouble(value) < 0.0) {
            return 'Bedrag >= 0.0';
          }
          return null;
        },
      ),
    );
  }

  _eigenWoningReserveBerekenen(bool value) {
    nhpm.eigenWoningReserveBerekenen(value);
  }

  _veranderingEigenWoningReserve(String value) {
    nhpm.veranderingEigenWoningReserve(nf.parsToDouble(value));
  }

  _veranderingOorsprongelijkelLening(String value) {
    nhpm.veranderingEigenWoningReserve(nf.parsToDouble(value));
  }

  updateState() {
    setState(() {});
  }
}

/// Vorige woning
///
///
///
///
///

class HypotheekProfielVorigeWoningPanel extends StatefulWidget {
  final HypotheekProfielViewModel nieuwHypotheekProfielViewModel;

  HypotheekProfielVorigeWoningPanel({
    Key? key,
    required this.nieuwHypotheekProfielViewModel,
  }) : super(key: key);

  @override
  State<HypotheekProfielVorigeWoningPanel> createState() =>
      HypotheekProfielVorigeWoningPanelState();
}

class HypotheekProfielVorigeWoningPanelState
    extends State<HypotheekProfielVorigeWoningPanel> {
  late final MyNumberFormat nf = MyNumberFormat(context);
  late HypotheekProfielViewModel nhpm;
  HypotheekProfiel get profiel => nhpm.profiel;

  late TextEditingController tecWoningWaarde = TextEditingController(
      text: profiel.vorigeWoningGegevens.woningWaarde == 0.0
          ? ''
          : nf.parseDblToText(profiel.vorigeWoningGegevens.woningWaarde));

  late FocusNode fnWoningWaarde = FocusNode()
    ..addListener(() {
      bool f = fnWoningWaarde.hasFocus;
      if (!f) {
        _veranderingWoningwaarde(tecWoningWaarde.text);
      }
    });

  late TextEditingController tecHypotheek = TextEditingController(
      text: profiel.vorigeWoningGegevens.lening == 0.0
          ? ''
          : nf.parseDblToText(profiel.vorigeWoningGegevens.lening));

  late FocusNode fnHypotheek = FocusNode()
    ..addListener(() {
      if (!fnHypotheek.hasFocus) {
        _veranderingHypotheek(tecHypotheek.text);
      }
    });

  late List<SliverBoxItemState<Waarde>> itemList;

  @override
  void initState() {
    nhpm = widget.nieuwHypotheekProfielViewModel..vorigeWoningPanel = this;
    super.initState();

    itemList = profiel.vorigeWoningGegevens.kosten
        .map((Waarde e) => SliverBoxItemState(
            key: e.key, insertRemoveAnimation: 1.0, enabled: true, value: e))
        .toList();
  }

  @override
  void didUpdateWidget(HypotheekProfielVorigeWoningPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool get woningGegevensZichtbaar =>
      (profiel.doelOverzicht == DoelProfielOverzicht.nieuw &&
          profiel.situatie == Situatie.koopwoning) ||
      profiel.eigenReserveWoning.woningGegevens;

  @override
  void dispose() {
    tecWoningWaarde.dispose();
    fnWoningWaarde.dispose();
    tecHypotheek.dispose();
    fnHypotheek.dispose();

    nhpm.vorigeWoningPanel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverRowBox<String, Waarde>(
      heightItem: 72.0,
      visible: woningGegevensZichtbaar,
      visibleAnimated: true,
      itemList: itemList,
      topList: [
        SliverBoxItemState(
            key: 'topPadding',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'topPadding'),
        SliverBoxItemState(
            key: 'woningTitle',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'woningTitle'),
        SliverBoxItemState(
            key: 'woning',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'woning'),
        SliverBoxItemState(
            key: 'lening',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'lening'),
        SliverBoxItemState(
            key: 'kostenTitle',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'kostenTitle'),
      ],
      bottomList: [
        SliverBoxItemState(
            key: 'totaleKosten',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'totaleKosten'),
        SliverBoxItemState(
            key: 'bottom',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'bottom'),
      ],
      buildSliverBoxItem: _buildItem,
      buildSliverBoxTopBottom: _buildTopBottom,
    );
  }

  Widget _buildItem(
      {Animation? animation,
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
              waarde: state.value,
              text: v,
            ),
        waardeAanpassen: (double value) => _veranderingWaarde(
              waarde: state.value,
              value: value,
            ));

    return SliverRowItemBackground(
        key: Key(state.key),
        backgroundColor: Color.fromARGB(255, 244, 254, 251),
        radialTop: 0.0,
        radialbottom: 0.0,
        child: InsertRemoveVisibleAnimatedSliverRowItem(
            state: state, child: child, enableAnimation: animation));
  }

  Widget _buildTopBottom(
      {Animation? animation,
      required int index,
      required int length,
      required SliverBoxItemState<String> state}) {
    switch (state.key) {
      case 'topPadding':
        {
          return SizedBox(
            height: 16.0,
          );
        }
      case 'woningTitle':
        {
          final theme = Theme.of(context);
          final headline3 = theme.textTheme.headline3;

          final child = Center(
              child: Text(
            profiel.doelOverzicht == DoelProfielOverzicht.nieuw &&
                    profiel.situatie != Situatie.geenKoopwoning
                ? 'Huidige Woning'
                : 'Vorige Woning',
            style: headline3,
            textAlign: TextAlign.center,
          ));

          return SliverRowItemBackground(
              radialTop: 32.0,
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 239, 249, 253),
              child: VisibleAnimatedSliverRowItem(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: child,
                ),
                enableAnimation: animation,
              ));
        }
      case 'woning':
        {
          final child = TextFormField(
            controller: tecWoningWaarde,
            focusNode: fnWoningWaarde,
            decoration:
                InputDecoration(hintText: 'Bedrag', labelText: 'Woningwaarde'),
            keyboardType: TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputFormatters: [
              MyNumberFormat(context).numberInputFormat('#.00')
            ],
            validator: (String? value) {
              if (nf.parsToDouble(value) == 0.0) {
                return 'Geen bedrag';
              }
              return null;
            },
          );

          return SliverRowItemBackground(
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 239, 249, 253),
              child: VisibleAnimatedSliverRowItem(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 4.0, right: 16.0, bottom: 2.0),
                  child: child,
                ),
                enableAnimation: animation,
              ));
        }
      case 'kostenTitle':
        {
          {
            final theme = Theme.of(context);
            final headline3 = theme.textTheme.headline3;

            final child = Center(
                child: Text(
              'Kosten',
              style: headline3,
              textAlign: TextAlign.center,
            ));

            return SliverRowItemBackground(
                key: Key(state.key),
                backgroundColor: Color.fromARGB(255, 239, 249, 253),
                child: VisibleAnimatedSliverRowItem(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: child,
                  ),
                  enableAnimation: animation,
                ));
          }
        }

      case 'lening':
        {
          final child = TextFormField(
              key: Key('hypotheekInvullen'),
              controller: tecHypotheek,
              focusNode: fnHypotheek,
              decoration: InputDecoration(
                  hintText: 'Bedrag', labelText: 'Restschuld lening(en)'),
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatters: [
                MyNumberFormat(context).numberInputFormat('#.00')
              ],
              validator: (String? value) {
                if (nf.parsToDouble(value) < 0.0) {
                  return 'Bedrag >= 0.0';
                }
                return null;
              });

          return SliverRowItemBackground(
              radialTop: 0,
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 239, 249, 253),
              child: VisibleAnimatedSliverRowItem(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: child,
                ),
                enableAnimation: animation,
              ));
        }
      case 'bottom':
        {
          return SliverRowItemBackground(
              radialbottom: 32.0,
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 239, 249, 253),
              child: VisibleAnimatedSliverRowItem(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Center(
                      child: ToevoegenKostenButton(pressed: toevoegKostenItem)),
                ),
                enableAnimation: animation,
              ));
        }
      case 'totaleKosten':
        {
          final child = TotaleKostenRowItem(
            backgroundColor: Color.fromARGB(255, 239, 249, 253),
            enableAnimation: animation,
            state: state,
            totaleKosten: profiel.vorigeWoningGegevens.totaleKosten,
          );

          return SliverRowItemBackground(
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 239, 249, 253),
              child: VisibleAnimatedSliverRowItem(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: child,
                ),
                enableAnimation: animation,
              ));
        }
      default:
        {
          return Text(':(');
        }
    }
  }

  toevoegKostenItem() {
    List<Waarde> resterend = [];
    List<Waarde> lijst = profiel.vorigeWoningGegevens.kosten;
    List<Waarde> suggestieLijst =
        WoningLeningKostenGegevens.suggestieKostenVorigeWoning();

    for (Waarde w in suggestieLijst) {
      if (lijst.indexWhere((Waarde aanwezig) => aanwezig.id == w.id) == -1) {
        resterend.add(w);
      }
    }
    resterend.add(leegKosten);

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
    nhpm.veranderingToevoegenKostenVorigeWoning(lijst);
  }

  _veranderingWoningwaarde(String value) {
    nhpm.veranderingWoningWaarde(nf.parsToDouble(value));
  }

  _veranderingHypotheek(String value) {
    nhpm.veranderingHypotheek(nf.parsToDouble(value));
  }

  _veranderingOmschrijving({required Waarde waarde, required String text}) {
    nhpm.veranderingWaardepWoning(waarde: waarde, name: text);
  }

  _veranderingWaarde({required Waarde waarde, required double value}) {
    nhpm.veranderingWaardepWoning(waarde: waarde, value: value);
  }

  _veranderingWaardeOpties(
      {required SliverBoxItemState<Waarde> state,
      required SelectedMenuPopupIdentifierValue<String, dynamic> iv}) {
    switch (iv.identifier) {
      case 'eenheid':
        {
          nhpm.veranderingWaardepWoning(waarde: state.value, eenheid: iv.value);
          break;
        }
      case 'aftrekken':
        {
          nhpm.veranderingWaardepWoning(
              waarde: state.value, aftrekbaar: iv.value);
          break;
        }
      case 'verwijderen':
        {
          nhpm.veranderingVerwijderenKostenVorigeWoning([state.value]);
          state.enabled = false;
          break;
        }
    }
  }

  updateState() {
    setState(() {});
  }
}
