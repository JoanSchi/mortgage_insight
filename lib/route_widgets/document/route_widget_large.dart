import 'package:flutter/material.dart';
import 'package:mortgage_insight/navigation/navigation_large.dart';

class LargeRouteDocument extends StatelessWidget {
  LargeRouteDocument({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.backgroundColor, body: LargeDrawer());
  }
}
