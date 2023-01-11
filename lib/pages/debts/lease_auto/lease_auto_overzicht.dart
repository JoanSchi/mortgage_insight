import 'package:flutter/material.dart';
import 'package:mortgage_insight/pages/debts/lease_auto/lease_auto_model.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_lease_auto.dart';
import 'package:intl/intl.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../../../utilities/date.dart';
import '../../../utilities/value_to_width.dart';

class OverzichtLeaseAuto extends StatefulWidget {
  final LeaseAutoModel? leaseAutoModel;

  OverzichtLeaseAuto({Key? key, required this.leaseAutoModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OverzichtLeaseAutoState();
}

class OverzichtLeaseAutoState extends State<OverzichtLeaseAuto> {
  late MyNumberFormat nf = MyNumberFormat(context);
  final columnWidthSummaryValues = ValueToWidth<int>(value: 0);
  final widthLegend = ValueToWidth<String>(value: '');
  LeaseAutoModel? leaseAutoModel;
  late DateFormat df = DateFormat.yMd(localeToString(context));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (leaseAutoModel != widget.leaseAutoModel) {
      leaseAutoModel?.removeListener(notify);
      leaseAutoModel = widget.leaseAutoModel?..addListener(notify);
    }
  }

  @override
  void didUpdateWidget(covariant OverzichtLeaseAuto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (leaseAutoModel != widget.leaseAutoModel) {
      leaseAutoModel?.removeListener(notify);
      leaseAutoModel = widget.leaseAutoModel?..addListener(notify);
    }
  }

  @override
  void dispose() {
    leaseAutoModel?.removeListener(notify);
    super.dispose();
  }

  notify() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    if (leaseAutoModel == null ||
        leaseAutoModel!.ola.berekend != Calculated.yes) {
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
    OperationalLeaseAuto ola = leaseAutoModel!.ola;

    final ThemeData theme = Theme.of(context);
    // final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final map = ola.overzicht(DateTime.now());
    final layout = map['layout'];

    if (layout == 0) {
      String error;
      switch (map['error']) {
        case 'date':
          error = 'Maandlast kan pas vanaf 2016 berekend worden';
          break;
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
      datum 
      vanaf 
      mndBedrag
      maandlast
      registratiePercentage
      registratieBedrag
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
          textPadding('MaandBedrag'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(map['mndBedrag'], format: '#0.00', ifnull: '-'),
              textAlign: TextAlign.right)
        ]),
        TableRow(children: [
          textPadding('Registratie (%)'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(map['registratiePercentage'],
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
        TableRow(children: [
          textPadding('Registratiebedrag'),
          textPadding(' : '),
          textPadding(
              nf.parseDblToText(map['registratieBedrag'],
                  format: '#0.00', ifnull: '-'),
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
