import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/nl/inkomen/inkomen.dart';
import '../../utilities/date.dart';

class IncomeCalculation {
  static PensionEvaluated evaluatePension(
      {required DateTime date, required List<Inkomen> list}) {
    for (Inkomen item in list) {
      int delta = DateUtils.monthDelta(date, item.datum);

      if (delta < 0) {
        //Negative delta: date after item date.
        if (item.pensioen) {
          return PensionEvaluated(
              enable: false, pensioen: true, blockItem: item);
        }
      } else if (delta > 0) {
        //Positive delta: date before item date.
        if (item.pensioen) {
          return PensionEvaluated(enable: true, blockItem: item);
        } else {
          return PensionEvaluated(
              enable: false, pensioen: false, blockItem: item);
        }
      }
    }

    return PensionEvaluated(enable: true);
  }
}

class PensionEvaluated {
  bool enable;
  bool? pensioen;
  Inkomen? blockItem;

  PensionEvaluated({
    required this.enable,
    this.pensioen,
    this.blockItem,
  });

  String message(BuildContext context) {
    if (blockItem != null) {
      double width = MediaQuery.of(context).size.width;

      if (width > 600) {
        final monthYear =
            DateFormat.yMMMM(localeToString(context)).format(blockItem!.datum);
        return 'Geblokt: Op $monthYear is al ${blockItem!.pensioen ? 'pensioen' : 'niet pensioen'} gerechtigd geselecteerd.';
      } else {
        final monthYear =
            DateFormat.yMMM(localeToString(context)).format(blockItem!.datum);
        return 'Geblokt: Op $monthYear ${blockItem!.pensioen ? 'pensioen' : 'niet pensioen'} gerechtigd geselecteerd.';
      }
    } else {
      return ':(';
    }
  }
}
