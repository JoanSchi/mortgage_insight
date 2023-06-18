import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

class TabBarPageStyle extends ThemeExtension<TabBarPageStyle> {
  double? height;
  TextStyle? textStyle;
  Color? indicatorColor;
  Color? labelColor;

  TabBarPageStyle({
    this.height,
    this.textStyle,
    this.indicatorColor,
    this.labelColor,
  });

  @override
  ThemeExtension<TabBarPageStyle> copyWith({
    double? height,
    TextStyle? textStyle,
    Color? indicatorColor,
    Color? labelColor,
  }) {
    return TabBarPageStyle(
      height: height ?? this.height,
      textStyle: textStyle ?? this.textStyle,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      labelColor: labelColor ?? this.labelColor,
    );
  }

  @override
  ThemeExtension<TabBarPageStyle> lerp(
      ThemeExtension<TabBarPageStyle>? other, double t) {
    if (other is! TabBarPageStyle) {
      return this;
    }

    return TabBarPageStyle(
      height: lerpDouble(height, other.height, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      labelColor: Color.lerp(labelColor, other.labelColor, t),
    );
  }
}

buildTabBarOverviewPageStyle(FormFactorType formFactorType) {
  switch (formFactorType) {
    case FormFactorType.smallPhone:
    case FormFactorType.largePhone:
    case FormFactorType.tablet:
    case FormFactorType.unknown:
      return TabBarPageStyle(
        indicatorColor: const Color(0xFF5a92a9),
      );

    case FormFactorType.monitor:
      return TabBarPageStyle(
        height: 64.0,
        textStyle: const TextStyle(fontSize: 24.0),
        indicatorColor: const Color(0xFF5a92a9),
      );
  }
}
