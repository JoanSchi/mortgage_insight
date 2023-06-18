import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import 'model/hypotheek_dossier_view_model.dart';
import 'model/hypotheek_dossier_view_state.dart';

abstract class AbstractHypotheekDossierConsumerState<
    T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  late final nf = MyNumberFormat(context);

  HypotheekDossierBewerkenNotifier get notifier =>
      ref.read(hypotheekDossierProvider.notifier);

  HypotheekDossier get hd =>
      ref.read(hypotheekDossierProvider).hypotheekDossier;

  String toText(String Function(HypotheekDossier hd) toText) {
    final hd = ref.read(hypotheekDossierProvider).hypotheekDossier;

    return toText(hd);
  }

  String doubleToText(double Function(HypotheekDossier hd) doubleToText) {
    final hd = ref.read(hypotheekDossierProvider).hypotheekDossier;

    return nf.parseDblToText(doubleToText(hd));
  }

  String intToText(int Function(HypotheekDossier hd) intToText) {
    final hd = ref.read(hypotheekDossierProvider).hypotheekDossier;

    final value = intToText(hd);
    return value == 0.0 ? '' : '$value';
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(hypotheekDossierProvider);
    final hd = viewState.hypotheekDossier;

    return buildHypotheekDossier(
      context,
      viewState,
      hd,
    );
  }

  Widget buildHypotheekDossier(BuildContext context,
      HypotheekDossierViewState bewerken, HypotheekDossier hd);
}
