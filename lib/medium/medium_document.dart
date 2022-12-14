import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/navigation/navigation_medium.dart';
import '../routes/my_go_route.dart';

class MediumRoute extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MediumRouteState();
}

class MediumRouteState extends ConsumerState<MediumRoute> {
  late MyGoRouter _router = MyGoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'MediumDocument',
        builder: (context, state) => MediumDocument(),
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

class MediumDocument extends StatefulWidget {
  MediumDocument({Key? key}) : super(key: key);

  @override
  State<MediumDocument> createState() => _MediumDocumentState();
}

class _MediumDocumentState extends State<MediumDocument> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // DeviceScreen3 deviceScreen = DeviceScreen3.of(context);

    return Scaffold(
        backgroundColor: theme.backgroundColor, body: MediumDrawer());
  }
}
