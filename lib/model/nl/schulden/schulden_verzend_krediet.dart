import 'dart:convert';
import 'package:mortgage_insight/utilities/Kalender.dart';
import 'schulden.dart';

class VerzendhuisKrediet extends Schuld {
  double totaalBedrag;
  double mndBedrag;
  double slotTermijn;
  int maanden;
  int minMaanden;
  int maxMaanden;
  bool isTotalbedrag;
  bool heeftSlotTermijn;
  int decimalen;

  VerzendhuisKrediet({
    int id = 0,
    required SchuldenCategorie categorie,
    String subCategorie: '',
    String omschrijving: '',
    DateTime? beginDatum,
    this.totaalBedrag = 0.0,
    this.mndBedrag = 0.0,
    this.slotTermijn = 0.0,
    this.maanden: 12,
    this.minMaanden = 1,
    this.maxMaanden = 120,
    this.heeftSlotTermijn = false,
    this.isTotalbedrag = true,
    this.decimalen = 0,
    Calculated berekend = Calculated.no,
    int error = 0,
  }) : super(
          id: id,
          categorie: categorie,
          subCategorie: subCategorie,
          omschrijving: omschrijving,
          beginDatum: beginDatum,
          berekend: berekend,
          error: error,
        );

  double maandLast(DateTime huidige) {
    if (huidige.compareTo(beginDatum) < 0 || huidige.compareTo(eindDatum) > 0) {
      return 0.0;
    } else if (heeftSlotTermijn &&
        huidige.isAfter(Kalender.voegPeriodeToe(eindDatum, maanden: -1))) {
      return slotTermijn;
    } else {
      return mndBedrag;
    }
  }

  DateTime get eindDatum =>
      DateTime(beginDatum.year, beginDatum.month + maanden, beginDatum.day);

  set bedrag(double bedrag) {
    if (isTotalbedrag) {
      totaalBedrag = bedrag;
    } else {
      mndBedrag = bedrag;
    }
  }

  double get bedrag => isTotalbedrag ? totaalBedrag : mndBedrag;

  setSlottermijn(double slotBedrag) {
    slotTermijn = slotBedrag;

    totaalBedrag = heeftSlotTermijn
        ? (maanden - 1) * mndBedrag + slotBedrag
        : maanden * mndBedrag;
  }

  berekenen() {
    berekend = Calculated.no;

    if ((isTotalbedrag ? totaalBedrag == 0.0 : mndBedrag == 0.0) ||
        maanden == 0) {
      return;
    }

    if (isTotalbedrag) {
      if (totaalBedrag > 0.0 && maanden != 0) {
        int afronden;

        switch (decimalen) {
          case 1:
            {
              afronden = 10;
              break;
            }
          case 2:
            {
              afronden = 100;
              break;
            }
          default:
            {
              afronden = 1;
            }
        }

        if (maanden == 1 ||
            (totaalBedrag * afronden % maanden) / afronden == 0) {
          mndBedrag = totaalBedrag / maanden;
          slotTermijn = 0.0;
          heeftSlotTermijn = false;
        } else {
          mndBedrag =
              (totaalBedrag * afronden / maanden).ceilToDouble() / afronden;
          slotTermijn = totaalBedrag % mndBedrag;
          heeftSlotTermijn = slotTermijn != 0.0;
        }
      }
    } else {
      if (mndBedrag > 0.0 && maanden != 0) {
        if (heeftSlotTermijn && slotTermijn > 0.0) {
          totaalBedrag = (maanden - 1) * mndBedrag + slotTermijn;
        } else {
          totaalBedrag = maanden * mndBedrag;
          slotTermijn = 0.0;
        }
      }
    }

    berekend = Calculated.yes;
  }

  @override
  VerzendhuisKrediet copyWith({
    int? id,
    SchuldenCategorie? categorie,
    String? subCategorie,
    String? omschrijving,
    DateTime? beginDatum,
    Calculated? berekend,
    double? totaalBedrag,
    double? mndBedrag,
    double? slottermijn,
    int? maanden,
    int? minMaanden,
    int? maxMaanden,
    bool? isTotalbedrag,
    bool? heeftSlotTermijn,
    int? decimalen,
    int? error,
  }) {
    return VerzendhuisKrediet(
      id: id ?? this.id,
      categorie: categorie ?? this.categorie,
      subCategorie: subCategorie ?? this.subCategorie,
      omschrijving: omschrijving ?? this.omschrijving,
      beginDatum: beginDatum ?? this.beginDatum,
      berekend: berekend ?? this.berekend,
      totaalBedrag: totaalBedrag ?? this.totaalBedrag,
      mndBedrag: mndBedrag ?? this.mndBedrag,
      slotTermijn: slottermijn ?? this.slotTermijn,
      maanden: maanden ?? this.maanden,
      minMaanden: minMaanden ?? this.minMaanden,
      maxMaanden: maxMaanden ?? this.maxMaanden,
      isTotalbedrag: isTotalbedrag ?? this.isTotalbedrag,
      heeftSlotTermijn: heeftSlotTermijn ?? this.heeftSlotTermijn,
      decimalen: decimalen ?? this.decimalen,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return super == (other) &&
        other is VerzendhuisKrediet &&
        other.totaalBedrag == totaalBedrag &&
        other.mndBedrag == mndBedrag &&
        other.slotTermijn == slotTermijn &&
        other.maanden == maanden &&
        other.minMaanden == minMaanden &&
        other.maxMaanden == maxMaanden &&
        other.isTotalbedrag == isTotalbedrag &&
        other.heeftSlotTermijn == heeftSlotTermijn &&
        other.decimalen == decimalen;
  }

  @override
  int get hashCode {
    return super.hashCode ^
        totaalBedrag.hashCode ^
        mndBedrag.hashCode ^
        slotTermijn.hashCode ^
        maanden.hashCode ^
        minMaanden.hashCode ^
        maxMaanden.hashCode ^
        isTotalbedrag.hashCode ^
        heeftSlotTermijn.hashCode ^
        decimalen.hashCode;
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
      // VerzendhuisKrediet
      'totaalBedrag': totaalBedrag,
      'mndBedrag': mndBedrag,
      'slotTermijn': slotTermijn,
      'maanden': maanden,
      'minMaanden': minMaanden,
      'maxMaanden': maxMaanden,
      'isTotalbedrag': isTotalbedrag,
      'heeftSlotTermijn': heeftSlotTermijn,
      'decimalen': decimalen,
    };
  }

  factory VerzendhuisKrediet.fromMap(Map<String, dynamic> map) {
    return VerzendhuisKrediet(
      id: map['id']?.toInt(),
      categorie: SchuldenCategorie.values[map['categorie'].toInt()],
      subCategorie: map['subCategorie'],
      omschrijving: map['omschrijving'],
      beginDatum: DateTime.parse(map['beginDatum']).toLocal(),
      berekend: Calculated.values[map['berekend'].toInt()],
      error: map['error']?.toInt(),
      // VerzendhuisKrediet
      totaalBedrag: map['totaalBedrag']?.toDouble(),
      mndBedrag: map['mndBedrag']?.toDouble(),
      slotTermijn: map['slotTermijn']?.toDouble(),
      maanden: map['maanden']?.toInt(),
      minMaanden: map['minMaanden']?.toInt(),
      maxMaanden: map['maxMaanden']?.toInt(),
      isTotalbedrag: map['isTotalbedrag'],
      heeftSlotTermijn: map['heeftSlotTermijn'],
      decimalen: map['decimalen']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VerzendhuisKrediet.fromJson(String source) =>
      VerzendhuisKrediet.fromMap(json.decode(source));
}
