// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes_app.dart';

class HandleRoutes {
  static void setMainRoute(WidgetRef ref, String name) {
    ref.read(routeDocumentProvider.notifier).setMainName(name);
  }

  static void setRoutePage(WidgetRef ref, String name) {
    ref.read(routeDocumentProvider.notifier).setPageRouteName(name);
  }
}
