// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PageActionItem {
  final IconData? icon;
  final String? image;
  final VoidCallback voidCallback;

  PageActionItem({
    this.icon,
    this.image,
    required this.voidCallback,
  });
}

Widget? buildActionRow(
    {required BuildContext context, List<Widget> action = const []}) {
  final Widget? row = action.isEmpty
      ? null
      : Row(
          children: action,
          mainAxisSize: MainAxisSize.min,
        );

  return row;
}

List<Widget> pageActionsToIconButton(
    BuildContext context, List<PageActionItem> pageActions) {
  return pageActions.isEmpty
      ? []
      : [
          for (PageActionItem p in pageActions)
            () {
              if (p.icon != null) {
                return IconButton(
                  icon: Icon(p.icon),
                  onPressed: p.voidCallback,
                );
              } else if (p.image != null) {
                return IconButton(
                  icon: Image.asset(p.image!),
                  onPressed: p.voidCallback,
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.question_mark),
                  onPressed: p.voidCallback,
                );
              }
            }()
        ];
}
