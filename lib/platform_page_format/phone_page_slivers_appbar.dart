import 'package:custom_sliver_appbar/shapeborder_appbar/shapeborder_lb_rb_rounded.dart';
import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import '../my_widgets/oh_no.dart';
import '../utilities/device_info.dart';
import 'adjust_scroll_configuration.dart';
import 'page_actions.dart';
import 'page_bottom_actions_layout.dart';
import 'page_properties.dart';
import 'tab_bar.dart';

class PhonePageSliverAppBar extends StatelessWidget {
  final String title;
  final WidgetBuilder? imageBuilder;
  final GetPageProperties getPageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder? bodyBuilder;
  final SliversBuilder? sliversBuilder;
  final FabProperties? fabProperties;
  final TabController? tabController;
  final List<Tab>? tabs;

  const PhonePageSliverAppBar(
      {super.key,
      this.title = '',
      this.imageBuilder,
      required this.getPageProperties,
      this.bottom,
      this.bodyBuilder,
      this.sliversBuilder,
      this.fabProperties,
      this.tabController,
      this.tabs});

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    final theme = deviceScreen.theme;
    final isPortrait = deviceScreen.orientation == Orientation.portrait;

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

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    double leftPaddingAppBar = (!isPortrait && pageProperties.hasNavigationBar)
        ? pageProperties.leftPaddingWithNavigation
        : 0.0;

    final minExtent = pageProperties.minExtent;
    final floatingExtent = pageProperties.floatingExtent;
    final maxExtent = pageProperties.maxExtent;

    Widget appBar(BuildContext context, {bool? innerBoxIsScrolled}) =>
        TextImageSliverAppBar(
            innerBoxIsScrolled: innerBoxIsScrolled,
            backgroundColor: theme.appBarTheme.backgroundColor,
            scrolledUnderBackgroundColor: theme.colorScheme.surface,
            minExtent: minExtent,
            floatingExtent: floatingExtent,
            maxCenter: maxExtent, //isPortrait ? 200.0 : 112.0,
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
            bottom: preferredWidget,
            orientation: deviceScreen.orientation,
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

    if (leftPaddingAppBar != 0.0) {
      body = Padding(
        padding: EdgeInsets.only(
          left: leftPaddingAppBar,
        ),
        child: body,
      );
    }

    return Scaffold(
        body: sliversBuilder != null
            ? body
            : AdjustedScrollConfiguration(
                child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        // SliverOverlapAbsorber(
                        //     handle:
                        //         NestedScrollView.sliverOverlapAbsorberHandleFor(
                        //             context)
                        // sliver: appBar),
                        appBar(context, innerBoxIsScrolled: innerBoxIsScrolled)
                      ];
                    },
                    body: body),
              ),
        floatingActionButton: floatingActionButton);
  }
}
