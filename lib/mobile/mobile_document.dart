import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/overlay_indicator/ltbr_drawer_indicator.dart';
import 'package:mortgage_insight/navigation/navigation_mobile_left.dart';
import 'package:mortgage_insight/state_manager/widget_state.dart';
import '../debts/debt_panel.dart';
import '../hypotheek/bewerken/hypotheek_bewerken.dart';
import '../hypotheek/profiel_bewerken/hypotheek_profiel_bewerken.dart';
import '../income/income_fields.dart';
import '../navigation/navigation_mobile_bottom.dart';
import '../routes/my_go_route.dart';
import '../routes/page_route.dart';
import '../routes/routes_items.dart';

const double kLeftMobileNavigationBarSize = 64.0;

class MobileRoute extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MobileRouteState();
}

class MobileRouteState extends ConsumerState<MobileRoute> {
  late MyGoRouter _router = MyGoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
          path: '/',
          name: 'MobileDocument',
          builder: (context, state) => MobileDocument(),
          routes: [
            GoRoute(
              path: '$routeIncomeEdit',
              name: routeIncomeEdit,
              builder: (context, state) => IncomeEdit(),
            ),
            GoRoute(
              path: '$routeDebtsEdit',
              name: routeDebtsEdit,
              builder: (context, state) => BewerkSchulden(),
            ),
            GoRoute(
              path: '$routeNieweHypotheekProfielEdit',
              name: routeNieweHypotheekProfielEdit,
              builder: (context, state) => BewerkHypotheekProfiel(),
            ),
            GoRoute(
              path: '$routeMortgageEdit',
              name: routeMortgageEdit,
              builder: (context, state) => BewerkHypotheek(),
            ),
          ]),
    ],
  )
    ..addDidPopListener(didPop)
    ..addDidPushListener(didPush)
    ..addDidRemoveListener(didRemove);

  String get initialLocation {
    String subRoute = ref.read(routeEditPageProvider).route;

    String route = subRoute.isEmpty ? '/' : '/$subRoute';

    debugPrint('initialLocation Mobile: $route');

    return route;
  }

  @override
  void dispose() {
    _router.removeDidPopListener(didPop);
    _router.removeDidPushListener(didPush);
    _router.removeDidRemoveListener(didRemove);
    super.dispose();
  }

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    cancelEdit(route.settings.name);
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

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

    return Router(
        backButtonDispatcher:
            ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
              ..takePriority(),
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate);
  }
}

class MobileDocument extends StatefulWidget {
  const MobileDocument({Key? key}) : super(key: key);

  @override
  State<MobileDocument> createState() => _MobileDocumentState();
}

class _MobileDocumentState extends State<MobileDocument> {
  LtrbDrawerController ltrbDrawerController = LtrbDrawerController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget drawer = (mediaQuery.orientation == Orientation.portrait)
        ? LtrbDrawer(
            buildOverlay: defaultArrowIndicator(),
            drawerController: ltrbDrawerController,
            drawerPosition: DrawerPosition.bottom,
            safeTopArea: false,
            preferredSize: const [
              650.0,
            ],
            allowMaximumSize: true,
            minSpaceAllowed: 56.0,
            buildDrawer: ({
              required DrawerModel drawerModel,
              required DrawerPosition drawerPosition,
            }) =>
                BottomMobileDrawer(
              drawerModel: drawerModel,
            ),
            body: RoutePage(),
            scrimeColorEnd: Color.fromARGB(159, 41, 125, 167),
            minimumSize: 64.0,
            navigationBarSize: 16.0,
          )
        : LtrbDrawer(
            safeTopArea: false,
            buildOverlay: defaultArrowIndicator(),
            drawerController: ltrbDrawerController,
            drawerPosition: DrawerPosition.left,
            preferredSize: const [
              550.0,
            ],
            allowMaximumSize: true,
            maximumSize: 900,
            minSpaceAllowed: 56.0,
            buildDrawer: ({
              required DrawerModel drawerModel,
              required DrawerPosition drawerPosition,
            }) =>
                MobileLeftDrawer(
              drawerModel: drawerModel,
            ),
            body: RoutePage(),
            scrimeColorEnd: Color.fromARGB(159, 41, 125, 167),
            minimumSize: 64.0,
            navigationBarSize: 16.0,
          );

    return Scaffold(
      body: drawer,
    );
  }
}
