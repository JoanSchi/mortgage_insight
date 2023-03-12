import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';

class MyRoutePage extends ConsumerStatefulWidget {
  const MyRoutePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyRoutePageState();
}

class _MyRoutePageState extends ConsumerState<MyRoutePage> {
  late final GoRouter? _router =
      ref.read(routeDocumentProvider).routes[AppRoutes.page];

  @override
  Widget build(BuildContext context) {
    final router = _router;

    return router == null
        ? const OhNo(text: 'Page router is not found')
        : Router(
            backButtonDispatcher: ChildBackButtonDispatcher(
                Router.of(context).backButtonDispatcher!)
              ..takePriority(),
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate);
  }
}
