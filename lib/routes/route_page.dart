import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/routes/route_document.dart';

class MyRoutePage extends ConsumerWidget {
  const MyRoutePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter? r = ref.watch(routeDocumentProvider
        .select((value) => value.listOfRoutes[AppRoute.page]));

    return r == null
        ? OhNo(text: 'Page router is not found')
        : Router(
            backButtonDispatcher: ChildBackButtonDispatcher(
                Router.of(context).backButtonDispatcher!)
              ..takePriority(),
            routeInformationProvider: r.routeInformationProvider,
            routeInformationParser: r.routeInformationParser,
            routerDelegate: r.routerDelegate);
  }
}
