import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import 'page_actions.dart';
import 'page_bottom_actions_layout.dart';
import 'page_properties.dart';

class PhonePageScrollBars extends StatelessWidget {
  final String? title;
  final WidgetBuilder? imageBuilder;
  final PageProperties pageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;
  final FabProperties? fabProperties;
  final int notificationDept;

  const PhonePageScrollBars({
    Key? key,
    this.title,
    this.imageBuilder,
    PageProperties? pageProperties,
    this.bottom,
    this.fabProperties,
    required this.notificationDept,
    required this.bodyBuilder,
  })  : pageProperties = pageProperties ?? const PageProperties(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);
    final isPortrait = deviceScreen.isPortrait;

    final height = deviceScreen.size.height;

    double toolbarHeight = 0.0;
    const imageHeight = 100.0;
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    bool showTitle = false;
    bool showImage = false;

    double heightLeft = height - bottomHeight;

    final Widget? left = buildActionRow(
      context: context,
      action: pageActionsToIconButton(context, pageProperties.leftTopActions),
    );

    final Widget? right = buildActionRow(
      context: context,
      action: pageActionsToIconButton(context, pageProperties.rightTopActions),
    );

    Widget body = bodyBuilder(
        context: context, nested: false, topPadding: 8.0, bottomPadding: 8.0);

    body = PageActionBottomLayout(
        leftBottomActions: pageProperties.leftBottomActions,
        rightBottomActions: pageProperties.rightBottomActions,
        body: body);

    double leftPaddingAppBar;
    double leftPadding;

    if ((!isPortrait && pageProperties.hasNavigationBar)) {
      leftPadding =
          leftPaddingAppBar = pageProperties.leftPaddingWithNavigation;
    } else {
      leftPadding = pageProperties.leftPadding;
      leftPaddingAppBar = 0.0;
    }

    body = Padding(
      padding: EdgeInsets.only(
          left: leftPadding, right: pageProperties.rightPadding),
      child: body,
    );

    if (bottom != null) {
      if (title != null && heightLeft - toolbarHeight > 500.0) {
        showTitle = true;
        toolbarHeight = kToolbarHeight;
        heightLeft -= toolbarHeight;
      }
    } else if (left != null ||
        right != null ||
        (title != null && heightLeft - toolbarHeight > 400)) {
      showTitle = true;
      toolbarHeight = kToolbarHeight;
      heightLeft -= toolbarHeight;
    }

    if (imageBuilder != null && heightLeft - imageHeight > 600.0) {
      showImage = true;
    }

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    return Scaffold(
      appBar: TitleImageAppBar(
          notificationPredicate: (ScrollNotification notification) =>
              notification.depth == notificationDept,
          title: showTitle ? title : null,
          backgroundColor: theme.colorScheme.background,
          backgroundColorScrolledUnder: theme.colorScheme.onSurface,
          leftActions: left,
          rightActions: right,
          titleHeight: toolbarHeight,
          imageHeight: showImage ? imageHeight : 0.0,
          imageBuilder: showImage ? imageBuilder : null,
          bottom: bottom,
          bottomPositionImage: 42.0,
          appBarBackgroundBuilder: (
              {required BuildContext context,
              required EdgeInsets padding,
              required double safeTopPadding,
              required bool scrolledUnder,
              Widget? child}) {
            final scrolledUnderColor = scrolledUnder
                ? theme.colorScheme.surface
                : theme.bottomAppBarTheme.color;

            return isPortrait
                ? Material(
                    color: scrolledUnderColor,
                    child: child,
                  )
                : Material(
                    color: scrolledUnderColor,
                    shape: ShapeBorderLbRbRounded(
                      topPadding: safeTopPadding,
                      leftInsets: leftPaddingAppBar,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: leftPaddingAppBar + 6.0, right: 6.0),
                      child: child,
                    ));
          }),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
