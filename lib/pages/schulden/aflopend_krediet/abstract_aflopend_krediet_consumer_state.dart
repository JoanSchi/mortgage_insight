// Copyright (C) 2023 Joan Schipper
// 
// This file is part of mortgage_insight.
// 
// mortgage_insight is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// mortgage_insight is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';
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
        const OhNo(text: 'AflopendKrediet not found');
  }

  Widget buildAflopendKrediet(BuildContext context, AflopendKrediet ak);
}
