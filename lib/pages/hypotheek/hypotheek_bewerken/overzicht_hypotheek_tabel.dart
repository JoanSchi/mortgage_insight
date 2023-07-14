import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flextable/flextable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/termijn/termijn.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/hypotheek_view_model.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

class OverzichtHypotheekTabel extends ConsumerStatefulWidget {
  const OverzichtHypotheekTabel({
    super.key,
  });

  @override
  ConsumerState<OverzichtHypotheekTabel> createState() =>
      _OverzichtHypotheekTabelState();
}

class _OverzichtHypotheekTabelState
    extends ConsumerState<OverzichtHypotheekTabel> {
  late FlexTableController flexTableController;
  FlexTableScaleChangeNotifier? _scaleChangeNotifier;

  FlexTableScaleChangeNotifier get scaleChangeNotifier =>
      _scaleChangeNotifier ??= FlexTableScaleChangeNotifier();

  late HypotheekTable hypotheekTable;

  @override
  void initState() {
    flexTableController = FlexTableController();
    hypotheekTable = HypotheekTable(
        termijnen: ref.read(hypotheekBewerkenProvider).hypotheek?.termijnen ??
            const IListConst([]));
    super.initState();
  }

  @override
  void didUpdateWidget(OverzichtHypotheekTabel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    flexTableController.dispose();
    _scaleChangeNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IList<Termijn> termijnen = ref.watch(
        hypotheekBewerkenProvider.select<IList<Termijn>>((value) =>
            value.hypotheek?.termijnen ?? const IListConst<Termijn>([])));

    final vorige = hypotheekTable;

    hypotheekTable = switch ((
      hypotheekTable,
      HypotheekTable(
        termijnen: termijnen,
        bcHeader: const Color.fromARGB(255, 115, 181, 203),
        fcHeader: Colors.white,
        bc1: const Color.fromARGB(255, 208, 234, 243),
        bc2: Colors.white,
      )
    )) {
      (HypotheekTable o, HypotheekTable n) => n.shouldRebuild(o) ? n : o,
    };

    Widget buildTable({FlexTableScaleChangeNotifier? scaleChangeNotifier}) {
      return FlexTable(
        scaleChangeNotifier: scaleChangeNotifier,
        flexTableController: flexTableController,
        flexTableModel: hypotheekTable.makeFlexTableModel(
            DeviceScreen3.of(context), vorige),
      );
    }

    return FlexTableToSliverBox(
        flexTableController: flexTableController,
        child: switch (defaultTargetPlatform) {
          TargetPlatform.linux ||
          TargetPlatform.macOS ||
          TargetPlatform.windows =>
            GridBorderLayout(children: [
              buildTable(scaleChangeNotifier: scaleChangeNotifier),
              GridBorderLayoutPosition(
                  row: 2,
                  squeezeRatio: 1.0,
                  measureHeight: true,
                  child: TableBottomBar(
                      scaleChangeNotifier: scaleChangeNotifier,
                      flexTableController: flexTableController,
                      maxWidthSlider: 200.0))
            ]),
          (_) => buildTable()
        });
  }
}

class HypotheekTable {
  IList<Termijn> termijnen;
  FlexTableModel? _flexTableModel;

  final df = DateFormat('dd-MM-yy');
  final nf = NumberFormat('#0.00', 'nl_nl');
  final autoFreezeAreasX = <AutoFreezeArea>[];
  final autoFreezeAreasY = <AutoFreezeArea>[];
  List<RangeProperties> specificWidth = [];

  int rowStartLayout = 0;
  int columnStartLayout = 0;
  int layoutRows = 0;
  int layoutColumns = 0;

  final Color? bcHeader;
  final Color? fcHeader;
  final Color? bc1;
  final Color? bc2;
  final Color? fc1;
  final Color? fc2;

  Color lineColor = Colors.white;
  double lineWidth = 0.5;

  HypotheekTable({
    this.rowStartLayout = 0,
    this.columnStartLayout = 0,
    this.bcHeader,
    this.fcHeader,
    this.bc1,
    this.bc2,
    this.fc1,
    this.fc2,
    required this.termijnen,
  });

  FlexTableModel? get flexTableModel => _flexTableModel;

  FlexTableModel makeFlexTableModel(
      DeviceScreen3 deviceScreen3, HypotheekTable? vorige) {
    return _flexTableModel ??= _make(deviceScreen3, vorige);
  }

  FlexTableModel _make(DeviceScreen3 deviceScreen3, HypotheekTable? vorige) {
    int column = columnStartLayout;
    int columnStart = column;
    int row = rowStartLayout;
    int rowStart = row;

    final headerAttr = {
      'background': bcHeader,
      'textStyle': TextStyle(color: fcHeader, fontWeight: FontWeight.bold),
      'alignment': Alignment.bottomCenter
    };

    final data = FlexTableDataModelCR();

    data.addCell(
        row: row,
        column: column++,
        rows: 2,
        cell: Cell(value: 'Datum', attr: headerAttr));

    data.addCell(
      row: row,
      column: column++,
      rows: 2,
      cell: Cell(value: 'Lening', attr: headerAttr),
    );

    data.addCell(
        row: row,
        column: columnStart + 2,
        columns: 2,
        cell: Cell(value: 'Per maand', attr: headerAttr));

    data.addCell(
        row: row,
        column: columnStart + 4,
        columns: 2,
        cell: Cell(value: 'Per jaar', attr: headerAttr));

    row++;

    data.addCell(
        row: row,
        column: column++,
        cell: Cell(value: 'Rente', attr: headerAttr));

    data.addCell(
        row: row,
        column: column++,
        cell: Cell(value: 'Aflossen', attr: headerAttr));
    data.addCell(
        row: row,
        column: column++,
        cell: Cell(value: 'Rente', attr: headerAttr));
    data.addCell(
        row: row,
        column: column++,
        cell: Cell(value: 'Aflossen', attr: headerAttr));
    // data.addCell(
    //     row: row,
    //     column: column++,
    //     cell: Cell(value: 'Teruggave', attr: headerAttr));
    // data.addCell(
    //     row: row,
    //     column: column++,
    //     cell: Cell(
    //         value: 'Netto', attr: {'background': rowColor}));
    // data.addCell(
    //     row: row,
    //     column: column++,
    //     cell: Cell(
    //         value: 'N. e/m', attr: {'background': rowColor}));

    final length = termijnen.length;
    int huidigeJaar = 0;
    int jaarRow = 0;
    double jaarRente = 0.0;
    double jaarAflossen = 0.0;

    row++;

    for (int i = 0; i < length; i++) {
      Termijn t = termijnen[i];
      final jaar = t.startDatum.year;
      final mndRente = t.renteBedrag;
      final mndAflossen = t.aflossen + t.extraAflossen;
      Color? rowColor = row % 2 == 0 ? bc2 : bc1;

      column = columnStart;
      data.addCell(
          row: row,
          column: column++,
          cell: Cell(
              value: df.format(t.startDatum), attr: {'background': rowColor}));
      data.addCell(
          row: row,
          column: column++,
          cell:
              Cell(value: nf.format(t.lening), attr: {'background': rowColor}));
      data.addCell(
          row: row,
          column: column++,
          cell:
              Cell(value: nf.format(mndRente), attr: {'background': rowColor}));

      data.addCell(
          row: row,
          column: column++,
          cell: Cell(
              value: nf.format(mndAflossen), attr: {'background': rowColor}));

      if (i == 0) {
        huidigeJaar = jaar;
        jaarRow = row;
      }

      if (i == length - 1) {
        jaarRente += mndRente;
        jaarAflossen += mndAflossen;

        int deltaRow = row - jaarRow + 1;

        //Jaar Rente

        Color? yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

        data.addCell(
            row: jaarRow,
            column: column++,
            rows: deltaRow,
            cell: Cell(
                value: nf.format(jaarRente),
                attr: {'background': yearColorBlock}));

        //Jaar aflossen

        yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

        data.addCell(
            row: jaarRow,
            column: column++,
            rows: deltaRow,
            cell: Cell(
                value: nf.format(jaarAflossen),
                attr: {'background': yearColorBlock}));
      } else if (jaar > huidigeJaar) {
        int deltaRow = row - jaarRow;

        //Jaar Rente

        Color? yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

        data.addCell(
            row: jaarRow,
            column: column++,
            rows: deltaRow,
            cell: Cell(
                value: nf.format(jaarRente),
                attr: {'background': yearColorBlock}));

        //Jaar aflossen

        yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

        data.addCell(
            row: jaarRow,
            column: column++,
            rows: deltaRow,
            cell: Cell(
                value: nf.format(jaarAflossen),
                attr: {'background': yearColorBlock}));

        huidigeJaar = jaar;
        jaarRow = row;
        jaarRente = mndRente;
        jaarAflossen = mndAflossen;
      } else {
        jaarRente += mndRente;
        jaarAflossen += mndAflossen;
      }
      row++;
    }

    addFreeze(
        autoFreezeAuto: autoFreezeAreasX,
        start: columnStart,
        freeze: columnStart + 1,
        end: column);

    addFreeze(
        autoFreezeAuto: autoFreezeAreasY,
        start: rowStart,
        freeze: rowStart + 2,
        end: row);

    specificWidth.addAll([
      RangeProperties(min: columnStart, max: columnStart, length: 75.0),
      RangeProperties(min: columnStart + 1, max: columnStart + 1, length: 85.0),
      RangeProperties(min: columnStart + 2, max: columnStart + 3, length: 75.0),
      RangeProperties(min: columnStart + 4, max: columnStart + 4, length: 75.0),
    ]);

    final h = data.horizontalLineList;

    LineNodeList horizontalLine(
            int startColumn, int endColumn, Color lineColor) =>
        h.createLineNodeList(
            startLevelTwoIndex: startColumn,
            lineNode: LineNode(
                left: const Line.noLine(),
                right: Line(width: lineWidth, color: lineColor)))
          ..addLineNode(
              startLevelTwoIndex: endColumn,
              lineNode: LineNode(
                  left: Line(width: lineWidth, color: lineColor),
                  right: const Line.noLine()));

    h
      ..addList(
          startLevelOneIndex: rowStart,
          lineList: horizontalLine(columnStart, column, lineColor))
      ..addList(
          startLevelOneIndex: rowStart + 1,
          lineList: horizontalLine(columnStart + 2, column, lineColor))
      ..addList(
          startLevelOneIndex: rowStart + 2,
          lineList: horizontalLine(
              columnStart, column, const Color.fromARGB(255, 13, 131, 190)))
      ..addList(
          startLevelOneIndex: row,
          lineList: horizontalLine(
              columnStart, column, const Color.fromARGB(255, 13, 131, 190)));

    final v = data.verticalLineList;

    LineNodeList verticalLine(int startRow, int endRow, Color lineColor) {
      return v.createLineNodeList(
          startLevelTwoIndex: startRow,
          lineNode: LineNode(
              top: const Line.noLine(),
              bottom: Line(width: lineWidth, color: lineColor)))
        ..addLineNode(
            startLevelTwoIndex: endRow,
            lineNode: LineNode(
                top: Line(width: lineWidth, color: lineColor),
                bottom: const Line.noLine()));
    }

    v
      ..addList(
          startLevelOneIndex: columnStart,
          endLevelOneIndex: columnStart + 2,
          lineList: verticalLine(rowStart, row, lineColor))
      ..addList(
          startLevelOneIndex: columnStart + 3,
          lineList: verticalLine(rowStart + 1, row, lineColor))
      ..addList(
          startLevelOneIndex: columnStart + 4,
          lineList: verticalLine(rowStart, row, lineColor))
      ..addList(
          startLevelOneIndex: columnStart + 5,
          lineList: verticalLine(rowStart + 1, row, lineColor))
      ..addList(
          startLevelOneIndex: columnStart + 6,
          endLevelOneIndex: column,
          lineList: verticalLine(rowStart, row, lineColor));

    if (layoutRows < row + 1) {
      layoutRows = row + 1;
    }

    if (layoutColumns < column) {
      layoutColumns = column;
    }

    double minTableScale = 0.5;
    double maxTableScale = 3.0;
    double tableScale = 1.0;

    switch (deviceScreen3.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        break;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        minTableScale = 1.0;
        tableScale = 1.5;
        maxTableScale = 4.0;
        break;
    }

    return FlexTableModel(
        stateSplitX: SplitState.noSplit,
        stateSplitY: SplitState.noSplit,
        columnHeader: false,
        rowHeader: false,
        scrollLockX: true,
        scrollLockY: true,
        specificWidth: specificWidth,
        defaultWidthCell: 70.0,
        defaultHeightCell: 25.0,
        maximumColumns: layoutColumns,
        maximumRows: layoutRows,
        dataTable: data,
        panelMargin: 2.0,
        autoFreezeAreasX: autoFreezeAreasX,
        autoFreezeAreasY: autoFreezeAreasY,
        scale: clampDouble(vorige?.flexTableModel?.tableScale ?? tableScale,
            minTableScale, maxTableScale),
        minTableScale: minTableScale,
        maxTableScale: maxTableScale);
  }

  bool shouldRebuild(HypotheekTable oldDelegate) =>
      termijnen != oldDelegate.termijnen ||
      bcHeader != oldDelegate.bcHeader ||
      fcHeader != oldDelegate.fcHeader ||
      bc1 != oldDelegate.bc1 ||
      bc2 != oldDelegate.bc2 ||
      fc1 != oldDelegate.fc1 ||
      fc2 != oldDelegate.fc2;
}

void addFreeze(
    {required List<AutoFreezeArea> autoFreezeAuto,
    required int start,
    required int freeze,
    required int end}) {
  for (var freeze in autoFreezeAuto) {
    if (freeze.startIndex == start) {
      if (freeze.endIndex < end) {
        freeze.endIndex = end;
      }
      return;
    }
  }

  autoFreezeAuto.add(AutoFreezeArea(
      startIndex: start,
      freezeIndex: freeze,
      endIndex: end,
      customSplitSize: 0.5));
}
