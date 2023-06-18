import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import 'package:mortgage_insight/platform_page_format/tab_bar.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

import '../my_widgets/oh_no.dart';
import 'page_bottom_actions_layout.dart';
import 'page_properties.dart';

class TablePageScrollBars extends StatelessWidget {
  final String? title;
  final WidgetBuilder? imageBuilder;
  final GetPageProperties getPageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder? bodyBuilder;
  final SliversBuilder? sliversBuilder;
  final int notificationDepth;
  final FabProperties? fabProperties;
  final TabController? tabController;
  final List<Tab>? tabs;

  const TablePageScrollBars({
    super.key,
    this.title,
    this.imageBuilder,
    required this.getPageProperties,
    this.bottom,
    this.fabProperties,
    required this.notificationDepth,
    this.bodyBuilder,
    this.sliversBuilder,
    this.tabController,
    this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);
    final isNarrow = deviceScreen.isTabletWidthNarrow;
    final topPadding = deviceScreen.topPadding;

    PreferredSizeWidget? preferredWidget =
        (tabController != null && tabs != null)
            ? MyTabBar(
                formFactorType: deviceScreen.formFactorType,
                controller: tabController,
                tabs: tabs!)
            : bottom;

    final bottomHeight = preferredWidget?.preferredSize.height ?? 0.0;

    final pageProperties = getPageProperties(
        hasScrollBars: true,
        formFactorType: deviceScreen.formFactorType,
        orientation: deviceScreen.orientation,
        bottom: bottomHeight);

    final Widget? left = buildActionRow(
        context: context,
        action:
            pageActionsToIconButton(context, pageProperties.leftTopActions));
    final Widget? right = buildActionRow(
        context: context,
        action:
            pageActionsToIconButton(context, pageProperties.rightTopActions));

    final titleHeight =
        (isNarrow && (title != null || left != null || right != null))
            ? 56.0
            : 0.0;

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    const padding = EdgeInsets.all(8.0);

    Widget body = bodyBuilder?.call(context: context, padding: padding) ??
        sliversBuilder?.call(context: context, padding: padding) ??
        const OhNo(text: 'No body');

    body = PageActionBottomLayout(
        leftBottomActions: pageProperties.leftBottomActions,
        rightBottomActions: pageProperties.rightBottomActions,
        body: body);

    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           print('blub');
      //         },
      //         icon: Icon(Icons.free_breakfast))
      //   ],
      // ),
      appBar: TitleImageAppBar(
          orientation: Orientation.landscape,
          notificationPredicate: (ScrollNotification notification) =>
              notification.depth == notificationDepth,
          title: isNarrow ? title : null,
          backgroundColor: theme.colorScheme.background,
          backgroundColorScrolledUnder: theme.colorScheme.onSurface,
          leftActions: left,
          rightActions: right,
          titleTextStyle: const TextStyle(fontSize: 24.0),
          titleHeight: titleHeight,
          imageHeight: imageBuilder != null
              ? pageProperties.maxExtent - topPadding
              : 0.0,
          imageBuilder: imageBuilder,
          bottomPositionImage: 0.0, //isNarrow ? 42.0 : 0.0,
          bottom: preferredWidget,
          appBarBackgroundBuilder: (
              {required BuildContext context,
              required EdgeInsets padding,
              required double safeTopPadding,
              required bool scrolledUnder,
              Widget? child}) {
            final scrolledUnderColor = scrolledUnder
                ? theme.colorScheme.surface
                : theme.appBarTheme.backgroundColor;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                  color: scrolledUnderColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: child),
            );
          }),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
