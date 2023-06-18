import 'package:flutter/widgets.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import '../utilities/device_info.dart';

class MatchPageProperties<T> {
  final bool? useScrollBars;
  final Set<FormFactorType> types;
  final Set<Orientation> orientations;

  final T pageProperties;

  const MatchPageProperties({
    this.useScrollBars = false,
    this.types = const {},
    this.orientations = const {},
    required this.pageProperties,
  });

  /// Use a unique number for match points 64,32,16,8,4,2,1  etc for unique number
  ///
  ///

  int matchPoints(
      bool useScrollBars, FormFactorType type, Orientation orientation) {
    int points = 0;

    if (this.useScrollBars != null) {
      if (this.useScrollBars == useScrollBars) {
        points += 64;
      } else {
        return 0;
      }
    }

    if (types.isNotEmpty) {
      if (types.contains(type)) {
        points += 32;
      } else {
        return 0;
      }
    }

    if (orientations.isNotEmpty) {
      if (orientations.contains(orientation)) {
        points += 16;
      } else {
        return 0;
      }
    }
    return points;
  }

  static int get maxPoints => 112;
}

class PageProperties {
  final bool hasNavigationBar;
  final double leftPaddingWithNavigation;
  final List<PageActionItem> leftTopActions;
  final List<PageActionItem> rightTopActions;
  final List<PageActionItem> leftBottomActions;
  final List<PageActionItem> rightBottomActions;
  final double minExtent;
  final double floatingExtent;
  final double maxExtent;
  final bool hasScrollBars;

  const PageProperties({
    this.hasNavigationBar = false,
    this.leftPaddingWithNavigation = 56.0,
    this.leftTopActions = const [],
    this.rightTopActions = const [],
    this.leftBottomActions = const [],
    this.rightBottomActions = const [],
    this.minExtent = 56.0,
    this.floatingExtent = 100.0,
    this.maxExtent = 200.0,
    this.hasScrollBars = false,
  });
}
