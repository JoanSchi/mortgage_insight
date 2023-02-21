import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mortgage_insight/model/nl/schulden/remove_schulden_aflopend_krediet.dart';
import 'package:mortgage_insight/model/nl/schulden/remove_schulden_verzend_krediet.dart';

import 'schulden.dart';

class RemoveSchuldenContainer {
  List<RemoveSchuld> list;

  RemoveSchuldenContainer({
    List<RemoveSchuld>? list,
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

  RemoveSchuldenContainer copyWith({
    List<RemoveSchuld>? list,
  }) {
    return RemoveSchuldenContainer(
      list: list ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'list': list.map((x) => x.toMap()).toList(),
    };
  }

  factory RemoveSchuldenContainer.fromMap(Map<String, dynamic> map) {
    return RemoveSchuldenContainer(
      list: fromMapToSchuld(map['list']),
    );
  }

  static List<RemoveSchuld> fromMapToSchuld(List<dynamic>? fromList) {
    List<RemoveSchuld> list = [];

    if (fromList == null) return list;

    for (Map<String, dynamic> x in fromList) {
      RemoveSchuld? schuld;
      switch (SchuldenCategorie.values[x['categorie'].toInt()]) {
        case SchuldenCategorie.aflopend_krediet:
          schuld = RemoveAflopendKrediet.fromMap(x);
          break;
        case SchuldenCategorie.doorlopend_krediet:
          // schuld = RemoveDoorlopendKrediet.fromMap(x);
          break;
        case SchuldenCategorie.verzendhuiskrediet:
          schuld = RemoveVerzendhuisKrediet.fromMap(x);
          break;
        case SchuldenCategorie.operationele_autolease:
          // schuld = RemoveOperationalLeaseAuto.fromMap(x);
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

  factory RemoveSchuldenContainer.fromJson(String source) =>
      RemoveSchuldenContainer.fromMap(json.decode(source));
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

abstract class RemoveSchuld {
  static const int noError = 0;
  static const int unknownError = 1;
  int id;
  SchuldenCategorie categorie;
  String subCategorie;
  String omschrijving;
  DateTime _beginDatum;
  StatusBerekening _berekend;
  int error;

  RemoveSchuld({
    required this.id,
    required this.categorie,
    required this.omschrijving,
    DateTime? beginDatum,
    this.subCategorie = '',
    StatusBerekening berekend: StatusBerekening.nietBerekend,
    required this.error,
  })  : _berekend = berekend,
        _beginDatum = DateUtils.dateOnly(beginDatum ?? DateTime.now());

  set beginDatum(DateTime value) {
    _beginDatum = DateUtils.dateOnly(value);
  }

  DateTime get beginDatum => _beginDatum;

  double maandLast(DateTime huidige);

  DateTime get eindDatum;

  RemoveSchuld copyWith({
    SchuldenCategorie? categorie,
    String? omschrijving,
    DateTime? beginDatum,
    StatusBerekening? berekend,
  });

  set berekend(StatusBerekening value) {
    _berekend = value;

    if (value == StatusBerekening.nietBerekend) {
      error = noError;
    }
  }

  StatusBerekening get berekend => _berekend;

  static bool equalSubCategorie(RemoveSchuld? one, RemoveSchuld? two) {
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

    return other is RemoveSchuld &&
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
