// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../layout/transition/scale_size_transition.dart';

typedef BuildSliverBox<I> = Widget Function(
    {Animation? animation,
    required int index,
    required int length,
    required SliverBoxItemState<I> state});

class SliverRowBox<T, I> extends StatefulWidget {
  final List<SliverBoxItemState<T>> topList;
  final List<SliverBoxItemState<I>> itemList;
  final List<SliverBoxItemState<T>> bottomList;
  final BuildSliverBox<I> buildSliverBoxItem;
  final BuildSliverBox<T> buildSliverBoxTopBottom;
  final bool visible;
  final bool visibleAnimated;
  final int maximumItems;
  final double heightItem;
  final EdgeInsets paddingItem;
  final Duration duration;

  const SliverRowBox({
    Key? key,
    required this.topList,
    required this.itemList,
    required this.bottomList,
    required this.buildSliverBoxItem,
    required this.buildSliverBoxTopBottom,
    this.visible = true,
    this.visibleAnimated = false,
    this.maximumItems = -1,
    required this.heightItem,
    this.paddingItem = const EdgeInsets.symmetric(horizontal: 16.0),
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<SliverRowBox<T, I>> createState() => _SliverRowBoxState<T, I>();

  static _SliverRowBoxState? of<T, I>(BuildContext context) {
    return context.findAncestorStateOfType<_SliverRowBoxState<T, I>>();
  }
}

class _SliverRowBoxState<T, I> extends State<SliverRowBox<T, I>>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? enableAnimation;
  bool maxItemsForAnimation = false;
  int maxItemsDuringAnimation = -1;

  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    checkAnimation();
    super.didChangeDependencies();
  }

  void didUpdateWidget(SliverRowBox<T, I> oldWidget) {
    checkAnimation();
    if (widget.visibleAnimated) {
      if (widget.visible) {
        animationController?.forward();
      } else {
        animationController?.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  checkAnimation() {
    if (widget.visibleAnimated) {
      if (animationController == null) {
        maxItemsForAnimation = !widget.visible;
        animationController = AnimationController(
            value: widget.visible ? 1.0 : 0.0,
            vsync: this,
            duration: widget.duration);
        enableAnimation = animationController!
            .drive<double>(CurveTween(curve: Curves.easeInOut))
          ..addListener(() {
            if ((enableAnimation!.value != 1.0) != maxItemsForAnimation) {
              setState(() {
                maxItemsForAnimation = !maxItemsForAnimation;
              });
            }
          });
      } else if (animationController?.duration != widget.duration) {
        animationController?.duration = widget.duration;
      }
    } else if (animationController != null) {
      maxItemsForAnimation = false;
      animationController?.dispose();
      animationController = null;
      enableAnimation = null;
    }
  }

  verwijder(SliverBoxItemState state) {
    setState(() {
      widget.itemList.remove(state);
    });
  }

  @override
  Widget build(BuildContext context) {
    RenderSliverList? r = context.findRenderObject() as RenderSliverList?;

    if (maxItemsForAnimation) {
      if (r != null) {
        final y = (r.parentData as SliverPhysicalParentData).paintOffset.dy;
        final vieportHeight = r.constraints.viewportMainAxisExtent;
        final height = vieportHeight * 1.25 - y;
        maxItemsDuringAnimation = height ~/ widget.heightItem + 1;
      }
      debugPrint('Maximum items during animation $maxItemsForAnimation');
    } else {
      maxItemsDuringAnimation = -1;
    }

    return SliverList(
        delegate: _SliverBoxRowSliverChildDelegate<T, I>(
      buildItem: _buildItem,
      buildTopBottom: _buildTopBottom,
      topList: widget.topList,
      itemList: widget.itemList,
      bottomList: widget.bottomList,
      maxItemsDuringAnimation: maxItemsDuringAnimation,
    ));
  }

  Widget _buildItem(
      {required BuildContext context,
      required SliverBoxItemState<I> state,
      required int index,
      required int length}) {
    return widget.buildSliverBoxItem(
        index: index, length: length, state: state, animation: enableAnimation);
  }

  Widget _buildTopBottom(
      {required BuildContext context,
      required SliverBoxItemState<T> state,
      required int index,
      required int length}) {
    return widget.buildSliverBoxTopBottom(
        animation: enableAnimation, index: index, length: length, state: state);
  }
}

class _SliverBoxRowSliverChildDelegate<T, I> extends SliverChildDelegate {
  final List<SliverBoxItemState<T>> topList;
  final List<SliverBoxItemState<I>> itemList;
  final List<SliverBoxItemState<T>> bottomList;
  final int maxItemsDuringAnimation;

  final Widget Function(
      {required BuildContext context,
      required SliverBoxItemState<T> state,
      required int index,
      required int length}) buildTopBottom;

  final Widget Function(
      {required BuildContext context,
      required SliverBoxItemState<I> state,
      required int index,
      required int length}) buildItem;

  _SliverBoxRowSliverChildDelegate({
    required this.topList,
    required this.itemList,
    required this.bottomList,
    required this.buildTopBottom,
    required this.buildItem,
    required this.maxItemsDuringAnimation,
  });

  @override
  Widget? build(BuildContext context, int index) {
    final topLength = topList.length;
    int itemLength = itemList.length;
    final bottomLength = bottomList.length;

    if (index == -1) {
      return null;
    }

    if (maxItemsDuringAnimation != -1 && itemLength > maxItemsDuringAnimation) {
      itemLength = maxItemsDuringAnimation;
    }

    if (index < topLength) {
      return buildTopBottom(
          context: context,
          state: topList[index],
          index: index,
          length: topLength);
    }

    index -= topLength;

    if (index < itemLength) {
      return buildItem(
          context: context,
          state: itemList[index],
          index: index,
          length: itemLength);
    }

    index -= itemLength;

    if (index < bottomLength) {
      return buildTopBottom(
          context: context,
          state: bottomList[index],
          index: index,
          length: bottomList.length);
    }

    return null;
  }

  int? get estimatedChildCount =>
      topList.length + itemList.length + bottomList.length;

  @override
  bool shouldRebuild(SliverChildDelegate oldDelegate) {
    return true;
  }
}

class VisibleAnimatedSliverRowItem extends StatelessWidget {
  final Animation? enableAnimation;
  final Widget child;

  const VisibleAnimatedSliverRowItem({
    Key? key,
    this.enableAnimation,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final a = enableAnimation;

    if (a != null) {
      return AnimatedBuilder(
          animation: a,
          child: child,
          builder: (BuildContext context, Widget? child) => a.value == 0.0
              ? SizedBox.shrink()
              : ScaleResized(scale: a.value, child: child));
    } else {
      return child;
    }
  }
}

class InsertRemoveVisibleAnimatedSliverRowItem extends StatelessWidget {
  final Animation? enableAnimation;
  final Widget child;
  final SliverBoxItemState state;

  const InsertRemoveVisibleAnimatedSliverRowItem({
    Key? key,
    this.enableAnimation,
    required this.child,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final a = enableAnimation;

    if (a != null) {
      return AnimatedBuilder(
          key: Key('ea_${state.key}'),
          animation: a,
          child: child,
          builder: (BuildContext context, Widget? child) {
            final scale = a.value;
            return ScaleResized(scale: scale, child: tt());
          });
    } else {
      return tt();
    }
  }

  Widget tt() {
    if (state.enabled && state.insertRemoveAnimation == 1.0) {
      return child;
    } else {
      return SliverItemRowAnimation(
        key: Key('a_${state.key}'),
        child: child,
        state: state,
      );
    }
  }
}

class SliverItemRowAnimation extends StatefulWidget {
  final SliverBoxItemState state;
  final Widget child;

  const SliverItemRowAnimation({
    Key? key,
    required this.state,
    required this.child,
  }) : super(key: key);

  @override
  State<SliverItemRowAnimation> createState() => _SliverItemRowAnimationState();
}

class _SliverItemRowAnimationState extends State<SliverItemRowAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      value: widget.state.insertRemoveAnimation,
      vsync: this,
      duration: Duration(milliseconds: 200))
    ..addListener(() {
      if (animation.value == 0.0 && !widget.state.enabled) {
        SliverRowBox.of(context)?.verwijder(widget.state);
      } else {
        setState(() {
          widget.state.insertRemoveAnimation = animation.value;
        });
      }
    });

  late Animation animation =
      controller.drive(CurveTween(curve: Curves.easeInOut));

  @override
  void didChangeDependencies() {
    checkAnimation();
    super.didChangeDependencies();
  }

  void didUpdateWidget(SliverItemRowAnimation oldWidget) {
    checkAnimation();
    super.didUpdateWidget(oldWidget);
  }

  checkAnimation() {
    switch (widget.state.animationAction()) {
      case AnimationStatus.forward:
        controller.forward();
        break;
      case AnimationStatus.reverse:
        controller.reverse();
        break;
      default:
        {}
        break;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleResized(
        scale: widget.state.insertRemoveAnimation, child: widget.child);
  }
}

class SliverRowItemBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double radialTop;
  final double radialbottom;

  const SliverRowItemBackground({
    Key? key,
    required this.child,
    this.backgroundColor,
    this.radialTop = 0.0,
    this.radialbottom = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _child = Material(
      child: child,
      type: MaterialType.transparency,
    );

    final bgc = backgroundColor;
    return bgc == null
        ? _child
        : CustomPaint(
            child: _child,
            painter: DrawSliverBackground(
                color: bgc, radialTop: radialTop, radialBottom: radialbottom));
  }
}

class DrawSliverBackground extends CustomPainter {
  final Color color;
  final double radialTop;
  final double radialBottom;

  DrawSliverBackground({
    required this.color,
    required this.radialTop,
    required this.radialBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.height == 0.0) {
      return;
    }
    final paint = Paint()..color = color;

    if (radialTop == 0.0 && radialBottom == 0.0) {
      canvas.drawRect(
          const Offset(0.0, -0.1) & size + const Offset(0.0, 0.1), paint);
    } else {
      double _radialTop;
      double _radialBottom;

      if (size.height < radialTop + radialBottom) {
        _radialTop = size.height / (radialTop + radialBottom) * radialTop;
        _radialBottom = size.height / (radialTop + radialBottom) * radialBottom;
      } else {
        _radialTop = radialTop;
        _radialBottom = radialBottom;
      }

      Rect rect = radialTop == 0.0
          ? Offset.zero & size
          : Offset(0.0, -0.1) & size + const Offset(0.0, 0.1);

      canvas.drawRRect(
          RRect.fromRectAndCorners(rect,
              topLeft: Radius.circular(_radialTop),
              topRight: Radius.circular(_radialTop),
              bottomLeft: Radius.circular(_radialBottom),
              bottomRight: Radius.circular(_radialBottom)),
          paint);
    }
  }

  @override
  bool shouldRepaint(DrawSliverBackground oldDelegate) {
    return color != oldDelegate.color ||
        radialTop != oldDelegate.radialTop ||
        radialBottom != oldDelegate.radialBottom;
  }
}

class SliverBoxItemState<T> {
  double insertRemoveAnimation;
  T value;
  bool enabled;
  String key;

  SliverBoxItemState({
    required this.key,
    required this.insertRemoveAnimation,
    required this.value,
    required this.enabled,
  });

  AnimationStatus animationAction() {
    if (enabled && insertRemoveAnimation != 1.0) {
      return AnimationStatus.forward;
    } else if (!enabled && insertRemoveAnimation != 0.0) {
      return AnimationStatus.reverse;
    } else {
      return AnimationStatus.completed;
    }
  }
}
