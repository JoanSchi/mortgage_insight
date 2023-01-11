import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/my_page.dart';

import 'page_actions.dart';

class MonitorPage extends StatelessWidget {
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;
  final List<Widget> leftActions;
  final List<Widget> rightActions;
  final List<PageActionItem> leftPageActions;
  final List<PageActionItem> rightPageActions;

  const MonitorPage(
      {super.key,
      this.bottom,
      required this.bodyBuilder,
      this.leftActions = const [],
      this.rightActions = const [],
      this.leftPageActions = const [],
      this.rightPageActions = const []});

  @override
  Widget build(BuildContext context) {
    final b = bottom;

    return Scaffold(
        appBar: (b != null)
            ? TitleImageAppBar(
                bottom: b,
                leftActions: buildActionRow(context: context, action: [
                  ...pageActionsToIconButton(context, leftPageActions),
                  ...leftActions
                ]),
                rightActions: buildActionRow(context: context, action: [
                  ...rightActions,
                  ...pageActionsToIconButton(context, rightPageActions),
                ]),
              )
            : null,
        body: bodyBuilder(context: context, nested: false));
  }
}
