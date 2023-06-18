import 'package:flutter/material.dart';

enum CardMenuOptions { edit, delete }

class MoCard extends StatelessWidget {
  final Widget? top;
  final Widget? bottom;
  final Widget body;
  final Color? color;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? splashColor;
  final Color? highlightColor;
  final List<Positioned> positioneds;

  const MoCard({
    Key? key,
    this.top,
    this.bottom,
    required this.body,
    this.positioneds = const [],
    this.color,
    this.onTap,
    this.onLongPress,
    this.splashColor = const Color.fromARGB(137, 170, 212, 229),
    this.highlightColor = const Color.fromARGB(136, 111, 152, 169),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget card = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (top != null) ...[
            top!,
            Divider(
              color: theme.primaryColor,
              height: 4.0,
              indent: 5.0,
              endIndent: 5.0,
            ),
          ],
          Expanded(
            child: body,
          ),
          if (bottom != null) ...[
            Divider(
              color: theme.primaryColor,
              height: 4.0,
              indent: 5.0,
              endIndent: 5.0,
            ),
            bottom!
          ]
        ],
      ),
    );

    if (onTap != null || onLongPress != null) {
      card = InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          onTap: onTap,
          onLongPress: onLongPress,
          child: card);
    }

    if (positioneds.isNotEmpty) {
      card = Stack(children: [
        ...positioneds,
        Positioned(left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: card)
      ]);
    }

    return Card(
        clipBehavior: Clip.antiAlias,
        color: color,
        surfaceTintColor: color,
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: card);
  }
}

class MoCardMenuItem {
  final String action;
  final Widget? icon;
  final Widget text;

  MoCardMenuItem({
    required this.action,
    this.icon,
    required this.text,
  });

  MoCardMenuItem.edit({
    this.action = 'edit',
    this.icon = const Icon(Icons.edit),
    this.text = const Text('Aanpassen'),
  });

  MoCardMenuItem.delete({
    this.action = 'delete',
    this.icon = const Icon(Icons.delete),
    this.text = const Text('Verwijderen'),
  });
}

Widget buildMoCardMenu(
    {Widget? icon,
    required List<MoCardMenuItem> items,
    required PopupMenuItemSelected<String> onSelected}) {
  List<PopupMenuEntry<String>> menuEntryList = items
      .map(
        (MoCardMenuItem e) => PopupMenuItem<String>(
          value: e.action,
          child: e.icon == null
              ? e.text
              : Row(
                  children: [
                    e.icon!,
                    const SizedBox(width: 10.0),
                    e.text,
                  ],
                ),
        ),
      )
      .toList();

  return PopupMenuButton<String>(
    icon: icon,
    onSelected: onSelected,
    itemBuilder: (BuildContext context) => menuEntryList,
    elevation: 1.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );
}
