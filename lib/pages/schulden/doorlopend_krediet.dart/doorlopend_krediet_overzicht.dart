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
import 'package:hypotheek_berekeningen/schulden/uitwerken/doorlopendkrediet_verwerken.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import '../../../utilities/my_number_format.dart';
import '../../../utilities/date.dart';

class OverzichtDoorlopendKrediet extends ConsumerStatefulWidget {
  const OverzichtDoorlopendKrediet({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<OverzichtDoorlopendKrediet> createState() =>
      OverzichtDoorlopendKredietState();
}

class OverzichtDoorlopendKredietState
    extends ConsumerState<OverzichtDoorlopendKrediet> {
  late MyNumberFormat nf = MyNumberFormat(context);
  late DateFormat df = DateFormat.yMd(localeToString(context));

  @override
  Widget build(BuildContext context) {
    final schuld = ref.watch(schuldProvider).schuld;

    return schuld?.mapOrNull<Widget?>(
            doorlopendKrediet: (DoorlopendKrediet doorlopendKrediet) =>
                _build(context, doorlopendKrediet)) ??
        const OhNo(
          text: 'Doorlopendkrediet niet gevonden',
        );
  }

  Widget _build(BuildContext context, DoorlopendKrediet dk) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: (dk.statusBerekening != StatusBerekening.berekend)
            ? const SizedBox.shrink()
            : buildSummary(context, dk));
  }

  Widget buildSummary(BuildContext context, DoorlopendKrediet dk) {
    final ThemeData theme = Theme.of(context);
    final map = _overzicht(dk, DateTime.now());

    if (map.containsKey('fout')) {
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
            map['fout'],
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
      bedrag
      maandlastPercentage
      maandlast
      */

      Widget textPadding(String text, {textAlign = TextAlign.left}) {
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
}

Map<String, dynamic> _overzicht(DoorlopendKrediet dk, DateTime huidigeDatum) {
  if (dk.statusBerekening != StatusBerekening.berekend) {
    return {'fout': 'Fout'};
  }

  final maandLastPercentage =
      DoorlopendKredietVerwerken.fictieveKredietlast(huidigeDatum);

  return {
    'begin': dk.beginDatum,
    'eind': dk.eindDatum,
    'bedrag': dk.bedrag,
    'maandlastPercentage': maandLastPercentage,
    'maandlast': dk.bedrag / 100.0 * maandLastPercentage,
  };
}
