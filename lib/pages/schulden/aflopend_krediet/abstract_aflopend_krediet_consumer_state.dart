import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';

import '../../../model/nl/schulden/schulden.dart';
import '../schuld_provider.dart';

abstract class AbstractAflopendKredietState<T extends ConsumerStatefulWidget>
    extends ConsumerState<T> {
  late final nf = MyNumberFormat(context);

  AflopendKrediet? get ak => ref
      .read(schuldProvider)
      .schuld
      ?.mapOrNull(aflopendKrediet: (AflopendKrediet ak) => ak);

  SchuldBewerkNotifier get notify => ref.read(schuldProvider.notifier);

  AflopendKrediet? akFrom(SchuldBewerken? schuldBewerken) => schuldBewerken
      ?.schuld
      ?.mapOrNull<AflopendKrediet>(aflopendKrediet: (AflopendKrediet ak) => ak);

  String toText(Function(AflopendKrediet ak) toText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            aflopendKrediet: (AflopendKrediet ak) => toText(ak)) ??
        '';
  }

  String doubleToText(double Function(AflopendKrediet ak) doubleToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            aflopendKrediet: (AflopendKrediet ak) {
          final value = doubleToText(ak);
          return value == 0.0 ? '' : nf.parseDblToText(doubleToText(ak));
        }) ??
        '';
  }

  String intToText(int Function(AflopendKrediet ak) intToText) {
    return ref.read(schuldProvider).schuld?.mapOrNull<String>(
            aflopendKrediet: (AflopendKrediet ak) {
          final value = intToText(ak);
          return value == 0.0 ? '' : '$value';
        }) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(schuldProvider).schuld?.mapOrNull(
            aflopendKrediet: (AflopendKrediet ak) =>
                buildAflopendKrediet(context, ak)) ??
        OhNo(text: 'AflopendKrediet not found');
  }

  Widget buildAflopendKrediet(BuildContext context, AflopendKrediet ak);
}
