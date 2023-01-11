import 'package:flutter/material.dart';
import 'package:mortgage_insight/utilities/MyNumberFormat.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../model/nl/schulden/schulden_aflopend_krediet.dart';
import '../../../utilities/Kalender.dart';
import '../date_picker.dart';
import '../../../my_widgets/simple_widgets.dart';
import 'aflopend_krediet_model.dart';

class AflopendKredietOptiePanel extends StatefulWidget {
  final AflopendKredietModel aflopendKredietModel;

  AflopendKredietOptiePanel(this.aflopendKredietModel);

  @override
  State<StatefulWidget> createState() => AflopendKredietOptiePanelState();
}

class AflopendKredietOptiePanelState extends State<AflopendKredietOptiePanel>
    with SingleTickerProviderStateMixin {
  late AflopendKredietModel aflopendKredietModel = aflopendKredietModel =
      widget.aflopendKredietModel..aflopendKredietOptiePanelState = this;

  late AflopendKrediet ak = aflopendKredietModel.ak;

  late TextEditingController _textEditingController =
      TextEditingController(text: ak.omschrijving);

  late FocusNode _fnOmschrijving = _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_textEditingController.text);
      }
    });

  late AnimationController _gebrokenMaandAlleenRenteAnimationController =
      _gebrokenMaandAlleenRenteAnimationController = AnimationController(
    value: ak.betaling == AKbetaling.per_eerst_volgende_maand ? 1.0 : 0.0,
    vsync: this,
    duration: Duration(milliseconds: 300),
  );

  bool looptijdVerschuiven = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _gebrokenMaandAlleenRenteAnimationController.dispose();
    _textEditingController.dispose();
    _fnOmschrijving.dispose();
    aflopendKredietModel.aflopendKredietOptiePanelState = null;
    super.dispose();
  }

  void didUpdateWidget(AflopendKredietOptiePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (ak.berekend != Calculated.yes) {
      ak.bereken();
    }

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

    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: OmschrijvingTextField(
          focusNode: _fnOmschrijving,
          textEditingController: _textEditingController,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: DateWidget(
          useRootNavigator: true,
          date: ak.beginDatum,
          firstDate: firstDate,
          lastDate: lastDate,
          saveDate: _veranderingDatum,
          changeDate: _veranderingDatum,
        ),
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Annuïteit berekening:'),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Wrap(children: [
          RadioSimpel<AKbetaling>(
              title: 'Op ingangsdatum',
              value: AKbetaling.per_periode,
              groupValue: ak.betaling,
              onChanged: _veranderingBetaling),
          RadioSimpel<AKbetaling>(
              title: 'Per maand',
              value: AKbetaling.per_maand,
              groupValue: ak.betaling,
              onChanged: _veranderingBetaling),
          RadioSimpel<AKbetaling>(
              title: 'Vanaf eerste volledige maand',
              value: AKbetaling.per_eerst_volgende_maand,
              groupValue: ak.betaling,
              onChanged: _veranderingBetaling),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SizeTransition(
          sizeFactor: _gebrokenMaandAlleenRenteAnimationController,
          child: CheckboxSimpel(
              title: 'Gebroken maand alleen rente',
              value: ak.renteGebrokenMaand,
              onChanged: renteGebrokenMaand),
        ),
      ),
      Divider(),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Termijnbedrag afronden op:',
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Wrap(spacing: 8.0, children: [
          ChoiceChip(
            key: Key('euros'),
            avatar: avatar('#0', ak.decimalen == 0),
            label: Text('Euro\'s'),
            selected: ak.decimalen == 0,
            onSelected: (v) {
              _afronden(0);
            },
          ),
          ChoiceChip(
            key: Key('10cent'),
            avatar: avatar('#0.0', ak.decimalen == 1),
            label: Text('10 ct'),
            selected: ak.decimalen == 1,
            onSelected: (v) {
              _afronden(1);
            },
          ),
          ChoiceChip(
            key: Key('1cent'),
            avatar: avatar('#0.00', ak.decimalen == 2),
            label: Text('1 ct'),
            selected: ak.decimalen == 2,
            onSelected: (v) {
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
    if (date == null) return;
    aflopendKredietModel.veranderingDate(date);
  }

  _veranderingOmschrijving(String? value) {
    aflopendKredietModel.veranderingOmschrijving(value ?? '');
  }

  _afronden(int afronding) {
    aflopendKredietModel.veranderingAfronden(afronding);
  }

  _veranderingBetaling(AKbetaling? betaling) {
    if (betaling == null) return;

    aflopendKredietModel.veranderingBetaling(betaling);
  }

  showAlleenRenteCheckbox() {
    if (ak.betaling == AKbetaling.per_eerst_volgende_maand) {
      _gebrokenMaandAlleenRenteAnimationController.forward();
    } else {
      _gebrokenMaandAlleenRenteAnimationController.reverse();
    }
  }

  renteGebrokenMaand(bool? value) {
    if (value == null || ak.betaling != AKbetaling.per_eerst_volgende_maand)
      return;

    setState(() {
      aflopendKredietModel.veranderingRenteGebrokenMaand(value);
    });
  }

  setBetaling() {
    setState(() {
      showAlleenRenteCheckbox();
    });
  }

  setAfronden() {
    setState(() {});
  }
}

class AflopendkredietInvulPanel extends StatefulWidget {
  final AflopendKredietModel aflopendKredietModel;

  AflopendkredietInvulPanel(this.aflopendKredietModel);

  @override
  State createState() => AflopendkredietInvulPanelState();
}

class AflopendkredietInvulPanelState extends State<AflopendkredietInvulPanel> {
  late AflopendKredietModel aflopendKredietModel = widget.aflopendKredietModel
    ..aflopendkredietInvulPanelState = this;
  late AflopendKrediet ak = aflopendKredietModel.ak;

  late MyNumberFormat nf = MyNumberFormat(context);
  late TextEditingController _tecLening = TextEditingController(
      text: ak.lening == 0.0 ? '' : nf.parseDoubleToText(ak.lening));
  late TextEditingController _tecRente = TextEditingController(
      text: ak.rente == 0.0 ? '' : nf.parseDoubleToText(ak.rente));
  late TextEditingController _tecMaanden = TextEditingController(
      text: ak.maanden == 0.0 ? '' : nf.parseIntToText(ak.maanden));
  late TextEditingController _tecTermijnbedrag = TextEditingController(
      text: ak.termijnBedragMnd == 0.0
          ? ''
          : nf.parseDoubleToText(ak.termijnBedragMnd));

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

  bool isSliding = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AflopendkredietInvulPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

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

    aflopendKredietModel.aflopendkredietInvulPanelState = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bedragen en rente:',
            ),
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24.0,
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
                SizedBox(width: 32.0),
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
                SizedBox(width: 32.0),
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
                  width: 16.0,
                )
              ]),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 8.0),
            child: Text(
              'R.: Rente, T.b.: Termijnbedrag (mnd)',
              // style: theme.textTheme.caption
              //     .copyWith(fontStyle: FontStyle.italic)
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text(
              'Looptijd',
              // style: theme.textTheme.body1
              //     .copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
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
                      onChangeStart: (value) {
                        isSliding = true;
                        // Provider.of<_StandaardLeningTabelNotifier>(context,
                        //         listen: false)
                        //     .showTableFunction(false);
                      },
                      onChangeEnd: (value) {
                        isSliding = false;
                        // delayChangeEnd();
                      }),
                ),
                SizedBox(width: 8.0),
                SizedBox(
                  width: 50.0,
                  child: TextFormField(
                      controller: _tecMaanden,
                      focusNode: _fnMaanden,
                      key: Key('Maanden'),
                      decoration: new InputDecoration(
                          hintText: '1..120', labelText: 'Mnd'),
                      validator: (String? text) {
                        if (buitenPeriode(text) != 0) {
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
                SizedBox(width: 16.0),
              ]),
          // CheckValidator(
          //     key: Key('Annlening'),
          //     initialValue: looptijdInTekst(ak.maanden),
          //     fontStyle: FontStyle.italic,
          //     validator: (text) {
          //       switch (buitenPeriode(_tecMaanden.text)) {
          //         case -1:
          //           {
          //             return '* Minimaal ${ak.minMaanden} ${ak.minMaanden == 1 ? 'maand' : 'maanden'}';
          //           }
          //         case 1:
          //           {
          //             return '* Maximaal ${ak.maxMaanden} maanden (${nf.parseDoubleToText(ak.maxMaanden / 12, '0.#')} jaar)';
          //           }
          //         default:
          //           {
          //             return null;
          //           }
          //       }
          //     })
        ]);
  }

  _veranderingLening(String? text) {
    final double lening =
        (text == null || text.isEmpty) ? 0.0 : nf.parsToDouble(text);

    aflopendKredietModel.veranderingLening(lening);
  }

  _veranderingRente(String? text) {
    final double rente =
        (text == null || text.isEmpty) ? 0.0 : nf.parsToDouble(text);

    aflopendKredietModel.veranderingRente(rente);
  }

  _veranderingTermijnBedrag(String? text) {
    final double termijnBedrag =
        (text == null || text.isEmpty) ? 0.0 : nf.parsToDouble(text);

    aflopendKredietModel.veranderingTermijnBedrag(termijnBedrag);
  }

  _veranderingLooptijdTextfield(String? text) {
    final int maanden = (text == null || text.isEmpty) ? 0 : nf.parsToInt(text);

    if (maanden != ak.maanden) {
      aflopendKredietModel.veranderingLooptijd(maanden);
    }
  }

  int buitenPeriode(String? text) {
    final m = text == null || text.isEmpty ? 0 : int.parse(text);

    return m < ak.minMaanden
        ? -1
        : ak.maxMaanden < m
            ? 1
            : 0;
  }

  _veranderingLooptijdSlider(int looptijdMnd) {
    aflopendKredietModel.veranderingLooptijd(looptijdMnd);
  }

  setLening(double value) {
    _tecLening.text = nf.parseDblToText(value);
  }

  setRente(double value) {
    _tecRente.text = nf.parseDblToText(value);
  }

  setTermijnBedrag(double value) {
    _tecTermijnbedrag.text = nf.parseDblToText(value);
  }

  setMaanden(int value) {
    setState(() {
      //SetState for slider
      _tecMaanden.text = nf.parseIntToText(value);
    });
  }
}

class AflopendKredietErrorWidget extends StatefulWidget {
  final AflopendKredietModel aflopendKredietModel;

  AflopendKredietErrorWidget({Key? key, required this.aflopendKredietModel})
      : super(key: key);

  @override
  State<AflopendKredietErrorWidget> createState() =>
      _AflopendKredietErrorWidgetState();
}

class _AflopendKredietErrorWidgetState
    extends State<AflopendKredietErrorWidget> {
  late AflopendKredietModel aflopendKredietModel;

  @override
  void initState() {
    aflopendKredietModel = widget.aflopendKredietModel..addListener(notify);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (aflopendKredietModel != widget.aflopendKredietModel) {
      aflopendKredietModel.removeListener(notify);
      aflopendKredietModel = widget.aflopendKredietModel..addListener(notify);
    }
    super.didChangeDependencies();
  }

  void notify() {
    setState(() {});
  }

  @override
  void dispose() {
    aflopendKredietModel.removeListener(notify);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ak = aflopendKredietModel.ak;

    return SliverToBoxAdapter(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final maxIconSize = constraints.maxWidth - 2.0 * 16.0;

      double size = maxIconSize < 300.0 ? maxIconSize : 300.0;

      switch (ak.error) {
        case Schuld.unknownError:
          {
            return Column(children: [
              Icon(
                Icons.warning_amber,
                color: Colors.amberAccent,
                size: size,
              ),
              Text(
                'Een onbekende fout is tijdens het berekenen opgetreden.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.red),
              )
            ]);
          }
        case AflopendKrediet.termijnBedragTelaagError:
          {
            return Column(children: [
              Icon(
                Icons.warning_amber,
                color: Colors.amberAccent,
                size: size,
              ),
              Text(
                  'Het termijnbedrag moet minimaal ${ak.minTermijnBedragMnd} zijn.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(color: Colors.red))
            ]);
          }
        default:
          {
            return SizedBox.shrink();
          }
      }
    }));
  }
}
