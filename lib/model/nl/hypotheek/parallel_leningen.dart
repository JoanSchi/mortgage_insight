import 'dart:convert';
import 'gegevens/hypotheek/hypotheek.dart';
import 'hypotheek.dart';

class RemoveParallelLeningen {
  List<RemoveStatusLening> list;
  double somLeningen;
  double somVerduurzaamKosten;
  double somVerbouwKosten;

  RemoveParallelLeningen(
      {List<RemoveStatusLening>? list,
      this.somLeningen = 0.0,
      this.somVerbouwKosten = 0.0,
      this.somVerduurzaamKosten = 0.0})
      : list = [];

  RemoveParallelLeningen.from({
    required List<RemoveHypotheek> parallelHypotheken,
    required RemoveHypotheek hypotheek,
  })  : list = [],
        somLeningen = 0.0,
        somVerbouwKosten = 0.0,
        somVerduurzaamKosten = 0.0 {
    for (RemoveHypotheek h in parallelHypotheken) {
      Termijn? termijn;

      for (Termijn t in h.termijnen) {
        if (t.startDatum.compareTo(hypotheek.startDatum) <= 0) {
          termijn = t;
        } else {
          break;
        }
      }

      if (termijn != null) {
        final statusLening = RemoveStatusLening(
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

  factory RemoveParallelLeningen.fromMap(Map<String, dynamic> map) {
    return RemoveParallelLeningen(
      list: List<RemoveStatusLening>.from(
        (map['list'] as List<int>).map<RemoveStatusLening>(
          (x) => RemoveStatusLening.fromMap(x as Map<String, dynamic>),
        ),
      ),
      somLeningen: map['somLeningen'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoveParallelLeningen.fromJson(String source) =>
      RemoveParallelLeningen.fromMap(
          json.decode(source) as Map<String, dynamic>);

  RemoveParallelLeningen copyWith({
    List<RemoveStatusLening>? list,
    double? somLeningen,
  }) {
    return RemoveParallelLeningen(
      list: list ?? this.list,
      somLeningen: somLeningen ?? this.somLeningen,
    );
  }
}

class RemoveStatusLening {
  String id;
  int periode;
  double lening;
  double rente;
  int aflosTermijnInMaanden;
  HypotheekVorm hypotheekVorm;

  RemoveStatusLening({
    required this.id,
    required this.lening,
    required this.periode,
    required this.rente,
    required this.aflosTermijnInMaanden,
    required this.hypotheekVorm,
  });

  static RemoveStatusLening from(
      {required RemoveHypotheek hypotheek, required int periode}) {
    return RemoveStatusLening(
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

  factory RemoveStatusLening.fromMap(Map<String, dynamic> map) {
    return RemoveStatusLening(
      id: map['id'],
      hypotheekVorm: HypotheekVorm.values[map['hypotheekVorm']],
      lening: map['lening']?.toDouble(),
      periode: map['periode'],
      rente: map['rente']?.toDouble(),
      aflosTermijnInMaanden: map['aflosTermijnInMaanden']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoveStatusLening.fromJson(String source) =>
      RemoveStatusLening.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RemoveStatusLening &&
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

  RemoveStatusLening copyWith({
    String? id,
    int? periode,
    double? lening,
    double? rente,
    double? toetsRente,
    int? aflosTermijnInMaanden,
    HypotheekVorm? hypotheekVorm,
    double? annuiteitMnd,
  }) {
    return RemoveStatusLening(
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
