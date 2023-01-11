import 'package:flutter/material.dart';
import 'package:mortgage_insight/pages/debts/verzend_krediet/verzend_krediet_model.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_verzend_krediet.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../../../utilities/value_to_width.dart';

class OverzichtVerzendHuisKrediet extends StatefulWidget {
  final VerzendhuisKredietModel? verzendhuisKredietModel;

  OverzichtVerzendHuisKrediet({Key? key, required this.verzendhuisKredietModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverzichtVerzendHuisKredietState();
}

class OverzichtVerzendHuisKredietState
    extends State<OverzichtVerzendHuisKrediet> {
  late MyNumberFormat nf = MyNumberFormat(context);
  final columnWidthSummaryValues = ValueToWidth<int>(value: 0);
  final widthLegend = ValueToWidth<String>(value: '');
  VerzendhuisKredietModel? verzendHuisKredietModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (verzendHuisKredietModel != widget.verzendhuisKredietModel) {
      verzendHuisKredietModel?.removeListener(notify);
      verzendHuisKredietModel = widget.verzendhuisKredietModel
        ?..addListener(notify);
    }
  }

  @override
  void didUpdateWidget(covariant OverzichtVerzendHuisKrediet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (verzendHuisKredietModel != widget.verzendhuisKredietModel) {
      verzendHuisKredietModel?.removeListener(notify);
      verzendHuisKredietModel = widget.verzendhuisKredietModel
        ?..addListener(notify);
    }
  }

  @override
  void dispose() {
    verzendHuisKredietModel?.removeListener(notify);
    super.dispose();
  }

  notify() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (verzendHuisKredietModel == null ||
        verzendHuisKredietModel!.vk.berekend != Calculated.yes) {
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
    VerzendhuisKrediet vk = verzendHuisKredietModel!.vk;

    final ThemeData theme = Theme.of(context);
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    Widget textPadding(String text, {textAlign: TextAlign.left}) {
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
        theme.textTheme.bodyText2!.copyWith(fontSize: 16.0);

    final Widget tableOverzicht = DefaultTextStyle(
      style: textStyleTable,
      child: Table(columnWidths: {
        0: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FixedColumnWidth(calculateWidthFromNumber(
                valueToWidth: columnWidthSummaryValues,
                value: vk.totaalBedrag,
                textStyle: textStyleTable,
                textScaleFactor: textScaleFactor)
            .width)
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

    bool hasRente = false;
    Widget center;
    if (hasRente) {
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
    } else {
      center = tableOverzicht;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Divider(height: 24.0),
        Text(
          'Overzicht',
        ),
        SizedBox(height: 16.0),
        center,
        SizedBox(height: 8.0),
      ]),
    );
  }
}
