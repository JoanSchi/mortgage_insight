import 'dart:convert';
import 'hypotheek.dart';

class ParallelLeningen {
  List<StatusLening> list;
  double somLeningen;
  double somVerduurzaamKosten;
  double somVerbouwKosten;

  ParallelLeningen(
      {List<StatusLening>? list,
      this.somLeningen = 0.0,
      this.somVerbouwKosten = 0.0,
      this.somVerduurzaamKosten = 0.0})
      : list = [];

  ParallelLeningen.from({
    required List<Hypotheek> parallelHypotheken,
    required Hypotheek hypotheek,
  })  : list = [],
        somLeningen = 0.0,
        somVerbouwKosten = 0.0,
        somVerduurzaamKosten = 0.0 {
    for (Hypotheek h in parallelHypotheken) {
      Termijn? termijn;

      for (Termijn t in h.termijnen) {
        if (t.startDatum.compareTo(hypotheek.startDatum) <= 0) {
          termijn = t;
        } else {
          break;
        }
      }

      if (termijn != null) {
        final statusLening = StatusLening(
            id: h.id,
            lening: termijn.lening,
            periode: termijn.periode,
            rente: h.rente,
            aflosTermijnInMaanden: h.aflosTermijnInMaanden,
            hypotheekVorm: h.hypotheekvorm);

        list.add(statusLening);

        somLeningen += statusLening.lening;
      }

      if (h.startDatum.compareTo(hypotheek.startDatum) == 0 &&
          h.verbouwVerduurzaamKosten.toepassen) {
        h.verbouwVerduurzaamKosten
            .forEachUitsplitsenVerduurzamen((double kosten, bool verduurzamen) {
          if (verduurzamen) {
            somVerduurzaamKosten += kosten;
          } else {
            somVerbouwKosten += kosten;
          }
        });
      }
    }
  }

  double get somKosten => somVerduurzaamKosten + somVerbouwKosten;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'list': list.map((x) => x.toMap()).toList(),
      'somLeningen': somLeningen,
    };
  }

  factory ParallelLeningen.fromMap(Map<String, dynamic> map) {
    return ParallelLeningen(
      list: List<StatusLening>.from(
        (map['list'] as List<int>).map<StatusLening>(
          (x) => StatusLening.fromMap(x as Map<String, dynamic>),
        ),
      ),
      somLeningen: map['somLeningen'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ParallelLeningen.fromJson(String source) =>
      ParallelLeningen.fromMap(json.decode(source) as Map<String, dynamic>);

  ParallelLeningen copyWith({
    List<StatusLening>? list,
    double? somLeningen,
  }) {
    return ParallelLeningen(
      list: list ?? this.list,
      somLeningen: somLeningen ?? this.somLeningen,
    );
  }
}

class StatusLening {
  String id;
  int periode;
  double lening;
  double rente;
  int aflosTermijnInMaanden;
  HypotheekVorm hypotheekVorm;

  StatusLening({
    required this.id,
    required this.lening,
    required this.periode,
    required this.rente,
    required this.aflosTermijnInMaanden,
    required this.hypotheekVorm,
  });

  static StatusLening from(
      {required Hypotheek hypotheek, required int periode}) {
    return StatusLening(
        id: hypotheek.id,
        lening: 0.0,
        periode: periode,
        rente: hypotheek.rente,
        aflosTermijnInMaanden: hypotheek.aflosTermijnInMaanden,
        hypotheekVorm: hypotheek.hypotheekvorm);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hypotheekVorm': hypotheekVorm.index,
      'lening': lening,
      'periode': periode,
      'rente': rente,
      'aflosTermijnInMaanden': aflosTermijnInMaanden,
    };
  }

  factory StatusLening.fromMap(Map<String, dynamic> map) {
    return StatusLening(
      id: map['id'],
      hypotheekVorm: HypotheekVorm.values[map['hypotheekVorm']],
      lening: map['lening']?.toDouble(),
      periode: map['periode'],
      rente: map['rente']?.toDouble(),
      aflosTermijnInMaanden: map['aflosTermijnInMaanden']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusLening.fromJson(String source) =>
      StatusLening.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatusLening &&
        other.id == id &&
        other.periode == periode &&
        other.lening == lening &&
        other.aflosTermijnInMaanden == aflosTermijnInMaanden &&
        other.hypotheekVorm == hypotheekVorm;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        periode.hashCode ^
        lening.hashCode ^
        aflosTermijnInMaanden.hashCode ^
        hypotheekVorm.hashCode;
  }

  StatusLening copyWith({
    String? id,
    int? periode,
    double? lening,
    double? rente,
    double? toetsRente,
    int? aflosTermijnInMaanden,
    HypotheekVorm? hypotheekVorm,
    double? annuiteitMnd,
  }) {
    return StatusLening(
      id: id ?? this.id,
      periode: periode ?? this.periode,
      lening: lening ?? this.lening,
      rente: rente ?? this.rente,
      aflosTermijnInMaanden:
          aflosTermijnInMaanden ?? this.aflosTermijnInMaanden,
      hypotheekVorm: hypotheekVorm ?? this.hypotheekVorm,
    );
  }
}
