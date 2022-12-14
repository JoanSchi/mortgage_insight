import 'package:flutter/material.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

class AppBarOverViewPageStyle extends ThemeExtension<AppBarOverViewPageStyle> {
  Color? background;
  Color? backgroundScrolling;
  Color? color;

  AppBarOverViewPageStyle({
    this.background,
    this.backgroundScrolling,
    this.color,
  });

  @override
  ThemeExtension<AppBarOverViewPageStyle> copyWith({
    Color? background,
    Color? backgroundScrolling,
    Color? color,
  }) {
    return AppBarOverViewPageStyle(
      background: background ?? this.background,
      backgroundScrolling: backgroundScrolling ?? this.backgroundScrolling,
      color: color ?? this.color,
    );
  }

  @override
  ThemeExtension<AppBarOverViewPageStyle> lerp(
      ThemeExtension<AppBarOverViewPageStyle>? other, double t) {
    if (other is! AppBarOverViewPageStyle) {
      return this;
    }

    return AppBarOverViewPageStyle(
      background: Color.lerp(background, other.background, t),
      backgroundScrolling:
          Color.lerp(backgroundScrolling, other.backgroundScrolling, t),
      color: Color.lerp(color, other.color, t),
    );
  }
}

buildAppBarOverViewPageStyle(FormFactorType formFactorType) {
  return AppBarOverViewPageStyle(
      background: Colors.white,
      backgroundScrolling: Color(0xFFE8F1F5),
      color: Color.fromARGB(255, 5, 66, 92));
}
