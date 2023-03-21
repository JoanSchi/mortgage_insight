import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import '../../../model/nl/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'hypotheek_dossier_model.dart';

abstract class AbstractHypotheekProfielConsumerState<
    T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  late final nf = MyNumberFormat(context);

  HypotheekDossierBewerkenNotifier get notifier =>
      ref.read(hypotheekDossierBewerkenProvider.notifier);

  HypotheekDossier? get hd =>
      ref.read(hypotheekDossierBewerkenProvider).hypotheekDossier;

  String toText(String Function(HypotheekDossier hd) toText) {
    final hd = ref.read(hypotheekDossierBewerkenProvider).hypotheekDossier;

    return hd != null ? toText(hd) : '';
  }

  String doubleToText(double Function(HypotheekDossier hd) doubleToText) {
    final hd = ref.read(hypotheekDossierBewerkenProvider).hypotheekDossier;

    return hd != null ? nf.parseDblToText(doubleToText(hd)) : '';
  }

  String intToText(int Function(HypotheekDossier hd) intToText) {
    final hd = ref.read(hypotheekDossierBewerkenProvider).hypotheekDossier;

    if (hd == null) {
      return '';
    } else {
      final value = intToText(hd);
      return value == 0.0 ? '' : '$value';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bewerken = ref.watch(hypotheekDossierBewerkenProvider);
    final hd = bewerken.hypotheekDossier;

    return (hd != null)
        ? buildHypotheekDossier(
            context,
            bewerken,
            hd,
          )
        : const SliverToBoxAdapter(
            child: OhNo(text: 'Hypotheekprofiel not found.'));
  }

  Widget buildHypotheekDossier(BuildContext context,
      HypotheekDossierBewerken bewerken, HypotheekDossier hd);
}
