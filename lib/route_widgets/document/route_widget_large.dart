import 'package:flutter/material.dart';
import 'package:mortgage_insight/navigation/navigation_large.dart';

class LargeRouteDocument extends StatelessWidget {
  const LargeRouteDocument({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: const LargeDrawer());
  }
}
