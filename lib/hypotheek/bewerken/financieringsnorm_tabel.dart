import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/my_widgets/animated_scale_resize_switcher.dart';
import 'package:sliver_table/FlexTable/DataFlexTable.dart';
import 'package:sliver_table/FlexTable/TableItems/Cells.dart';
import 'package:sliver_table/FlexTable/TableLine.dart';
import 'package:sliver_table/FlexTable/TableModel.dart';
import 'package:sliver_table/FlexTable/TableMultiPanelPortView.dart';
import 'package:sliver_table/SliverToViewPortBox.dart';
import '../../model/nl/hypotheek/financierings_norm/norm_inkomen.dart';
import '../../model/nl/hypotheek/hypotheek.dart';
import '../../utilities/MyNumberFormat.dart';
import '../../utilities/date.dart';
import '../../utilities/value_to_width.dart';
import 'hypotheek_model.dart';

class FinancieringsNormTable extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;
  final ScrollController? controller;

  const FinancieringsNormTable(
      {Key? key, required this.hypotheekViewModel, this.controller})
      : super(key: key);

  @override
  State<FinancieringsNormTable> createState() => _FinancieringsNormTableState();
}

class _ShrinkFlexTableToViewPortBoxDelegate
    extends SliverToViewPortBoxDelegate {
  final FlexTable? flexTable;

  _ShrinkFlexTableToViewPortBoxDelegate({required this.flexTable});

  Widget build(BuildContext context, double shrinkOffset, double paintExtent) {
    final f = flexTable;
    return AnimatedScaleResizeSwitcher(
        child: f != null ? f : SizedBox.shrink());
  }

  bool shouldRebuild(_ShrinkFlexTableToViewPortBoxDelegate oldDelegate) => true;

  @override
  sliverScroll(double offset) {
    flexTable?.tableModel.setScrollWithSliver(offset);
  }
}

class _FinancieringsNormTableState extends State<FinancieringsNormTable> {
  late _FinancieringsnormenGegevens gegevens;
  final columnWidthByHeader1 = ValueToWidth<String>(value: '');
  final columnWidthByValue1 = ValueToWidth<int>(value: 0);
  final columnWidthByHeader2 = ValueToWidth<String>(value: '');
  final columnWidthByValue2 = ValueToWidth<int>(value: 0);

  late MyNumberFormat nf = MyNumberFormat(context);
  late DateFormat df = DateFormat.yMd(localeToString(context));

  @override
  void initState() {
    gegevens =
        _FinancieringsnormenGegevens.from(widget.hypotheekViewModel.hypotheek);
    widget.hypotheekViewModel.addListener(notify);
    super.initState();
  }

  @override
  void dispose() {
    widget.hypotheekViewModel.removeListener(notify);
    super.dispose();
  }

  notify() {
    final nieuweGegevens =
        _FinancieringsnormenGegevens.from(widget.hypotheekViewModel.hypotheek);

    if (nieuweGegevens != gegevens) {
      setState(() {
        gegevens = nieuweGegevens;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return gegevens.toepassen
        ? _buildTable(context)
        : SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
  }

  Widget _buildTable(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyText2!;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final tableModel =
        makeTableModel(style: textStyle, textScaleFactor: textScaleFactor);

    return DefaultTextStyle(
        style: textStyle,
        child: SliverToViewPortBox(
            delegate: _ShrinkFlexTableToViewPortBoxDelegate(
                flexTable: FlexTable(
          maxWidth: 980,
          tableModel: tableModel,
          sliverController: widget.controller,
          alignment: Alignment.topCenter,
          sidePanelWidget: [
            // if (false)
            //   (tableModel) => FlexTableLayoutParentDataWidget(
            //       tableLayoutPosition: FlexTableLayoutPosition.bottom(),
            //       child: TableBottomBar(
            //           tableModel: tableModel, maxWidthSlider: 200.0))
          ],
        ))));
  }

  TableModel makeTableModel(
      {required TextStyle style,
      double textScaleFactor = 1.0,
      String numberFormatPattern = '#0.00'}) {
    final data = DataFlexTable();

    final lineColor = Colors.blueGrey[200]!;
    final v = data.verticalLineList;
    final h = data.horizontalLineList;

    int c = 1;
    int r = 1;

    final drawingVerticalLine =
        List.filled(gegevens.omschrijvingen.length, false);

    startVerticalLine({required int i, required int row, required int column}) {
      if (!drawingVerticalLine[i]) {
        v.addList(
            startLevelOneIndex: column + i,
            endLevelOneIndex: column + i,
            lineList: v.createLineNodeList(
                startLevelTwoIndex: row,
                endLevelTwoIndex: row,
                lineNode: LineNode(
                  bottom: Line(color: lineColor),
                )));
        drawingVerticalLine[i] = true;
      }
    }

    endVerticalLine(int i, int row, int column) {
      if (drawingVerticalLine[i]) {
        v.addList(
            startLevelOneIndex: column + i,
            endLevelOneIndex: column + i,
            lineList: v.createLineNodeList(
                startLevelTwoIndex: row,
                endLevelTwoIndex: row,
                lineNode: LineNode(
                  top: Line(color: lineColor),
                )));

        drawingVerticalLine[i] = false;
      }
    }

    void finishVerticalLine({required int row, required int column}) {
      for (int i = 0; i < drawingVerticalLine.length; i++) {
        if (drawingVerticalLine[i]) {
          v.addList(
              startLevelOneIndex: column + i,
              lineList: v.createLineNodeList(
                  startLevelTwoIndex: row,
                  lineNode: LineNode(
                    top: Line(color: lineColor),
                  )));
        }
      }
    }

    toRowCell({
      required List list,
      required int row,
      required int column,
      toValue,
    }) {
      late SpanCell _m;

      int length = list.length;
      for (int i = 0; i < length; i++) {
        final value = list[i];

        if (i == 0) {
          _m = SpanCell(value: value, cell: Cell(value: toValue(value)));
          startVerticalLine(i: i, row: row, column: column);
        } else {
          if (_m.value == value) {
            endVerticalLine(i, row, column);
            _m.span++;
          } else {
            data.addCell(
                row: row,
                column: column + _m.column,
                cell: _m.cell,
                columns: _m.span);

            _m.setNext(value: value, cell: Cell(value: toValue(value)));
            startVerticalLine(i: i, row: row, column: column);
          }
        }

        if (i == length - 1) {
          data.addCell(
            row: row,
            column: column + _m.column,
            columns: _m.span,
            cell: _m.cell,
          );
        }
      }
    }

    // DefaultTableBuilder

    data.addCell(
        row: r,
        column: c,
        cell: Cell(
            value: 'Omschrijving', attr: {'alignment': Alignment.centerLeft}));
    toRowCell(
        list: gegevens.omschrijvingen,
        column: c + 1,
        row: r++,
        toValue: (String v) => v);

    if (gegevens.verschillendeDatums) {
      data.addCell(row: r, column: c, cell: Cell(value: 'Datum'));
      toRowCell(
          list: gegevens.datums,
          column: c + 1,
          row: r++,
          toValue: (DateTime v) => df.format(v));
    }
    // DefaultTableBuilder
    data.addCell(
        row: r,
        column: c,
        cell: Cell(value: 'Totaal', attr: {'alignment': Alignment.centerLeft}));
    toRowCell(
      list: gegevens.totaals,
      column: c + 1,
      row: r++,
      toValue: (double v) => nf.parseDoubleToText(v, '#0'),
    );

    if (gegevens.verduurzamen.fold(0.0, (double pr, element) => pr + element) >
        0.1) {
      data.addCell(
          row: r,
          column: c,
          cell: Cell(
              value: 'Verduurzamen',
              attr: {'alignment': Alignment.centerLeft}));
      toRowCell(
        list: gegevens.verduurzamen,
        column: c + 1,
        row: r++,
        toValue: (double v) => nf.parseDoubleToText(v, '#0'),
      );
    }

    if (gegevens.delen) {
      data.addCell(
          row: r,
          column: c,
          cell: Cell(
              value: 'Resterend', attr: {'alignment': Alignment.centerLeft}));
      toRowCell(
        list: gegevens.resterenden,
        column: c + 1,
        row: r++,
        toValue: (double v) => nf.parseDoubleToText(v, '#0'),
      );
    }

    finishVerticalLine(row: r, column: 2);

    v.addList(
        startLevelOneIndex: c,
        lineList: v.createLineNodeList(
            startLevelTwoIndex: 1,
            lineNode: LineNode(
              bottom: Line(color: lineColor),
            ))
          ..addLineNode(
              startLevelTwoIndex: r,
              lineNode: LineNode(
                top: Line(color: lineColor),
              )));

    final endfirstTable = c + 1 + gegevens.omschrijvingen.length;

    v.addList(
        startLevelOneIndex: endfirstTable,
        lineList: v.createLineNodeList(
            startLevelTwoIndex: 1,
            lineNode: LineNode(
              bottom: Line(color: lineColor),
            ))
          ..addLineNode(
              startLevelTwoIndex: r,
              lineNode: LineNode(
                top: Line(color: lineColor),
              )));

    //Horizontale lijnen

    h.addList(
        startLevelOneIndex: 1,
        endLevelOneIndex: r,
        lineList: h.createLineNodeList(
            startLevelTwoIndex: 1,
            lineNode: LineNode(
              right: Line(color: lineColor),
            ))
          ..addLineNode(
              startLevelTwoIndex: endfirstTable,
              lineNode: LineNode(
                left: Line(color: lineColor),
              )));

    r = r;

    int rows = r > 0 ? r + 1 : 3;
    int columns = endfirstTable > 0 ? endfirstTable + 1 : 3;
    int columnWidthIndex = 0;

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
          PropertiesRange(min: columnWidthIndex++, length: 1.0),
          PropertiesRange(min: columnWidthIndex++, length: 120.0),
          //   PropertiesRange(
          //       min: columnWidthIndex++,
          //       length: calculateColumnWidth(
          //         'lening',
          //         'lening',
          //         aflopendKrediet.lening,
          //       )),
          //   PropertiesRange(
          //       min: columnWidthIndex++,
          //       length: calculateColumnWidth(
          //         'termijnbedrag',
          //         'T.b.',
          //         aflopendKrediet.termijnBedragMnd,
          //       )),
          //   PropertiesRange(
          //       min: columnWidthIndex++,
          //       length: calculateColumnWidth(
          //         'Interest',
          //         'Rente',
          //         interestToCalculateWidth,
          //       )),
          //   PropertiesRange(
          //       min: columnWidthIndex++,
          //       length: calculateColumnWidth(
          //         'aflossen',
          //         'Afl.',
          //         aflossenToCalculateWidth,
          //       )),
          PropertiesRange(min: columns - 1, length: 2.0)
        ],
        specificHeight: [
          PropertiesRange(min: 0, max: 0, length: 2.0),
          PropertiesRange(min: rows - 1, max: rows - 1, length: 2.0)
        ],
        dataTable: data);
  }
}

class _FinancieringsnormenGegevens {
  List<String> omschrijvingen = [];
  List<DateTime> datums = [];
  List<double> totaals = [];
  List<double> resterenden = [];
  List<double> verduurzamen = [];
  bool delen;
  bool verschillendeDatums = false;

  _FinancieringsnormenGegevens.from(Hypotheek hypotheek)
      : delen = hypotheek.parallelLeningen.list.length > 0 {
    if (hypotheek.afgesloten) {
      return;
    }

    final mI = hypotheek.maxLeningInkomen;

    if (mI.isbepaald) {
      List<GegevensNormInkomen> gegevens = mI.gegevens;

      int index = 0;
      int length = gegevens.length;
      double somParellelLeningen = 0.0;

      bool add(GegevensNormInkomen g) {
        if (g.fout.isNotEmpty) {
          return false;
        }
        omschrijvingen.add('Inkomen');
        datums.add(g.startDatum);
        totaals.add((somParellelLeningen + g.optimalisatieLast.lening));
        resterenden.add(g.optimalisatieLast.lening);
        verduurzamen.add(mI.verduurzaamKosten);

        return true;
      }

      bool volgende = true;

      if (length > index) {
        somParellelLeningen = gegevens[index].parallelLeningen.somLeningen;
        volgende = add(gegevens[index++]);
      }
      while (volgende && index < length) {
        add(gegevens[index++]);
      }
    }

    final mW = hypotheek.maxLeningWoningWaarde;

    if (mW.isbepaald) {
      omschrijvingen.add('woning');
      datums.add(hypotheek.startDatum);
      totaals.add(mW.totaal);
      resterenden.add(mW.resterend);
      verduurzamen.add(mW.verduurzaamKosten);
    }

    final mN = hypotheek.maxLeningNHG;

    if (mN.isbepaald) {
      omschrijvingen.add('Nhg');
      datums.add(hypotheek.startDatum);
      totaals.add(mN.totaal);
      resterenden.add(mN.resterend);
      verduurzamen.add(mN.verduurzaamKosten);
    }

    verschillendeDatums =
        datums.any((DateTime v) => v.compareTo(hypotheek.startDatum) != 0);
  }

  bool get toepassen => omschrijvingen.isNotEmpty;

  @override
  bool operator ==(covariant _FinancieringsnormenGegevens other) {
    if (identical(this, other)) return true;

    return listEquals(other.omschrijvingen, omschrijvingen) &&
        listEquals(other.datums, datums) &&
        listEquals(other.totaals, totaals) &&
        listEquals(other.resterenden, resterenden) &&
        listEquals(other.verduurzamen, verduurzamen) &&
        other.delen == delen;
  }

  @override
  int get hashCode {
    return omschrijvingen.hashCode ^
        datums.hashCode ^
        totaals.hashCode ^
        resterenden.hashCode ^
        verduurzamen.hashCode ^
        delen.hashCode;
  }
}

class SpanCell {
  Object value;
  int column = 0;
  int span = 1;
  Cell cell;

  SpanCell({
    required this.value,
    required this.cell,
    this.span = 1,
  });

  setNext({required Object value, required Cell cell}) {
    this.value = value;
    this.cell = cell;
    column += span;
    span = 1;
  }

  int get end => column + span;
}

class SpacerFinancieringsTabel extends StatefulWidget {
  final HypotheekViewModel hypotheekViewModel;

  const SpacerFinancieringsTabel({Key? key, required this.hypotheekViewModel})
      : super(key: key);

  @override
  State<SpacerFinancieringsTabel> createState() =>
      _SpacerFinancieringsTabelState();
}

class _SpacerFinancieringsTabelState extends State<SpacerFinancieringsTabel> {
  double height = 0.0;
  @override
  void initState() {
    height = determineHeight();
    widget.hypotheekViewModel.addListener(notify);
    super.initState();
  }

  @override
  void dispose() {
    widget.hypotheekViewModel.removeListener(notify);
    super.dispose();
  }

  notify() {
    final dH = determineHeight();

    if (height != dH) {
      setState(() {
        height = dH;
      });
    }
  }

  double determineHeight() {
    final h = widget.hypotheekViewModel.hypotheek;
    return !h.afgesloten &&
            (h.maxLeningInkomen.isbepaald ||
                h.maxLeningWoningWaarde.isbepaald ||
                h.maxLeningNHG.isbepaald)
        ? 16.0
        : 0.0;
  }

  @override
  Widget build(BuildContext context) => SliverSpacer(
        height: height,
      );
}

class SliverSpacer extends StatefulWidget {
  final double height;
  const SliverSpacer({Key? key, required this.height}) : super(key: key);

  @override
  State<SliverSpacer> createState() => _SliverSpacerState();
}

class _SliverSpacerState extends State<SliverSpacer>
    with SingleTickerProviderStateMixin {
  Tween tween = Tween(begin: 0.0, end: 0.0);

  late AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 200));

  late Animation _animation = tween.animate(_controller);

  @override
  void initState() {
    tween.end = widget.height;
    _controller.value = 1.0;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SliverSpacer oldWidget) {
    if (tween.end != widget.height) {
      tween.begin = _animation.value;
      tween.end = widget.height;

      _controller.value = 0.0;
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
          child: AnimatedBuilder(
        animation: _animation,
        builder: ((context, child) => SizedBox(height: _animation.value)),
      ));
}
