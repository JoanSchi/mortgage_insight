// Copyright (C) 2023 Joan Schipper
//
// This file is part of mortgage_insight.
//
// mortgage_insight is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// mortgage_insight is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../utilities/device_info.dart';

class AdjustedScrollConfiguration extends StatelessWidget {
  final Widget child;

  const AdjustedScrollConfiguration({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyMaterialOverscrollIndicatorBehavior(),
      child: child,
    );
  }
}

class MyMaterialScrollBarBehavior extends ScrollBehavior {
  const MyMaterialScrollBarBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };

  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the base class ScrollBehavior as well.
    final deviceScreen3 = DeviceScreen3.of(context);

    switch (getPlatform(context)) {
      case TargetPlatform.linux ||
            TargetPlatform.macOS ||
            TargetPlatform.windows:
        {
          return switch (deviceScreen3.formFactorType) {
            FormFactorType.monitor => Scrollbar(
                interactive: true,
                controller: details.controller,
                child: child,
              ),
            (_) => child
          };
        }

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
        return child;
    }
  }
}

class MyMaterialOverscrollIndicatorBehavior
    extends MyMaterialScrollBarBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
    }
  }
}
