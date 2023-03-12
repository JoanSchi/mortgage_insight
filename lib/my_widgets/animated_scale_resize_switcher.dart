import 'package:flutter/material.dart';
import '../layout/transition/scale_size_transition.dart';

class AnimatedScaleResizeSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const AnimatedScaleResizeSwitcher(
      {Key? key,
      required this.child,
      this.duration = const Duration(milliseconds: 200)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: <Widget>[
              ...previousChildren,
              if (currentChild != null) currentChild,
            ],
          );
        },
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleResizedTransition(scale: animation, child: child),
          );
        },
        duration: duration,
        child: child);
  }
}
