import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/model/nl/schulden/autolease_verwerken.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../utilities/my_number_format.dart';
import '../../../utilities/date.dart';
import '../../../utilities/value_to_width.dart';

class OverzichtLeaseAuto extends ConsumerStatefulWidget {
  const OverzichtLeaseAuto({Key? key}) : super(key: key);

  @override
  ConsumerState<OverzichtLeaseAuto> createState() => OverzichtLeaseAutoState();
}

class OverzichtLeaseAutoState extends ConsumerState<OverzichtLeaseAuto> {
  late MyNumberFormat nf = MyNumberFormat(context);
  final columnWidthSummaryValues = ValueToWidth<int>(value: 0);
  final widthLegend = ValueToWidth<String>(value: '');
  late DateFormat df = DateFormat.yMd(localeToString(context));

  @override
  Widget build(BuildContext context) {
    return ref
            .watch(schuldProvider.select((value) => value.schuld))
            ?.maybeMap<Widget>(
                leaseAuto: (LeaseAuto leaseAuto) =>
                    buildAutoLease(context, leaseAuto),
                orElse: ohNo) ??
        ohNo();
  }

  Widget buildAutoLease(BuildContext context, LeaseAuto leaseAuto) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: (leaseAuto.statusBerekening != StatusBerekening.berekend)
          ? const SizedBox.shrink()
          : buildSummary(context, leaseAuto),
    );
  }

  Widget buildSummary(BuildContext context, LeaseAuto leaseAuto) {
    final ThemeData theme = Theme.of(context);
    // final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final huidigeDatum = DateUtils.dateOnly(DateTime.now());
    final map = LeaseAutoVerwerken.overzicht(leaseAuto, huidigeDatum);

    if (map.containsKey('fout')) {
      String fout = map['fout'];

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
            fout,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
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
          theme.textTheme.bodyMedium!.copyWith(fontSize: 16.0);

      final Widget tableOverzicht = DefaultTextStyle(
        style: textStyleTable,
        child: Table(columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: IntrinsicColumnWidth(),
          2: IntrinsicColumnWidth(),
        }, children: tableRows),
      );

      return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 24.0),
        const Text(
          'Overzicht',
        ),
        const SizedBox(height: 16.0),
        tableOverzicht,
        const SizedBox(height: 8.0),
      ]);
    }
  }

  Widget ohNo() => OhNo(text: 'LeaseAuto not found!');
}
