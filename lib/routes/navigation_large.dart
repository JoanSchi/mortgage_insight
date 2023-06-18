import 'package:flutter/material.dart';
import 'package:mortgage_insight/routes/routes.dart';

import 'navigation_medium.dart';

class LargeNavigation extends StatelessWidget {
  const LargeNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFe0ecf2),
        body: MediumDrawer(
            body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200.0 - 208.0),
              child: const Pagina()),
        )));
  }
}
