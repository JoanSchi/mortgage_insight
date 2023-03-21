// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/schulden/aflopend_krediet_verwerken.dart';
import 'package:mortgage_insight/model/nl/schulden/autolease_verwerken.dart';
import 'package:mortgage_insight/model/nl/schulden/doorlopendkrediet_verwerken.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden.dart';
import 'package:mortgage_insight/model/nl/schulden/verzendkrediet_verwerken.dart';
import 'package:mortgage_insight/model/settings/table_month_options.dart';

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
              id: -1,
              omschrijving: 'AK',
              categorie: SchuldenCategorie.aflopendKrediet,
              beginDatum: beginDatum,
              betaling: AKbetaling.ingangsdatum,
              decimalen: 2,
              tableMonthOptions: const TableMonthOptions(
                  monthsVisible: IListConst([
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true,
                    true
                  ]),
                  deviate: true,
                  startEnd: true),
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
              id: -1,
              categorie: SchuldenCategorie.doorlopendKrediet,
              omschrijving: 'DK',
              beginDatum: beginDatum,
              statusBerekening: StatusBerekening.nietBerekend,
              error: '',
              eindDatumGebruiker: Kalender.voegPeriodeToe(beginDatum, jaren: 1, periodeOpties: PeriodeOpties.eind),
              heeftEindDatum: true,
              bedrag: 0.0,
            ),
            schuldItem: item);
        break;
      case SchuldenCategorie.verzendhuiskrediet:
        setSchuld(
            schuld: VerzendKrediet(
                id: -1,
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
                id: -1,
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
