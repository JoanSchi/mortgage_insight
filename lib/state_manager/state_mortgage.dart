import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

final selectedProvider = ChangeNotifierProvider((ref) {
  final date = DateTime.now();

  String dateString = '${date.year}${date.month}${date.day}';

  String? name = ref.watch(sharedPrefs).whenOrNull<String>(data: (v) {
    v.getKeys().forEach((v) {
      if (v.startsWith(dateString)) {}
    });

    return dateString;
  });
  if (name == null) {
    name = dateString;
  }

  return Selected(name);
});

class Selected extends ChangeNotifier {
  String document;
  bool empty;

  Selected(this.document, {this.empty: true});
}
