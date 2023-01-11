import 'package:flutter/material.dart';
import '../../navigation/navigation_medium.dart';

class MediumDocument extends StatelessWidget {
  MediumDocument({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        backgroundColor: theme.backgroundColor, body: MediumDrawer());
  }
}
