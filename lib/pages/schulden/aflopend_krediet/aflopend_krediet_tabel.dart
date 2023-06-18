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

import 'package:flextable/flextable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/pages/schulden/aflopend_krediet/abstract_aflopend_krediet_consumer_state.dart';
import 'dart:math' as math;
import '../../../utilities/date.dart';
import '../../../utilities/value_to_width.dart';

class AflopendKredietTabel extends ConsumerStatefulWidget {
  const AflopendKredietTabel({Key? key}) : super(key: key);

  @override
  ConsumerState<AflopendKredietTabel> createState() => _DebtTableState();
}

class WidthColumn<T> {
  final ValueToWidth<String> header;
  final ValueToWidth<T> values;

  WidthColumn(
    this.header,
    this.values,
  );

  double get width => math.max(header.width, values.width);
}

class _DebtTableState
    extends AbstractAflopendKredietState<AflopendKredietTabel> {
  late DateFormat df = DateFormat.yMd(localeToString(context));
  Map<String, WidthColumn> map = {};
  FlexTableController flexTableController = FlexTableController();

  // TextToWidth _textToWidthDate = TextToWidth();
  // ValueToWidth _numberToWidthLening = ValueToWidth();
  // ValueToWidth _numberToWidthInterest = ValueToWidth();
  // ValueToWidth _numberToWidthTermijnBedrag = ValueToWidth();
  // ValueToWidth _numberToWidthAflossen = ValueToWidth();

  @override
  Widget buildAflopendKrediet(BuildContext context, AflopendKrediet ak) {
    if (ak.error.isNotEmpty || ak.termijnen.isEmpty) {
      return _buildEmpty();
    }

    ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.textTheme.bodyMedium!;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    FlexTableModel? tableModel = makeTableModel(
        ak: ak, textScaleFactor: textScaleFactor, style: textStyle);

    if (tableModel == null) {
      return _buildEmpty();
    }

    return DefaultTextStyle(
        style: textStyle,
        child: FlexTableToSliverBox(
            flexTableController: flexTableController,
            child: FlexTable(
              flexTableController: flexTableController,
              flexTableModel: tableModel,

              // sidePanelWidget: [
              //   if (!touch)
              //     (tableModel) => FlexTableLayoutParentDataWidget(
              //         tableLayoutPosition: const FlexTableLayoutPosition.bottom(),
              //         child: TableBottomBar(
              //             tableModel: tableModel, maxWidthSlider: 200.0))
              // ],
            )));
  }

  _buildEmpty() {
    return const SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
  }

  FlexTableModel? makeTableModel(
      {required AflopendKrediet ak,
      required TextStyle style,
      double textScaleFactor = 1.0,
      String numberFormatPattern = '#0.00'}) {
    final aantalTermijnen = ak.termijnen.length;

    if (aantalTermijnen == 0) {
      return null;
    }
    int rows = 0;
    int columns = 5;
    final data = FlexTableDataModel();

    rows = aantalTermijnen + 3;
    columns = 7;
    int r = 1;

    final lineColor = Colors.blueGrey[200]!;
    final h = data.horizontalLineList;
    // final lineNodeHorizontalList = h.createLineNodeList();

    int c = 1;
    //Datum

    Color unevenColor = const Color.fromARGB(255, 208, 234, 243);
    Color evenColor = Colors.white;

    data.addCell(
        row: r,
        column: c++,
        cell: Cell(
            value: 'Datum',
            attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

    //Schuld
    data.addCell(
        row: r,
        column: c++,
        cell: Cell(
            value: 'Lening',
            attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

    //Interest
    data.addCell(
        row: r,
        column: c++,
        cell: Cell(
            value: 'Rente',
            attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

    //Termijn
    data.addCell(
        row: r,
        column: c++,
        cell: Cell(
            value: 'T.b.',
            attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

    //Aflossen
    data.addCell(
        row: r,
        column: c++,
        cell: Cell(
            value: 'Afl.',
            attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));
    r++;

    for (var t in ak.termijnen) {
      int c = 1;
      //Datum

      data.addCell(
          row: r,
          column: c++,
          cell: Cell(
              value: df.format(t.termijn),
              attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

      //Schuld
      data.addCell(
          row: r,
          column: c++,
          cell: Cell(
              value: nf.parseDblToText(
                t.schuld,
                format: numberFormatPattern,
              ),
              attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

      //Interest
      data.addCell(
          row: r,
          column: c++,
          cell: Cell(
              value: nf.parseDblToText(
                t.interest,
                format: numberFormatPattern,
              ),
              attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

      //Termijn
      data.addCell(
          row: r,
          column: c++,
          cell: Cell(
              value: nf.parseDblToText(
                t.termijnBedrag,
                format: numberFormatPattern,
              ),
              attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));

      //Aflossen
      data.addCell(
          row: r,
          column: c++,
          cell: Cell(
              value: nf.parseDblToText(
                t.aflossen,
                format: numberFormatPattern,
              ),
              attr: {'background': r % 2 == 0 ? evenColor : unevenColor}));
      r++;
    }

    h.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: rows - 1,
        lineList: h.createLineNodeList(
            startLevelTwoIndex: 1,
            endLevelTwoIndex: 1,
            lineNode: LineNode(right: Line(color: lineColor))));

    h.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: rows - 1,
        lineList: h.createLineNodeList(
            startLevelTwoIndex: 2,
            endLevelTwoIndex: columns - 2,
            lineNode: LineNode(
                left: Line(color: lineColor), right: Line(color: lineColor))));

    h.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: rows - 1,
        lineList: h.createLineNodeList(
            startLevelTwoIndex: columns - 1,
            endLevelTwoIndex: columns - 1,
            lineNode: LineNode(left: Line(color: lineColor))));

    final v = data.verticalLineList;

    v.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: columns - 1,
        lineList: v.createLineNodeList(
            startLevelTwoIndex: 1,
            endLevelTwoIndex: 1,
            lineNode: LineNode(
              bottom: Line(color: lineColor),
            )));

    v.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: columns - 1,
        lineList: v.createLineNodeList(
            startLevelTwoIndex: 2,
            endLevelTwoIndex: rows - 2,
            lineNode: LineNode(
                bottom: Line(color: lineColor), top: Line(color: lineColor))));

    v.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: columns - 1,
        lineList: v.createLineNodeList(
            startLevelTwoIndex: rows - 1,
            endLevelTwoIndex: rows - 1,
            lineNode: LineNode(top: Line(color: lineColor))));

    double interestToCalculateWidth = 0.0;
    double aflossenToCalculateWidth = 0.0;

    if (ak.termijnen.length > 2) {
      interestToCalculateWidth = ak.termijnen[1].interest;
      for (int i = aantalTermijnen - 1; i >= 0; i--) {
        final value = ak.termijnen[i].aflossen;

        if (aflossenToCalculateWidth < value) {
          aflossenToCalculateWidth = value;
        } else {
          break;
        }
      }
    }
    int columnWidthIndex = 0;

    double calculateColumnWidth(String key, String header, var value,
        {double padding = 6.0}) {
      WidthColumn? widthColumn = map[key];

      if (widthColumn == null) {
        widthColumn = WidthColumn(
          ValueToWidth<String>(value: ''),
          value is num
              ? ValueToWidth<int>(value: 0)
              : ValueToWidth<String>(value: ''),
        );

        map[key] = widthColumn;
      }

      calculateWidthFromText(
          textStyle: style,
          textScaleFactor: 1,
          text: header,
          textToWidth: widthColumn.header);

      if (widthColumn.values is ValueToWidth<String>) {
        calculateWidthFromText(
            textStyle: style,
            textScaleFactor: 1,
            text: value,
            textToWidth: widthColumn.values as ValueToWidth<String>);
      } else if (widthColumn.values is ValueToWidth<int>) {
        calculateWidthFromNumber(
            textStyle: style,
            textScaleFactor: textScaleFactor,
            value: ak.lening,
            valueToWidth: widthColumn.values as ValueToWidth<int>);
      } else {
        assert(false, 'Runtype unknown');
      }

      return widthColumn.width + padding * 2.0;
    }

    return FlexTableModel(
        scrollLockX: true,
        scrollLockY: true,
        defaultWidthCell: 90.0,
        defaultHeightCell: 30.0,
        maximumColumns: columns,
        maximumRows: rows,
        scale: 1.0,
        minTableScale: 0.5,
        maxTableScale: 3.0,
        autoFreezeAreasX: [
          AutoFreezeArea(startIndex: 0, freezeIndex: 2, endIndex: columns - 1)
        ],
        autoFreezeAreasY: [
          AutoFreezeArea(startIndex: 0, freezeIndex: 2, endIndex: rows - 1)
        ],
        specificWidth: [
          RangeProperties(min: columnWidthIndex++, length: 2.0),
          RangeProperties(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'datum',
                'Datum',
                '00-00-0000',
              )),
          RangeProperties(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'lening',
                'lening',
                ak.lening,
              )),
          RangeProperties(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'termijnbedrag',
                'T.b.',
                ak.termijnBedragMnd,
              )),
          RangeProperties(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'Interest',
                'Rente',
                interestToCalculateWidth,
              )),
          RangeProperties(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'aflossen',
                'Afl.',
                aflossenToCalculateWidth,
              )),
          RangeProperties(min: columnWidthIndex++, length: 2.0)
        ],
        specificHeight: [
          RangeProperties(min: 0, max: 0, length: 2.0),
          RangeProperties(min: rows - 1, max: rows - 1, length: 2.0)
        ],
        dataTable: data);
  }
}
