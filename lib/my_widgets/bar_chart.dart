import 'package:flutter/material.dart';
import 'summary_pie_chart/pie_chart.dart';

class BarGraph extends StatefulWidget {
  final List<PiePiece> pieces;
  final double radius;
  BarGraph({Key? key, required this.pieces, this.radius: 16.0})
      : super(key: key);

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _animatedController = AnimationController(
      vsync: this, value: 1.0, duration: const Duration(milliseconds: 200))
    ..addListener(() {
      setState(() {});
    });

  late TweenPiece tweenPiece =
      TweenPiece(begin: widget.pieces, end: widget.pieces);
  late Animation<List<PiePiece>> _animation =
      tweenPiece.animate(_animatedController);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(BarGraph oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pieces.length == widget.pieces.length) {
      tweenPiece
        ..begin = _animation.value
        ..end = widget.pieces;
      _animatedController
        ..value = 0.0
        ..forward();
    } else {
      tweenPiece
        ..begin = widget.pieces
        ..end = widget.pieces;
      _animatedController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animatedValue = _animation.value;
    return CustomPaint(
      child: Container(
        height: 56.0,
      ),
      painter: PaintBar(values: animatedValue, radius: widget.radius),
    );
  }
}

class PaintBar extends CustomPainter {
  final List<PiePiece> values;
  final double radius;
  PaintBar({required this.values, this.radius: 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(
        0.0,
        (double previousValue, PiePiece element) =>
            previousValue + element.value);

    Paint paint = Paint();
    double x = 0.0;

    if (radius > 0.0) {
      canvas.saveLayer(Rect.largest, paint);
      canvas.clipRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0.0, 0.0, size.width, 56.0), Radius.circular(radius)));
    }

    for (PiePiece p in values) {
      paint.color = p.color;

      double length = size.width / total * p.value;

      canvas.drawRect(Rect.fromLTWH(x, 0.0, length, 56.0), paint);

      // TextPainter tp = TextPainter(
      //   text: TextSpan(text: '${p.value.toInt()}'),
      //   textDirection: TextDirection.ltr,
      //   textAlign: TextAlign.left,
      // );

      // tp.layout(maxWidth: length);

      // if (tp.width <= length) {
      //   tp.paint(canvas, Offset(x + (length - tp.width) / 2.0, 20.0));
      // }

      x += length;
    }
    if (radius > 0.0) {
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
