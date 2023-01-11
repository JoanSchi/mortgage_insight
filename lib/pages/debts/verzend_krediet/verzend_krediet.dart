import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/pages/debts/verzend_krediet/verzend_krediet_model.dart';
import 'package:mortgage_insight/pages/debts/verzend_krediet/verzend_krediet_overview.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_verzend_krediet.dart';
import 'package:mortgage_insight/template_mortgage_items/AcceptCancelActions.dart';
import '../../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../my_widgets/simple_widgets.dart';
import '../../../utilities/Kalender.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../date_picker.dart';
import 'package:go_router/go_router.dart';

class VerzendKredietPanel extends ConsumerStatefulWidget {
  final VerzendhuisKrediet verzendHuisKrediet;
  final MessageListener<AcceptCancelBackMessage> messageListener;

  const VerzendKredietPanel({
    Key? key,
    required this.verzendHuisKrediet,
    required this.messageListener,
  }) : super(key: key);

  @override
  ConsumerState<VerzendKredietPanel> createState() =>
      _VerzendKredietPanelState();
}

class _VerzendKredietPanelState extends ConsumerState<VerzendKredietPanel> {
  late VerzendhuisKredietModel verzendhuisKredietModel =
      verzendhuisKredietModel =
          VerzendhuisKredietModel(vk: widget.verzendHuisKrediet);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(VerzendKredietPanel oldWidget) {
    if (widget.verzendHuisKrediet != oldWidget.verzendHuisKrediet) {
      verzendhuisKredietModel.dispose();
      verzendhuisKredietModel =
          VerzendhuisKredietModel(vk: widget.verzendHuisKrediet);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MessageListenerWidget(
      listener: widget.messageListener,
      onMessage: (AcceptCancelBackMessage message) {
        switch (message.msg) {
          case AcceptCancelBack.accept:
            FocusScope.of(context).unfocus();

            scheduleMicrotask(() {
              if ((_formKey.currentState?.validate() ?? false) &&
                  widget.verzendHuisKrediet.berekend == Calculated.yes) {
                ref
                    .read(hypotheekContainerProvider.notifier)
                    .addSchuld(widget.verzendHuisKrediet);
                scheduleMicrotask(() {
                  //didpop sets editState of routeEditPageProvider.notifier to null;
                  context.pop();
                });
              }
            });

            break;
          case AcceptCancelBack.cancel:
            //didpop sets editState of routeEditPageProvider.notifier to null;
            context.pop();

            break;
          default:
            break;
        }
      },
      child: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            VerzendKredietOptiePanel(
                verzendhuisKredietModel: verzendhuisKredietModel),
            OverzichtVerzendHuisKrediet(
                verzendhuisKredietModel: verzendhuisKredietModel)
          ],
        ),
      ),
    );
  }
}

class VerzendKredietOptiePanel extends StatefulWidget {
  final VerzendhuisKredietModel verzendhuisKredietModel;

  VerzendKredietOptiePanel({Key? key, required this.verzendhuisKredietModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => VerzendKredietOptiePanelState();
}

class VerzendKredietOptiePanelState extends State<VerzendKredietOptiePanel>
    with TickerProviderStateMixin {
  late VerzendhuisKredietModel verzendhuisKredietModel =
      widget.verzendhuisKredietModel..verzendKredietOptiePanelState = this;

  VerzendhuisKrediet get vk => verzendhuisKredietModel.vk;

  late MyNumberFormat nf = MyNumberFormat(context);

  late TextEditingController _tecOmschrijving =
      TextEditingController(text: vk.omschrijving);

  late TextEditingController _tecMaanden =
      TextEditingController(text: vk.maanden.toString());

  late TextEditingController _tecBedrag = TextEditingController(
      text: vk.totaalBedrag == 0.0
          ? ''
          : nf.parseDoubleToText(vk.totaalBedrag, '#0.00'));

  late TextEditingController _tecSlottermijn = TextEditingController(
      text: vk.slotTermijn == 0.0
          ? ''
          : nf.parseDoubleToText(vk.slotTermijn, '#0.00'));

  late FocusNode _fnMaanden = FocusNode()
    ..addListener(() {
      if (!_fnMaanden.hasFocus) {
        _veranderingMaandenFromText(_tecMaanden.text);
      }
    });
  late FocusNode _fnBedrag = FocusNode()
    ..addListener(() {
      if (!_fnBedrag.hasFocus) {
        _veranderingBedrag(_tecBedrag.text);
      }
    });
  late FocusNode _fnSlottermijn = FocusNode()
    ..addListener(() {
      if (!_fnSlottermijn.hasFocus) {
        _veranderingSlottermijn(_tecSlottermijn.text);
      }
    });
  late FocusNode _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_tecOmschrijving.text);
      }
    });

  late AnimationController _slottermijnCheckboxAnimationController =
      AnimationController(
          value: !vk.isTotalbedrag ? 1 : 0,
          vsync: this,
          duration: const Duration(milliseconds: 200));

  late AnimationController _slottermijnEditTextAnimationController =
      AnimationController(
          value: _slottermijnEditboxvisible ? 1.0 : 0.0,
          vsync: this,
          duration: const Duration(milliseconds: 200))
        ..addListener(() {
          final status = _slottermijnEditTextAnimationController.status;

          if (status == AnimationStatus.dismissed &&
              _slottermijnEditboxvisible) {
            setState(() {});
          }
          if (status != AnimationStatus.dismissed &&
              !_slottermijnEditboxvisible) {
            setState(() {});
          }
        });

  late AnimationController _afrondenAnimationController = AnimationController(
    value: vk.isTotalbedrag ? 1.0 : 0.0,
    vsync: this,
    duration: Duration(milliseconds: 200),
  );
  bool get _slottermijnEditboxvisible =>
      !vk.isTotalbedrag && vk.heeftSlotTermijn;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(VerzendKredietOptiePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _fnOmschrijving.dispose();
    _tecMaanden.dispose();
    _fnMaanden.dispose();
    _tecBedrag.dispose();
    _fnBedrag.dispose();
    _tecSlottermijn.dispose();
    _fnSlottermijn.dispose();
    _slottermijnCheckboxAnimationController.dispose();
    _slottermijnEditTextAnimationController.dispose();
    _afrondenAnimationController.dispose();
    verzendhuisKredietModel.verzendKredietOptiePanelState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year - 3, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    Widget avatar(String text, bool selected) => CircleAvatar(
          backgroundColor:
              selected ? theme.colorScheme.onSecondary : Colors.blueGrey[50],
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 8.0, color: selected ? Colors.white : null),
          ),
        );

    final List<Widget> bedragen = [
      Expanded(
        child: TextFormField(
            controller: _tecBedrag,
            keyboardType: TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputFormatters: [nf.numberInputFormat('#0.00')],
            focusNode: _fnBedrag,
            decoration: new InputDecoration(
                hintText: '',
                labelText: vk.isTotalbedrag ? 'Totaal' : 'Termijn'),
            validator: (String? text) {
              if (text == null || text.isEmpty || nf.parsToDouble(text) < 1) {
                return '> 1';
              }
              return null;
            },
            onSaved: (String? text) {
              if (_fnBedrag.hasFocus) {
                _veranderingBedrag(text);
              }
            },
            textInputAction: TextInputAction.next),
      ),
    ];

    if (_slottermijnEditboxvisible) {
      bedragen.addAll([
        SizedBox(
          width: 16.0,
        ),
        SizeTransition(
          sizeFactor: _slottermijnEditTextAnimationController,
          axis: Axis.horizontal,
          child: SizedBox(
              width: 90.0,
              child: TextFormField(
                controller: _tecSlottermijn,
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  MyNumberFormat(context).numberInputFormat('#0.00')
                ],
                focusNode: _fnSlottermijn,
                decoration:
                    new InputDecoration(hintText: '', labelText: 'Slottermijn'),
                validator: (text) {
                  if (text == null ||
                      text.isEmpty ||
                      (nf.parsToDouble(text) <= 0)) {
                    return '>= 0';
                  }
                  return null;
                },
                onSaved: (text) {
                  if (_fnSlottermijn.hasFocus) {
                    _veranderingSlottermijn(text);
                  }
                },
              )),
        )
      ]);
    }

    List<Widget> columnChildren = [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: OmschrijvingTextField(
          focusNode: _fnOmschrijving,
          textEditingController: _tecOmschrijving,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: DateWidget(
          date: vk.beginDatum,
          firstDate: firstDate,
          lastDate: lastDate,
          saveDate: (DateTime? date) {
            _veranderingDatum(date);
          },
          changeDate: (DateTime? date) {
            _veranderingDatum(date);
          },
        ),
      ),
      SizedBox(
        height: 8.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RadioSimpel<bool>(
            title: 'Totaalbedrag',
            value: true,
            groupValue: vk.isTotalbedrag,
            onChanged: (bool? value) {
              _veranderingBedragPerMaandOfTotaal(value);
            }),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RadioSimpel<bool>(
            title: 'Termijnbedrag per maand',
            value: false,
            groupValue: vk.isTotalbedrag,
            onChanged: _veranderingBedragPerMaandOfTotaal),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 56.0, right: 16.0),
        child: SizeTransition(
          sizeFactor: _slottermijnCheckboxAnimationController,
          child: CheckboxSimpel(
              title: 'Slottermijn',
              value: vk.heeftSlotTermijn,
              onChanged:
                  !vk.isTotalbedrag ? veranderingSlotTermijnOptie : null),
        ),
      ),
      SizeTransition(
        sizeFactor: _afrondenAnimationController,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Termijnbedrag afronden op:',
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(spacing: 8.0, children: [
                ChoiceChip(
                  key: Key('euros'),
                  avatar: avatar('#0', vk.decimalen == 0),
                  label: Text('Euro\'s'),
                  selected: vk.decimalen == 0,
                  onSelected: (v) {
                    _veranderingAfronden(0);
                  },
                ),
                ChoiceChip(
                  key: Key('10cent'),
                  avatar: avatar('#0.0', vk.decimalen == 1),
                  label: Text('10 ct'),
                  selected: vk.decimalen == 1,
                  onSelected: (v) {
                    _veranderingAfronden(1);
                  },
                ),
                ChoiceChip(
                  key: Key('1cent'),
                  avatar: avatar('#0.00', vk.decimalen == 2),
                  label: Text('1 ct'),
                  selected: vk.decimalen == 2,
                  onSelected: (v) {
                    _veranderingAfronden(2);
                  },
                ),
              ])),
        ]),
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          vk.isTotalbedrag ? 'Totaalbedrag:' : 'Termijnbedrag per maand:',
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(children: bedragen),
      ),
      SizedBox(
        height: 8.0,
      ),
      Row(children: [
        Flexible(
          child: Slider(
              value: (vk.maanden < vk.minMaanden
                      ? vk.minMaanden
                      : vk.maanden > vk.maxMaanden
                          ? vk.maxMaanden
                          : vk.maanden)
                  .toDouble(),
              min: vk.minMaanden.toDouble(),
              max: vk.maxMaanden.toDouble(),
              divisions: vk.maxMaanden - vk.minMaanden,
              onChanged: (double value) {
                _veranderingMaandenFromSlider(value.toInt());
              }),
        ),
        SizedBox(
            width: 60.0,
            child: TextFormField(
              controller: _tecMaanden,
              inputFormatters: [nf.textInputFormat(NumberType.integralNumber)],
              focusNode: _fnMaanden,
              decoration: InputDecoration(
                  hintText: '${vk.minMaanden}..${vk.maxMaanden}',
                  labelText: 'Mnd'),
              validator: (String? text) =>
                  buitenPeriode(text) == 0 ? null : '*',
              onSaved: (String? text) {
                if (_fnMaanden.hasFocus) {
                  _veranderingMaandenFromText(text);
                }
              },
              keyboardType: TextInputType.number,
            )),
        SizedBox(width: 16.0),
      ]),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CheckValidator(
            key: Key('BedragLooptijd'),
            initialValue: Kalender.looptijdInTekst(vk.maanden),
            validator: (text) {
              switch (buitenPeriode(_tecMaanden.text)) {
                case -1:
                  {
                    return '* Minimaal ${vk.minMaanden} ${vk.minMaanden == 1 ? 'maand' : 'maanden'}';
                  }
                case 1:
                  {
                    return '* Maximaal ${vk.maxMaanden} maanden (${nf.parseDoubleToText(vk.maxMaanden / 12, '0.#')} jaar)';
                  }
                default:
                  {
                    return null;
                  }
              }
            }),
      )
    ];

    return SliverToBoxAdapter(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: columnChildren));
  }

  _veranderingOmschrijving(String? text) {
    verzendhuisKredietModel.veranderingOmschrijving(text ?? '');
  }

  _veranderingDatum(DateTime? value) {
    if (value != null) {
      verzendhuisKredietModel.veranderingDatum(value);
    }
  }

  _veranderingAfronden(int decimalen) {
    verzendhuisKredietModel.veranderingAfronden(decimalen);
  }

  _veranderingSlottermijn(String? text) {
    verzendhuisKredietModel.veranderingSlottermijn(
        text == null || text.isEmpty ? 0.0 : nf.parsToDouble(text));
  }

  _veranderingBedrag(String? text) {
    verzendhuisKredietModel.veranderingBedrag(
        text == null || text.isEmpty ? 0.0 : nf.parsToDouble(text));
  }

  veranderingSlotTermijnOptie(bool? value) {
    assert(value != null, 'Can not be null');
    verzendhuisKredietModel.veranderingSlotTermijnOptie(value!);
  }

  _veranderingBedragPerMaandOfTotaal(bool? value) {
    assert(value != null, 'Can not be null');

    verzendhuisKredietModel.veranderingBedragPerMaandOfTotaal(value!);
  }

  _veranderingMaandenFromText(String? text) {
    verzendhuisKredietModel.veranderingMaanden(
        (text == null || text.isEmpty) ? 1 : int.parse(text));
  }

  _veranderingMaandenFromSlider(int maanden) {
    verzendhuisKredietModel.veranderingMaanden(maanden);
  }

  showSlotTermijnEditBox() {
    if (!vk.isTotalbedrag && vk.heeftSlotTermijn) {
      _slottermijnEditTextAnimationController.forward();
    } else {
      _slottermijnEditTextAnimationController.reverse();
    }
  }

  showAfronden() {
    if (vk.isTotalbedrag) {
      _afrondenAnimationController.forward();
    } else {
      _afrondenAnimationController.reverse();
    }
  }

  int buitenPeriode(String? text) {
    final m = text == null || text.isEmpty ? 0 : int.parse(text);

    return m < vk.minMaanden
        ? -1
        : vk.maxMaanden < m
            ? 1
            : 0;
  }

  setBedrag(double value) {
    _tecBedrag.text =
        value == 0.0 ? '' : nf.parseDoubleToText(vk.bedrag, '#0.00');
  }

  setSlottermijnWaarde(double value) {
    _tecSlottermijn.text =
        value == 0.0 ? '' : nf.parseDoubleToText(vk.slotTermijn, '#0.00');
  }

  setMaanden(int value) {
    _tecMaanden.text = nf.parseIntToText(value);
  }

  setBedragPerMaandOfTotaal(bool value) {
    if (value) {
      _afrondenAnimationController.forward();
    } else {
      _afrondenAnimationController.reverse();
    }

    if (value) {
      _slottermijnCheckboxAnimationController.reverse();
    } else {
      _slottermijnCheckboxAnimationController.forward();
    }

    showSlotTermijnEditBox();
  }

  void refreshState() {
    setState(() {});
  }
}
