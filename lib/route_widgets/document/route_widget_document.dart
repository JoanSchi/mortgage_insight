import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../my_widgets/oh_no.dart';
import '../../state_manager/routes/routes_app.dart';
import '../../theme/theme.dart';

class Document extends ConsumerStatefulWidget {
  const Document({Key? key}) : super(key: key);

  @override
  ConsumerState<Document> createState() => _DocumentState();
}

class _DocumentState extends ConsumerState<Document> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 30), () async {
      print('delay');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('test3', 'hihi');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Document oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    GoRouter? router = ref.watch(routeDocumentProvider
        .select((value) => value.routes[AppRoutes.document]));

    body = router == null
        ? OhNo(text: 'AppRoute main is not found.')
        : Router(
            backButtonDispatcher: ChildBackButtonDispatcher(
                Router.of(context).backButtonDispatcher!)
              ..takePriority(),
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate);

    return Theme(data: buildFactorTheme(context), child: body);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        ref.read(hypotheekContainerProvider).saveHypotheekContainer();
        break;
      case AppLifecycleState.detached:
        ref.read(hypotheekContainerProvider).saveHypotheekContainer();
        break;
    }
  }
}
