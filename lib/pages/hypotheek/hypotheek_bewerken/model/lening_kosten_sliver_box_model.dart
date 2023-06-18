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

import '../../../../my_widgets/animated_sliver_widgets/edit_box_properties.dart';
import '../../../../my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';

class HypotheekKostenSliverBoxModel extends AnimatedSliverBoxModel<String> {
  HypotheekKostenSliverBoxModel(
      {required super.sliverBoxContext,
      required this.topBox,
      required this.dossierBox,
      required this.bottomBox,
      required super.axis,
      required super.duration});
  SingleBoxModel<String, EditableBoxProperties> topBox;
  SingleBoxModel<String, KostenItemBoxProperties> dossierBox;
  SingleBoxModel<String, BoxItemProperties> bottomBox;

  @override
  Iterable<SingleBoxModel> iterator() sync* {
    yield topBox;

    yield dossierBox;

    yield bottomBox;
  }

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
