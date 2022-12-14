import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mortgage_insight/theme/theme.dart';

import '../layout/letter_spacing.dart';
import '../utilities/device_info.dart';

class LtrbNavigationStyle extends ThemeExtension<LtrbNavigationStyle> {
  Color? background;
  Color? secondBackground;
  Color? colorItem;
  Color? colorSelectedItem;
  Color? backgroundItem;
  Color? backgroundSelectedItem;
  Color? imageColor;
  TextStyle? headerTextStyle;
  Color? headerColorPrimair;
  TextStyle? barTextStyle;

  LtrbNavigationStyle({
    required this.background,
    required this.secondBackground,
    required this.colorItem,
    required this.colorSelectedItem,
    required this.backgroundItem,
    required this.backgroundSelectedItem,
    required this.imageColor,
    required this.headerTextStyle,
    required this.headerColorPrimair,
    required this.barTextStyle,
  });

  @override
  ThemeExtension<LtrbNavigationStyle> lerp(
      ThemeExtension<LtrbNavigationStyle>? other, double t) {
    if (other is! LtrbNavigationStyle) {
      return this;
    }
    return LtrbNavigationStyle(
      background: Color.lerp(background, other.background, t),
      secondBackground: Color.lerp(secondBackground, other.secondBackground, t),
      colorItem: Color.lerp(colorItem, other.colorItem, t),
      colorSelectedItem: Color.lerp(colorItem, other.colorItem, t),
      backgroundItem: Color.lerp(colorItem, other.colorItem, t),
      backgroundSelectedItem: Color.lerp(colorItem, other.colorItem, t),
      imageColor: Color.lerp(imageColor, other.imageColor, t),
      headerTextStyle:
          TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      barTextStyle: TextStyle.lerp(barTextStyle, other.barTextStyle, t),
      headerColorPrimair:
          Color.lerp(headerColorPrimair, other.headerColorPrimair, t),
    );
  }

  ThemeExtension<LtrbNavigationStyle> copyWith({
    Color? background,
    Color? secondBackground,
    Color? colorItem,
    Color? colorSelectedItem,
    Color? backgroundItem,
    Color? backgroundSelectedItem,
    Color? imageColor,
    TextStyle? headerTextStyle,
    TextStyle? barTextStyle,
  }) {
    return LtrbNavigationStyle(
      background: background ?? this.background,
      secondBackground: secondBackground ?? this.secondBackground,
      colorItem: colorItem ?? this.colorItem,
      colorSelectedItem: colorSelectedItem ?? this.colorSelectedItem,
      backgroundItem: backgroundItem ?? this.backgroundItem,
      backgroundSelectedItem:
          backgroundSelectedItem ?? this.backgroundSelectedItem,
      imageColor: imageColor ?? this.imageColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      headerColorPrimair: headerColorPrimair ?? this.headerColorPrimair,
      barTextStyle: barTextStyle ?? this.barTextStyle,
    );
  }
}

buildLtrbNavigationStyle(FormFactorType formFactorType) {
  return LtrbNavigationStyle(
    imageColor: Colors.white,
    background: Colors.white,
    secondBackground: Color(0xFF70b7d3),
    headerColorPrimair: Color(0xFF5a92a9),
    colorItem: Colors.white,
    colorSelectedItem: Color.fromARGB(255, 2, 2, 2),
    backgroundItem: null,
    backgroundSelectedItem: Colors.white.withOpacity(0.6),
    headerTextStyle: GoogleFonts.notoSansVai(
        textStyle: TextStyle(
            fontSize: 32.0,
            letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
            color: Color.fromARGB(255, 5, 66, 92))),
    barTextStyle: GoogleFonts.rubik(
        textStyle: TextStyle(fontSize: 14.0, color: Colors.white)),
  );
}
