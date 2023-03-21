import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedCheck extends StatefulWidget {
  final bool checked;
  final double size;
  final Color? color;
  final double? strokeWidth;
  final Duration duration;
  final double minWidth;

  const AnimatedCheck(
      {super.key,
      required this.checked,
      required this.size,
      this.color,
      this.minWidth = 8.0,
      this.strokeWidth,
      this.duration = const Duration(milliseconds: 300)});

  @override
  State<StatefulWidget> createState() => AnimatedCheckState();
}

class AnimatedCheckState extends State<AnimatedCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        value: widget.checked ? 1.0 : 0.0,
        duration: widget.duration);
    _animation = _controller.drive(CurveTween(curve: Curves.easeInOut));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedCheck oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }

    if (oldWidget.checked != widget.checked) {
      if (widget.checked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return CustomPaint(
        foregroundPainter: AnimatedPathPainter(
            _animation, widget.color ?? theme.primaryColor, widget.strokeWidth),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: widget.minWidth +
                  (widget.size - widget.minWidth) * _animation.value,
              height: widget.size,
            );
          },
        ));
  }
}

class AnimatedPathPainter extends CustomPainter {
  final Animation<double> _animation;

  final Color _color;

  final double? strokeWidth;

  AnimatedPathPainter(this._animation, this._color, this.strokeWidth)
      : super(repaint: _animation);

  Path _createAnyPath(Size size) {
    return Path()
      ..moveTo(0.27083 * size.height, 0.54167 * size.height)
      ..lineTo(0.41667 * size.height, 0.68750 * size.height)
      ..lineTo(0.75000 * size.height, 0.35417 * size.height);
  }

  Path createAnimatedPath(Path originalPath, double animationPercent) {
    final totalLength = originalPath
        .computeMetrics()
        .fold(0.0, (double prev, PathMetric metric) => prev + metric.length);

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(Path originalPath, double length) {
    var currentLength = 0.0;

    final path = Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final animationPercent = _animation.value;

    final path = createAnimatedPath(_createAnyPath(size), animationPercent);

    final Paint paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth ?? size.width * 0.06;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
