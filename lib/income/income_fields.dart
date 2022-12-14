import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/layout/transition/scale_size_transition.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/model/nl/inkomen/inkomen.dart';
import 'package:mortgage_insight/my_widgets/calender_date_picker/month_year_picker.dart';
import 'package:mortgage_insight/state_manager/widget_state.dart';
import 'package:mortgage_insight/template_mortgage_items/AcceptCancelActions.dart';
import 'package:mortgage_insight/utilities/MyNumberFormat.dart';
import 'package:mortgage_insight/utilities/date.dart';
import '../my_widgets/my_page/my_page.dart';
import 'income_model.dart';

final MessageListener<AcceptCancelBackMessage> _messageListeners =
    MessageListener<AcceptCancelBackMessage>();

class IncomeEdit extends ConsumerStatefulWidget {
  const IncomeEdit({Key? key}) : super(key: key);

  @override
  ConsumerState<IncomeEdit> createState() => IncomeEditState();
}

class IncomeEditState extends ConsumerState<IncomeEdit> {
  InkomenModel? inkomenModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    updateModel();
    super.didChangeDependencies();
  }

  updateModel() {
    BewerkenInkomen? bewerkenInkomen = ref.read(routeEditPageProvider).object;

    assert(bewerkenInkomen != null,
        'BewerkenInkomen mag niet null zijn in IncomeEdit');

    if (bewerkenInkomen != null) {
      if (bewerkenInkomen != inkomenModel?.bewerkenInkomen) {
        inkomenModel = InkomenModel(bewerkenInkomen: bewerkenInkomen);
      }
    } else {
      inkomenModel = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (inkomenModel == null) {
      return Text(
        ':(',
        textScaleFactor: 24.0,
      );
    } else {
      return MyPage(
          title: 'Inkomen',
          backgroundColor: Colors.white,
          imageName: inkomenModel!.inkomen.partner
              ? 'graphics/fit_persons.png'
              : 'graphics/fit_person.png',
          body: AcceptCanelPanel(
              accept: () => _messageListeners.invoke(
                  AcceptCancelBackMessage(msg: AcceptCancelBack.accept)),
              cancel: () => _messageListeners.invoke(
                  AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)),
              child: EditScrollable(children: [
                IncomeFieldForm(
                  inkomenModel: inkomenModel!,
                )
              ])));
    }
  }
}

class IncomeFieldForm extends ConsumerStatefulWidget {
  final InkomenModel inkomenModel;

  IncomeFieldForm({
    Key? key,
    required this.inkomenModel,
  }) : super(key: key);

  @override
  IncomeFieldFormState createState() => IncomeFieldFormState();
}

DateTime firstSelectableDate = DateTime(2000, 1);
DateTime lastSelectableDate = DateTime(2070, 12);

class IncomeFieldFormState extends ConsumerState<IncomeFieldForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _brutoJaarInkomenController;
  TextEditingController? _brutoMaandInkomenController;
  TextEditingController? _brutoJaarPensioenInkomenController;
  TextEditingController? _brutoMaandPensioenInkomenController;
  late final nf = MyNumberFormat(context);
  final bedrageRegExp = RegExp(r'^[0-9]+([.|,][0-9]{0,2})?');
  late final TextInputFormatter bedragFilter =
      FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+([.|,][0-9]{0,2})?'));

  Inkomen get _item => inkomenModel.inkomen;
  late List<Inkomen> inkomenLijst;

  late InkomenModel inkomenModel;

  @override
  void initState() {
    inkomenModel = widget.inkomenModel;
    inkomenModel.incomeFieldFormState = this;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  checkDate(DateTime date, {int yearToAdd = 0, int monthToAdd = 0}) {
    date = DateTime(date.year + yearToAdd, date.month + monthToAdd);

    for (Inkomen i in inkomenLijst) {
      final delta = DateUtils.monthDelta(i.datum, date);

      if (delta > 0) {
        return date;
      } else if (delta == 0) {
        date = DateTime(date.year + yearToAdd, date.month + monthToAdd);
      }
    }
  }

  String firstTextInkomen(double value) {
    if (value > 0.0 || inkomenModel.origineleDatum != null) {
      return nf.parseDoubleToText(value);
    } else {
      return '';
    }
  }

  TextEditingController get brutoJaarInkomenController {
    if (_brutoJaarInkomenController == null)
      _brutoJaarInkomenController = TextEditingController(
          text: firstTextInkomen(_item.specificatie.brutoJaar));
    return _brutoJaarInkomenController!;
  }

  TextEditingController get brutoMaandInkomenController {
    if (_brutoMaandInkomenController == null)
      _brutoMaandInkomenController = TextEditingController(
          text: firstTextInkomen(_item.specificatie.brutoMaand));
    return _brutoMaandInkomenController!;
  }

  TextEditingController get brutoJaarPensioenInkomenController {
    if (_brutoJaarPensioenInkomenController == null)
      _brutoJaarPensioenInkomenController = TextEditingController(
          text: firstTextInkomen(_item.pensioenSpecificatie.brutoJaar));
    return _brutoJaarPensioenInkomenController!;
  }

  TextEditingController get brutoMaandPensioenInkomenController {
    if (_brutoMaandPensioenInkomenController == null)
      _brutoMaandPensioenInkomenController = TextEditingController(
          text: firstTextInkomen(_item.pensioenSpecificatie.brutoMaand));
    return _brutoMaandPensioenInkomenController!;
  }

  @override
  void dispose() {
    _brutoJaarInkomenController?.dispose();
    _brutoMaandInkomenController?.dispose();
    _brutoJaarPensioenInkomenController?.dispose();
    _brutoMaandPensioenInkomenController?.dispose();
    inkomenModel.incomeFieldFormState = null;
    super.dispose();
  }

  tekstPensioenBlok() {
    final DateTime? blockDatum =
        inkomenModel.pensioenEvaluatie.blockItem?.datum;

    if (blockDatum == null) {
      return 'blub';
    }

    final maandJaar =
        DateFormat.yMMMM(localeToString(context)).format(blockDatum);

    switch (blockDatum.compareTo(_item.datum)) {
      case -1:
        return 'Pensioen gerechtigd sinds $maandJaar';
      case 1:
        return 'Pensioen gerechtigd op $maandJaar';
      default:
        {
          return 'Pensioen gerechtigd geblokt om ombekende reden';
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      MonthYear(
        date: _item.datum,
        firstDate: firstSelectableDate,
        lastDate: lastSelectableDate,
        changeDate: _veranderingDatum,
        saveDate: _veranderingDatum,
      ),
      inkomenModel.pensioenEvaluatie.enable
          ? Row(
              children: [
                Checkbox(value: _item.pensioen, onChanged: changedPensioen),
                Text('Pensioen gerechtigd')
              ],
            )
          : Text(tekstPensioenBlok())
    ];

    Widget inkomen;

    if (_item.pensioen) {
      inkomen = Column(
        key: Key('pensioen'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 16.0,
          ),
          Text('Bruto pensioen jaarinkomen:'),
          Row(
            children: [
              Radio<JaarInkomenUit>(
                  value: JaarInkomenUit.jaar,
                  groupValue: _item.pensioenSpecificatie.jaarInkomenUit,
                  onChanged: (v) =>
                      _veranderingJaarInkomenUit(v, pensioen: true)),
              Text('jaarbedrag'),
              Radio<JaarInkomenUit>(
                  value: JaarInkomenUit.maand,
                  groupValue: _item.pensioenSpecificatie.jaarInkomenUit,
                  onChanged: (v) =>
                      _veranderingJaarInkomenUit(v, pensioen: true)),
              Text('maanddrag'),
            ],
          ),
          JaarInkomenUit.jaar == _item.pensioenSpecificatie.jaarInkomenUit
              ? TextFormField(
                  key: Key('pensioenJaarDedrag'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [bedragFilter],
                  controller: brutoJaarPensioenInkomenController,
                  decoration: InputDecoration(
                      labelText: 'Inkomen',
                      hintText: 'Bruto pensioen jaarbedrag'),
                  validator: validateBedrag,
                  onSaved: (String? value) =>
                      _veranderingBrutoJaar(value, pensioen: true),
                )
              : TextFormField(
                  key: Key('pensioenMaandDedrag'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [bedragFilter],
                  controller: brutoMaandPensioenInkomenController,
                  decoration: InputDecoration(
                      labelText: 'Inkomen',
                      hintText: 'Bruto pensioen maandbedrag'),
                  validator: validateBedrag,
                  onSaved: (String? value) =>
                      _veranderingBrutoMaand(value, pensioen: true)),
        ],
      );
    } else {
      inkomen = Column(
          key: Key('geen pensioen'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.0,
            ),
            Text('Bruto jaarinkomen:'),
            Row(
              children: [
                Radio<JaarInkomenUit>(
                    value: JaarInkomenUit.jaar,
                    groupValue: _item.specificatie.jaarInkomenUit,
                    onChanged: (v) =>
                        _veranderingJaarInkomenUit(v, pensioen: false)),
                Text('jaarbedrag'),
                Radio<JaarInkomenUit>(
                    value: JaarInkomenUit.maand,
                    groupValue: _item.specificatie.jaarInkomenUit,
                    onChanged: (v) =>
                        _veranderingJaarInkomenUit(v, pensioen: false)),
                Text('maanddrag'),
              ],
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: JaarInkomenUit.jaar == _item.specificatie.jaarInkomenUit
                  ? TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [bedragFilter],
                      controller: brutoJaarInkomenController,
                      decoration: InputDecoration(
                          labelText: 'Inkomen', hintText: 'Bruto jaarbedrag'),
                      validator: validateBedrag,
                      onSaved: _veranderingBrutoJaar,
                    )
                  : Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [bedragFilter],
                          controller: brutoMaandInkomenController,
                          decoration: InputDecoration(
                              labelText: 'Inkomen',
                              hintText: 'Bruto maandbedrag'),
                          validator: validateBedrag,
                          onSaved: _veranderingBrutoMaand,
                        ),
                        Row(children: [
                          Checkbox(
                              value: _item.specificatie.vakantiegeld,
                              onChanged: _veranderingVakantiegeld),
                          Text('Vakantiegeld (8%)')
                        ]),
                        Row(children: [
                          Checkbox(
                              value: _item.specificatie.dertiendeMaand,
                              onChanged: changeDertiendeMaand),
                          Text('Dertiendemaand')
                        ]),
                      ],
                    ),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleResizedTransition(child: child, scale: animation);
              },
            )
          ]);
    }
    children.add(AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: inkomen,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleResizedTransition(child: child, scale: animation);
        }));

    final formField = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )),
    );

    return MessageListenerWidget<AcceptCancelBackMessage>(
        listener: _messageListeners,
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

    inkomenModel.veranderingDatum(value);
  }

  changedPensioen(bool? value) {
    setState(() {
      _item.pensioen = value ?? false;
    });
  }

  _veranderingJaarInkomenUit(JaarInkomenUit? value, {bool pensioen: false}) {
    assert(value != null, 'Verandering Jaar Inkomen niet nul zijn');

    inkomenModel.veranderingJaarInkomenUit(value!, pensioen);
  }

  _veranderingBrutoJaar(String? value, {bool pensioen: false}) {
    inkomenModel.veranderingBrutoJaar(nf.parsToDouble(value), pensioen);
  }

  _veranderingBrutoMaand(String? value, {bool pensioen: false}) {
    inkomenModel.veranderingBrutoMaand(nf.parsToDouble(value), pensioen);
  }

  _veranderingVakantiegeld(bool? value) {
    assert(value != null, 'Verandering Vakantiegeld kan niet nul zijn');
    inkomenModel.veranderingVakantiegeld(value!);
  }

  changeDertiendeMaand(bool? value) {
    assert(value != null, 'Verandering Dertiendemaand kan niet nul zijn');
    inkomenModel.veranderingDertiendeMaand(value!);
  }

  String? validateBedrag(String? value) {
    if (value == null || value.startsWith(bedrageRegExp)) {
      return null;
    } else {
      return 'Bedrag in ##.00';
    }
  }

  save() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      ref.read(hypotheekContainerProvider).addIncome(
          oldDate: inkomenModel.origineleDatum,
          newItem: inkomenModel.inkomen,
          partner: inkomenModel.partner);
    }

    //didpop sets editState of routeEditPageProvider.notifier to null;
    context.pop();
  }

  cancel() {
    //didpop sets editState of routeEditPageProvider.notifier to null;
    context.pop();
  }

  setBrutoJaarInkomen(double value) {
    _brutoJaarInkomenController?.text = nf.parseDoubleToText(value);
  }

  setBrutoMaandInkomen(double value) {
    _brutoMaandInkomenController?.text = nf.parseDoubleToText(value);
  }

  setBrutoJaarInkomenPensioen(double value) {
    _brutoJaarPensioenInkomenController?.text = nf.parseDoubleToText(value);
  }

  setBrutoMaandInkomenPensioen(double value) {
    _brutoMaandPensioenInkomenController?.text = nf.parseDoubleToText(value);
  }

  refreshState() {
    setState(() {});
  }
}

class MonthYear extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? date;
  final changeDate;
  final saveDate;

  MonthYear({
    Key? key,
    required this.date,
    required this.firstDate,
    required this.lastDate,
    required this.changeDate,
    required this.saveDate,
  }) : super(key: key);

  @override
  _MonthYearState createState() => _MonthYearState();
}

class _MonthYearState extends State<MonthYear> {
  late DateTime? _date = widget.date;
  late TextEditingController _dateController;
  final regExpDateInput = RegExp(r'^[0-9]{1,2}([-|.][0-9]{0,4})?');
  final regExpDateValidate = RegExp(r'^[0-9]{1,2}([-|.][0-9]{2,4})');
  FocusNode _dateNode = FocusNode();

  @override
  void initState() {
    _dateController =
        TextEditingController(text: '${_date?.month}-${_date?.year}');
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String monthYearText = _date != null
    //     ? DateFormat.yMMMM(localeToString(context)).format(_date!)
    //     : 'Use: mm-yyyy';

    final textField = Focus(
        onFocusChange: (bool value) {
          if (!value) {
            setDateFromTextField(validateDate(_dateController.text).date);
          }
        },
        child: TextFormField(
          focusNode: _dateNode,
          controller: _dateController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(regExpDateInput)],
          decoration: const InputDecoration(
            // icon: Icon(Icons.person),
            hintText: 'mm-yyyy of mm.yyyy',
            labelText: 'Datum',
            // helperText: monthYearText
          ),
          validator: (String? value) {
            return validateDate(value).error;
          },
          onSaved: (String? value) {
            DateTime? date = validateDate(value).date;
            if (date != null) widget.saveDate(date);
          },
          onFieldSubmitted: (String text) {
            setDateFromTextField(validateDate(text).date);
          },
        ));

    Widget icon = IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          if (_dateNode.hasFocus) {
            _dateNode.unfocus();
          }
          showMonthPicker(
                  context: context,
                  initialDate: _date ?? monthYear(DateTime.now()),
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate)
              .then((value) {
            if (value != null) {
              setDateFromPicker(value);
            }
          });
        });

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Expanded(child: textField), icon],
    );
  }

  setDateFromTextField(DateTime? value) {
    if (widget.changeDate != null) {
      widget.changeDate(value);
    }
    _date = value;
  }

  setDateFromPicker(DateTime value) {
    _date = value;
    _dateController.text = '${value.month}-${value.year}';

    if (widget.changeDate != null) {
      widget.changeDate(value);
    }

    Timer(Duration(milliseconds: 5), () {
      if (_dateNode.hasFocus) {
        if (!_dateNode.nextFocus()) {
          _dateNode.unfocus();
        }
      }
    });
  }

  MonthYearValidated validateDate(String? value) {
    if (value != null) {
      if (value.startsWith(regExpDateValidate)) {
        List<String> split =
            value.contains('-') ? value.split('-') : value.split('.');

        int month = int.parse(split[0]);

        if (month < 1 || month > 12) {
          return MonthYearValidated(error: ' Use mm: 1-12');
        }

        String yearText = split[1];
        int year = 0;

        switch (yearText.length) {
          case 2:
            {
              year = int.parse('20' + yearText);
              break;
            }
          case 4:
            {
              year = int.parse(yearText);
              break;
            }
          default:
            {
              return MonthYearValidated(error: ' Use last yy or yyyy');
            }
        }

        DateTime dateFromInput = DateTime(year, month);

        if (DateUtils.monthDelta(widget.firstDate, dateFromInput) < 0) {
          return MonthYearValidated(error: 'Te ..');
        } else if (DateUtils.monthDelta(widget.lastDate, dateFromInput) > 0) {
          return MonthYearValidated(error: 'Te ...');
        } else {
          return MonthYearValidated(date: dateFromInput);
        }
      } else {
        return MonthYearValidated(error: 'Use mm-yyyy');
      }
    }
    return MonthYearValidated(error: 'Empty');
  }
}

class MonthYearValidated {
  DateTime? date;
  String? error;
  MonthYearValidated({
    this.date,
    this.error,
  });
}
