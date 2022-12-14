import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class MyFlex extends MultiChildRenderObjectWidget {
  MyFlex({
    Key? key,
    required this.direction,
    List<Widget> children = const <Widget>[],
  }) : super(key: key, children: children);

  final Axis direction;

  @override
  MyRenderFlex createRenderObject(BuildContext context) {
    return MyRenderFlex(
      direction: direction,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MyRenderFlex renderObject) {
    renderObject..direction = direction;
  }
}

enum MyFlexFit {
  tight,
  fill,
}

class MyFlexible extends ParentDataWidget<MyFlexParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const MyFlexible({
    Key? key,
    this.fit = MyFlexFit.tight,
    required Widget child,
  }) : super(key: key, child: child);

  final MyFlexFit fit;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is MyFlexParentData);
    final MyFlexParentData parentData =
        renderObject.parentData! as MyFlexParentData;
    bool needsLayout = false;

    if (parentData.fit != fit) {
      parentData.fit = fit;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => Flex;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('flex', fit));
  }
}

typedef _ChildSizingFunction = double Function(RenderBox child, double extent);

class MyFlexParentData extends ContainerBoxParentData<RenderBox> {
  MyFlexFit fit = MyFlexFit.tight;

  @override
  String toString() => '${super.toString()}; fit=$fit';
}

class MyRenderFlex extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MyFlexParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MyFlexParentData> {
  /// Creates a flex render object.
  ///
  /// By default, the flex layout is horizontal and children are aligned to the
  /// start of the main axis and the center of the cross axis.
  MyRenderFlex({
    List<RenderBox>? children,
    Axis direction = Axis.horizontal,
  }) : _direction = direction {
    addAll(children);
  }

  /// The direction to use as the main axis.
  Axis get direction => _direction;
  Axis _direction;
  set direction(Axis value) {
    if (_direction != value) {
      _direction = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MyFlexParentData)
      child.parentData = MyFlexParentData();
  }

  double _getIntrinsicSize({
    required Axis sizingDirection,
    required double
        extent, // the extent in the direction that isn't the sizing direction
    required _ChildSizingFunction
        childSize, // a method to find the size in the sizing direction
  }) {
    if (_direction == sizingDirection) {
      double length = 0.0;
      RenderBox? child = firstChild;

      while (child != null) {
        length += childSize(child, extent);
        final MyFlexParentData childParentData =
            child.parentData! as MyFlexParentData;
        child = childParentData.nextSibling;
      }
      return length;
    } else {
      RenderBox? child = firstChild;
      double length = 0.0;

      while (child != null) {
        double crossSize = childSize(child, extent);

        if (length < crossSize) {
          length = crossSize;
        }

        final MyFlexParentData childParentData =
            child.parentData! as MyFlexParentData;
        child = childParentData.nextSibling;
      }

      return length;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicWidth(extent),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _getIntrinsicSize(
      sizingDirection: Axis.horizontal,
      extent: height,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicWidth(extent),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMinIntrinsicHeight(extent),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _getIntrinsicSize(
      sizingDirection: Axis.vertical,
      extent: width,
      childSize: (RenderBox child, double extent) =>
          child.getMaxIntrinsicHeight(extent),
    );
  }

  // _LayoutSize _computeSizes(
  //     {required BoxConstraints constraints,
  //     required ChildLayouter layoutChild}) {
  //   RenderBox? child = firstChild;

  //   double length = 0.0;
  //   double crossLength = 0.0;
  //   double lengthTight = 0.0;
  //   int fillNumber = 0;

  //   while (child != null) {
  //     Size size = layoutChild(child, BoxConstraints.tight(Size(200, 200)));

  //     final MyFlexParentData childParentData =
  //         child.parentData! as MyFlexParentData;
  //     child = childParentData.nextSibling;

  //     double childLength = 0.0;

  //     if (_direction == Axis.vertical) {
  //       childLength = size.height;

  //       if (crossLength < size.width) {
  //         crossLength = size.width;
  //       }
  //     } else {
  //       childLength = size.width;

  //       if (crossLength < size.height) {
  //         crossLength = size.height;
  //       }
  //     }

  //     length += childLength;

  //     if (childParentData.fit == MyFlexFit.fill) {
  //       fillNumber++;
  //     } else {
  //       lengthTight += childLength;
  //     }

  //     child = childParentData.nextSibling;
  //   }

  //   return _LayoutSize(
  //       length: length,
  //       crossLength: crossLength,
  //       lengthTight: lengthTight,
  //       fillNumber: fillNumber);
  // }

  // @override
  // Size computeDryLayout(BoxConstraints constraints) {
  //   final sizes = _computeSizes(
  //     layoutChild: ChildLayoutHelper.dryLayoutChild,
  //     constraints: constraints,
  //   );

  //   switch (_direction) {
  //     case Axis.horizontal:
  //       return Size(
  //           constraints.constrainWidth(sizes.length), sizes.crossLength);
  //     case Axis.vertical:
  //       return Size(
  //           sizes.crossLength, constraints.constrainHeight(sizes.length));
  //   }
  // }

  @override
  void performLayout() {
    // _LayoutSize sizes = _computeSizes(
    //   layoutChild: ChildLayoutHelper.dryLayoutChild,
    //   constraints: constraints,
    // );

    double x = 0.0;
    double y = 0.0;
    double height;
    double width;

    switch (_direction) {
      case Axis.horizontal:
        RenderBox? child = firstChild;
        height = constraints.maxHeight;
        width = 0.0;

        while (child != null) {
          final MyFlexParentData childParentData =
              child.parentData! as MyFlexParentData;

          if (childParentData.fit == MyFlexFit.tight) {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  minHeight: height,
                  maxHeight: height,
                ),
                parentUsesSize: true);

            width += child.size.width;
          }

          child = childParentData.nextSibling;
        }

        child = firstChild;

        while (child != null) {
          final MyFlexParentData childParentData =
              child.parentData! as MyFlexParentData;

          if (childParentData.fit == MyFlexFit.fill) {
            child.layout(
                BoxConstraints(
                    maxWidth: math.max(0.0, constraints.maxWidth - width),
                    maxHeight: height),
                parentUsesSize: true);

            width += child.size.width;
            height = child.size.height;
          }

          child = childParentData.nextSibling;
        }

        child = firstChild;

        while (child != null) {
          final MyFlexParentData childParentData =
              child.parentData! as MyFlexParentData;

          if (childParentData.fit == MyFlexFit.tight) {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                  minHeight: height,
                  maxHeight: height,
                ),
                parentUsesSize: true);
          }

          childParentData.offset = Offset(x, y);
          x += child.size.width;

          child = childParentData.nextSibling;
        }

        break;
      case Axis.vertical:
        {
          RenderBox? child = firstChild;
          height = 0.0;
          width = constraints.maxWidth;

          while (child != null) {
            final MyFlexParentData childParentData =
                child.parentData! as MyFlexParentData;

            if (childParentData.fit == MyFlexFit.tight) {
              child.layout(
                  constraints.tighten(
                    width: width,
                  ),
                  parentUsesSize: true);

              height += child.size.height;
            }

            child = childParentData.nextSibling;
          }

          child = firstChild;

          while (child != null) {
            final MyFlexParentData childParentData =
                child.parentData! as MyFlexParentData;

            if (childParentData.fit == MyFlexFit.fill) {
              child.layout(
                  BoxConstraints(
                    maxWidth: width,
                    maxHeight: math.max(0.0, constraints.maxHeight - height),
                  ),
                  parentUsesSize: true);

              height += child.size.height;
            }

            child = childParentData.nextSibling;
          }

          child = firstChild;

          while (child != null) {
            final MyFlexParentData childParentData =
                child.parentData! as MyFlexParentData;

            childParentData.offset = Offset(x, y);
            y += child.size.height;

            child = childParentData.nextSibling;
          }
        }
    }
    size = Size(width, height);

    // final double allocatedSize = sizes.allocatedSize;
    // double actualSize = sizes.mainSize;
    // double crossSize = sizes.crossSize;
    // double maxBaselineDistance = 0.0;
    // if (crossAxisAlignment == CrossAxisAlignment.baseline) {
    //   RenderBox? child = firstChild;
    //   double maxSizeAboveBaseline = 0;
    //   double maxSizeBelowBaseline = 0;
    //   while (child != null) {
    //     assert(() {
    //       if (textBaseline == null)
    //         throw FlutterError(
    //             'To use FlexAlignItems.baseline, you must also specify which baseline to use using the "baseline" argument.');
    //       return true;
    //     }());
    //     final double? distance =
    //         child.getDistanceToBaseline(textBaseline!, onlyReal: true);
    //     if (distance != null) {
    //       maxBaselineDistance = math.max(maxBaselineDistance, distance);
    //       maxSizeAboveBaseline = math.max(
    //         distance,
    //         maxSizeAboveBaseline,
    //       );
    //       maxSizeBelowBaseline = math.max(
    //         child.size.height - distance,
    //         maxSizeBelowBaseline,
    //       );
    //       crossSize =
    //           math.max(maxSizeAboveBaseline + maxSizeBelowBaseline, crossSize);
    //     }
    //     final FlexParentData childParentData =
    //         child.parentData! as FlexParentData;
    //     child = childParentData.nextSibling;
    //   }
    // }

    // // Align items along the main axis.
    // switch (_direction) {
    //   case Axis.horizontal:
    //     size = constraints.constrain(Size(actualSize, crossSize));
    //     actualSize = size.width;
    //     crossSize = size.height;
    //     break;
    //   case Axis.vertical:
    //     size = constraints.constrain(Size(crossSize, actualSize));
    //     actualSize = size.height;
    //     crossSize = size.width;
    //     break;
    // }
    // final double actualSizeDelta = actualSize - allocatedSize;
    // _overflow = math.max(0.0, -actualSizeDelta);
    // final double remainingSpace = math.max(0.0, actualSizeDelta);
    // late final double leadingSpace;
    // late final double betweenSpace;
    // // flipMainAxis is used to decide whether to lay out left-to-right/top-to-bottom (false), or
    // // right-to-left/bottom-to-top (true). The _startIsTopLeft will return null if there's only
    // // one child and the relevant direction is null, in which case we arbitrarily decide not to
    // // flip, but that doesn't have any detectable effect.
    // final bool flipMainAxis =
    //     !(_startIsTopLeft(direction, textDirection, verticalDirection) ?? true);
    // switch (_mainAxisAlignment) {
    //   case MainAxisAlignment.start:
    //     leadingSpace = 0.0;
    //     betweenSpace = 0.0;
    //     break;
    //   case MainAxisAlignment.end:
    //     leadingSpace = remainingSpace;
    //     betweenSpace = 0.0;
    //     break;
    //   case MainAxisAlignment.center:
    //     leadingSpace = remainingSpace / 2.0;
    //     betweenSpace = 0.0;
    //     break;
    //   case MainAxisAlignment.spaceBetween:
    //     leadingSpace = 0.0;
    //     betweenSpace = childCount > 1 ? remainingSpace / (childCount - 1) : 0.0;
    //     break;
    //   case MainAxisAlignment.spaceAround:
    //     betweenSpace = childCount > 0 ? remainingSpace / childCount : 0.0;
    //     leadingSpace = betweenSpace / 2.0;
    //     break;
    //   case MainAxisAlignment.spaceEvenly:
    //     betweenSpace = childCount > 0 ? remainingSpace / (childCount + 1) : 0.0;
    //     leadingSpace = betweenSpace;
    //     break;
    // }

    // // Position elements
    // double childMainPosition =
    //     flipMainAxis ? actualSize - leadingSpace : leadingSpace;
    // RenderBox? child = firstChild;
    // while (child != null) {
    //   final FlexParentData childParentData =
    //       child.parentData! as FlexParentData;
    //   final double childCrossPosition;
    //   switch (_crossAxisAlignment) {
    //     case CrossAxisAlignment.start:
    //     case CrossAxisAlignment.end:
    //       childCrossPosition = _startIsTopLeft(
    //                   flipAxis(direction), textDirection, verticalDirection) ==
    //               (_crossAxisAlignment == CrossAxisAlignment.start)
    //           ? 0.0
    //           : crossSize - _getCrossSize(child.size);
    //       break;
    //     case CrossAxisAlignment.center:
    //       childCrossPosition =
    //           crossSize / 2.0 - _getCrossSize(child.size) / 2.0;
    //       break;
    //     case CrossAxisAlignment.stretch:
    //       childCrossPosition = 0.0;
    //       break;
    //     case CrossAxisAlignment.baseline:
    //       if (_direction == Axis.horizontal) {
    //         assert(textBaseline != null);
    //         final double? distance =
    //             child.getDistanceToBaseline(textBaseline!, onlyReal: true);
    //         if (distance != null)
    //           childCrossPosition = maxBaselineDistance - distance;
    //         else
    //           childCrossPosition = 0.0;
    //       } else {
    //         childCrossPosition = 0.0;
    //       }
    //       break;
    //   }
    //   if (flipMainAxis) childMainPosition -= _getMainSize(child.size);
    //   switch (_direction) {
    //     case Axis.horizontal:
    //       childParentData.offset =
    //           Offset(childMainPosition, childCrossPosition);
    //       break;
    //     case Axis.vertical:
    //       childParentData.offset =
    //           Offset(childCrossPosition, childMainPosition);
    //       break;
    //   }
    //   if (flipMainAxis) {
    //     childMainPosition -= betweenSpace;
    //   } else {
    //     childMainPosition += _getMainSize(child.size) + betweenSpace;
    //   }
    //   child = childParentData.nextSibling;
    // }
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
