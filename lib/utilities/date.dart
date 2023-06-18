import 'package:flutter/widgets.dart';

String localeToString(BuildContext context) {
  Locale locale = Localizations.localeOf(context);
  return '${locale.languageCode}_${locale.countryCode}';
}

DateTime monthYear(DateTime date) {
  return DateTime(date.year, date.month);
}
