import 'package:flutter/material.dart';

class FabProperties {
  final String? text;
  final Tooltip? tooltip;
  final Widget? icon;
  final VoidCallback onTap;

  const FabProperties({
    this.text,
    this.tooltip,
    this.icon,
    required this.onTap,
  });
}

class Fab extends StatelessWidget {
  final FabProperties fabProperties;

  const Fab({super.key, required this.fabProperties});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: fabProperties.onTap,
      child: fabProperties.icon,
    );
  }
}
