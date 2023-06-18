// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beamer/beamer.dart';
import 'package:date_input_picker/date_input_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/inkomen/gegevens/inkomen.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import 'package:mortgage_insight/layout/transition/scale_size_transition.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import 'package:mortgage_insight/utilities/date.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../my_widgets/selectable_widgets/single_checkbox.dart';
import '../../../platform_page_format/default_match_page_properties.dart';
import '../../../platform_page_format/default_page.dart';
import '../../../utilities/device_info.dart';
import 'inkomen_bewerken_model.dart';
import 'inkomen_bewerken_view_state.dart';

class InkomenBewerken extends ConsumerStatefulWidget {
  const InkomenBewerken({super.key});

  @override
  ConsumerState<InkomenBewerken> createState() => IncomeEditState();
}

class IncomeEditState extends ConsumerState<InkomenBewerken> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool partner = ref.watch(
        inkomenBewerkenViewProvider.select((value) => value.inkomen.partner));
    final theme = Theme.of(context);

    final save = PageActionItem(
        text: 'Opslaan',
        icon: Icons.done,
        voidCallback: () {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState!.save();

            final bewerkenProvider = ref.read(inkomenBewerkenViewProvider);

            ref.read(hypotheekDocumentProvider.notifier).inkomenToevoegen(
                  oldDate: bewerkenProvider.origineleDatum,
                  newItem: bewerkenProvider.inkomen,
                );

            Beamer.of(context, root: true).popToNamed('/document/inkomen');
          }
        });

    final cancel = PageActionItem(
        text: 'Annuleren',
        icon: Icons.arrow_back,
        voidCallback: () =>
            Beamer.of(context, root: true).popToNamed('/document/inkomen'));

    return DefaultPage(
      title: 'Inkomen',
      imageBuilder: (_) => Image(
          image: AssetImage(
            partner ? 'graphics/persons.png' : 'graphics/person.png',
          ),
          color: theme.colorScheme.onSurface),
      getPageProperties: (
              {required hasScrollBars,
              required formFactorType,
              required orientation,
              required bottom}) =>
          hypotheekPageProperties(
              hasScrollBars: hasScrollBars,
              formFactorType: formFactorType,
              orientation: orientation,
              bottom: bottom,
              leftTopActions: [cancel],
              rightTopActions: [save]),
      sliversBuilder: (
              {required BuildContext context,
              Widget? appBar,
              required EdgeInsets padding}) =>
          Form(
              key: _formKey,
              child: IncomeFieldForm(
                padding: padding,
                appBar: appBar,
              )),
    );
  }
}

class IncomeFieldForm extends ConsumerStatefulWidget {
  final EdgeInsets padding;
  final Widget? appBar;

  const IncomeFieldForm({
    Key? key,
    required this.padding,
    required this.appBar,
  }) : super(key: key);

  @override
  IncomeFieldFormState createState() => IncomeFieldFormState();
}

class IncomeFieldFormState extends ConsumerState<IncomeFieldForm> {
  DateTime firstSelectableDate = DateTime(2000, 1);
  DateTime lastSelectableDate = DateTime(2070, 12);
  late final TextEditingController _brutoInkomenController =
      TextEditingController(text: firstTextInkomen());

  late final nf = MyNumberFormat(context);
  final bedrageRegExp = RegExp(r'^[0-9]+([.|,][0-9]{0,2})?');
  late final TextInputFormatter bedragFilter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+([.|,][0-9]{0,2})?'));

  InkomenBewerkenViewState get _read => ref.read(inkomenBewerkenViewProvider);

  InkomenBewerkenViewModelNotifier get _notifier {
    return ref.read(inkomenBewerkenViewProvider.notifier);
  }

  String firstTextInkomen() {
    final InkomenBewerkenViewState r = _read;
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
    InkomenBewerkenViewState bewerken = ref.watch(inkomenBewerkenViewProvider);

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
                const SizedBox(
                  width: 4.0,
                ),
                Text(tekstPensioenBlok(),
                    style: const TextStyle(fontStyle: FontStyle.italic))
              ],
            ),
      const SizedBox(
        height: 16.0,
      ),
      const Text('Bruto pensioen jaarinkomen:'),
      const SizedBox(
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
        duration: const Duration(milliseconds: 300),
        child: bewerken.inkomen.pensioen
            ? const SizedBox.shrink()
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
            scale: animation,
            child: child,
          );
        },
      ),
    ];

    final appBar = widget.appBar;
    return CustomScrollView(
      slivers: [
        if (appBar != null) appBar,
        SliverPadding(
            padding: widget.padding,
            sliver:
                SliverList(delegate: SliverChildListDelegate.fixed(children)))
      ],
    );
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
}
