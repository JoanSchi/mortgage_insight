import 'package:flutter/material.dart';
import 'dart:math' as math;

ValueToWidth calculateWidthFromNumber(
    {required ValueToWidth<int> valueToWidth,
    required double value,
    required TextStyle textStyle,
    required double textScaleFactor,
    String decimal = '.00'}) {
  int suggestedNumber =
      math.pow(10.0, (math.log(value) / math.ln10).floorToDouble()).round() * 9;

  // x Zonder x9 is suggestie 1 by een waarde 0.1 dit wordt 1.00, dit is te small daarom 1 *9  wordt 9.00;

  if (valueToWidth.value != suggestedNumber ||
      valueToWidth.textScaleFactor != textScaleFactor) {
    final text = ',$suggestedNumber$decimal';

    final Size size = (TextPainter(
            text: TextSpan(text: text, style: textStyle),
            maxLines: 1,
            textScaleFactor: textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    valueToWidth
      ..value = suggestedNumber
      ..width = size.width
      ..textScaleFactor = textScaleFactor;
  }
  return valueToWidth;
}

ValueToWidth<String> calculateWidthFromText(
    {required ValueToWidth<String> textToWidth,
    required String text,
    required TextStyle textStyle,
    required double textScaleFactor}) {
  if (textToWidth.value != text ||
      textToWidth.textScaleFactor != textScaleFactor) {
    final Size size = (TextPainter(
            text: TextSpan(text: text, style: textStyle),
            maxLines: 1,
            textScaleFactor: textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    textToWidth
      ..value = text
      ..width = size.width
      ..textScaleFactor = textScaleFactor;
  }

  return textToWidth;
}

class ValueToWidth<T> {
  T value;
  double width;
  double textScaleFactor;

  ValueToWidth({
    required this.value,
    this.width = 0.0,
    this.textScaleFactor = 1.0,
  });
}
