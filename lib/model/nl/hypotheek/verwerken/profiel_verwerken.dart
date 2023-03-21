import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:sliver_row_box/sliver_row_box.dart';
import '../../../../utilities/kalender.dart';
import '../gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import '../gegevens/hypotheek_dossier/hypotheek_dossier.dart';

class HypotheekDossierVerwerken {
  static DateTime beginDatumWoningKopen() => DateUtils.dateOnly(DateTime.now());

  static DateTime eindDatumWoningKopen() =>
      Kalender.voegPeriodeToe(DateTime.now(), jaren: 5);

  /// Eigenwoningreserve
  ///
  ///
  ///
  ///
  ///
  ///
  static bool eigenwoningReserveOptie(HypotheekDossier? hd) {
    if (hd == null) return false;

    return !hd.starter &&
        (hd.inkomensNormToepassen || hd.woningWaardeNormToepassen);
  }

  static bool eigenwoningReserveZichtbaar(HypotheekDossier? hd) {
    if (hd == null) return false;

    return !hd.starter &&
        (hd.inkomensNormToepassen || hd.woningWaardeNormToepassen) &&
        hd.eigenWoningReserve.ewrToepassen;
  }

  static bool woningGegevensZichtbaar(HypotheekDossier? hd) {
    if (hd == null) return false;

    return !hd.starter &&
        (hd.inkomensNormToepassen || hd.woningWaardeNormToepassen) &&
        hd.eigenWoningReserve.ewrToepassen &&
        hd.eigenWoningReserve.ewrBerekenen;
  }

  /// SliverBoxRow
  ///
  ///
  ///
  ///
  ///

  static List<SliverBoxItemState<String>> createTop(
      HypotheekDossier? hypotheekProfiel, bool zichtbaar) {
    if (hypotheekProfiel == null) return [];

    ItemStatusSliverBox status =
        zichtbaar ? ItemStatusSliverBox.visible : ItemStatusSliverBox.invisible;
    return [
      SliverBoxItemState(
          key: 'topPadding', height: 72.0, status: status, value: 'topPadding'),
      SliverBoxItemState(
          key: 'woningTitle',
          height: 72.0,
          status: status,
          value: 'woningTitle'),
      SliverBoxItemState(
          key: 'woning', height: 72.0, status: status, value: 'woning'),
      SliverBoxItemState(
          key: 'lening', height: 72.0, status: status, value: 'lening'),
      SliverBoxItemState(
          key: 'kostenTitle',
          height: 72.0,
          status: status,
          value: 'kostenTitle'),
    ];
  }

  static List<SliverBoxItemState<Waarde>> createBody(
      HypotheekDossier? hypotheekProfiel, bool zichtbaar) {
    if (hypotheekProfiel == null) return [];

    return hypotheekProfiel.vorigeWoningKosten.kosten
        .map((Waarde e) => SliverBoxItemState<Waarde>(
            key: e.key,
            value: e,
            height: 72.0,
            status: zichtbaar
                ? ItemStatusSliverBox.visible
                : ItemStatusSliverBox.invisible))
        .toList()
      ..sort((a, b) => a.value.index.compareTo(b.value.index));
  }

  static List<SliverBoxItemState<String>> createBottom(
      HypotheekDossier? hypotheekProfiel, bool zichtbaar) {
    if (hypotheekProfiel == null) return [];

    ItemStatusSliverBox status =
        zichtbaar ? ItemStatusSliverBox.visible : ItemStatusSliverBox.invisible;
    return [
      SliverBoxItemState(
          key: 'totaleKosten',
          height: 72.0,
          status: status,
          value: 'totaleKosten'),
      SliverBoxItemState(
          key: 'bottom', height: 72.0, status: status, value: 'bottom'),
    ];
  }

  /// Suggestie kostenlijst
  ///
  ///
  ///
  ///
  ///

  static List<Waarde> suggestieKosten(HypotheekDossier hd) {
    List<Waarde> resterend = [];
    IList<Waarde> lijst = hd.vorigeWoningKosten.kosten;
    List<Waarde> suggestieLijst = suggestieKostenVorigeWoning;

    for (Waarde w in suggestieLijst) {
      if (lijst.indexWhere((Waarde aanwezig) => aanwezig.id == w.id) == -1) {
        resterend.add(w);
      }
    }
    return resterend..add(leegKosten);
  }

  /// Kosten
  ///
  ///
  ///
  ///
  ///

  static const suggestieKostenVorigeWoning = <Waarde>[
    Waarde(
        id: 'makelaar',
        index: 0,
        omschrijving: 'makelaar',
        getal: 3000.0,
        eenheid: Eenheid.bedrag,
        standaard: true),
    Waarde(
        id: 'energielabel',
        index: 1,
        omschrijving: 'energielabel',
        getal: 200.0,
        eenheid: Eenheid.bedrag,
        standaard: true),
    Waarde(
        id: 'advertentie',
        index: 2,
        omschrijving: 'advertentie',
        getal: 150.0,
        eenheid: Eenheid.bedrag,
        standaard: true),
  ];

  static const leegKosten = Waarde(
      id: 'eigen',
      index: 1000,
      omschrijving: '',
      getal: 0.0,
      eenheid: Eenheid.bedrag,
      standaard: false,
      aftrekbaar: false,
      verduurzamen: false);
}