// ignore_for_file: public_member_api_docs, sort_constructors_first
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

import 'package:flutter/widgets.dart';

import '../utilities/device_info.dart';
import 'page_actions.dart';
import 'page_properties.dart';

class HypotheekPageProperties {
  List<MatchPageProperties<PageProperties>> list;

  HypotheekPageProperties({
    required this.list,
  });

  HypotheekPageProperties.standaard(
      {bool hasNavigationBar = false,
      double bottom = 0.0,
      List<PageActionItem> leftTopActions = const [],
      List<PageActionItem> rightTopActions = const []})
      : list = [
          MatchPageProperties<PageProperties>(
              types: {FormFactorType.monitor},
              pageProperties: PageProperties(
                  minExtent: 56.0,
                  floatingExtent: 72.0 + bottom,
                  maxExtent: 96.0 + bottom,
                  leftTopActions: leftTopActions,
                  rightTopActions: rightTopActions)),
          MatchPageProperties<PageProperties>(
              types: {FormFactorType.tablet},
              // orientations: {Orientation.landscape},
              pageProperties: PageProperties(
                  minExtent: 56.0 + bottom,
                  floatingExtent: 110.0 + bottom,
                  maxExtent: 160.0 + bottom,
                  leftTopActions: leftTopActions,
                  rightTopActions: rightTopActions)),
          MatchPageProperties<PageProperties>(
              types: {FormFactorType.largePhone, FormFactorType.smallPhone},
              orientations: {Orientation.landscape},
              pageProperties: PageProperties(
                  hasNavigationBar: hasNavigationBar,
                  minExtent: 0.0,
                  floatingExtent: 56.0,
                  maxExtent: 100.0,
                  leftTopActions: leftTopActions,
                  rightTopActions: rightTopActions)),
          MatchPageProperties<PageProperties>(
              types: {FormFactorType.largePhone, FormFactorType.smallPhone},
              orientations: {Orientation.portrait},
              pageProperties: PageProperties(
                  minExtent: 56.0,
                  floatingExtent: 112.0,
                  maxExtent: 200.0,
                  leftTopActions: leftTopActions,
                  rightTopActions: rightTopActions))
        ];

  PageProperties findPageProperties(
      bool useScrollBars, FormFactorType type, Orientation orientation) {
    int latestMatchPoints = -1;
    PageProperties? latestPageProperties;

    for (MatchPageProperties f in list) {
      final matchPoints = f.matchPoints(useScrollBars, type, orientation);

      if (matchPoints > latestMatchPoints) {
        if (matchPoints == MatchPageProperties.maxPoints) {
          return f.pageProperties;
        } else {
          latestMatchPoints = matchPoints;
          latestPageProperties = f.pageProperties;
        }
      }
    }

    return latestPageProperties ?? const PageProperties();
  }
}

PageProperties hypotheekPageProperties(
    {required bool hasScrollBars,
    required final FormFactorType formFactorType,
    required final Orientation orientation,
    required double bottom,
    bool hasNavigationBar = false,
    List<PageActionItem> leftTopActions = const [],
    List<PageActionItem> rightTopActions = const []}) {
  return switch ((formFactorType, orientation)) {
    (FormFactorType formFactorType, _)
        when formFactorType == FormFactorType.monitor =>
      PageProperties(
          minExtent: 56.0,
          floatingExtent: 72.0 + bottom,
          maxExtent: 96.0 + bottom,
          leftTopActions: leftTopActions,
          rightTopActions: rightTopActions),
    (FormFactorType formFactorType, _)
        when formFactorType == FormFactorType.tablet =>
      PageProperties(
          minExtent: 56.0 + bottom,
          floatingExtent: 110.0 + bottom,
          maxExtent: 160.0 + bottom,
          leftTopActions: leftTopActions,
          rightTopActions: rightTopActions),
    (_, Orientation.landscape) => PageProperties(
        hasNavigationBar: hasNavigationBar,
        minExtent: 0.0,
        floatingExtent: 56.0,
        maxExtent: 100.0,
        leftTopActions: leftTopActions,
        rightTopActions: rightTopActions),
    (_, Orientation.portrait) => PageProperties(
        minExtent: 56.0,
        floatingExtent: 112.0,
        maxExtent: 200.0,
        leftTopActions: leftTopActions,
        rightTopActions: rightTopActions),
  };
}
