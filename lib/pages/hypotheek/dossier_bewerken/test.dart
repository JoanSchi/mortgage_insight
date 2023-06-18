// Copyright (C) 2023 Joan Schipper
//
// This file is part of mortgage_insight.
//
// mortgage_insight is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// mortgage_insight is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class TestReadingOrderTraversalPolicy extends FocusTraversalPolicy
    with DirectionalFocusTraversalPolicyMixin {
  // Collects the given candidates into groups by directionality. The candidates
  // have already been sorted as if they all had the directionality of the
  // nearest Directionality ancestor.
  List<_ReadingOrderDirectionalGroupData> _collectDirectionalityGroups(
      Iterable<_ReadingOrderSortData> candidates) {
    TextDirection? currentDirection = candidates.first.directionality;
    List<_ReadingOrderSortData> currentGroup = <_ReadingOrderSortData>[];
    final List<_ReadingOrderDirectionalGroupData> result =
        <_ReadingOrderDirectionalGroupData>[];
    // Split candidates into runs of the same directionality.
    for (final _ReadingOrderSortData candidate in candidates) {
      if (candidate.directionality == currentDirection) {
        currentGroup.add(candidate);
        continue;
      }
      currentDirection = candidate.directionality;
      result.add(_ReadingOrderDirectionalGroupData(currentGroup));
      currentGroup = <_ReadingOrderSortData>[candidate];
    }
    if (currentGroup.isNotEmpty) {
      result.add(_ReadingOrderDirectionalGroupData(currentGroup));
    }
    // Sort each group separately. Each group has the same directionality.
    for (final _ReadingOrderDirectionalGroupData bandGroup in result) {
      if (bandGroup.members.length == 1) {
        continue; // No need to sort one node.
      }
      _ReadingOrderSortData.sortWithDirectionality(
          bandGroup.members, bandGroup.directionality!);
    }
    return result;
  }

  _ReadingOrderSortData _pickNext(List<_ReadingOrderSortData> candidates) {
    // Find the topmost node by sorting on the top of the rectangles.
    mergeSort<_ReadingOrderSortData>(candidates,
        compare: (_ReadingOrderSortData a, _ReadingOrderSortData b) =>
            a.rect.top.compareTo(b.rect.top));
    final _ReadingOrderSortData topmost = candidates.first;

    // Find the candidates that are in the same horizontal band as the current one.
    List<_ReadingOrderSortData> inBand(_ReadingOrderSortData current,
        Iterable<_ReadingOrderSortData> candidates) {
      final Rect band = Rect.fromLTRB(double.negativeInfinity, current.rect.top,
          double.infinity, current.rect.bottom);
      return candidates.where((_ReadingOrderSortData item) {
        return !item.rect.intersect(band).isEmpty;
      }).toList();
    }

    final List<_ReadingOrderSortData> inBandOfTop = inBand(topmost, candidates);
    // It has to have at least topmost in it if the topmost is not degenerate.
    assert(topmost.rect.isEmpty || inBandOfTop.isNotEmpty);

    // The topmost rect is in a band by itself, so just return that one.
    if (inBandOfTop.length <= 1) {
      return topmost;
    }

    // Now that we know there are others in the same band as the topmost, then pick
    // the one at the beginning, depending on the text direction in force.

    // Find out the directionality of the nearest common Directionality
    // ancestor for all nodes. This provides a base directionality to use for
    // the ordering of the groups.
    final TextDirection? nearestCommonDirectionality =
        _ReadingOrderSortData.commonDirectionalityOf(inBandOfTop);

    // Do an initial common-directionality-based sort to get consistent geometric
    // ordering for grouping into directionality groups. It has to use the
    // common directionality to be able to group into sane groups for the
    // given directionality, since rectangles can overlap and give different
    // results for different directionalities.
    _ReadingOrderSortData.sortWithDirectionality(
        inBandOfTop, nearestCommonDirectionality!);

    // Collect the top band into internally sorted groups with shared directionality.
    final List<_ReadingOrderDirectionalGroupData> bandGroups =
        _collectDirectionalityGroups(inBandOfTop);
    if (bandGroups.length == 1) {
      // There's only one directionality group, so just send back the first
      // one in that group, since it's already sorted.
      return bandGroups.first.members.first;
    }

    // Sort the groups based on the common directionality and bounding boxes.
    _ReadingOrderDirectionalGroupData.sortWithDirectionality(
        bandGroups, nearestCommonDirectionality);
    return bandGroups.first.members.first;
  }

  // Sorts the list of nodes based on their geometry into the desired reading
  // order based on the directionality of the context for each node.
  @override
  Iterable<FocusNode> sortDescendants(
      Iterable<FocusNode> descendants, FocusNode currentNode) {
    if (descendants.length <= 1) {
      return descendants;
    }

    final List<_ReadingOrderSortData> data = <_ReadingOrderSortData>[
      for (final FocusNode node in descendants) _ReadingOrderSortData(node),
    ];

    final List<FocusNode> sortedList = <FocusNode>[];
    final List<_ReadingOrderSortData> unplaced = data;

    // Pick the initial widget as the one that is at the beginning of the band
    // of the topmost, or the topmost, if there are no others in its band.
    _ReadingOrderSortData current = _pickNext(unplaced);
    sortedList.add(current.node);
    unplaced.remove(current);

    // Go through each node, picking the next one after eliminating the previous
    // one, since removing the previously picked node will expose a new band in
    // which to choose candidates.
    while (unplaced.isNotEmpty) {
      final _ReadingOrderSortData next = _pickNext(unplaced);
      current = next;
      sortedList.add(current.node);
      unplaced.remove(current);
    }

    return sortedList;
  }
}

class _ReadingOrderSortData with Diagnosticable {
  _ReadingOrderSortData(this.node)
      : rect = node.rect,
        directionality = _findDirectionality(node.context!);

  final TextDirection? directionality;
  final Rect rect;
  final FocusNode node;

  // Find the directionality in force for a build context without creating a
  // dependency.
  static TextDirection? _findDirectionality(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<Directionality>()
        ?.textDirection;
  }

  /// Finds the common Directional ancestor of an entire list of groups.
  static TextDirection? commonDirectionalityOf(
      List<_ReadingOrderSortData> list) {
    final Iterable<Set<Directionality>> allAncestors =
        list.map<Set<Directionality>>((_ReadingOrderSortData member) =>
            member.directionalAncestors.toSet());
    Set<Directionality>? common;
    for (final Set<Directionality> ancestorSet in allAncestors) {
      common ??= ancestorSet;
      common = common.intersection(ancestorSet);
    }
    if (common!.isEmpty) {
      // If there is no common ancestor, then arbitrarily pick the
      // directionality of the first group, which is the equivalent of the
      // "first strongly typed" item in a bidirectional algorithm.
      return list.first.directionality;
    }
    // Find the closest common ancestor. The memberAncestors list contains the
    // ancestors for all members, but the first member's ancestry was
    // added in order from nearest to furthest, so we can still use that
    // to determine the closest one.
    return list.first.directionalAncestors
        .firstWhere(common.contains)
        .textDirection;
  }

  static void sortWithDirectionality(
      List<_ReadingOrderSortData> list, TextDirection directionality) {
    mergeSort<_ReadingOrderSortData>(list,
        compare: (_ReadingOrderSortData a, _ReadingOrderSortData b) {
      switch (directionality) {
        case TextDirection.ltr:
          return a.rect.left.compareTo(b.rect.left);
        case TextDirection.rtl:
          return b.rect.right.compareTo(a.rect.right);
      }
    });
  }

  /// Returns the list of Directionality ancestors, in order from nearest to
  /// furthest.
  Iterable<Directionality> get directionalAncestors {
    List<Directionality> getDirectionalityAncestors(BuildContext context) {
      final List<Directionality> result = <Directionality>[];
      InheritedElement? directionalityElement =
          context.getElementForInheritedWidgetOfExactType<Directionality>();
      while (directionalityElement != null) {
        result.add(directionalityElement.widget as Directionality);
        directionalityElement = _getAncestor(directionalityElement)
            ?.getElementForInheritedWidgetOfExactType<Directionality>();
      }
      return result;
    }

    _directionalAncestors ??= getDirectionalityAncestors(node.context!);
    return _directionalAncestors!;
  }

  List<Directionality>? _directionalAncestors;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextDirection>('directionality', directionality));
    properties.add(StringProperty('name', node.debugLabel, defaultValue: null));
    properties.add(DiagnosticsProperty<Rect>('rect', rect));
  }
}

// A class for containing group data while sorting in reading order while taking
// into account the ambient directionality.
class _ReadingOrderDirectionalGroupData with Diagnosticable {
  _ReadingOrderDirectionalGroupData(this.members);

  final List<_ReadingOrderSortData> members;

  TextDirection? get directionality => members.first.directionality;

  Rect? _rect;
  Rect get rect {
    if (_rect == null) {
      for (final Rect rect
          in members.map<Rect>((_ReadingOrderSortData data) => data.rect)) {
        _rect ??= rect;
        _rect = _rect!.expandToInclude(rect);
      }
    }
    return _rect!;
  }

  List<Directionality> get memberAncestors {
    if (_memberAncestors == null) {
      _memberAncestors = <Directionality>[];
      for (final _ReadingOrderSortData member in members) {
        _memberAncestors!.addAll(member.directionalAncestors);
      }
    }
    return _memberAncestors!;
  }

  List<Directionality>? _memberAncestors;

  static void sortWithDirectionality(
      List<_ReadingOrderDirectionalGroupData> list,
      TextDirection directionality) {
    mergeSort<_ReadingOrderDirectionalGroupData>(list, compare:
        (_ReadingOrderDirectionalGroupData a,
            _ReadingOrderDirectionalGroupData b) {
      switch (directionality) {
        case TextDirection.ltr:
          return a.rect.left.compareTo(b.rect.left);
        case TextDirection.rtl:
          return b.rect.right.compareTo(a.rect.right);
      }
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<TextDirection>('directionality', directionality));
    properties.add(DiagnosticsProperty<Rect>('rect', rect));
    properties.add(IterableProperty<String>('members',
        members.map<String>((_ReadingOrderSortData member) {
      return '"${member.node.debugLabel}"(${member.rect})';
    })));
  }
}

BuildContext? _getAncestor(BuildContext context, {int count = 1}) {
  BuildContext? target;
  context.visitAncestorElements((Element ancestor) {
    count--;
    if (count == 0) {
      target = ancestor;
      return false;
    }
    return true;
  });
  return target;
}
