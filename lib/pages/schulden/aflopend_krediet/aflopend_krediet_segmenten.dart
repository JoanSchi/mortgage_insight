import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/my_widgets/selectable_widgets/selectable_group_themes.dart';
import 'package:mortgage_insight/my_widgets/selectable_widgets/single_checkbox.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../my_widgets/mortgage_chip.dart';
import '../../../utilities/kalender.dart';
import '../../../my_widgets/simple_widgets.dart';
import 'abstract_aflopend_krediet_consumer_state.dart';

class AflopendKredietOptiePanel extends ConsumerStatefulWidget {
  const AflopendKredietOptiePanel({super.key});

  @override
  ConsumerState<AflopendKredietOptiePanel> createState() =>
      AflopendKredietOptiePanelState();
}

class AflopendKredietOptiePanelState
    extends AbstractAflopendKredietState<AflopendKredietOptiePanel>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _textEditingController =
      TextEditingController(
          text: toText(
    (ak) => ak.omschrijving,
  ));

  late FocusNode _fnOmschrijving = _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_textEditingController.text);
      }
    });

  late AnimationController _gebrokenMaandAlleenRenteAnimationController =
      _gebrokenMaandAlleenRenteAnimationController = AnimationController(
    value: ak?.betaling == AKbetaling.perEerstVolgendeMaand ? 1.0 : 0.0,
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void dispose() {
    _gebrokenMaandAlleenRenteAnimationController.dispose();
    _textEditingController.dispose();
    _fnOmschrijving.dispose();
    super.dispose();
  }

  void changeAfterListen(SchuldBewerken? previous, SchuldBewerken next) {
    final nextAK = akFrom(next);

    if (nextAK == null) {
      return;
    }
    final previousAK = akFrom(previous);

    if (previousAK?.betaling != nextAK.betaling) {
      if (nextAK.betaling == AKbetaling.perEerstVolgendeMaand) {
        _gebrokenMaandAlleenRenteAnimationController.forward();
      } else {
        _gebrokenMaandAlleenRenteAnimationController.reverse();
      }
    }
  }

  @override
  buildAflopendKrediet(context, AflopendKrediet ak) {
    ref.listen(schuldProvider, changeAfterListen);
    final theme = Theme.of(context);
    final dateNow = DateUtils.dateOnly(DateTime.now());
    final firstDate = DateTime(2014, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    final children = <Widget>[
      const SizedBox(
        height: 6.0,
      ),
      OmschrijvingTextField(
        focusNode: _fnOmschrijving,
        textEditingController: _textEditingController,
      ),
      DateInputPicker(
        labelText: 'Datum',
        date: ak.beginDatum,
        firstDate: firstDate,
        lastDate: lastDate,
        saveDate: _veranderingDatum,
        changeDate: _veranderingDatum,
      ),
      const SizedBox(
        height: 24.0,
      ),
      const Text('Termijn betaling:'),
      const SizedBox(
        height: 8.0,
      ),
      UndefinedSelectableGroup(
        groups: [
          MyRadioGroup(
              groupValue: ak.betaling,
              list: [
                RadioSelectable(
                    text: 'op ingangsdatum', value: AKbetaling.ingangsdatum),
                RadioSelectable(
                    text: 'per maand', value: AKbetaling.perEerstVolgendeMaand)
              ],
              onChange: _veranderingBetaling)
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SizeTransition(
          sizeFactor: _gebrokenMaandAlleenRenteAnimationController,
          child: MyCheckbox(
              text: 'Gebroken maand alleen rente',
              value: ak.eersteGebrokenMaandAlleenRente,
              onChanged: _veranderingEersteGebrokenMaandAlleenRente),
        ),
      ),
      const Divider(),
      const SizedBox(
        height: 12.0,
      ),
      const Text(
        'Termijnbedrag afronden op:',
      ),
      const SizedBox(
        height: 8.0,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(spacing: 8.0, children: [
          MortgageChip(
            key: const Key('euros'),
            text: 'Euro\'s',
            selected: ak.decimalen == 0,
            avatarText: '#0',
            onSelected: (bool? v) {
              _afronden(0);
            },
          ),
          MortgageChip(
            key: const Key('10cent'),
            text: '10 ct',
            selected: ak.decimalen == 1,
            avatarText: '#.0',
            onSelected: (bool? v) {
              _afronden(1);
            },
          ),
          MortgageChip(
            key: const Key('1cent'),
            text: '1 ct',
            selected: ak.decimalen == 2,
            avatarText: '#.00',
            onSelected: (bool? v) {
              _afronden(2);
            },
          ),
        ]),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  _veranderingDatum(DateTime? date) {
    notify.veranderingAflopendKrediet(beginDatum: date);
  }

  _veranderingOmschrijving(String? value) {
    notify.veranderingOmschrijving(value ?? '');
  }

  _afronden(int afronding) {
    notify.veranderingAflopendKrediet(decimalen: afronding);
  }

  _veranderingBetaling(AKbetaling? betaling) {
    notify.veranderingAflopendKrediet(betaling: betaling);
  }

  _veranderingEersteGebrokenMaandAlleenRente(bool? value) {
    notify.veranderingAflopendKrediet(eersteGebrokenMaandAlleenRente: value);
  }
}

class AflopendkredietInvulPanel extends ConsumerStatefulWidget {
  const AflopendkredietInvulPanel();

  @override
  ConsumerState<AflopendkredietInvulPanel> createState() =>
      AflopendkredietInvulPanelState();
}

class AflopendkredietInvulPanelState
    extends AbstractAflopendKredietState<AflopendkredietInvulPanel> {
  late TextEditingController _tecLening =
      TextEditingController(text: doubleToText((ak) => ak.lening));
  late TextEditingController _tecRente =
      TextEditingController(text: doubleToText((ak) => ak.rente));
  late TextEditingController _tecMaanden =
      TextEditingController(text: intToText((ak) => ak.maanden));
  late TextEditingController _tecTermijnbedrag =
      TextEditingController(text: doubleToText((ak) => ak.termijnBedragMnd));

  late FocusNode _fnLening = FocusNode()
    ..addListener(() {
      if (!_fnLening.hasFocus) {
        _veranderingLening(_tecLening.text);
      }
    });
  late FocusNode _fnRente = FocusNode()
    ..addListener(() {
      if (!_fnRente.hasFocus) {
        _veranderingRente(_tecRente.text);
      }
    });
  late FocusNode _fnTermijnBedrag = FocusNode()
    ..addListener(() {
      if (!_fnTermijnBedrag.hasFocus) {
        _veranderingTermijnBedrag(_tecTermijnbedrag.text);
      }
    });
  late FocusNode _fnMaanden = FocusNode()
    ..addListener(() {
      if (!_fnMaanden.hasFocus) {
        _veranderingLooptijdTextfield(_tecMaanden.text);
      }
    });

  @override
  void dispose() {
    super.dispose();
    _tecLening.dispose();
    _tecRente.dispose();
    _tecTermijnbedrag.dispose();
    _tecMaanden.dispose();

    _fnLening.dispose();
    _fnRente.dispose();
    _fnTermijnBedrag.dispose();
    _fnMaanden.dispose();
  }

  void changeAfterListening(SchuldBewerken? previous, SchuldBewerken next) {
    final nextAK = akFrom(next);

    if (nextAK == null) {
      return;
    }

    //final previousAK = akFrom(previous);

    if (nf.parsToDouble(_tecLening.text) != nextAK.lening) {
      _tecLening.text = nf.parseDblToText(nextAK.lening);
    }

    if (nf.parsToDouble(_tecTermijnbedrag.text) != nextAK.termijnBedragMnd) {
      _tecTermijnbedrag.text = nf.parseDblToText(nextAK.termijnBedragMnd);
    }

    if ((int.tryParse(_tecMaanden.text) ?? -1) != nextAK.maanden) {
      _tecMaanden.text = nf.parseIntToText(nextAK.maanden);
    }
  }

  @override
  Widget buildAflopendKrediet(BuildContext context, AflopendKrediet ak) {
    ref.listen(schuldProvider, changeAfterListening);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 8.0,
          ),
          const Text(
            'Bedragen en rente:',
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 4.0,
                ),
                Flexible(
                  child: TextFormField(
                      controller: _tecLening,
                      focusNode: _fnLening,
                      key: Key('leenbedrag'),
                      decoration: new InputDecoration(
                          hintText: '', labelText: 'Leenbedrag'),
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return 'Bedrag?';
                        }
                        return null;
                      },
                      onSaved: (String? text) {
                        if (_fnLening.hasFocus) {
                          _veranderingLening(text);
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [
                        MyNumberFormat(context).numberInputFormat('#.00')
                      ],
                      textInputAction: TextInputAction.next),
                ),
                SizedBox(width: 16.0),
                SizedBox(
                  width: 60.0,
                  child: TextFormField(
                      controller: _tecRente,
                      focusNode: _fnRente,
                      key: Key('Rente'),
                      decoration: new InputDecoration(
                          hintText: '< 16%', labelText: 'R. (%)'),
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Rente?';
                        }
                        return null;
                      },
                      onSaved: (text) {
                        if (_fnRente.hasFocus) {
                          _veranderingRente(text);
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [
                        MyNumberFormat(context).numberInputFormat('#.00')
                      ],
                      textInputAction: TextInputAction.next),
                ),
                SizedBox(width: 16.0),
                SizedBox(
                  width: 80.0,
                  child: TextFormField(
                      controller: _tecTermijnbedrag,
                      focusNode: _fnTermijnBedrag,
                      key: Key('termijnbedrag'),
                      decoration: new InputDecoration(
                          hintText: '>= ${ak.minTermijnBedragMnd}',
                          labelText: 'T.b.'),
                      validator: (String? text) {
                        if (text == null || text.isEmpty) {
                          return 'Termijnbedrag?';
                        }
                        return null;
                      },
                      onSaved: (text) {
                        if (_fnTermijnBedrag.hasFocus) {
                          _veranderingTermijnBedrag(text);
                        }
                      },
                      keyboardType: TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [
                        MyNumberFormat(context).numberInputFormat('#.00')
                      ],
                      textInputAction: TextInputAction.next),
                ),
                SizedBox(
                  width: 4.0,
                )
              ]),
          const Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Text('R.: Rente, T.b.: Termijnbedrag (mnd)',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            'Looptijd',
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
                child: Slider(
              min: ak.minMaanden.toDouble(),
              max: ak.maxMaanden.toDouble(),
              value: (ak.maanden < ak.minMaanden
                      ? ak.minMaanden
                      : ak.maanden > ak.maxMaanden
                          ? ak.maxMaanden
                          : ak.maanden)
                  .toDouble(),
              divisions: ak.maxMaanden - ak.minMaanden + 1,
              onChanged: (value) {
                _veranderingLooptijdSlider(value.toInt());
              },
            )),
            // SizedBox(width: 8.0),
            SizedBox(
              width: 50.0,
              child: TextFormField(
                  controller: _tecMaanden,
                  focusNode: _fnMaanden,
                  key: Key('Maanden'),
                  decoration:
                      new InputDecoration(hintText: '1..120', labelText: 'Mnd'),
                  validator: (String? text) {
                    if (buitenPeriode(ak, text) != 0) {
                      return '*';
                    }
                    return null;
                  },
                  onSaved: (text) {
                    if (_fnMaanden.hasFocus) {
                      _veranderingLooptijdTextfield(text);
                    }
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    MyNumberFormat(context).numberInputFormat('0000')
                  ]),
            ),
            const SizedBox(width: 4.0),
          ]),
          CheckValidator(
              key: const Key('Annlening'),
              initialValue: Kalender.looptijdInTekst(ak.maanden),
              validator: (text) {
                switch (buitenPeriode(ak, _tecMaanden.text)) {
                  case -1:
                    {
                      return '* Minimaal ${ak.minMaanden} ${ak.minMaanden == 1 ? 'maand' : 'maanden'}';
                    }
                  case 1:
                    {
                      return '* Maximaal ${ak.maxMaanden} maanden (${nf.parseDoubleToText(ak.maxMaanden / 12, '0.#')} jaar)';
                    }
                  default:
                    {
                      return null;
                    }
                }
              })
        ]);
  }

  _veranderingLening(String? text) {
    notify.veranderingAflopendKrediet(lening: nf.parsToDouble(text));
  }

  _veranderingRente(String? text) {
    notify.veranderingAflopendKrediet(rente: nf.parsToDouble(text));
  }

  _veranderingTermijnBedrag(String? text) {
    notify.veranderingAflopendKrediet(termijnBedragMnd: nf.parsToDouble(text));
  }

  _veranderingLooptijdTextfield(String? text) {
    final int maanden = (text == null || text.isEmpty) ? 0 : nf.parsToInt(text);

    notify.veranderingAflopendKrediet(maanden: maanden);
  }

  int buitenPeriode(AflopendKrediet ak, String? text) {
    final m = text == null || text.isEmpty ? 0 : int.parse(text);

    return m < ak.minMaanden
        ? -1
        : ak.maxMaanden < m
            ? 1
            : 0;
  }

  _veranderingLooptijdSlider(int looptijdMnd) {
    notify.veranderingAflopendKrediet(maanden: looptijdMnd);
  }
}

class AflopendKredietErrorWidget extends ConsumerStatefulWidget {
  const AflopendKredietErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AflopendKredietErrorWidget> createState() =>
      _AflopendKredietErrorWidgetState();
}

class _AflopendKredietErrorWidgetState
    extends AbstractAflopendKredietState<AflopendKredietErrorWidget> {
  @override
  Widget buildAflopendKrediet(BuildContext context, AflopendKrediet ak) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxIconSize = constraints.maxWidth - 2.0 * 16.0;

      double size = maxIconSize < 300.0 ? maxIconSize : 300.0;

      if (ak.error.isNotEmpty) {
        return Column(children: [
          Icon(
            Icons.warning_amber,
            color: Colors.amberAccent,
            size: size,
          ),
          Text(
            ak.error,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.red),
          )
        ]);
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
