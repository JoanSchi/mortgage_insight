import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'hypotheek.dart';

class HypotheekIterateItem extends LinkedListEntry<HypotheekIterateItem> {
  RemoveHypotheek hypotheek;
  bool last = false;

  HypotheekIterateItem(this.hypotheek);

  List<RemoveHypotheek> get parallelHypotheken =>
      list?.map((e) => e.hypotheek).where((RemoveHypotheek e) {
        debugPrint(
            'id e ${e.id} id hypotheek ${hypotheek.id} not equal ${hypotheek != e} ${e.eindDatum.compareTo(hypotheek.startDatum)}');
        debugPrint('date e ${e.eindDatum}');
        debugPrint('date hypotheek ${hypotheek.startDatum}');
        debugPrint(
            'toevoegen ${e != hypotheek && e.eindDatum.compareTo(hypotheek.startDatum) > 0}');
        return e != hypotheek &&
            e.eindDatum.compareTo(hypotheek.startDatum) > 0;
      }).toList() ??
      const [];
}

class HypotheekIterator {
  List<RemoveHypotheek> eersteHypotheken;
  Map<String, RemoveHypotheek> hypotheken;

  HypotheekIterator({required this.eersteHypotheken, required this.hypotheken});

  Iterable<RemoveHypotheek> all() sync* {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (RemoveHypotheek h in eersteHypotheken) {
      linkedList.add(HypotheekIterateItem(h));
    }

    while (true) {
      HypotheekIterateItem? iItem;

      for (HypotheekIterateItem e in linkedList) {
        if (iItem == null ||
            e.hypotheek.startDatum.compareTo(iItem.hypotheek.startDatum) < 0) {
          iItem = e;
        }
      }

      final HypotheekIterateItem? entry = iItem;

      if (entry == null) break;

      iItem = entry.next;

      if (entry.hypotheek.volgende.isNotEmpty) {
        entry.hypotheek = hypotheken[entry.hypotheek.volgende]!;
      } else {
        linkedList.remove(entry);
      }

      yield entry.hypotheek;
    }
  }

  HypotheekIterateItem onlyWithParallel(RemoveHypotheek hypotheek) {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (RemoveHypotheek h in eersteHypotheken) {
      linkedList.add(HypotheekIterateItem(h));
    }

    while (true) {
      HypotheekIterateItem? iItem;

      for (HypotheekIterateItem e in linkedList) {
        if (e.last) continue;

        if (e.hypotheek == hypotheek) {
          debugPrint('returned hypotheek ${e.hypotheek.id}');
          return e;
        }
        if (iItem == null ||
            e.hypotheek.startDatum.compareTo(iItem.hypotheek.startDatum) < 0) {
          iItem = e;
        }
      }

      final HypotheekIterateItem? entry = iItem;

      if (entry == null) break;

      iItem = entry.next;

      if (entry.hypotheek.volgende.isNotEmpty) {
        entry.hypotheek = hypotheken[entry.hypotheek.volgende]!;
      } else {
        entry.last = true;
      }
    }
    return HypotheekIterateItem(hypotheek);
  }

  Iterable<HypotheekIterateItem> parallel(
    RemoveHypotheek? vanaf,
  ) sync* {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (RemoveHypotheek h in eersteHypotheken) {
      linkedList.add(HypotheekIterateItem(h));
    }

    bool found = vanaf == null;

    while (true) {
      HypotheekIterateItem? iItem;

      for (HypotheekIterateItem e in linkedList) {
        if (e.last) continue;

        if (iItem == null ||
            e.hypotheek.startDatum.compareTo(iItem.hypotheek.startDatum) < 0) {
          iItem = e;
        }
      }

      final HypotheekIterateItem? entry = iItem;

      if (entry == null) break;

      iItem = entry.next;

      if (entry.hypotheek.volgende.isNotEmpty) {
        entry.hypotheek = hypotheken[entry.hypotheek.volgende]!;
      } else {
        entry.last = true;
      }

      if (found || entry.hypotheek == vanaf) {
        found = true;
        yield entry;
      }
    }
  }

  Iterable<HypotheekIterateItem> parallelTm(
      {RemoveHypotheek? vanaf, RemoveHypotheek? tm}) sync* {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (RemoveHypotheek h in eersteHypotheken) {
      linkedList.add(HypotheekIterateItem(h));
    }

    while (true) {
      HypotheekIterateItem? iItem;

      for (HypotheekIterateItem e in linkedList) {
        if (e.last) continue;

        if (iItem == null ||
            e.hypotheek.startDatum.compareTo(iItem.hypotheek.startDatum) < 0) {
          iItem = e;
        }
      }

      final HypotheekIterateItem? entry = iItem;

      if (entry == null) break;

      iItem = entry.next;

      if (entry.hypotheek.volgende.isNotEmpty) {
        entry.hypotheek = hypotheken[entry.hypotheek.volgende]!;
      } else {
        entry.last = true;
      }

      if (vanaf != null && vanaf == entry.hypotheek) {
        yield entry;
        vanaf = null;
      } else if (tm != null && tm == entry.hypotheek) {
        yield entry;
        break;
      } else {
        yield entry;
      }
    }
  }
}
