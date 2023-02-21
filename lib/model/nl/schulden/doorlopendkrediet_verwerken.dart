// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden.dart';

import '../../../utilities/Kalender.dart';

class DoorlopendKredietVerwerken {
  static DateTime eindDatum(DoorlopendKrediet dk) =>
      dk.heeftEindDatum && dk.eindDatumGebruiker != DateTime(0)
          ? dk.eindDatumGebruiker
          : eindBereikEindDatum(dk.beginDatum);

  static DoorlopendKrediet verandering(DoorlopendKrediet dk,
      {DateTime? beginDatum,
      bool? heeftEindDatum,
      DateTime? eindDatumGebruiker,
      double? bedrag}) {
    final bool _heeftEindDatum = heeftEindDatum ?? dk.heeftEindDatum;
    final DateTime _beginDatum = beginDatum ?? dk.beginDatum;
    final DateTime _eindDatumGebruiker = eindDatumInbeReik(
        _beginDatum, eindDatumGebruiker ?? dk.eindDatumGebruiker);
    final double _bedrag = bedrag ?? dk.bedrag;

    final StatusBerekening statusBerekening =
        ((_heeftEindDatum && _eindDatumGebruiker == DateTime(0)) ||
                DateUtils.monthDelta(_beginDatum, _eindDatumGebruiker) < 1 ||
                _bedrag == 0.0)
            ? StatusBerekening.nietBerekend
            : StatusBerekening.berekend;

    return dk.copyWith(
        statusBerekening: statusBerekening,
        beginDatum: _beginDatum,
        heeftEindDatum: _heeftEindDatum,
        eindDatumGebruiker: _eindDatumGebruiker,
        bedrag: _bedrag);
  }

  static double fictieveKredietlast(DateTime datum) {
    return 2.0;
  }

  static double maandLast(
    DoorlopendKrediet dk,
    DateTime huidige,
  ) {
    if (huidige.compareTo(dk.beginDatum) < 0 ||
        huidige.compareTo(eindDatum(dk)) > 0) {
      return 0.0;
    } else {
      return dk.bedrag / 100 * fictieveKredietlast(huidige);
    }
  }

  static DateTime beginBereikEindDatum(DateTime begin) =>
      Kalender.voegPeriodeToe(begin, maanden: 1);

  static DateTime eindBereikEindDatum(DateTime begin) =>
      Kalender.voegPeriodeToe(begin, jaren: 30);

  static DateTime eindDatumInbeReik(DateTime begin, DateTime eind) {
    if (eind == DateTime(0)) {
      return eindBereikEindDatum(begin);
    }

    begin = beginBereikEindDatum(begin);

    if (begin.compareTo(eind) > 0) {
      return begin;
    }

    DateTime eindSuggestie = eindBereikEindDatum(begin);

    if (eindSuggestie.compareTo(eind) < 0) {
      return eindSuggestie;
    }

    return eind;
  }
}