import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import 'package:mortgage_insight/utilities/Kalender.dart';
import '../../../model/nl/hypotheek/kosten_hypotheek.dart';
import '../../../my_widgets/sliver_row_box.dart';
import 'hypotheek_profiel_bewerken.dart';

class HypotheekProfielViewModel with ChangeNotifier {
  Map<String, dynamic> map = {};

  HypotheekProfielen hypotheekProfielen;
  HypotheekProfiel? profielOrigineel;
  late HypotheekProfiel profiel;

  bool get isNieuw => profielOrigineel == null;

  VoidCallback? updateOptieState;
  HypotheekProfielVorigeWoningPanelState? vorigeWoningPanel;
  HypotheekProfielEigenWoningReservePanelState? eigenWoningReservePanel;

  HypotheekProfielViewModel(
      {required this.hypotheekProfielen, HypotheekProfiel? profiel})
      : profielOrigineel = profiel {
    this.profiel = profiel?.copyWith() ??
        HypotheekProfiel(omschrijving: suggestieOmschrijving);

    bewarenERW();
  }

  String get suggestieOmschrijving {
    //\s whitespace alleen op eind$
    RegExp exp = RegExp("[0-9]+\\s*\$");

    int number = 0;

    for (HypotheekProfielContainer c in hypotheekProfielen.profielen.values) {
      final match = exp.firstMatch(c.profiel.omschrijving);

      if (match != null) {
        final value = match.group(0);

        if (value != null) {
          int n = int.parse(value);
          if (n > number) {
            number = n;
          }
        }
      }
    }
    number++;

    return 'Profiel $number';
  }

  /* Profiel
   *
   */

  void eigenWoningReserveBerekenen(bool value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.eigenReserveWoning.erwBerekenen = value;
    });
  }

  void veranderingOmschrijving(String value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.omschrijving = value;
    });
  }

  void veranderingDoelProfiel(DoelProfielOverzicht value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.doelOverzicht = value;

      bewarenERW();

      // kostenAanpassen(
      //     toevoegen: value == DoelProfielOverzicht.nieuw,
      //     waarde: WoningGegevens.overdrachtBelasting,
      //     kostenlijst: profiel.woningGegevens.kosten);

      aanpassenERW();
    });
  }

  void veranderingDatumWoningKopen(DateTime value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.datumWoningKopen = value;
    });
  }

  void veranderingInkomensNorm(bool value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.inkomensNormToepassen = value;
    });
  }

  void veranderingWoningWaardeToepassen(bool value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.woningWaardeNormToepassen = value;
    });
  }

  // void veranderingNhgToepassen(bool value) {
  //   calculatedAndNotify(() {
  //     profiel.nhgToepassen = value;
  //   });
  // }

  void veranderingSituatie(Situatie value) {
    calculatedAndNotify((HypotheekProfiel old) {
      bewarenERW();
      profiel.situatie = value;

      // if (old.situatie == Situatie.starter || value == Situatie.starter) {
      //   kostenAanpassen(
      //       toevoegen: value != Situatie.starter,
      //       waarde: WoningGegevens.overdrachtBelasting,
      //       kostenlijst: profiel.woningGegevens.kosten);
      // }
      aanpassenERW();
    });
  }

  void veranderingERW(bool value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.eigenReserveWoning.erwToepassing = value;
    });
  }

  /// Vorige woning (te verkopen woning)
  ///
  ///
  ///
  ///
  void veranderingWoningWaarde(double value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.vorigeWoningGegevens.woningWaarde = value;
    });
  }

  void veranderingHypotheek(double value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.vorigeWoningGegevens.lening = value;
    });
  }

  void veranderingEigenWoningReserve(double value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.eigenReserveWoning.erw = value;
    });
  }

  void veranderingOorspronkelijkeLening(double value) {
    calculatedAndNotify((HypotheekProfiel old) {
      profiel.eigenReserveWoning.oorspronkelijkeHoofdsom = value;
    });
  }

  void veranderingToevoegenKostenVorigeWoning(List<Waarde> toevoegen) {
    calculatedAndNotify((HypotheekProfiel old) {
      List<Waarde> lijst = profiel.vorigeWoningGegevens.kosten;

      int indexEigenKosten = lijst.isEmpty || lijst.last.index < 1000
          ? 1000
          : lijst.last.index + 1;

      final List<Waarde> kopie = toevoegen
          .map((v) => v.id == leegKosten.id
              ? v.copyWith(index: indexEigenKosten++)
              : v.copyWith())
          .toList();

      _toevoegenKostenVorigeWoningPanel(kopie);

      kostenToevoegen(
          toevoegen: kopie, lijst: profiel.vorigeWoningGegevens.kosten);
    });
  }

  _toevoegenKostenVorigeWoningPanel(List<Waarde> lijst) {
    vorigeWoningPanel?.itemList
      ?..addAll(lijst.map((Waarde v) => SliverBoxItemState<Waarde>(
          key: v.key, insertRemoveAnimation: 0.0, value: v, enabled: true)))
      ..sort((SliverBoxItemState<Waarde> a, SliverBoxItemState<Waarde> b) =>
          a.value.index - b.value.index);
  }

  void veranderingVerwijderenKostenVorigeWoning(List<Waarde> verwijderen) {
    calculatedAndNotify((HypotheekProfiel old) {
      kostenVerwijderen(
          verwijderen: verwijderen, lijst: profiel.vorigeWoningGegevens.kosten);
    });
  }

  veranderingWaardepWoning(
      {required Waarde waarde,
      String? name,
      double? value,
      Eenheid? eenheid,
      bool? aftrekbaar}) {
    calculatedAndNotify((HypotheekProfiel old) {
      waarde.setWaardes(
          name: name, value: value, eenheid: eenheid, aftrekbaar: aftrekbaar);
    });
  }

  /* Calculate and Notify
   *
   */

  calculatedAndNotify(ValueChanged<HypotheekProfiel> berekening) {
    final old = profiel.copyWith();
    berekening(old);

    bool _updateOptieState = false;
    bool _updateEigenWoningReserve = false;
    bool _updateVorigeWoningState = false;
    bool berekenen = false;

    if (old.doelOverzicht != profiel.doelOverzicht) {
      _updateOptieState = true;
      _updateEigenWoningReserve = true;
      _updateVorigeWoningState = true;
    }

    if (old.situatie != profiel.situatie) {
      _updateOptieState = true;
      _updateEigenWoningReserve = true;
      _updateVorigeWoningState = true;
    }

    if (old.inkomensNormToepassen != profiel.inkomensNormToepassen) {
      _updateOptieState = true;
    }

    if (old.woningWaardeNormToepassen != profiel.woningWaardeNormToepassen) {
      _updateOptieState = true;
      berekenen = true;
    }

    /// Eigenwoningreserve
    ///
    ///

    if (profiel.eigenReserveWoning != old.eigenReserveWoning) {
      _updateOptieState = true;
      _updateEigenWoningReserve = true;
      _updateVorigeWoningState = true;
      berekenen = true;
    }

    /// Te verkopen / Vorige Woning
    ///
    ///

    if (profiel.vorigeWoningGegevens != old.vorigeWoningGegevens) {
      _updateVorigeWoningState = true;
      _updateEigenWoningReserve = true;
      berekenen = true;
    }

    if (profiel.vorigeWoningGegevens.woningWaarde !=
            old.vorigeWoningGegevens.woningWaarde ||
        profiel.vorigeWoningGegevens.totaleKosten !=
            old.vorigeWoningGegevens.totaleKosten) {}

    /// Bereken hypotheken door
    ///
    ///

    if (berekenen) {
      // profiel.controleerHypotheken();
    }

    /// Update
    ///
    ///

    if (_updateOptieState && updateOptieState != null) {
      updateOptieState?.call();
    }

    if (_updateEigenWoningReserve) {
      eigenWoningReservePanel?.updateState();
    }

    if (_updateVorigeWoningState) {
      vorigeWoningPanel?.updateState();
    }
  }

  // void kostenAanpassen(
  //     {required Waarde waarde,
  //     required List<Waarde> kostenlijst,
  //     required bool toevoegen}) {
  //   if (toevoegen) {
  //     if (kostenlijst.indexWhere((element) => element.id == waarde.id) == -1) {
  //       Waarde w = map[waarde.id] ?? waarde;
  //       if (w.index != -1) {
  //         kostenlijst.add(map[waarde.id] ?? waarde);

  //         kostenlijst.sort(
  //           (a, b) => a.index - b.index,
  //         );
  //       }
  //     }
  //   } else {
  //     int index = kostenlijst.indexWhere((element) => element.id == waarde.id);

  //     if (index != -1) {
  //       map[waarde.id] = kostenlijst[index];
  //       kostenlijst.removeAt(index);
  //     }
  //   }
  // }

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

  valueToMap(String text, value) {
    map[text] = value;
  }

  valueFromMap(String text, {to, dv}) {
    final value = map[text];
    if (value != null || dv != null) {
      to(value ?? dv);
    }
  }

  void bewarenERW() {
    switch (profiel.doelOverzicht) {
      case DoelProfielOverzicht.nieuw:
        if (profiel.situatie == Situatie.geenKoopwoning) {
          valueToMap(
              'erw_geenkoopwoning', profiel.eigenReserveWoning.erwToepassing);
        }

        break;
      case DoelProfielOverzicht.bestaand:
        valueToMap('erw_bestaand', profiel.eigenReserveWoning.erwToepassing);
        break;
    }
  }

  void aanpassenERW() {
    if (profiel.inkomensNormToepassen) {
      switch (profiel.doelOverzicht) {
        case DoelProfielOverzicht.nieuw:
          switch (profiel.situatie) {
            case Situatie.starter:
              profiel.eigenReserveWoning.erwToepassing = false;
              break;
            case Situatie.koopwoning:
              profiel.eigenReserveWoning.erwToepassing = true;
              break;
            case Situatie.geenKoopwoning:
              valueFromMap('erw_geenkoopwoning',
                  to: (v) => profiel.eigenReserveWoning.erwToepassing = v,
                  dv: false);
              break;
          }
          break;
        case DoelProfielOverzicht.bestaand:
          valueFromMap('erw_bestaand',
              to: (v) => profiel.eigenReserveWoning.erwToepassing = v,
              dv: false);

          break;
      }
    }
  }

  DateTime get datumWoningKopen {
    final huidigeDatum = DateUtils.dateOnly(DateTime.now());

    if (profiel.datumWoningKopen.compareTo(huidigeDatum) < 0) {
      profiel.datumWoningKopen = hypotheekDatumSuggestie;
    }

    return profiel.datumWoningKopen;
  }

  DateTime get beginDatumWoningKopen => DateUtils.dateOnly(DateTime.now());

  DateTime get eindDatumWoningKopen =>
      Kalender.voegPeriodeToe(DateTime.now(), jaren: 5);
}
