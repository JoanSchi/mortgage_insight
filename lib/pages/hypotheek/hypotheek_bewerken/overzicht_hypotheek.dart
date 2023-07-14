import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/termijn/termijn.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/abstract_hypotheek_consumer.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/hypotheek_view_state.dart';
import '../../../layout/transition/scale_size_transition.dart';
import '../../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../../my_widgets/summary_pie_chart/summary_pie_layout.dart';
import '../../../utilities/value_to_width.dart';

class OverzichtHypotheek extends ConsumerStatefulWidget {
  const OverzichtHypotheek({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      OverzichtHypotheekState();
}

class OverzichtHypotheekState
    extends AbstractHypotheekConsumerState<OverzichtHypotheek> {
  final columnWidthSummaryValues = ValueToWidth<double>(value: 0.0);
  final widthLegend = ValueToWidth<String>(value: '');

  @override
  Widget buildHypotheek(
      BuildContext context,
      HypotheekViewState hypotheekViewState,
      HypotheekDossier hypotheekDossier,
      Hypotheek hypotheek) {
    Widget widget;

    if (hypotheek.termijnen.isNotEmpty) {
      widget = buildSummary(context, hypotheek, hypotheek.termijnen.last);
    } else {
      widget = const SizedBox.shrink();
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

  Widget buildSummary(
      BuildContext context, Hypotheek hypotheek, Termijn laatsteTermijn) {
    final theme = Theme.of(context);
    final displaySmall = theme.textTheme.displaySmall;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final rente = laatsteTermijn.renteTotaal;
    final restSchuld = laatsteTermijn.leningNaAflossen;
    final lening = hypotheek.lening;
    final afgelost = lening - restSchuld;
    final totaal = lening + rente;

    Widget textPadding(String text, {textAlign = TextAlign.left}) {
      return Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
          child: Text(text, textAlign: textAlign));
    }

    List<TableRow> tableRows = [
      TableRow(children: [
        textPadding('Lening'),
        textPadding(' : '),
        textPadding(nf.parseDblToText(lening, format: '#,##0', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      if (hypotheek.hypotheekvorm != HypotheekVorm.aflosvrij)
        TableRow(children: [
          textPadding(' - afgelost'),
          textPadding(' : '),
          textPadding(nf.parseDblToText(afgelost, format: '#,##0', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
      if (hypotheek.hypotheekvorm != HypotheekVorm.aflosvrij)
        TableRow(children: [
          textPadding(' - resterend'),
          textPadding(' :'),
          textPadding(
              nf.parseDblToText(hypotheek.restSchuld,
                  format: '#,##0', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
      TableRow(children: [
        textPadding('Rente'),
        textPadding(' :'),
        textPadding(
            nf.parseDblToText(hypotheek.rente, format: '#0.0#', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
      TableRow(children: [
        textPadding('Totaal'),
        textPadding(' :'),
        textPadding(nf.parseDblToText(totaal, format: '#,##0', ifnull: '-'),
            textAlign: TextAlign.right)
      ]),
    ];

    TextStyle textStyleTable =
        theme.textTheme.bodyMedium!.copyWith(fontSize: 16.0);

    final Widget tableOverzicht = DefaultTextStyle(
      style: textStyleTable,
      child: Table(columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        // 2: FixedColumnWidth(nf
        //     .calculateWidthFromNumber(
        //         valueToWidth: columnWidthSummaryValues,
        //         value: gegevens.totaal,
        //         textStyle: textStyleTable,
        //         textScaleFactor: textScaleFactor,
        //         format: '#,##0')
        //     .width)
      }, children: tableRows),
    );

    final valueToText = (double v) => '${(v * 10).roundToDouble() / 10}%';

    final pieces = (afgelost > 0.0)
        ? <PiePiece>[
            PiePiece(
                value: afgelost / totaal * 100.0,
                name: 'Afgelost',
                color: const Color(0xFFF6E7D8)),
            PiePiece(
                value: restSchuld / totaal * 100.0,
                name: 'Resterend',
                color: const Color(0xFFF68989)),
            PiePiece(
                value: rente / totaal * 100.0,
                name: 'Rente',
                color: const Color(0xFFC65D7B)),
          ]
        : [
            PiePiece(
                value: restSchuld / totaal * 100.0,
                name: 'Lening',
                color: const Color.fromARGB(255, 248, 176, 176)),
            PiePiece(
                value: rente / totaal * 100.0,
                name: 'Rente',
                color: const Color(0xFFC65D7B)),
          ];

    final piecesInnerLening = (afgelost > 0.0)
        ? [
            PiePiece(
                value: lening / totaal * 100.0,
                name: 'Lening',
                color: const Color(0xFF874356)),
          ]
        : const <PiePiece>[];

    calculateWidthFromText(
        textToWidth: widthLegend,
        text: '99.9%',
        textStyle: textStyleTable,
        textScaleFactor: textScaleFactor);

    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 16.0),
      Text(
        'Overzicht',
        style: displaySmall,
      ),
      const SizedBox(height: 16.0),
      SummaryPieLayout(
        children: [
          SummaryPieDataWidget(id: SummaryPieID.summary, child: tableOverzicht),
          SummaryPieDataWidget(
              id: SummaryPieID.pie,
              child: SizedBox(
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
                  ))),
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
      const SizedBox(height: 16.0),
    ]);
  }
}

// class _LeningOverzichtGegevens {
//   double lening = 0.0;
//   double rente = 0.0;
//   double restSchuld = 0.0;
//   HypotheekVorm hypotheekVorm;
//   bool show = false;

//   _LeningOverzichtGegevens.from(HypotheekViewModel v)
//       : hypotheekVorm = v.hypotheek.hypotheekvorm {
//     lening = v.hypotheek.lening;

//     if (v.isBerekend && v.hypotheek.termijnen.isNotEmpty) {
//       show = true;
//       final laatsteTermijn = v.hypotheek.termijnen.last;
//       rente = laatsteTermijn.renteTotaal;
//       restSchuld = laatsteTermijn.leningNaAflossen;
//     }
//   }

//   double get leningAfgelost => lening - restSchuld;

//   double get interest => rente / lening * 100.0;

//   double get totaal => rente + lening;
// }
