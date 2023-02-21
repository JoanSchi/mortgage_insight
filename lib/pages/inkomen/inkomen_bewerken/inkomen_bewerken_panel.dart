// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';

import 'package:mortgage_insight/layout/transition/scale_size_transition.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import 'package:mortgage_insight/utilities/MyNumberFormat.dart';
import 'package:mortgage_insight/utilities/date.dart';
import 'package:mortgage_insight/utilities/message_listeners.dart';

import '../../../model/nl/inkomen/inkomen.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../my_widgets/selectable_widgets/single_checkbox.dart';
import '../../../platform_page_format/default_page.dart';
import '../../../platform_page_format/page_properties.dart';
import '../../../utilities/device_info.dart';
import 'inkomen_bewerken_model.dart';
import 'inkomen_bewerken.dart';

class IncomeEdit extends ConsumerStatefulWidget {
  const IncomeEdit({Key? key}) : super(key: key);

  @override
  ConsumerState<IncomeEdit> createState() => IncomeEditState();
}

class UpdateInkomenBrutoTextField {
  final PeriodeInkomen periodeInkomen;
  final bool pensioen;
  UpdateInkomenBrutoTextField({
    required this.periodeInkomen,
    required this.pensioen,
  });

  @override
  bool operator ==(covariant UpdateInkomenBrutoTextField other) {
    if (identical(this, other)) return true;

    return other.periodeInkomen == periodeInkomen && other.pensioen == pensioen;
  }

  @override
  int get hashCode => periodeInkomen.hashCode ^ pensioen.hashCode;
}

class IncomeEditState extends ConsumerState<IncomeEdit> {
  final MessageListener<AcceptCancelBackMessage> _messageListeners =
      MessageListener<AcceptCancelBackMessage>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool partner = ref.watch(
        inkomenBewerkenProvider.select((value) => value.inkomen.partner));
    final theme = Theme.of(context);

    final save = PageActionItem(
        text: 'Opslaan',
        icon: Icons.done,
        voidCallback: () => _messageListeners
            .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.accept)));

    final cancel = PageActionItem(
        text: 'Annuleren',
        icon: Icons.arrow_back,
        voidCallback: () => _messageListeners
            .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)));

    return DefaultPage(
        title: 'Inkomen',
        imageBuilder: (_) => Image(
            image: AssetImage(
              partner ? 'graphics/persons.png' : 'graphics/person.png',
            ),
            color: theme.colorScheme.onSurface),
        matchPageProperties: [
          MatchPageProperties(
              pageProperties:
                  PageProperties(rightBottomActions: [cancel, save])),
          MatchPageProperties(
            types: {FormFactorType.SmallPhone, FormFactorType.LargePhone},
            orientations: {Orientation.landscape},
            pageProperties: PageProperties(
                leftTopActions: [cancel], rightTopActions: [save]),
          )
        ],
        bodyBuilder: ({required BuildContext context, required bool nested}) =>
            IncomeFieldForm(
              messageListeners: _messageListeners,
              nested: nested,
            ));
  }
}

class IncomeFieldForm extends ConsumerStatefulWidget {
  final MessageListener<AcceptCancelBackMessage> messageListeners;

  final bool nested;

  IncomeFieldForm({
    Key? key,
    required this.messageListeners,
    required this.nested,
  }) : super(key: key);

  @override
  IncomeFieldFormState createState() => IncomeFieldFormState();
}

DateTime firstSelectableDate = DateTime(2000, 1);
DateTime lastSelectableDate = DateTime(2070, 12);

class IncomeFieldFormState extends ConsumerState<IncomeFieldForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brutoInkomenController =
      TextEditingController(text: firstTextInkomen());

  late final nf = MyNumberFormat(context);
  final bedrageRegExp = RegExp(r'^[0-9]+([.|,][0-9]{0,2})?');
  late final TextInputFormatter bedragFilter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+([.|,][0-9]{0,2})?'));

  InkomenBewerken get _read => ref.read(inkomenBewerkenProvider);

  InkomenNotifier get _notifier {
    return ref.read(inkomenBewerkenProvider.notifier);
  }

  String firstTextInkomen() {
    final InkomenBewerken r = _read;
    if (r.origineleDatum == DateTime(0)) {
      return '';
    } else {
      return nf.parseDoubleToText(r.inkomen.brutoInkomen);
    }
  }

  @override
  void dispose() {
    _brutoInkomenController.dispose();
    super.dispose();
  }

  String tekstPensioenBlok() {
    final blokDatum = _read.blokDatum;

    final maandJaar =
        DateFormat.yMMMM(localeToString(context)).format(blokDatum);

    switch (blokDatum.compareTo(_read.inkomen.datum)) {
      case -1:
        return 'Pensioen gerechtigd sinds $maandJaar';
      case 1:
        return 'Niet pensioen gerechtigd, tenminste tot $maandJaar';
      default:
        {
          return 'Pensioen gerechtigd geblokt om ombekende reden';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    InkomenBewerken bewerken = ref.watch(inkomenBewerkenProvider);

    final theme = DeviceScreen3.of(context);
    bool formatWithUnfocus;
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        {
          formatWithUnfocus = true;
          break;
        }

      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        {
          formatWithUnfocus = false;
        }
        break;
    }

    String monthFormat = 'M-y';

    List<Widget> children = [
      DateInputPicker(
          additionalDividers: const ['/', '.', '-'],
          formatWithUnfocus: formatWithUnfocus,
          format: monthFormat,
          labelText: 'Month/Year',
          formatHint: monthFormat,
          dateMode: DateMode.monthYear,
          textInputAction: TextInputAction.next,
          dividerVisible: DividerVisible.auto,
          date: bewerken.inkomen.datum,
          firstDate: firstSelectableDate,
          lastDate: lastSelectableDate,
          changeDate: _veranderingDatum,
          saveDate: _veranderingDatum),
      const SizedBox(
        height: 8.0,
      ),
      bewerken.pensioenKeuze
          ? MyCheckbox(
              text: 'Pensioen gerechtigd',
              value: bewerken.inkomen.pensioen,
              onChanged: _veranderingPensioen)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 4.0,
                ),
                Text(tekstPensioenBlok(),
                    style: const TextStyle(fontStyle: FontStyle.italic))
              ],
            ),
      SizedBox(
        height: 16.0,
      ),
      Text('Bruto pensioen jaarinkomen:'),
      SizedBox(
        height: 8.0,
      ),
      UndefinedSelectableGroup(
        groups: [
          MyRadioGroup<PeriodeInkomen>(
              list: [
                RadioSelectable(text: 'jaarbedrag', value: PeriodeInkomen.jaar),
                RadioSelectable(text: 'maanddrag', value: PeriodeInkomen.maand)
              ],
              groupValue: bewerken.inkomen.periodeInkomen,
              onChange: (PeriodeInkomen? value) =>
                  _veranderingPeriodeInkomen(value))
        ],
      ),
      TextFormField(
          controller: _brutoInkomenController,
          keyboardType: TextInputType.number,
          inputFormatters: [bedragFilter],
          decoration: InputDecoration(
              labelText:
                  'Inkomen (${bewerken.inkomen.periodeInkomen == PeriodeInkomen.jaar ? 'J' : 'M'})',
              hintText: 'Bruto pensioen jaarbedrag'),
          validator: validateBedrag,
          onSaved: (String? value) => _veranderingBrutoInkomen(
                value,
              )),
      const SizedBox(
        height: 8.0,
      ),
      AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: bewerken.inkomen.pensioen
            ? SizedBox.shrink()
            : UndefinedSelectableGroup(groups: [
                MyCheckGroup<String>(
                  list: [
                    CheckSelectable(
                        identifier: 'vakantie',
                        text: 'Vakantiegeld (%)',
                        value: bewerken.inkomen.vakantiegeld),
                    CheckSelectable(
                        identifier: '13',
                        text: 'Dertiendemaand',
                        value: bewerken.inkomen.dertiendeMaand)
                  ],
                  onChange: (identifier, value) {
                    switch (identifier) {
                      case 'vakantie':
                        {
                          _veranderingVakantiegeld(!value);
                          break;
                        }
                      case '13':
                        {
                          _veranderingDertiendeMaand(!value);
                        }
                    }
                  },
                )
              ]),
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleResizedTransition(
            child: child,
            scale: animation,
          );
        },
      )
    ];

    final formField = Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            if (widget.nested)
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber
                // above.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return children[index];
              }, childCount: children.length),
            )
          ],
        ));

    return MessageListenerWidget<AcceptCancelBackMessage>(
        listener: widget.messageListeners,
        onMessage: (AcceptCancelBackMessage message) {
          switch (message.msg) {
            case AcceptCancelBack.accept:
              save();
              break;
            case AcceptCancelBack.cancel:
              cancel();
              break;
            case AcceptCancelBack.back:
              break;
          }
        },
        child: formField);
  }

  _veranderingDatum(DateTime? value) {
    if (value == null) return;
    _notifier.veranderingDatum(value);
  }

  _veranderingPensioen(bool? value) {
    _notifier.veranderingPensioen(value ?? false);
  }

  _veranderingPeriodeInkomen(PeriodeInkomen? value) {
    _notifier.veranderingJaarInkomenUit(value ?? PeriodeInkomen.jaar);
  }

  _veranderingBrutoInkomen(String? value) {
    _notifier.veranderingBrutoInkomen(nf.parsToDouble(value));
  }

  _veranderingVakantiegeld(bool? value) {
    assert(value != null, 'Verandering Vakantiegeld kan niet nul zijn');
    _notifier.veranderingVakantiegeld(value!);
  }

  _veranderingDertiendeMaand(bool? value) {
    assert(value != null, 'Verandering Dertiendemaand kan niet nul zijn');
    _notifier.veranderingDertiendeMaand(value!);
  }

  String? validateBedrag(String? value) {
    if (nf.parsToDouble(value) != 0.0) {
      return null;
    } else {
      return 'Bedrag in ##.00';
    }
  }

  save() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      ref.read(hypotheekContainerProvider).addInkomen(
            oldDate: _read.origineleDatum,
            newItem: _read.inkomen,
          );

      context.pop();
    }
  }

  cancel() {
    context.pop();
  }
}
