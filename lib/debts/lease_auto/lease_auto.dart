import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/debts/date_picker.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_lease_auto.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:go_router/go_router.dart';
import '../../template_mortgage_items/AcceptCancelActions.dart';
import '../../utilities/Kalender.dart';
import '../../utilities/MyNumberFormat.dart';
import 'lease_auto_model.dart';
import 'lease_auto_overzicht.dart';

class LeaseAutoPanel extends ConsumerStatefulWidget {
  final OperationalLeaseAuto operationalLeaseAuto;
  final MessageListener<AcceptCancelBackMessage> messageListener;

  const LeaseAutoPanel(
      {Key? key,
      required this.operationalLeaseAuto,
      required this.messageListener})
      : super(key: key);

  @override
  ConsumerState<LeaseAutoPanel> createState() => _LeaseAutoPanelState();
}

class _LeaseAutoPanelState extends ConsumerState<LeaseAutoPanel> {
  late LeaseAutoModel _leaseAutoModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _leaseAutoModel = LeaseAutoModel(ola: widget.operationalLeaseAuto);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    updateModel();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(LeaseAutoPanel oldWidget) {
    updateModel();
    super.didUpdateWidget(oldWidget);
  }

  updateModel() {
    if (_leaseAutoModel.ola != widget.operationalLeaseAuto) {
      _leaseAutoModel = LeaseAutoModel(ola: widget.operationalLeaseAuto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate.fixed([
        LeasAutoInvulPanel(leaseAutoModel: _leaseAutoModel, formKey: _formKey),
      ])),
      OverzichtLeaseAuto(
        leaseAutoModel: _leaseAutoModel,
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
                      .addSchuld(widget.operationalLeaseAuto);

                  scheduleMicrotask(() {
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

class LeasAutoInvulPanel extends StatefulWidget {
  final LeaseAutoModel leaseAutoModel;
  final GlobalKey<FormState> formKey;

  LeasAutoInvulPanel({required this.leaseAutoModel, required this.formKey});

  @override
  LeasAutoInvulPanelState createState() {
    return LeasAutoInvulPanelState();
  }
}

class LeasAutoInvulPanelState extends State<LeasAutoInvulPanel> {
  late TextEditingController _tecOmschrijving =
      TextEditingController(text: ola.omschrijving);
  late TextEditingController _tecBedrag = TextEditingController(
      text: ola.mndBedrag == 0.0 ? '' : nf.parseDoubleToText(ola.mndBedrag));
  late TextEditingController _tecJaren = TextEditingController(
      text: ola.jaren == 0.0 ? '' : nf.parseIntToText(ola.jaren));
  late TextEditingController _tecMaanden = TextEditingController(
      text: ola.maanden == 0.0 ? '' : nf.parseIntToText(ola.maanden));
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
  late FocusNode _fnJaren = FocusNode()
    ..addListener(() {
      if (!_fnJaren.hasFocus) {
        _veranderingJaren(_tecJaren.text);
      }
    });
  late FocusNode _fnMaanden = FocusNode()
    ..addListener(() {
      if (!_fnMaanden.hasFocus) {
        _veranderingMaanden(_tecMaanden.text);
      }
    });

  late MyNumberFormat nf = MyNumberFormat(context);

  late LeaseAutoModel leaseAutoModel = widget.leaseAutoModel
    ..leasAutoPanelState = this;
  OperationalLeaseAuto get ola => leaseAutoModel.ola;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void didUpdateWidget(LeasAutoInvulPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    leaseAutoModel.leasAutoPanelState = null;
    _tecOmschrijving.dispose();
    _tecBedrag.dispose();
    _tecJaren.dispose();
    _tecMaanden.dispose();
    _fnOmschrijving.dispose();
    _fnBedrag.dispose();
    _fnJaren.dispose();
    _fnMaanden.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year - 10, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    return Form(
      key: widget.formKey,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: OmschrijvingTextField(
              textEditingController: _tecOmschrijving,
              focusNode: _fnOmschrijving),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: DateWidget(
            date: ola.beginDatum,
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
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                      controller: _tecBedrag,
                      focusNode: _fnBedrag,
                      key: Key('leaseBedrag'),
                      decoration: new InputDecoration(
                          hintText: 'Maandbedrag', labelText: 'Bedrag (M)'),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return 'Leasebedrag?';
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
                      ],
                      textInputAction: TextInputAction.next),
                ),
                SizedBox(width: 24.0),
                SizedBox(
                  width: 80.0,
                  child: TextFormField(
                      controller: _tecJaren,
                      focusNode: _fnJaren,
                      key: Key('jaar'),
                      decoration: new InputDecoration(
                          hintText: 'Jaren', labelText: 'Periode (J)'),
                      validator: (String? text) {
                        if ((text?.isEmpty ?? true) && ola.maanden == 0) {
                          return 'Jaren en/of';
                        }
                        return null;
                      },
                      onSaved: (String? text) {
                        _veranderingJaren(text);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MyNumberFormat(context).numberInputFormat('00')
                      ],
                      textInputAction: TextInputAction.next),
                ),
                SizedBox(width: 24.0),
                SizedBox(
                  width: 85.0,
                  child: TextFormField(
                      controller: _tecMaanden,
                      focusNode: _fnMaanden,
                      key: Key('maanden'),
                      decoration: new InputDecoration(
                          hintText: 'Maanden', labelText: 'Periode (M)'),
                      validator: (text) {
                        if ((text?.isEmpty ?? true) && ola.jaren == 0) {
                          return 'maanden?';
                        }
                        return null;
                      },
                      onSaved: (String? text) {
                        _veranderingMaanden(text);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MyNumberFormat(context).numberInputFormat('00')
                      ]),
                ),
              ]),
        )
      ]),
    );
  }

  _veranderingOmschrijving(String? value) {
    leaseAutoModel.veranderingOmschrijving(value ?? '');
  }

  _veranderingDatum(DateTime? date) {
    if (date != null) {
      leaseAutoModel.veranderingDatum(date);
    }
  }

  _veranderingBedrag(String? value) {
    leaseAutoModel
        .veranderingBedrag(value == null ? 0.0 : nf.parsToDouble(value));
  }

  _veranderingJaren(String? value) {
    leaseAutoModel.veranderingJaren(value == null ? 0 : nf.parsToInt(value));
  }

  _veranderingMaanden(String? value) {
    leaseAutoModel.veranderingMaanden(value == null ? 0 : nf.parsToInt(value));
  }
}
