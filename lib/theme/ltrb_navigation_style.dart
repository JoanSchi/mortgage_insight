import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/device_info.dart';

class LtrbNavigationStyle extends ThemeExtension<LtrbNavigationStyle> {
  final Color? background;
  final Color? secondBackground;
  final Color? colorItem;
  final Color? colorSelectedItem;
  final Color? backgroundItem;
  final Color? backgroundSelectedItem;
  final Color? imageColor;
  final TextStyle? headerTextStyle;
  final Color? headerColorPrimair;
  final TextStyle? barTextStyle;

  const LtrbNavigationStyle({
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
      colorSelectedItem:
          Color.lerp(colorSelectedItem, other.colorSelectedItem, t),
      backgroundItem: Color.lerp(backgroundItem, other.backgroundItem, t),
      backgroundSelectedItem:
          Color.lerp(backgroundSelectedItem, other.backgroundSelectedItem, t),
      imageColor: Color.lerp(imageColor, other.imageColor, t),
      headerTextStyle:
          TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      barTextStyle: TextStyle.lerp(barTextStyle, other.barTextStyle, t),
      headerColorPrimair:
          Color.lerp(headerColorPrimair, other.headerColorPrimair, t),
    );
  }

  @override
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
      headerColorPrimair: headerColorPrimair ?? headerColorPrimair,
      barTextStyle: barTextStyle ?? this.barTextStyle,
    );
  }
}

buildLtrbNavigationStyle(FormFactorType formFactorType) {
  return LtrbNavigationStyle(
    imageColor: const Color.fromARGB(255, 6, 65, 91), // Colors.white,
    background: Colors.white,
    secondBackground: const Color.fromARGB(255, 183, 221, 237),
    headerColorPrimair: const Color(0xFF5a92a9),
    colorItem: const Color.fromARGB(255, 6, 65, 91),
    colorSelectedItem: const Color.fromARGB(
        255, 6, 65, 91), //const Color.fromARGB(255, 2, 2, 2),
    backgroundItem: null,
    backgroundSelectedItem: const Color.fromARGB(255, 231, 246, 248),
    headerTextStyle: GoogleFonts.notoSansVai(
        textStyle: const TextStyle(
            fontSize: 28.0, color: Color.fromARGB(255, 6, 65, 91))),
    barTextStyle: GoogleFonts.rubik(
        textStyle: const TextStyle(fontSize: 14.0, color: Colors.white)),
  );
}
