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

// final dataMortgageProvider = ChangeNotifierProvider((ref) {
//   String name = ref.watch(selectedProvider).document;

//   HypotheekItem? hi =
//       ref.watch(sharedPrefs).whenOrNull<HypotheekItem?>(data: (v) {
//     String? text = v.getString(name);

//     print('sharedPrefs when $text');

//     return text != null ? HypotheekItem.fromJson(text) : null;
//   });

//   if (hi == null) {
//     hi = HypotheekItem(name: 'de Wiemel 17');
//   }

//   return MortageData(hi);
// });

// class MortageData extends ChangeNotifier {
//   HypotheekItem list;

//   MortageData(this.list);

//   void addIncome(InkomenItem newItem, bool partner) {
//     final list = List<InkomenItem>.from(
//         partner ? current.inkomenPartner : current.inkomen);

//     merged:
//     {
//       int length = list.length;

//       final totalMonthsNewItem = newItem.datum.year * 12 + newItem.datum.month;

//       for (int i = 0; i < length; i++) {
//         final element = list[i];

//         final totalMonthsOfElement =
//             element.datum.year * 12 + element.datum.month;

//         if (totalMonthsNewItem == totalMonthsOfElement) {
//           list[i] = newItem;
//           break merged;
//         } else if (totalMonthsNewItem < totalMonthsOfElement) {
//           list.insert(i, newItem);
//           break merged;
//         }
//       }

//       list.add(newItem);
//     }

//     if (partner) {
//       current.inkomenPartner = list;
//     } else {
//       current.inkomen = list;
//     }

//     notifyListeners();
//   }

//   void removeIncome(InkomenItem newItem, bool partner) {
//     final list = List<InkomenItem>.from(
//         partner ? current.inkomenPartner : current.inkomen);

//     list.removeWhere((InkomenItem element) {
//       final totalMonthsOfElement =
//           element.datum.year * 12 + element.datum.month;

//       final totalMonthsNewItem = newItem.datum.year * 12 + newItem.datum.month;

//       return totalMonthsOfElement == totalMonthsNewItem;
//     });

//     if (partner) {
//       current.inkomenPartner = list;
//     } else {
//       current.inkomen = list;
//     }

//     notifyListeners();
//   }

//   HypotheekItem get current => list;
// }


