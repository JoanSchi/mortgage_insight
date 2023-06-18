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

import 'package:flutter/material.dart';
import 'aflopend_krediet_segmenten.dart';
import 'aflopend_krediet_overview.dart';
import 'aflopend_krediet_tabel.dart';

class AflopendKredietPanel extends StatelessWidget {
  final EdgeInsets padding;
  final Widget? appBar;

  const AflopendKredietPanel({
    super.key,
    required this.padding,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (appBar != null) appBar!,
        SliverPadding(
          padding: padding.copyWith(bottom: 0.0),
          sliver: const SliverList(
              delegate: SliverChildListDelegate.fixed(
            [
              AflopendKredietOptiePanel(),
              Divider(),
              AflopendkredietInvulPanel(),
              OverzichtLening(),
              AflopendKredietErrorWidget(),
            ],
          )),
        ),
        SliverPadding(
            padding: padding.copyWith(top: 0.0),
            sliver: const AflopendKredietTabel()),
      ],
    );
  }
}
