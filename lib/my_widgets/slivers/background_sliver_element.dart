import 'package:flutter/material.dart';
import 'dart:math' as math;

class BackgroundSliverElement extends StatelessWidget {
  final double radial;
  final Color color;
  final bool start;
  final bool end;
  final Widget? child;
  final double endPadding;
  final double startPadding;
  final double leftPadding;
  final double rightPadding;

  const BackgroundSliverElement(
      {Key? key,
      this.radial = 16.0,
      required this.color,
      required this.start,
      required this.end,
      this.child,
      this.endPadding = 8.0,
      this.startPadding = 8.0,
      this.leftPadding = 8.0,
      this.rightPadding = 8.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter:
          BorderPainter(radial: radial, color: color, start: start, end: end),
      child: Padding(
        padding: EdgeInsets.only(
            left: leftPadding,
            top: start ? startPadding : 0.0,
            right: rightPadding,
            bottom: end ? endPadding : 0.0),
        child: child,
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double radial;
  final Color color;
  final bool start;
  final bool end;

  BorderPainter({
    required this.radial,
    required this.color,
    required this.start,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    double bottom = size.height;
    double right = size.width;

    if (!start && !end) {
      canvas.drawRect(Rect.fromLTRB(0.0, 0.0, right, bottom + 1.0), paint);
    } else {
      double pi = math.pi;
      Path path = Path();
      double d = 2.0 * radial;

      if (start) {
        path
          ..moveTo(0.0, d)
          ..arcTo(Rect.fromLTWH(0.0, 0.0, d, d), pi, 0.5 * pi, false)
          ..arcTo(Rect.fromLTWH(right - d, 0.0, d, d), pi * 2.0 / 4.0 * 3.0,
              0.5 * pi, false);
      } else {
        path
          ..lineTo(0.0, 0.0)
          ..lineTo(right, 0.0);
      }

      if (end) {
        path
          ..arcTo(
              Rect.fromLTWH(right - d, bottom - d, d, d), 0.0, 0.5 * pi, false)
          ..arcTo(Rect.fromLTWH(0.0, bottom - d, d, d), pi * 2.0 / 4.0,
              0.5 * pi, false);
      } else {
        path
          ..lineTo(right, bottom + 1.0)
          ..lineTo(0.0, bottom + 1.0);
      }

      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        radial != oldDelegate.radial ||
        start != oldDelegate.start ||
        end != oldDelegate.end;
  }
}
