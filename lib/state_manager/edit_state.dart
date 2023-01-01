import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routes/routes_items.dart';

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
