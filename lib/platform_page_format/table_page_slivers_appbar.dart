import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import 'package:mortgage_insight/platform_page_format/page_bottom_actions_layout.dart';
import '../my_widgets/oh_no.dart';
import '../utilities/device_info.dart';
import 'adjust_scroll_configuration.dart';
import 'page_actions.dart';
import 'dart:math' as math;
import 'tab_bar.dart';

class TablePageSliverAppBar extends StatelessWidget {
  final String title;
  final WidgetBuilder? imageBuilder;
  final PreferredSizeWidget? bottom;
  final BodyBuilder? bodyBuilder;
  final SliversBuilder? sliversBuilder;
  final GetPageProperties getPageProperties;
  final FabProperties? fabProperties;
  final TabController? tabController;
  final List<Tab>? tabs;

  const TablePageSliverAppBar(
      {super.key,
      this.title = '',
      this.imageBuilder,
      required this.getPageProperties,
      this.bottom,
      this.fabProperties,
      this.bodyBuilder,
      this.sliversBuilder,
      this.tabController,
      this.tabs});

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;
    final isNarrow = deviceScreen.isTabletWidthNarrow;

    PreferredSizeWidget? preferredWidget =
        (tabController != null && tabs != null)
            ? MyTabBar(
                formFactorType: deviceScreen.formFactorType,
                controller: tabController,
                tabs: tabs!)
            : bottom;

    final bottomHeight = preferredWidget?.preferredSize.height ?? 0.0;

    final pageProperties = getPageProperties(
        hasScrollBars: false,
        formFactorType: FormFactorType.largePhone,
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

    double heightTitle =
        (isNarrow && (title.isNotEmpty || left != null || right != null))
            ? 56.0
            : 0.0;

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    double minExtent = math.max(heightTitle, bottomHeight);

    minExtent = math.max(minExtent, pageProperties.minExtent);
    final floatingExtent =
        math.max(heightTitle + bottomHeight, pageProperties.floatingExtent);
    final maxExtent = math.max(floatingExtent, pageProperties.maxExtent);

    Widget appBar(BuildContext context, {bool? innerBoxIsScrolled}) =>
        TextImageSliverAppBar(
            innerBoxIsScrolled: innerBoxIsScrolled,
            backgroundColor: theme.appBarTheme.backgroundColor,
            scrolledUnderBackgroundColor: theme.colorScheme.surface,
            minExtent: minExtent,
            floatingExtent: floatingExtent,
            maxCenter: maxExtent,
            tween: false //isNarrow
                ? Tween(begin: 48, end: 42)
                : Tween(begin: 0.0, end: 0.0),
            lrTbFit: isNarrow ? LrTbFit.no : LrTbFit.fit,
            leftActions: left != null
                ? (BuildContext context, double height) => ClipTop(
                      maxHeight: height,
                      child: CenterY(
                        child: left,
                      ),
                    )
                : null,
            rightActions: right != null
                ? (BuildContext context, double height) => ClipTop(
                      maxHeight: height,
                      child: CenterY(
                        child: right,
                      ),
                    )
                : null,
            title: title.isEmpty || !isNarrow
                ? null
                : CustomTitle(
                    title: title,
                    textStyleTween: TextStyleTween(
                        begin: const TextStyle(fontSize: 24.0),
                        end: const TextStyle(fontSize: 20.0)),
                    height: Tween(begin: 48.0, end: 56.0),
                  ),
            image: imageBuilder != null
                ? CustomImage(
                    includeTopWithMinium: !isNarrow,
                    imageBuilder: imageBuilder!,
                  )
                : null,
            pinned: true,
            bottom: preferredWidget,
            orientation: Orientation.landscape, //deviceScreen.orientation,
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
            });
    const padding = EdgeInsets.all(8.0);

    Widget body = bodyBuilder?.call(context: context, padding: padding) ??
        sliversBuilder?.call(
            context: context, appBar: appBar(context), padding: padding) ??
        const OhNo(text: 'No body');

    body = PageActionBottomLayout(
        leftBottomActions: pageProperties.leftBottomActions,
        rightBottomActions: pageProperties.rightBottomActions,
        body: body);

    return Scaffold(
      body: sliversBuilder != null
          ? body
          : AdjustedScrollConfiguration(
              child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      // SliverOverlapAbsorber(
                      // This widget takes the overlapping behavior of the SliverAppBar,
                      // and redirects it to the SliverOverlapInjector below. If it is
                      // missing, then it is possible for the nested "inner" scroll view
                      // below to end up under the SliverAppBar even when the inner
                      // scroll view thinks it has not been scrolled.
                      // This is not necessary if the "headerSliverBuilder" only builds
                      // widgets that do not overlap the next sliver.
                      // handle:
                      //     NestedScrollView.sliverOverlapAbsorberHandleFor(
                      //         context),
                      // sliver: appBar),
                      appBar(context, innerBoxIsScrolled: innerBoxIsScrolled)
                    ];
                  },
                  body: body)),
      floatingActionButton: floatingActionButton,
    );
  }
}
