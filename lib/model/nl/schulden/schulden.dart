import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mortgage_insight/model/nl/schulden/schulden_aflopend_krediet.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_doorlopend_krediet.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_lease_auto.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_verzend_krediet.dart';

enum SchuldenCategorie {
  aflopend_krediet,
  doorlopend_krediet,
  verzendhuiskrediet,
  operationele_autolease
}

enum AKbetaling {
  per_periode,
  per_maand,
  per_eerst_volgende_maand,
}

enum DateStatus {
  now,
  before,
  after,
}

enum Calculated { yes, no, withError }

class SchuldenContainer {
  List<Schuld> list;

  SchuldenContainer({
    List<Schuld>? list,
  }) : list = list ?? [];

  // Map<String, dynamic> toMap() {
  //   List<Map<String, dynamic>> toList = [];

  //   list.forEach((Schuld x) {
  //     Map<String, dynamic>? map;
  //     switch (x.categorie) {
  //       case SchuldenCategorie.aflopend_krediet:
  //         map = (x as AflopendKrediet).toMap();
  //         break;
  //       case SchuldenCategorie.doorlopend_krediet:
  //         map = (x as DoorlopendKrediet).toMap();
  //         break;
  //       case SchuldenCategorie.verzendhuiskrediet:
  //         map = (x as VerzendhuisKrediet).toMap();
  //         break;
  //       case SchuldenCategorie.operationele_autolease:
  //         map = (x as OperationalLeaseAuto).toMap();
  //         break;
  //       default:
  //         {
  //           assert(false, 'toMap: Schuld categorie niet gevonden');
  //         }
  //     }
  //     if (map != null) {
  //       toList.add(map);
  //     }
  //   });
  //   return {'list': toList};
  // }

  SchuldenContainer copyWith({
    List<Schuld>? list,
  }) {
    return SchuldenContainer(
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'list': list.map((x) => x.toMap()).toList(),
    };
  }

  factory SchuldenContainer.fromMap(Map<String, dynamic> map) {
    return SchuldenContainer(
      list: fromMapToSchuld(map['list']),
    );
  }

  static List<Schuld> fromMapToSchuld(List<dynamic>? fromList) {
    List<Schuld> list = [];

    if (fromList == null) return list;

    for (Map<String, dynamic> x in fromList) {
      Schuld? schuld;
      switch (SchuldenCategorie.values[x['categorie'].toInt()]) {
        case SchuldenCategorie.aflopend_krediet:
          schuld = AflopendKrediet.fromMap(x);
          break;
        case SchuldenCategorie.doorlopend_krediet:
          schuld = DoorlopendKrediet.fromMap(x);
          break;
        case SchuldenCategorie.verzendhuiskrediet:
          schuld = VerzendhuisKrediet.fromMap(x);
          break;
        case SchuldenCategorie.operationele_autolease:
          schuld = OperationalLeaseAuto.fromMap(x);
          break;
        default:
          {
            assert(false, 'fromMap: Schuld categorie niet gevonden');
          }
      }
      if (schuld != null) {
        list.add(schuld);
      }
    }
    return list;
  }

  String toJson() => json.encode(toMap());

  factory SchuldenContainer.fromJson(String source) =>
      SchuldenContainer.fromMap(json.decode(source));
}

String omschrijvingSchuldKop(SchuldenCategorie categorie) {
  switch (categorie) {
    case SchuldenCategorie.aflopend_krediet:
      return 'Aflopend krediet';
    case SchuldenCategorie.doorlopend_krediet:
      return 'Doorlopend krediet';
    case SchuldenCategorie.verzendhuiskrediet:
      return 'lening';
    case SchuldenCategorie.operationele_autolease:
      return 'Autolease';
  }
}

abstract class Schuld {
  static const int noError = 0;
  static const int unknownError = 1;
  int id;
  SchuldenCategorie categorie;
  String subCategorie;
  String omschrijving;
  DateTime _beginDatum;
  Calculated _berekend;
  int error;

  Schuld({
    required this.id,
    required this.categorie,
    required this.omschrijving,
    DateTime? beginDatum,
    this.subCategorie = '',
    Calculated berekend: Calculated.no,
    required this.error,
  })  : _berekend = berekend,
        _beginDatum = DateUtils.dateOnly(beginDatum ?? DateTime.now());

  set beginDatum(DateTime value) {
    _beginDatum = DateUtils.dateOnly(value);
  }

  DateTime get beginDatum => _beginDatum;

  double maandLast(DateTime huidige);

  DateTime get eindDatum;

  Schuld copyWith({
    SchuldenCategorie? categorie,
    String? omschrijving,
    DateTime? beginDatum,
    Calculated? berekend,
  });

  set berekend(Calculated value) {
    _berekend = value;

    if (value == Calculated.no) {
      error = noError;
    }
  }

  Calculated get berekend => _berekend;

  static bool equalSubCategorie(Schuld? one, Schuld? two) {
    return one != null &&
        two != null &&
        one.categorie == two.categorie &&
        one.subCategorie == two.subCategorie;
  }

  @override
  String toString() =>
      'Schuld(categorie $categorie omschrijving: $omschrijving, beginDatum: $beginDatum, berekend: $berekend)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Schuld &&
        other.id == id &&
        other.subCategorie == subCategorie &&
        other.omschrijving == omschrijving &&
        other.beginDatum == beginDatum &&
        other._berekend == _berekend &&
        other.error == error;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        subCategorie.hashCode ^
        omschrijving.hashCode ^
        beginDatum.hashCode ^
        _berekend.hashCode ^
        error.hashCode;
  }

  DateStatus dateStatus(DateTime huidigeDatum) {
    huidigeDatum = DateUtils.dateOnly(huidigeDatum);

    if (beginDatum.compareTo(huidigeDatum) <= 0 &&
        eindDatum.compareTo(huidigeDatum) >= 0) {
      return DateStatus.now;
    } else if (beginDatum.compareTo(huidigeDatum) > 0) {
      return DateStatus.before;
    } else {
      return DateStatus.after;
    }
  }

  Map<String, dynamic> toMap();

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'categorie' : categorie.index,
  //     'subCategorie': subCategorie,
  //     'omschrijving': omschrijving,
  //     '_beginDatum': _beginDatum.toIso8601String(),
  //     '_berekend': _berekend.index,
  //     'error': error,
  //   };
  // }

  // factory Schuld.fromMap(Map<String, dynamic> map) {
  //   return Schuld(
  //     id: map['id']?.toInt(),
  //     categorie: SchuldenCategorie.values[ map['categorie'].toInt()],
  //     subCategorie: map['subCategorie'],
  //     omschrijving: map['omschrijving'],
  //     beginDatum: DateTime.parse(map['_beginDatum']).toLocal(),
  //     berekend: Calculated.values[map['_berekend'].toInt()],
  //     error: map['error']?.toInt(),
  //   );
  // }

}
