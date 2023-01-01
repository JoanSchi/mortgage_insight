import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/debts/date_picker.dart';
import 'package:mortgage_insight/hypotheek/bewerken/financieringsnorm_tabel.dart';
import 'package:mortgage_insight/hypotheek/bewerken/hypotheek_model.dart';
import 'package:mortgage_insight/hypotheek/bewerken/hypotheek_verleng_card.dart';
import 'package:mortgage_insight/hypotheek/bewerken/overzicht_hypotheek.dart';
import 'package:mortgage_insight/hypotheek/bewerken/overzicht_hypotheek_tabel.dart';
import 'package:mortgage_insight/hypotheek/profiel_bewerken/KostenLijst.dart';
import 'package:mortgage_insight/layout/transition/scale_size_transition.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/my_widgets/header_layout.dart';
import 'package:mortgage_insight/my_widgets/sliver_row_box.dart';
import 'package:mortgage_insight/my_widgets/animated_scale_resize_switcher.dart';
import 'package:mortgage_insight/my_widgets/selectable_button_group.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/state_manager/edit_state.dart';
import 'package:mortgage_insight/utilities/MyNumberFormat.dart';
import '../../model/nl/hypotheek/financierings_norm/norm.dart';
import '../../model/nl/hypotheek/hypotheek.dart';
import '../../model/nl/hypotheek/kosten_hypotheek.dart';
import '../../my_widgets/my_page/my_page.dart';
import '../../my_widgets/selectable_popupmenu.dart';
import '../../state_manager/state_edit_object.dart';
import '../../utilities/device_info.dart';
import 'verdeling_leningen.dart';

const _horizontal = 8.0;

class BewerkHypotheek extends ConsumerStatefulWidget {
  @override
  ConsumerState<BewerkHypotheek> createState() => BewerkHypotheekState();
}

class BewerkHypotheekState extends ConsumerState<BewerkHypotheek> {
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
        title: 'Toevoegen',
        imageName: 'graphics/fit_geldzak.png',
        body: HypotheekBewerkPanel());
  }
}

class HypotheekBewerkPanel extends ConsumerStatefulWidget {
  HypotheekBewerkPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HypotheekBewerkPanelState();
}

class _HypotheekBewerkPanelState extends ConsumerState<HypotheekBewerkPanel> {
  late HypotheekViewModel hypotheekViewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    hypotheekViewModel = ref.read(editObjectProvider).object;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController? controller = PrimaryScrollController.of(context);

    return AcceptCanelPanel(
      accept: () {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          hypotheekViewModel.accept();
          ref
              .read(hypotheekContainerProvider)
              .updateHypotheekProfiel(hypotheekViewModel.profiel);

          ref.read(pageHypotheekProvider).page = 1;

          scheduleMicrotask(() {
            context.pop();
          });
        }
      },
      cancel: () {
        hypotheekViewModel.cancel();
        scheduleMicrotask(() {
          context.pop();
        });
      },
      child: Form(
        key: _formKey,
        child: CustomScrollView(slivers: [
          HypotheekBewerkOmschrijvingToevoegOptie(
            hypotheekViewModel: hypotheekViewModel,
          ),
          HypotheekBewerkDatumVerlengen(
            hypotheekViewModel: hypotheekViewModel,
          ),
          TermijnPeriodePanel(
            hypotheekViewModel: hypotheekViewModel,
          ),
          HypotheekKostenPanel(
            hypotheekViewModel: hypotheekViewModel,
          ),
          VerduurzamenPanel(
            hypotheekViewModel: hypotheekViewModel,
          ),
          LeningPanel(
            hypotheekViewModel: hypotheekViewModel,
          ),
          SpacerFinancieringsTabel(
            hypotheekViewModel: hypotheekViewModel,
          ),
          FinancieringsNormTable(
            controller: controller,
            hypotheekViewModel: hypotheekViewModel,
          ),
          VerdelingLeningen(
            hypotheekViewModel: hypotheekViewModel,
          ),
          OverzichtHypotheek(
            hypotheekViewModel: hypotheekViewModel,
          ),
          OverzichtHypotheekTabel(
              hypotheekViewModel: hypotheekViewModel, controller: controller)
        ]),
      ),
    );
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
  final HypotheekViewModel hypotheekViewModel;

  HypotheekBewerkOmschrijvingToevoegOptie({
    Key? key,
    required this.hypotheekViewModel,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      HypotheekBewerkOmschrijvingToevoegOptieState();
}

class HypotheekBewerkOmschrijvingToevoegOptieState
    extends ConsumerState<HypotheekBewerkOmschrijvingToevoegOptie> {
  late TextEditingController _tecOmschrijving =
      TextEditingController(text: hypotheek.omschrijving);
  late FocusNode _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_tecOmschrijving.text);
      }
    });

  late HypotheekViewModel hvm;

  Hypotheek get hypotheek => hvm.hypotheek;

  HypotheekProfiel get profiel => hvm.profiel;

  @override
  void initState() {
    hvm = widget.hypotheekViewModel
      ..hypotheekBewerkOmschrijvingKeuzeState = this;
    super.initState();
  }

  @override
  void dispose() {
    hvm.hypotheekBewerkOmschrijvingKeuzeState = null;
    _tecOmschrijving.dispose();
    _fnOmschrijving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerline4 = theme.textTheme.headline4;

    List<Widget> children = [
      SizedBox(
        height: 16.0,
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
        child: Text(
          'Hypotheek',
          style: headerline4,
        ),
      ),
    ];

    if (hvm.heeftTeverlengenHypotheken) {
      children.addAll([
        SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: SelectableRadioGroup<OptiesHypotheekToevoegen>(
              selectableRadioItems: [
                SelectableRadioItem(
                    text: 'Nieuw', value: OptiesHypotheekToevoegen.nieuw),
                SelectableRadioItem(
                    text: 'Verlengen',
                    value: OptiesHypotheekToevoegen.verlengen),
              ],
              groupValue: hypotheek.optiesHypotheekToevoegen,
              onChange: _veranderingHypotheekToevoegen),
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
    hvm.veranderingOmschrijving(value);
  }

  _veranderingHypotheekToevoegen(OptiesHypotheekToevoegen? value) {
    if (value == null) return;
    hvm.veranderingHypotheekToevoegen(value);
  }

  void updateState() {
    setState(() {});
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
  final HypotheekViewModel hypotheekViewModel;

  HypotheekBewerkDatumVerlengen({
    Key? key,
    required this.hypotheekViewModel,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      HypotheekBewerkDatumVerlengenState();
}

class HypotheekBewerkDatumVerlengenState
    extends ConsumerState<HypotheekBewerkDatumVerlengen> {
  late HypotheekViewModel hvm;

  Hypotheek get hypotheek => hvm.hypotheek;

  HypotheekProfiel get profiel => hvm.profiel;

  @override
  void initState() {
    hvm = widget.hypotheekViewModel..hypotheekBewerkDatumVerlengenState = this;
    super.initState();
  }

  @override
  void dispose() {
    hvm.hypotheekBewerkDatumVerlengenState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstDate = hvm.eersteKalenderDatum;
    final lastDate = hvm.laatsteKalenderDatum;
    final theme = Theme.of(context);
    final headerline4 = theme.textTheme.headline4;
    Widget vorigeOfDatum;

    if (hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw) {
      vorigeOfDatum = Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontal),
        child: DateWidget(
          date: hypotheek.startDatum,
          firstDate: firstDate,
          lastDate: lastDate,
          changeDate: _veranderingStartDatum,
          saveDate: _veranderingStartDatum,
        ),
      );

      if (hvm.restSchuld.isNotEmpty) {
        vorigeOfDatum = Column(children: [
          vorigeOfDatum,
          SizedBox(
            height: 16.0,
          ),
          Text('Oversluiten', style: headerline4),
          SizedBox(
            height: 8.0,
          ),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;

            final max = 150.0;
            final inner = 6.0;

            final r = 1.0 + ((width - max) / (max + inner)).floorToDouble();

            final w = (width - r * inner + inner) / r;

            return Wrap(
                spacing: 6.0,
                children: hvm.restSchuld.values
                    .map((RestSchuld r) => SizedBox(
                          width: w,
                          height: w / 3.0 * 2.0,
                          child: RestSchuldCard(
                            restSchuld: r,
                            selected: hypotheek.startDatum,
                            changed: _veranderingStartDatum,
                          ),
                        ))
                    .toList());
          })
        ]);
      }
    } else {
      vorigeOfDatum = LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;

        final max = 300.0;
        final inner = 6.0;

        final r = 1.0 + ((width - max) / (max + inner)).floorToDouble();

        final w = (width - r * inner + inner) / r;

        return Wrap(
            spacing: 6.0,
            children: hvm.verlengen
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

    final an = AnimatedScaleResizeSwitcher(
      child: vorigeOfDatum,
    );

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: an,
    ));
  }

  _veranderingStartDatum(DateTime? value) {
    if (value == null) return;
    hvm.veranderingStartDatum(value);
  }

  _veranderingVorigeHypotheek(String? value) {
    hvm.veranderingVorigeHypotheek(value!);
  }

  void updateState() {
    setState(() {});
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
  final HypotheekViewModel hypotheekViewModel;

  TermijnPeriodePanel({
    Key? key,
    required this.hypotheekViewModel,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      TermijnPeriodePanelState();
}

class TermijnPeriodePanelState extends ConsumerState<TermijnPeriodePanel> {
  late final MyNumberFormat nf = MyNumberFormat(context);

  late TextEditingController _tecAflosTermijnInJaren = TextEditingController(
      text: nf.parseIntToText(hypotheek.aflosTermijnInJaren));

  late final FocusNode _fnAflosTermijnInJaren = FocusNode()
    ..addListener(() {
      if (!_fnAflosTermijnInJaren.hasFocus) {
        _veranderenAflosTermijnInJaren(int.parse(_tecAflosTermijnInJaren.text));
      }
    });

  late TextEditingController _tecPeriodeInJaren =
      TextEditingController(text: nf.parseIntToText(hypotheek.periodeInJaren));

  late final FocusNode _fnPeriodeInJaren = FocusNode()
    ..addListener(() {
      if (!_fnPeriodeInJaren.hasFocus) {
        _veranderenPeriodeInJaren(int.parse(_tecPeriodeInJaren.text));
      }
    });
  late HypotheekViewModel hvm;

  Hypotheek get hypotheek => hvm.hypotheek;

  HypotheekProfiel get profiel => hvm.profiel;

  @override
  void initState() {
    hvm = widget.hypotheekViewModel..termijnPeriodeNhgState = this;
    super.initState();
  }

  @override
  void dispose() {
    hvm.termijnPeriodeNhgState = null;

    _tecAflosTermijnInJaren.dispose();
    _fnAflosTermijnInJaren.dispose();
    _tecPeriodeInJaren.dispose();
    _fnPeriodeInJaren.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    children.addAll([
      SizedBox(
        height: 8.0,
      ),
      AnimatedScaleResizeSwitcher(
          child: hypotheek.optiesHypotheekToevoegen ==
                  OptiesHypotheekToevoegen.verlengen
              ? SizedBox.shrink()
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: _horizontal),
                    child: Text('Aflostermijn (jaren)'),
                  ),
                  Row(children: [
                    Expanded(
                      child: _jarenSlider(
                          selectie: hypotheek.aflosTermijnInJaren,
                          max: hvm.bepaaldeMaximaleTermijnInJaren,
                          onChanged: (double? value) {
                            if (value != null) {
                              _veranderenAflosTermijnInJaren(value.toInt());
                            }
                          }),
                    ),
                    SizedBox(
                      width: 50.0,
                      child: TextFormField(
                          controller: _tecAflosTermijnInJaren,
                          focusNode: _fnAflosTermijnInJaren,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText:
                                  '1-${hvm.bepaaldeMaximaleTermijnInJaren}',
                              labelText: 'Termijn'),
                          keyboardType: TextInputType.numberWithOptions(
                            signed: true,
                            decimal: false,
                          ),
                          inputFormatters: [
                            MyNumberFormat(context).numberInputFormat('#0')
                          ],
                          textInputAction: TextInputAction.next),
                    ),
                    SizedBox(
                      width: 16.0,
                    )
                  ]),
                  SizedBox(
                    height: 8.0,
                  ),
                ])),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontal),
        child: Text('Rentevaste periode (jaren)'),
      ),
      Row(children: [
        Expanded(
          child: _jarenSlider(
              selectie: hypotheek.periodeInJaren,
              max: hypotheek.aflosTermijnInJaren,
              onChanged: (double? value) {
                if (value != null) {
                  _veranderenPeriodeInJaren(value.toInt());
                }
              }),
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
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: false,
              ),
              inputFormatters: [
                MyNumberFormat(context).numberInputFormat('#0')
              ],
              textInputAction: TextInputAction.next),
        ),
        SizedBox(
          width: 16.0,
        )
      ]),
      SizedBox(
        height: 4.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontal),
        child: UndefinedSelectableGroup(
          children: [
            AnimatedScaleResizeSwitcher(
                child: hypotheek.afgesloten
                    ? SizedBox.shrink()
                    : SelectableCheck(
                        selectableItems: SelectableCheckItem(
                            text: 'Nationale hypotheek garantie (NHG)',
                            value: hypotheek.maxLeningNHG.toepassen,
                            changeChecked: _veranderingNHG))),
          ],
        ),
      )
    ]);

    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ));
  }

  Widget _jarenSlider(
      {required int selectie,
      required int max,
      required ValueChanged<double>? onChanged}) {
    return Slider(
        min: 1.0,
        max: max.toDouble(),
        value: selectie.toDouble(),
        divisions: max - 1 < 1 ? 1 : max - 1,
        onChanged: onChanged);
  }

  _veranderenAflosTermijnInJaren(int value) {
    int max = hvm.bepaaldeMaximaleTermijnInJaren;
    if (value < 1) {
      value = 1;
      _tecAflosTermijnInJaren.text = '1';
    } else if (value > max) {
      value = max;
      _tecAflosTermijnInJaren.text = max.toString();
    }
    hvm.veranderenAflostermijnInJaren(value);
  }

  _veranderenPeriodeInJaren(int value) {
    int max = hypotheek.aflosTermijnInJaren;
    if (value < 1) {
      value = 1;
      _tecPeriodeInJaren.text = '1';
    } else if (value > max) {
      value = max;
      _tecPeriodeInJaren.text = max.toString();
    }
    hvm.veranderenPeriodeInJaren(value);
  }

  _veranderingNHG(bool? value) {
    hvm.veranderingNHG(value!);
  }

  void updateState() {
    setState(() {});
  }

  setTermijnInJaren(int value) {
    _tecAflosTermijnInJaren.text = value.toString();
  }

  setPeriodeInJaren(int value) {
    _tecPeriodeInJaren.text = value.toString();
  }
}

/// Verduurzamen
///
///
///
///
///
///

class VerduurzamenPanel extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;

  VerduurzamenPanel({
    Key? key,
    required this.hypotheekViewModel,
  }) : super(key: key);

  @override
  State<VerduurzamenPanel> createState() => VerduurzamenPanelState();
}

class VerduurzamenPanelState extends State<VerduurzamenPanel>
    with SingleTickerProviderStateMixin {
  late final MyNumberFormat nf = MyNumberFormat(context);
  late HypotheekViewModel hvm;

  Hypotheek get hypotheek => hvm.hypotheek;

  HypotheekProfiel get profiel => hvm.profiel;

  late List<SliverBoxItemState<Waarde>> sliverBoxList;

  TextEditingController? _tecTaxatie;

  TextEditingController get tecTaxatie {
    if (_tecTaxatie == null) {
      _tecTaxatie = TextEditingController(
          text: nf.parseDblToText(hypotheek.verbouwVerduurzaamKosten.taxatie,
              format: '#.00'));
    }
    return _tecTaxatie!;
  }

  FocusNode? _fnTaxatie;

  FocusNode get fnTaxatie {
    if (_fnTaxatie == null) {
      _fnTaxatie = FocusNode()
        ..addListener(() {
          if (!_fnTaxatie!.hasFocus) {
            _veranderingTaxatie(nf.parsToDouble(tecTaxatie.text));
          }
        });
    }
    return _fnTaxatie!;
  }

  late AnimationController _animationController = AnimationController(
      value: zichtbaar ? 1.0 : 0.0,
      vsync: this,
      duration: Duration(milliseconds: 300));

  late Animation _animation =
      CurveTween(curve: Curves.bounceInOut).animate(_animationController);

  @override
  void initState() {
    hvm = widget.hypotheekViewModel..verduurzamenPanelState = this;

    sliverBoxList = hypotheek.verbouwVerduurzaamKosten.kosten
        .map<SliverBoxItemState<Waarde>>((Waarde e) => SliverBoxItemState(
            key: e.key, insertRemoveAnimation: 1.0, enabled: true, value: e))
        .toList();

    super.initState();
  }

  @override
  void dispose() {
    hvm.verduurzamenPanelState = null;
    _tecTaxatie?.dispose();
    _fnTaxatie?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool get zichtbaar =>
      hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw &&
      !hypotheek.afgesloten;

  @override
  Widget build(BuildContext context) {
    return SliverRowBox<String, Waarde>(
      heightItem: 72.0,
      visible: zichtbaar && hypotheek.verbouwVerduurzaamKosten.toepassen,
      visibleAnimated: true,
      itemList: sliverBoxList,
      topList: [
        SliverBoxItemState(
            key: 'topPadding',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'topPadding'),
        SliverBoxItemState(
            key: 'title',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: 'title'),
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
        button: (SliverBoxItemState<Waarde> state) =>
            VerbouwenVerduurzamenKostenMenu(
              aanpassenWaarde:
                  (SelectedMenuPopupIdentifierValue<String, dynamic> v) =>
                      _aanpassenWaardeOpties(state: state, iv: v),
              waarde: state.value,
            ),
        omschrijvingAanpassen: (String v) => _veranderingOmschrijving(
              waarde: state.value,
              tekst: v,
            ),
        waardeAanpassen: (double value) => _veranderingWaarde(
              waarde: state.value,
              value: value,
            ));

    if ((index == 0 &&
        animation != null &&
        !hypotheek.verbouwVerduurzaamKosten.toepassen)) {
      return AnimatedBuilder(
          key: Key(state.key),
          animation: animation,
          builder: (BuildContext context, Widget? child) =>
              SliverRowItemBackground(
                  key: Key(state.key),
                  backgroundColor: Color.fromARGB(255, 244, 254, 251),
                  radialTop: 32.0 * (1.0 - animation.value),
                  child: child!),
          child: InsertRemoveVisibleAnimatedSliverRowItem(
              state: state, child: child, enableAnimation: animation));
    } else {
      return SliverRowItemBackground(
          key: Key(state.key),
          backgroundColor: Color.fromARGB(255, 244, 254, 251),
          radialTop: 0.0,
          radialbottom: 0.0,
          child: InsertRemoveVisibleAnimatedSliverRowItem(
              state: state, child: child, enableAnimation: animation));
    }
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
      case 'title':
        {
          final theme = Theme.of(context);
          final headline3 = theme.textTheme.headline3;

          Widget child = Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 16.0, right: 8.0, bottom: 16.0),
              child: HeaderLayout(children: [
                HeaderLayoutDataWidget(
                    id: HeaderLayoutID.title,
                    child: Text(
                      softWrap: true,
                      'Verbouwen / Verduurzamen',
                      style: headline3,
                      textAlign: TextAlign.center,
                    )),
                HeaderLayoutDataWidget(
                    id: HeaderLayoutID.right,
                    child: Switch(
                      value: hypotheek.verbouwVerduurzaamKosten.toepassen,
                      onChanged: _veranderingVerduurzamenToepassen,
                    )),
              ]));

          final a = animation;

          return a == null
              ? child
              : AnimatedBuilder(
                  animation: a,
                  child: child,
                  builder: (BuildContext context, Widget? child) =>
                      SliverRowItemBackground(
                          radialTop: 32.0,
                          radialbottom:
                              hypotheek.verbouwVerduurzaamKosten.toepassen
                                  ? 0.0
                                  : 32.0 * (1.0 - a.value),
                          key: Key(state.key),
                          backgroundColor: Color.fromARGB(255, 244, 254, 251),
                          child: AnimatedBuilder(
                              animation: _animation,
                              child: child,
                              builder: (BuildContext context, Widget? child) =>
                                  _animation.value == 0.0
                                      ? SizedBox.shrink()
                                      : ScaleResized(
                                          scale: _animation.value,
                                          child: child))),
                );
        }

      case 'bottom':
        {
          final child = Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ToevoegenKostenButton(
                    icon: Icon(Icons.list),
                    color: const Color(0XFFBABD42),
                    roundedRight: 0.0,
                    pressed: toevoegenVerduurzaamKosten),
                const SizedBox(
                  width: 1.0,
                ),
                ToevoegenKostenButton(
                    roundedLeft: 0.0, pressed: toevoegenVerduurzaamKosten)
              ]),
              AnimatedScaleResizeSwitcher(
                child: hypotheek.verbouwVerduurzaamKosten.totaleKosten == 0.0
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 16.0),
                        child: TextFormField(
                            controller: _tecTaxatie,
                            focusNode: _fnTaxatie,
                            decoration: InputDecoration(
                                hintText: 'Wonigwaarde na verb./verd.',
                                labelText: 'Taxatie'),
                            keyboardType: TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            ),
                            inputFormatters: [
                              MyNumberFormat(context).numberInputFormat('#')
                            ],
                            textInputAction: TextInputAction.done),
                      ),
              ),
            ],
          );

          return SliverRowItemBackground(
              radialbottom: 32.0,
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 244, 254, 251),
              child: VisibleAnimatedSliverRowItem(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: child,
                ),
                enableAnimation: animation,
              ));
        }
      case 'totaleKosten':
        {
          final child = TotaleKostenRowItem(
            backgroundColor: Color.fromARGB(255, 244, 254, 251),
            enableAnimation: animation,
            state: state,
            totaleKosten: hypotheek.verbouwVerduurzaamKosten.totaleKosten,
          );

          return SliverRowItemBackground(
              key: Key(state.key),
              backgroundColor: Color.fromARGB(255, 244, 254, 251),
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

  toevoegenVerduurzaamKosten() {
    List<Waarde> resterend = [];
    List<Waarde> lijst = hypotheek.verbouwVerduurzaamKosten.kosten;
    List<Waarde> suggestieLijst =
        VerbouwVerduurzaamKosten.suggestieVerduurzamen;

    for (Waarde w in suggestieLijst) {
      if (lijst.indexWhere((Waarde aanwezig) => aanwezig.id == w.id) == -1) {
        resterend.add(w);
      }
    }
    resterend.addAll(VerbouwVerduurzaamKosten.leegVerduurzamen);

    if (resterend.length == 1) {
      _toevoegenWaardes(resterend);
    } else {
      showKosten(
              context: context,
              lijst: resterend,
              image: Image.asset('graphics/plant_groei.png'),
              title: 'Kosten')
          .then((List<Waarde>? value) {
        if (value != null && value.isNotEmpty) {
          _toevoegenWaardes(value);
        }
      });
    }
  }

  _toevoegenWaardes(List<Waarde> lijst) {
    hvm.veranderingVerduurzamenToevoegen(lijst);
  }

  _veranderingVerduurzamenToepassen(bool? value) {
    hvm.veranderingVerduurzamenToepassen(value!);
  }

  _veranderingOmschrijving({required Waarde waarde, required String tekst}) {
    hvm.veranderingKosten(waarde: waarde, name: tekst);
  }

  _veranderingWaarde({required Waarde waarde, required double value}) {
    hvm.veranderingKosten(waarde: waarde, value: value);
  }

  _aanpassenWaardeOpties(
      {required SliverBoxItemState<Waarde> state,
      required SelectedMenuPopupIdentifierValue iv}) {
    switch (iv.identifier) {
      case 'verduurzamen':
        {
          hvm.veranderingVerduurzamen(
              waarde: state.value, verduurzamen: iv.value);
          break;
        }
      case 'verwijderen':
        {
          hvm.veranderingVerduurzamenVerwijderen([state.value]);
          state.enabled = false;
          break;
        }
    }
  }

  _veranderingTaxatie(double value) {
    hvm.veranderingTaxatie(value);
  }

  void updateState() {
    if (zichtbaar && !_animation.isCompleted) {
      _animationController.forward();
    } else if (!zichtbaar && !_animation.isDismissed) {
      _animationController.reverse();
    }
    setState(() {});
  }
}

/* Lenning
 *
 *
 *
 * 
 *
 *
 */

class LeningPanel extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;

  LeningPanel({Key? key, required this.hypotheekViewModel}) : super(key: key);

  @override
  State<LeningPanel> createState() => LeningPanelState();
}

class LeningPanelState extends State<LeningPanel> {
  late HypotheekViewModel hvm;
  late final MyNumberFormat nf = MyNumberFormat(context);

  late TextEditingController _tecRente = TextEditingController(
      text: hypotheek.rente == 0.0 ? '' : nf.parseDblToText(hypotheek.rente));

  late final FocusNode _fnRente = FocusNode()
    ..addListener(() {
      if (!_fnRente.hasFocus) {
        _veranderingRente(_tecRente.text);
      }
    });

  late TextEditingController _tecLening = TextEditingController(
      text: hypotheek.gewensteLening == 0
          ? ''
          : nf.parseDblToText(hypotheek.gewensteLening));

  bool focusLening = false;
  late final FocusNode _fnLening = FocusNode()
    ..addListener(() {
      if (_fnLening.hasFocus) {
        focusLening = true;
      } else if (!_fnLening.hasFocus && focusLening) {
        _veranderingLening(_tecLening.text);
        focusLening = false;
      }
    });

  Hypotheek get hypotheek => hvm.hypotheek;

  HypotheekProfiel get profiel => hvm.profiel;

  @override
  void initState() {
    hvm = widget.hypotheekViewModel..leningPanelState = this;
    super.initState();
  }

  @override
  void dispose() {
    hvm.leningPanelState = null;
    _tecLening.dispose();
    _fnLening.dispose();
    _tecRente.dispose();
    _fnRente.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerTextStyle = theme.textTheme.headline4;
    Widget leningWidget;

    switch (hypotheek.optiesHypotheekToevoegen) {
      case OptiesHypotheekToevoegen.nieuw:
        leningWidget =
            hvm.isBestaandeHypotheek || !hypotheek.maxLening.toepassen
                ? _bestaandeLening(context)
                : _nieuwLening(context);
        break;
      case OptiesHypotheekToevoegen.verlengen:
        leningWidget = _verlengenLening(context);
        break;
    }

    List<Widget> children = [
      SizedBox(
        height: 16.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: _horizontal),
        child: Text(
          'Hypotheekvorm',
          style: headerTextStyle,
        ),
      ),
      SizedBox(
        height: 8.0,
      ),
      _vorm(),
      AnimatedScaleResizeSwitcher(
        child: leningWidget,
      )
    ];

    return SliverToBoxAdapter(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ));
  }

  _nieuwLening(BuildContext context) {
    return Column(
      key: Key('NieuwLening'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _renteField(),
        ),
        SizedBox(
          height: 8.0,
        ),
        PinkLeningInfo(profiel: profiel, hypotheek: hypotheek),
        Row(
          children: [
            SizedBox(
              width: _horizontal,
            ),
            Expanded(child: _leningField()),
            TextButton(
                child: Text('Max'),
                onPressed: () => _veranderingMaxLening(100.0)),
            SizedBox(
              width: _horizontal,
            ),
          ],
        )
      ],
    );
  }

  _bestaandeLening(context) {
    final firstDate = hypotheek.startDatum;
    final lastDate = hvm.eindDatumDeelsAfgelosteLening();

    Widget dateWidget = hypotheek.deelsAfgelosteLening
        ? DateWidget(
            date: hypotheek.datumDeelsAfgelosteLening,
            firstDate: firstDate,
            lastDate: lastDate,
            saveDate: _veranderingDatumDeelsAfgelosteLening)
        : SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (firstDate.compareTo(lastDate) < 0)
            SelectableCheckGroup(
              selectableItems: [
                SelectableCheckItem(
                    text: 'Deels afgeloste lening invullen',
                    value: hypotheek.deelsAfgelosteLening,
                    changeChecked: _veranderingDeelsAfgelost)
              ],
            ),
          AnimatedScaleResizeSwitcher(child: dateWidget),
          Row(
            children: [
              Expanded(child: _leningField()),
              SizedBox(
                width: 16.0,
              ),
              SizedBox(
                width: 80.0,
                child: _renteField(),
              )
            ],
          ),
        ],
      ),
    );
  }

  _verlengenLening(BuildContext context) {
    return Column(
      key: Key('verlengenLening'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontal),
          child: _renteField(),
        ),
        SizedBox(
          height: 8.0,
        ),
        PinkLeningInfo(profiel: profiel, hypotheek: hypotheek),
      ],
    );
  }

  Widget _vorm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontal),
      child: UndefinedSelectableGroup(
        children: [
          SelectedRadioBox<HypotheekVorm>(
              text: 'Annuïteit',
              value: HypotheekVorm.Annuity,
              groupValue: hypotheek.hypotheekvorm,
              onChange: _veranderingHypotheekvorm),
          SelectedRadioBox<HypotheekVorm>(
              text: 'Lineair',
              value: HypotheekVorm.Linear,
              groupValue: hypotheek.hypotheekvorm,
              onChange: _veranderingHypotheekvorm),
          AnimatedScaleResizeSwitcher(
            child: hypotheek.maxLeningNHG.toepassen
                ? SizedBox.shrink()
                : SelectedRadioBox<HypotheekVorm>(
                    text: 'Aflosvrij',
                    value: HypotheekVorm.Aflosvrij,
                    groupValue: hypotheek.hypotheekvorm,
                    onChange: _veranderingHypotheekvorm),
          ),
        ],
      ),
    );
  }

  Widget _renteField() {
    return TextFormField(
        controller: _tecRente,
        focusNode: _fnRente,
        onSaved: _veranderingRente,
        validator: (String? value) {
          double rente = value == null ? 0.0 : nf.parsToDouble(value);
          return (rente < 0.0 || rente > 10) ? '0-10%' : null;
        },
        decoration: new InputDecoration(hintText: '%', labelText: 'Rente (%)'),
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
        textInputAction: TextInputAction.done);
  }

  Widget _leningField() {
    return TextFormField(
        onSaved: _veranderingLening,
        validator: (String? value) =>
            (value != null && nf.parsToDouble(value) == 0.0) ? '> 0.0' : null,
        controller: _tecLening,
        focusNode: _fnLening,
        decoration: InputDecoration(hintText: 'Bedrag', labelText: 'Lening'),
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        inputFormatters: [MyNumberFormat(context).numberInputFormat('#.00')],
        textInputAction: TextInputAction.done);
  }

  _veranderingHypotheekvorm(HypotheekVorm? value) {
    if (value == null) return;
    hvm.veranderingHypotheekvorm(value);
  }

  _veranderingRente(String? value) {
    if (value == null) return;
    hvm.veranderingRente(nf.parsToDouble(value));
  }

  _veranderingLening(String? value) {
    if (value == null) return;
    hvm.veranderingLening(nf.parsToDouble(value));
  }

  setLening(double value) {
    if ((nf.parsToDouble(_tecLening.text) - value).abs() > 0.009) {
      _tecLening.text = nf.parseDblToText(value);
    }
  }

  _veranderingMaxLening(double value) {
    hvm.veranderingMaximaleLening(value);
  }

  _veranderingDeelsAfgelost(bool? value) {
    hvm.veranderingDeelsAfgelost(value!);
  }

  _veranderingDatumDeelsAfgelosteLening(DateTime value) {
    hvm.veranderingDatumDeelsAfgelosteLening(value);
  }

  void updateState() {
    setState(() {});
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

class HypotheekKostenPanel extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;

  HypotheekKostenPanel({
    Key? key,
    required this.hypotheekViewModel,
  }) : super(key: key);

  @override
  State<HypotheekKostenPanel> createState() => HypotheekKostenPanelState();
}

class HypotheekKostenPanelState extends State<HypotheekKostenPanel> {
  late final MyNumberFormat nf = MyNumberFormat(context);
  late HypotheekViewModel hvm;

  Hypotheek get hypotheek => hvm.hypotheek;
  HypotheekProfiel get profiel => hvm.profiel;

  late TextEditingController _tecWoningWaarde = TextEditingController(
      text: hypotheek.woningLeningKosten.woningWaarde == 0.0
          ? ''
          : nf.parseDblToText(hypotheek.woningLeningKosten.woningWaarde));

  late FocusNode _fnWoningWaarde = FocusNode()
    ..addListener(() {
      if (!_fnWoningWaarde.hasFocus) {
        _veranderingWoningwaardeWoning(_tecWoningWaarde.text);
      }
    });

  late List<SliverBoxItemState<Waarde>> sliverBoxList;

  @override
  void initState() {
    hvm = widget.hypotheekViewModel..hypotheekKostenPanelState = this;

    sliverBoxList = hypotheek.woningLeningKosten.kosten
        .map((Waarde e) => SliverBoxItemState<Waarde>(
            key: '${e.id}_${e.index}',
            insertRemoveAnimation: 1.0,
            enabled: true,
            value: e))
        .toList();

    super.initState();
  }

  @override
  void dispose() {
    _tecWoningWaarde.dispose();
    _fnWoningWaarde.dispose();
    hvm.hypotheekKostenPanelState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverRowBox<String, Waarde>(
      heightItem: 72.0,
      visible: true,
      visibleAnimated: false,
      itemList: sliverBoxList,
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
        backgroundColor: Color.fromARGB(255, 239, 249, 253),
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
            'Woning',
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
            controller: _tecWoningWaarde,
            focusNode: _fnWoningWaarde,
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
              if (profiel.woningWaardeNormToepassen &&
                  nf.parsToDouble(value) == 0.0) {
                return 'Geen bedrag > 0';
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
                    padding: const EdgeInsets.only(top: 16.0),
                    child: child,
                  ),
                  enableAnimation: animation,
                ));
          }
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
            totaleKosten: hypotheek.woningLeningKosten.totaleKosten,
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
    List<Waarde> lijst = hypotheek.woningLeningKosten.kosten;
    List<Waarde> suggestieLijst = WoningLeningKostenGegevens.suggestieKosten(
        overdrachtBelasting: hvm.suggestieOverdrachtBelasting,
        nhg: hypotheek.maxLeningNHG.toepassen);

    List<Waarde> resterend = [];

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
    hvm.veranderingKostenToevoegen(lijst);
  }

  _veranderingWoningwaardeWoning(String? value) {
    hvm.veranderingWoningwaardeWoning(nf.parsToDouble(value));
  }

  _veranderingOmschrijving({required Waarde waarde, required String text}) {
    hvm.veranderingKosten(waarde: waarde, name: text);
  }

  _veranderingWaarde({required Waarde waarde, required double value}) {
    hvm.veranderingKosten(waarde: waarde, value: value);
  }

  _veranderingWaardeOpties(
      {required SliverBoxItemState<Waarde> state,
      required SelectedMenuPopupIdentifierValue<String, dynamic> iv}) {
    switch (iv.identifier) {
      case 'eenheid':
        {
          hvm.veranderingKosten(waarde: state.value, eenheid: iv.value);
          break;
        }
      case 'aftrekken':
        {
          hvm.veranderingKosten(waarde: state.value, aftrekbaar: iv.value);
          break;
        }
      case 'verwijderen':
        {
          hvm.veranderingKostenVerwijderen([state.value]);
          state.enabled = false;
          break;
        }
    }
  }

  void updateState() {
    setState(() {});
  }
}

class PinkLeningInfo extends StatelessWidget {
  final HypotheekProfiel profiel;
  final Hypotheek hypotheek;

  const PinkLeningInfo(
      {Key? key, required this.profiel, required this.hypotheek})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nf = MyNumberFormat(context);

    List<Widget> errorMessage = [];

    void foutMeldingToevoegen(Norm norm) {
      if (norm.fouten.isNotEmpty) {
        errorMessage.addAll(norm.fouten.map((String fout) => Text(fout,
            style: theme.textTheme.bodyText2
                ?.copyWith(color: Color.fromARGB(255, 159, 24, 14)))));
      }
    }

    foutMeldingToevoegen(hypotheek.maxLeningInkomen);
    foutMeldingToevoegen(hypotheek.maxLeningWoningWaarde);

    final maxLening = hypotheek.maxLening;

    Widget child;

    if (maxLening.toepassen && maxLening.fouten.isEmpty) {
      final m = DefaultTextStyle(
          style: theme.textTheme.bodyText2!
              .copyWith(color: Colors.brown[900], fontSize: 18.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Maximale Lening:'),
            Text(
              nf.parseDoubleToText(maxLening.resterend, '#0'),
              textScaleFactor: 2.0,
            )
          ]));

      child = Stack(children: [
        Positioned(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: m),
        if (errorMessage.isNotEmpty)
          Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 0.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Color.fromARGB(255, 159, 24, 14)),
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min, children: errorMessage),
                ],
              ))
      ]);
    } else {
      child = Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Color.fromARGB(255, 159, 24, 14),
                size: 128.0,
              ),
              ...errorMessage
            ]),
      );
    }

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (hypotheek.rente == 0.0)
            ? SizedBox.shrink()
            : Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                color: Color.fromARGB(
                    255, 255, 231, 229), //Color.fromARGB(255, 253, 227, 56),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 200,
                    child: child,
                  ),
                )));
  }
}
