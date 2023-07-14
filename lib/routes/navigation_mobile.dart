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
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/overlay_indicator/ltbr_drawer_indicator.dart';
import 'package:mortgage_insight/routes/navigation_mobile_left.dart';
import '../platform_page_format/adjust_scroll_configuration.dart';
import 'navigation_mobile_bottom.dart';
import 'routes.dart';

const double kLeftMobileNavigationBarSize = 64.0;

class MobileNavigation extends StatefulWidget {
  const MobileNavigation({super.key});

  @override
  State<MobileNavigation> createState() => _MobileNavigationState();
}

class _MobileNavigationState extends State<MobileNavigation> {
  LtrbDrawerController ltrbDrawerController = LtrbDrawerController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    Widget drawer = (mediaQuery.orientation == Orientation.portrait)
        ? LtrbDrawer(
            buildOverlay: defaultArrowIndicator(),
            drawerController: ltrbDrawerController,
            drawerPosition: DrawerPosition.bottom,
            safeTopArea: false,
            preferredSize: const [
              555.0,
            ],
            allowMaximumSize: true,
            minSpaceAllowed: 56.0,
            buildDrawer: ({
              required DrawerModel drawerModel,
              required DrawerPosition drawerPosition,
            }) =>
                BottomMobileDrawer(
              drawerModel: drawerModel,
            ),
            body: const Pagina(),
            scrimeColorEnd: const Color.fromARGB(159, 41, 125, 167),
            minimumSize: 64.0,
            navigationBarSize: 16.0,
          )
        : LtrbDrawer(
            safeTopArea: false,
            buildOverlay: defaultArrowIndicator(),
            drawerController: ltrbDrawerController,
            drawerPosition: DrawerPosition.left,
            preferredSize: const [
              550.0,
            ],
            allowMaximumSize: true,
            maximumSize: 900,
            minSpaceAllowed: 56.0,
            buildDrawer: ({
              required DrawerModel drawerModel,
              required DrawerPosition drawerPosition,
            }) =>
                MobileLeftDrawer(
              drawerModel: drawerModel,
            ),
            body: const Pagina(),
            scrimeColorEnd: const Color.fromARGB(159, 41, 125, 167),
            minimumSize: 64.0,
            navigationBarSize: 16.0,
          );

    return ScrollConfiguration(
        behavior: const MyMaterialScrollBarBehavior(),
        child: Scaffold(
          body: drawer,
        ));
  }
}
