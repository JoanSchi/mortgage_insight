import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/routes_items.dart';

final routeMainProvider = StateNotifierProvider<RouteMainState, String>((ref) {
  return RouteMainState('/');
});

class RouteMainState extends StateNotifier<String> {
  RouteMainState(String initial) : super(initial);

  set mainRoute(String route) {
    state = route;
  }

  String get mainRoute => state;
}

final routePageProvider = StateNotifierProvider<RoutePageState, String>((ref) {
  return RoutePageState(routeIncome);
});

class RoutePageState extends StateNotifier<String> {
  RoutePageState(String initial) : super(initial);

  set pageRoute(String route) {
    state = route;
  }

  String get pageRoute => state;
}

class EditRouteState<T> {
  String route;
  T? object;

  EditRouteState({
    this.route = '',
    this.object,
  });

  void clear() {
    route = '';
    object = null;
  }
}

final routeEditPageProvider =
    StateNotifierProvider<RouteEditPageState, EditRouteState>((ref) {
  return RouteEditPageState(EditRouteState());
});

class RouteEditPageState extends StateNotifier<EditRouteState> {
  RouteEditPageState(EditRouteState initial) : super(initial);

  set editState(EditRouteState route) {
    // assert((route != null && state == null) || (route == null && state != null),
    //     'EditRouteState: route is null: ${route == null} state is null: ${state == null} ');

    state = route;
  }

  clear() {
    state.clear();
  }

  EditRouteState get editState => state;
}

final pageHypotheekProvider = ChangeNotifierProvider<PageHypotheekState>((ref) {
  return PageHypotheekState();
});

class PageHypotheekState extends ChangeNotifier {
  int _page = -1;

  PageHypotheekState();

  set page(int value) {
    _page = value;
    notifyListeners();
  }

  int get page => _page;

  pageNotify() {
    notifyListeners();
  }
}
