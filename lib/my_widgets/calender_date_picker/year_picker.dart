import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mortgage_insight/my_widgets/calender_date_picker/month_year_picker.dart';

// const int _yearPickerColumnCount = 3;
const double _yearPickerPadding = 16.0;
const double _yearPickerRowSpacing = 8.0;

class MyYearPicker extends StatefulWidget {
  final DateTime currentDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final DragStartBehavior dragStartBehavior;
  final PickerLayout pickerLayout;

  MyYearPicker({
    Key? key,
    DateTime? currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    required this.pickerLayout,
  })  : assert(!firstDate.isAfter(lastDate)),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        super(key: key);

  @override
  State<MyYearPicker> createState() => _YearPickerState();

  static calculateHeightAndRows(
      {required double availibleHeight,
      required DateTime firstDate,
      required DateTime lastDate}) {
    int columns;
    double height;

    final pages = ((lastDate.year - firstDate.year + 1) * heightPickerItem) /
        availibleHeight;
    if (pages >= 3.0) {
      columns = 3;
      height = (lastDate.year - firstDate.year + 1) ~/ 3 * heightPickerItem;
    } else if (pages >= 2.0) {
      columns = 2;
      height = (lastDate.year - firstDate.year + 1) ~/ 2 * heightPickerItem;
    } else {
      columns = 1;
      height = (lastDate.year - firstDate.year + 1) * heightPickerItem;
    }

    return PickerLayout(
        columns: columns, height: math.min(height, availibleHeight));
  }
}

class _YearPickerState extends State<MyYearPicker> {
  late ScrollController _scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 12;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
        initialScrollOffset: _scrollOffsetForYear(widget.selectedDate));
  }

  @override
  void didUpdateWidget(MyYearPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      // _scrollController.jumpTo(_scrollOffsetForYear(widget.selectedDate));
    }
  }

  double _scrollOffsetForYear(DateTime date) {
    // Move the offset down by 2 rows to approximately center it.

    final int firstYear = widget.firstDate.year -
        (_itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0);

    final int initialYearIndex = date.year - firstYear;
    final int initialYearRow = initialYearIndex ~/ widget.pickerLayout.columns;

    double totalHeight = (_itemCount < minYears ? minYears : _itemCount) ~/
        widget.pickerLayout.columns *
        heightPickerItem;

    int i = initialYearRow;
    if (i == 2) {
      i--;
    } else if (i > 2) {
      i -= 2;
    }

    if (widget.pickerLayout.height < totalHeight - i * heightPickerItem) {
      return i * heightPickerItem;
    } else {
      return math.max(0.0, totalHeight - widget.pickerLayout.height);
    }
  }

  Widget _buildYearItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears
        ? (minYears - _itemCount) ~/ widget.pickerLayout.columns
        : 0;
    final int year = widget.firstDate.year + index - offset;
    final bool isSelected = year == widget.selectedDate.year;
    final bool isCurrentYear = year == widget.currentDate.year;
    final bool isDisabled =
        year < widget.firstDate.year || year > widget.lastDate.year;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    final Color textColor;
    if (isSelected) {
      textColor = colorScheme.onPrimary;
    } else if (isDisabled) {
      textColor = colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentYear) {
      textColor = colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface.withOpacity(0.87);
    }
    final TextStyle? itemStyle = textTheme.bodyText2?.apply(color: textColor);

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(8.0),
      );
    } else if (isCurrentYear && !isDisabled) {
      decoration = BoxDecoration(
        border: Border.all(
          color: colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(8.0),
      );
    }

    Widget yearItem = Center(
      child: Container(
        decoration: decoration,
        height: decorationHeight,
        width: decorationWidth,
        child: Center(
          child: Semantics(
            selected: isSelected,
            child: Text(year.toString(), style: itemStyle),
          ),
        ),
      ),
    );

    if (isDisabled) {
      yearItem = ExcludeSemantics(
        child: yearItem,
      );
    } else {
      yearItem = InkWell(
        key: ValueKey<int>(year),
        onTap: () =>
            widget.onChanged(DateTime(year, widget.selectedDate.month)),
        child: yearItem,
        borderRadius: BorderRadius.circular(8.0),
      );
    }

    return yearItem;
  }

  int get _itemCount {
    return widget.lastDate.year - widget.firstDate.year + 1;
  }

  @override
  Widget build(BuildContext context) {
    // Widget yearList = 1 < widget.pickerLayout.columns
    //     ?
    Widget yearList = GridView.builder(
      controller: _scrollController,
      dragStartBehavior: widget.dragStartBehavior,
      gridDelegate: _YearPickerGridDelegate(widget.pickerLayout.columns),
      itemBuilder: _buildYearItem,
      itemCount: math.max(_itemCount, minYears),
      padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
    );
    // : Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //     child: ListView.builder(
    //       controller: _scrollController,
    //       itemBuilder: _buildYearItem,
    //       itemCount: math.max(_itemCount, minYears),
    //     ),
    //   );

    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        const Divider(
          height: dividerHeight,
        ),
        Expanded(
          child: yearList,
        ),
        const Divider(
          height: dividerHeight,
        ),
      ],
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  int columnCount;

  _YearPickerGridDelegate(this.columnCount);

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth =
        (constraints.crossAxisExtent - (columnCount) * _yearPickerRowSpacing) /
            columnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: heightPickerItem,
      crossAxisCount: columnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: heightPickerItem,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}
