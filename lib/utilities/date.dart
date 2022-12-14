import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String localeToString(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  return '${locale.languageCode}_${locale.countryCode}';
}

DateTime monthYear(DateTime date) {
  return DateTime(date.year, date.month);
}

int get dateID {
  return int.parse('${DateFormat('yyyyMMdd').format(DateTime.now())}001');
}

String get secondsID {
  return DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
}
