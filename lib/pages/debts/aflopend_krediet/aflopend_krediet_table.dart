import 'package:flextable/FlexTable/body_layout.dart';
import 'package:flextable/FlexTable/data_flexfable.dart';
import 'package:flextable/FlexTable/table_bottombar.dart';
import 'package:flextable/FlexTable/table_line.dart';
import 'package:flextable/FlexTable/table_model.dart';
import 'package:flextable/FlexTable/table_multi_panel_portview.dart';
import 'package:flextable/sliver_to_viewportbox.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flextable/FlexTable/TableItems/Cells.dart';
import '../../../model/nl/schulden/schulden_aflopend_krediet.dart';
import '../../../utilities/MyNumberFormat.dart';
import 'dart:math' as math;
import '../../../utilities/date.dart';
import '../../../utilities/value_to_width.dart';
import 'aflopend_krediet_model.dart';

class DebtTable extends StatefulWidget {
  final ScrollController? controller;
  final AflopendKredietModel? aflopendKredietModel;

  DebtTable({Key? key, this.controller, required this.aflopendKredietModel})
      : super(key: key);

  @override
  State<DebtTable> createState() => _DebtTableState();
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

class _DebtTableState extends State<DebtTable> {
  AflopendKredietModel? aflopendKredietModel;
  AflopendKrediet? aflopendKrediet;

  Map<String, WidthColumn> map = {};

  // TextToWidth _textToWidthDate = TextToWidth();
  // ValueToWidth _numberToWidthLening = ValueToWidth();
  // ValueToWidth _numberToWidthInterest = ValueToWidth();
  // ValueToWidth _numberToWidthTermijnBedrag = ValueToWidth();
  // ValueToWidth _numberToWidthAflossen = ValueToWidth();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (aflopendKredietModel != widget.aflopendKredietModel) {
      aflopendKredietModel?.removeListener(notify);
      aflopendKredietModel = widget.aflopendKredietModel?..addListener(notify);
    }
  }

  notify() {
    setState(() {});
  }

  @override
  void didUpdateWidget(DebtTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (aflopendKredietModel != widget.aflopendKredietModel) {
      aflopendKredietModel?.removeListener(notify);
      aflopendKredietModel = widget.aflopendKredietModel?..addListener(notify);
    }
  }

  @override
  void dispose() {
    aflopendKredietModel?.removeListener(notify);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (aflopendKredietModel == null ||
        aflopendKredietModel!.ak.termijnen.length < 2) {
      print(
          'aflopendKredietModel!.ak.termijnen.length ${aflopendKredietModel!.ak.termijnen.length}');
      return _buildEmpty();
    }

    final ak = aflopendKredietModel!.ak;

    ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.textTheme.bodyText2!;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    MyNumberFormat nf = MyNumberFormat(context);
    DateFormat df = DateFormat.yMd(localeToString(context));

    TableModel? tableModel = makeTableModel(
        aflopendKrediet: ak,
        df: df,
        nf: nf,
        textScaleFactor: textScaleFactor,
        style: textStyle);

    if (tableModel == null) {
      return _buildEmpty();
    }

    final touch = ScrollConfiguration.of(context)
        .dragDevices
        .contains(PointerDeviceKind.touch);

    return DefaultTextStyle(
        style: textStyle,
        child: SliverToViewPortBox(
            delegate: FlexTableToViewPortBoxDelegate(
                flexTable: FlexTable(
          maxWidth: 980,
          findSliverScrollPosition: true,
          tableModel: tableModel,
          alignment: Alignment.topCenter,
          sidePanelWidget: [
            if (!touch)
              (tableModel) => FlexTableLayoutParentDataWidget(
                  tableLayoutPosition: FlexTableLayoutPosition.bottom(),
                  child: TableBottomBar(
                      tableModel: tableModel, maxWidthSlider: 200.0))
          ],
        ))));
  }

  _buildEmpty() {
    return SliverToBoxAdapter(
      child: SizedBox.shrink(),
    );
  }

  TableModel? makeTableModel(
      {required AflopendKrediet aflopendKrediet,
      required DateFormat df,
      required MyNumberFormat nf,
      required TextStyle style,
      double textScaleFactor = 1.0,
      String numberFormatPattern = '#0.00'}) {
    final aantalTermijnen = aflopendKrediet.termijnen.length;

    if (aantalTermijnen == 0) {
      return null;
    }
    int rows = 0;
    int columns = 5;
    final data = DataFlexTable();

    rows = aantalTermijnen + 3;
    columns = 7;
    int r = 1;

    final lineColor = Colors.blueGrey[200]!;
    final h = data.horizontalLineList;
    // final lineNodeHorizontalList = h.createLineNodeList();

    int c = 1;
    //Datum

    Color unevenColor = Color.fromARGB(255, 208, 234, 243);
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

    aflopendKrediet.termijnen.forEach((AKtermijnAnn t) {
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
    });

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

    if (aflopendKrediet.termijnen.length > 2) {
      interestToCalculateWidth = aflopendKrediet.termijnen[1].interest;
      for (int i = aantalTermijnen - 1; i >= 0; i--) {
        final value = aflopendKrediet.termijnen[i].aflossen;

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
            value: aflopendKrediet.lening,
            valueToWidth: widthColumn.values as ValueToWidth<int>);
      } else {
        assert(false, 'Runtype unknown');
      }

      return widthColumn.width + padding * 2.0;
    }

    return TableModel(
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
          PropertiesRange(min: columnWidthIndex++, length: 2.0),
          PropertiesRange(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'datum',
                'Datum',
                '00-00-0000',
              )),
          PropertiesRange(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'lening',
                'lening',
                aflopendKrediet.lening,
              )),
          PropertiesRange(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'termijnbedrag',
                'T.b.',
                aflopendKrediet.termijnBedragMnd,
              )),
          PropertiesRange(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'Interest',
                'Rente',
                interestToCalculateWidth,
              )),
          PropertiesRange(
              min: columnWidthIndex++,
              length: calculateColumnWidth(
                'aflossen',
                'Afl.',
                aflossenToCalculateWidth,
              )),
          PropertiesRange(min: columnWidthIndex++, length: 2.0)
        ],
        specificHeight: [
          PropertiesRange(min: 0, max: 0, length: 2.0),
          PropertiesRange(min: rows - 1, max: rows - 1, length: 2.0)
        ],
        dataTable: data);
  }
}
