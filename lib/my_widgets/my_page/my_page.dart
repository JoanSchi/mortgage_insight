import 'package:custom_sliver_appbar/sliver_header/center_y.dart';
import 'package:custom_sliver_appbar/sliver_header/clip_top.dart';
import 'package:custom_sliver_appbar/sliver_header/ratio_reposition_resize.dart';
import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/left_right_to_bottom_layout.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/properties.dart';
import 'package:custom_sliver_appbar/title_image_sliver_appbar/title_image_sliver_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/mobile/mobile_document.dart';
import 'package:mortgage_insight/my_widgets/my_page/phone_page.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import 'package:nested_scroll_view_3m/nested_scroll_view_3m.dart';

class EditScrollable extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final IconData? icon;
  final String? imageName;

  const EditScrollable({
    Key? key,
    required this.children,
    this.title,
    this.icon,
    this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scroll = Container(
        child: CustomScrollView(
      slivers: [
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return children[index];
          }, childCount: children.length),
        )
      ],
    ));

    return scroll;
  }
}

class MyPage extends StatefulWidget {
  final Widget body;
  final String title;
  final String imageName;
  final Widget? leftActions;
  final Widget? rightActions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool handleSliverOverlap;
  final bool hasNavigationBar;

  const MyPage({
    Key? key,
    required this.body,
    this.title = '',
    this.imageName = '',
    this.leftActions,
    this.rightActions,
    this.bottom,
    this.backgroundColor,
    this.handleSliverOverlap = false,
    this.hasNavigationBar = true,
  }) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();

  static _MyPageState of(BuildContext context) {
    final _MyPageState? result =
        context.findAncestorStateOfType<_MyPageState>();
    if (result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'EditRoute.of() called with a context that does not contain a EditRoute.',
      ),
      ErrorDescription(
        '',
      ),
      ErrorHint(
        '',
      ),
      ErrorHint(
        '',
      ),
      context.describeElement('The context used was'),
    ]);
  }
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    Widget body;

    switch (deviceScreen.formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
      case FormFactorType.Unknown:
        if (deviceScreen.isPortrait) {
          body = Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: widget.body);
        } else {
          body = Padding(
              padding: EdgeInsets.only(
                  left: 8.0 +
                      (widget.hasNavigationBar
                          ? kLeftMobileNavigationBarSize
                          : 0.0),
                  top: 0.0,
                  right: 8.0,
                  bottom: 0.0),
              child: widget.body);
        }

        break;
      case FormFactorType.Tablet:
      case FormFactorType.Monitor:
        if (widget.backgroundColor != null) {
          body = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(42.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: widget.body,
                ),
                color: widget.backgroundColor),
          );
        } else {
          body = Padding(
            padding: const EdgeInsets.all(12.0),
            child: widget.body,
          );
        }
        break;
    }

    if (deviceScreen.hasScrollBars) {
      switch (deviceScreen.formFactorType) {
        case FormFactorType.SmallPhone:
        case FormFactorType.LargePhone:
          return PhonePage(
              title: widget.title,
              imageName: widget.imageName,
              leftActions: widget.leftActions,
              rightActions: widget.rightActions,
              bottom: widget.bottom,
              body: body);
        case FormFactorType.Tablet:
        case FormFactorType.Monitor:
        case FormFactorType.Unknown:
          return OhNo();
      }
    } else {
      switch (deviceScreen.formFactorType) {
        case FormFactorType.SmallPhone:
        case FormFactorType.LargePhone:
          return Scaffold(
            body: SliverAppBarNestedScrollView(
              bottom: widget.bottom,
              imageName: widget.imageName,
              title: widget.title,
              body: body,
            ),
          );

        case FormFactorType.Tablet:
        case FormFactorType.Monitor:
        case FormFactorType.Unknown:
          return OhNo();
      }
    }
  }
}

class SliverAppBarNestedScrollView extends StatelessWidget {
  final String title;
  final String imageName;
  final Widget? leftActions;
  final Widget? rightActions;
  final PreferredSizeWidget? bottom;
  final Widget body;

  const SliverAppBarNestedScrollView(
      {super.key,
      this.title = '',
      this.imageName = '',
      this.leftActions,
      this.rightActions,
      this.bottom,
      required this.body});

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);
    final theme = deviceScreen.theme;
    final portrait = deviceScreen.orientation == Orientation.portrait;
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    return NestedScrollView3M(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            TextImageSliverAppBar(
              backgroundColor: theme.bottomAppBarColor,
              scrolledUnderBackground: theme.colorScheme.surface,
              minExtent: portrait ? bottomHeight : 0.0,
              floatingExtent: 56.0,
              maxCenter: portrait ? 200.0 : 100.0,
              tween: portrait
                  ? Tween(begin: 42, end: 36)
                  : Tween(begin: 0.0, end: 0.0),
              lrTbFit: portrait ? LrTbFit.no : LrTbFit.fit,
              leftActions: leftActions != null
                  ? (double height) => ClipTop(
                        maxHeight: height,
                        child: CenterY(
                          child: leftActions,
                        ),
                      )
                  : null,
              rightActions: rightActions != null
                  ? (double height) => ClipTop(
                        maxHeight: height,
                        child: CenterY(
                          child: IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {}),
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
                      height: Tween(begin: 56.0, end: 48),
                    ),
              image: imageName.isEmpty
                  ? null
                  : CustomImage(
                      includeTopWithMinium: !portrait,
                      imageBuilder: (_) => RePositionReSize(
                          ratioHeight: 0.8,
                          ratioPosition: Ratio(0.0, 0.0),
                          child: Image(
                              image: AssetImage(
                                imageName,
                              ),
                              color: theme.colorScheme.onSurface)),
                    ),
              pinned: true,
              bottom: bottom,
              orientation: deviceScreen.orientation,
            ),
          ];
        },
        body: body);
  }
}

class AcceptCanelPanel extends StatelessWidget {
  final Widget child;
  final VoidCallback? cancel;
  final VoidCallback? accept;

  AcceptCanelPanel({
    Key? key,
    required this.child,
    this.cancel,
    this.accept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screen = DeviceScreen3.of(context);
    Orientation orientation;

    switch (screen.formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
      case FormFactorType.Unknown:
        orientation = screen.orientation;
        break;
      case FormFactorType.Tablet:
      case FormFactorType.Monitor:
        orientation = (screen.size.height < 600)
            ? Orientation.landscape
            : Orientation.portrait;

        break;
    }

    Widget body;

    if (orientation == Orientation.portrait) {
      body = Column(children: [
        Expanded(child: child),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (cancel != null)
              TextButton(onPressed: cancel, child: Text('Annuleren')),
            if (accept != null)
              TextButton(onPressed: accept, child: Text('Opslaan')),
            SizedBox(
              width: 16.0,
            )
          ],
        )
      ]);
    } else {
      body = Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 64.0,
          child: (cancel != null)
              ? IconButton(onPressed: cancel, icon: Icon(Icons.close))
              : null,
        ),
        Expanded(child: child),
        SizedBox(
          width: 64.0,
          child: (accept != null)
              ? IconButton(onPressed: accept, icon: Icon(Icons.save_alt))
              : null,
        )
      ]);
    }
    return body;
  }
}

class Oops extends StatelessWidget {
  const Oops({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(key: Key('list'), slivers: [
        SliverOverlapInjector(
          // This is the flip side of the SliverOverlapAbsorber above.
          handle: NestedScrollView3M.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverToBoxAdapter(
            child: Center(child: Text(':{', textScaleFactor: 20.0)))
      ]),
    );
  }
}
