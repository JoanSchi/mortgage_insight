import 'package:flutter/material.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/overlay_indicator/ltbr_drawer_indicator.dart';
import 'package:mortgage_insight/navigation/navigation_mobile_left.dart';

import '../navigation/navigation_mobile_bottom.dart';
import '../routes/route_page.dart';

const double kLeftMobileNavigationBarSize = 64.0;

// class MobileRoute extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => MobileRouteState();
// }

// class MobileRouteState extends ConsumerState<MobileRoute>
//     implements PageNavigatorObserverImplementation {
//   late GoRouter _router = GoRouter(
//     observers: [PageNavigatorObserver(implementation: this)],
//     initialLocation: initialLocation,
//     routes: [
//       GoRoute(
//           path: '/',
//           name: 'MobileDocument',
//           builder: (context, state) => MobileDocument(),
//           routes: [
//             GoRoute(
//               path: '$routeIncomeEdit',
//               name: routeIncomeEdit,
//               builder: (context, state) => IncomeEdit(),
//             ),
//             GoRoute(
//               path: '$routeDebtsEdit',
//               name: routeDebtsEdit,
//               builder: (context, state) => BewerkSchulden(),
//             ),
//             GoRoute(
//               path: '$routeNieweHypotheekProfielEdit',
//               name: routeNieweHypotheekProfielEdit,
//               builder: (context, state) => BewerkHypotheekProfiel(),
//             ),
//             GoRoute(
//               path: '$routeMortgageEdit',
//               name: routeMortgageEdit,
//               builder: (context, state) => BewerkHypotheek(),
//             ),
//           ]),
//     ],
//   );

//   String get initialLocation {
//     String subRoute = ref.read(routeEditPageProvider).route;

//     String route = subRoute.isEmpty ? '/' : '/$subRoute';

//     debugPrint('initialLocation Mobile: $route');

//     return route;
//   }

//   @override
//   void dispose() {
//     // _router.removeDidPopListener(didPop);
//     // _router.removeDidPushListener(didPush);
//     // _router.removeDidRemoveListener(didRemove);
//     super.dispose();
//   }

//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     cancelEdit(route.settings.name);
//   }

//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

//   void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     cancelEdit(previousRoute?.settings.name);
//   }

//   cancelEdit(String? route) {
//     if (route == ref.read(routeEditPageProvider.notifier).editState.route) {
//       scheduleMicrotask(() {
//         ref.read(routeEditPageProvider.notifier).clear();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ref.listen<EditRouteState?>(routeEditPageProvider,
//         (EditRouteState? previous, EditRouteState? next) {
//       if (next != null) {
//         if (previous != null) {
//           _router.goNamed(next.route);
//         } else {
//           _router.pushNamed(next.route);
//         }
//       }
//     });

//     //Use Router.withConfig as example

//     // return Router.withConfig(
//     //   config: _router,
//     // );

//     //  routeInformationProvider: config.routeInformationProvider,
//     //   routeInformationParser: config.routeInformationParser,
//     //   routerDelegate: config.routerDelegate,

//     return Router(
//         backButtonDispatcher:
//             ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
//               ..takePriority(),
//         routeInformationProvider: _router.routeInformationProvider,
//         routeInformationParser: _router.routeInformationParser,
//         routerDelegate: _router.routerDelegate);
//   }

//   @override
//   void didReplace({Route? newRoute, Route? oldRoute}) {}
// }

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
            body: MyRoutePage(),
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
            body: MyRoutePage(),
            scrimeColorEnd: Color.fromARGB(159, 41, 125, 167),
            minimumSize: 64.0,
            navigationBarSize: 16.0,
          );

    return Scaffold(
      body: drawer,
    );
  }
}
