import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExdendedBar extends CustomPainter {
  final double radial;
  final double maxHeight;
  final double paddingBottom;
  final Color color;
  final Paint _paint;
  final pi = math.pi;

  ExdendedBar(
      {this.radial = 8.0,
      this.maxHeight = double.maxFinite,
      this.paddingBottom = 0.0,
      required this.color})
      : _paint = Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    double heigth = size.height - paddingBottom;

    if (maxHeight < heigth) heigth = maxHeight;

    final length = radial * 2.0;
    final leftBottom = Rect.fromLTWH(0.0, heigth - length, length, length);
    final rightBottom =
        Rect.fromLTWH(size.width - length, heigth - length, length, length);

    final path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, heigth)
      ..arcTo(leftBottom, -pi, -pi * 0.5, false)
      ..arcTo(rightBottom, -pi * 1.5, -pi * 0.5, false)
      ..lineTo(size.width, 0.0)
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(ExdendedBar oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.maxHeight != maxHeight ||
        oldDelegate.radial != radial ||
        oldDelegate.paddingBottom != paddingBottom;
  }
}

class RoundHeaderCard extends CustomPainter {
  final double radial;
  final double padding;
  final Color color;
  final Paint _paint;
  final pi = math.pi;

  RoundHeaderCard({this.radial = 8.0, this.padding = 4.0, required this.color})
      : _paint = Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final length = radial * 2.0;
    final leftBottom = Rect.fromLTWH(padding, 0.0, length, length);
    final rightBottom =
        Rect.fromLTWH(size.width - length - padding, 0.0, length, length);

    Path path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, radial)
      ..arcTo(leftBottom, -pi, pi * 0.5, false)
      ..close();

    canvas.drawPath(path, _paint);

    path = Path()
      ..moveTo(size.width, 0.0)
      ..arcTo(rightBottom, -3.14 * 0.5, 3.14 * 0.5, false)
      ..lineTo(size.width, radial)
      ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(RoundHeaderCard oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.padding != padding ||
        oldDelegate.radial != radial;
  }
}

class RoundHeaderBar extends CustomPainter {
  final double leftTopRadial;
  final double rightTopRadial;
  final double leftBottomRadial;
  final double rightBottomRadial;
  final double statusBarHeight;
  final double leftInsets;
  final double rightInsets;
  final Color color;
  final Paint _paint;
  final pi = math.pi;

  RoundHeaderBar(
      {this.leftTopRadial = 16.0,
      this.rightTopRadial = 16.0,
      this.leftBottomRadial = 16.0,
      this.rightBottomRadial = 16.0,
      this.statusBarHeight = 28.0,
      this.leftInsets = 56.0,
      this.rightInsets = 56.0,
      required this.color})
      : _paint = Paint()..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    Path path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, statusBarHeight);

    if (leftInsets != 0.0) {
      if (leftTopRadial != 0.0) {
        final length = leftTopRadial * 2.0;

        final leftTop =
            Rect.fromLTWH(leftInsets - length, statusBarHeight, length, length);

        path.arcTo(leftTop, -0.5 * pi, pi * 0.5, false);
      } else {
        path.lineTo(leftInsets, statusBarHeight);
      }
    }

    if (leftBottomRadial != 0.0) {
      final length = leftBottomRadial * 2.0;
      final leftBottom =
          Rect.fromLTWH(leftInsets, height - length, length, length);
      path.arcTo(leftBottom, pi, -0.5 * pi, false);
    } else {
      path.lineTo(leftInsets, height);
    }

    if (rightBottomRadial != 0.0) {
      final length = rightBottomRadial * 2.0;
      final rightBottom = Rect.fromLTWH(
          width - rightInsets - length, height - length, length, length);

      path.arcTo(rightBottom, 0.5 * pi, -pi * 0.5, false);
    } else {
      path.lineTo(width - rightInsets, height);
    }

    if (rightInsets != 0.0) {
      if (rightBottomRadial != 0.0) {
        final length = rightBottomRadial * 2.0;
        final rightTop =
            Rect.fromLTWH(width - rightInsets, statusBarHeight, length, length);

        path
          ..arcTo(rightTop, -pi, pi * 0.5, false)
          ..lineTo(width, statusBarHeight);
      }
    }

    path
      ..lineTo(width, 0.0)
      ..close();

    //   ..lineTo(0.0, radial)
    //   ..arcTo(leftBottom, -pi, pi * 0.5, false)
    //   ..close();

    // canvas.drawPath(path, _paint);

    // path = Path()
    //   ..moveTo(size.width, 0.0)
    //   ..arcTo(rightBottom, -3.14 * 0.5, 3.14 * 0.5, false)
    //   ..lineTo(size.width, radial)
    //   ..close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(RoundHeaderBar oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.statusBarHeight != statusBarHeight ||
        oldDelegate.leftInsets != leftInsets ||
        oldDelegate.rightInsets != rightInsets ||
        oldDelegate.leftTopRadial != leftTopRadial ||
        oldDelegate.rightTopRadial != rightTopRadial ||
        oldDelegate.leftBottomRadial != leftBottomRadial ||
        oldDelegate.rightBottomRadial != rightBottomRadial;
  }
}

class RoundedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget? child;

  RoundedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(RoundedHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class ShapeBorderHeader extends ShapeBorder {
  final double leftTopRadial;
  final double rightTopRadial;
  final double leftBottomRadial;
  final double rightBottomRadial;
  final double topPadding;
  final double heightToFlat;
  final double leftInsets;
  final double rightInsets;
  final pi = math.pi;

  const ShapeBorderHeader({
    this.heightToFlat = 28.0,
    this.leftTopRadial = 16.0,
    this.rightTopRadial = 16.0,
    this.leftBottomRadial = 16.0,
    this.rightBottomRadial = 16.0,
    this.topPadding = 0.0,
    this.leftInsets = 0.0,
    this.rightInsets = 0.0,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(rect, inner: true);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getPath(rect);
  }

  Path getPath(Rect rect, {inner = false}) {
    final width = rect.width;
    final height = inner ? rect.height : rect.height;
    double minLeftHeight = leftInsets == 0.0 ? heightToFlat : topPadding;
    double minRightHeight = rightInsets == 0.0 ? heightToFlat : topPadding;

    Path path = Path()
      ..moveTo(0.0, 0.0)
      ..lineTo(0.0, minLeftHeight);

    bool equalToStatusBar = rect.height <= minLeftHeight;

    if (equalToStatusBar) {
      path.lineTo(width, minLeftHeight);
      path.lineTo(width, 0.0);
      path.close();
      return path;
    }

    final availibleLeftSpace = rect.height - minLeftHeight;
    const curveFactor = 0.5;

    /* Left
     *
     */
    final neededSpaceLeft = leftTopRadial + leftBottomRadial;

    double leftFactor = availibleLeftSpace > neededSpaceLeft
        ? 1.0
        : availibleLeftSpace / neededSpaceLeft;

    //lefDistance is distance between controlPoint X2 top to controlPoint X1 bottom

    final double leftDistance = (availibleLeftSpace < neededSpaceLeft)
        ? math.sqrt(neededSpaceLeft * neededSpaceLeft -
                availibleLeftSpace * availibleLeftSpace) *
            curveFactor
        : 0.0;

    if (leftInsets != 0.0) {
      if (leftTopRadial * leftFactor != 0.0) {
        path.lineTo(leftInsets - leftTopRadial, minLeftHeight);

        path.quadraticBezierTo(
          leftInsets - (leftDistance / neededSpaceLeft * leftTopRadial),
          minLeftHeight,
          leftInsets,
          minLeftHeight + leftTopRadial * leftFactor,
        );
      } else {
        path.lineTo(leftInsets, minRightHeight);
      }
    }

    if (leftBottomRadial != 0.0) {
      path
        ..lineTo(leftInsets, height - leftBottomRadial * leftFactor)
        ..quadraticBezierTo(
          leftInsets +
              (leftDistance / neededSpaceLeft * leftBottomRadial / 2.0),
          height,
          leftInsets + leftBottomRadial,
          height,
        );
    } else {
      path.lineTo(leftInsets, height);
    }

    /* Right
     *
     */
    final availibleRightSpace = rect.height - minRightHeight;
    final neededSpaceRight = rightTopRadial + rightBottomRadial;

    double rightFactor = availibleRightSpace > neededSpaceRight
        ? 1.0
        : availibleRightSpace / neededSpaceRight;

    //rightDistance is distance between controlPoint X2 top to controlPoint X1 bottom

    final double rightDistance = (availibleRightSpace < neededSpaceRight)
        ? math.sqrt(neededSpaceRight * neededSpaceRight -
                availibleRightSpace * availibleRightSpace) *
            curveFactor
        : 0.0;

    if (rightBottomRadial != 0.0) {
      path
        ..lineTo(width - rightInsets - rightBottomRadial, height)
        ..quadraticBezierTo(
            width -
                rightInsets -
                rightDistance / neededSpaceRight * rightBottomRadial,
            height,
            width - rightInsets,
            height - rightBottomRadial * rightFactor);
    } else {
      path.lineTo(width - rightInsets, height);
    }

    if (rightInsets != 0.0) {
      if (rightTopRadial != 0.0) {
        path
          ..lineTo(width - rightInsets,
              minRightHeight + rightTopRadial * rightFactor)
          ..quadraticBezierTo(
              width -
                  rightInsets +
                  rightDistance / neededSpaceRight * rightTopRadial,
              minRightHeight,
              width - rightInsets + rightTopRadial,
              minRightHeight);
      } else {
        path.lineTo(width - rightInsets, minRightHeight);
      }
    }

    path.lineTo(width, minRightHeight);
    path.lineTo(width, 0.0);
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

// this.leftTopRadial = 16.0,
//     this.rightTopRadial = 16.0,
//     this.leftBottomRadial = 16.0,
//     this.rightBottomRadial = 16.0,
//     this.statusBarHeight = 28.0,
//     this.leftInsets = 56.0,
//     this.rightInsets = 56.0,

  @override
  ShapeBorder scale(double t) {
    return ShapeBorderHeader(
      heightToFlat: heightToFlat * t,
      leftTopRadial: leftTopRadial * t,
      rightTopRadial: rightTopRadial * t,
      leftBottomRadial: leftBottomRadial * t,
      rightBottomRadial: rightBottomRadial * t,
      leftInsets: leftInsets * t,
      rightInsets: rightInsets * t,
    );
  }
}
