// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:nested_scroll_view_3m/nested_scroll_view_3m.dart';

import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/platform_page_format/phone_page_scrollbars.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

import 'monitor_page.dart';
import 'page_actions.dart';
import 'phone_page_slivers_appbar.dart';
import 'table_page_slivers_appbar.dart';
import 'tablet_page_scrollbars.dart';

class FactorTypePageProperties {
  final Set<FormFactorType> types;
  final PageProperties pageProperties;

  FactorTypePageProperties({
    required this.types,
    required this.pageProperties,
  });
}

class PageProperties {
  final bool hasNavigationBar;
  final List<PageActionItem> leftBarActions;
  final List<PageActionItem> rightBarActions;
  final List<PageActionItem> firstPageActions;
  final List<PageActionItem> secondPageActions;

  const PageProperties({
    this.hasNavigationBar = false,
    this.leftBarActions = const [],
    this.rightBarActions = const [],
    this.firstPageActions = const [],
    this.secondPageActions = const [],
  });
}

typedef BodyBuilder = Widget Function(
    {required BuildContext context, required bool nested});

class MyPage extends StatefulWidget {
  final BodyBuilder bodyBuilder;
  final String title;
  final WidgetBuilder? imageBuilder;
  final PreferredSizeWidget? bottom;
  final List<FactorTypePageProperties> factorTypePageProperties;

  const MyPage({
    Key? key,
    required this.bodyBuilder,
    this.title = '',
    this.imageBuilder,
    this.factorTypePageProperties = const [],
    this.bottom,
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

    if (deviceScreen.hasScrollBars) {
      switch (deviceScreen.formFactorType) {
        case FormFactorType.SmallPhone:
        case FormFactorType.LargePhone:
          return PhonePageScrollBars(
              title: widget.title,
              imageBuilder: widget.imageBuilder,
              pageProperties: findPageProperties(deviceScreen.formFactorType),
              bottom: widget.bottom,
              bodyBuilder: widget.bodyBuilder);
        case FormFactorType.Tablet:
          return TablePageScrollBars(
            title: widget.title,
            imageBuilder: widget.imageBuilder,
            pageProperties: findPageProperties(deviceScreen.formFactorType),
            bodyBuilder: widget.bodyBuilder,
            bottom: widget.bottom,
          );

        case FormFactorType.Monitor:
          return MonitorPage(
            bodyBuilder: widget.bodyBuilder,
            bottom: widget.bottom,
          );
        case FormFactorType.Unknown:
          return OhNo(text: 'FormFactorType is Unknown!');
      }
    } else {
      switch (deviceScreen.formFactorType) {
        case FormFactorType.SmallPhone:
        case FormFactorType.LargePhone:
          return Scaffold(
            body: PhonePageSliverAppBar(
              bottom: widget.bottom,
              imageBuilder: widget.imageBuilder,
              title: widget.title,
              pageProperties: findPageProperties(deviceScreen.formFactorType),
              bodyBuilder: widget.bodyBuilder,
            ),
          );

        case FormFactorType.Tablet:
          return Scaffold(
            body: TablePageSliverAppBar(
              bottom: widget.bottom,
              imageBuilder: widget.imageBuilder,
              title: widget.title,
              bodyBuilder: widget.bodyBuilder,
            ),
          );
        case FormFactorType.Monitor:
          return MonitorPage(
            bodyBuilder: widget.bodyBuilder,
            bottom: widget.bottom,
          );
        case FormFactorType.Unknown:
          return OhNo(text: 'FormFactorType is Unknown!');
      }
    }
  }

  PageProperties findPageProperties(FormFactorType type) {
    PageProperties? unknown;
    for (FactorTypePageProperties f in widget.factorTypePageProperties) {
      if (f.types.contains(type)) {
        return f.pageProperties;
      }
    }
    return unknown ?? PageProperties();
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
