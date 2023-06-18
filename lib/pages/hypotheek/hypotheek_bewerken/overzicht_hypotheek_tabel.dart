// import 'package:flextable/FlexTable/TableItems/Cells.dart';
// import 'package:flextable/FlexTable/data_flexfable.dart';
// import 'package:flextable/FlexTable/table_line.dart';
// import 'package:flextable/FlexTable/table_model.dart';
// import 'package:flextable/FlexTable/table_multi_panel_portview.dart';
// import 'package:flextable/sliver_to_viewportbox.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:mortgage_insight/pages/hypotheek/bewerken/hypotheek_model.dart';
// import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';

// class _HypotheekTabelGegevens {
//   List<Termijn> termijnen;

//   _HypotheekTabelGegevens({
//     required this.termijnen,
//   });

//   _HypotheekTabelGegevens.from(HypotheekViewModel v)
//       : termijnen = v.hypotheek.termijnen;

//   bool get isLeeg => termijnen.isEmpty;

//   @override
//   bool operator ==(covariant _HypotheekTabelGegevens other) {
//     if (identical(this, other)) return true;

//     return listEquals(other.termijnen, termijnen);
//   }

//   @override
//   int get hashCode => termijnen.hashCode;
// }

// class OverzichtHypotheekTabel extends StatefulWidget {
//   final HypotheekViewModel hypotheekViewModel;
//   final ScrollController? controller;

//   const OverzichtHypotheekTabel(
//       {super.key, required this.hypotheekViewModel, required this.controller});

//   @override
//   State<OverzichtHypotheekTabel> createState() =>
//       _OverzichtHypotheekTabelState();
// }

// class _OverzichtHypotheekTabelState extends State<OverzichtHypotheekTabel> {
//   TableModel? tableModel;
//   late _HypotheekTabelGegevens _gegevens;
//   late HypotheekViewModel hypotheekViewModel = widget.hypotheekViewModel;

//   @override
//   void initState() {
//     super.initState();
//     hypotheekViewModel = widget.hypotheekViewModel..addListener(update);

//     _gegevens = _HypotheekTabelGegevens.from(hypotheekViewModel);

//     if (!_gegevens.isLeeg) {
//       final h = HypotheekTable(rowStartLayout: 1, columnStartLayout: 1)
//         ..makeTable(
//             headerColor: Color.fromARGB(255, 115, 181, 203),
//             gegevens: _gegevens,
//             bc1: Color.fromARGB(255, 208, 234, 243));
//       tableModel = h.tableModel();
//     }
//   }

//   @override
//   void didUpdateWidget(OverzichtHypotheekTabel oldWidget) {
//     if (hypotheekViewModel != widget.hypotheekViewModel) {
//       hypotheekViewModel.removeListener(update);
//       hypotheekViewModel = widget.hypotheekViewModel..addListener(update);
//       update();
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   void update() {
//     final nieuweGegevens = _HypotheekTabelGegevens.from(hypotheekViewModel);

//     if (_gegevens != nieuweGegevens) {
//       setState(() {
//         _gegevens = nieuweGegevens;

//         if (!_gegevens.isLeeg) {
//           final h = HypotheekTable(rowStartLayout: 1, columnStartLayout: 1)
//             ..makeTable(
//                 headerColor: Color.fromARGB(255, 115, 181, 203),
//                 gegevens: _gegevens,
//                 bc1: Color.fromARGB(255, 208, 234, 243));
//           tableModel = h.tableModel();
//         } else {
//           tableModel = null;
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final t = tableModel;
//     return t == null
//         ? SliverToBoxAdapter(
//             child: SizedBox.shrink(),
//           )
//         : SliverToViewPortBox(
//             delegate: FlexTableToViewPortBoxDelegate(
//                 flexTable: FlexTable(
//             maxWidth: 980,
//             tableModel: t,
//             findSliverScrollPosition: true,
//             alignment: Alignment.topCenter,
//             sidePanelWidget: [
//               // if (false)
//               // (tableModel) => FlexTableLayoutParentDataWidget(
//               //     tableLayoutPosition: FlexTableLayoutPosition.bottom(),
//               //     child:
//               //         TableBottomBar(tableModel: tableModel, maxWidthSlider: 200.0))
//             ],
//           )));
//   }
// }

// class HypotheekTable {
//   final data = DataFlexTableCR();
//   final df = DateFormat('dd-MM-yyyy');
//   final nf = NumberFormat('###', 'nl_NL');
//   final autoFreezeAreasX = <AutoFreezeArea>[];
//   final autoFreezeAreasY = <AutoFreezeArea>[];
//   List<PropertiesRange> specificWidth = [];

//   int rowStartLayout = 0;
//   int columnStartLayout = 0;
//   int layoutRows = 0;
//   int layoutColumns = 0;

//   HypotheekTable({this.rowStartLayout = 0, this.columnStartLayout = 0});

//   makeTable(
//       {required _HypotheekTabelGegevens gegevens,
//       Color headerColor = Colors.white,
//       Color bc1 = Colors.white,
//       Color bc2 = Colors.white,
//       Color lineColor = Colors.white,
//       double lineWidth = 0.5}) {
//     int column = columnStartLayout;
//     int columnStart = column;
//     int row = rowStartLayout;
//     int rowStart = row;

//     final headerAttr = {
//       'background': headerColor,
//       'textStyle': TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       'alignment': Alignment.bottomCenter
//     };

//     data.addCell(
//         row: row,
//         column: column++,
//         rows: 2,
//         cell: Cell(value: 'Datum', attr: headerAttr));

//     data.addCell(
//       row: row,
//       column: column++,
//       rows: 2,
//       cell: Cell(value: 'Lening', attr: headerAttr),
//     );

//     data.addCell(
//         row: row,
//         column: columnStart + 2,
//         columns: 2,
//         cell: Cell(value: 'Per maand', attr: headerAttr));

//     data.addCell(
//         row: row,
//         column: columnStart + 4,
//         columns: 2,
//         cell: Cell(value: 'Per jaar', attr: headerAttr));

//     row++;

//     data.addCell(
//         row: row,
//         column: column++,
//         cell: Cell(value: 'Rente', attr: headerAttr));

//     data.addCell(
//         row: row,
//         column: column++,
//         cell: Cell(value: 'Aflossen', attr: headerAttr));
//     data.addCell(
//         row: row,
//         column: column++,
//         cell: Cell(value: 'Rente', attr: headerAttr));
//     data.addCell(
//         row: row,
//         column: column++,
//         cell: Cell(value: 'Aflossen', attr: headerAttr));
//     // data.addCell(
//     //     row: row,
//     //     column: column++,
//     //     cell: Cell(value: 'Teruggave', attr: headerAttr));
//     // data.addCell(
//     //     row: row,
//     //     column: column++,
//     //     cell: Cell(
//     //         value: 'Netto', attr: {'background': rowColor}));
//     // data.addCell(
//     //     row: row,
//     //     column: column++,
//     //     cell: Cell(
//     //         value: 'N. e/m', attr: {'background': rowColor}));

//     final termijnen = gegevens.termijnen;
//     final length = termijnen.length;
//     int huidigeJaar = 0;
//     int jaarRow = 0;
//     double jaarRente = 0.0;
//     double jaarAflossen = 0.0;

//     row++;

//     for (int i = 0; i < length; i++) {
//       Termijn t = termijnen[i];
//       final jaar = t.startDatum.year;
//       final mndRente = t.maandRenteBedragRatio;
//       final mndAflossen = t.aflossen + t.extraAflossen;
//       Color rowColor = row % 2 == 0 ? bc2 : bc1;

//       column = columnStart;
//       data.addCell(
//           row: row,
//           column: column++,
//           cell: Cell(
//               value: df.format(t.startDatum), attr: {'background': rowColor}));
//       data.addCell(
//           row: row,
//           column: column++,
//           cell:
//               Cell(value: nf.format(t.lening), attr: {'background': rowColor}));
//       data.addCell(
//           row: row,
//           column: column++,
//           cell: Cell(
//               value: nf.format(mndAflossen), attr: {'background': rowColor}));

//       data.addCell(
//           row: row,
//           column: column++,
//           cell: Cell(
//               value: nf.format(t.maandRenteBedragRatio),
//               attr: {'background': rowColor}));

//       if (i == 0) {
//         huidigeJaar = jaar;
//         jaarRow = row;
//       }

//       if (i == length - 1) {
//         jaarRente += mndRente;
//         jaarAflossen += mndAflossen;

//         int deltaRow = row - jaarRow + 1;

//         //Jaar Rente

//         Color yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

//         data.addCell(
//             row: jaarRow,
//             column: column++,
//             rows: deltaRow,
//             cell: Cell(
//                 value: nf.format(jaarRente),
//                 attr: {'background': yearColorBlock}));

//         //Jaar aflossen

//         yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

//         data.addCell(
//             row: jaarRow,
//             column: column++,
//             rows: deltaRow,
//             cell: Cell(
//                 value: nf.format(jaarAflossen),
//                 attr: {'background': yearColorBlock}));
//       } else if (jaar > huidigeJaar) {
//         int deltaRow = row - jaarRow;

//         //Jaar Rente

//         Color yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

//         data.addCell(
//             row: jaarRow,
//             column: column++,
//             rows: deltaRow,
//             cell: Cell(
//                 value: nf.format(jaarRente),
//                 attr: {'background': yearColorBlock}));

//         //Jaar aflossen

//         yearColorBlock = (huidigeJaar + column) % 2 == 0 ? bc1 : bc2;

//         data.addCell(
//             row: jaarRow,
//             column: column++,
//             rows: deltaRow,
//             cell: Cell(
//                 value: nf.format(jaarAflossen),
//                 attr: {'background': yearColorBlock}));

//         huidigeJaar = jaar;
//         jaarRow = row;
//         jaarRente = mndRente;
//         jaarAflossen = mndAflossen;
//       } else {
//         jaarRente += mndRente;
//         jaarAflossen += mndAflossen;
//       }
//       row++;
//     }

//     addFreeze(
//         autoFreezeAuto: autoFreezeAreasX,
//         start: columnStart,
//         freeze: columnStart + 1,
//         end: column);

//     addFreeze(
//         autoFreezeAuto: autoFreezeAreasY,
//         start: rowStart,
//         freeze: rowStart + 2,
//         end: row);

//     specificWidth.addAll([
//       PropertiesRange(min: columnStart, max: columnStart, length: 95.0),
//       PropertiesRange(min: columnStart + 2, max: columnStart + 2, length: 60.0),
//       PropertiesRange(min: columnStart + 4, max: columnStart + 4, length: 60.0),
//     ]);

//     final h = data.horizontalLineList;

//     LineNodeList horizontalLine(
//             int startColumn, int endColumn, Color lineColor) =>
//         h.createLineNodeList(
//             startLevelTwoIndex: startColumn,
//             lineNode: LineNode(
//                 left: Line.noLine(),
//                 right: Line(width: lineWidth, color: lineColor)))
//           ..addLineNode(
//               startLevelTwoIndex: endColumn,
//               lineNode: LineNode(
//                   left: Line(width: lineWidth, color: lineColor),
//                   right: Line.noLine()));

//     h
//       ..addList(
//           startLevelOneIndex: rowStart,
//           lineList: horizontalLine(columnStart, column, lineColor))
//       ..addList(
//           startLevelOneIndex: rowStart + 1,
//           lineList: horizontalLine(columnStart + 2, column, lineColor))
//       ..addList(
//           startLevelOneIndex: rowStart + 2,
//           lineList: horizontalLine(
//               columnStart, column, Color.fromARGB(255, 13, 131, 190)))
//       ..addList(
//           startLevelOneIndex: row,
//           lineList: horizontalLine(
//               columnStart, column, Color.fromARGB(255, 13, 131, 190)));

//     final v = data.verticalLineList;

//     LineNodeList verticalLine(int startRow, int endRow, Color lineColor) =>
//         v.createLineNodeList(
//             startLevelTwoIndex: startRow,
//             lineNode: LineNode(
//                 top: Line.noLine(),
//                 bottom: Line(width: lineWidth, color: lineColor)))
//           ..addLineNode(
//               startLevelTwoIndex: endRow,
//               lineNode: LineNode(
//                   top: Line(width: lineWidth, color: lineColor),
//                   bottom: Line.noLine()));

//     v
//       ..addList(
//           startLevelOneIndex: columnStart,
//           endLevelOneIndex: columnStart + 2,
//           lineList: verticalLine(rowStart, row, lineColor))
//       ..addList(
//           startLevelOneIndex: columnStart + 3,
//           lineList: verticalLine(rowStart + 1, row, lineColor))
//       ..addList(
//           startLevelOneIndex: columnStart + 4,
//           lineList: verticalLine(rowStart, row, lineColor))
//       ..addList(
//           startLevelOneIndex: columnStart + 5,
//           lineList: verticalLine(rowStart + 1, row, lineColor))
//       ..addList(
//           startLevelOneIndex: columnStart + 6,
//           endLevelOneIndex: column,
//           lineList: verticalLine(rowStart, row, lineColor));

//     if (layoutRows < row + 1) {
//       layoutRows = row + 1;
//     }

//     if (layoutColumns < column + 1) {
//       layoutColumns = column + 1;
//     }
//   }

//   void addFreeze(
//       {required List<AutoFreezeArea> autoFreezeAuto,
//       required int start,
//       required int freeze,
//       required int end}) {
//     if (!autoFreezeAuto.contains((AutoFreezeArea freeze) {
//       if (freeze.startIndex == start) {
//         if (freeze.endIndex < end) {
//           freeze.endIndex = end;
//         }
//         return true;
//       }
//       return false;
//     })) {
//       autoFreezeAuto.add(AutoFreezeArea(
//           startIndex: start,
//           freezeIndex: freeze,
//           endIndex: end,
//           customSplitSize: 0.5));
//     }
//   }

//   tableModel({
//     TargetPlatform? platform,
//     scrollLockX: true,
//     scrollLockY: true,
//     autoFreezeListX = false,
//     autoFreezeListY = false,
//   }) {
//     double minTableScale = 0.5;
//     double maxTableScale = 3.0;
//     double tableScale = 1.0;

//     if (platform != null) {
//       switch (platform) {
//         case TargetPlatform.iOS:
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//           break;
//         case TargetPlatform.macOS:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           minTableScale = 1.0;
//           tableScale = 1.5;
//           maxTableScale = 4.0;
//           break;
//       }
//     }

//     return TableModel(
//         stateSplitX: SplitState.NO_SPLITE,
//         stateSplitY: SplitState.NO_SPLITE,
//         columnHeader: false,
//         rowHeader: false,
//         scrollLockX: scrollLockX,
//         scrollLockY: scrollLockY,
//         specificWidth: specificWidth,
//         defaultWidthCell: 70.0,
//         defaultHeightCell: 25.0,
//         maximumColumns: layoutColumns,
//         maximumRows: layoutRows,
//         dataTable: data,
//         panelMargin: 2.0,
//         autoFreezeAreasX: autoFreezeAreasX,
//         autoFreezeAreasY: autoFreezeAreasY,
//         scale: tableScale,
//         minTableScale: minTableScale,
//         maxTableScale: maxTableScale);
//   }
// }
