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
import 'package:hypotheek_berekeningen/schulden/uitwerken/aflopend_krediet_verwerken.dart';
import 'package:mortgage_insight/pages/schulden/aflopend_krediet/abstract_aflopend_krediet_consumer_state.dart';
import '../../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../../my_widgets/summary_pie_chart/summary_pie_layout.dart';
import '../../../utilities/value_to_width.dart';

class OverzichtLening extends ConsumerStatefulWidget {
  const OverzichtLening({
    super.key,
  });

  @override
  ConsumerState<OverzichtLening> createState() => OverzichtLeningState();
}

class OverzichtLeningState
    extends AbstractAflopendKredietState<OverzichtLening> {
  final widthLegend = ValueToWidth<String>(value: '');

  @override
  Widget buildAflopendKrediet(BuildContext context, AflopendKrediet ak) {
    Widget widget;

    if (ak.statusBerekening != StatusBerekening.berekend) {
      widget = const SizedBox(
        height: 1.0,
      );
    } else {
      widget = buildSummary(context, ak);
    }

    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200), child: widget);
  }

  Widget buildSummary(BuildContext context, AflopendKrediet ak) {
    final ThemeData theme = Theme.of(context);
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    Widget textPadding(String text, {textAlign = TextAlign.left}) {
      return Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
          child: Text(text, textAlign: textAlign));
    }

    List<TableRow> tableRows = [
      TableRow(children: [
        textPadding('Lening'),
        textPadding(' : '),
        textPadding(
            nf.parseDblToText(ak.lening, format: '#,##0.00', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      TableRow(children: [
        textPadding('Termijn'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(ak.termijnBedragMnd,
                format: '#0.00', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
    ];

    if (ak.slotTermijn != 0.0) {
      tableRows.add(TableRow(children: [
        textPadding('Slottermijn'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(ak.slotTermijn, format: '#0.00', ifnull: '-'),
            textAlign: TextAlign.right)
      ]));
    }

    final somAnn =
        nf.parseDblToText(ak.somAnn, format: '#,##0.00', ifnull: '-');

    tableRows.addAll([
      TableRow(children: [
        textPadding('Interest'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(ak.somInterest, format: '#,##0.00', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      TableRow(children: [
        textPadding('Int. (%)'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(
                ak.statusBerekening == StatusBerekening.berekend
                    ? AflopendKredietVerwerken.interestPercentage(ak)
                    : null,
                format: '#0.0',
                ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      TableRow(children: [
        textPadding('Totaal'),
        textPadding(' :'),
        textPadding(somAnn, textAlign: TextAlign.right)
      ])
    ]);
    TextStyle textStyleTable =
        theme.textTheme.bodyMedium!.copyWith(fontSize: 16.0);

    final Widget tableOverzicht = DefaultTextStyle(
      style: textStyleTable,
      child: Table(columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth()
      }, children: tableRows),
    );

    valueToText(double v) => '${(v * 10).roundToDouble() / 10}%';

    final pieces = <PiePiece>[
      PiePiece(
          value: ak.lening / ak.somAnn * 100.0,
          name: 'lening',
          color: const Color(0xFFaad400)),
      PiePiece(
          value: ak.somInterest / ak.somAnn * 100.0,
          name: 'rente',
          color: const Color.fromARGB(255, 8, 10, 0))
    ];

    calculateWidthFromText(
        textToWidth: widthLegend,
        text: '99.9%',
        textStyle: textStyleTable,
        textScaleFactor: textScaleFactor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Divider(height: 24.0),
        const Text(
          'Overzicht',
        ),
        const SizedBox(height: 16.0),
        SummaryPieLayout(
          children: [
            SummaryPieDataWidget(
                id: SummaryPieID.summary, child: tableOverzicht),
            SummaryPieDataWidget(
                id: SummaryPieID.pie,
                child: SizedBox(
                    width: 250,
                    height: 250,
                    child: PieChart(
                      pieces: pieces,
                    ))),
            ...pieces
                .map((PiePiece e) => SummaryPieDataWidget(
                    id: SummaryPieID.legendItem,
                    child: LegendItem(
                      minValue: widthLegend.width,
                      valueToText: valueToText,
                      item: e,
                    )))
                .toList()
          ],
        ),
        const SizedBox(height: 8.0),
      ]),
    );
  }
}
