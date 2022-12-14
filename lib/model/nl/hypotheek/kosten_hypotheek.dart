// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

enum Situatie { starter, koopwoning, geenKoopwoning }

enum Eenheid { percentageWoningWaarde, percentageLening, bedrag }

class Waarde {
  String id;
  int index;
  String name;
  double value;
  Eenheid eenheid;
  bool standaard;
  bool aftrekbaar;
  bool verduurzamen;

  Waarde({
    required this.id,
    required this.index,
    required this.name,
    required this.value,
    required this.eenheid,
    this.aftrekbaar = false,
    this.standaard = false,
    this.verduurzamen = false,
  });

  String get key => '${id}_$index';

  Waarde copyWith({
    String? id,
    int? index,
    String? name,
    double? value,
    Eenheid? eenheid,
    bool? gebruiker,
    bool? aftrekbaar,
    bool? verduurzamen,
  }) {
    return Waarde(
      id: id ?? this.id,
      index: index ?? this.index,
      name: name ?? this.name,
      value: value ?? this.value,
      eenheid: eenheid ?? this.eenheid,
      standaard: gebruiker ?? this.standaard,
      aftrekbaar: aftrekbaar ?? this.aftrekbaar,
      verduurzamen: verduurzamen ?? this.verduurzamen,
    );
  }

  setWaardes({
    String? name,
    double? value,
    Eenheid? eenheid,
    bool? aftrekbaar,
    bool? verduurzamen,
  }) {
    if (name != null) {
      this.name = name;
    }
    if (value != null) {
      this.value = value;
      debugPrint('value is ${this.value}');
    }
    if (eenheid != null) {
      this.eenheid = eenheid;
    }

    if (aftrekbaar != null) {
      this.aftrekbaar = aftrekbaar;
    }

    if (verduurzamen != null) {
      this.verduurzamen = verduurzamen;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'index': index,
      'name': name,
      'value': value,
      'eenheid': eenheid.index,
      'standaard': standaard,
      'aftrekbaar': aftrekbaar,
      'verduurzamen': verduurzamen
    };
  }

  factory Waarde.fromMap(Map<String, dynamic> map) {
    return Waarde(
      id: map['id'],
      index: map['index'],
      name: map['name'],
      value: map['value']?.toDouble(),
      eenheid: Eenheid.values[map['eenheid']],
      standaard: map['standaard'],
      aftrekbaar: map['aftrekbaar'],
      verduurzamen: map['verduurzamen'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Waarde.fromJson(String source) => Waarde.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Waarde &&
        other.name == name &&
        other.value == value &&
        other.eenheid == eenheid &&
        other.standaard == standaard &&
        other.aftrekbaar == aftrekbaar &&
        other.verduurzamen == verduurzamen;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        value.hashCode ^
        eenheid.hashCode ^
        standaard.hashCode ^
        aftrekbaar.hashCode ^
        verduurzamen.hashCode;
  }
}

// final Waarde geenKosten = Waarde(
//     id: 'geen',
//     index: -1,
//     name: '',
//     value: 0.0,
//     eenheid: Eenheid.bedrag,
//     standaard: true,
//     aftrekbaar: false,
//     verduurzamen: true);

final Waarde leegKostenVerduurzamen = Waarde(
    id: 'eigen',
    index: 1000,
    name: '',
    value: 0.0,
    eenheid: Eenheid.bedrag,
    standaard: true,
    aftrekbaar: false,
    verduurzamen: true);

final Waarde leegKosten = Waarde(
    id: 'eigen',
    index: 1000,
    name: '',
    value: 0.0,
    eenheid: Eenheid.bedrag,
    standaard: true,
    aftrekbaar: false,
    verduurzamen: false);

class EigenReserveWoning {
  bool erwToepassing;
  bool erwBerekenen;
  double erw;
  double oorspronkelijkeHoofdsom;

  bool get woningGegevens => erwToepassing && erwBerekenen;

  EigenReserveWoning({
    this.erwToepassing: false,
    this.erwBerekenen: false,
    this.erw: 0.0,
    this.oorspronkelijkeHoofdsom = 0.0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'erwToepassing': erwToepassing,
      'erwBerekenen': erwBerekenen,
      'erw': erw,
      'oorspronkelijkeHoofdsom': oorspronkelijkeHoofdsom,
    };
  }

  factory EigenReserveWoning.fromMap(Map<String, dynamic> map) {
    return EigenReserveWoning(
      erwToepassing: map['erwToepassing'],
      erwBerekenen: map['erwBerekenen'],
      erw: map['erw']?.toDouble(),
      oorspronkelijkeHoofdsom: map['oorspronkelijkeHoofdsom']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory EigenReserveWoning.fromJson(String source) =>
      EigenReserveWoning.fromMap(json.decode(source));

  EigenReserveWoning copyWith({
    bool? erwToepassing,
    bool? erwBerekenen,
    double? erw,
    double? oorspronkelijkeLening,
  }) {
    return EigenReserveWoning(
      erwToepassing: erwToepassing ?? this.erwToepassing,
      erwBerekenen: erwBerekenen ?? this.erwBerekenen,
      erw: erw ?? this.erw,
      oorspronkelijkeHoofdsom:
          oorspronkelijkeLening ?? this.oorspronkelijkeHoofdsom,
    );
  }
}

class WoningLeningKostenGegevens {
  double woningWaarde;
  double lening;
  List<Waarde> kosten;

  WoningLeningKostenGegevens({
    this.woningWaarde = 0.0,
    this.lening = 0.0,
    List<Waarde>? kosten,
  }) : kosten = kosten ?? <Waarde>[];

  WoningLeningKostenGegevens copyWith({
    double? woningWaarde,
    double? initieleLening,
    List<Waarde>? kosten,
  }) {
    return WoningLeningKostenGegevens(
      woningWaarde: woningWaarde ?? this.woningWaarde,
      lening: initieleLening ?? this.lening,
      kosten: kosten ?? this.kosten.map((Waarde e) => e.copyWith()).toList(),
    );
  }

  double get totaleKosten => kosten.fold(0.0, (double previous, Waarde w) {
        double value;
        switch (w.eenheid) {
          case Eenheid.percentageWoningWaarde:
            value = woningWaarde / 100.0 * w.value;
            break;
          case Eenheid.bedrag:
            value = w.value;
            break;
          case Eenheid.percentageLening:
            value = lening / 100.0 * w.value;
            break;
        }
        return previous + value;
      });

  double get verschil => woningWaarde - lening - totaleKosten;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lening': lening,
      'kosten': kosten.map((x) => x.toMap()).toList(),
      'woningWaarde': woningWaarde,
    };
  }

  factory WoningLeningKostenGegevens.fromMap(Map<String, dynamic> map) {
    return WoningLeningKostenGegevens(
      lening: map['lening']?.toDouble(),
      kosten: List<Waarde>.from(map['kosten'].map((x) => Waarde.fromMap(x))),
      woningWaarde: map['woningWaarde']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WoningLeningKostenGegevens.fromJson(String source) =>
      WoningLeningKostenGegevens.fromMap(json.decode(source));

  static final borgNHG = Waarde(
    id: 'borgNHG',
    index: 5,
    name: 'Borg NHG',
    value: 0.7,
    eenheid: Eenheid.percentageLening,
  );

  static List<Waarde> suggestieKosten({
    required bool overdrachtBelasting,
    required bool nhg,
  }) =>
      [
        if (overdrachtBelasting)
          Waarde(
              id: 'overdrachtBelasting',
              index: 0,
              name: 'Overdracht Belasting',
              value: 2.0,
              eenheid: Eenheid.percentageWoningWaarde,
              standaard: true,
              aftrekbaar: false),
        Waarde(
            id: 'bouwkundigRapport',
            index: 3,
            name: 'Bouwkundig Rapport',
            value: 500.0,
            eenheid: Eenheid.bedrag,
            aftrekbaar: true),
        Waarde(
            id: 'bankgarantie',
            index: 4,
            name: 'Bankgarantie',
            value: 250.0,
            eenheid: Eenheid.bedrag,
            aftrekbaar: true),
        Waarde(
            id: 'adviesBemiddeling',
            index: 6,
            name: 'Advies bemiddeling',
            value: 2000.0,
            eenheid: Eenheid.bedrag,
            aftrekbaar: true),
        Waarde(
            id: 'aankoopmakelaar',
            index: 7,
            name: 'Aankoopmakelaar',
            value: 3000.0,
            eenheid: Eenheid.bedrag,
            aftrekbaar: true),
        Waarde(
            id: 'taxatie',
            index: 1,
            name: 'Taxatie',
            value: 500.0,
            eenheid: Eenheid.bedrag,
            standaard: true,
            aftrekbaar: true),
        Waarde(
            id: 'notaris',
            index: 2,
            name: 'Notaris',
            value: 1200.0,
            eenheid: Eenheid.bedrag,
            standaard: true,
            aftrekbaar: true),
        if (nhg) WoningLeningKostenGegevens.borgNHG,
      ];

  static List<Waarde> suggestieKostenVorigeWoning() => [
        Waarde(
            id: 'makelaar',
            index: 0,
            name: 'makelaar',
            value: 3000.0,
            eenheid: Eenheid.bedrag,
            standaard: true),
        Waarde(
            id: 'energielabel',
            index: 1,
            name: 'energielabel',
            value: 200.0,
            eenheid: Eenheid.bedrag,
            standaard: true),
        Waarde(
            id: 'advertentie',
            index: 2,
            name: 'advertentie',
            value: 150.0,
            eenheid: Eenheid.bedrag,
            standaard: true),
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WoningLeningKostenGegevens &&
        other.woningWaarde == woningWaarde &&
        other.lening == lening &&
        listEquals(other.kosten, kosten);
  }

  @override
  int get hashCode => woningWaarde.hashCode ^ lening.hashCode ^ kosten.hashCode;
}

class VerbouwVerduurzaamKosten {
  bool toepassen;
  List<Waarde> kosten;
  double taxatie;
  String energieClassificering;

  VerbouwVerduurzaamKosten({
    List<Waarde>? kosten,
    this.energieClassificering = '',
    this.toepassen = false,
    this.taxatie = 0.0,
  }) : kosten = kosten ?? <Waarde>[];

  double get totaleKosten => kosten.fold(0.0, (double previous, Waarde w) {
        double value;
        switch (w.eenheid) {
          case Eenheid.percentageWoningWaarde:
            value = taxatie / 100.0 * w.value;
            break;
          case Eenheid.bedrag:
            value = w.value;
            break;
          case Eenheid.percentageLening:
            value = 0.0;
            break;
        }
        return previous + value;
      });

  double get totaleVerbouwKosten => _totaleKostenUitsplitsen(false);

  double get totaleVerduurzaamKosten => _totaleKostenUitsplitsen(true);

  double _totaleKostenUitsplitsen(bool verduurzamen) =>
      kosten.fold(0.0, (double previous, Waarde w) {
        if (w.verduurzamen != verduurzamen) {
          return previous;
        } else {
          double value;
          switch (w.eenheid) {
            case Eenheid.percentageWoningWaarde:
              value = taxatie / 100.0 * w.value;
              break;
            case Eenheid.bedrag:
              value = w.value;
              break;
            case Eenheid.percentageLening:
              value = 0.0;
              break;
          }
          return previous + value;
        }
      });

  forEachUitsplitsenVerduurzamen(Function(double kost, bool verduurzamen) t) {
    for (Waarde w in kosten) {
      switch (w.eenheid) {
        case Eenheid.percentageWoningWaarde:
          t(taxatie / 100.0 * w.value, w.verduurzamen);
          break;
        case Eenheid.bedrag:
          t(w.value, w.verduurzamen);
          break;
        case Eenheid.percentageLening:
          break;
      }
    }
  }

  static List<Waarde> leegVerduurzamen = [
    Waarde(
        id: 'Eigen Isolatie',
        index: 1000,
        name: 'Isolatie: ....',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'Eigen Warmteterugwinning',
        index: 1001,
        name: 'Warmteterugwinning: ...',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'Overige',
        index: 1002,
        name: '',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
  ];

  static List<Waarde> suggestieVerduurzamen = [
    Waarde(
        id: 'Isolatie 1',
        index: 1,
        name: 'Isolatie van dak/vloer/gevel',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'HRplusplus',
        index: 2,
        name: 'HR++',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'Warmtepomp',
        index: 3,
        name: 'Warmtepomp',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'zonnepanelen',
        index: 4,
        name: 'Zonnepanelen',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'Energiezuinige ventilatie',
        index: 5,
        name: 'Energiezuinige ventilatie',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
    Waarde(
        id: 'warmteterugwinning 1',
        index: 6,
        name: 'Douche met warmteterugwinning',
        value: 0.0,
        eenheid: Eenheid.bedrag,
        standaard: true,
        verduurzamen: true),
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toepassen': toepassen,
      'kosten': kosten.map((x) => x.toMap()).toList(),
      'taxatie': taxatie,
      'energieClassificering': energieClassificering,
    };
  }

  factory VerbouwVerduurzaamKosten.fromMap(Map<String, dynamic> map) {
    return VerbouwVerduurzaamKosten(
      toepassen: map['toepassen'] as bool,
      kosten: List<Waarde>.from(
        (map['kosten'] as List<int>).map<Waarde>(
          (x) => Waarde.fromMap(x as Map<String, dynamic>),
        ),
      ),
      taxatie: map['taxatie'] as double,
      energieClassificering: map['energieClassificering'],
    );
  }

  String toJson() => json.encode(toMap());

  factory VerbouwVerduurzaamKosten.fromJson(String source) =>
      VerbouwVerduurzaamKosten.fromMap(
          json.decode(source) as Map<String, dynamic>);

  VerbouwVerduurzaamKosten copyWith({
    bool? toepassen,
    List<Waarde>? kosten,
    double? taxatie,
    String? energieClassificering,
  }) {
    return VerbouwVerduurzaamKosten(
      toepassen: toepassen ?? this.toepassen,
      kosten: kosten ?? this.kosten,
      taxatie: taxatie ?? this.taxatie,
      energieClassificering:
          energieClassificering ?? this.energieClassificering,
    );
  }
}
