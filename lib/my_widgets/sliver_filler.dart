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

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SliverFiller extends SingleChildRenderObjectWidget {
  final double itemExtent;
  final int itemCount;
  final double offset;
  const SliverFiller({
    super.key,
    super.child,
    this.offset = 0.0,
    required this.itemCount,
    required this.itemExtent,
  });

  @override
  RenderSliverFillRemaining createRenderObject(BuildContext context) =>
      RenderSliverFillRemaining(
          offset: offset, itemCount: itemCount, itemExtent: itemExtent);

  @override
  void updateRenderObject(
      BuildContext context, RenderSliverFillRemaining renderObject) {
    renderObject
      ..offset = offset
      ..itemCount = itemCount
      ..itemExtent = itemExtent;
  }
}

class RenderSliverFillRemaining extends RenderSliverSingleBoxAdapter {
  RenderSliverFillRemaining(
      {super.child,
      required double offset,
      required double itemExtent,
      required int itemCount})
      : _offset = offset,
        _itemCount = itemCount,
        _itemExtent = itemExtent;

  int _itemCount;

  int get itemCount => _itemCount;

  set itemCount(int value) {
    if (value != _itemCount) {
      _itemCount = value;
      markNeedsLayout();
    }
  }

  double _itemExtent;

  double get itemExtent => _itemExtent;

  set itemExtent(double value) {
    if (value != _itemExtent) {
      _itemExtent = value;
      markNeedsLayout();
    }
  }

  double _offset;

  double get offset => _offset;

  set offset(double value) {
    if (value != _offset) {
      _offset = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final SliverConstraints constraints = this.constraints;

    // Origineel: double extent = (constraints.viewportMainAxisExtent -
    //          constraints.precedingScrollExtent

    double extent = offset +
        (constraints.remainingPaintExtent - itemCount * itemExtent) / 2.0;

    if (extent < 0.0) {
      extent = 0.0;
    }

    if (child != null) {
      child!.layout(constraints.asBoxConstraints(
        minExtent: extent,
        maxExtent: extent,
      ));
    }

    assert(
      extent.isFinite,
      'The calculated extent for the child of SliverFillRemaining is not finite. '
      'This can happen if the child is a scrollable, in which case, the '
      'hasScrollBody property of SliverFillRemaining should not be set to '
      'false.',
    );
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: extent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    if (child != null) {
      setChildParentData(child!, constraints, geometry!);
    }
  }
}
