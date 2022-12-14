import 'package:flutter/material.dart';

import '../../model/nl/hypotheek/hypotheek.dart';
import '../../my_widgets/custom_fitted_box.dart';
import '../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../utilities/MyNumberFormat.dart';
import '../../utilities/date.dart';
import 'package:intl/intl.dart';

import 'hypotheek_model.dart';

// Color.fromARGB(255, 253, 251, 247)

class VerlengCard extends StatelessWidget {
  final Hypotheek hypotheek;
  final String? selected;
  final ValueChanged<String?> changed;

  const VerlengCard(
      {Key? key,
      required this.hypotheek,
      required this.selected,
      required this.changed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat df = DateFormat('dd MMM\nyyyy', localeToString(context));
    final MyNumberFormat nf = MyNumberFormat(context);
    final ThemeData theme = Theme.of(context);

    if (hypotheek.termijnen.isEmpty) {
      return Card(
          color: Colors.red, child: Text('Termijnen niet berekend! :('));
    }

    final laatsteTermijn = hypotheek.termijnen.last;

    final List<PiePiece> piePieces = [
      PiePiece(
          value: laatsteTermijn.leningNaAflossen,
          name: 'Schuld',
          color:
              selected == hypotheek.id ? Color(0xFFFAC213) : Color(0xFFDEB6AB)),
      PiePiece(
          value: laatsteTermijn.aflossenTotaal,
          name: 'Afl.',
          color:
              selected == hypotheek.id ? Color(0xFFF77E21) : Color(0xFFAC7D88)),
      PiePiece(
          value: laatsteTermijn.renteTotaal,
          name: 'R',
          color:
              selected == hypotheek.id ? Color(0xFFD61C4E) : Color(0xFF85586F)),
    ];

    double totaal = laatsteTermijn.leningNaAflossen +
        laatsteTermijn.aflossenTotaal +
        laatsteTermijn.renteTotaal;

    final pieChart = PieChart(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomFittedBox(
          customApplyBoxFit: defaultPieApplyBoxFit,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 40.0),
            child: Text(
              nf.parseDoubleToText(laatsteTermijn.leningNaAflossen, '#0'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyText2
                  ?.copyWith(color: Color.fromARGB(255, 6, 74, 129)),
            ),
          ),
        ),
      ),
      useLine: true,
      pieces: piePieces,
      total: totaal,
    );

    final legend = [
      LegendItem(
        item: piePieces[0],
        valueToText: (double v) => nf.parseDoubleToText(v, '#0'),
      ),
      LegendItem(
        item: piePieces[1],
        valueToText: (double v) => '${nf.parseDoubleToText(v, '#0')}',
      ),
      LegendItem(
        item: piePieces[2],
        valueToText: (double v) =>
            '${nf.parseDoubleToText(v, '#0')} (${nf.parseDoubleToText(hypotheek.rente, '#0.0')}%)',
      ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      color: Color.fromARGB(255, 246, 251, 253),
      child: InkWell(
        splashColor: const Color.fromARGB(137, 170, 212, 229),
        highlightColor: const Color.fromARGB(150, 255, 248, 225),
        onTap: () => changed(hypotheek.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 46.0,
              child: Stack(children: [
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: Radio(
                      value: hypotheek.id,
                      groupValue: selected,
                      onChanged: changed),
                ),
                Positioned(
                  left: 0.0,
                  top: 2.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Center(
                      child: Text(
                    '${hypotheek.omschrijving == '' ? hypotheek.id : hypotheek.omschrijving}',
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.2,
                  )),
                ),
              ]),
            ),
            Divider(indent: 8.0, endIndent: 8.0, height: 2.0),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(df.format(hypotheek.startDatum)),
                        Text(
                          df.format(hypotheek.eindDatum),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: pieChart),
                        SizedBox(
                          height: 4.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 2.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              ...legend,
                              Text(' ; '),
                              Text(
                                  'L: ${nf.parseDblToText(hypotheek.gewensteLening, format: '#0')}')
                            ],
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestSchuldCard extends StatelessWidget {
  final RestSchuld restSchuld;
  final DateTime? selected;
  final ValueChanged<DateTime?> changed;

  const RestSchuldCard(
      {Key? key,
      required this.restSchuld,
      required this.selected,
      required this.changed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat df = DateFormat('dd-MM-yyyy', localeToString(context));
    final nf = MyNumberFormat(context);
    final theme = Theme.of(context);

    final textStyleDatum = theme.textTheme.bodyText2
        ?.copyWith(color: Color.fromARGB(255, 4, 37, 87), fontSize: 16.0);

    final textStyleSchuld = theme.textTheme.bodyText2
        ?.copyWith(color: Color.fromARGB(255, 4, 37, 87), fontSize: 24.0);

    return Card(
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
        color: Color.fromARGB(255, 246, 251, 253),
        child: Stack(
          children: [
            Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: InkWell(
                  splashColor: const Color.fromARGB(137, 170, 212, 229),
                  highlightColor: const Color.fromARGB(150, 255, 248, 225),
                  onTap: () => changed(restSchuld.datum),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(df.format(restSchuld.datum), style: textStyleDatum),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(nf.parseDoubleToText(restSchuld.restSchuld, '#0'),
                          style: textStyleSchuld)
                    ],
                  ),
                )),
            Positioned(
                left: 0.0,
                top: 0.0,
                child: Radio(
                  value: restSchuld.datum,
                  groupValue: selected,
                  onChanged: changed,
                ))
          ],
        ));
  }
}
