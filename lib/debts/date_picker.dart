import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../utilities/date.dart';

class DateWidget extends StatefulWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime date;
  final changeDate;
  final saveDate;
  final bool useRootNavigator;

  DateWidget({
    Key? key,
    required this.date,
    required this.firstDate,
    required this.lastDate,
    this.changeDate,
    required this.saveDate,
    this.useRootNavigator = true,
  }) : super(key: key);

  @override
  _DateWidgetState createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  DateTime? _date;
  late DateFormat dateFormat = DateFormat.yMd(localeToString(context));
  late TextEditingController _dateController = TextEditingController(
      text: _date != null ? dateFormat.format(widget.date) : '');

  late FocusNode _dateNode = FocusNode()
    ..addListener(() {
      if (!_dateNode.hasFocus) {
        setDateFromTextField(validateDate(_dateController.text).date);
      }
    });

  late RegExp regExpDateInput;
  late String dateSeperator = MaterialLocalizations.of(context).dateSeparator;

  @override
  void initState() {
    super.initState();
    _date = widget.date;
  }

  @override
  void didChangeDependencies() {
    String languageCode = Localizations.localeOf(context).languageCode;

    switch (languageCode) {
      case 'nl':
        {
          regExpDateInput = RegExp(
              r'^([0-9]{1,2}([-|.|/]?[0-9]{0,2})?([-|.|/]?[0-9]{0,4}))?');
          break;
        }
      default:
        {
          regExpDateInput = RegExp(
              r'^([0-9]{1,2}([-|.|/]?[0-9]{0,2})?([-|.|/]?[0-9]{0,4}))?');
          break;
        }
    }

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_date != widget.date) {
      _date = widget.date;
      _dateController.dispose();
      _dateController = TextEditingController(
          text: _date != null ? dateFormat.format(_date!) : '');
    }
  }

  @override
  void dispose() {
    _dateNode.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      focusNode: _dateNode,
      controller: _dateController,
      keyboardType: TextInputType.datetime,
      inputFormatters: [FilteringTextInputFormatter.allow(regExpDateInput)],
      decoration: InputDecoration(
        // icon: Icon(Icons.person),
        hintText: dateFormat.pattern,
        labelText: 'Datum',
        // helperText: monthYearText
      ),
      validator: (String? value) {
        return validateDate(value).error;
      },
      onSaved: (String? value) {
        DateTime? date = validateDate(value).date;
        if (date != null) widget.saveDate?.call(date);
      },
      onFieldSubmitted: (String text) {
        setDateFromTextField(validateDate(text).date);
      },
    );

    Widget icon = IconButton(
        icon: Icon(Icons.calendar_today),
        onPressed: () {
          if (_dateNode.hasFocus) {
            _dateNode.unfocus();
          }

          DateTime suggestedDate = _date ?? DateUtils.dateOnly(DateTime.now());

          if (widget.firstDate.difference(suggestedDate).inDays > 0) {
            suggestedDate = widget.firstDate;
          } else if (widget.lastDate.difference(suggestedDate).inDays < 0) {
            suggestedDate = widget.lastDate;
          }

          showDatePicker(
                  context: context,
                  initialDate: suggestedDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  useRootNavigator: widget.useRootNavigator)
              .then((value) {
            if (value != null) {
              setDateFromPicker(value);
            }
          });
        });

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Expanded(child: textField), icon],
      ),
    );
  }

  setDateFromTextField(DateTime? value) {
    widget.changeDate?.call(value);
    _date = value;
  }

  setDateFromPicker(DateTime value) {
    _date = value;
    _dateController.text = dateFormat.format(value);

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

  DateValidate validateDate(String? value) {
    if (value != null) {
      try {
        if (dateSeperator != '.') {
          value = value.replaceAll('.', dateSeperator);
        }

        if (dateSeperator != '/') {
          value = value.replaceAll('/', dateSeperator);
        }

        if (dateSeperator != '-') {
          value = value.replaceAll('-', dateSeperator);
        }

        List<String> split = value.split(dateSeperator);

        if (split.length == 2) {
          String? pattern = dateFormat.pattern;
          if (pattern != null) {
            final splitPattern = pattern.split(dateSeperator);
            for (int i = 0; i < splitPattern.length; i++) {
              if (splitPattern[i].contains('y') ||
                  splitPattern[i].contains('Y')) {
                split.insert(i, '${DateTime.now().year}');

                break;
              }
            }
            if (split.length != 3) {
              return DateValidate(error: 'Jaar niet gevonden');
            }
            value =
                '${split[0]}$dateSeperator${split[1]}$dateSeperator${split[2]}';
          }
        } else if (split.length == 3) {
          String? pattern = dateFormat.pattern;
          if (pattern != null) {
            final splitPattern = pattern.split(dateSeperator);
            for (int i = 0; i < splitPattern.length; i++) {
              if (splitPattern[i].contains('y') ||
                  splitPattern[i].contains('Y')) {
                switch (split[i].length) {
                  case 1:
                  case 2:
                    {
                      split[i] = '${int.parse(split[i]) + 2000}';
                      break;
                    }
                  case 3:
                    {
                      return DateValidate(error: 'Error');
                    }
                }
                break;
              }
            }
          }

          value =
              '${split[0]}$dateSeperator${split[1]}$dateSeperator${split[2]}';
        }

        DateTime dateTime = dateFormat.parse(value);

        if (widget.firstDate.difference(dateTime).inDays > 0 ||
            widget.lastDate.difference(dateTime).inDays < 0) {
          return DateValidate(
              error:
                  'Bereik: ${dateFormat.format(widget.firstDate)} t/m ${dateFormat.format(widget.lastDate)}');
        }

        print(
            'check date: day: ${dateTime.day} month: ${dateTime.month} year: ${dateTime.year}');
        return DateValidate(date: dateTime);
      } catch (e) {
        return DateValidate(error: 'Datum niet herkend.');
      }
    }
    return DateValidate(date: DateUtils.dateOnly(DateTime.now()));
  }
}

class DateValidate {
  DateTime? date;
  String? error;
  DateValidate({
    this.date,
    this.error,
  });
}
