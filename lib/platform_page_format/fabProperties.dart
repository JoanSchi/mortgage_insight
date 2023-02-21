// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class FabProperties {
  final String? text;
  final Tooltip? tooltip;
  final Widget? icon;
  final VoidCallback onTap;

  FabProperties({
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
