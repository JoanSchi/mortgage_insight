import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

import 'page_bottom_actions_layout.dart';
import 'page_properties.dart';

class TablePageScrollBars extends StatelessWidget {
  final String? title;
  final WidgetBuilder? imageBuilder;
  final PageProperties pageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;
  final int notificationDepth;

  final FabProperties? fabProperties;

  const TablePageScrollBars({
    Key? key,
    this.title,
    this.imageBuilder,
    PageProperties? pageProperties,
    this.bottom,
    this.fabProperties,
    required this.notificationDepth,
    required this.bodyBuilder,
  })  : pageProperties = pageProperties ?? const PageProperties(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);
    final isNarrow = deviceScreen.isTabletWidthNarrow;

    final Widget? left = buildActionRow(
        context: context,
        action:
            pageActionsToIconButton(context, pageProperties.leftTopActions));
    final Widget? right = buildActionRow(
        context: context,
        action:
            pageActionsToIconButton(context, pageProperties.rightTopActions));

    Widget body = PageActionBottomLayout(
        leftBottomActions: pageProperties.leftBottomActions,
        rightBottomActions: pageProperties.rightBottomActions,
        body: bodyBuilder(
            context: context,
            nested: false,
            topPadding: 8.0,
            bottomPadding: 8.0));

    final titleHeight =
        (isNarrow && (title != null || left != null || right != null))
            ? 56.0
            : 0.0;

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    return Scaffold(
      appBar: TitleImageAppBar(
          orientation: isNarrow ? Orientation.portrait : Orientation.landscape,
          notificationPredicate: (ScrollNotification notification) =>
              notification.depth == notificationDepth,
          title: titleHeight != 0.0 ? title : null,
          backgroundColor: theme.colorScheme.background,
          backgroundColorScrolledUnder: theme.colorScheme.onSurface,
          leftActions: left,
          rightActions: right,
          titleTextStyle: const TextStyle(fontSize: 24.0),
          titleHeight: titleHeight,
          imageHeight: imageBuilder != null ? 120.0 : 0.0,
          imageBuilder: imageBuilder,
          bottomPositionImage: isNarrow ? 42.0 : 0.0,
          bottom: bottom,
          appBarBackgroundBuilder: (
              {required BuildContext context,
              required EdgeInsets padding,
              required double safeTopPadding,
              required bool scrolledUnder,
              Widget? child}) {
            final scrolledUnderColor = scrolledUnder
                ? theme.colorScheme.surface
                : theme.bottomAppBarTheme.color;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                  color: scrolledUnderColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: child),
            );
          }),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
