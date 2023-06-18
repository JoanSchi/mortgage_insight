import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SummaryPieLayout extends MultiChildRenderObjectWidget {
  final double innerPadding;
  final double innerLegendPadding;

  const SummaryPieLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    this.innerPadding = 12.0,
    this.innerLegendPadding = 4.0,
  }) : super(key: key, children: children);

  @override
  RenderSummaryPieLayout createRenderObject(BuildContext context) {
    return RenderSummaryPieLayout(
        innerPadding: innerPadding, innerLegendPadding: innerLegendPadding);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSummaryPieLayout renderObject) {
    renderObject
      ..innerPadding = innerPadding
      ..innerLegendPadding = innerLegendPadding;
  }
}

enum SummaryPieID {
  summary,
  pie,
  legendItem,
}

class SummaryPieDataWidget extends ParentDataWidget<SummaryPieParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const SummaryPieDataWidget({
    Key? key,
    this.id = SummaryPieID.summary,
    required Widget child,
  }) : super(key: key, child: child);

  final SummaryPieID id;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is SummaryPieParentData);
    final SummaryPieParentData parentData =
        renderObject.parentData! as SummaryPieParentData;
    bool needsLayout = false;

    if (parentData.id != id) {
      parentData.id = id;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => SummaryPieLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('id', id));
  }
}

class SummaryPieParentData extends ContainerBoxParentData<RenderBox> {
  SummaryPieID id = SummaryPieID.summary;

  @override
  String toString() => '${super.toString()}; id=$id';
}

class RenderSummaryPieLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, SummaryPieParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, SummaryPieParentData> {
  double _innerPadding;
  double _innerLegendPadding;

  RenderSummaryPieLayout({
    List<RenderBox>? children,
    required double innerPadding,
    required double innerLegendPadding,
  })  : _innerPadding = innerPadding,
        _innerLegendPadding = innerLegendPadding {
    addAll(children);
  }

  set innerPadding(double value) {
    if (value != _innerPadding) {
      _innerPadding = value;
      markNeedsLayout();
    }
  }

  double get innerPadding => _innerPadding;

  set innerLegendPadding(double value) {
    if (value != _innerLegendPadding) {
      _innerLegendPadding = value;
      markNeedsLayout();
    }
  }

  double get innerLegendPadding => _innerLegendPadding;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SummaryPieParentData) {
      child.parentData = SummaryPieParentData();
    }
  }

  @override
  void performLayout() {
    double x = 0.0;
    double y = 0.0;
    double width = constraints.maxWidth;
    double height = 0.0;
    double summaryWidth = 0.0;
    double summaryHeight = 0.0;
    double pieWidth = 0.0;
    double pieHeight = 0.0;
    double maxLegendItemWidth = 0.0;
    double maxLegendItemHeight = 0.0;
    List<Size> legendItemList = <Size>[];

    RenderBox? child = firstChild;

    while (child != null) {
      final SummaryPieParentData childParentData =
          child.parentData! as SummaryPieParentData;

      switch (childParentData.id) {
        case SummaryPieID.summary:
          {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
                parentUsesSize: true);

            summaryWidth = child.size.width;
            summaryHeight = child.size.height;

            break;
          }
        case SummaryPieID.pie:
          {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
                parentUsesSize: true);

            pieWidth = child.size.width;
            pieHeight = child.size.height;

            break;
          }
        case SummaryPieID.legendItem:
          {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
                parentUsesSize: true);

            if (child.size.width > maxLegendItemWidth) {
              maxLegendItemWidth = child.size.width;
            }

            Size size = child.size;
            legendItemList.add(size);

            if (size.height > maxLegendItemHeight) {
              maxLegendItemHeight = size.height;
            }

            break;
          }
      }

      child = childParentData.nextSibling;
    }

    final summaryWidthInnerPadding =
        summaryWidth == 0.0 ? 0.0 : summaryWidth + innerPadding;

    if (width / 2.0 - pieWidth / 2.0 - summaryWidthInnerPadding > 0.0 &&
        width / 2.0 - pieWidth / 2.0 - maxLegendItemWidth - innerPadding >
            0.0) {
      RenderBox? child = firstChild;

      height = math.max(summaryHeight, pieHeight);

      double legendHeight = legendItemList.fold(
              0.0,
              (double previousValue, Size element) =>
                  previousValue + element.height) +
          (legendItemList.length - 1) * innerLegendPadding;

      double yLegend = (height - legendHeight) / 2.0;
      double x = width / 2.0 - pieWidth / 2.0 - summaryWidthInnerPadding;

      int legendCount = 0;

      while (child != null) {
        final SummaryPieParentData childParentData =
            child.parentData! as SummaryPieParentData;

        switch (childParentData.id) {
          case SummaryPieID.summary:
            childParentData.offset = Offset(x, (height - summaryHeight) / 2.0);
            x += summaryWidth + innerPadding;
            break;
          case SummaryPieID.pie:
            childParentData.offset = Offset(x, (height - pieHeight) / 2.0);
            x += pieWidth + innerPadding;
            break;
          case SummaryPieID.legendItem:
            childParentData.offset = Offset(x, yLegend);
            yLegend +=
                legendItemList[legendCount++].height + innerLegendPadding;
            break;
        }

        child = childParentData.nextSibling;
      }
    } else {
      RenderBox? child = firstChild;

      final lw =
          calculateRowsLegend(sizes: legendItemList, availibleWith: width);

      height = summaryHeight +
          (summaryHeight == 0.0 ? 0.0 : innerPadding) +
          pieHeight +
          innerPadding +
          lw.height;
      y = 0.0;

      int i = 0;

      while (child != null) {
        final SummaryPieParentData childParentData =
            child.parentData! as SummaryPieParentData;

        switch (childParentData.id) {
          case SummaryPieID.summary:
            childParentData.offset = Offset((width - summaryWidth) / 2.0, y);
            y += summaryHeight + innerPadding;
            break;
          case SummaryPieID.pie:
            childParentData.offset = Offset((width - pieWidth) / 2.0, y);
            y += pieHeight + innerPadding;
            break;
          case SummaryPieID.legendItem:
            x = lw.getX(i, 0, LegendAxis.center);
            y = lw.getY(i, height - lw.height, LegendAxis.start);
            i++;
            childParentData.offset = Offset(x, y);
            break;
        }

        child = childParentData.nextSibling;
      }
    }

    size = Size(width, height);
  }

  LegendWrap calculateRowsLegend(
      {required List<Size> sizes, required double availibleWith}) {
    LegendWrap l = LegendWrap(width: availibleWith);

    LegendRange legendRow = LegendRange();

    double legendHeight = 0.0;

    for (Size s in sizes) {
      if (s.width > availibleWith - legendRow.width && legendRow.count != 0) {
        legendHeight += legendRow.height;
        legendRow = LegendRange();
      }

      l.list.add(LegendRowItem(
          legendRange: legendRow, x: legendRow.width, y: legendHeight));
      legendRow.addRow(s);
    }
    legendHeight += legendRow.height;

    l.height = legendHeight;

    return l;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

class LegendWrap {
  double height;
  double width;

  List<LegendRowItem> list;

  LegendWrap({this.width = 0.0, this.height = 0.0, LegendRowItem? item})
      : list = item == null ? [] : [item];

  getX(int i, double start, LegendAxis axis) {
    return list[i].getX(start, width, axis);
  }

  getY(int i, double start, LegendAxis axis) {
    return list[i].getY(start, height, axis);
  }
}

enum LegendAxis { start, center }

class LegendRowItem {
  LegendRange legendRange;
  double x;
  double y;
  bool row;

  LegendRowItem({
    required this.legendRange,
    required this.x,
    required this.y,
    this.row = true,
  });

  getX(double start, double width, LegendAxis axis) {
    switch (axis) {
      case LegendAxis.start:
        return start + x;
      case LegendAxis.center:
        return start + (width - legendRange.width) / 2.0 + x;
    }
  }

  getY(double start, double height, LegendAxis axis) {
    switch (axis) {
      case LegendAxis.start:
        return start + y;
      case LegendAxis.center:
        return start + (height - legendRange.height) / 2.0 + y;
    }
  }
}

class LegendRange {
  double width;
  double height;
  int count;

  LegendRange({
    Size size = Size.zero,
    this.count = 0,
  })  : width = size.width,
        height = size.height;

  void addRow(Size size) {
    width += size.width;
    if (height < size.height) {
      height = size.height;
    }
    count++;
  }

  void addColumn(Size size) {
    height += size.height;
    if (width < size.width) {
      width = size.width;
    }
    count++;
  }
}
