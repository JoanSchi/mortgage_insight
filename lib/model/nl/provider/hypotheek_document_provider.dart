import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek_document/hypotheek_document.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'hypotheek_dossier_notifier.dart';
import 'inkomen_notifier.dart';
import 'schuld_notifier.dart';

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

final hypotheekDocumentProvider =
    StateNotifierProvider<HypotheekDocumentNotifier, HypotheekDocument>((ref) {
  HypotheekDocument? document; // =
  //     ref.watch(sharedPrefs).whenOrNull<HypotheekDocument?>(data: (v) {
  //   String? text = v.getString('test_hypotheek');

  //   debugPrint('Hypotheek ${text == null ? 'not' : ''} found in sharedPrefs');

  //   return text != null ? HypotheekDocument.fromJson(jsonDecode(text)) : null;
  // });

  return HypotheekDocumentNotifier(document ?? const HypotheekDocument());
});

class HypotheekDocumentNotifier extends StateNotifier<HypotheekDocument>
    with InkomenNotifier, SchuldNotifier, HypotheekDossierNotifier {
  HypotheekDocumentNotifier(HypotheekDocument document) : super(document);

  void saveHypotheek() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('test_hypotheek', jsonEncode(state));
    debugPrint('hypotheek saved to shared');
  }

  void reset() {
    state = const HypotheekDocument();
  }

  void openHypotheek() {
    SharedPreferences.getInstance().then((value) {
      String? text = value.getString('test_hypotheek');

      debugPrint('sharedPrefs when $text');

      if (text != null) {
        state = HypotheekDocument.fromJson(jsonDecode(text));
      }
    });
  }
}
