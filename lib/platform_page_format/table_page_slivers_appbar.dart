import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/my_page.dart';
import 'package:nested_scroll_view_3m/nested_scroll_view_3m.dart';
import '../utilities/device_info.dart';
import 'page_actions.dart';
import 'dart:math' as math;

class TablePageSliverAppBar extends StatelessWidget {
  final String title;
  final WidgetBuilder? imageBuilder;
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;
  final PageProperties pageProperties;

  const TablePageSliverAppBar(
      {super.key,
      this.title = '',
      this.imageBuilder,
      PageProperties? pageProperties,
      this.bottom,
      required this.bodyBuilder})
      : pageProperties =
            pageProperties ?? const PageProperties(hasNavigationBar: false);

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final height = deviceScreen.mediaQuery.size.height;
    final theme = deviceScreen.theme;
    final isPortrait = deviceScreen.isPortrait;
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    final Widget? left;
    final Widget? right;
    Widget body;

    left = buildActionRow(
        context: context,
        action:
            pageActionsToIconButton(context, pageProperties.leftBarActions));
    right = buildActionRow(
        context: context,
        action:
            pageActionsToIconButton(context, pageProperties.rightBarActions));
    body = bodyBuilder(context: context, nested: false);

    double heightTitle =
        (isPortrait && (title.isNotEmpty || left != null || right != null))
            ? 56.0
            : 0.0;

    final minExtent = math.max(heightTitle, bottomHeight);

    return NestedScrollView3M(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
                // This widget takes the overlapping behavior of the SliverAppBar,
                // and redirects it to the SliverOverlapInjector below. If it is
                // missing, then it is possible for the nested "inner" scroll view
                // below to end up under the SliverAppBar even when the inner
                // scroll view thinks it has not been scrolled.
                // This is not necessary if the "headerSliverBuilder" only builds
                // widgets that do not overlap the next sliver.
                handle:
                    NestedScrollView3M.sliverOverlapAbsorberHandleFor(context),
                sliver: TextImageSliverAppBar(
                    backgroundColor: theme.bottomAppBarColor,
                    scrolledUnderBackground: theme.colorScheme.surface,
                    minExtent: minExtent,
                    floatingExtent: heightTitle + bottomHeight,
                    maxCenter: isPortrait ? 200.0 : 100.0,
                    tween: isPortrait
                        ? Tween(begin: 48, end: 42)
                        : Tween(begin: 0.0, end: 0.0),
                    lrTbFit: isPortrait ? LrTbFit.no : LrTbFit.fit,
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
                    title: title.isEmpty || !isPortrait
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
                            includeTopWithMinium: !isPortrait,
                            imageBuilder: imageBuilder!,
                          )
                        : null,
                    pinned: true,
                    bottom: bottom,
                    orientation: deviceScreen.orientation,
                    appBarBackgroundBuilder: (
                        {required BuildContext context,
                        required EdgeInsets padding,
                        required double safeTopPadding,
                        required bool scrolledUnder,
                        Widget? child}) {
                      final scrolledUnderColor = scrolledUnder
                          ? theme.colorScheme.surface
                          : theme.bottomAppBarColor;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Material(
                            color: scrolledUnderColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: child),
                      );
                    })),
          ];
        },
        body: body);
  }
}
