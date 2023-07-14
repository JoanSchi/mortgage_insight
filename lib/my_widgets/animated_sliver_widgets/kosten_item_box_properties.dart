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

import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:flutter/widgets.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';

import 'box_properties_constants.dart';

const dossierKostenTop = 128.0;
const dossierKostenBottom = 64.0;

const animalHeightSuggestion = 48.0;

class KostenItemBoxProperties extends BoxItemProperties {
  BoxPropertiesPanels panel;
  Waarde value;
  bool aliveOutsideView;
  bool transfer = false;
  static const kostenHeightNormal = 48.0;
  double measuredHeightStandard = 0.0;
  double measuredHeightEdit = 0.0;
  bool _animateOnInitiation = false;

  KostenItemBoxProperties({
    super.transitionStatus = BoxItemTransitionState.visible,
    required super.id,
    required this.panel,
    super.single = false,
    required this.value,
    this.aliveOutsideView = false,
  });

  fixPanel() {
    if (panel == BoxPropertiesPanels.standard) {
      transfer = false;
    }
    innerTransition = false;
  }

  setToPanel(BoxPropertiesPanels panel) {
    if (this.panel == panel) return;

    this.panel = panel;
    transfer = true;

    innerTransition = true;
    _animateOnInitiation = true;
  }

  String idKey() {
    return 'dossier_${id}_$panel';
  }

  @override
  void garbageCollected(Axis axis) {
    panel = BoxPropertiesPanels.standard;
    transfer = false;
    innerTransition = false;
  }

  @override
  double? size(Axis axis) {
    return panel == BoxPropertiesPanels.standard ? kostenHeightNormal : null;
  }

  @override
  bool useSizeOfChild(Axis axis) => panel == BoxPropertiesPanels.edit;

  @override
  void setMeasuredSize(Axis axis, double size) {
    if (panel == BoxPropertiesPanels.standard) {
      measuredHeightStandard = size;
    } else {
      measuredHeightEdit = size;
    }
  }

  @override
  double suggestedSize(Axis axis) =>
      size(axis) ??
      (panel == BoxPropertiesPanels.standard
          ? measuredHeightStandard
          : measuredHeightEdit);

  @override
  void prepareForReBuild() {}

  bool get animateOnInitiation {
    final a = _animateOnInitiation;
    _animateOnInitiation = false;
    return a;
  }

  setTransitionStatus(BoxItemTransitionState state) {
    transitionStatus = switch ((transitionStatus, state)) {
      (BoxItemTransitionState a, BoxItemTransitionState b)
          when a == BoxItemTransitionState.visible &&
              b == BoxItemTransitionState.appear =>
        BoxItemTransitionState.visible,
      (BoxItemTransitionState a, BoxItemTransitionState b)
          when a == BoxItemTransitionState.visible &&
              b == BoxItemTransitionState.disappear =>
        BoxItemTransitionState.invisible,
      (_, BoxItemTransitionState b) => b,
    };
  }
}
