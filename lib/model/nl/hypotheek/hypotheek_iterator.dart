import 'dart:collection';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';

import 'gegevens/hypotheek/hypotheek.dart';

class HypotheekIterateItem extends LinkedListEntry<HypotheekIterateItem> {
  Hypotheek hypotheek;
  bool last = false;

  HypotheekIterateItem(this.hypotheek);

  List<Hypotheek> get parallelHypotheken =>
      list?.map((e) => e.hypotheek).where((Hypotheek e) {
        // debugPrint(
        //     'id e ${e.id} id hypotheek ${hypotheek.id} not equal ${hypotheek != e} ${e.eindDatum.compareTo(hypotheek.startDatum)}');
        // debugPrint('date e ${e.eindDatum}');
        // debugPrint('date hypotheek ${hypotheek.startDatum}');
        // debugPrint(
        //     'toevoegen ${e != hypotheek && e.eindDatum.compareTo(hypotheek.startDatum) > 0}');
        return //e != hypotheek &&
            e.eindDatum.compareTo(hypotheek.startDatum) > 0;
      }).toList() ??
      const [];
}

class HypotheekIterator {
  IList<Hypotheek> eersteHypotheken;
  IMap<String, Hypotheek> hypotheken;

  HypotheekIterator({required this.eersteHypotheken, required this.hypotheken});

  Iterable<Hypotheek> all() sync* {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (Hypotheek h in eersteHypotheken) {
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

  HypotheekIterateItem onlyWithParallel(Hypotheek hypotheek) {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (Hypotheek h in eersteHypotheken) {
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

  Iterable<HypotheekIterateItem> parallelMetStartDatum(
    Hypotheek? vanaf,
  ) sync* {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (Hypotheek h in eersteHypotheken) {
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
      {Hypotheek? vanaf, Hypotheek? tm}) sync* {
    LinkedList<HypotheekIterateItem> linkedList = LinkedList();

    for (Hypotheek h in eersteHypotheken) {
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

  Iterable<Hypotheek> parallelStartDatum(DateTime startDatum) sync* {
    for (Hypotheek hypotheek in eersteHypotheken) {
      //Eerste parallele hypotheek startDatum komt later, daarom overslaan
      if (hypotheek.startDatum.compareTo(startDatum) < 0) {
        continue;
      }

      Hypotheek? h = hypotheek;

      while (h != null) {
        //Als parallele eindDatum later is dan de startDatum, dan valt startDatum binnen periode van de paralelle hypotheek.
        if (startDatum.compareTo(h.eindDatum) < 0) {
          yield h;
          break;
        }

        if (h.volgende.isNotEmpty) {
          h = hypotheken[h.volgende]!;
        }
      }
    }
  }
}
