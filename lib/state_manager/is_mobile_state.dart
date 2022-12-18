// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routes/routes_items.dart';

final isMobileProvider = Provider<bool>((ref) {
  return true;
});

class Route {
  String route;

  Route({
    required this.route,
  });
}

final pageProvider = Provider<Route>((ref) => Route(route: routeIncome));

final editProvider = Provider<Route>((ref) => Route(route: ''));
