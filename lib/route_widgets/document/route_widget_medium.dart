import 'package:flutter/material.dart';
import '../../navigation/navigation_medium.dart';

class MediumDocument extends StatelessWidget {
  const MediumDocument({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: const MediumDrawer());
  }
}
