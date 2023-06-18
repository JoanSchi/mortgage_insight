// Copyright (C) 2023 Joan Schipper
// 
// This file is part of mortgage_insight.
// 
// mortgage_insight is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// mortgage_insight is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:hypotheek_berekeningen/schulden/uitwerken/aflopend_krediet_verwerken.dart';
import 'package:hypotheek_berekeningen/schulden/uitwerken/autolease_verwerken.dart';
import 'package:hypotheek_berekeningen/schulden/uitwerken/doorlopendkrediet_verwerken.dart';
import 'package:hypotheek_berekeningen/schulden/uitwerken/verzendkrediet_verwerken.dart';
import '../../utilities/kalender.dart';

class SchuldBewerken {
  Schuld? schuld;
  SchuldItem? selectedSchuldItem;
  int page = 0;

  SchuldBewerken({
    this.schuld,
    this.selectedSchuldItem,
    this.page = 0,
  });

  SchuldBewerken copyWith({
    Schuld? schuld,
    SchuldItem? selectedSchuldItem,
    int? page,
  }) {
    return SchuldBewerken(
      schuld: schuld ?? this.schuld,
      selectedSchuldItem: selectedSchuldItem ?? this.selectedSchuldItem,
      page: page ?? this.page,
    );
  }
}

final schuldProvider =
    StateNotifierProvider<SchuldBewerkNotifier, SchuldBewerken>((ref) {
  return SchuldBewerkNotifier(SchuldBewerken());
});

class SchuldBewerkNotifier extends StateNotifier<SchuldBewerken> {
  SchuldBewerkNotifier(super.state);

  Schuld? get schuld => state.schuld;

  void resetSchuld() {
    state = SchuldBewerken();
  }

  void selectSchuld(SchuldItem item) {
    if (item.categorie == schuld?.categorie) {
      return;
    }

    final beginDatum = DateUtils.dateOnly(DateTime.now());

    switch (item.categorie) {
      case SchuldenCategorie.aflopendKrediet:
        setSchuld(
            schuld: AflopendKrediet(
              id: '',
              omschrijving: 'AK',
              categorie: SchuldenCategorie.aflopendKrediet,
              beginDatum: beginDatum,
              betaling: AKbetaling.ingangsdatum,
              decimalen: 2,
              defaultAflossenPerMaand: 0.0,
              lening: 0.0,
              maanden: 12,
              minMaanden: 1,
              maxMaanden: 120,
              rente: 5.0,
              minAflossenPerMaand: 1.0,
              maxAflossenPerMaand: 5000.0,
              eersteGebrokenMaandAlleenRente: true,
              minTermijnBedragMnd: 1.0,
              error: '',
              slotTermijn: 0.0,
              somAnn: 0.0,
              somInterest: 0.0,
              statusBerekening: StatusBerekening.nietBerekend,
              termijnBedragMnd: 0.0,
              termijnen: const IListConst([]),
            ),
            schuldItem: item);
        break;
      case SchuldenCategorie.doorlopendKrediet:
        setSchuld(
            schuld: DoorlopendKrediet(
              id: '',
              categorie: SchuldenCategorie.doorlopendKrediet,
              omschrijving: 'DK',
              beginDatum: beginDatum,
              statusBerekening: StatusBerekening.nietBerekend,
              error: '',
              eindDatumGebruiker: Kalender.voegPeriodeToe(beginDatum,
                  jaren: 1, periodeOpties: PeriodeOpties.eind),
              heeftEindDatum: true,
              bedrag: 0.0,
            ),
            schuldItem: item);
        break;
      case SchuldenCategorie.verzendhuiskrediet:
        setSchuld(
            schuld: VerzendKrediet(
                id: '',
                categorie: SchuldenCategorie.verzendhuiskrediet,
                omschrijving: 'VK',
                beginDatum: beginDatum,
                statusBerekening: StatusBerekening.nietBerekend,
                error: '',
                decimalen: 2,
                heeftSlotTermijn: false,
                vkBedrag: VKbedrag.totaal,
                minMaanden: 1,
                maxMaanden: 60,
                maanden: 12,
                mndBedrag: 0.0,
                totaalBedrag: 0.0,
                slotTermijn: 0.0),
            schuldItem: item);
        break;
      case SchuldenCategorie.autolease:
        setSchuld(
            schuld: LeaseAuto(
                id: '',
                categorie: SchuldenCategorie.autolease,
                omschrijving: 'Lease Auto',
                beginDatum: beginDatum,
                statusBerekening: StatusBerekening.nietBerekend,
                error: '',
                jaren: 2,
                maanden: 0,
                mndBedrag: 0.0),
            schuldItem: item);
        break;
    }
  }

  void setSchuld({Schuld? schuld, SchuldItem? schuldItem}) {
    state = state.copyWith(schuld: schuld, selectedSchuldItem: schuldItem);
  }

  void editSchuld(Schuld schuld) {
    state = state = SchuldBewerken(schuld: schuld.copyWith());
  }

  void updateSchuld(Schuld schuld) {
    state = state.copyWith(schuld: schuld);
  }

  void veranderingOmschrijving(String omschrijving) {
    state = state.copyWith(
        schuld: state.schuld?.copyWith(omschrijving: omschrijving));
  }

  void veranderingDoorlopendKrediet(
      {DateTime? beginDatum,
      bool? heeftEindDatum,
      DateTime? eindDatumGebruiker,
      double? bedrag}) {
    state = state.copyWith(
        schuld: state.schuld?.mapOrNull<Schuld>(
            doorlopendKrediet: (DoorlopendKrediet dk) =>
                DoorlopendKredietVerwerken.verandering(dk,
                    beginDatum: beginDatum,
                    heeftEindDatum: heeftEindDatum,
                    eindDatumGebruiker: eindDatumGebruiker,
                    bedrag: bedrag)));
  }

  void veranderingLeaseAuto(
      {DateTime? datum, double? bedrag, int? jaren, int? maanden}) {
    state = state.copyWith(
        schuld: state.schuld?.mapOrNull<Schuld>(
            leaseAuto: (LeaseAuto leaseAuto) => LeaseAutoVerwerken.verandering(
                leaseAuto,
                datum: datum,
                jaren: jaren,
                maanden: maanden,
                bedrag: bedrag)));
  }

  void veranderingVerzendKrediet(
      {DateTime? beginDatum,
      int? maanden,
      VKbedrag? vkBedrag,
      double? bedrag,
      bool? heeftSlotTermijn,
      double? slotBedrag,
      int? decimalen}) {
    state = state.copyWith(schuld:
        state.schuld?.mapOrNull<Schuld>(verzendKrediet: (VerzendKrediet vk) {
      return VerzendKredietVerwerken.veranderen(vk,
          beginDatum: beginDatum,
          maanden: maanden,
          vkBedrag: vkBedrag,
          bedrag: bedrag,
          heeftSlotTermijn: heeftSlotTermijn,
          slotBedrag: slotBedrag,
          decimalen: decimalen);
    }));
  }

  void veranderingAflopendKrediet(
      {DateTime? beginDatum,
      double? lening,
      double? rente,
      double? termijnBedragMnd,
      int? maanden,
      AKbetaling? betaling,
      bool? eersteGebrokenMaandAlleenRente,
      int? decimalen}) {
    state = state.copyWith(schuld:
        state.schuld?.mapOrNull<Schuld>(aflopendKrediet: (AflopendKrediet ak) {
      return AflopendKredietVerwerken.verandering(ak,
          beginDatum: beginDatum,
          lening: lening,
          rente: rente,
          termijnBedragMnd: termijnBedragMnd,
          maanden: maanden,
          betaling: betaling,
          eersteGebrokenMaandAlleenRente: eersteGebrokenMaandAlleenRente,
          decimalen: decimalen);
    }));
  }
}

const aflopendKrediet = SchuldItem(
  categorie: SchuldenCategorie.aflopendKrediet,
  omschrijving: 'Aflopende Krediet',
  level: 0,
);

const verzendKrediet = SchuldItem(
  categorie: SchuldenCategorie.verzendhuiskrediet,
  omschrijving: 'Verzendhuiskrediet',
  level: 0,
);

const autolease = SchuldItem(
  categorie: SchuldenCategorie.autolease,
  omschrijving: 'Operationele Lease Auto',
  level: 0,
);

const doorlopendKrediet = SchuldItem(
  categorie: SchuldenCategorie.doorlopendKrediet,
  omschrijving: 'Doorlopend Krediet',
  level: 0,
);

const schuldenLijst = <SchuldItem>[
  aflopendKrediet,
  verzendKrediet,
  autolease,
  doorlopendKrediet,
];

class SchuldItem {
  final SchuldenCategorie categorie;
  final String omschrijving;
  final int level;

  const SchuldItem({
    required this.categorie,
    required this.omschrijving,
    required this.level,
  });
}
