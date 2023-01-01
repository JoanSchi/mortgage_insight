import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/navigation/navigation_medium.dart';

class MediumRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MediumRouteState();
}

class MediumRouteState extends State<MediumRoute> {
  GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'MediumDocument',
        builder: (context, state) => MediumDocument(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
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
