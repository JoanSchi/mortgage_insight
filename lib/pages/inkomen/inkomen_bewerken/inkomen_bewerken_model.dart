// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/gereedschap/kalender.dart';
import 'package:hypotheek_berekeningen/inkomen/gegevens/inkomen.dart';
import '../../../utilities/date.dart';
import 'inkomen_bewerken_view_state.dart';

final inkomenBewerkenViewProvider = StateNotifierProvider<
    InkomenBewerkenViewModelNotifier, InkomenBewerkenViewState>((ref) {
  return InkomenBewerkenViewModelNotifier(InkomenBewerkenViewState(
      inkomen: Inkomen(
        datum: monthYear(DateTime.now()),
        partner: false,
        indexatie: 0.01,
        pensioen: false,
        periodeInkomen: PeriodeInkomen.jaar,
        brutoInkomen: 0.0,
        dertiendeMaand: false,
        vakantiegeld: true,
      ),
      lijst: IList(),
      origineleDatum: DateTime(0),
      pensioenKeuze: true,
      blokDatum: DateTime(0)));
});

class InkomenBewerkenViewModelNotifier
    extends StateNotifier<InkomenBewerkenViewState> {
  InkomenBewerkenViewModelNotifier(super.state);

  void bestaand({required IList<Inkomen> lijst, required Inkomen inkomen}) {
    _evaluatie(inkomen: inkomen, lijst: lijst);
  }

  void nieuw({required IList<Inkomen> lijst, required bool partner}) {
    DateTime datum = monthYear(DateTime.now());

    if (lijst.isNotEmpty) {
      final last = lijst.last;

      datum = datum.compareTo(last.datum) <= 0
          ? Kalender.voegPeriodeToe(last.datum,
              maanden: 1, periodeOpties: PeriodeOpties.volgende)
          : datum;

      bool pensioenKeuze;
      DateTime blokDatum;

      if (last.pensioen) {
        pensioenKeuze = false;
        blokDatum = last.datum;
      } else {
        pensioenKeuze = true;
        blokDatum = DateTime(0);
      }

      state = state.copyWith(
          origineleDatum: DateTime(0),
          pensioenKeuze: pensioenKeuze,
          blokDatum: blokDatum,
          lijst: lijst,
          inkomen: last.copyWith(datum: datum));
    } else {
      state = state.copyWith(
          origineleDatum: DateTime(0),
          pensioenKeuze: true,
          blokDatum: DateTime(0),
          lijst: lijst,
          inkomen: state.inkomen.copyWith(datum: datum, partner: partner));
    }
  }

  void _evaluatie({DateTime? datum, Inkomen? inkomen, IList<Inkomen>? lijst}) {
    inkomen ??= state.inkomen;
    datum ??= inkomen.datum;
    lijst ??= state.lijst;

    bool pensioenKeuze = true;
    bool pensioen = false;
    DateTime blokDatum = DateTime(0);
    DateTime origineleDatum = state.origineleDatum;

    for (Inkomen i in lijst) {
      if (DateUtils.monthDelta(datum, i.datum) == 0) {
        origineleDatum = datum;
        break;
      }
    }

    for (Inkomen i in lijst) {
      int delta = DateUtils.monthDelta(datum, i.datum);

      if (delta < 0 && i.pensioen) {
        //Negative delta: item date after i date.
        pensioenKeuze = false;
        pensioen = true;
        blokDatum = i.datum;
        break;
      } else if (delta > 0 && !i.pensioen) {
        //Positive delta: item date before i date.
        pensioenKeuze = false;
        pensioen = false;
        blokDatum = i.datum;
        break;
      }
    }

    if (pensioenKeuze) {
      state = state.copyWith(
          origineleDatum: origineleDatum,
          pensioenKeuze: pensioenKeuze,
          blokDatum: blokDatum,
          lijst: lijst,
          inkomen: inkomen.copyWith(datum: datum));
    } else {
      state = state.copyWith(
          origineleDatum: origineleDatum,
          pensioenKeuze: pensioenKeuze,
          blokDatum: blokDatum,
          lijst: lijst,
          inkomen: inkomen.copyWith(pensioen: pensioen, datum: datum));
    }
  }

  void veranderingPensioen(bool value) {
    state = state.copyWith.inkomen(pensioen: value);
  }

  void veranderingDatum(DateTime value) {
    _evaluatie(datum: value);
  }

  void veranderingJaarInkomenUit(PeriodeInkomen value) {
    state = state.copyWith.inkomen(periodeInkomen: value);
  }

  void veranderingBrutoInkomen(double value) {
    state = state.copyWith.inkomen(brutoInkomen: value);
  }

  void veranderingVakantiegeld(bool value) {
    state = state.copyWith.inkomen(vakantiegeld: value);
  }

  void veranderingDertiendeMaand(bool value) {
    state = state.copyWith.inkomen(dertiendeMaand: value);
  }
}
