import 'dart:math' as math;
import 'package:flutter/material.dart';

class PiePiece {
  final double value;
  final String name;
  Color color;

  PiePiece({
    required this.value,
    required this.name,
    required this.color,
  });

  PiePiece copyWith({
    double? value,
    String? name,
    Color? color,
  }) {
    return PiePiece(
      value: value ?? this.value,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PiePiece &&
        other.value == value &&
        other.name == name &&
        other.color == color;
  }

  @override
  int get hashCode => value.hashCode ^ name.hashCode ^ color.hashCode;
}

class PieChart extends StatefulWidget {
  final double total;
  final List<PiePiece> pieces;
  final double? padding;
  final double? paddingRatio;
  final double strokeWidth;
  final bool useLine;
  final Widget? child;

  const PieChart({
    Key? key,
    this.total = 100.0,
    required this.pieces,
    double? padding,
    this.paddingRatio,
    this.strokeWidth = 16.0,
    this.useLine = false,
    this.child,
  })  : padding = (padding == null && paddingRatio == null) ? 4.0 : padding,
        super(key: key);

  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
  late TweenPiece tweenPiece =
      TweenPiece(begin: widget.pieces, end: widget.pieces);
  late final Animation<List<PiePiece>> _animation =
      tweenPiece.animate(_controller);

  @override
  void didUpdateWidget(covariant PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pieces.length == widget.pieces.length) {
      tweenPiece
        ..begin = _animation.value
        ..end = widget.pieces;
      _controller
        ..value = 0.0
        ..forward();
    } else {
      tweenPiece
        ..begin = widget.pieces
        ..end = widget.pieces;
      _controller.value = 0.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: PieChartPainter(
                total: widget.total,
                pieces: _animation.value,
                padding: widget.padding,
                paddingRatio: widget.paddingRatio,
                useLine: widget.useLine,
                strokeWidth: widget.strokeWidth),
            child: widget.child ?? Container(),
          );
        });
  }
}

class PieChartPainter extends CustomPainter {
  final double total;
  final List<PiePiece> pieces;
  final double? padding;
  final double? paddingRatio;
  final double strokeWidth;
  final bool useLine;

  PieChartPainter({
    required this.total,
    required this.pieces,
    required this.strokeWidth,
    required this.useLine,
    required this.padding,
    required this.paddingRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double p = (padding != null)
        ? padding!
        : size.shortestSide * (paddingRatio ?? 0.0);

    final d = size.shortestSide - p * 2.0 - (useLine ? strokeWidth : 0.0);
    final rect =
        Rect.fromLTWH((size.width - d) / 2.0, (size.height - d) / 2.0, d, d);

    final Paint paint = Paint();

    if (useLine) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
    } else {
      paint.style = PaintingStyle.fill;
    }

    final center = !useLine;

    //Start drawArc at the top
    double anglePosition = math.pi / 2.0 * 3.0;
    for (PiePiece piece in pieces) {
      double angle = math.pi * 2 / total * piece.value;
      canvas.drawArc(
        rect,
        anglePosition,
        angle,
        center,
        paint..color = piece.color,
      );
      anglePosition += angle;
    }
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return total != oldDelegate.total || pieces != oldDelegate.pieces;
  }
}

typedef ValuToText = String Function(double value);

class LegendItem extends StatelessWidget {
  final PiePiece item;
  final ValuToText? valueToText;
  final double minValue;

  LegendItem(
      {Key? key, required this.item, this.valueToText, this.minValue = 40.0})
      : super(key: key) {
    // this.valueToText = valueToText ?? (num v) => '$v';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24.0,
          height: 8.0,
          child: CustomPaint(
              painter: CircleLegend(color: item.color, radial: 5.0)),
        ),
        Text('${item.name}: '),
        ConstrainedBox(
            constraints: BoxConstraints(minWidth: minValue),
            child: Text(valueToText != null
                ? valueToText!(item.value)
                : '${item.value}'))
      ],
    );
  }
}

class TweenPiece extends Tween<List<PiePiece>> {
  TweenPiece({required List<PiePiece> begin, required List<PiePiece> end})
      : super(begin: begin, end: end);

  @override
  List<PiePiece> lerp(double t) {
    final List<PiePiece> b = begin as List<PiePiece>;
    final List<PiePiece> e = end as List<PiePiece>;
    return List.generate(
        b.length,
        (int index) => b[index].copyWith(
            value: b[index].value + (e[index].value - b[index].value) * t));
  }
}

class CircleLegend extends CustomPainter {
  final double radial;
  final Color color;

  CircleLegend({
    required this.radial,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        size.center(Offset.zero),
        radial,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CircleLegend oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radial != radial;
  }
}
