import 'package:flutter/material.dart';

typedef RouteChange<T, P> = void Function(T route, P previousRoute);

class PageNavigatorObserver extends NavigatorObserver {
  final PageNavigatorObserverImplementation implementation;

  PageNavigatorObserver({required this.implementation});

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    implementation.didRemove(route, previousRoute);
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    implementation.didPush(route, previousRoute);
  }

  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    implementation.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    implementation.didPop(route, previousRoute);
  }
}

abstract class PageNavigatorObserverImplementation {
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// The [Navigator] popped `route`.
  ///
  /// The route immediately below that one, and thus the newly active
  /// route, is `previousRoute`.
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// The [Navigator] removed `route`.
  ///
  /// If only one route is being removed, then the route immediately below
  /// that one, if any, is `previousRoute`.
  ///
  /// If multiple routes are being removed, then the route below the
  /// bottommost route being removed, if any, is `previousRoute`, and this
  /// method will be called once for each removed route, from the topmost route
  /// to the bottommost route.
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  /// The [Navigator] replaced `oldRoute` with `newRoute`.
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}
}
