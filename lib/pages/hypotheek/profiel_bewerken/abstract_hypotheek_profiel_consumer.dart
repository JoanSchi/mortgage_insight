import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';

import '../../../model/nl/hypotheek/gegevens/hypotheek_profiel/hypotheek_profiel.dart';
import 'hypotheek_profiel_model.dart';

abstract class AbstractHypotheekProfielConsumerState<
    T extends ConsumerStatefulWidget> extends ConsumerState<T> {
  late final nf = MyNumberFormat(context);

  ProfielBewerkNotifier get notifier =>
      ref.read(profielBewerkenProvider.notifier);

  HypotheekProfiel? get hp =>
      ref.read(profielBewerkenProvider).hypotheekProfiel;

  String toText(String Function(HypotheekProfiel hp) toText) {
    final hp = ref.read(profielBewerkenProvider).hypotheekProfiel;

    return hp != null ? toText(hp) : '';
  }

  String doubleToText(double Function(HypotheekProfiel hp) doubleToText) {
    final hp = ref.read(profielBewerkenProvider).hypotheekProfiel;

    return hp != null ? nf.parseDblToText(doubleToText(hp)) : '';
  }

  String intToText(int Function(HypotheekProfiel hp) intToText) {
    final hp = ref.read(profielBewerkenProvider).hypotheekProfiel;

    if (hp == null) {
      return '';
    } else {
      final value = intToText(hp);
      return value == 0.0 ? '' : '$value';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bewerken = ref.watch(profielBewerkenProvider);
    final hp = bewerken.hypotheekProfiel;

    return (hp != null)
        ? buildHypotheekProfiel(
            context,
            bewerken,
            hp,
          )
        : const SliverToBoxAdapter(
            child: OhNo(text: 'Hypotheekprofiel not found.'));
  }

  Widget buildHypotheekProfiel(BuildContext context,
      HypotheekProfielBewerken bewerken, HypotheekProfiel hp);
}
