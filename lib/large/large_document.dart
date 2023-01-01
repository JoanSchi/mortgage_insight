import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/navigation/navigation_large.dart';

class LargeRoute extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LargeRouteState();
}

class LargeRouteState extends ConsumerState<LargeRoute> {
  GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'LargeDocument',
        builder: (context, state) => LargeDocument(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Router(
        backButtonDispatcher:
            ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
              ..takePriority(),
        routeInformationProvider: _router.routeInformationProvider,
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
