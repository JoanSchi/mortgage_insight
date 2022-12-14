import 'package:flutter/material.dart';
import 'package:mortgage_insight/hypotheek/bewerken/hypotheek_model.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';

import '../../layout/transition/scale_size_transition.dart';
import '../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../my_widgets/summary_pie_chart/summary_pie_layout.dart';
import '../../utilities/MyNumberFormat.dart';
import '../../utilities/value_to_width.dart';

class OverzichtHypotheek extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;

  OverzichtHypotheek({Key? key, required this.hypotheekViewModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverzichtHypotheekState();
}

class OverzichtHypotheekState extends State<OverzichtHypotheek> {
  late MyNumberFormat nf = MyNumberFormat(context);
  final columnWidthSummaryValues = ValueToWidth<double>(value: 0.0);
  final widthLegend = ValueToWidth<String>(value: '');
  late _LeningOverzichtGegevens gegevens;

  @override
  void initState() {
    widget.hypotheekViewModel.addListener(notify);
    gegevens = _LeningOverzichtGegevens.from(widget.hypotheekViewModel);
    super.initState();
  }

  @override
  void dispose() {
    widget.hypotheekViewModel.removeListener(notify);
    super.dispose();
  }

  notify() {
    final nieuw = _LeningOverzichtGegevens.from(widget.hypotheekViewModel);
    if (gegevens != nieuw) {
      setState(() {
        gegevens = nieuw;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (gegevens.show) {
      widget = buildSummary(context);
    } else {
      widget = SizedBox.shrink();
    }

    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleResizedTransition(scale: animation, child: child),
            );
          },
          duration: const Duration(milliseconds: 200),
          child: widget),
    );
  }

  Widget buildSummary(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

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
            nf.parseDblToText(gegevens.lening, format: '#,##0', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      if (gegevens.hypotheekVorm != HypotheekVorm.Aflosvrij)
        TableRow(children: [
          textPadding(' - afgelost'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(gegevens.leningAfgelost,
                  format: '#,##0', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
      if (gegevens.hypotheekVorm != HypotheekVorm.Aflosvrij)
        TableRow(children: [
          textPadding(' - resterend'),
          textPadding(' :'),
          textPadding(
              nf.parseDblToText(gegevens.restSchuld,
                  format: '#,##0', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
      TableRow(children: [
        textPadding('Rente'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(gegevens.rente, format: '#0', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      TableRow(children: [
        textPadding('Totaal'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(gegevens.totaal, format: '#,##0', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
    ];

    TextStyle textStyleTable =
        theme.textTheme.bodyText2!.copyWith(fontSize: 16.0);

    final Widget tableOverzicht = DefaultTextStyle(
      style: textStyleTable,
      child: Table(columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FixedColumnWidth(nf
            .calculateWidthFromNumber(
                valueToWidth: columnWidthSummaryValues,
                value: gegevens.totaal,
                textStyle: textStyleTable,
                textScaleFactor: textScaleFactor,
                format: '#,##0')
            .width)
      }, children: tableRows),
    );

    final valueToText = (double v) => '${(v * 10).roundToDouble() / 10}%';

    final pieces = (gegevens.hypotheekVorm != HypotheekVorm.Aflosvrij)
        ? <PiePiece>[
            PiePiece(
                value: gegevens.leningAfgelost / gegevens.totaal * 100.0,
                name: 'Afgelost',
                color: Color(0xFFF6E7D8)),
            PiePiece(
                value: gegevens.restSchuld / gegevens.totaal * 100.0,
                name: 'Resterend',
                color: Color(0xFFF68989)),
            PiePiece(
                value: gegevens.rente / gegevens.totaal * 100.0,
                name: 'Rente',
                color: Color(0xFFC65D7B)),
          ]
        : [
            PiePiece(
                value: gegevens.restSchuld / gegevens.totaal * 100.0,
                name: 'Lening',
                color: Color.fromARGB(255, 248, 176, 176)),
            PiePiece(
                value: gegevens.rente / gegevens.totaal * 100.0,
                name: 'Rente',
                color: Color(0xFFC65D7B)),
          ];

    final piecesInnerLening =
        (gegevens.hypotheekVorm != HypotheekVorm.Aflosvrij)
            ? [
                PiePiece(
                    value: gegevens.lening / gegevens.totaal * 100.0,
                    name: 'Lening',
                    color: Color(0xFF874356)),
              ]
            : const <PiePiece>[];

    calculateWidthFromText(
        textToWidth: widthLegend,
        text: '99.9%',
        textStyle: textStyleTable,
        textScaleFactor: textScaleFactor);

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Divider(),
      SizedBox(height: 16.0),
      Text(
        'Overzicht lening',
      ),
      SizedBox(height: 16.0),
      SummaryPieLayout(
        children: [
          SummaryPieDataWidget(child: tableOverzicht, id: SummaryPieID.summary),
          SummaryPieDataWidget(
              child: Container(
                  width: 250,
                  height: 250,
                  child: Stack(
                    children: [
                      PieChart(
                        pieces: pieces,
                      ),
                      if (piecesInnerLening.isNotEmpty)
                        PieChart(
                          paddingRatio: 1.0 / 5.0,
                          pieces: piecesInnerLening,
                        ),
                    ],
                  )),
              id: SummaryPieID.pie),
          ...(piecesInnerLening.isNotEmpty
                  ? [...piecesInnerLening, ...pieces]
                  : pieces)
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
      SizedBox(height: 16.0),
    ]);
  }
}

class _LeningOverzichtGegevens {
  double lening = 0.0;
  double rente = 0.0;
  double restSchuld = 0.0;
  HypotheekVorm hypotheekVorm;
  bool show = false;

  _LeningOverzichtGegevens.from(HypotheekViewModel v)
      : hypotheekVorm = v.hypotheek.hypotheekvorm {
    lening = v.hypotheek.lening;

    if (v.isBerekend && v.hypotheek.termijnen.isNotEmpty) {
      show = true;
      final laatsteTermijn = v.hypotheek.termijnen.last;
      rente = laatsteTermijn.renteTotaal;
      restSchuld = laatsteTermijn.leningNaAflossen;
    }
  }

  double get leningAfgelost => lening - restSchuld;

  double get interest => rente / lening * 100.0;

  double get totaal => rente + lening;
}
