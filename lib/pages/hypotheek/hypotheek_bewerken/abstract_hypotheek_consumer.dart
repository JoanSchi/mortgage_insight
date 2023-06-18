import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import 'model/hypotheek_view_model.dart';
import 'model/hypotheek_view_state.dart';

abstract class AbstractHypotheekConsumerState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  late final nf = MyNumberFormat(context);

  HypotheekViewStateNotifier get notifier =>
      ref.read(hypotheekBewerkenProvider.notifier);

  Hypotheek? get hypotheek => ref.read(hypotheekBewerkenProvider).hypotheek;

  HypotheekDossier? get hypotheekDossier =>
      ref.read(hypotheekBewerkenProvider).hypotheekDossier;

  String toText(String Function(Hypotheek hypotheek) toText) {
    final hypotheek = ref.read(hypotheekBewerkenProvider).hypotheek;

    return hypotheek != null ? toText(hypotheek) : '';
  }

  String doubleToText(double Function(Hypotheek hypotheek) doubleToText) {
    final hp = ref.read(hypotheekBewerkenProvider).hypotheek;

    return hp != null ? nf.parseDblToText(doubleToText(hp)) : '';
  }

  String intToText(int Function(Hypotheek hypotheek) intToText) {
    final hp = ref.read(hypotheekBewerkenProvider).hypotheek;

    if (hp == null) {
      return '';
    } else {
      final value = intToText(hp);
      return value == 0.0 ? '' : '$value';
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(hypotheekBewerkenProvider);
    final hp = viewState.hypotheekDossier;
    final hypotheek = viewState.hypotheek;

    return (hypotheek != null)
        ? buildHypotheek(context, viewState, hp, hypotheek)
        : ohno();
  }

  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek);

  Widget ohno() =>
      const SliverToBoxAdapter(child: OhNo(text: 'Hypotheek not found.'));
}
