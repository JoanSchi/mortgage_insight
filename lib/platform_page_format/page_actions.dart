// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PageActionItem {
  final IconData? icon;
  final String? image;
  final String text;
  final VoidCallback voidCallback;

  PageActionItem({
    this.text = '',
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
          mainAxisSize: MainAxisSize.min,
          children: action,
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
                  icon: const Icon(Icons.question_mark),
                  onPressed: p.voidCallback,
                );
              }
            }()
        ];
}

List<Widget> pageActionsToTextButton(
    BuildContext context, List<PageActionItem> pageActions) {
  return pageActions.isEmpty
      ? const []
      : [
          for (PageActionItem p in pageActions)
            TextButton(
              onPressed: p.voidCallback,
              child: Text(p.text),
            )
        ];
}
