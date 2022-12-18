import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/navigation/navigation_large.dart';
import '../routes/page_navigator_observer.dart';
import '../state_manager/edit_state.dart';

class LargeRoute extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LargeRouteState();
}

class LargeRouteState extends ConsumerState<LargeRoute>
    implements PageNavigatorObserverImplementation {
  late GoRouter _router = GoRouter(
    observers: [PageNavigatorObserver(implementation: this)],
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'LargeDocument',
        builder: (context, state) => LargeDocument(),
        // routes: [
        //   GoRoute(
        //     path: '$routeIncomeEdit',
        //     name: routeIncomeEdit,
        //     builder: (context, state) => IncomeEdit(),
        //   ),
        //   GoRoute(
        //     path: '$routeAddDebtsEdit',
        //     name: routeAddDebtsEdit,
        //     builder: (context, state) => AddDebts(),
        //   ),
        // ]
      ),
    ],
  );

  String get initialLocation {
    // String? subRoute = ref.read(routeEditPageProvider)?.route;

    // String route = (subRoute == null) ? '/' : '/$subRoute';

    // debugPrint('initialLocation Mobile: $route');

    return '/';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen<EditRouteState?>(routeEditPageProvider,
    //     (EditRouteState? previous, EditRouteState? next) {
    //   if (next != null) {
    //     _router.pushNamed(next.route);
    //   }
    // });

    return Router(
        backButtonDispatcher:
            ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
              ..takePriority(),
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate);
  }

  @override
  void didPush(Route route, Route? previousRoute) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // if ((route.settings.name ?? '').contains('Edit')) {
    //   scheduleMicrotask(() {
    //     ref.read(routeEditPageProvider.notifier).clear();
    //   });
    // }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {}

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {}
}

class LargeDocument extends StatefulWidget {
  LargeDocument({Key? key}) : super(key: key);

  @override
  State<LargeDocument> createState() => _LargeDocumentState();
}

class _LargeDocumentState extends State<LargeDocument> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // DeviceScreen3 deviceScreen = DeviceScreen3.of(context);

    return Scaffold(
        backgroundColor: theme.backgroundColor, body: LargeDrawer());
  }
}
