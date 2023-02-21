import 'package:flutter/widgets.dart';

class MatchTargetWrap<T> {
  final Set<TargetPlatform> targetPlatforms;
  final Set<bool> wraps;

  final T object;

  MatchTargetWrap({
    this.targetPlatforms = const {},
    this.wraps = const {},
    required this.object,
  });

  /// Use a unique number for match points 64,32,16,8,4,2,1  etc for unique number
  ///
  ///

  int matchPoints(TargetPlatform targetPlatform, bool wrap) {
    int points = 0;

    if (targetPlatforms.isNotEmpty) {
      if (targetPlatforms.contains(targetPlatform)) {
        points += 64;
      }
    }

    if (wraps.isNotEmpty) {
      if (wraps.contains(wrap)) {
        points += 32;
      }
    }
    return points;
  }

  static int get maxPoints => 96;
}
