// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../schuld_provider.dart';

class LeaseAutoNotifier {
  final SchuldNotifier notifier;
  LeaseAuto _state;

  LeaseAutoNotifier(
    this.notifier,
    this._state,
  );

  set state(LeaseAuto value) {
    if (_state != value) {
      _state = value;
      notifier.updateSchuld(value);
    }
  }

  static LeaseAutoNotifier? bewerken(WidgetRef ref) {
    SchuldNotifier notifier = ref.read(schuldProvider.notifier);
    LeaseAuto? leaseAuto;

    notifier.schuld?.mapOrNull(leaseAuto: (LeaseAuto value) {
      leaseAuto = value;
    });
    final a = leaseAuto;
    return (a != null) ? LeaseAutoNotifier(notifier, a) : null;
  }

  void veranderingOmschrijving(String value) {
    state = _state.copyWith(omschrijving: value);
  }

  void veranderingDatum(DateTime value) {
    state = _state.copyWith(beginDatum: DateUtils.dateOnly(value));
  }

  void veranderingBedrag(double value) {
    state = _state.copyWith(
        mndBedrag: value, statusBerekening: isBerekend(mndBedrag: value));
  }

  void veranderingJaren(int value) {
    state = _state.copyWith(
        jaren: value, statusBerekening: isBerekend(jaren: value));
  }

  void veranderingMaanden(int value) {
    state = _state.copyWith(
        maanden: value, statusBerekening: isBerekend(maanden: value));
  }

  StatusBerekening isBerekend({double? mndBedrag, int? jaren, int? maanden}) {
    if ((mndBedrag ?? _state.mndBedrag) > 0.0 && (jaren ?? _state.jaren) > 0 ||
        (maanden ?? _state.maanden) > 0) {
      return StatusBerekening.berekend;
    } else {
      return StatusBerekening.nietBerekend;
    }
  }
}
