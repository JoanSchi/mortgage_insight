import 'package:flutter/material.dart';

class MortgageChip extends StatelessWidget {
  final bool selected;
  final ValueChanged<bool?> onSelected;
  final String text;
  final String avatarText;

  const MortgageChip(
      {super.key,
      required this.selected,
      required this.onSelected,
      required this.text,
      required this.avatarText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawChip(
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      side: BorderSide.none,
      avatar: CircleAvatar(
        backgroundColor: selected
            ? theme.colorScheme.surface
            : const Color.fromARGB(255, 225, 232, 235),
        child: Text(
          avatarText,
          style: theme.textTheme.bodySmall
              ?.copyWith(fontSize: 8.0, color: theme.colorScheme.primary),
        ),
      ),
      // backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.onSurface,
      surfaceTintColor: Colors.pink,
      selectedShadowColor: Colors.pink,
      label: Text(text,
          style: TextStyle(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface)),
      selected: selected,
      onSelected: onSelected,
    );
  }
}
