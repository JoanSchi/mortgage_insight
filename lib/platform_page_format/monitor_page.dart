import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'fab_properties.dart';
import 'page_actions.dart';
import 'page_properties.dart';

class MonitorPage extends StatelessWidget {
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;
  final PageProperties pageProperties;
  final FabProperties? fabProperties;

  const MonitorPage({
    super.key,
    this.bottom,
    required this.bodyBuilder,
    PageProperties? pageProperties,
    this.fabProperties,
  }) : pageProperties = pageProperties ?? const PageProperties();

  @override
  Widget build(BuildContext context) {
    Widget body = bodyBuilder(
        context: context, nested: false, topPadding: 8.0, bottomPadding: 8.0);

    final floatingActionButton =
        fabProperties == null ? null : Fab(fabProperties: fabProperties!);

    final r = pageProperties.leftBottomActions.isEmpty &&
            pageProperties.rightBottomActions.isEmpty
        ? null
        : Row(children: [
            ...pageActionsToTextButton(
                context, pageProperties.leftBottomActions),
            const Expanded(child: SizedBox()),
            ...pageActionsToTextButton(
                context, pageProperties.rightBottomActions)
          ]);

    body = Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
          body: Column(children: [Expanded(child: body), if (r != null) r]),
          floatingActionButton: floatingActionButton,
        ),
      ),
    );

    if (bottom != null) {
      body = Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32, bottom: 32.0),
          child: Column(
            children: [bottom!, Expanded(child: body)],
          ));
    } else {
      body = Padding(padding: const EdgeInsets.all(32.0), child: body);
    }

    // body = Padding(padding: const EdgeInsets.only(16.0), child: body);

    body = Material(
      color: const Color(0xFFe0ecf2),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      child: Row(
        children: [
          const Expanded(
            child: SizedBox(
              width: 56.0,
            ),
          ),
          SizedBox(width: 1200, child: body),
          const Expanded(
              child: SizedBox(
            width: 56.0,
          ))
        ],
      ),
    );

    return body;
  }
}
