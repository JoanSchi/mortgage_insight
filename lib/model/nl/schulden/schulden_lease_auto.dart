import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mortgage_insight/model/nl/schulden/schulden.dart';

import '../../../../utilities/Kalender.dart';

class OperationalLeaseAuto extends Schuld {
  double mndBedrag;
  int jaren;
  int maanden;

  OperationalLeaseAuto(
      {int id = 0,
      SchuldenCategorie categorie: SchuldenCategorie.operationele_autolease,
      String omschrijving: 'Auto',
      DateTime? beginDatum,
      eindDatum,
      this.mndBedrag: 0.0,
      this.jaren: 3,
      this.maanden: 0,
      Calculated berekend: Calculated.no,
      int error: Schuld.noError})
      : super(
          id: id,
          categorie: categorie,
          omschrijving: omschrijving,
          beginDatum: beginDatum,
          subCategorie: '',
          berekend: berekend,
          error: error,
        );

  setBeginDatum(DateTime datum) {
    beginDatum = datum;
  }

  setJaren(int jaren) {
    this.jaren = jaren;
  }

  setMaanden(int maanden) {
    this.maanden = maanden;
  }

  void berekenen() {
    if (mndBedrag > 0.0 && (jaren > 0 || maanden > 0)) {
      berekend = Calculated.yes;
    } else {
      berekend = Calculated.no;
    }
  }

  int get aantalMaanden => jaren * 12 + maanden;

  Map<String, dynamic> overzicht(DateTime datumNu) {
    if (berekend != Calculated.yes) {
      return {'layout': 0, 'error': 'unknown'};
    }

    DateTime datum;

    final status = dateStatus(datumNu);

    switch (status) {
      case DateStatus.now:
        datum = datumNu;
        break;
      case DateStatus.before:
        datum = beginDatum;
        break;
      case DateStatus.after:
        datum = eindDatum;
        break;
    }

    DateTime vanaf = DateTime(2022, 4, 1);

    if (vanaf.compareTo(datumNu) <= 0) {
      return _overzichtMap(
        datum: datum,
        vanaf: vanaf,
        registratiePercentage: 100.0,
      );
    }

    vanaf = DateTime(2016, 1, 1);

    if (vanaf.compareTo(datumNu) <= 0) {
      return _overzichtMap(
        datum: datum,
        vanaf: vanaf,
        registratiePercentage: 65.0,
      );
    }

    return {'layout': 0, 'error': 'date'};
  }

  Map<String, dynamic> _overzichtMap(
      {required DateTime vanaf,
      required DateTime datum,
      required double registratiePercentage}) {
    return {
      'layout': 1,
      'begin': beginDatum,
      'eind': eindDatum,
      'datum': datum,
      'vanaf': vanaf,
      'mndBedrag': mndBedrag,
      'maandlast': mndBedrag / 100.0 * registratiePercentage,
      'registratiePercentage': registratiePercentage,
      'registratieBedrag':
          mndBedrag * aantalMaanden / 100.0 * registratiePercentage
    };
  }

  @override
  DateTime get eindDatum => Kalender.voegPeriodeToe(beginDatum,
      jaren: jaren, maanden: maanden, periodeOpties: PeriodeOpties.TOT);

  @override
  OperationalLeaseAuto copyWith(
      {int? id,
      SchuldenCategorie? categorie,
      String? omschrijving,
      DateTime? beginDatum,
      double? mndBedrag,
      int? jaren,
      int? maanden,
      Calculated? berekend,
      int? error}) {
    return OperationalLeaseAuto(
      id: id ?? this.id,
      categorie: categorie ?? this.categorie,
      omschrijving: omschrijving ?? this.omschrijving,
      beginDatum: beginDatum ?? this.beginDatum,
      mndBedrag: mndBedrag ?? this.mndBedrag,
      jaren: jaren ?? this.jaren,
      maanden: maanden ?? this.maanden,
      berekend: berekend ?? this.berekend,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OperationalLeaseAuto &&
        other.id == id &&
        other.subCategorie == subCategorie &&
        other.omschrijving == omschrijving &&
        other.beginDatum == beginDatum &&
        other.berekend == berekend &&
        other.error == error &&
        other.mndBedrag == mndBedrag &&
        other.jaren == jaren &&
        other.maanden == maanden;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      subCategorie.hashCode ^
      omschrijving.hashCode ^
      beginDatum.hashCode ^
      berekend.hashCode ^
      error.hashCode ^
      mndBedrag.hashCode ^
      jaren.hashCode ^
      maanden.hashCode;

  @override
  double maandLast(DateTime huidige) {
    if (huidige.compareTo(beginDatum) < 0 || huidige.compareTo(eindDatum) > 0) {
      return 0.0;
    }

    DateTime vanaf = DateTime(2022, 4, 1);

    if (DateUtils.monthDelta(vanaf, huidige) >= 0) {
      return mndBedrag;
    }

    vanaf = DateTime(2016, 1, 1);

    if (DateUtils.monthDelta(vanaf, huidige) >= 0) {
      return mndBedrag * 0.65;
    }
    return -1;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categorie': categorie.index,
      'omschrijving': omschrijving,
      'beginDatum': beginDatum.toIso8601String(),
      'berekend': berekend.index,
      'error': error,
      // Lease auto
      'mndBedrag': mndBedrag,
      'jaren': jaren,
      'maanden': maanden,
    };
  }

  factory OperationalLeaseAuto.fromMap(Map<String, dynamic> map) {
    return OperationalLeaseAuto(
      id: map['id']?.toInt(),
      categorie: SchuldenCategorie.values[map['categorie'].toInt()],
      omschrijving: map['omschrijving'],
      beginDatum: DateTime.parse(map['beginDatum']).toLocal(),
      berekend: Calculated.values[map['berekend'].toInt()],
      error: map['error']?.toInt(),
      // Lease auto
      mndBedrag: map['mndBedrag']?.toDouble(),
      jaren: map['jaren']?.toInt(),
      maanden: map['maanden']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationalLeaseAuto.fromJson(String source) =>
      OperationalLeaseAuto.fromMap(json.decode(source));
}
