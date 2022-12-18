import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/hypotheek/bewerken/hypotheek_bewerken.dart';
import 'package:mortgage_insight/hypotheek/profiel_bewerken/hypotheek_profiel_bewerken.dart';
import 'package:mortgage_insight/hypotheek/hypotheek_panel.dart';
import 'package:mortgage_insight/income/income_panel.dart';
import 'package:mortgage_insight/routes/routes_items.dart';
import 'package:mortgage_insight/state_manager/edit_state.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../debts/debt_panel.dart';
import '../income/income_fields.dart';
import 'page_navigator_observer.dart';

class MyRoutePage extends ConsumerStatefulWidget {
  MyRoutePage();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MyRoutePageState();
}

class MyRoutePageState extends ConsumerState<MyRoutePage>
    implements PageNavigatorObserverImplementation {
  static GoRouterPageBuilder noTransitionPage(
    Widget child,
  ) {
    return (BuildContext context, GoRouterState state) =>
        NoTransitionPage<void>(
          name: state.name,
          key: state.pageKey,
          child: child,
        );
  }

  late GoRouter _router = GoRouter(
    observers: [PageNavigatorObserver(implementation: this)],
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'b',
        builder: (context, state) => Container(),
      ),
      GoRoute(
          path: '/$routeIncome',
          name: routeIncome,
          // builder: (context, state) => IncomePanel(),
          pageBuilder: noTransitionPage(IncomePanel()),
          routes: [
            GoRoute(
              path: '$routeIncomeEdit',
              name: routeIncomeEdit,
              pageBuilder: noTransitionPage(
                IncomeEdit(),
              ),
            ),
          ]),
      GoRoute(
          path: '/$routeDebts',
          name: routeDebts,
          pageBuilder: noTransitionPage(
            LastPanel(),
          ),
          routes: [
            GoRoute(
                path: '$routeDebtsEdit',
                name: routeDebtsEdit,
                pageBuilder: noTransitionPage(
                  BewerkSchulden(),
                )),
          ]),
      GoRoute(
        path: '/$routeOverview',
        name: routeOverview,
        builder: (context, state) => Container(color: Colors.blue[100]),
      ),
      GoRoute(
          path: '/$routeMortgage',
          name: routeMortgage,
          pageBuilder: noTransitionPage(
            HypotheekBlub(),
          ),
          routes: [
            GoRoute(
                path: '$routeNieweHypotheekProfielEdit',
                name: routeNieweHypotheekProfielEdit,
                pageBuilder: noTransitionPage(
                  BewerkHypotheekProfiel(),
                )),
            GoRoute(
                path: '$routeMortgageEdit',
                name: routeMortgageEdit,
                pageBuilder: noTransitionPage(
                  BewerkHypotheek(),
                )),
          ]),
      GoRoute(
        path: '/$routePayoff',
        name: routePayoff,
        builder: (context, state) => Container(color: Colors.blueGrey[300]),
      ),
      GoRoute(
        path: '/$routeTax',
        name: routeTax,
        builder: (context, state) => Container(color: Colors.orange[300]),
      ),
      GoRoute(
        path: '/$routeTable',
        name: routeTable,
        builder: (context, state) => Container(color: Colors.blue[300]),
      ),
      GoRoute(
        path: '/$routeGraph',
        name: routeGraph,
        builder: (context, state) => Container(color: Colors.pink[300]),
      ),
    ],
  );

  String get initialLocation {
    String route = '/${ref.read(routePageProvider)}';

    switch (DeviceScreen3.of(context).formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
        break;
      case FormFactorType.Tablet:
      case FormFactorType.Monitor:
        String subRoute = ref.read(routeEditPageProvider).route;

        if (subRoute.isNotEmpty) {
          route = '$route/$subRoute';
        }
        break;
    }

    debugPrint('InitialLocation PageRoute $route');

    return route;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    cancelEdit(route.settings.name);
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // cancelEdit(previousRoute?.settings.name);
  }

  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    cancelEdit(previousRoute?.settings.name);
  }

  cancelEdit(String? route) {
    if (route == ref.read(routeEditPageProvider.notifier).editState.route) {
      scheduleMicrotask(() {
        ref.read(routeEditPageProvider.notifier).clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(routePageProvider, (String? previous, String next) {
      if (next.contains('Edit')) {
        _router.pushNamed(next);
      } else {
        _router.goNamed(next);
      }
    });

    bool allowEdit;
    switch (DeviceScreen3.of(context).formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
        allowEdit = false;
        break;
      case FormFactorType.Tablet:
      case FormFactorType.Monitor:
        allowEdit = true;
        break;
    }

    if (allowEdit) {
      ref.listen<EditRouteState?>(routeEditPageProvider,
          (EditRouteState? previous, EditRouteState? next) {
        if (next != null) {
          if (previous != null) {
            _router.goNamed(next.route);
          } else {
            _router.pushNamed(next.route);
          }
        }
      });
    }

    return Router(
        backButtonDispatcher:
            ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
              ..takePriority(),
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {}
}
