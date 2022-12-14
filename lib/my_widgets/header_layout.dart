import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HeaderLayout extends MultiChildRenderObjectWidget {
  final double space;

  HeaderLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    this.space = 12.0,
  }) : super(key: key, children: children);

  @override
  RenderHeaderLayout createRenderObject(BuildContext context) {
    return RenderHeaderLayout(
      space: space,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderHeaderLayout renderObject) {
    renderObject..space = space;
  }
}

enum HeaderLayoutID {
  left,
  title,
  right,
}

class HeaderLayoutDataWidget extends ParentDataWidget<HeaderLayoutParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const HeaderLayoutDataWidget({
    Key? key,
    this.id = HeaderLayoutID.title,
    required Widget child,
  }) : super(key: key, child: child);

  final HeaderLayoutID id;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is HeaderLayoutParentData);
    final HeaderLayoutParentData parentData =
        renderObject.parentData! as HeaderLayoutParentData;
    bool needsLayout = false;

    if (parentData.id != id) {
      parentData.id = id;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => HeaderLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('id', id));
  }
}

class HeaderLayoutParentData extends ContainerBoxParentData<RenderBox> {
  HeaderLayoutID id = HeaderLayoutID.title;

  @override
  String toString() => '${super.toString()}; id=$id';
}

class RenderHeaderLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, HeaderLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, HeaderLayoutParentData> {
  double _space;

  RenderHeaderLayout({
    List<RenderBox>? children,
    required double space,
  }) : _space = space {
    addAll(children);
  }

  set space(double value) {
    if (value != _space) {
      _space = value;
      markNeedsLayout();
    }
  }

  double get space => _space;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! HeaderLayoutParentData)
      child.parentData = HeaderLayoutParentData();
  }

  @override
  void performLayout() {
    double leftWidth = 0.0;
    double rightWidth = 0.0;
    double height = 0.0;

    RenderBox? child = firstChild;

    while (child != null) {
      final HeaderLayoutParentData childParentData =
          child.parentData! as HeaderLayoutParentData;

      switch (childParentData.id) {
        case HeaderLayoutID.left:
          {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
                parentUsesSize: true);

            final s = child.size;
            leftWidth = s.width + space;

            if (s.height > height) {
              height = s.height;
            }
            break;
          }
        case HeaderLayoutID.right:
          {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth,
                ),
                parentUsesSize: true);

            final s = child.size;
            rightWidth = s.width + space;

            if (s.height > height) {
              height = s.height;
            }
            break;
          }
        case HeaderLayoutID.title:
          {}
      }

      child = childParentData.nextSibling;
    }

    final t = (leftWidth < rightWidth ? rightWidth : leftWidth);

    child = firstChild;

    while (child != null) {
      final HeaderLayoutParentData childParentData =
          child.parentData! as HeaderLayoutParentData;

      switch (childParentData.id) {
        case HeaderLayoutID.title:
          {
            child.layout(
                BoxConstraints(
                  maxWidth: constraints.maxWidth - t * 2.0,
                ),
                parentUsesSize: true);

            final s = child.size;

            if (s.height > height) {
              height = s.height;
            }
            break;
          }
        default:
          {}
      }

      child = childParentData.nextSibling;
    }

    child = firstChild;

    while (child != null) {
      final HeaderLayoutParentData childParentData =
          child.parentData! as HeaderLayoutParentData;

      switch (childParentData.id) {
        case HeaderLayoutID.left:
          {
            final s = child.size;
            childParentData.offset = Offset(0.0, (height - s.height) / 2.0);

            break;
          }
        case HeaderLayoutID.title:
          {
            final s = child.size;
            childParentData.offset = Offset(
                (constraints.maxWidth - s.width) / 2.0,
                (height - s.height) / 2.0);

            break;
          }
        default:
          {
            final s = child.size;
            childParentData.offset = Offset(
                constraints.maxWidth - s.width, (height - s.height) / 2.0);
          }
      }

      child = childParentData.nextSibling;
    }

    size = Size(constraints.maxWidth, height);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
