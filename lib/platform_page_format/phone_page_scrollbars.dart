// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/my_page.dart';

import 'page_actions.dart';

class PhonePageScrollBars extends StatelessWidget {
  final String? title;
  final WidgetBuilder? imageBuilder;
  final PageProperties pageProperties;
  final PreferredSizeWidget? bottom;
  final BodyBuilder bodyBuilder;

  const PhonePageScrollBars({
    Key? key,
    this.title,
    this.imageBuilder,
    PageProperties? pageProperties,
    this.bottom,
    required this.bodyBuilder,
  })  : pageProperties =
            pageProperties ?? const PageProperties(hasNavigationBar: false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    final titleHeight = kToolbarHeight;
    final imageHeight = 100.0;
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    bool showTitle = false;
    bool showImage = false;

    double heightLeft = height - bottomHeight;

    final Widget? left;
    final Widget? right;
    final Widget body;

    if (height < 900) {
      left = buildActionRow(
        context: context,
        action: pageActionsToIconButton(context, [
          ...pageProperties.leftBarActions,
          ...pageProperties.firstPageActions
        ]),
      );
      right = buildActionRow(
          context: context,
          action: pageActionsToIconButton(context, [
            ...pageProperties.secondPageActions,
            ...pageProperties.rightBarActions
          ]));

      body = bodyBuilder(context: context, nested: false);
    } else {
      left = buildActionRow(
          context: context,
          action:
              pageActionsToIconButton(context, pageProperties.leftBarActions));
      right = buildActionRow(
          context: context,
          action:
              pageActionsToIconButton(context, pageProperties.rightBarActions));
      // TODO: Wrap actions
      body = bodyBuilder(context: context, nested: false);
    }

    if (title != null &&
        (heightLeft - titleHeight > 600.0 || left != null || right != null)) {
      showTitle = true;
      heightLeft -= titleHeight;
    }

    if (imageBuilder != null && heightLeft - imageHeight > 600.0) {
      showImage = true;
    }

    return Scaffold(
      appBar: TitleImageAppBar(
        title: showTitle ? null : title,
        backgroundColor: theme.backgroundColor,
        backgroundColorScrolledUnder: theme.colorScheme.onSurface,
        leftActions: left,
        rightActions: right,
        titleHeight: titleHeight,
        imageHeight: showImage ? 0.0 : imageHeight,
        imageBuilder: showImage ? imageBuilder : null,
        bottom: bottom,
      ),
      body: body,
    );
  }
}
