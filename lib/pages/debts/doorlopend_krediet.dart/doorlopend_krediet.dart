import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/pages/debts/doorlopend_krediet.dart/doorlopend_krediet_model.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_doorlopend_krediet.dart';
import 'package:go_router/go_router.dart';
import '../../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../../my_widgets/simple_widgets.dart';
import '../../../template_mortgage_items/AcceptCancelActions.dart';
import '../../../utilities/Kalender.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../date_picker.dart';
import 'doorlopend_krediet_overzicht.dart';

class DoorlopendKredietPanel extends ConsumerStatefulWidget {
  final DoorlopendKrediet doorlopendKrediet;
  final MessageListener<AcceptCancelBackMessage> messageListener;

  const DoorlopendKredietPanel(
      {Key? key,
      required this.doorlopendKrediet,
      required this.messageListener})
      : super(key: key);

  @override
  ConsumerState<DoorlopendKredietPanel> createState() =>
      _DoorlopendKredietPanelState();
}

class _DoorlopendKredietPanelState
    extends ConsumerState<DoorlopendKredietPanel> {
  late DoorlopendKredietModel _doorlopendKredietModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _doorlopendKredietModel =
        DoorlopendKredietModel(dk: widget.doorlopendKrediet);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setModel();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DoorlopendKredietPanel oldWidget) {
    setModel();
    super.didUpdateWidget(oldWidget);
  }

  setModel() {
    if (_doorlopendKredietModel.dk != widget.doorlopendKrediet) {
      _doorlopendKredietModel =
          DoorlopendKredietModel(dk: widget.doorlopendKrediet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate.fixed([
        DoorlopendKredietInvulPanel(
            doorlopendKredietModel: _doorlopendKredietModel, formKey: _formKey),
      ])),
      OverzichtDoorlopendKrediet(
        doorlopendKredietModel: _doorlopendKredietModel,
      )
    ]);

    return MessageListenerWidget<AcceptCancelBackMessage>(
        listener: widget.messageListener,
        onMessage: (AcceptCancelBackMessage message) {
          switch (message.msg) {
            case AcceptCancelBack.accept:
              FocusScope.of(context).unfocus();

              scheduleMicrotask(() {
                if ((_formKey.currentState?.validate() ?? false)) {
                  ref
                      .read(hypotheekContainerProvider.notifier)
                      .addSchuld(widget.doorlopendKrediet);

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
        child: scrollView);
  }
}

class DoorlopendKredietInvulPanel extends StatefulWidget {
  final DoorlopendKredietModel doorlopendKredietModel;
  final GlobalKey<FormState> formKey;

  DoorlopendKredietInvulPanel(
      {required this.doorlopendKredietModel, required this.formKey});

  @override
  DoorlopendKredietInvulPanelState createState() {
    return new DoorlopendKredietInvulPanelState();
  }
}

class DoorlopendKredietInvulPanelState
    extends State<DoorlopendKredietInvulPanel>
    with SingleTickerProviderStateMixin {
  late DoorlopendKredietModel doorlopendKredietModel =
      widget.doorlopendKredietModel..doorlopendKredietInvulPanelState = this;
  late DoorlopendKrediet dk = doorlopendKredietModel.dk;

  late TextEditingController _tecOmschrijving =
      TextEditingController(text: dk.omschrijving);
  late TextEditingController _tecBedrag =
      TextEditingController(text: nf.parseDblToText(dk.bedrag));
  late FocusNode _fnOmschrijving = FocusNode()
    ..addListener(() {
      if (!_fnOmschrijving.hasFocus) {
        _veranderingOmschrijving(_tecOmschrijving.text);
      }
    });
  late FocusNode _fnBedrag = FocusNode()
    ..addListener(() {
      if (!_fnBedrag.hasFocus) {
        _veranderingBedrag(_tecBedrag.text);
      }
    });
  late AnimationController _animationControllerEindDatum = AnimationController(
    value: dk.heeftEindDatum ? 1 : 0,
    vsync: this,
    duration: Duration(milliseconds: 200),
  );

  late MyNumberFormat nf = MyNumberFormat(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DoorlopendKredietInvulPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _tecOmschrijving.dispose();
    _tecBedrag.dispose();
    _fnOmschrijving.dispose();
    _fnBedrag.dispose();
    _animationControllerEindDatum.dispose();
    doorlopendKredietModel.doorlopendKredietInvulPanelState = null;
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    final list = <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: OmschrijvingTextField(
            textEditingController: _tecOmschrijving,
            focusNode: _fnOmschrijving),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: DateWidget(
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
      ),
      Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 32.0, bottom: 8.0),
        child: Text(
          'Einddatum/Krediet:',
        ),
      ),
      CheckboxSimpel(
        title: 'Einddatum',
        value: dk.heeftEindDatum,
        onChanged: (bool? value) {
          _veranderingHeeftEinddatum(value);
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 3,
            child: TextFormField(
                controller: _tecBedrag,
                focusNode: _fnBedrag,
                key: Key('DK_krediet'),
                decoration: new InputDecoration(
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
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                inputFormatters: [
                  MyNumberFormat(context).numberInputFormat('#.00')
                ]),
          ),
          SizedBox(
            width: 16.0,
          ),
          SizeTransition(
            sizeFactor: _animationControllerEindDatum,
            axis: Axis.horizontal,
            child: SizedBox(
              width: 160,
              child: DateWidget(
                date: dk.eindDatum,
                firstDate: dk.beginBereikEindDatum,
                lastDate: dk.eindBereikEindDatum,
                saveDate: (DateTime? date) {
                  _veranderingEinddatum(date);
                },
                changeDate: (DateTime? date) {
                  _veranderingEinddatum(date);
                },
              ),
            ),
          ),
        ]),
      )
    ];

    return Form(
        key: widget.formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }

  _veranderingBegindatum(DateTime? date) {
    if (date != null) {
      doorlopendKredietModel.veranderingBegindatum(date);
    }
  }

  _veranderingHeeftEinddatum(bool? date) {
    doorlopendKredietModel.veranderingHeeftEinddatum(date ?? false);
  }

  _veranderingEinddatum(DateTime? date) {
    if (date != null && dk.heeftEindDatum) {
      doorlopendKredietModel.veranderingEinddatum(date);
    }
  }

  _veranderingOmschrijving(String? value) {
    doorlopendKredietModel.veranderingOmschrijving(value ?? '');
  }

  _veranderingBedrag(String? value) {
    doorlopendKredietModel
        .veranderingBedrag(value == null ? 0 : nf.parsToDouble(value));
  }

  setHeeftEinddatum(bool value) {
    eindDatumAnimation();
    setState(() {});
  }

  setNieuwEindDatum(DateTime value) {
    setState(() {});
  }

  eindDatumAnimation() {
    if (dk.heeftEindDatum) {
      _animationControllerEindDatum.forward();
    } else {
      _animationControllerEindDatum.reverse();
    }
  }
}
