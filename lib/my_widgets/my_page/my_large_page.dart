import 'package:flutter/material.dart';

class MyLargePage extends StatelessWidget {
  final PreferredSizeWidget? preferredSizeWidget;
  final Widget body;

  const MyLargePage({super.key, this.preferredSizeWidget, required this.body});

  @override
  Widget build(BuildContext context) {
    final ps = preferredSizeWidget;

    return MyWidget(
      child: Stack(children: [
        Positioned(
          left: 0.0,
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Column(
            children: [
              if (ps != null)
                SizedBox(height: ps.preferredSize.height, child: ps),
              Expanded(child: body)
            ],
          ),
        )
      ]),
    );
  }
}

class MyWidget extends StatelessWidget {
  final Widget child;
  const MyWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
