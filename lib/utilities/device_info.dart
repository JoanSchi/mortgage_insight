import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum FormFactorType { smallPhone, largePhone, tablet, monitor, unknown }

class DeviceOS {
  // Syntax sugar, proxy the UniversalPlatform methods so our views can reference a single class
  static bool isIOS = Platform.isIOS;
  static bool isAndroid = Platform.isAndroid;
  static bool isMacOS = Platform.isMacOS;
  static bool isLinux = Platform.isLinux;
  static bool isWindows = Platform.isWindows;

  // Higher level device class abstractions (more syntax sugar for the views)
  static bool isWeb = kIsWeb;
  static bool get isDesktop => isWindows || isMacOS || isLinux;
  static bool get isMobile => isAndroid || isIOS;
  static bool get isDesktopOrWeb => isDesktop || isWeb;
  static bool get isMobileOrWeb => isMobile || isWeb;
}

// class DeviceScreen {
//   // Get the device form factor as best we can.
//   // Otherwise we will use the screen size to determine which class we fall into.
//   static FormFactorType of(BuildContext context) {
//     double shortestSide = MediaQuery.of(context).size.shortestSide;
//     if (shortestSide <= 300) return FormFactorType.smallPhone;
//     if (shortestSide <= 600) return FormFactorType.largePhone;
//     if (shortestSide <= 900) return FormFactorType.tablet;
//     return FormFactorType.monitor;
//   }

//   // Shortcuts for various mobile device types
//   static bool isPhone(BuildContext context) =>
//       MediaQuery.of(context).size.shortestSide <= 600.0;
//   static bool isTablet(BuildContext context) =>
//       of(context) == FormFactorType.tablet;
//   static bool isMonitor(BuildContext context) =>
//       of(context) == FormFactorType.monitor;
//   static bool isSmallPhone(BuildContext context) =>
//       of(context) == FormFactorType.smallPhone;
//   static bool isLargePhone(BuildContext context) =>
//       of(context) == FormFactorType.largePhone;
// }

class DeviceScreen3 {
  final MediaQueryData mediaQuery;
  final ThemeData theme;

  TargetPlatform get platform => theme.platform;
  Size get size => mediaQuery.size;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get topPadding => mediaQuery.padding.top;

  bool get hasScrollBars {
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return true;
    }
  }

  DeviceScreen3.of(BuildContext context)
      : mediaQuery = MediaQuery.of(context),
        theme = Theme.of(context);

  FormFactorType get formFactorType {
    switch (platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return formFactorTypeByShortestSide;
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (size.width > 1200.0 && size.height > 600.0) {
          return FormFactorType.monitor;
        } else if (size.width > 500 && size.height > 500) {
          return FormFactorType.tablet;
        } else {
          return FormFactorType.largePhone;
        }
    }
  }

  bool get formTypeFactorIsPhone {
    final type = formFactorType;
    return type == FormFactorType.smallPhone ||
        type == FormFactorType.largePhone;
  }

  FormFactorType get formFactorTypeByShortestSide {
    double shortestSide = size.shortestSide;
    if (shortestSide <= 300) return FormFactorType.smallPhone;
    if (shortestSide <= 600) return FormFactorType.largePhone;
    if (shortestSide <= 900) return FormFactorType.tablet;
    return FormFactorType.monitor;
  }

  Orientation get orientation =>
      size.width < size.height ? Orientation.portrait : Orientation.landscape;

  bool get isPortrait => size.width < size.height;

  bool get isTabletWidthNarrow => size.width <= 900.0;

  bool get wrapSelectionWidgets =>
      size.height < size.width &&
      (formFactorType == FormFactorType.smallPhone ||
          formFactorType == FormFactorType.largePhone);
}
