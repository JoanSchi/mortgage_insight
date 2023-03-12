import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/my_widgets/simple_widgets.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../utilities/my_number_format.dart';
import 'lease_auto_overzicht.dart';

class LeaseAutoPanel extends StatelessWidget {
  final double topPadding;
  final double bottomPadding;

  const LeaseAutoPanel(
      {Key? key, required this.topPadding, required this.bottomPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate.fixed([
        SizedBox(
          height: topPadding,
        ),
        LeasAutoInvulPanel(),
        OverzichtLeaseAuto(),
        SizedBox(
          height: bottomPadding,
        ),
      ])),
    ]);
  }
}

class LeasAutoInvulPanel extends ConsumerStatefulWidget {
  LeasAutoInvulPanel();

  @override
  LeasAutoInvulPanelState createState() {
    return LeasAutoInvulPanelState();
  }
}

class LeasAutoInvulPanelState extends ConsumerState<LeasAutoInvulPanel> {
  late final TextEditingController _tecOmschrijving =
      TextEditingController(text: toText((LeaseAuto a) => a.omschrijving));
  late final TextEditingController _tecBedrag =
      TextEditingController(text: doubleToText((LeaseAuto a) => a.mndBedrag));
  late final TextEditingController _tecJaren =
      TextEditingController(text: intToText((LeaseAuto a) => a.jaren));
  late final TextEditingController _tecMaanden =
      TextEditingController(text: intToText((LeaseAuto a) => a.maanden));
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
  late final FocusNode _fnJaren = FocusNode()
    ..addListener(() {
      if (!_fnJaren.hasFocus) {
        _veranderingJaren(_tecJaren.text);
      }
    });
  late final FocusNode _fnMaanden = FocusNode()
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

  SchuldBewerkNotifier get notifier => ref.read(schuldProvider.notifier);

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
    return Column(children: [
      const SizedBox(
        height: 6.0,
      ),
      OmschrijvingTextField(
          textEditingController: _tecOmschrijving, focusNode: _fnOmschrijving),
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
      const SizedBox(
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
                  key: const Key('leaseBedrag'),
                  decoration: const InputDecoration(
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
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  inputFormatters: [
                    MyNumberFormat(context).numberInputFormat('#.00')
                  ],
                  textInputAction: TextInputAction.next),
            ),
            const SizedBox(width: 24.0),
            SizedBox(
              width: 80.0,
              child: TextFormField(
                  controller: _tecJaren,
                  focusNode: _fnJaren,
                  key: Key('jaar'),
                  decoration: const InputDecoration(
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
            const SizedBox(width: 24.0),
            SizedBox(
              width: 85.0,
              child: TextFormField(
                  controller: _tecMaanden,
                  focusNode: _fnMaanden,
                  key: const Key('maanden'),
                  decoration: const InputDecoration(
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
    ]);
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
