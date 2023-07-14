// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utilities/device_info.dart';
import 'appbar_overview_page_style.dart';
import 'ltrb_navigation_style.dart';
import 'tabbar_overview_page_style.dart';
import 'theme_colors.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

// // const Color color50 = Color(0xFFf1f1ea); // Color(0xFFFEEAE6);
// // const Color color100 = Color(0xFFA2B29F); //Color(0xFFFEDBD0);
// // // const Color shrinePink300 = Color(0xFFFBB8AC);
// // // const Color shrinePink400 = Color(0xFFEAA4A4);
// // const Color color900 = Color(0xFF442B2D);
// // // const Color shrineBrown600 = Color(0xFF7D4F52);
// // const Color errorColor = Color(0xFFC5032B);
// // const Color surfaceWhite = Color(0xFFFFFBFA);
// // const Color backgroundWhite = Colors.white;
// // // const back = Color(0xFFfafafa);

// const Color color50 = Color(0xFFf1f1ea); // Color(0xFFFEEAE6);
// const Color color100 = Color(0xFF70b7d3);
// const Color colorSecondary = Color.fromARGB(255, 102, 157, 180);
// // const Color shrinePink300 = Color(0xFFFBB8AC);
// // const Color shrinePink400 = Color(0xFFEAA4A4);
// const Color color900 = Color.fromARGB(255, 5, 66, 92);
// // const Color shrineBrown600 = Color(0xFF7D4F52);
// const Color errorColor = Color(0xFFC5032B);
// const Color surfaceWhite = Color(0xFFE8F1F5);
// const Color backgroundWhite = Color(0xFFf1f5fd);
// // const back = Color(0xFFfafafa);
// const Color bar = Color(0xd7eef4ff); //Color(0xFFF4F9F9); //Color(0xFFD0E8F2);

ThemeData buildTheme(BuildContext context) {
  final DeviceScreen3 deviceScreen = DeviceScreen3.of(context);

  final theme = ThemeData(
      useMaterial3: true,
      colorScheme: hypotheekLightColorScheme,
      primaryColor: hypotheekLightColorScheme.primary,
      indicatorColor: hypotheekLightColorScheme.primary,
      scaffoldBackgroundColor: Colors.white,
      extensions: {
        _b,
        buildTabBarOverviewPageStyle(deviceScreen.formFactorType),
        buildAppBarOverViewPageStyle(deviceScreen.formFactorType),
      });

  return theme.copyWith(
    tabBarTheme: switch (deviceScreen.formFactorType) {
      FormFactorType.monitor => TabBarTheme(
          labelColor: hypotheekLightColorScheme.primary,
          indicatorColor: hypotheekLightColorScheme.primary,
          labelStyle: const TextStyle(fontSize: 18.0),
          unselectedLabelStyle: const TextStyle(fontSize: 18.0)),
      _ => TabBarTheme(
          labelColor: hypotheekLightColorScheme.primary,
          indicatorColor: hypotheekLightColorScheme.primary,
        )
    },
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: hypotheekLightColorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        )),
    textTheme: _buildShrineTextTheme(theme.textTheme),
    primaryTextTheme: _buildShrineTextTheme(theme.primaryTextTheme),
    listTileTheme: theme.listTileTheme.copyWith(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return GoogleFonts.rubikTextTheme(base.copyWith(
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 24.0,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 18.0,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w500,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 18.0,
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16.0,
    ),
    bodyMedium: base.bodyMedium,
    titleMedium: base.titleMedium,
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),
  )
      // .apply(
      //   displayColor: color900,
      //   bodyColor: color900,
      // )
      );
}

class PageStyle extends ThemeExtension<PageStyle> {
  Color? backgroundColor;
  ButtonStyle? buttonStyleTop;
  ButtonStyle? buttonStyleBottom;

  PageStyle({
    this.backgroundColor,
    this.buttonStyleTop,
    this.buttonStyleBottom,
  });

  @override
  ThemeExtension<PageStyle> copyWith({
    Color? backgroundColor,
    ButtonStyle? buttonStyleTop,
    ButtonStyle? buttonStyleBottom,
  }) {
    return PageStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      buttonStyleTop: buttonStyleTop ?? this.buttonStyleTop,
      buttonStyleBottom: buttonStyleBottom ?? this.buttonStyleBottom,
    );
  }

  @override
  ThemeExtension<PageStyle> lerp(ThemeExtension<PageStyle>? other, double t) {
    if (other is! PageStyle) {
      return this;
    }

    return PageStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      buttonStyleTop: ButtonStyle.lerp(buttonStyleTop, other.buttonStyleTop, t),
      buttonStyleBottom:
          ButtonStyle.lerp(buttonStyleBottom, other.buttonStyleBottom, t),
    );
  }
}

final _b = LtrbNavigationStyle(
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
