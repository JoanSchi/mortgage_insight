import 'dart:collection';

import 'hypotheek.dart';

class HypotheekIterateItem extends LinkedListEntry<HypotheekIterateItem> {
  Hypotheek hypotheek;
  bool last = false;

  HypotheekIterateItem(this.hypotheek);

  List<Hypotheek> get parallelHypotheken =>
      list?.map((e) => e.hypotheek).where((Hypotheek e) {
        print(
            'id e ${e.id} id hypotheek ${hypotheek.id} not equal ${hypotheek != e} ${e.eindDatum.compareTo(hypotheek.startDatum)}');
        print('date e ${e.eindDatum}');
        print('date hypotheek ${hypotheek.startDatum}');
        print(
            'toevoegen ${e != hypotheek && e.eindDatum.compareTo(hypotheek.startDatum) > 0}');
        return e != hypotheek &&
            e.eindDatum.compareTo(hypotheek.startDatum) > 0;
      }).toList() ??
      const [];
}

class HypotheekIterator {
  List<Hypotheek> eersteHypotheken;
  Map<String, Hypotheek> hypotheken;

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
          print('returned hypotheek ${e.hypotheek.id}');
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
}
