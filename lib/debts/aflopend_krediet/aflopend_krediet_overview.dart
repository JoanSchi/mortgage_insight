import 'package:flutter/material.dart';
import '../../model/nl/schulden/schulden.dart';
import '../../model/nl/schulden/schulden_aflopend_krediet.dart';
import '../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../my_widgets/summary_pie_chart/summary_pie_layout.dart';
import '../../utilities/MyNumberFormat.dart';
import '../../utilities/value_to_width.dart';
import 'aflopend_krediet_model.dart';

class OverzichtLening extends StatefulWidget {
  final AflopendKredietModel? aflopendKredietModel;

  OverzichtLening({Key? key, required this.aflopendKredietModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverzichtLeningState();
}

class OverzichtLeningState extends State<OverzichtLening> {
  late MyNumberFormat nf = MyNumberFormat(context);
  final columnWidthSummaryValues = ValueToWidth<int>(value: 0);
  final widthLegend = ValueToWidth<String>(value: '');
  AflopendKredietModel? aflopendKredietModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (aflopendKredietModel != widget.aflopendKredietModel) {
      aflopendKredietModel?.removeListener(notify);
      aflopendKredietModel = widget.aflopendKredietModel?..addListener(notify);
    }
  }

  @override
  void didUpdateWidget(covariant OverzichtLening oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (aflopendKredietModel != widget.aflopendKredietModel) {
      aflopendKredietModel?.removeListener(notify);
      aflopendKredietModel = widget.aflopendKredietModel?..addListener(notify);
    }
  }

  @override
  void dispose() {
    aflopendKredietModel?.removeListener(notify);
    super.dispose();
  }

  notify() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (aflopendKredietModel == null ||
        aflopendKredietModel!.ak.berekend != Calculated.yes) {
      widget = SizedBox(
        height: 1.0,
      );
    } else {
      widget = buildSummary(context);
    }

    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200), child: widget),
    );
  }

  Widget buildSummary(BuildContext context) {
    AflopendKrediet ak = aflopendKredietModel!.ak;

    final ThemeData theme = Theme.of(context);
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    Widget textPadding(String text, {textAlign: TextAlign.left}) {
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
                ak.berekend == Calculated.yes ? ak.interestPercentage() : null,
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
        theme.textTheme.bodyText2!.copyWith(fontSize: 16.0);

    final Widget tableOverzicht = DefaultTextStyle(
      style: textStyleTable,
      child: Table(columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FixedColumnWidth(calculateWidthFromNumber(
                valueToWidth: columnWidthSummaryValues,
                value: ak.somAnn,
                textStyle: textStyleTable,
                textScaleFactor: textScaleFactor)
            .width)
      }, children: tableRows),
    );

    final valueToText = (double v) => '${(v * 10).roundToDouble() / 10}%';

    final pieces = <PiePiece>[
      PiePiece(
          value: ak.lening / ak.somAnn * 100.0,
          name: 'lening',
          color: Color(0xFFaad400)),
      PiePiece(
          value: ak.somInterest / ak.somAnn * 100.0,
          name: 'rente',
          color: Color.fromARGB(255, 8, 10, 0))
    ];

    calculateWidthFromText(
        textToWidth: widthLegend,
        text: '99.9%',
        textStyle: textStyleTable,
        textScaleFactor: textScaleFactor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Divider(height: 24.0),
        Text(
          'Overzicht',
        ),
        SizedBox(height: 16.0),
        SummaryPieLayout(
          children: [
            SummaryPieDataWidget(
                child: tableOverzicht, id: SummaryPieID.summary),
            SummaryPieDataWidget(
                child: Container(
                    width: 250,
                    height: 250,
                    child: PieChart(
                      pieces: pieces,
                    )),
                id: SummaryPieID.pie),
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
        SizedBox(height: 8.0),
      ]),
    );
  }
}



// class PercentagePieChart extends StatelessWidget {
//   final List<charts.Series<PieItem, String>> seriesList;
//   final bool animate;

//   PercentagePieChart(this.seriesList, {this.animate = true});

//   factory PercentagePieChart.data({List<PieItem> data = const <PieItem>[]}) {
//     return new PercentagePieChart(
//       _createSampleData(data: data),
//       animate: true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new charts.PieChart<String>(
//       seriesList,
//       animate: animate,
//       rtlSpec: charts.RTLSpec(axisDirection: charts.AxisDirection.reversed),
//       // Add the legend behavior to the chart to turn on legends.
//       // This example shows how to optionally show measure and provide a custom
//       // formatter.

//       behaviors: [
//         charts.DatumLegend(
//           // Positions for "start" and "end" will be left and right respectively
//           // for widgets with a build context that has directionality ltr.
//           // For rtl, "start" and "end" will be right and left respectively.
//           // Since this example has directionality of ltr, the legend is
//           // positioned on the right side of the chart.
//           position: charts.BehaviorPosition.end,
//           // By default, if the position of the chart is on the left or right of
//           // the chart, [horizontalFirst] is set to false. This means that the
//           // legend entries will grow as new rows first instead of a new column.
//           horizontalFirst: false,
//           insideJustification: charts.InsideJustification.topStart,
//           outsideJustification: charts.OutsideJustification.middleDrawArea,
//           // This defines the padding around each legend entry.
//           cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
//           // Set [showMeasures] to true to display measures in series legend.
//           showMeasures: true,
//           // Configure the measure value to be shown by default in the legend.
//           legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
//           // Optionally provide a measure formatter to format the measure value.
//           // If none is specified the value is formatted as a decimal.
//           measureFormatter: (num? value) {
//             return value == null ? '-' : '${value.round()}%';
//           },
//         ),
//       ],
//       // defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
//       //   charts.ArcLabelDecorator(
//       //       labelPosition: charts.ArcLabelPosition.outside)
//       // ])
//     );
//   }

//   static List<charts.Series<PieItem, String>> _createSampleData(
//       {List<PieItem> data: const <PieItem>[]}) {
//     return [
//       new charts.Series<PieItem, String>(
//         id: 'Totaal',
//         domainFn: (PieItem item, _) => item.label,
//         measureFn: (PieItem item, _) => item.percentage,
//         data: data,
//         // colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
//         // seriesColor: charts.ColorUtil.fromDartColor(Colors.amber.shade700),
//         // labelAccessorFn: (PieItem r, _) => r.label
//       )
//     ];
//   }
// }

// class PieItem {
//   final String label;
//   final double percentage;

//   PieItem(this.label, this.percentage);
// }
