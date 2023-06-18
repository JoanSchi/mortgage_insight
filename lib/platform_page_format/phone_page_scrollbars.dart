// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import 'page_actions.dart';
import 'page_bottom_actions_layout.dart';
import 'tab_bar.dart';

class PhonePageScrollBars extends StatelessWidget {
  final String? title;
  final WidgetBuilder? imageBuilder;
  final GetPageProperties getPageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder? bodyBuilder;
  final SliversBuilder? sliversBuilder;
  final FabProperties? fabProperties;
  final int notificationDept;
  final TabController? tabController;
  final List<Tab>? tabs;

  const PhonePageScrollBars({
    super.key,
    required this.getPageProperties,
    this.title,
    this.imageBuilder,
    this.bottom,
    this.fabProperties,
    required this.notificationDept,
    this.tabController,
    this.tabs,
    this.bodyBuilder,
    this.sliversBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);
    final isPortrait = deviceScreen.isPortrait;

    final height = deviceScreen.size.height;

    double toolbarHeight = 0.0;
    const imageHeight = 100.0;

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

    const padding = EdgeInsets.all(8.0);

    if (preferredWidget != null) {
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

    Widget body = bodyBuilder?.call(context: context, padding: padding) ??
        sliversBuilder?.call(context: context, padding: padding) ??
        const OhNo(text: 'No body');

    body = PageActionBottomLayout(
        leftBottomActions: pageProperties.leftBottomActions,
        rightBottomActions: pageProperties.rightBottomActions,
        body: body);

    double leftPaddingAppBar = 0.0;

    if ((!isPortrait && pageProperties.hasNavigationBar)) {
      leftPaddingAppBar = pageProperties.leftPaddingWithNavigation;
      body = Padding(
        padding: EdgeInsets.only(left: leftPaddingAppBar),
        child: body,
      );
    }

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
          bottom: preferredWidget,
          bottomPositionImage: 42.0,
          appBarBackgroundBuilder: (
              {required BuildContext context,
              required EdgeInsets padding,
              required double safeTopPadding,
              required bool scrolledUnder,
              Widget? child}) {
            final scrolledUnderColor = scrolledUnder
                ? theme.colorScheme.surface
                : theme.appBarTheme.backgroundColor;

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
