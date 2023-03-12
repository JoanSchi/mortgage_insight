import 'package:flutter/material.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/overlay_indicator/ltbr_drawer_indicator.dart';
import 'package:mortgage_insight/navigation/navigation_mobile_left.dart';
import '../../navigation/navigation_mobile_bottom.dart';
import 'route_widget_page.dart';

const double kLeftMobileNavigationBarSize = 64.0;

class MobileDocument extends StatefulWidget {
  const MobileDocument({super.key});

  @override
  State<MobileDocument> createState() => _MobileDocumentState();
}

class _MobileDocumentState extends State<MobileDocument> {
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
              650.0,
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
            body: const MyRoutePage(),
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
            body: const MyRoutePage(),
            scrimeColorEnd: const Color.fromARGB(159, 41, 125, 167),
            minimumSize: 64.0,
            navigationBarSize: 16.0,
          );

    return Scaffold(
      body: drawer,
    );
  }
}
