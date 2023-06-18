import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mortgage_insight/utilities/value_to_width.dart';
import 'dart:math' as math;

enum NumberType {
  decimalNumber,
  integralNumber,
}

class MyNumberFormat {
  Locale locale;

  late String decimalSep;
  late DecimalOnly decimalOnly;
  final textInputFormatters = <String, TextInputFormatter>{};
  final numberFormats = <String, intl.NumberFormat>{};
  intl.NumberFormat currencyNumberFormat;

  static MyNumberFormat? _singleton;

  factory MyNumberFormat(BuildContext context) =>
      _singleton ??= MyNumberFormat._internal(context);

  MyNumberFormat._internal(BuildContext context)
      : locale = Localizations.localeOf(context),
        currencyNumberFormat = intl.NumberFormat.currency(locale: 'nl') {
    debugPrint('locale is $locale');

    decimalSep = intl.NumberFormat.decimalPattern(locale.languageCode)
        .symbols
        .DECIMAL_SEP;
    debugPrint('decimal is $decimalSep');

    //String pattr = r'\d*\'+decimal_sep+r'?\d*';
//    String pattr = r'^\d{0,1}(\'+decimalSep+r'\d{0,1})?$';
//
//    print('languageCode $language pattr: $pattr');
//
//    decimalOnly = new DecimalOnly(pattr);
//
//    String t = r'^\d+(\'+decimalSep+r'\d{0,2})?$';
//    decimalOnly = new DecimalOnly(t);
  }

  TextInputFormatter numberInputFormat(String numberPattern) {
    if (textInputFormatters.containsKey(numberPattern)) {
      return textInputFormatters[numberPattern]!;
    }

    TextInputFormatter f;

    if (numberPattern.contains('.')) {
      final split = numberPattern.split('.');

      final integral = split[0].contains('#') ? '*' : '{0,${split[0].length}}';
      final decimal = split[1].contains('#') ? '*' : '{0,${split[1].length}}';

      String pattern =
          r'^\d' + integral + r'(\' + decimalSep + r'\d' + decimal + r')?$';
      f = DecimalOnly(pattern);
    } else if (numberPattern.contains('0')) {
      String pattern = r'^\d{0,' + numberPattern.length.toString() + r'}?$';
      f = DecimalOnly(pattern);
    } else {
      f = FilteringTextInputFormatter.digitsOnly;
    }

    textInputFormatters[numberPattern] = f;
    return f;
  }

  intl.NumberFormat numberFormat(String format) {
    if (numberFormats.containsKey(format)) {
      return numberFormats[format]!;
    }

    final numberFormat = intl.NumberFormat(format, locale.languageCode);

    numberFormats[format] = numberFormat;

    return numberFormat;
  }

  intl.NumberFormat currency() {
    return currencyNumberFormat;
  }

  TextInputFormatter textInputFormat(NumberType type) {
    switch (type) {
      case NumberType.decimalNumber:
        {
          return decimalOnly;
        }
      default:
        {
          return FilteringTextInputFormatter.digitsOnly;
        }
    }
  }

  double parsToDouble(String? value) {
    if (value == null || value.isEmpty) {
      return 0.0;
    } else if (value == decimalSep) {
      return 0.0;
    }

    if (decimalSep == ',') {
      value = value.replaceAll(',', '.');
    }

    return double.parse(value);
  }

  int parsToInt(String value) {
    if (value.isEmpty) {
      return 0;
    }

    if (decimalSep == ',') {
      value = value.replaceAll(',', '.');
    }

    return int.parse(value);
  }

  String parseIntToText(int number) {
    return number.toString();
  }

  String parseDoubleToText(double number, [format = '#0.0#']) {
    return numberFormat(format).format(number);
  }

  String parseDblToText(double? number,
      {format = "#0.0#", String ifnull = ''}) {
    return number != null ? numberFormat(format).format(number) : ifnull;
  }

  ValueToWidth<double> calculateWidthFromNumber(
      {required ValueToWidth<double> valueToWidth,
      required double value,
      required TextStyle textStyle,
      required double textScaleFactor,
      String format = '#0.00'}) {
    double suggestedNumber =
        math.pow(10.0, (math.log(value) / math.ln10).floorToDouble()) * 9;

    // x Zonder x9 is suggestie 1 by een waarde 0.1 dit wordt 1.00, dit is te small daarom 1 *9  wordt 9.00;

    if (valueToWidth.value != suggestedNumber ||
        valueToWidth.textScaleFactor != textScaleFactor) {
      final text = parseDblToText(suggestedNumber, format: format);

      final Size size = (TextPainter(
              text: TextSpan(text: text, style: textStyle),
              maxLines: 1,
              textScaleFactor: textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout())
          .size;

      valueToWidth
        ..value = suggestedNumber
        ..width = size.width
        ..textScaleFactor = textScaleFactor;
    }
    return valueToWidth;
  }
}

class DecimalOnly extends TextInputFormatter {
  RegExp regExp;

  DecimalOnly(String pattr) : regExp = RegExp(pattr);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final matches = regExp.allMatches(newValue.text);

    return matches.isEmpty ? oldValue.copyWith() : newValue.copyWith();
  }
}
