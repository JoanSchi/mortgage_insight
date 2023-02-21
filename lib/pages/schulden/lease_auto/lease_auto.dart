import 'dart:async';

import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../utilities/message_listeners.dart';
import '../../../utilities/MyNumberFormat.dart';
import 'lease_auto_overzicht.dart';

class LeaseAutoPanel extends ConsumerStatefulWidget {
  final MessageListener<AcceptCancelBackMessage> messageListener;

  const LeaseAutoPanel({Key? key, required this.messageListener})
      : super(key: key);

  @override
  ConsumerState<LeaseAutoPanel> createState() => _LeaseAutoPanelState();
}

class _LeaseAutoPanelState extends ConsumerState<LeaseAutoPanel> {
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
  void didUpdateWidget(LeaseAutoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate.fixed([
        LeasAutoInvulPanel(formKey: _formKey),
      ])),
      OverzichtLeaseAuto()
    ]);

    return MessageListenerWidget<AcceptCancelBackMessage>(
        listener: widget.messageListener,
        onMessage: (AcceptCancelBackMessage message) {
          switch (message.msg) {
            case AcceptCancelBack.accept:
              FocusScope.of(context).unfocus();

              scheduleMicrotask(() {
                if ((_formKey.currentState?.validate() ?? false)) {
                  final schuld = ref.read(schuldProvider).schuld;
                  if (schuld != null) {
                    ref
                        .read(hypotheekContainerProvider.notifier)
                        .addSchuld(schuld);
                  }

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

class LeasAutoInvulPanel extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  LeasAutoInvulPanel({required this.formKey});

  @override
  LeasAutoInvulPanelState createState() {
    return LeasAutoInvulPanelState();
  }
}

class LeasAutoInvulPanelState extends ConsumerState<LeasAutoInvulPanel> {
  late TextEditingController _tecOmschrijving =
      TextEditingController(text: toText((LeaseAuto a) => a.omschrijving));
  late TextEditingController _tecBedrag =
      TextEditingController(text: doubleToText((LeaseAuto a) => a.mndBedrag));
  late TextEditingController _tecJaren =
      TextEditingController(text: intToText((LeaseAuto a) => a.jaren));
  late TextEditingController _tecMaanden =
      TextEditingController(text: intToText((LeaseAuto a) => a.maanden));
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

  String toText(Function(LeaseAuto leaseAuto) toText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            leaseAuto: (LeaseAuto leaseAuto) => toText(leaseAuto)) ??
        '';
  }

  String doubleToText(double Function(LeaseAuto leaseAuto) doubleToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            leaseAuto: (LeaseAuto leaseAuto) {
          final value = doubleToText(leaseAuto);
          return value == 0.0 ? '' : nf.parseDblToText(doubleToText(leaseAuto));
        }) ??
        '';
  }

  String intToText(int Function(LeaseAuto leaseAuto) intToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            leaseAuto: (LeaseAuto leaseAuto) {
          final value = intToText(leaseAuto);
          return value == 0.0 ? '' : '$value';
        }) ??
        '';
  }

  late MyNumberFormat nf = MyNumberFormat(context);

  SchuldNotifier get notifier => ref.read(schuldProvider.notifier);

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
    return ref.watch(schuldProvider.select((value) => value.schuld))?.mapOrNull(
            leaseAuto: (LeaseAuto leaseAuto) =>
                buildLeaseAuto(context, leaseAuto)) ??
        OhNo(text: 'AutoLease is null!');
  }

  buildLeaseAuto(BuildContext context, LeaseAuto leaseAuto) {
    final dateNow = DateTime.now();
    final firstDate = DateTime(2016, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12, 1);
    return Form(
      key: widget.formKey,
      child: Column(children: [
        const SizedBox(
          height: 6.0,
        ),
        OmschrijvingTextField(
            textEditingController: _tecOmschrijving,
            focusNode: _fnOmschrijving),
        DateInputPicker(
          date: leaseAuto.beginDatum,
          firstDate: firstDate,
          lastDate: lastDate,
          saveDate: (DateTime? date) {
            _veranderingDatum(date);
          },
          changeDate: (DateTime? date) {
            _veranderingDatum(date);
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
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
                      if ((text?.isEmpty ?? true) && leaseAuto.maanden == 0) {
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
                      if ((text?.isEmpty ?? true) && leaseAuto.jaren == 0) {
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
            ])
      ]),
    );
  }

  _veranderingOmschrijving(String? value) {
    notifier.veranderingOmschrijving(value ?? '');
  }

  _veranderingDatum(DateTime? date) {
    notifier.veranderingLeaseAuto(datum: date);
  }

  _veranderingBedrag(String? value) {
    notifier.veranderingLeaseAuto(bedrag: nf.parsToDouble(value));
  }

  _veranderingJaren(String? value) {
    if (value == null) return;
    notifier.veranderingLeaseAuto(jaren: nf.parsToInt(value));
  }

  _veranderingMaanden(String? value) {
    if (value == null) return;
    notifier.veranderingLeaseAuto(maanden: nf.parsToInt(value));
  }
}
