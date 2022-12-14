// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mortgage_insight/hypotheek/bewerken/hypotheek_model.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import 'package:mortgage_insight/utilities/MyNumberFormat.dart';

import '../../layout/transition/scale_size_transition.dart';
import '../../model/nl/hypotheek/parallel_leningen.dart';
import '../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../my_widgets/summary_pie_chart/summary_pie_layout.dart';
import '../../utilities/value_to_width.dart';

class VerdelingLeningen extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;

  const VerdelingLeningen({
    Key? key,
    required this.hypotheekViewModel,
  }) : super(key: key);

  @override
  State<VerdelingLeningen> createState() => _VerdelingLeningenState();
}

class _VtoW {
  ValueToWidth<String> text = ValueToWidth<String>(value: '');
  ValueToWidth<double> value = ValueToWidth<double>(value: 0.0);
}

class _VerdelingLeningenState extends State<VerdelingLeningen> {
  late _L gegevens;
  late MyNumberFormat nf = MyNumberFormat(context);
  late List<_VtoW> vToW;
  final columnWidthSummaryValues = ValueToWidth<double>(value: 0.0);

  @override
  void initState() {
    gegevens = _L.from(
        widget.hypotheekViewModel.profiel, widget.hypotheekViewModel.hypotheek);
    widget.hypotheekViewModel.addListener(notify);

    super.initState();
  }

  @override
  void dispose() {
    widget.hypotheekViewModel.removeListener(notify);
    super.dispose();
  }

  notify() {
    final nieuw = _L.from(
        widget.hypotheekViewModel.profiel, widget.hypotheekViewModel.hypotheek);

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
      widget = _buildVerdeling(context);
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

  Widget _buildVerdeling(BuildContext context) {
    final theme = Theme.of(context);

    final TextStyle textStyle = theme.textTheme.bodyText2!;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    nf.calculateWidthFromNumber(
        valueToWidth: columnWidthSummaryValues,
        value: gegevens.total,
        textScaleFactor: textScaleFactor,
        textStyle: textStyle);

    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 8.0,
        ),
        Text(
          'Verdeling leningen',
        ),
        SizedBox(
          height: 16.0,
        ),
        SummaryPieLayout(
          children: [
            SummaryPieDataWidget(
                child: Container(
                    width: 250,
                    height: 250,
                    child: Stack(
                      children: [
                        PieChart(
                          total: gegevens.total,
                          pieces: gegevens.outerPieces,
                        ),
                        PieChart(
                          total: gegevens.total,
                          paddingRatio: 1.0 / 5.0,
                          pieces: gegevens.innerPieces,
                        )
                      ],
                    )),
                id: SummaryPieID.pie),
            ...(gegevens.innerPieces.isEmpty
                    ? gegevens.outerPieces
                    : [...gegevens.outerPieces, ...gegevens.innerPieces])
                .map((PiePiece e) => SummaryPieDataWidget(
                    id: SummaryPieID.legendItem,
                    child: LegendItem(
                      // minValue: columnWidthSummaryValues.width,
                      valueToText: (double v) => nf.parseDoubleToText(v, '#0'),
                      item: e,
                    )))
                .toList()
          ],
        ),
      ],
    );
  }
}

class _L {
  // static const leningColors = const [
  //   Color(0xFFF4EA8E),
  //   Color(0xFFF37121),
  //   Color(0xFFA03C78),
  //   Color(0xFFED8E7C),
  //   Color(0xFFFFB319),
  //   Color(0xFFD92027),
  // ];

  final restSchuldColor = Color.fromARGB(255, 198, 53, 68);
  final woningColor = Color(0xFF68353a);
  final financieringsRuimteColor = Color.fromARGB(255, 244, 193, 139);
  final eigenColor = Color.fromARGB(255, 244, 135, 19);

  final leningColors = [
    Color.fromARGB(255, 251, 212, 204),
    Color.fromARGB(255, 252, 165, 147),
    Color.fromARGB(255, 215, 130, 113),
    Color.fromARGB(255, 183, 95, 77),
    Color.fromARGB(255, 151, 65, 47),
  ];

  final kostenColors = [
    Color.fromARGB(255, 198, 216, 223),
    Color.fromARGB(255, 173, 199, 210),
    Color.fromARGB(255, 141, 168, 179),
    Color.fromARGB(255, 90, 134, 152),
    Color.fromARGB(255, 54, 108, 129),
  ];

  final verduurzaamColors = [
    Color(0xFFe0de61),
    Color(0xFFc7c94b),
    Color.fromARGB(255, 164, 165, 61),
    Color.fromARGB(255, 127, 129, 47),
    Color.fromARGB(255, 84, 85, 30),
  ];
  double total = 0.0;

  final outerPieces = <PiePiece>[];
  double totalOuter = 0.0;

  final innerPieces = <PiePiece>[];
  double totalInner = 0.0;
  bool show = false;

  _L.from(HypotheekProfiel profiel, Hypotheek hypotheek) {
    int count = 0;

    final woningWaarde = hypotheek.woningLeningKosten.woningWaarde;
    bool woningWaardeToepassen = false;

    if (woningWaarde == 0.0 && hypotheek.parallelLeningen.list.isEmpty) {
      return;
    }

    if (hypotheek.startDatum == profiel.datumWoningKopen) {
      if (woningWaarde > 0.0) {
        innerPieces.add(PiePiece(
            value: woningWaarde, name: 'WoningWaarde', color: woningColor));

        totalInner += woningWaarde;
        woningWaardeToepassen = true;
      }
    }

    void addKosten(Hypotheek h) {
      final kosten = h.woningLeningKosten.totaleKosten;

      if (kosten > 0.0) {
        innerPieces.add(PiePiece(
            value: kosten,
            name: 'Kosten L${h.leningNummer}',
            color: kostenColors[count % kostenColors.length]));

        totalInner += kosten;
      }
    }

    void addVerduurzamen(Hypotheek h) {
      final verduurzamen = h.verbouwVerduurzaamKosten.totaleKosten;

      if (verduurzamen > 0.0) {
        innerPieces.add(PiePiece(
            value: verduurzamen,
            name: 'Verduurzamen L${h.leningNummer}',
            color: verduurzaamColors[count % verduurzaamColors.length]));

        totalInner += verduurzamen;
      }
    }

    for (StatusLening s in hypotheek.parallelLeningen.list) {
      Hypotheek parallel = profiel.hypotheken[s.id]!;
      outerPieces.add(PiePiece(
          value: s.lening,
          name: 'Lening L${parallel.leningNummer}',
          color: leningColors[count % leningColors.length]));

      totalOuter += s.lening;

      if (profiel.datumWoningKopen == parallel.startDatum) {
        addKosten(parallel);
        addVerduurzamen(parallel);
      }

      count++;
    }

    outerPieces.add(PiePiece(
        value: hypotheek.lening,
        name: 'Lening L${hypotheek.leningNummer}',
        color: leningColors[count % leningColors.length]));

    totalOuter += hypotheek.lening;

    addKosten(hypotheek);
    addVerduurzamen(hypotheek);

    count++;

    if (!hypotheek.afgesloten) {
      final over = math.min(totalInner - totalOuter,
          hypotheek.maxLening.resterend - hypotheek.lening);

      if (over > 0.0) {
        totalOuter += over;

        outerPieces.add(PiePiece(
            value: over,
            name: 'Ruimte financiering',
            color: financieringsRuimteColor));
      }
    }

    if (totalInner > totalOuter) {
      outerPieces.add(PiePiece(
          value: totalInner - totalOuter, name: 'Eigen', color: eigenColor));

      total = totalInner;
    } else if (totalInner < totalOuter) {
      if (woningWaardeToepassen) {
        innerPieces.add(PiePiece(
            value: totalOuter - totalInner,
            name: woningWaardeToepassen ? 'Over?' : 'Extra',
            color: woningColor));
      } else if (hypotheek.startDatum == profiel.datumWoningKopen) {
        innerPieces.add(PiePiece(
            value: totalOuter - totalInner,
            name: 'WoningWaarde?',
            color: leningColors[count % leningColors.length]));
      }

      total = totalOuter;
    } else {
      total = totalOuter;
    }

    show = true;
  }

  @override
  bool operator ==(covariant _L other) {
    if (identical(this, other)) return true;

    return other.total == total &&
        other.totalOuter == totalOuter &&
        other.totalInner == totalInner &&
        listEquals(other.innerPieces, innerPieces) &&
        listEquals(other.outerPieces, outerPieces) &&
        other.show == show;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        totalOuter.hashCode ^
        totalInner.hashCode ^
        innerPieces.hashCode ^
        outerPieces.hashCode ^
        show.hashCode;
  }
}
