import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:mortgage_insight/model/nl/schulden/autolease_verwerken.dart';
import 'package:mortgage_insight/model/nl/schulden/doorlopendkrediet_verwerken.dart';

import '../../../utilities/Kalender.dart';
import 'remove_schulden_aflopend_krediet.dart';
import 'verzendkrediet_verwerken.dart';

part 'schulden.freezed.dart';
part 'schulden.g.dart';

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

enum SchuldenCategorie {
  aflopend_krediet,
  doorlopend_krediet,
  verzendhuiskrediet,
  operationele_autolease
}

enum StatusBerekening { berekend, nietBerekend, fout }

@freezed
class SchuldenOverzicht with _$SchuldenOverzicht {
  const factory SchuldenOverzicht({required IList<Schuld> lijst}) =
      _SchuldenOverzicht;

  factory SchuldenOverzicht.fromJson(Map<String, Object?> json) =>
      _$SchuldenOverzichtFromJson(json);
}

@freezed
class Schuld with _$Schuld {
  const Schuld._();

  const factory Schuld.leaseAuto({
    required int id,
    required SchuldenCategorie categorie,
    required String omschrijving,
    required DateTime beginDatum,
    required StatusBerekening statusBerekening,
    required String error,
    //
    required double mndBedrag,
    required int jaren,
    required int maanden,
  }) = LeaseAuto;

  const factory Schuld.verzendKrediet({
    required int id,
    required SchuldenCategorie categorie,
    required String omschrijving,
    required DateTime beginDatum,
    required StatusBerekening statusBerekening,
    required String error,
    //
    required double totaalBedrag,
    required double mndBedrag,
    required double slotTermijn,
    required int maanden,
    required int minMaanden,
    required int maxMaanden,
    required bool isTotalbedrag,
    required bool heeftSlotTermijn,
    required int decimalen,
  }) = VerzendKrediet;

  const factory Schuld.doorlopendKrediet({
    required int id,
    required SchuldenCategorie categorie,
    required String omschrijving,
    required DateTime beginDatum,
    required StatusBerekening statusBerekening,
    required String error,
    //
    required double bedrag,
    required DateTime eindDatumGebruiker,
    required bool heeftEindDatum,
  }) = DoorlopendKrediet;

  const factory Schuld.aflopendKrediet(
      {required int id,
      required SchuldenCategorie categorie,
      required String omschrijving,
      required DateTime beginDatum,
      required StatusBerekening statusBerekening,
      required String error,
      //
      required double lening,
      required double rente,
      required double termijnBedragMnd,
      required double minTermijnBedragMnd,
      required int maanden,
      required int minMaanden,
      required int maxMaanden,
      required double minAflossenPerMaand,
      required double maxAflossenPerMaand,
      required double defaultAflossenPerMaand,
      required IList<AKtermijnAnn> termijnen,
      required double somInterest,
      required double somAnn,
      required double slotTermijn,
      required AflosTabelOpties aflosTabelOpties,
      required int decimalen,
      required bool renteGebrokenMaand,
      required AKbetaling betaling}) = AflopendKrediet;

  factory Schuld.fromJson(Map<String, Object?> json) => _$SchuldFromJson(json);

  DateStatus dateStatus(DateTime huidigeDatum) {
    huidigeDatum = DateUtils.dateOnly(huidigeDatum);

    if (beginDatum.compareTo(huidigeDatum) > 0) {
      return DateStatus.before;
    }

    if (eindDatum.compareTo(huidigeDatum) >= 0) {
      return DateStatus.now;
    }
    return DateStatus.after;
  }

  DateTime get eindDatum {
    return map(leaseAuto: (LeaseAuto leaseAuto) {
      return LeaseAutoVerwerken.eindDatum(leaseAuto);
    }, aflopendKrediet: (AflopendKrediet ak) {
      return DateTime(0);
    }, verzendKrediet: (VerzendKrediet vk) {
      return VerzendKredietVerwerken.eindDatum(vk);
    }, doorlopendKrediet: (DoorlopendKrediet dk) {
      return DoorlopendKredietVerwerken.eindDatum(dk);
    });
  }

  double maandLast(DateTime huidige) {
    return map(leaseAuto: (LeaseAuto leaseAuto) {
      return LeaseAutoVerwerken.maandLast(leaseAuto, huidige);
    }, aflopendKrediet: (AflopendKrediet value) {
      return 0;
    }, verzendKrediet: (VerzendKrediet vk) {
      return VerzendKredietVerwerken.maandLast(vk, huidige);
    }, doorlopendKrediet: (DoorlopendKrediet dk) {
      return DoorlopendKredietVerwerken.maandLast(dk, huidige);
    });
  }
}

@freezed
class AKtermijnAnn with _$AKtermijnAnn {
  const factory AKtermijnAnn(
      {required DateTime termijn,
      required double interest,
      required double aflossen,
      required double schuld,
      required double termijnBedrag}) = _AKtermijnAnn;

  factory AKtermijnAnn.fromJson(Map<String, Object?> json) =>
      _$AKtermijnAnnFromJson(json);
}
