import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import 'package:mortgage_insight/model/nl/hypotheek/kosten_hypotheek.dart';
import 'package:mortgage_insight/utilities/Kalender.dart';
import '../../../model/nl/hypotheek/hypotheek_doorbereken.dart';
import '../../../model/nl/hypotheek/financierings_norm/norm.dart';
import '../../../model/nl/inkomen/inkomen.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../my_widgets/sliver_row_box.dart';
import '../../../utilities/MyNumber.dart';
import 'hypotheek_bewerken.dart';

class HypotheekEdit {
  String id;
  HypotheekProfiel profiel;
  Map<String, dynamic> map = {};

  Hypotheek get hypotheek => profiel.hypotheken[id]!;

  HypotheekEdit({
    this.id = '',
    required HypotheekProfiel profiel,
  }) : profiel = profiel.copyWith();
}

class HypotheekViewModel with ChangeNotifier {
  String id;
  HypotheekProfiel originineelProfiel;
  HypotheekProfiel profiel;
  Map<String, dynamic> map = {};

  Hypotheek get hypotheek => profiel.hypotheken[id]!;

  bool isBerekend = true;
  Map<DateTime, RestSchuld> restSchuld = {};

  TermijnPeriodePanelState? termijnPeriodeNhgState;
  HypotheekBewerkDatumVerlengenState? hypotheekBewerkDatumVerlengenState;
  HypotheekBewerkOmschrijvingToevoegOptieState?
      hypotheekBewerkOmschrijvingKeuzeState;
  LeningPanelState? leningPanelState;
  HypotheekKostenPanelState? hypotheekKostenPanelState;
  VerduurzamenPanelState? verduurzamenPanelState;

  final List<Inkomen> inkomenLijst;
  final List<Inkomen> inkomenLijstPartner;
  final List<Schuld> schuldenLijst;
  List<Hypotheek> verlengen = [];
  String idVerlengenGeselecteerd = '';
  int bepaaldeMaximaleTermijnInJaren = 0;

  final huidigeDatum = DateUtils.dateOnly(DateTime.now());

  bool veranderTextLening = false;

  HypotheekViewModel(
      {this.id = '',
      required HypotheekProfiel profiel,
      required this.inkomenLijst,
      required this.inkomenLijstPartner,
      required this.schuldenLijst})
      : originineelProfiel = profiel,
        profiel = profiel.copyWith() {
    if (id.isEmpty) {
      nieuweHypotheek();
    } else {
      bestaandeHypotheek(id);
    }

    initialiseerTeVerlengenHypotheek();
    schuldVorigeLening();

    if (verlengen.isNotEmpty) {
      idVerlengenGeselecteerd = verlengen[0].id;
    }

    restSchuldInventarisatie();
  }

  void nieuweHypotheek() {
    double lening;

    if (verlengen.isEmpty) {
      lening = 0.0;
    } else {
      lening = verlengen.first.termijnen.last.lening;
    }

    final startDatum = hypotheekDatumSuggestie;

    bepaaldeMaximaleTermijnInJaren = _maxTermijnenInJarenStartDatum(startDatum);

    final Hypotheek hypotheek = Hypotheek(
        startDatum: startDatum,
        aflosTermijnInMaanden: bepaaldeMaximaleTermijnInJaren * 12,
        optiesHypotheekToevoegen: OptiesHypotheekToevoegen.nieuw,
        periodeInMaanden: 10 * 12,
        gewensteLening: lening,
        rente: 1.0,
        maxLeningInkomen:
            NormInkomen(order: 0, toepassen: profiel.inkomensNormToepassen),
        maxLeningWoningWaarde: DefaultNorm(
          order: 1,
          toepassen: profiel.woningWaardeNormToepassen,
        ),
        maxLeningNHG: DefaultNorm(order: 2),
        woningLeningKosten: WoningLeningKostenGegevens(
            woningWaarde: profiel.woningWaardeVinden(startDatum)));

    id = hypotheek.id;
    profiel.addHypotheek(hypotheek);

    if (!hypotheek.afgesloten) {
      DoorBerekenen(
              profiel: profiel,
              inkomenLijst: inkomenLijst,
              inkomenPartnerLijst: inkomenLijstPartner,
              schuldenLijst: schuldenLijst)
          .doorbereken(tm: hypotheek);
    }

    hypotheek.normaliseerLening();

    if (hypotheek.lening > 0.0) {
      hypotheek
        ..opschonen()
        ..termijnenAanmaken()
        ..voegRenteToe()
        ..berekenPeriode();
    }
  }

  bestaandeHypotheek(String id) {
    DoorBerekenen(
            profiel: profiel,
            inkomenLijst: inkomenLijst,
            inkomenPartnerLijst: inkomenLijstPartner,
            schuldenLijst: schuldenLijst)
        .doorbereken(tm: hypotheek);

    controleMaximaleJaren();
  }

  void linkAanVorige(String vorigeID) {
    if (hypotheek.vorige == vorigeID) return;

    if (hypotheek.vorige.isEmpty) {
      assert(profiel.eersteHypotheken.contains(hypotheek),
          'Veranderen aanmaak hypotheek in verlengen: Hypotheek niet gevonden in eersteHypotheken lijst!');

      profiel.eersteHypotheken.remove(hypotheek);
    } else {
      final oudeVorigeHypotheek = profiel.hypotheken[hypotheek.vorige]!;
      oudeVorigeHypotheek.volgende = '';
    }

    final vorigeHypotheek = profiel.hypotheken[vorigeID]!;

    vorigeHypotheek.volgende = hypotheek.id;
    hypotheek.vorige = vorigeID;

    hypotheek.startDatum = vorigeHypotheek.eindDatum;
    hypotheek.lening = vorigeHypotheek.restSchuld;
    hypotheek.gewensteLening = vorigeHypotheek.restSchuld;
  }

  void verwijderLinkVorige() {
    if (hypotheek.vorige.isEmpty) {
      return;
    }
    final vorigeHypotheek = profiel.hypotheken[hypotheek.vorige]!;

    vorigeHypotheek.volgende = '';
    hypotheek.vorige = '';

    assert(!profiel.eersteHypotheken.contains(hypotheek),
        'Link vorige hypotheek verwijderen: Hypotheek bevindt zich al in eersteHypotheken lijst, dit zou niet mogelijk moeten zijn!');

    profiel.eersteHypotheken.add(hypotheek);
  }

  void controleMaximaleJaren() {
    switch (hypotheek.optiesHypotheekToevoegen) {
      case OptiesHypotheekToevoegen.nieuw:
        bepaaldeMaximaleTermijnInJaren = _maxTermijnenInJaren;
        break;
      case OptiesHypotheekToevoegen.verlengen:
        bepaaldeMaximaleTermijnInJaren = termijnResterend() ~/ 12;
        break;
    }

    if (bepaaldeMaximaleTermijnInJaren < hypotheek.aflosTermijnInJaren) {
      hypotheek.aflosTermijnInJaren = bepaaldeMaximaleTermijnInJaren;
    }

    if (hypotheek.aflosTermijnInMaanden < hypotheek.periodeInMaanden) {
      hypotheek.periodeInMaanden = hypotheek.aflosTermijnInMaanden;
    }
  }

  int termijnResterend() {
    Hypotheek? vorigeHypoteek = profiel.hypotheken[hypotheek.vorige];

    return (vorigeHypoteek != null)
        ? (vorigeHypoteek.aflosTermijnInMaanden -
            vorigeHypoteek.periodeInMaanden)
        : _maxTermijnenInJaren;
  }

  void initialiseerTeVerlengenHypotheek() {
    zoek(String id) {
      if (id == hypotheek.id) return;

      final h = profiel.hypotheken[id];

      assert(h != null,
          'By initialiseren te verlengen hypotheken moet zoeken op id niet null opleveren!');

      if (h == null) return;

      if (h.volgende.isEmpty || h.volgende == hypotheek.id) {
        if (h.restSchuld > 1.0) {
          verlengen.add(h);
        }
        return;
      }

      zoek(h.volgende);
    }

    for (Hypotheek h in profiel.eersteHypotheken) {
      zoek(h.id);
    }
  }

  restSchuldInventarisatie() {
    profiel.hypotheken.values.forEach((Hypotheek h) {
      if (h != hypotheek && h.restSchuld > 0.0) {
        RestSchuld? r = restSchuld[h.eindDatum]?..toevoegen(h.restSchuld);

        if (r == null) {
          restSchuld[h.eindDatum] =
              RestSchuld(datum: h.eindDatum, restSchuld: h.restSchuld);
        }
      }
    });

    profiel.hypotheken.values.forEach((Hypotheek h) {
      if (h != hypotheek) {
        restSchuld[h.startDatum]?.verwijderen(h.lening);
      }
    });

    restSchuld.removeWhere((key, value) => value.restSchuld < 0.01);
  }

  schuldVorigeLening() {
    if (hypotheek.vorige.isNotEmpty) {
      double restSchuld = profiel.hypotheken[hypotheek.vorige]!.restSchuld;
      hypotheek.gewensteLening = restSchuld;
    }
  }

  veranderingLening(double value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.gewensteLening = value;
    });
  }

  veranderingMaximaleLening(double value) {
    calculatedAndNotify((Hypotheek old) {
      veranderTextLening = true;
      hypotheek.gewensteLening =
          roundTwoDecimal(hypotheek.maxLening.resterend / 100.0 * value);
    });
  }

  veranderingRente(double value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.rente = value;
    });
  }

  veranderenAflostermijnInJaren(int value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.aflosTermijnInJaren = value;
      controleMaximaleJaren();
      controleerDatumDeelsAfgelosteLening();
    });
  }

  veranderenPeriodeInJaren(int value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.periodeInJaren = value;
      controleerDatumDeelsAfgelosteLening();
    });
  }

  veranderingOmschrijving(String value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.omschrijving = value;
    });
  }

  veranderingNHG(bool value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.maxLeningNHG.toepassen = value;

      if (value) {
        if (hypotheek.hypotheekvorm == HypotheekVorm.Aflosvrij)
          hypotheek.hypotheekvorm = HypotheekVorm.Annuity;
      } else {
        valueFromMap('laatst_gekozen_hypotheek_vorm', to: (value) {
          hypotheek.hypotheekvorm = value;
        });
      }

      kostenAanpassen(
          waarde: WoningLeningKostenGegevens.borgNHG,
          kostenlijst: hypotheek.woningLeningKosten.kosten,
          toevoegen: hypotheek.maxLeningNHG.toepassen,
          itemlijst: hypotheekKostenPanelState?.sliverBoxList);
    });
  }

  veranderingVerduurzamenToepassen(bool value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.verbouwVerduurzaamKosten.toepassen = value;
    });
  }

  veranderingHypotheekToevoegen(OptiesHypotheekToevoegen value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.optiesHypotheekToevoegen = value;

      void bewaar(String optie) {
        valueToMap('aflostermijn_$optie', old.aflosTermijnInMaanden);
        valueToMap('periode_$optie', old.periodeInMaanden);
        if (!optie.startsWith('verlengen'))
          valueToMap('startDatum_$optie', old.startDatum);
        valueToMap('nhg_$optie', old.maxLeningNHG.toepassen);
        valueToMap(
            'verduurzamen_$optie', old.verbouwVerduurzaamKosten.toepassen);
        valueToMap('hypotheekvorm_$optie', old.hypotheekvorm);
      }

      switch (old.optiesHypotheekToevoegen) {
        case OptiesHypotheekToevoegen.nieuw:
          bewaar('nieuw');
          break;
        case OptiesHypotheekToevoegen.verlengen:
          bewaar('verlengen_${hypotheek.vorige}');
          break;
      }

      void herstel(String optie) {
        valueFromMap('aflostermijn_$optie',
            to: (value) => hypotheek.aflosTermijnInMaanden = value,
            dv: () => optie.startsWith('verlengen')
                ? termijnResterend()
                : _maxTermijnenInJaren * 12);

        valueFromMap('periode_$optie',
            to: (value) => hypotheek.periodeInMaanden = value,
            dv: () =>
                optie.startsWith('verlengen') ? termijnResterend() : 10 * 12);

        if (!(optie.startsWith('verlengen'))) {
          valueFromMap('startDatum_$optie',
              to: (value) => hypotheek.startDatum = value,
              dv: () => hypotheekDatumSuggestie);
        }

        valueFromMap('nhg_$optie',
            to: (value) => hypotheek.maxLeningNHG.toepassen = value,
            dv: () => false);

        valueFromMap('verduurzamen_$optie',
            to: (value) => hypotheek.verbouwVerduurzaamKosten.toepassen = value,
            dv: () => false);

        valueFromMap('hypotheekvorm_$optie',
            to: (value) => hypotheek.hypotheekvorm = value,
            dv: () => HypotheekVorm.Annuity);
      }

      switch (value) {
        case OptiesHypotheekToevoegen.nieuw:
          {
            verwijderLinkVorige();
            herstel('nieuw');
            controleerStartDatum();
            controleerAfgesloten();
            controleerDatumDeelsAfgelosteLening();
            controleMaximaleJaren();
            break;
          }

        case OptiesHypotheekToevoegen.verlengen:
          {
            assert(verlengen.isNotEmpty,
                'Veranderen aanmaak hypotheek in verlengen: Geen te verlengen hypotheken gevonden!');

            linkAanVorige(verlengen[0].id);
            herstel('verlengen_${hypotheek.vorige}');
            controleerAfgesloten();
            controleMaximaleJaren();
            break;
          }
      }
    });
  }

  veranderingStartDatum(DateTime value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.startDatum = value;
      controleerDatumDeelsAfgelosteLening();
    });
  }

  veranderingHypotheekvorm(HypotheekVorm value) {
    calculatedAndNotify((Hypotheek old) {
      valueToMap('laatst_gekozen_hypotheek_vorm', value);
      hypotheek.hypotheekvorm = value;
    });
  }

  veranderingVorigeHypotheek(String value) {
    calculatedAndNotify((Hypotheek old) {
      linkAanVorige(value);
      controleMaximaleJaren();
    });
  }

  veranderingDeelsAfgelost(bool value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.deelsAfgelosteLening = value;
    });
  }

  veranderingDatumDeelsAfgelosteLening(DateTime value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.datumDeelsAfgelosteLening = value;
    });
  }

  void veranderingWoningwaardeWoning(double value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.woningLeningKosten.woningWaarde = value;
    });
  }

  void veranderingKostenToevoegen(List<Waarde> value) {
    calculatedAndNotify((Hypotheek old) {
      List<Waarde> lijst = hypotheek.woningLeningKosten.kosten;

      int indexEigenKosten = lijst.isEmpty || lijst.last.index < 1000
          ? 1000
          : lijst.last.index + 1;

      final List<Waarde> kopie = value
          .map((v) => v.id == leegKosten.id
              ? v.copyWith(index: indexEigenKosten++)
              : v.copyWith())
          .toList();

      _toevoegenKostenWoningPanel(
          sliverBoxList: hypotheekKostenPanelState?.sliverBoxList,
          lijst: kopie);

      kostenToevoegen(
          lijst: hypotheek.woningLeningKosten.kosten, toevoegen: kopie);
    });
  }

  _toevoegenKostenWoningPanel(
      {List<SliverBoxItemState<Waarde>>? sliverBoxList,
      required List<Waarde> lijst}) {
    sliverBoxList
      ?..addAll(lijst.map((Waarde v) => SliverBoxItemState<Waarde>(
          key: v.key, insertRemoveAnimation: 0.0, value: v, enabled: true)))
      ..sort((SliverBoxItemState<Waarde> a, SliverBoxItemState<Waarde> b) =>
          a.value.index - b.value.index);
  }

  void veranderingKostenVerwijderen(List<Waarde> value) {
    calculatedAndNotify((Hypotheek old) {
      kostenVerwijderen(
          lijst: hypotheek.woningLeningKosten.kosten, verwijderen: value);
    });
  }

  veranderingKosten(
      {required Waarde waarde,
      String? name,
      double? value,
      Eenheid? eenheid,
      bool? aftrekbaar}) {
    calculatedAndNotify((Hypotheek old) {
      waarde.setWaardes(
          name: name, value: value, eenheid: eenheid, aftrekbaar: aftrekbaar);
    });
  }

  void veranderingVerduurzamenToevoegen(List<Waarde> value) {
    calculatedAndNotify((Hypotheek old) {
      List<Waarde> lijst = hypotheek.verbouwVerduurzaamKosten.kosten;

      int indexEigenKosten = lijst.isEmpty || lijst.last.index < 1000
          ? 1000
          : lijst.last.index + 1;

      final List<Waarde> kopie = value
          .map((v) => v.id == leegKosten.id
              ? v.copyWith(index: indexEigenKosten++)
              : v.copyWith())
          .toList();

      _toevoegenKostenWoningPanel(
          sliverBoxList: verduurzamenPanelState?.sliverBoxList, lijst: kopie);

      kostenToevoegen(
          lijst: hypotheek.verbouwVerduurzaamKosten.kosten, toevoegen: kopie);
    });
  }

  void veranderingVerduurzamenVerwijderen(List<Waarde> value) {
    calculatedAndNotify((Hypotheek old) {
      kostenVerwijderen(
          lijst: hypotheek.verbouwVerduurzaamKosten.kosten, verwijderen: value);
    });
  }

  veranderingVerduurzamen(
      {required Waarde waarde,
      String? name,
      double? value,
      Eenheid? eenheid,
      bool? aftrekbaar,
      bool? verduurzamen}) {
    calculatedAndNotify((Hypotheek old) {
      waarde.setWaardes(
          name: name,
          value: value,
          eenheid: eenheid,
          aftrekbaar: aftrekbaar,
          verduurzamen: verduurzamen);
    });
  }

  veranderingTaxatie(double value) {
    calculatedAndNotify((Hypotheek old) {
      hypotheek.verbouwVerduurzaamKosten.taxatie = value;
    });
  }

  /* Calculate and Notify
   *
   *
   * 
   */

  calculatedAndNotify(ValueChanged<Hypotheek> berekening,
      {bool bereken: true}) {
    Hypotheek old = hypotheek.copyWith(termijnen: const []);
    final oldMaximumTermijnInJaren = bepaaldeMaximaleTermijnInJaren;

    berekening(old);

    bool updateHypotheekBewerkOmschrijvingKeuze = false;
    bool updateHypotheekBewerkDatumVerlengen = false;
    bool updateTermijnPeriodeNhgPanel = false;
    bool updateLeningPanel = false;
    bool updateHypotheekKosten = false;
    bool updateVerduurzaamKosten = false;

    ///
    ///
    ///
    ///
    ///

    if (old.optiesHypotheekToevoegen != hypotheek.optiesHypotheekToevoegen) {
      updateTermijnPeriodeNhgPanel = true;
      updateHypotheekBewerkOmschrijvingKeuze = true;
      updateHypotheekBewerkDatumVerlengen = true;
      updateLeningPanel = true;
    }

    if (old.vorige != hypotheek.vorige) {
      updateTermijnPeriodeNhgPanel = true;
      updateHypotheekBewerkDatumVerlengen = true;
    }

    if (old.startDatum != hypotheek.startDatum) {
      updateLeningPanel = true;
      updateHypotheekBewerkDatumVerlengen = true;
    }

    if (old.hypotheekvorm != hypotheek.hypotheekvorm) {
      updateLeningPanel = true;
    }

    if (old.rente != hypotheek.rente) {
      updateLeningPanel = true;
    }

    if (old.gewensteLening != hypotheek.gewensteLening) {
      updateLeningPanel = true;
    }

    if (oldMaximumTermijnInJaren != bepaaldeMaximaleTermijnInJaren) {
      updateTermijnPeriodeNhgPanel = true;
      updateLeningPanel = true;
    }

    if (old.aflosTermijnInMaanden != hypotheek.aflosTermijnInMaanden) {
      updateTermijnPeriodeNhgPanel = true;
      updateLeningPanel = true;

      termijnPeriodeNhgState?.setTermijnInJaren(hypotheek.aflosTermijnInJaren);
    }

    if (old.periodeInMaanden != hypotheek.periodeInMaanden) {
      updateTermijnPeriodeNhgPanel = true;
      updateLeningPanel = true;

      termijnPeriodeNhgState?.setPeriodeInJaren(hypotheek.periodeInJaren);
    }

    if (old.maxLeningNHG.toepassen != hypotheek.maxLeningNHG.toepassen) {
      updateTermijnPeriodeNhgPanel = true;
      updateLeningPanel = true;
      updateHypotheekKosten = true;
    }

    if (old.verbouwVerduurzaamKosten.toepassen !=
        hypotheek.verbouwVerduurzaamKosten.toepassen) {
      updateTermijnPeriodeNhgPanel = true;
      updateVerduurzaamKosten = true;
    }

    if (old.verbouwVerduurzaamKosten != hypotheek.verbouwVerduurzaamKosten) {
      updateVerduurzaamKosten = true;
    }

    if (old.woningLeningKosten != hypotheek.woningLeningKosten) {
      updateHypotheekKosten = true;
    }

    if (old.verbouwVerduurzaamKosten != hypotheek.verbouwVerduurzaamKosten) {
      updateVerduurzaamKosten = true;
    }

    if (old.deelsAfgelosteLening != hypotheek.deelsAfgelosteLening) {
      updateLeningPanel = true;
    }

    if (old.maxLeningNHG.toepassen != hypotheek.maxLeningNHG.toepassen) {}

    /*  Berekenen
     *
     *
     */

    DoorBerekenen(
            profiel: profiel,
            inkomenLijst: inkomenLijst,
            inkomenPartnerLijst: inkomenLijstPartner,
            schuldenLijst: schuldenLijst)
        .doorbereken(tm: hypotheek);

    hypotheek.normaliseerLening();

    if (old.lening != hypotheek.lening) {
      updateHypotheekKosten = true;
    }

    if (hypotheek.startDatum != old.startDatum ||
        hypotheek.aflosTermijnInMaanden != old.aflosTermijnInMaanden ||
        hypotheek.periodeInMaanden != old.periodeInMaanden ||
        hypotheek.hypotheekvorm != old.hypotheekvorm ||
        hypotheek.rente != old.rente ||
        hypotheek.lening != old.lening) {
      hypotheek.termijnen = [];

      if (hypotheek.lening > 0.0) {
        hypotheek
          ..opschonen()
          ..termijnenAanmaken()
          ..voegRenteToe()
          ..voegExtraAflossenToe()
          ..berekenPeriode();
      }
    }

    /* Aanpassen
     *
     *
     */

    if (hypotheek.lening != old.lening) {
      updateLeningPanel = true;
      updateHypotheekKosten = true;
    }

    if (updateHypotheekBewerkOmschrijvingKeuze) {
      hypotheekBewerkOmschrijvingKeuzeState?.updateState();
    }

    if (updateTermijnPeriodeNhgPanel) {
      termijnPeriodeNhgState?.updateState();
    }

    if (veranderTextLening) {
      leningPanelState?.setLening(hypotheek.gewensteLening);
      veranderTextLening = false;
    }

    if (updateLeningPanel) {
      leningPanelState?.updateState();
    }

    if (updateHypotheekBewerkDatumVerlengen) {
      hypotheekBewerkDatumVerlengenState?.updateState();
    }

    if (updateHypotheekKosten) {
      hypotheekKostenPanelState?.updateState();
    }

    if (updateVerduurzaamKosten) {
      verduurzamenPanelState?.updateState();
    }

    notifyListeners();
  }

  accept() {
    DoorBerekenen(
            profiel: profiel,
            inkomenLijst: inkomenLijst,
            inkomenPartnerLijst: inkomenLijstPartner,
            schuldenLijst: schuldenLijst)
        .doorbereken(vanaf: hypotheek);
  }

  cancel() {}

  void kostenAanpassen(
      {required Waarde waarde,
      required List<Waarde> kostenlijst,
      required List<SliverBoxItemState<Waarde>>? itemlijst,
      required bool toevoegen}) {
    if (toevoegen) {
      if (kostenlijst.indexWhere((element) => element.id == waarde.id) == -1) {
        Waarde w = map[waarde.id] ?? waarde;
        if (w.index != -1) {
          kostenlijst.add(w);
          itemlijst?.add(SliverBoxItemState<Waarde>(
            key: w.key,
            enabled: true,
            insertRemoveAnimation: 0.0,
            value: w,
          ));

          kostenlijst.sort(
            (a, b) => a.index - b.index,
          );

          itemlijst?.sort(
            (a, b) => a.value.index - b.value.index,
          );
        }
      }
    } else {
      // int index = kostenlijst.indexWhere((element) => element.id == waarde.id);

      // if (index != -1) {
      //   Waarde w = kostenlijst[index];
      //   map[waarde.id] = w;
      //   kostenlijst.removeAt(index);

      //   itemlijst
      //       ?.where(
      //           (SliverBoxItemState<Waarde> state) => state.value.id == w.id)
      //       .forEach((SliverBoxItemState<Waarde> state) {
      //     state.enabled = false;
      //   });
      // }

      kostenlijst.removeWhere((Waarde w) {
        if (w.id == waarde.id) {
          itemlijst
              ?.where(
                  (SliverBoxItemState<Waarde> state) => state.value.id == w.id)
              .forEach((SliverBoxItemState<Waarde> state) {
            state.enabled = false;
          });
          return true;
        } else {
          return false;
        }
      });
    }
  }

  void kostenToevoegen(
      {required List<Waarde> toevoegen, required List<Waarde> lijst}) {
    lijst
      ..addAll(toevoegen)
      ..sort((a, b) => a.index - b.index);
  }

  void kostenVerwijderen(
      {required List<Waarde> verwijderen, required List<Waarde> lijst}) {
    for (Waarde v in verwijderen) {
      lijst.remove(v);
    }
  }

  bool get isBestaandeHypotheek =>
      hypotheek.startDatum.compareTo(huidigeDatum) < 0;

  bool get heeftTeverlengenHypotheken {
    return verlengen.isNotEmpty;
  }

  DateTime eindDatumDeelsAfgelosteLening() {
    final dateNow = DateUtils.dateOnly(DateTime.now());

    final endDate = Kalender.voegPeriodeToe(hypotheek.startDatum,
        maanden: hypotheek.periodeInMaanden - 2);

    if (dateNow.compareTo(endDate) < 0) {
      return dateNow;
    }
    return endDate;
  }

  void controleerDatumDeelsAfgelosteLening() {
    if (hypotheek.optiesHypotheekToevoegen == OptiesHypotheekToevoegen.nieuw &&
        hypotheek.startDatum.compareTo(huidigeDatum) < 0 &&
        hypotheek.deelsAfgelosteLening) {
      if (hypotheek.datumDeelsAfgelosteLening.compareTo(hypotheek.startDatum) <
          0) {
        hypotheek.deelsAfgelosteLening = false;
        hypotheek.datumDeelsAfgelosteLening = hypotheek.startDatum;
      } else if (hypotheek.datumDeelsAfgelosteLening
              .compareTo(eindDatumDeelsAfgelosteLening()) >
          0) {
        hypotheek.datumDeelsAfgelosteLening = eindDatumDeelsAfgelosteLening();
      }
    } else {
      hypotheek.datumDeelsAfgelosteLening = hypotheek.startDatum;
    }
  }

  valueToMap(String text, value) {
    map[text] = value;
  }

  valueFromMap(String text, {to, dv}) {
    final value = map[text];
    if (value != null || dv != null) {
      to(value ?? dv());
    }
  }

  controleerStartDatum() {
    final eerst = eersteKalenderDatum;

    if (hypotheek.startDatum.compareTo(eerst) < 0) {
      hypotheek.startDatum = eerst;
      return;
    }

    final laatste = laatsteKalenderDatum;

    if (hypotheek.startDatum.compareTo(laatste) > 0) {
      hypotheek.startDatum = laatste;
      return;
    }
  }

  DateTime get eersteKalenderDatum {
    return Kalender.voegPeriodeToe(DateTime.now(),
        jaren: -_maxTermijnenInJaren);
  }

  DateTime get laatsteKalenderDatum {
    return DateTime(
        huidigeDatum.year + _maxTermijnenInJaren,
        huidigeDatum.month,
        Kalender.dagenPerMaand(
            jaar: huidigeDatum.year + _maxTermijnenInJaren,
            maand: huidigeDatum.month));
  }

  controleerAfgesloten() {
    hypotheek.controleerAfgesloten();
  }

  int get _maxTermijnenInJaren =>
      _maxTermijnenInJarenStartDatum(hypotheek.startDatum);

  int _maxTermijnenInJarenStartDatum(DateTime startDatum) =>
      profiel.doelOverzicht == DoelProfielOverzicht.nieuw &&
              profiel.datumWoningKopen == startDatum &&
              profiel.situatie == Situatie.starter
          ? 40
          : 30;

  bool get suggestieOverdrachtBelasting {
    if (profiel.doelOverzicht == DoelProfielOverzicht.nieuw) {
      if (hypotheek.startDatum == profiel.datumWoningKopen &&
          profiel.situatie != Situatie.starter) {
        for (Hypotheek h in profiel.eersteHypotheken) {
          if (h != hypotheek &&
              h.startDatum == profiel.datumWoningKopen &&
              h.woningLeningKosten.kosten.indexWhere((Waarde element) =>
                      element.id == 'overdrachtBelasting') !=
                  -1) {
            return false;
          }
        }
        return true;
      }
    }
    return false;
  }
}

class RestSchuld {
  DateTime datum;
  double restSchuld;

  RestSchuld({
    required this.datum,
    required this.restSchuld,
  });

  toevoegen(double value) {
    restSchuld += value;
  }

  verwijderen(double value) {
    restSchuld -= value;
  }
}
