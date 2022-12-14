import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import '../../../utilities/date.dart';
import '../inkomen/inkomen.dart';
import '../schulden/schulden.dart';

final sharedPrefs = FutureProvider<SharedPreferences>(
    (_) async => await SharedPreferences.getInstance());

final hypotheekContainerProvider = ChangeNotifierProvider((ref) {
  String name = 'test'; //ref.watch(selectedProvider).document;

  HypotheekContainer? container =
      ref.read(sharedPrefs).whenOrNull<HypotheekContainer?>(data: (v) {
    String? text = v.getString('${name}_hypotheek');

    print('sharedPrefs when $text');

    return text != null ? HypotheekContainer.fromJson(text) : null;
  });

  return HypotheekContainerChangeNotifier(container ?? HypotheekContainer());
});

class HypotheekContainerChangeNotifier extends ChangeNotifier {
  HypotheekContainer container;
  bool empty;

  HypotheekContainerChangeNotifier(this.container, {this.empty: true});

  /* Inkomen
   *
   *
   *
   *
   */

  InkomenContainer inkomenContainer(bool partner) =>
      (partner ? container.inkomenPartner : container.inkomen);

  List<Inkomen> inkomenLijst({bool partner: false}) =>
      (partner ? container.inkomenPartner : container.inkomen).list;

  void addIncome(
      {required DateTime? oldDate,
      required Inkomen newItem,
      required bool partner}) {
    container.addIncome(oldDate: oldDate, newItem: newItem, partner: partner);
    container.updateHypotheekInkomens();
    notifyListeners();
  }

  void removeIncome({required Inkomen removeItem, required bool partner}) {
    container.removeIncome(removeItem: removeItem, partner: partner);
    container.updateHypotheekInkomens();
    notifyListeners();
  }

  // void updateIncome({required bool partner}) {
  //   container.updateInkomen(partner);
  // }

  /* Schulden
   *
   *
   *
   *
   */

  SchuldenContainer get schuldenContainer => container.schuldenContainer;

  addSchuld(Schuld schuld) {
    container.addSchuld(schuld);
    notifyListeners();
  }

  removeSchuld(Schuld schuld) {
    container.removeSchuld(schuld);
    notifyListeners();
  }

  updateSchulden() {
    updateSchulden();
    notifyListeners();
  }

  /* Hypotheekprofielen
   *
   *
   *
   *
   */

  HypotheekProfielContainer? get huidigeHypotheekProfielContainer =>
      container.hypotheekProfielen.profielContainer;

  void removeHypotheek(Hypotheek hypotheek) {
    container.removeHypotheek(hypotheek);
    notifyListeners();
  }

  /* Profiel
   */
  addHypotheekProfiel(HypotheekProfiel hypotheekProfiel) {
    container.addProfiel(nieuwProfiel: hypotheekProfiel);
    notifyListeners();
  }

  removeProfielHypotheek(HypotheekProfiel hypotheekProfiel) {
    container.removeProfiel(profielID: hypotheekProfiel.id);
    notifyListeners();
  }

  updateHypotheekProfiel(HypotheekProfiel hypotheekProfiel) {
    container.updateHypotheekProfielContainer(hypotheekProfiel);
    notifyListeners();
  }

  changeSelectedHypotheekContainerProfiel(String profielID) {
    container.changeProfiel(profielID: profielID);
    notifyListeners();
  }

  void saveHypotheekContainer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String hi = container.toJson();
    pref.setString('test_hypotheek', hi);
    print('to shared');
  }

  void reset() {
    container = HypotheekContainer();
  }
}

class HypotheekContainer {
  HypotheekProfielen hypotheekProfielen;
  InkomenContainer inkomen;
  InkomenContainer inkomenPartner;
  SchuldenContainer schuldenContainer;

  HypotheekContainer({
    InkomenContainer? inkomen,
    InkomenContainer? inkomenPartner,
    SchuldenContainer? schuldenContainer,
    HypotheekProfielen? hypotheekProfielen,
  })  : inkomen = inkomen ?? InkomenContainer(),
        inkomenPartner = inkomenPartner ?? InkomenContainer(),
        schuldenContainer = schuldenContainer ?? SchuldenContainer(),
        hypotheekProfielen = hypotheekProfielen ?? HypotheekProfielen();

  /* Inkomen
   *
   *
   *
   *
   */
  void addIncome(
      {required DateTime? oldDate,
      required Inkomen newItem,
      required bool partner}) {
    final list = (partner ? inkomenPartner : inkomen).list;

    if (oldDate != null) {
      final totalMonthsOldDate = oldDate.year * 12 + oldDate.month;

      list.removeWhere((element) {
        final totalMonths = element.datum.year * 12 + element.datum.month;
        return totalMonthsOldDate == totalMonths;
      });
    }

    merged:
    {
      int length = list.length;

      final totalMonthsNewItem = newItem.datum.year * 12 + newItem.datum.month;

      for (int i = 0; i < length; i++) {
        final element = list[i];

        final totalMonthsOfElement =
            element.datum.year * 12 + element.datum.month;

        if (totalMonthsNewItem == totalMonthsOfElement) {
          list[i] = newItem;
          break merged;
        } else if (totalMonthsNewItem < totalMonthsOfElement) {
          list.insert(i, newItem);
          break merged;
        }
      }

      list.add(newItem);
    }

    updateInkomen(partner);
  }

  void removeIncome({required Inkomen removeItem, required bool partner}) {
    final list = (partner ? inkomenPartner : inkomen).list;

    list.removeWhere((Inkomen element) {
      final totalMonthsOfElement =
          element.datum.year * 12 + element.datum.month;

      final totalMonthsNewItem =
          removeItem.datum.year * 12 + removeItem.datum.month;

      return totalMonthsOfElement == totalMonthsNewItem;
    });

    updateInkomen(partner);
  }

  updateInkomen(bool partner) {
    if (partner) {
      inkomenPartner = inkomenPartner.copyWith();
    } else {
      inkomen = inkomen.copyWith();
    }
  }

  /* Schulden
   *
   *
   *
   *
   */

  addSchuld(Schuld schuld) {
    final list = schuldenContainer.list;

    if (schuld.id == 0) {
      int dt = dateID;

      for (int i = 0; i < 998; i++) {
        if (list.indexWhere((Schuld s) => s.id == dt) == -1) {
          list.add(schuld..id = dt);
          break;
        }
        dt++;
      }
    } else {
      final index = list.indexWhere((Schuld s) => s.id == schuld.id);
      if (index == -1) {
        list.add(schuld);
      } else {
        list[index] = schuld;
      }
    }
    updateSchulden();
  }

  removeSchuld(Schuld schuld) {
    schuldenContainer.list.removeWhere((Schuld s) => s.id == schuld.id);
    updateSchulden();
  }

  updateSchulden() {
    schuldenContainer = schuldenContainer.copyWith();
  }

  /* Hypotheekprofielen
   *
   *
   *
   *
   */

  addProfiel({required HypotheekProfiel nieuwProfiel}) {
    hypotheekProfielen
      ..add(nieuwProfiel)
      ..updateProfielen();
  }

  removeProfiel({required String profielID}) {
    hypotheekProfielen
      ..remove(profielID: profielID)
      ..updateProfielen();
  }

  changeProfiel({required String profielID}) {
    hypotheekProfielen
      ..change(profielID: profielID)
      ..updateProfiel();
  }

  void removeHypotheek(Hypotheek hypotheek) {
    hypotheekProfielen
      ..profielContainer?.profiel.removeHypotheek(hypotheek)
      ..updateProfiel();
  }

  void updateHypotheekProfielContainer(HypotheekProfiel hypotheekProfiel) {
    hypotheekProfielen.updateHypotheekProfiel(hypotheekProfiel);
  }

  void updateHypotheekInkomens() {
    hypotheekProfielen.profielen.forEach((key, value) {
      // value.profiel.updateInkomens(
      //     inkomenLijst: inkomen, inkomenPartnerLijst: inkomenPartner);
    });
  }

  /* Json
   *
   *
   *
   *
   */

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hypotheekProfielen': hypotheekProfielen.toMap(),
      'inkomen': inkomen.toMap(),
      'inkomenPartner': inkomenPartner.toMap(),
      'schuldenContainer': schuldenContainer.toMap(),
    };
  }

  factory HypotheekContainer.fromMap(Map<String, dynamic> map) {
    return HypotheekContainer(
      hypotheekProfielen: HypotheekProfielen.fromMap(map['hypotheekProfielen']),
      inkomen: InkomenContainer.fromMap(map['inkomen']),
      inkomenPartner: InkomenContainer.fromMap(map['inkomenPartner']),
      schuldenContainer: SchuldenContainer.fromMap(map['schuldenContainer']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HypotheekContainer.fromJson(String source) =>
      HypotheekContainer.fromMap(json.decode(source));
}

void resetHypotheekInzicht(WidgetRef ref) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.remove('test');
  ref.read(hypotheekContainerProvider).reset();
}

class Test {
  Map<String, int> t;
  Test({
    required this.t,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      't': t,
    };
  }

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(
      t: Map<String, int>.from(map['t']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Test.fromJson(String source) => Test.fromMap(json.decode(source));
}
