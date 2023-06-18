import 'package:flutter/material.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/platform_page_format/phone_page_scrollbars.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import 'fab_properties.dart';
import 'monitor_page.dart';
import 'page_properties.dart';
import 'phone_page_slivers_appbar.dart';
import 'table_page_slivers_appbar.dart';
import 'tablet_page_scrollbars.dart';

typedef GetPageProperties = PageProperties Function(
    {required bool hasScrollBars,
    required FormFactorType formFactorType,
    required Orientation orientation,
    required double bottom});

typedef BodyBuilder = Widget Function(
    {required BuildContext context, required EdgeInsets padding});

typedef SliversBuilder = Widget Function(
    {required BuildContext context,
    Widget? appBar,
    required EdgeInsets padding});

class DefaultPage extends StatefulWidget {
  final BodyBuilder? bodyBuilder;
  final SliversBuilder? sliversBuilder;
  final String title;
  final WidgetBuilder? imageBuilder;
  final PreferredSizeWidget? bottom;
  final GetPageProperties getPageProperties;
  // final List<MatchPageProperties<PageProperties>> matchPageProperties;
  final FabProperties? fabProperties;
  final int notificationDept;
  final TabController? tabController;
  final List<Tab>? tabs;

  const DefaultPage(
      {Key? key,
      this.bodyBuilder,
      this.title = '',
      this.imageBuilder,
      required this.getPageProperties,
      this.bottom,
      this.tabController,
      this.tabs,
      this.fabProperties,
      this.notificationDept = 0,
      this.sliversBuilder})
      : super(key: key);

  @override
  State<DefaultPage> createState() => DefaultPageState();

  static DefaultPageState of(BuildContext context) {
    final DefaultPageState? result =
        context.findAncestorStateOfType<DefaultPageState>();
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

class DefaultPageState extends State<DefaultPage> {
  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    if (deviceScreen.hasScrollBars) {
      switch (deviceScreen.formFactorType) {
        case FormFactorType.smallPhone:
        case FormFactorType.largePhone:
          return PhonePageScrollBars(
            title: widget.title,
            imageBuilder: widget.imageBuilder,
            getPageProperties: widget.getPageProperties,
            bottom: widget.bottom,
            fabProperties: widget.fabProperties,
            notificationDept: widget.notificationDept,
            tabController: widget.tabController,
            tabs: widget.tabs,
            bodyBuilder: widget.bodyBuilder,
            sliversBuilder: widget.sliversBuilder,
          );
        case FormFactorType.tablet:
          return TablePageScrollBars(
            title: widget.title,
            imageBuilder: widget.imageBuilder,
            getPageProperties: widget.getPageProperties,
            bottom: widget.bottom,
            fabProperties: widget.fabProperties,
            notificationDepth: widget.notificationDept,
            tabController: widget.tabController,
            tabs: widget.tabs,
            bodyBuilder: widget.bodyBuilder,
            sliversBuilder: widget.sliversBuilder,
          );

        case FormFactorType.monitor:
          return MonitorPage(
            title: widget.title,
            imageBuilder: widget.imageBuilder,
            getPageProperties: widget.getPageProperties,
            fabProperties: widget.fabProperties,
            bottom: widget.bottom,
            notificationDepth: widget.notificationDept,
            tabController: widget.tabController,
            tabs: widget.tabs,
            bodyBuilder: widget.bodyBuilder,
            sliversBuilder: widget.sliversBuilder,
          );
        case FormFactorType.unknown:
          return const OhNo(text: 'FormFactorType is Unknown!');
      }
    } else {
      switch (deviceScreen.formFactorType) {
        case FormFactorType.smallPhone:
        case FormFactorType.largePhone:
          return PhonePageSliverAppBar(
            bottom: widget.bottom,
            imageBuilder: widget.imageBuilder,
            title: widget.title,
            getPageProperties: widget.getPageProperties,
            fabProperties: widget.fabProperties,
            tabController: widget.tabController,
            tabs: widget.tabs,
            bodyBuilder: widget.bodyBuilder,
            sliversBuilder: widget.sliversBuilder,
          );

        case FormFactorType.tablet:
          return TablePageSliverAppBar(
            bottom: widget.bottom,
            imageBuilder: widget.imageBuilder,
            title: widget.title,
            getPageProperties: widget.getPageProperties,
            fabProperties: widget.fabProperties,
            tabController: widget.tabController,
            tabs: widget.tabs,
            bodyBuilder: widget.bodyBuilder,
            sliversBuilder: widget.sliversBuilder,
          );
        case FormFactorType.monitor:
          return MonitorPage(
            title: widget.title,
            imageBuilder: widget.imageBuilder,
            getPageProperties: widget.getPageProperties,
            fabProperties: widget.fabProperties,
            bottom: widget.bottom,
            notificationDepth: widget.notificationDept,
            tabController: widget.tabController,
            tabs: widget.tabs,
            bodyBuilder: widget.bodyBuilder,
            sliversBuilder: widget.sliversBuilder,
          );
        case FormFactorType.unknown:
          return const OhNo(text: 'FormFactorType is Unknown!');
      }
    }
  }
}

class AcceptCanelPanel extends StatelessWidget {
  final Widget child;
  final VoidCallback? cancel;
  final VoidCallback? accept;

  const AcceptCanelPanel({
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
      case FormFactorType.smallPhone:
      case FormFactorType.largePhone:
      case FormFactorType.unknown:
        orientation = screen.orientation;
        break;
      case FormFactorType.tablet:
      case FormFactorType.monitor:
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
              TextButton(onPressed: cancel, child: const Text('Annuleren')),
            if (accept != null)
              TextButton(onPressed: accept, child: const Text('Opslaan')),
            const SizedBox(
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
              ? IconButton(onPressed: cancel, icon: const Icon(Icons.close))
              : null,
        ),
        Expanded(child: child),
        SizedBox(
          width: 64.0,
          child: (accept != null)
              ? IconButton(onPressed: accept, icon: const Icon(Icons.save_alt))
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
    return CustomScrollView(key: const Key('list'), slivers: [
      SliverOverlapInjector(
        // This is the flip side of the SliverOverlapAbsorber above.
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
      const SliverToBoxAdapter(
          child: Center(child: Text(':{', textScaleFactor: 20.0)))
    ]);
  }
}
