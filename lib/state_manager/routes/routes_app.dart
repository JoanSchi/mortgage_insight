// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/route_widgets/document/route_widget_mobile.dart';

import '../../pages/schulden/schuld_keuze_panel.dart';
import '../../pages/schulden/schulden_overzicht_panel.dart';
import '../../pages/hypotheek/bewerken/hypotheek_bewerken.dart';
import '../../pages/hypotheek/hypotheek_panel.dart';
import '../../pages/hypotheek/profiel_bewerken/hypotheek_profiel_bewerken.dart';

import '../../pages/inkomen/inkomen_bewerken/inkomen_bewerken_panel.dart';
import '../../pages/inkomen/inkomen_panel.dart';
import '../../route_widgets/document/route_widget_document.dart';
import '../../route_widgets/document/route_widget_large.dart';
import '../../route_widgets/document/route_widget_medium.dart';
import '../../route_widgets/start/mobile_start.dart';
import '../state_edit_object.dart';
import '../../utilities/device_info.dart';
import '../../navigation/navigation_page_items.dart';

enum AppLayout { mobile, tablet, large, unknown }

enum AppRoutes { main, document, page }

void editRoute<T>({required WidgetRef ref, required String name, T? edit}) {
  ref.read(routeDocumentProvider.notifier).setEditRouteName(name: name);
  ref.read(editObjectProvider.notifier).state = EditObject<T>(object: edit);
}

String watchRoutePage(WidgetRef ref) =>
    ref.watch(routeDocumentProvider.select((v) => v.pageRouteName));

bool watchSelectedRoutePage(WidgetRef ref, String name) =>
    ref.watch(routeDocumentProvider.select((v) => v.pageRouteName == name));

final routeDocumentProvider =
    StateNotifierProvider<RouteNotifier, AppRouteStates>((ref) {
  return RouteNotifier(
      AppRouteStates(mainRouteName: '', pageRouteName: routeIncome));
});

class RouteNotifier extends StateNotifier<AppRouteStates> {
  RouteNotifier(AppRouteStates appRoute) : super(appRoute);

  void setPageRouteName(String name) {
    state = state.copyWith(pageRouteName: name)
      ..routes[AppRoutes.page]?.goNamed(name);
  }

  void setMainName(String name) {
    state = state
      ..mainRouteName = name
      ..routes[AppRoutes.main]?.goNamed(name);
  }

  void setEditRouteName({
    required String name,
  }) {
    final AppRoutes appRoute;

    if (state.appLayout == AppLayout.mobile) {
      appRoute = AppRoutes.document;
    } else {
      appRoute = AppRoutes.page;
    }

    state
      ..editRouteName = name
      ..routes[appRoute]?.pushNamed(name);
  }

  setFormFactorType(FormFactorType type) {
    if (state.formFactorType == type) {
      return;
    }

    final appLayout = _appLayoutFromType(type);

    if (state.appLayout != appLayout) {
      state
        ..appLayout = appLayout
        ..routes = _routesFromAppLayout(
            layout: appLayout,
            mainRouteName: state.mainRouteName,
            editRouteName: state.editRouteName,
            pageRouteName: state.pageRouteName);
    }
  }
}

class AppRouteStates {
  String mainRouteName;
  String pageRouteName;
  String editRouteName;
  Map<AppRoutes, GoRouter> routes;
  AppLayout appLayout;
  FormFactorType formFactorType;

  AppRouteStates({
    required this.mainRouteName,
    required this.pageRouteName,
    this.editRouteName = '',
    this.routes = const {},
    this.appLayout = AppLayout.unknown,
    this.formFactorType = FormFactorType.Unknown,
  });

  AppRouteStates copyWith({
    String? mainRouteName,
    String? pageRouteName,
    String? editRouteName,
    Map<AppRoutes, GoRouter>? routes,
    AppLayout? appLayout,
    FormFactorType? formFactorType,
  }) {
    return AppRouteStates(
      mainRouteName: mainRouteName ?? this.mainRouteName,
      pageRouteName: pageRouteName ?? this.pageRouteName,
      editRouteName: editRouteName ?? this.editRouteName,
      routes: routes ?? this.routes,
      appLayout: appLayout ?? this.appLayout,
      formFactorType: formFactorType ?? this.formFactorType,
    );
  }
}

String _routePage({
  required String pageName,
  required String editName,
}) {
  return '/$pageName${editName.isEmpty ? '' : '/$editName'}';
}

AppLayout _appLayoutFromType(FormFactorType type) {
  switch (type) {
    case FormFactorType.SmallPhone:
    case FormFactorType.LargePhone:
      {
        return AppLayout.mobile;
      }
    case FormFactorType.Tablet:
      {
        return AppLayout.tablet;
      }
    case FormFactorType.Monitor:
      {
        return AppLayout.large;
      }
    case FormFactorType.Unknown:
      {
        return AppLayout.unknown;
      }
  }
}

Map<AppRoutes, GoRouter> _routesFromAppLayout(
    {required AppLayout layout,
    required String mainRouteName,
    required String pageRouteName,
    required String editRouteName}) {
  switch (layout) {
    case AppLayout.mobile:
      return {
        AppRoutes.main: _appRoute('/$mainRouteName'),
        AppRoutes.document: _mobile('/$editRouteName'),
        AppRoutes.page: _page('/$pageRouteName')
      };

    case AppLayout.tablet:
      return {
        AppRoutes.main: _appRoute('/$mainRouteName'),
        AppRoutes.document: _mediumRoute(),
        AppRoutes.page:
            _page(_routePage(pageName: pageRouteName, editName: editRouteName))
      };

    case AppLayout.large:
      return {
        AppRoutes.main: _appRoute('/$mainRouteName'),
        AppRoutes.document: _largeRoute(),
        AppRoutes.page:
            _page(_routePage(pageName: pageRouteName, editName: editRouteName))
      };

    default:
      {
        throw ('AppRouteLayout is unknown!');
      }
  }
}

GoRouterPageBuilder noTransitionPage(
  Widget child,
) {
  return (BuildContext context, GoRouterState state) => NoTransitionPage<void>(
        name: state.name,
        key: state.pageKey,
        child: child,
      );
}

class BlubObserver extends NavigatorObserver {
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}
}

GoRouter _appRoute(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'start',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: '/document',
        name: 'document',
        builder: (context, state) => const Document(),
      ),
    ],
  );
}

GoRouter _mobile(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    // observers: [BlubObserver()],
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
              builder: (context, state) => SchuldKeuzePanel(),
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
  );
}

// class MyWidget extends ConsumerWidget {
//   const MyWidget({super.key});

//   @override
//   Widget build(BuildContext context, ref) {
//     return Scaffold(
//         body: SafeArea(
//       child: Column(
//         children: [
//           TextButton(
//               child: Text('go'),
//               onPressed: () {
//                 ref
//                     .read(routeDocumentProvider.notifier)
//                     .setEditRouteName(name: routeIncomeEdit);
//               }),
//           TextField()
//         ],
//       ),
//     ));
//   }
// }

GoRouter _page(String initialLocation) {
  return GoRouter(
    // observers: [BlubObserver()],
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'b',
        builder: (context, state) {
          return Container();
        },
      ),
      GoRoute(
          path: '/$routeIncome',
          name: routeIncome,
          // builder: (context, state) => MyWidget(),
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
            SchuldenOverzichtPanel(),
          ),
          routes: [
            GoRoute(
                path: '$routeDebtsEdit',
                name: routeDebtsEdit,
                pageBuilder: noTransitionPage(
                  SchuldKeuzePanel(),
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
}

GoRouter _mediumRoute() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'MediumDocument',
        builder: (context, state) => MediumDocument(),
      ),
    ],
  );
}

GoRouter _largeRoute() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'LargeDocument',
        builder: (context, state) => LargeRouteDocument(),
      ),
    ],
  );
}
