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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import '../../../utilities/my_number_format.dart';
import '../../../utilities/value_to_width.dart';

class OverzichtVerzendHuisKrediet extends ConsumerStatefulWidget {
  const OverzichtVerzendHuisKrediet({Key? key}) : super(key: key);

  @override
  ConsumerState<OverzichtVerzendHuisKrediet> createState() =>
      OverzichtVerzendHuisKredietState();
}

class OverzichtVerzendHuisKredietState
    extends ConsumerState<OverzichtVerzendHuisKrediet> {
  late MyNumberFormat nf = MyNumberFormat(context);
  final widthLegend = ValueToWidth<String>(value: '');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant OverzichtVerzendHuisKrediet oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(schuldProvider).schuld?.mapOrNull(
            verzendKrediet: (VerzendKrediet vk) => _build(context, vk)) ??
        const OhNo(text: 'Verzendkrediet not found!');
  }

  Widget _build(BuildContext context, VerzendKrediet vk) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: vk.statusBerekening != StatusBerekening.berekend
            ? const SizedBox.shrink()
            : buildSummary(context, vk));
  }

  Widget buildSummary(BuildContext context, VerzendKrediet vk) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? displaySmall = theme.textTheme.displaySmall;

    Widget textPadding(String text, {textAlign = TextAlign.left}) {
      return Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Text(text, textAlign: textAlign));
    }

    List<TableRow> tableRows = [
      TableRow(children: [
        textPadding('Totaalbedrag'),
        textPadding(' : '),
        textPadding(
            nf.parseDblToText(vk.totaalBedrag, format: '#0.00', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      TableRow(children: [
        textPadding('Termijn'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(vk.mndBedrag, format: '#0.00', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
    ];

    tableRows.add(TableRow(children: [
      textPadding('Slottermijn'),
      textPadding(' :'),
      textPadding(
          vk.heeftSlotTermijn
              ? nf.parseDblToText(vk.slotTermijn, format: '#0.00', ifnull: '-')
              : '-',
          textAlign: TextAlign.right)
    ]));

    // final somAnn =
    //     nf.parseDblToText(vk.somAnn, format: '#,##0.00', ifnull: '-');

    // tableRows.addAll([
    //   TableRow(children: [
    //     Text('Interest'),
    //     Text(' :'),
    //     Text(nf.parseDblToText(ak.somInterest, format: '#,##0.00', ifnull: '-'),
    //         textAlign: TextAlign.right)
    //   ]),
    //   TableRow(children: [
    //     Text('Int. (%)'),
    //     Text(' :'),
    //     Text(
    //         nf.parseDblToText(
    //             ak.berekend == Calculated.yes ? ak.interestPercentage() : null,
    //             format: '#0.0',
    //             ifnull: '-'),
    //         textAlign: TextAlign.right)
    //   ]),
    //   TableRow(children: [
    //     Text('Totaal'),
    //     Text(' :'),
    //     Text(somAnn, textAlign: TextAlign.right)
    //   ])
    // ]);

    TextStyle textStyleTable =
        theme.textTheme.bodyMedium!.copyWith(fontSize: 16.0);

    final Widget tableOverzicht = DefaultTextStyle(
      style: textStyleTable,
      child: Table(columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
      }, children: tableRows),
    );

    // final valueToText = (double v) => '${(v * 10).roundToDouble() / 10}%';

    // final pieces = <PiePiece>[
    //   PiePiece(
    //       value: ak.lening / ak.somAnn * 100.0,
    //       name: 'lening',
    //       color: Color(0xFFaad400)),
    //   PiePiece(
    //       value: ak.somInterest / ak.somAnn * 100.0,
    //       name: 'rente',
    //       color: Color.fromARGB(255, 8, 10, 0))
    // ];

    // calculateWidthFromText(
    //     textToWidth: widthLegend,
    //     text: '99.9%',
    //     textStyle: textStyleTable,
    //     textScaleFactor: textScaleFactor);

    // bool hasRente = false;
    Widget center;
    // if (hasRente) {
    // center = SummaryPieLayout(
    //   children: [
    //     SummaryPieDataWidget(child: tableOverzicht, id: SummaryPieID.summary),
    //     SummaryPieDataWidget(
    //         child: Container(
    //             width: 250,
    //             height: 250,
    //             child: PieChart(
    //               pieces: pieces,
    //             )),
    //         id: SummaryPieID.pie),
    //     ...pieces
    //         .map((PiePiece e) => SummaryPieDataWidget(
    //             id: SummaryPieID.legendItem,
    //             child: LegendItem(
    //               minValue: widthLegend.width,
    //               valueToText: valueToText,
    //               item: e,
    //             )))
    //         .toList()
    //   ],
    // );
    // } else {
    center = tableOverzicht;
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Divider(height: 24.0),
        Text(
          'Overzicht',
          style: displaySmall,
        ),
        const SizedBox(height: 16.0),
        center,
        const SizedBox(height: 8.0),
      ]),
    );
  }
}
