import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
import '../../../model/nl/hypotheek/gegevens/hypotheek_profiel/hypotheek_profiel.dart';
import 'hypotheek_model.dart';

abstract class AbstractHypotheekConsumerState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  late final nf = MyNumberFormat(context);

  HypotheekBewerkNotifier get notifier =>
      ref.read(hypotheekBewerkenProvider.notifier);

  Hypotheek? get hypotheek => ref.read(hypotheekBewerkenProvider).hypotheek;

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
    final bewerken = ref.watch(hypotheekBewerkenProvider);
    final hp = bewerken.profiel;
    final hypotheek = bewerken.hypotheek;

    return (hp != null && hypotheek != null)
        ? buildHypotheek(context, bewerken, hp, hypotheek)
        : const SliverToBoxAdapter(child: OhNo(text: 'Hypotheek not found.'));
  }

  Widget buildHypotheek(BuildContext context, HypotheekBewerken hb,
      HypotheekProfiel hp, Hypotheek hypotheek);
}
