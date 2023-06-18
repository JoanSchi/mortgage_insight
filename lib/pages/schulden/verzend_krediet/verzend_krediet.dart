// Copyright (C) 2023 Joan Schipper
//
// This file is part of mortgage_insight.
//
// mortgage_insight is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// mortgage_insight is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:hypotheek_berekeningen/schulden/uitwerken/verzendkrediet_verwerken.dart';
import 'package:mortgage_insight/my_widgets/mortgage_chip.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/my_widgets/selectable_widgets/single_checkbox.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import 'package:mortgage_insight/pages/schulden/verzend_krediet/verzend_krediet_overview.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../my_widgets/simple_widgets.dart';
import '../../../utilities/kalender.dart';
import '../../../utilities/my_number_format.dart';
import '../../../utilities/match_properties.dart';

class VerzendKredietPanel extends StatelessWidget {
  final EdgeInsets padding;
  final Widget? appBar;

  const VerzendKredietPanel({
    super.key,
    required this.padding,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      if (appBar != null) appBar!,
      SliverPadding(
        padding: padding,
        sliver: const SliverList(
            delegate: SliverChildListDelegate.fixed(
          [
            VerzendKredietOptiePanel(),
            OverzichtVerzendHuisKrediet(),
          ],
        )),
      )
    ]);
  }
}

class VerzendKredietOptiePanel extends ConsumerStatefulWidget {
  const VerzendKredietOptiePanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<VerzendKredietOptiePanel> createState() =>
      VerzendKredietOptiePanelState();
}

class VerzendKredietOptiePanelState
    extends ConsumerState<VerzendKredietOptiePanel>
    with TickerProviderStateMixin {
  VerzendKrediet? get vk => ref
      .read(schuldProvider)
      .schuld
      ?.mapOrNull(verzendKrediet: (VerzendKrediet vk) => vk);

  SchuldBewerkNotifier get notifier => ref.read(schuldProvider.notifier);

  late MyNumberFormat nf = MyNumberFormat(context);

  late final TextEditingController _tecOmschrijving =
      TextEditingController(text: toText((vk) => vk.omschrijving));

  late final TextEditingController _tecMaanden =
      TextEditingController(text: intToText((vk) => vk.maanden));

  late final TextEditingController _tecBedrag =
      TextEditingController(text: doubleToText((vk) => vk.totaalBedrag));

  late final TextEditingController _tecSlottermijn =
      TextEditingController(text: doubleToText((vk) => vk.slotTermijn));

  late final FocusNode _fnMaanden = FocusNode()
    ..addListener(() {
      if (!_fnMaanden.hasFocus) {
        _veranderingMaandenFromText(_tecMaanden.text);
      }
    });
  late final FocusNode _fnBedrag = FocusNode()
    ..addListener(() {
      if (!_fnBedrag.hasFocus) {
        _veranderingBedrag(_tecBedrag.text);
      }
    });
  late final FocusNode _fnSlottermijn = FocusNode()
    ..addListener(() {
      if (!_fnSlottermijn.hasFocus) {
        _veranderingSlottermijn(_tecSlottermijn.text);
      }
    });
  late final FocusNode _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_tecOmschrijving.text);
      }
    });

  late final AnimationController _slottermijnCheckboxAnimationController =
      AnimationController(
          value: (vk?.vkBedrag ?? VKbedrag.totaal) == VKbedrag.totaal ? 1 : 0,
          vsync: this,
          duration: const Duration(milliseconds: 200));

  late final AnimationController _slottermijnEditTextAnimationController =
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

  late final AnimationController _afrondenAnimationController =
      AnimationController(
    value: (vk?.vkBedrag ?? VKbedrag.totaal) == VKbedrag.totaal ? 1.0 : 0.0,
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  bool get _slottermijnEditboxvisible {
    final localVk = vk;

    return (localVk != null) &&
        localVk.vkBedrag == VKbedrag.totaal &&
        localVk.heeftSlotTermijn;
  }

  String toText(Function(VerzendKrediet vk) toText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            verzendKrediet: (VerzendKrediet vk) => toText(vk)) ??
        '';
  }

  String doubleToText(double Function(VerzendKrediet vk) doubleToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            verzendKrediet: (VerzendKrediet vk) {
          final value = doubleToText(vk);
          return value == 0.0 ? '' : nf.parseDblToText(doubleToText(vk));
        }) ??
        '';
  }

  String intToText(int Function(VerzendKrediet vk) intToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            verzendKrediet: (VerzendKrediet vk) {
          final value = intToText(vk);
          return value == 0.0 ? '' : '$value';
        }) ??
        '';
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(schuldProvider, changeVerzendKrediet);

    return ref.watch(schuldProvider).schuld?.mapOrNull(
            verzendKrediet: (VerzendKrediet vk) => _build(context, vk)) ??
        const OhNo(text: 'VerzendKrediet not found!');
  }

  VerzendKrediet? vkFrom(SchuldBewerken? sb) =>
      sb?.schuld?.mapOrNull(verzendKrediet: (VerzendKrediet vk) => vk);

  void changeVerzendKrediet(SchuldBewerken? previous, SchuldBewerken next) {
    VerzendKrediet? nextVK = vkFrom(next);

    if (nextVK == null) {
      return;
    }

    VerzendKrediet? previousVK = vkFrom(previous);

    if (nextVK.maanden != int.tryParse(_tecMaanden.text)) {
      _tecMaanden.text = '${nextVK.maanden}';
    }

    if (previousVK != null && (previousVK.vkBedrag != nextVK.vkBedrag)) {
      switch (nextVK.vkBedrag) {
        case VKbedrag.totaal:
          {
            _tecBedrag.text = nf.parseDoubleToText(nextVK.totaalBedrag);
            break;
          }
        case VKbedrag.mnd:
          {
            _tecBedrag.text = nf.parseDoubleToText(nextVK.mndBedrag);
            break;
          }
      }
    }

    if (previousVK != null &&
        (previousVK.heeftSlotTermijn != nextVK.heeftSlotTermijn ||
            previousVK.vkBedrag != nextVK.vkBedrag)) {
      showSlotTermijnEditBox(VerzendKredietVerwerken.showSlottermijn(nextVK));

      if (nextVK.heeftSlotTermijn) {
        _tecSlottermijn.text = nf.parseDoubleToText(nextVK.slotTermijn);
      }
    }
  }

  Widget _build(BuildContext context, VerzendKrediet vk) {
    final dateNow = DateUtils.dateOnly(DateTime.now());
    final firstDate = DateTime(dateNow.year - 3, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    final List<Widget> bedragen = [
      Expanded(
        child: TextFormField(
            controller: _tecBedrag,
            keyboardType: const TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            inputFormatters: [nf.numberInputFormat('#0.00')],
            focusNode: _fnBedrag,
            decoration: InputDecoration(
                hintText: '',
                labelText:
                    vk.vkBedrag == VKbedrag.totaal ? 'Totaal' : 'Termijn'),
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

    bedragen.addAll([
      SizeTransition(
        sizeFactor: _slottermijnEditTextAnimationController,
        axis: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 8.0,
            ),
            SizedBox(
                width: 80.0,
                child: TextFormField(
                  controller: _tecSlottermijn,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputFormatters: [
                    MyNumberFormat(context).numberInputFormat('#0.00')
                  ],
                  focusNode: _fnSlottermijn,
                  decoration: const InputDecoration(
                      hintText: '', labelText: 'Slottermijn'),
                  validator: (text) {
                    if (nf.parsToDouble(text) < 0.0) {
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
          ],
        ),
      )
    ]);

    List<Widget> columnChildren = [
      const SizedBox(
        height: 6.0,
      ),
      OmschrijvingTextField(
        focusNode: _fnOmschrijving,
        textEditingController: _tecOmschrijving,
      ),
      DateInputPicker(
        labelText: 'Datum',
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
      const SizedBox(
        height: 8.0,
      ),
      UndefinedSelectableGroup(groups: [
        MyRadioGroup<VKbedrag>(
          groupValue: vk.vkBedrag,
          list: [
            RadioSelectable(text: 'Totaalbedrag', value: VKbedrag.totaal),
            RadioSelectable(
                text: 'Termijnbedrag per maand', value: VKbedrag.mnd)
          ],
          onChange: _veranderingBedragPerMaandOfTotaal,
        )
      ], matchTargetWrap: [
        MatchTargetWrap<GroupLayoutProperties>(
            object: GroupLayoutProperties.vertical())
      ]),
      Padding(
        padding: const EdgeInsets.only(left: 32.0),
        child: SizeTransition(
          sizeFactor: _slottermijnCheckboxAnimationController,
          child: MyCheckbox(
              text: 'Slottermijn',
              value: vk.heeftSlotTermijn,
              enabled: vk.vkBedrag == VKbedrag.mnd,
              onChanged: veranderingSlotTermijnOptie),
        ),
      ),
      SizeTransition(
        sizeFactor: _afrondenAnimationController,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Divider(),
          const Text(
            'Termijnbedrag afronden op:',
          ),
          const SizedBox(
            height: 8.0,
          ),
          Wrap(spacing: 8.0, children: [
            MortgageChip(
                key: const Key('euros'),
                selected: vk.decimalen == 0,
                onSelected: (v) {
                  _veranderingAfronden(0);
                },
                text: 'Euro\'s',
                avatarText: '#0'),
            MortgageChip(
                key: const Key('10cent'),
                selected: vk.decimalen == 1,
                onSelected: (v) {
                  _veranderingAfronden(1);
                },
                text: '10 ct',
                avatarText: '#.0'),
            MortgageChip(
                key: const Key('1cent'),
                selected: vk.decimalen == 2,
                onSelected: (v) {
                  _veranderingAfronden(2);
                },
                text: '1 ct',
                avatarText: '#.00'),
          ]),
        ]),
      ),
      const Divider(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          vk.vkBedrag == VKbedrag.totaal
              ? 'Totaalbedrag:'
              : 'Termijnbedrag per maand:',
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(children: bedragen),
      ),
      const SizedBox(
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
        const SizedBox(width: 16.0),
      ]),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CheckValidator(
            key: const Key('BedragLooptijd'),
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

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: columnChildren);
  }

  _veranderingOmschrijving(String? text) {
    notifier.veranderingOmschrijving(text ?? '');
  }

  _veranderingDatum(DateTime? value) {
    notifier.veranderingVerzendKrediet(beginDatum: value);
  }

  _veranderingAfronden(int decimalen) {
    notifier.veranderingVerzendKrediet(decimalen: decimalen);
  }

  _veranderingSlottermijn(String? text) {
    notifier.veranderingVerzendKrediet(slotBedrag: nf.parsToDouble(text));
  }

  _veranderingBedrag(String? text) {
    notifier.veranderingVerzendKrediet(bedrag: nf.parsToDouble(text));
  }

  veranderingSlotTermijnOptie(bool? value) {
    notifier.veranderingVerzendKrediet(heeftSlotTermijn: value);
  }

  _veranderingBedragPerMaandOfTotaal(VKbedrag? value) {
    notifier.veranderingVerzendKrediet(vkBedrag: value);
  }

  _veranderingMaandenFromText(String? text) {
    notifier.veranderingVerzendKrediet(
        maanden: text == null || text.isEmpty ? 1 : int.parse(text));
  }

  _veranderingMaandenFromSlider(int maanden) {
    notifier.veranderingVerzendKrediet(maanden: maanden);
  }

  void showSlotTermijnEditBox(bool heeftSlotTermijn) {
    if (heeftSlotTermijn) {
      _slottermijnEditTextAnimationController.forward();
    } else {
      _slottermijnEditTextAnimationController.reverse();
    }
  }

  showAfronden() {
    final localVk = vk;
    if (localVk != null && localVk.vkBedrag == VKbedrag.totaal) {
      _afrondenAnimationController.forward();
    } else {
      _afrondenAnimationController.reverse();
    }
  }

  int buitenPeriode(String? text) {
    final m = text == null || text.isEmpty ? 0 : int.parse(text);
    final localVk = vk;
    return localVk == null || m < localVk.minMaanden
        ? -1
        : localVk.maxMaanden < m
            ? 1
            : 0;
  }
}
