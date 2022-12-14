import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mortgage_insight/utilities/Kalender.dart';

import 'schulden.dart';

class DoorlopendKrediet extends Schuld {
  double bedrag;
  DateTime? _eindDatum;
  bool heeftEindDatum;

  DoorlopendKrediet({
    int id = 0,
    SchuldenCategorie categorie: SchuldenCategorie.doorlopend_krediet,
    String omschrijving = '',
    DateTime? beginDatum,
    String subCategorie = '',
    Calculated berekend: Calculated.no,
    int error: Schuld.noError,
    this.bedrag = 0.0,
    DateTime? eindDatum,
    this.heeftEindDatum = true,
  }) : super(
          id: id,
          categorie: categorie,
          omschrijving: omschrijving,
          beginDatum: beginDatum,
          subCategorie: '',
          berekend: berekend,
          error: error,
        ) {
    _eindDatum =
        eindDatum ?? Kalender.voegPeriodeToe(super.beginDatum, jaren: 1);
  }

  double fictieveKredietlast(DateTime datum) {
    return 2.0;
  }

  double maandLast(
    DateTime huidige,
  ) {
    if (huidige.compareTo(beginDatum) < 0 || huidige.compareTo(eindDatum) > 0) {
      return 0.0;
    } else {
      return bedrag / 100 * fictieveKredietlast(huidige);
    }
  }

  @override
  DoorlopendKrediet copyWith(
      {int? id,
      SchuldenCategorie? categorie,
      String? omschrijving,
      DateTime? beginDatum,
      DateTime? eindDatum,
      bool? heeftEindDatum,
      double? mndBedrag,
      Calculated? berekend,
      int? error}) {
    return DoorlopendKrediet(
      id: id ?? this.id,
      omschrijving: omschrijving ?? this.omschrijving,
      categorie: categorie ?? this.categorie,
      beginDatum: beginDatum ?? this.beginDatum,
      eindDatum: eindDatum ?? _eindDatum,
      heeftEindDatum: heeftEindDatum ?? this.heeftEindDatum,
      bedrag: mndBedrag ?? this.bedrag,
      berekend: berekend ?? this.berekend,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DoorlopendKrediet &&
        other.id == id &&
        other.categorie == categorie &&
        other.subCategorie == subCategorie &&
        other.omschrijving == omschrijving &&
        other.beginDatum == beginDatum &&
        other._eindDatum == _eindDatum &&
        other.heeftEindDatum == heeftEindDatum &&
        other.berekend == berekend &&
        other.error == error &&
        other.bedrag == bedrag;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      categorie.hashCode ^
      subCategorie.hashCode ^
      omschrijving.hashCode ^
      beginDatum.hashCode ^
      eindDatum.hashCode ^
      heeftEindDatum.hashCode ^
      berekend.hashCode ^
      error.hashCode ^
      bedrag.hashCode;

  set eindDatum(DateTime value) {
    value = DateUtils.dateOnly(value);
    _eindDatum = value;
  }

  @override
  DateTime get eindDatum => heeftEindDatum
      ? (_eindDatum ?? eindBereikEindDatum)
      : eindBereikEindDatum;

  void berekenen() {
    if ((heeftEindDatum && _eindDatum == null) ||
        DateUtils.monthDelta(beginDatum, _eindDatum!) < 1 ||
        bedrag == 0.0) {
      berekend = Calculated.no;
    } else {
      berekend = Calculated.yes;
    }
  }

  DateTime get beginBereikEindDatum =>
      Kalender.voegPeriodeToe(beginDatum, maanden: 1);

  DateTime get eindBereikEindDatum =>
      Kalender.voegPeriodeToe(beginDatum, jaren: 30);

  DateTime eindDatumInbeReik() {
    assert(heeftEindDatum, 'heeftEindDatum moet true zijn!!');

    if (_eindDatum == null) {
      return eindBereikEindDatum;
    }

    DateTime begin = beginBereikEindDatum;

    if (beginBereikEindDatum.compareTo(_eindDatum!) > 0) {
      return begin;
    }

    DateTime end = eindBereikEindDatum;

    if (eindBereikEindDatum.compareTo(_eindDatum!) < 0) {
      return end;
    }

    return _eindDatum!;
  }

  Map<String, dynamic> overzicht(DateTime datumNu) {
    if (berekend != Calculated.yes) {
      return {'layout': 0, 'error': 'unknown'};
    }

    return _overzichtMap(
      datum: datumNu,
      maandlastPercentage: 2.0,
    );
  }

  Map<String, dynamic> _overzichtMap(
      {required DateTime datum, required double maandlastPercentage}) {
    return {
      'layout': 1,
      'begin': beginDatum,
      'eind': eindDatum,
      'bedrag': bedrag,
      'maandlastPercentage': maandlastPercentage,
      'maandlast': bedrag / 100.0 * maandlastPercentage,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categorie': categorie.index,
      'subCategorie': subCategorie,
      'omschrijving': omschrijving,
      'beginDatum': beginDatum.toIso8601String(),
      'berekend': berekend.index,
      'error': error,
      // Doorlopend krediet
      'bedrag': bedrag,
      '_eindDatum': _eindDatum?.toIso8601String(),
      'heeftEindDatum': heeftEindDatum,
    };
  }

  factory DoorlopendKrediet.fromMap(Map<String, dynamic> map) {
    return DoorlopendKrediet(
      id: map['id']?.toInt(),
      categorie: SchuldenCategorie.values[map['categorie'].toInt()],
      subCategorie: map['subCategorie'],
      omschrijving: map['omschrijving'],
      beginDatum: DateTime.parse(map['beginDatum']).toLocal(),
      berekend: Calculated.values[map['berekend'].toInt()],
      error: map['error']?.toInt(),
      //Doorlopend Krediet
      bedrag: map['bedrag']?.toDouble(),
      eindDatum: map['_eindDatum'] != null
          ? DateTime.parse(map['_eindDatum']).toLocal()
          : null,
      heeftEindDatum: map['heeftEindDatum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DoorlopendKrediet.fromJson(String source) =>
      DoorlopendKrediet.fromMap(json.decode(source));
}
