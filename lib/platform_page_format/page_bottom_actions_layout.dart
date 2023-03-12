import 'package:flutter/material.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';

class PageActionBottomLayout extends StatelessWidget {
  final Widget body;
  final double space;
  final List<PageActionItem> leftBottomActions;
  final List<PageActionItem> rightBottomActions;

  const PageActionBottomLayout(
      {super.key,
      required this.body,
      this.space = 8.0,
      this.leftBottomActions = const [],
      this.rightBottomActions = const []});

  @override
  Widget build(BuildContext context) {
    if (leftBottomActions.isEmpty && rightBottomActions.isEmpty) {
      return body;
    }

    final left = buildActionRow(
        context: context,
        action: pageActionsToTextButton(context, leftBottomActions));
    final right = buildActionRow(
        context: context,
        action: pageActionsToTextButton(context, rightBottomActions));

    return left == null && right == null
        ? body
        : Column(
            children: [
              Expanded(child: body),
              SizedBox(
                height: space,
              ),
              Row(
                children: [
                  if (left != null) left,
                  const Expanded(
                    child: SizedBox(),
                  ),
                  if (right != null) right,
                ],
              )
            ],
          );
  }
}
