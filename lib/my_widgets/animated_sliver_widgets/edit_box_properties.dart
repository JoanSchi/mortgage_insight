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

import 'box_properties_constants.dart';

class EditableBoxProperties extends BoxItemProperties {
  BoxPropertiesPanels panel;
  double sizeStandardPanel;
  bool useSizeChildStandardPanel;
  double _measuredSizeEditPanel = 0.0;
  double _measuredSizeStandardPanel = 0.0;
  bool _animateOnInitiation = false;

  EditableBoxProperties({
    super.transitionStatus = BoxItemTransitionState.visible,
    required super.id,
    required this.panel,
    this.useSizeChildStandardPanel = false,
    required this.sizeStandardPanel,
    super.single = false,
  });

  fixPanel() {
    if (panel == BoxPropertiesPanels.standard) {
      innerTransition = false;
    }
  }

  setToPanel(BoxPropertiesPanels panel) {
    this.panel = panel;
    innerTransition = true;
    _animateOnInitiation = true;
  }

  bool get animateOnInitiation {
    final a = _animateOnInitiation;
    _animateOnInitiation = false;
    return a;
  }

  String idKey() {
    return 'dossier_${id}_$panel';
  }

  @override
  void garbageCollected(Axis axis) {
    panel = BoxPropertiesPanels.standard;
    innerTransition = false;
  }

  @override
  double? size(Axis axis) {
    return panel == BoxPropertiesPanels.standard ? sizeStandardPanel : null;
  }

  @override
  bool useSizeOfChild(Axis axis) =>
      useSizeChildStandardPanel || panel == BoxPropertiesPanels.edit;

  @override
  void setMeasuredSize(Axis axis, double size) {
    if (panel == BoxPropertiesPanels.standard) {
      _measuredSizeStandardPanel = size;
    } else {
      _measuredSizeEditPanel = size;
    }
  }

  double get measuredSize => panel == BoxPropertiesPanels.standard
      ? _measuredSizeStandardPanel
      : _measuredSizeEditPanel;

  @override
  double suggestedSize(Axis axis) => size(axis) ?? measuredSize;

  @override
  void prepareForReBuild() {}
}
