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

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

class MyTabBar extends TabBar {
  final FormFactorType formFactorType;

  const MyTabBar(
      {super.key,
      required this.formFactorType,
      required super.tabs,
      super.controller,
      super.padding});

  @override
  Size get preferredSize {
    double maxHeight = switch (formFactorType) {
      FormFactorType.tablet || FormFactorType.monitor => 56.0,
      _ => 46.0
    };

    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }
}
