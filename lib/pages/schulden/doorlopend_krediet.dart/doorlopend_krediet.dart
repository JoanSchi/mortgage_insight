import 'dart:async';
import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/schulden/doorlopendkrediet_verwerken.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:go_router/go_router.dart';
import '../../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../../my_widgets/selectable_widgets/single_checkbox.dart';
import '../../../my_widgets/simple_widgets.dart';
import '../../../utilities/message_listeners.dart';
import '../../../utilities/Kalender.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../schuld_provider.dart';
import 'doorlopend_krediet_overzicht.dart';

class DoorlopendKredietPanel extends ConsumerStatefulWidget {
  final MessageListener<AcceptCancelBackMessage> messageListener;

  const DoorlopendKredietPanel({Key? key, required this.messageListener})
      : super(key: key);

  @override
  ConsumerState<DoorlopendKredietPanel> createState() =>
      _DoorlopendKredietPanelState();
}

class _DoorlopendKredietPanelState
    extends ConsumerState<DoorlopendKredietPanel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final scrollView = CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate.fixed([
        DoorlopendKredietInvulPanel(formKey: _formKey),
      ])),
      OverzichtDoorlopendKrediet()
    ]);

    return MessageListenerWidget<AcceptCancelBackMessage>(
        listener: widget.messageListener,
        onMessage: (AcceptCancelBackMessage message) {
          switch (message.msg) {
            case AcceptCancelBack.accept:
              FocusScope.of(context).unfocus();

              scheduleMicrotask(() {
                if ((_formKey.currentState?.validate() ?? false)) {
                  Schuld? schuld = ref.read(schuldProvider).schuld;

                  if (schuld != null) {
                    ref
                        .read(hypotheekContainerProvider.notifier)
                        .addSchuld(schuld);
                  }

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

class DoorlopendKredietInvulPanel extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;

  DoorlopendKredietInvulPanel({required this.formKey});

  @override
  ConsumerState<DoorlopendKredietInvulPanel> createState() {
    return new DoorlopendKredietInvulPanelState();
  }
}

class DoorlopendKredietInvulPanelState
    extends ConsumerState<DoorlopendKredietInvulPanel>
    with SingleTickerProviderStateMixin {
  late TextEditingController _tecOmschrijving =
      TextEditingController(text: toText((dk) => dk.omschrijving));
  late TextEditingController _tecBedrag =
      TextEditingController(text: doubleToText((dk) => dk.bedrag));
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
    value: (dk?.heeftEindDatum ?? false) ? 1 : 0,
    vsync: this,
    duration: Duration(milliseconds: 200),
  );

  late MyNumberFormat nf = MyNumberFormat(context);

  SchuldNotifier get notifier => ref.read(schuldProvider.notifier);

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
        OhNo(text: 'DoorlopendKrediet fout');
  }

  Widget _build(BuildContext context, DoorlopendKrediet dk) {
    final dateNow = DateTime.now();
    final firstDate = DateTime(dateNow.year, 1, 1);
    final lastDate = DateTime(dateNow.year + 10, 12,
        Kalender.dagenPerMaand(jaar: dateNow.year + 10, maand: 12));

    final list = <Widget>[
      SizedBox(
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
      Text(
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
              key: Key('DK_krediet'),
              decoration:
                  new InputDecoration(hintText: 'limiet', labelText: 'Krediet'),
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

    return Form(
        key: widget.formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: list));
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
