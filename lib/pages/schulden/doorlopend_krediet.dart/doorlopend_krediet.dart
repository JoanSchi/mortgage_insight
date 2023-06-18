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
import 'package:hypotheek_berekeningen/schulden/uitwerken/doorlopendkrediet_verwerken.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import '../../../my_widgets/selectable_widgets/single_checkbox.dart';
import '../../../my_widgets/simple_widgets.dart';
import '../../../utilities/kalender.dart';
import '../../../utilities/my_number_format.dart';
import '../schuld_provider.dart';
import 'doorlopend_krediet_overzicht.dart';

class DoorlopendKredietPanel extends StatelessWidget {
  final EdgeInsets padding;
  final Widget? appBar;

  const DoorlopendKredietPanel({
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
            delegate: SliverChildListDelegate.fixed([
          DoorlopendKredietInvulPanel(),
          OverzichtDoorlopendKrediet(),
        ])),
      ),
    ]);
  }
}

class DoorlopendKredietInvulPanel extends ConsumerStatefulWidget {
  const DoorlopendKredietInvulPanel({
    super.key,
  });

  @override
  ConsumerState<DoorlopendKredietInvulPanel> createState() {
    return DoorlopendKredietInvulPanelState();
  }
}

class DoorlopendKredietInvulPanelState
    extends ConsumerState<DoorlopendKredietInvulPanel>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _tecOmschrijving =
      TextEditingController(text: toText((dk) => dk.omschrijving));
  late final TextEditingController _tecBedrag =
      TextEditingController(text: doubleToText((dk) => dk.bedrag));
  late final FocusNode _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_tecOmschrijving.text);
      }
    });
  late final FocusNode _fnBedrag = FocusNode()
    ..addListener(() {
      if (!_fnBedrag.hasFocus) {
        _veranderingBedrag(_tecBedrag.text);
      }
    });
  late final AnimationController _animationControllerEindDatum =
      AnimationController(
    value: (dk?.heeftEindDatum ?? false) ? 1 : 0,
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late MyNumberFormat nf = MyNumberFormat(context);

  SchuldBewerkNotifier get notifier => ref.read(schuldProvider.notifier);

  DoorlopendKrediet? get dk =>
      ref.read(schuldProvider).schuld?.mapOrNull<DoorlopendKrediet?>(
          doorlopendKrediet: (DoorlopendKrediet dk) => dk);

  String toText(Function(DoorlopendKrediet dk) toText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            doorlopendKrediet: (DoorlopendKrediet dk) => toText(dk)) ??
        '';
  }

  String doubleToText(Function(DoorlopendKrediet dk) doubleToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            doorlopendKrediet: (DoorlopendKrediet dk) {
          final value = doubleToText(dk);
          return value == 0.0 ? '' : nf.parseDblToText(doubleToText(dk));
        }) ??
        '';
  }

  String intToText(int Function(DoorlopendKrediet dk) intToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            doorlopendKrediet: (DoorlopendKrediet dk) {
          final value = intToText(dk);
          return value == 0.0 ? '' : '$value';
        }) ??
        '';
  }

  @override
  void dispose() {
    super.dispose();
    _tecOmschrijving.dispose();
    _tecBedrag.dispose();
    _fnOmschrijving.dispose();
    _fnBedrag.dispose();
    _animationControllerEindDatum.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
        schuldProvider.select<bool>((value) => (value.schuld?.mapOrNull<bool?>(
                doorlopendKrediet: (DoorlopendKrediet dk) =>
                    dk.heeftEindDatum) ??
            false)), (bool? previous, bool next) {
      eindDatumAnimation(next);
    });

    return ref.watch(schuldProvider).schuld?.mapOrNull(
            doorlopendKrediet: (DoorlopendKrediet dk) => _build(context, dk)) ??
        const OhNo(text: 'DoorlopendKrediet fout');
  }

  Widget _build(BuildContext context, DoorlopendKrediet dk) {
    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    final list = <Widget>[
      const SizedBox(
        height: 6,
      ),
      OmschrijvingTextField(
          textEditingController: _tecOmschrijving, focusNode: _fnOmschrijving),
      DateInputPicker(
        date: dk.beginDatum,
        firstDate: firstDate,
        lastDate: lastDate,
        saveDate: (DateTime? date) {
          _veranderingBegindatum(date);
        },
        changeDate: (DateTime? date) {
          _veranderingBegindatum(date);
        },
      ),
      const SizedBox(
        height: 16.0,
      ),
      const Text(
        'Einddatum/Krediet:',
      ),
      MyCheckbox(
        text: 'Einddatum',
        value: dk.heeftEindDatum,
        onChanged: (bool? value) {
          _veranderingHeeftEinddatum(value);
        },
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          flex: 3,
          child: TextFormField(
              controller: _tecBedrag,
              focusNode: _fnBedrag,
              key: const Key('DK_krediet'),
              decoration: const InputDecoration(
                  hintText: 'limiet', labelText: 'Krediet'),
              validator: (String? text) {
                if (nf.parsToDouble(text ?? '') <= 0) {
                  return '.. > 0';
                }
                return null;
              },
              onSaved: (String? text) {
                _veranderingBedrag(text);
              },
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatters: [
                MyNumberFormat(context).numberInputFormat('#.00')
              ]),
        ),
        const SizedBox(
          width: 16.0,
        ),
        SizeTransition(
          sizeFactor: _animationControllerEindDatum,
          axis: Axis.horizontal,
          child: SizedBox(
            width: 160,
            child: DateInputPicker(
              date: dk.eindDatumGebruiker,
              firstDate: DoorlopendKredietVerwerken.beginBereikEindDatum(
                  dk.beginDatum),
              lastDate:
                  DoorlopendKredietVerwerken.eindBereikEindDatum(dk.beginDatum),
              saveDate: (DateTime? date) {
                _veranderingEinddatum(date);
              },
              changeDate: (DateTime? date) {
                _veranderingEinddatum(date);
              },
            ),
          ),
        ),
      ])
    ];

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  _veranderingBegindatum(DateTime? date) {
    if (date != null) {
      notifier.veranderingDoorlopendKrediet(beginDatum: date);
    }
  }

  _veranderingHeeftEinddatum(bool? heefEindDatum) {
    notifier.veranderingDoorlopendKrediet(
        heeftEindDatum: heefEindDatum ?? false);
  }

  _veranderingEinddatum(DateTime? datum) {
    if (datum != null) {
      notifier.veranderingDoorlopendKrediet(eindDatumGebruiker: datum);
    }
  }

  _veranderingOmschrijving(String? value) {
    notifier.veranderingOmschrijving(value ?? '');
  }

  _veranderingBedrag(String? value) {
    notifier.veranderingDoorlopendKrediet(bedrag: nf.parsToDouble(value));
  }

  eindDatumAnimation(bool heeftEindDatum) {
    if (heeftEindDatum) {
      _animationControllerEindDatum.forward();
    } else {
      _animationControllerEindDatum.reverse();
    }
  }
}
