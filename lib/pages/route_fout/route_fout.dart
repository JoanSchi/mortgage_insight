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

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

enum RouteFoutOpties { wegkwijt, afsnijden }

class RouteFout extends StatelessWidget {
  final RouteFoutOpties routeFoutOpties;
  const RouteFout({super.key, this.routeFoutOpties = RouteFoutOpties.wegkwijt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displaySmall = theme.textTheme.displaySmall;

    final deviceScreen3 = DeviceScreen3.of(context);

    final padding =
        switch ((deviceScreen3.formFactorType, deviceScreen3.orientation)) {
      (FormFactorType type, Orientation orientation)
          when type == FormFactorType.smallPhone ||
              type == FormFactorType.largePhone =>
        orientation == Orientation.portrait
            ? const EdgeInsets.only(bottom: 56.0)
            : const EdgeInsets.only(left: 56.0),
      (_) => EdgeInsets.zero
    };

    return SafeArea(
      minimum: padding,
      child: Stack(children: [
        Positioned(
            left: 16.0,
            top: 16.0,
            height: 64.0,
            right: 16,
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                switch (routeFoutOpties) {
                  RouteFoutOpties.wegkwijt => 'Route niet gevonden',
                  RouteFoutOpties.afsnijden =>
                    'Route afgesneden / Pagina ververst?'
                },
                softWrap: true,
                textAlign: TextAlign.center,
                style: displaySmall,
              ),
            )),
        Positioned(
            left: 16.0,
            top: 80.0,
            bottom: 16.0,
            right: 16,
            child: FittedBox(
                fit: BoxFit.contain,
                child: switch (routeFoutOpties) {
                  RouteFoutOpties.wegkwijt =>
                    Image.asset('graphics/dewegkwijt.png'),
                  RouteFoutOpties.afsnijden =>
                    Image.asset('graphics/routeafsnijden.png')
                })),
        Positioned(
            left: 16.0,
            top: 80.0,
            child: ElevatedButton(
              child: const Text('Terug'),
              onPressed: () {
                Beamer.of(context).beamToNamed('/document');
              },
            ))
      ]),
    );
  }
}
