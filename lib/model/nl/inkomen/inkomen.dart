import 'dart:convert';
import 'dart:math' as math;

enum JaarInkomenUit { maand, jaar }

class InkomenContainer {
  List<Inkomen> list;
  InkomenContainer({
    List<Inkomen>? list,
  }) : list = list ?? [];

  InkomenContainer copyWith({
    List<Inkomen>? inkomen,
  }) {
    return InkomenContainer(
      list: inkomen ?? this.list,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'inkomen': list.map((x) => x.toMap()).toList(),
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return InkomenContainer(
      list: List<Inkomen>.from(map['inkomen']?.map((x) => Inkomen.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory InkomenContainer.fromJson(String source) =>
      InkomenContainer.fromMap(json.decode(source));

  @override
  String toString() => 'Inkomen(inkomen: $list)';
}

class DetailsInkomen {
  //enum
  JaarInkomenUit jaarInkomenUit;
  double brutoMaand;
  bool dertiendeMaand;
  bool vakantiegeld;
  double _brutoJaar;

  DetailsInkomen({
    this.jaarInkomenUit = JaarInkomenUit.jaar,
    this.brutoMaand = 0.0,
    this.dertiendeMaand = false,
    this.vakantiegeld = false,
    double brutoJaar = 0.0,
  }) : _brutoJaar = brutoJaar;

  DetailsInkomen copyWith({
    JaarInkomenUit? jaarInkomenUit,
    double? brutoMaand,
    bool? dertiendeMaand,
    bool? vakantiegeld,
    double? brutoJaar,
    bool? pensioen,
  }) {
    return DetailsInkomen(
      jaarInkomenUit: jaarInkomenUit ?? this.jaarInkomenUit,
      brutoMaand: brutoMaand ?? this.brutoMaand,
      dertiendeMaand: dertiendeMaand ?? this.dertiendeMaand,
      vakantiegeld: vakantiegeld ?? this.vakantiegeld,
      brutoJaar: brutoJaar ?? this._brutoJaar,
    );
  }

  set brutoJaar(double value) {
    _brutoJaar = value;
  }

  double get brutoJaar => jaarInkomenUit == JaarInkomenUit.jaar
      ? _brutoJaar
      : brutoMaand * 12.0 + bedragVakantiegeld + bedragDertiendeMaand;

  double get bedragVakantiegeld => vakantiegeld
      ? ((jaarInkomenUit == JaarInkomenUit.jaar
              ? _brutoJaar
              : brutoMaand * 12.0) *
          0.08)
      : 0.0;

  double get bedragDertiendeMaand => dertiendeMaand ? brutoMaand : 0.0;

  @override
  String toString() {
    return 'DetailsInkomen(inkomen_uit: $jaarInkomenUit, brutoMaand: $brutoMaand, dertiendeMaand: $dertiendeMaand, vakantiegeld: $vakantiegeld, brutoJaar: $brutoJaar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetailsInkomen &&
        other.jaarInkomenUit == jaarInkomenUit &&
        other.brutoMaand == brutoMaand &&
        other.dertiendeMaand == dertiendeMaand &&
        other.vakantiegeld == vakantiegeld &&
        other._brutoJaar == _brutoJaar;
  }

  @override
  int get hashCode {
    return jaarInkomenUit.hashCode ^
        brutoMaand.hashCode ^
        dertiendeMaand.hashCode ^
        vakantiegeld.hashCode ^
        _brutoJaar.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'jaarInkomenUit': jaarInkomenUit.index,
      'brutoMaand': brutoMaand,
      'dertiendeMaand': dertiendeMaand,
      'vakantiegeld': vakantiegeld,
      'brutoJaar': _brutoJaar,
    };
  }

  factory DetailsInkomen.fromMap(Map<String, dynamic> map) {
    return DetailsInkomen(
      jaarInkomenUit: JaarInkomenUit.values[map['jaarInkomenUit'].toInt() ?? 0],
      brutoMaand: map['brutoMaand']?.toDouble() ?? 0.0,
      dertiendeMaand: map['dertiendeMaand'] ?? false,
      vakantiegeld: map['vakantiegeld'] ?? false,
      brutoJaar: map['brutoJaar']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailsInkomen.fromJson(String source) =>
      DetailsInkomen.fromMap(json.decode(source));
}

class Inkomen {
  DateTime datum;
  bool partner;
  DetailsInkomen specificatie;
  double indexatie;
  DetailsInkomen pensioenSpecificatie;
  bool pensioen;

  Inkomen.empty(bool partner)
      : datum = DateTime(0),
        partner = partner,
        specificatie = DetailsInkomen(),
        indexatie = 0.0,
        pensioenSpecificatie = DetailsInkomen(),
        pensioen = false;

  Inkomen({
    required this.datum,
    required this.partner,
    required this.specificatie,
    required this.indexatie,
    required this.pensioenSpecificatie,
    required this.pensioen,
  });

  @override
  String toString() {
    return 'InkomenItem(datum: $datum, inkomen: $specificatie, indexatie: $indexatie, pensioenInkomen: $pensioenSpecificatie, pensioen: $pensioen)';
  }

  set indexatiePercentage(double percentage) => indexatie = percentage / 100.0;

  double get indexatiePercentage => indexatie * 100.0;

  Inkomen copyWith({
    DateTime? datum,
    bool? partner,
    DetailsInkomen? inkomen,
    double? indexatie,
    DetailsInkomen? pensioenInkomen,
    bool? pensioen,
  }) {
    return Inkomen(
      datum: datum ?? this.datum,
      partner: partner ?? this.partner,
      specificatie: inkomen ?? this.specificatie.copyWith(),
      indexatie: indexatie ?? this.indexatie,
      pensioenSpecificatie:
          pensioenInkomen ?? this.pensioenSpecificatie.copyWith(),
      pensioen: pensioen ?? this.pensioen,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Inkomen &&
        other.partner == partner &&
        other.datum == datum &&
        other.specificatie == specificatie &&
        other.indexatie == indexatie &&
        other.pensioenSpecificatie == pensioenSpecificatie &&
        other.pensioen == pensioen;
  }

  @override
  int get hashCode {
    return datum.hashCode ^
        partner.hashCode ^
        specificatie.hashCode ^
        indexatie.hashCode ^
        pensioenSpecificatie.hashCode ^
        pensioen.hashCode;
  }

  double brutoJaar(DateTime huidigeDatum) {
    return (pensioen
            ? pensioenSpecificatie.brutoJaar
            : specificatie.brutoJaar) *
        math.pow(1.0 + indexatie / 100.0, huidigeDatum.year - datum.year);
  }

  Map<String, dynamic> toMap() {
    return {
      'datum': datum.millisecondsSinceEpoch,
      'partner': partner,
      'inkomen': specificatie.toMap(),
      'indexatie': indexatie,
      'pensioenInkomen': pensioenSpecificatie.toMap(),
      'pensioen': pensioen,
    };
  }

  factory Inkomen.fromMap(Map<String, dynamic> map) {
    return Inkomen(
      datum: DateTime.fromMillisecondsSinceEpoch(map['datum']),
      partner: map['partner'] ?? false,
      specificatie: DetailsInkomen.fromMap(map['inkomen']),
      indexatie: map['indexatie']?.toDouble() ?? 0.0,
      pensioenSpecificatie: DetailsInkomen.fromMap(map['pensioenInkomen']),
      pensioen: map['pensioen'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Inkomen.fromJson(String source) =>
      Inkomen.fromMap(json.decode(source));
}
