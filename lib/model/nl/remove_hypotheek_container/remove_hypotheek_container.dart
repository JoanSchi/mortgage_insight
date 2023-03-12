// import 'dart:convert';

// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mortgage_insight/model/nl/inkomen/inkomen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
// import '../../../utilities/date.dart';
// import '../schulden/schulden.dart';

// final sharedPrefs = FutureProvider<SharedPreferences>(
//     (_) async => await SharedPreferences.getInstance());

// final removeHypotheekContainerProvider = ChangeNotifierProvider((ref) {
//   String name = 'test'; //ref.watch(selectedProvider).document;

//   HypotheekContainer? container =
//       ref.read(sharedPrefs).whenOrNull<HypotheekContainer?>(data: (v) {
//     String? text = v.getString('${name}_hypotheek');

//     print('sharedPrefs when $text');

//     return text != null ? HypotheekContainer.fromJson(text) : null;
//   });

//   return HypotheekContainerChangeNotifier(container ?? HypotheekContainer());
// });

// class HypotheekContainerChangeNotifier extends ChangeNotifier {
//   HypotheekContainer container;
//   bool empty;

//   HypotheekContainerChangeNotifier(this.container, {this.empty: true});



//   /* Hypotheekprofielen
//    *
//    *
//    *
//    *
//    */

//   HypotheekProfielContainer? get huidigeHypotheekProfielContainer =>
//       container.hypotheekProfielen.profielContainer;

//   void removeHypotheek(RemoveHypotheek hypotheek) {
//     container.removeHypotheek(hypotheek);
//     notifyListeners();
//   }

//   /* Profiel
//    */
//   addHypotheekProfiel(RemoveHypotheekProfiel hypotheekProfiel) {
//     container.addProfiel(nieuwProfiel: hypotheekProfiel);
//     notifyListeners();
//   }

//   removeProfielHypotheek(RemoveHypotheekProfiel hypotheekProfiel) {
//     container.removeProfiel(profielID: hypotheekProfiel.id);
//     notifyListeners();
//   }

//   updateHypotheekProfiel(RemoveHypotheekProfiel hypotheekProfiel) {
//     container.updateHypotheekProfielContainer(hypotheekProfiel);
//     notifyListeners();
//   }

//   changeSelectedHypotheekContainerProfiel(String profielID) {
//     container.changeProfiel(profielID: profielID);
//     notifyListeners();
//   }

//   void saveHypotheekContainer() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String hi = container.toJson();
//     pref.setString('test_hypotheek', hi);
//     print('to shared');
//   }

//   void reset() {
//     container = HypotheekContainer();
//   }
// }

// class HypotheekContainer {
//   RemoveHypotheekProfielen hypotheekProfielen;


//   HypotheekContainer({
//     InkomensOverzicht? inkomen,
//     RemoveHypotheekProfielen? hypotheekProfielen,
//   })          hypotheekProfielen = hypotheekProfielen ?? RemoveHypotheekProfielen();

 


//   /* Hypotheekprofielen
//    *
//    *
//    *
//    *
//    */

//   addProfiel({required RemoveHypotheekProfiel nieuwProfiel}) {
//     hypotheekProfielen
//       ..add(nieuwProfiel)
//       ..updateProfielen();
//   }

//   removeProfiel({required String profielID}) {
//     hypotheekProfielen
//       ..remove(profielID: profielID)
//       ..updateProfielen();
//   }

//   changeProfiel({required String profielID}) {
//     hypotheekProfielen
//       ..change(profielID: profielID)
//       ..updateProfiel();
//   }

//   void removeHypotheek(RemoveHypotheek hypotheek) {
//     hypotheekProfielen
//       ..profielContainer?.profiel.removeHypotheek(hypotheek)
//       ..updateProfiel();
//   }

//   void updateHypotheekProfielContainer(
//       RemoveHypotheekProfiel hypotheekProfiel) {
//     hypotheekProfielen.updateHypotheekProfiel(hypotheekProfiel);
//   }

//   void updateHypotheekInkomens() {
//     hypotheekProfielen.profielen.forEach((key, value) {
//       // value.profiel.updateInkomens(
//       //     inkomenLijst: inkomen, inkomenPartnerLijst: inkomenPartner);
//     });
//   }

//   /* Json
//    *
//    *
//    *
//    *
//    */


// void resetHypotheekInzicht(WidgetRef ref) async {
//   SharedPreferences pref = await SharedPreferences.getInstance();
//   pref.remove('test');
//   ref.read(removeHypotheekContainerProvider).reset();
// }

