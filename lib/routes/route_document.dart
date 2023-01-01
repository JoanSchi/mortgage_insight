// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../debts/debt_panel.dart';
import '../hypotheek/bewerken/hypotheek_bewerken.dart';
import '../hypotheek/hypotheek_panel.dart';
import '../hypotheek/profiel_bewerken/hypotheek_profiel_bewerken.dart';
import '../income/income_fields.dart';
import '../income/income_panel.dart';
import '../mobile/mobile_document.dart';
import '../state_manager/state_edit_object.dart';
import '../utilities/device_info.dart';
import 'routes_items.dart';

enum AppRouteLayout { mobile, large, unknown }

enum AppRoute { mobile, page }

void editRoute<T>(
    {required WidgetRef ref, required String name, required T edit}) {
  ref.read(routeDocumentProvider)._editRoute(name: name);
  ref.read(editObjectProvider.notifier).state = EditObject<T>(object: edit);
}

void setRoutePage({required WidgetRef ref, required String name}) {
  ref.read(routeDocumentProvider).pageRoute(name);
}

String watchRoutePage(WidgetRef ref) =>
    ref.watch(routeDocumentProvider.select((v) => v.pageRouteName));

bool watchSelectedRoutePage(WidgetRef ref, String name) =>
    ref.watch(routeDocumentProvider.select((v) => v.pageRouteName == name));

final routeDocumentProvider =
    StateNotifierProvider<RouteNotifier, RouteDocument>((ref) {
  return RouteNotifier(RouteDocument(read: ref.read));
});

class RouteNotifier extends StateNotifier<RouteDocument> {
  RouteNotifier(RouteDocument initial) : super(initial);
}

class RouteDocument {
  String pageRouteName = routeIncome;
  String editRouteName = '';
  Map<AppRoute, GoRouter> listOfRoutes = {};
  AppRouteLayout _appLayoutRoute = AppRouteLayout.unknown;
  FormFactorType _formFactorType = FormFactorType.Unknown;
  T Function<T>(ProviderListenable<T> provider) read;
  // StateNotifierProviderRef ref;

  RouteDocument({
    required this.read,
  });

  set formFactorType(FormFactorType formFactorType) {
    if (_formFactorType == formFactorType) {
      return;
    }
    _formFactorType = formFactorType;

    final a;

    switch (formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
        {
          a = AppRouteLayout.mobile;
          break;
        }

      case FormFactorType.Tablet:
      case FormFactorType.Monitor:
        {
          a = AppRouteLayout.large;
          break;
        }

      case FormFactorType.Unknown:
        {
          a = AppRouteLayout.unknown;
          break;
        }
    }

    if (_appLayoutRoute != a) {
      _appLayoutRoute = a;

      switch (a) {
        case AppRouteLayout.mobile:
          {
            listOfRoutes = {
              AppRoute.mobile: _mobile('/$editRouteName'),
              AppRoute.page: _page('/$pageRouteName')
            };
            break;
          }
        case AppRouteLayout.large:
          {
            listOfRoutes = {
              AppRoute.page: _page(
                  '/$pageRouteName ${editRouteName.isEmpty ? '' : '/$editRouteName'}')
            };

            break;
          }
        case AppRouteLayout.unknown:
          {
            throw ('AppRouteLayout is unknown!');
          }
      }
    }
  }

  FormFactorType get formFactorType => _formFactorType;

  void _editRoute<T>({
    required String name,
  }) {
    editRouteName = name;

    final AppRoute r;
    switch (_appLayoutRoute) {
      case AppRouteLayout.mobile:
        r = AppRoute.mobile;
        break;
      case AppRouteLayout.large:
        r = AppRoute.page;
        break;
      case AppRouteLayout.unknown:
        {
          throw ('AppRouteLayout is unknown!');
        }
    }

    listOfRoutes[r]?.pushNamed(name);
  }

  void pageRoute(String name) {
    pageRouteName = name;

    listOfRoutes[AppRoute.page]?.goNamed(name);
  }

  GoRouter _mobile(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      observers: [BlubObserver()],
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
    );
  }

  GoRouter _page(String initialLocation) {
    return GoRouter(
      observers: [BlubObserver()],
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
