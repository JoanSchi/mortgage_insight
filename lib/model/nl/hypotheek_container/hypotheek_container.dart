import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/inkomen/inkomen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import '../../../utilities/date.dart';
import '../schulden/remove_schulden.dart';
import '../schulden/schulden.dart';
import '../schulden/schulden.dart';
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

  InkomensOverzicht inkomenContainer(bool partner) =>
      (partner ? container.inkomenPartner : container.inkomen);

  IList<Inkomen> inkomenLijst({bool partner: false}) =>
      (partner ? container.inkomenPartner : container.inkomen).lijst;

  void addInkomen({
    required DateTime? oldDate,
    required Inkomen newItem,
  }) {
    container.addInkomen(
      oldDate: oldDate,
      newItem: newItem,
    );
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

  SchuldenOverzicht get schuldenOverzicht => container.schuldenOverzicht;

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
  InkomensOverzicht inkomen;
  InkomensOverzicht inkomenPartner;
  SchuldenOverzicht schuldenOverzicht;

  HypotheekContainer({
    InkomensOverzicht? inkomen,
    InkomensOverzicht? inkomenPartner,
    SchuldenOverzicht? schuldenOverzicht,
    HypotheekProfielen? hypotheekProfielen,
  })  : inkomen = inkomen ?? InkomensOverzicht(lijst: IList()),
        inkomenPartner = inkomenPartner ?? InkomensOverzicht(lijst: IList()),
        schuldenOverzicht =
            schuldenOverzicht ?? SchuldenOverzicht(lijst: IList()),
        hypotheekProfielen = hypotheekProfielen ?? HypotheekProfielen();

  /* Inkomen
   *
   *
   *
   *
   */
  void addInkomen({
    required DateTime? oldDate,
    required Inkomen newItem,
  }) {
    IList<Inkomen> list = (newItem.partner ? inkomenPartner : inkomen).lijst;

    if (oldDate != null) {
      final totalMonthsOldDate = oldDate.year * 12 + oldDate.month;

      list = list.removeWhere((element) {
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
          list = list.replace(i, newItem);
          break merged;
        } else if (totalMonthsNewItem < totalMonthsOfElement) {
          list = list.insert(i, newItem);
          break merged;
        }
      }

      list = list.add(newItem);
    }

    if (newItem.partner) {
      inkomenPartner = inkomenPartner.copyWith(lijst: list);
    } else {
      inkomen = inkomen.copyWith(lijst: list);
    }
  }

  void removeIncome({required Inkomen removeItem, required bool partner}) {
    IList<Inkomen> list = (partner ? inkomenPartner : inkomen).lijst;

    list = list.removeWhere((Inkomen element) {
      final totalMonthsOfElement =
          element.datum.year * 12 + element.datum.month;

      final totalMonthsNewItem =
          removeItem.datum.year * 12 + removeItem.datum.month;

      return totalMonthsOfElement == totalMonthsNewItem;
    });

    if (partner) {
      inkomenPartner = inkomenPartner.copyWith(lijst: list);
    } else {
      inkomen = inkomen.copyWith(lijst: list);
    }
  }

  /* Schulden
   *
   *
   *
   *
   */

  addSchuld(Schuld schuld) {
    var list = schuldenOverzicht.lijst;

    if (schuld.id == -1) {
      int dt = dateID;

      while (true) {
        if (list.indexWhere((Schuld s) => s.id == dt) == -1) {
          list = list.add(schuld.copyWith(id: dt));
          break;
        }
        dt++;
      }
    } else {
      final index = list.indexWhere((Schuld s) => s.id == schuld.id);
      if (index == -1) {
        list = list.add(schuld);
      } else {
        list.replace(index, schuld);
      }
    }
    schuldenOverzicht = schuldenOverzicht.copyWith(lijst: list);
  }

  removeSchuld(Schuld schuld) {
    schuldenOverzicht = schuldenOverzicht.copyWith(
        lijst: schuldenOverzicht.lijst
            .removeWhere((Schuld s) => s.id == schuld.id));
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
      'inkomen': inkomen.toJson(),
      'inkomenPartner': inkomenPartner.toJson(),
      'schuldenOverzicht': schuldenOverzicht.toJson(),
    };
  }

  factory HypotheekContainer.fromMap(Map<String, dynamic> map) {
    return HypotheekContainer(
      hypotheekProfielen: HypotheekProfielen.fromMap(map['hypotheekProfielen']),
      inkomen: InkomensOverzicht.fromJson(map['inkomen']),
      inkomenPartner: InkomensOverzicht.fromJson(map['inkomenPartner']),
      schuldenOverzicht: SchuldenOverzicht.fromJson(map['schuldenOverzicht']),
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
