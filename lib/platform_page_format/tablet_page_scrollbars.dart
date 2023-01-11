import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/my_page.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';

class TablePageScrollBars extends StatelessWidget {
  final String? title;
  final WidgetBuilder? imageBuilder;
  final PageProperties positionPageActions;
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;

  const TablePageScrollBars({
    Key? key,
    this.title,
    this.imageBuilder,
    PageProperties? pageProperties,
    this.bottom,
    required this.bodyBuilder,
  })  : positionPageActions =
            pageProperties ?? const PageProperties(hasNavigationBar: false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    final titleHeight = kToolbarHeight;
    final imageHeight = 100.0;

    final body = bodyBuilder(context: context, nested: false);

    return Scaffold(
      appBar: TitleImageAppBar(
        orientation: Orientation.landscape,
        title: title,
        backgroundColor: theme.backgroundColor,
        backgroundColorScrolledUnder: theme.colorScheme.onSurface,
        leftActions: buildActionRow(
            context: context,
            action: pageActionsToIconButton(
                context, positionPageActions.leftBarActions)),
        rightActions: buildActionRow(
            context: context,
            action: pageActionsToIconButton(
                context, positionPageActions.rightBarActions)),
        titleHeight: titleHeight,
        imageHeight: imageHeight,
        imageBuilder: imageBuilder,
        bottom: bottom,
      ),
      body: body,
    );
  }
}
