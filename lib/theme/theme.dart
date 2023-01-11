// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/letter_spacing.dart';
import '../utilities/device_info.dart';
import 'appbar_overview_page_style.dart';
import 'ltrb_navigation_style.dart';
import 'tabbar_overview_page_style.dart';

const defaultLetterSpacing = 0.03;
const mediumLetterSpacing = 0.04;
const largeLetterSpacing = 1.0;

// const Color color50 = Color(0xFFf1f1ea); // Color(0xFFFEEAE6);
// const Color color100 = Color(0xFFA2B29F); //Color(0xFFFEDBD0);
// // const Color shrinePink300 = Color(0xFFFBB8AC);
// // const Color shrinePink400 = Color(0xFFEAA4A4);
// const Color color900 = Color(0xFF442B2D);
// // const Color shrineBrown600 = Color(0xFF7D4F52);
// const Color errorColor = Color(0xFFC5032B);
// const Color surfaceWhite = Color(0xFFFFFBFA);
// const Color backgroundWhite = Colors.white;
// // const back = Color(0xFFfafafa);

const Color color50 = Color(0xFFf1f1ea); // Color(0xFFFEEAE6);
const Color color100 = Color(0xFF70b7d3);
const Color colorSecondary = Color.fromARGB(255, 102, 157, 180);
// const Color shrinePink300 = Color(0xFFFBB8AC);
// const Color shrinePink400 = Color(0xFFEAA4A4);
const Color color900 = Color.fromARGB(255, 5, 66, 92);
// const Color shrineBrown600 = Color(0xFF7D4F52);
const Color errorColor = Color(0xFFC5032B);
const Color surfaceWhite = Color(0xFFE8F1F5);
const Color backgroundWhite = Color(0xFFf1f5fd);
// const back = Color(0xFFfafafa);
const Color bar = Color(0xd7eef4ff); //Color(0xFFF4F9F9); //Color(0xFFD0E8F2);

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: color900, size: 32.0);
}

ThemeData buildTheme() {
  final base = ThemeData(useMaterial3: false);
  return base.copyWith(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      colorScheme: _shrineColorScheme,
      primaryColor: color100,
      scaffoldBackgroundColor: Colors.white,
      cardColor: backgroundWhite,
      errorColor: errorColor,
      buttonTheme: const ButtonThemeData(
        colorScheme: _shrineColorScheme,
        textTheme: ButtonTextTheme.normal,
      ),
      toggleableActiveColor: color100,
      primaryIconTheme: _customIconTheme(base.iconTheme),
      textTheme: _buildShrineTextTheme(base.textTheme),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: color100,
      ),
      primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
      iconTheme: _customIconTheme(base.iconTheme),
      listTileTheme: base.listTileTheme.copyWith(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0))),
      splashColor: Color.fromARGB(255, 168, 218, 210),
      highlightColor: Color.fromARGB(206, 203, 234, 240),
      backgroundColor: Colors.white);
}

ThemeData buildFactorTheme(BuildContext context) {
  final deviceScreen = DeviceScreen3.of(context);
  final formFactorType = deviceScreen.formFactorType;

  return deviceScreen.theme.copyWith(extensions: {
    buildLtrbNavigationStyle(formFactorType),
    buildTabBarOverviewPageStyle(formFactorType),
    buildAppBarOverViewPageStyle(formFactorType),
  });
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return GoogleFonts.rubikTextTheme(base
      .copyWith(
        headline3: base.headline4?.copyWith(
          fontSize: 24,
        ),
        headline4: base.headline4?.copyWith(
          fontSize: 18,
        ),
        headline5: base.headline5?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        headline6: base.headline6?.copyWith(
          fontSize: 18,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        caption: base.caption?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodyText1: base.bodyText1?.copyWith(
          fontSize: 16,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodyText2: base.bodyText2?.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        subtitle1: base.subtitle1?.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        button: base.button?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
      )
      .apply(
        displayColor: color900,
        bodyColor: color900,
      ));
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: color100,
  primaryContainer: color900,
  secondary: color50,
  secondaryContainer: color900,
  surface: surfaceWhite,
  background: backgroundWhite,
  error: errorColor,
  onPrimary: color900,
  onSecondary: color900,
  onSurface: color900,
  onBackground: color900,
  onError: surfaceWhite,
  brightness: Brightness.light,
);

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

// class TabBarPageStyle extends ThemeExtension<TabBarPageStyle> {
//   double? height;
//   TextStyle? textStyle;
//   Color? indicatorColor;
//   Color? labelColor;

//   TabBarPageStyle({
//     this.height,
//     this.textStyle,
//     this.indicatorColor,
//     this.labelColor,
//   });

//   @override
//   ThemeExtension<TabBarPageStyle> copyWith({
//     double? height,
//     TextStyle? textStyle,
//     Color? indicatorColor,
//     Color? labelColor,
//   }) {
//     return TabBarPageStyle(
//       height: height ?? this.height,
//       textStyle: textStyle ?? this.textStyle,
//       indicatorColor: indicatorColor ?? this.indicatorColor,
//       labelColor: labelColor ?? this.labelColor,
//     );
//   }

//   @override
//   ThemeExtension<TabBarPageStyle> lerp(
//       ThemeExtension<TabBarPageStyle>? other, double t) {
//     if (other is! TabBarPageStyle) {
//       return this;
//     }

//     return TabBarPageStyle(
//       height: lerpDouble(height, other.height, t),
//       textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
//       indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
//       labelColor: Color.lerp(labelColor, other.labelColor, t),
//     );
//   }
// }


