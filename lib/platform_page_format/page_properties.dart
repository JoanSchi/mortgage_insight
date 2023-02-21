import 'package:flutter/widgets.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import '../utilities/device_info.dart';

class MatchPageProperties<T> {
  final Set<FormFactorType> types;
  final Set<Orientation> orientations;

  final T pageProperties;

  MatchPageProperties({
    this.types = const {},
    this.orientations = const {},
    required this.pageProperties,
  });

  /// Use a unique number for match points 64,32,16,8,4,2,1  etc for unique number
  ///
  ///

  int matchPoints(FormFactorType type, Orientation orientation) {
    int points = 0;

    if (types.isNotEmpty) {
      if (types.contains(type)) {
        points += 64;
      } else {
        return -1;
      }
    }

    if (orientations.isNotEmpty) {
      if (orientations.contains(orientation)) {
        points += 32;
      } else {
        return -1;
      }
    }
    return points;
  }

  static int get maxPoints => 96;
}

class PageProperties {
  final bool hasNavigationBar;
  final List<PageActionItem> leftTopActions;
  final List<PageActionItem> rightTopActions;
  final List<PageActionItem> leftBottomActions;
  final List<PageActionItem> rightBottomActions;

  const PageProperties({
    this.hasNavigationBar = false,
    this.leftTopActions = const [],
    this.rightTopActions = const [],
    this.leftBottomActions = const [],
    this.rightBottomActions = const [],
  });
}
