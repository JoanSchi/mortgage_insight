import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';

class MyRoutePage extends ConsumerWidget {
  const MyRoutePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter? router = ref.watch(
        routeDocumentProvider.select((value) => value.routes[AppRoutes.page]));

    return router == null
        ? OhNo(text: 'Page router is not found')
        : Router(
            backButtonDispatcher: ChildBackButtonDispatcher(
                Router.of(context).backButtonDispatcher!)
              ..takePriority(),
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate);
  }
}
