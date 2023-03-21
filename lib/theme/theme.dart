// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../layout/letter_spacing.dart';
import '../utilities/device_info.dart';
import 'appbar_overview_page_style.dart';
import 'ltrb_navigation_style.dart';
import 'tabbar_overview_page_style.dart';
import 'theme_colors.dart';

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
  final theme = ThemeData(
      useMaterial3: false,
      colorScheme: hypotheekLightColorScheme,
      primaryColor: hypotheekLightColorScheme.primary,
      indicatorColor: hypotheekLightColorScheme.primary,
      scaffoldBackgroundColor: Colors.white);

  return theme.copyWith(
    tabBarTheme: TabBarTheme(
        labelColor: hypotheekLightColorScheme.primary,
        indicatorColor: hypotheekLightColorScheme.primary),
    // appBarTheme: AppBarTheme(
    //     systemOverlayStyle: SystemUiOverlayStyle.dark,
    //     elevation: 0,
    //     titleTextStyle: theme.appBarTheme.titleTextStyle
    //         ?.copyWith(color: hypotheekLightColorScheme.primary),
    //     toolbarTextStyle: theme.appBarTheme.toolbarTextStyle
    //         ?.copyWith(color: hypotheekLightColorScheme.primary),
    //     foregroundColor: theme.colorScheme.primary,
    //     color: theme.colorScheme.onPrimary),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: color900,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        )),
    primaryIconTheme: _customIconTheme(theme.iconTheme),
    textTheme: _buildShrineTextTheme(theme.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: color100,
    ),
    primaryTextTheme: _buildShrineTextTheme(theme.primaryTextTheme),
    iconTheme: _customIconTheme(theme.iconTheme),
    listTileTheme: theme.listTileTheme.copyWith(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))),
  );
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
  return GoogleFonts.rubikTextTheme(base.copyWith(
    displaySmall: base.displaySmall?.copyWith(
      fontSize: 24,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: 18,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      fontWeight: FontWeight.w500,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 18,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodySmall: base.bodySmall?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    titleMedium: base.titleMedium?.copyWith(
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
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
