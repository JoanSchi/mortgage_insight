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
import 'package:animated_sliver_box/animated_sliver_box_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/vervolg_lening/vervolg_lening.dart';
import '../../../../my_widgets/animated_sliver_widgets/box_properties_constants.dart';
import '../../../../my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';

class VervolgHypotheekSliverBoxModel extends AnimatedSliverBoxModel<String> {
  VervolgHypotheekSliverBoxModel(
      {required super.sliverBoxContext,
      SingleBoxModel<String, VervolgHypotheekItemBoxProperties>? box,
      required super.axis,
      required super.duration})
      : boxList = [if (box != null) box];
  List<SingleBoxModel<String, VervolgHypotheekItemBoxProperties>> boxList;

  @override
  Iterable<SingleBoxModel<String, VervolgHypotheekItemBoxProperties>>
      iterator() => boxList;

  @override
  void disposeSingleModel(SingleBoxModel singleBoxModel) {}

  @override
  double? estimateMaxScrollOffset(
    int firstIndex,
    int lastIndex,
    double leadingScrollOffset,
    double trailingScrollOffset,
  ) {
    // final length =
    //     animalBoxList.fold(0, (value, element) => value + element.items.length);
    // // int count = 0;

    // if(length < 20){
    //   count++;
    // }else{
    //   if(lastIndex < 1){

    //   }else if(animalBoxList.fold(0.0, (0.0, element) => element.items.length));
    // }
    return trailingScrollOffset +
        (length - lastIndex - 1) * KostenItemBoxProperties.kostenHeightNormal;
  }
}

const dossierKostenTop = 128.0;
const dossierKostenBottom = 64.0;

const animalHeightSuggestion = 48.0;

class VervolgHypotheekItemBoxProperties extends BoxItemProperties {
  BoxPropertiesPanels panel;

  bool aliveOutsideView;
  bool transfer = false;
  double measuredWidthStandard = 0.0;
  bool _animateOnInitiation = false;

  VervolgLening vervolgLening;

  VervolgHypotheekItemBoxProperties({
    super.transitionStatus = BoxItemTransitionState.visible,
    required super.id,
    required this.panel,
    super.single = false,
    required this.vervolgLening,
    this.aliveOutsideView = false,
  });

  // fixPanel() {
  //   if (panel == BoxPropertiesPanels.standard) {
  //     transfer = false;
  //   }
  //   innerTransition = false;
  // }

  // setToPanel(BoxPropertiesPanels panel) {
  //   if (this.panel == panel) return;

  //   this.panel = panel;
  //   transfer = true;

  //   innerTransition = true;
  //   _animateOnInitiation = true;
  // }

  String idKey() => switch (vervolgLening) {
        (HerFinancieren hf) => 'herFinancieren_${hf.ids.toString()}',
        (LeningVerlengen lv) => 'verlengen_${lv.hypotheek.id}'
      };

  @override
  void garbageCollected(Axis axis) {
    panel = BoxPropertiesPanels.standard;
    transfer = false;
    innerTransition = false;
  }

  @override
  double? size(Axis axis) => switch (vervolgLening) {
        (HerFinancieren _) => 200.0,
        (LeningVerlengen _) => 300.0
      };

  @override
  bool useSizeOfChild(Axis axis) => panel == BoxPropertiesPanels.edit;

  @override
  void setMeasuredSize(Axis axis, double size) {
    measuredWidthStandard = size;
  }

  @override
  double suggestedSize(Axis axis) => size(axis) ?? measuredWidthStandard;

  @override
  void prepareForReBuild() {}

  bool get animateOnInitiation {
    final a = _animateOnInitiation;
    _animateOnInitiation = false;
    return a;
  }
}
