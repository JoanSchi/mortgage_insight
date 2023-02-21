// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/schulden/autolease_verwerken.dart';
import 'package:mortgage_insight/model/nl/schulden/doorlopendkrediet_verwerken.dart';

import 'package:mortgage_insight/model/nl/schulden/schulden.dart';

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
    StateNotifierProvider<SchuldNotifier, SchuldBewerken>((ref) {
  return SchuldNotifier(SchuldBewerken());
});

class SchuldNotifier extends StateNotifier<SchuldBewerken> {
  SchuldNotifier(super.state);

  Schuld? get schuld => state.schuld;

  void resetSchuld() {
    state = SchuldBewerken();
  }

  void setSchuld({Schuld? schuld, SchuldItem? schuldItem}) {
    state = state.copyWith(schuld: schuld, selectedSchuldItem: schuldItem);
  }

  void updateSchuld(Schuld schuld) {
    state = state.copyWith(schuld: schuld);
  }

  void veranderingOmschrijving(String omschrijving) {
    state = state.copyWith(
        schuld: state.schuld?.copyWith(omschrijving: omschrijving));

    // state.copyWith(
    //     schuld: state.schuld?.map(
    //         leaseAuto: (LeaseAuto leaseAuto) =>
    //             leaseAuto.copyWith(omschrijving: omschrijving),
    //         verzendKrediet: (VerzendKrediet verzendKrediet) =>
    //             verzendKrediet.copyWith(omschrijving: omschrijving),
    //         doorlopendKrediet: (DoorlopendKrediet doorlopendKrediet) =>
    //             doorlopendKrediet.copyWith(omschrijving: omschrijving),
    //         aflopendKrediet: (AflopendKrediet aflopendKrediet) =>
    //             aflopendKrediet.copyWith(omschrijving: omschrijving)));
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
}

const aflopendKrediet = SchuldItem(
  categorie: SchuldenCategorie.aflopend_krediet,
  omschrijving: 'Aflopende Krediet',
  level: 0,
);

const verzendKrediet = SchuldItem(
  categorie: SchuldenCategorie.verzendhuiskrediet,
  omschrijving: 'Verzendhuiskrediet',
  level: 0,
);

const autolease = SchuldItem(
  categorie: SchuldenCategorie.operationele_autolease,
  omschrijving: 'Operationele Lease Auto',
  level: 0,
);

const doorlopendKrediet = SchuldItem(
  categorie: SchuldenCategorie.doorlopend_krediet,
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
