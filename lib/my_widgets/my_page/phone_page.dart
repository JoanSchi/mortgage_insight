// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:custom_sliver_appbar/title_image_appbar/title_image_appbar.dart';
import 'package:flutter/material.dart';

class PhonePage extends StatelessWidget {
  final String title;
  final String imageName;
  final Widget? leftActions;
  final Widget? rightActions;
  final PreferredSizeWidget? bottom;
  final Widget body;

  const PhonePage({
    Key? key,
    this.title = '',
    this.imageName = '',
    this.leftActions,
    this.rightActions,
    this.bottom,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    final titleHeight = kToolbarHeight;
    final imageHeight = 100.0;
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;

    bool noTitle = false;
    bool noImage = false;

    if (height - titleHeight - bottomHeight < 600.0 && bottom != null) {
      noTitle = true;
    } else if (height - titleHeight - imageHeight - bottomHeight < 600.0) {
      noImage = true;
    }

    return Scaffold(
      appBar: TitleImageAppBar(
        title: noTitle ? null : title,
        backgroundColor: theme.backgroundColor,
        backgroundColorScrolledUnder: theme.colorScheme.onSurface,
        leftActions: leftActions,
        rightActions: rightActions,
        titleHeight: titleHeight,
        imageHeight: noImage ? 0.0 : imageHeight,
        image: noImage
            ? null
            : Image(
                height: height,
                image: AssetImage(
                  imageName,
                ),
                color: theme.colorScheme.onSurface),
        bottom: bottom,
      ),
      body: body,
    );
  }
}
