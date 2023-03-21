import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../hypotheek_document.dart';
import 'hypotheek_dossier_notifier.dart';
import 'inkomen_notifier.dart';
import 'schuld_notifier.dart';

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

final hypotheekDocumentProvider =
    StateNotifierProvider<HypotheekDocumentNotifier, HypotheekDocument>((ref) {
  String name = 'test'; //ref.watch(selectedProvider).document;

  HypotheekDocument? document =
      ref.read(sharedPrefs).whenOrNull<HypotheekDocument?>(data: (v) {
    String? text = v.getString('${name}_hypotheek');

    debugPrint('sharedPrefs when $text');

    return text != null ? jsonDecode(text) : null;
  });

  return HypotheekDocumentNotifier(document ?? const HypotheekDocument());
});

class HypotheekDocumentNotifier extends StateNotifier<HypotheekDocument>
    with InkomenNotifier, SchuldNotifier, HypotheekDossierNotifier {
  HypotheekDocumentNotifier(HypotheekDocument document) : super(document);

  void saveHypotheekContainer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('test_hypotheek', jsonEncode(state));
    debugPrint('to shared');
  }

  void reset() {
    state = const HypotheekDocument();
  }
}
