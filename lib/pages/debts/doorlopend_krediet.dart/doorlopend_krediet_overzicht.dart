import 'package:flutter/material.dart';
import 'package:mortgage_insight/pages/debts/doorlopend_krediet.dart/doorlopend_krediet_model.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_doorlopend_krediet.dart';
import 'package:intl/intl.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../../../utilities/date.dart';

class OverzichtDoorlopendKrediet extends StatefulWidget {
  final DoorlopendKredietModel? doorlopendKredietModel;

  OverzichtDoorlopendKrediet({Key? key, required this.doorlopendKredietModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverzichtDoorlopendKredietState();
}

class OverzichtDoorlopendKredietState
    extends State<OverzichtDoorlopendKrediet> {
  late MyNumberFormat nf = MyNumberFormat(context);
  DoorlopendKredietModel? doorlopendKredietModel;
  late DateFormat df = DateFormat.yMd(localeToString(context));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (doorlopendKredietModel != widget.doorlopendKredietModel) {
      doorlopendKredietModel?.removeListener(notify);
      doorlopendKredietModel = widget.doorlopendKredietModel
        ?..addListener(notify);
    }
  }

  @override
  void didUpdateWidget(covariant OverzichtDoorlopendKrediet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (doorlopendKredietModel != widget.doorlopendKredietModel) {
      doorlopendKredietModel?.removeListener(notify);
      doorlopendKredietModel = widget.doorlopendKredietModel
        ?..addListener(notify);
    }
  }

  @override
  void dispose() {
    doorlopendKredietModel?.removeListener(notify);
    super.dispose();
  }

  notify() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (doorlopendKredietModel == null ||
        doorlopendKredietModel!.dk.berekend != Calculated.yes) {
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
    DoorlopendKrediet dk = doorlopendKredietModel!.dk;

    final ThemeData theme = Theme.of(context);
    // final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final map = dk.overzicht(DateTime.now());
    final layout = map['layout'];

    if (layout == 0) {
      String error;
      switch (map['error']) {
        default:
          {
            error = 'Fout onbekend';
          }
      }

      return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final maxIconSize = constraints.maxWidth - 2.0 * 16.0;

        double size = maxIconSize < 300.0 ? maxIconSize : 300.0;
        return Column(children: [
          Icon(
            Icons.warning_amber,
            color: Colors.amberAccent,
            size: size,
          ),
          Text(
            error,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: Colors.red),
          )
        ]);
      });
    } else {
      /*
     layout
      begin
      eind
      bedrag
      maandlastPercentage
      maandlast
      */

      Widget textPadding(String text, {textAlign: TextAlign.left}) {
        return Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(text, textAlign: textAlign));
      }

      List<TableRow> tableRows = [
        TableRow(children: [
          textPadding('begindatum'),
          textPadding(' : '),
          textPadding(df.format(map['begin']), textAlign: TextAlign.right)
        ]),
        TableRow(children: [
          textPadding('einddatum'),
          textPadding(' : '),
          textPadding(df.format(map['eind']), textAlign: TextAlign.right)
        ]),
        TableRow(children: [
          textPadding('Bedrag'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(map['bedrag'], format: '#0.00', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
        TableRow(children: [
          textPadding('MaandLast (%)'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(map['maandlastPercentage'],
                  format: '#0.0', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
        TableRow(children: [
          textPadding('Maandlast'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(map['maandlast'], format: '#0.00', ifnull: '-'),
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
          2: IntrinsicColumnWidth(),
          // FixedColumnWidth(calculateWidthFromNumber(
          //         valueToWidth: columnWidthSummaryValues,
          //         value: map['registratieBedrag'],
          //         textStyle: textStyleTable,
          //         textScaleFactor: textScaleFactor)
          //     .width
          // )
        }, children: tableRows),
      );

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Divider(height: 24.0),
          Text(
            'Overzicht',
          ),
          SizedBox(height: 16.0),
          tableOverzicht,
          SizedBox(height: 8.0),
        ]),
      );
    }
  }
}
