import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/navigation/navigation_large.dart';
import '../routes/my_go_route.dart';

class LargeRoute extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LargeRouteState();
}

class LargeRouteState extends ConsumerState<LargeRoute> {
  late MyGoRouter _router = MyGoRouter(
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
  )..addDidPopListener(didPop);

  String get initialLocation {
    // String? subRoute = ref.read(routeEditPageProvider)?.route;

    // String route = (subRoute == null) ? '/' : '/$subRoute';

    // debugPrint('initialLocation Mobile: $route');

    return '/';
  }

  @override
  void dispose() {
    _router.removeDidPopListener(didPop);
    super.dispose();
  }

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // if ((route.settings.name ?? '').contains('Edit')) {
    //   scheduleMicrotask(() {
    //     ref.read(routeEditPageProvider.notifier).editState = null;
    //   });
    // }
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
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate);
  }
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
