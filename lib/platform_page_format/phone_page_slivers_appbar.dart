import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fabProperties.dart';
import '../utilities/device_info.dart';
import 'page_actions.dart';
import 'page_bottom_actions_layout.dart';
import 'page_properties.dart';

class PhonePageSliverAppBar extends StatelessWidget {
  final String title;
  final WidgetBuilder? imageBuilder;
  final PageProperties pageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;
  final FabProperties? fabProperties;

  const PhonePageSliverAppBar(
      {super.key,
      this.title = '',
      this.imageBuilder,
      PageProperties? pageProperties,
      this.bottom,
      required this.bodyBuilder,
      this.fabProperties})
      : pageProperties = pageProperties ?? const PageProperties();

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final height = deviceScreen.mediaQuery.size.height;
    final theme = deviceScreen.theme;
    final isPortrait = deviceScreen.orientation == Orientation.portrait;
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    final left = buildActionRow(
      context: context,
      action: pageActionsToIconButton(
        context,
        pageProperties.leftTopActions,
      ),
    );

    final right = buildActionRow(
      context: context,
      action: pageActionsToIconButton(context, pageProperties.rightTopActions),
    );

    Widget body = bodyBuilder(context: context, nested: false);

    final padding = 8.0;

    double leftPaddingAppBar =
        !isPortrait && pageProperties.hasNavigationBar ? 56.0 : 0.0;

    body = Padding(
      padding: EdgeInsets.only(
          left: !isPortrait && pageProperties.hasNavigationBar ? 56.0 : padding,
          top: padding,
          right: padding,
          bottom: padding),
      child: PageActionBottomLayout(
          leftBottomActions: pageProperties.leftBottomActions,
          rightBottomActions: pageProperties.rightBottomActions,
          body: body),
    );

    // return AppBar(
    //   actions: pageActionsToIconButton(context, pageProperties.rightTopActions),
    // );

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: TextImageSliverAppBar(
                      backgroundColor: theme.bottomAppBarTheme.color,
                      scrolledUnderBackground: theme.colorScheme.surface,
                      minExtent: 56,
                      floatingExtent: 56.0,
                      maxCenter: isPortrait ? 200.0 : 100.0,
                      tween: isPortrait
                          ? Tween(begin: 42, end: 48)
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
                      title: title.isEmpty
                          ? null
                          : CustomTitle(
                              title: title,
                              textStyleTween: TextStyleTween(
                                  begin: const TextStyle(fontSize: 24.0),
                                  end: const TextStyle(fontSize: 20.0)),
                              height: Tween(begin: 56.0, end: 56.0),
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
                                      left: leftPaddingAppBar + 6.0,
                                      right: 6.0),
                                  child: child,
                                ));
                      }),
                ),
              ];
            },
            body: body),
        floatingActionButton: floatingActionButton);
  }
}
