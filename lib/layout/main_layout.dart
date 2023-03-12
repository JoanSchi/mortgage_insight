import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MainLayout extends MultiChildRenderObjectWidget {
  final double innerPadding;
  MainLayout({
    Key? key,
    List<Widget> children = const <Widget>[],
    this.innerPadding = 12.0,
  }) : super(key: key, children: children);

  @override
  RenderSummaryPieLayout createRenderObject(BuildContext context) {
    return RenderSummaryPieLayout(innerPadding: innerPadding);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSummaryPieLayout renderObject) {
    renderObject.innerPadding = innerPadding;
  }
}

enum MainLayoutComponent {
  body,
  overlay,
  navigation,
  systemstatusbar,
}

enum MainLayoutPosition {
  fill,
  center,
  left,
  top,
  bottom,
  right,
}

class MainLayoutWidget extends ParentDataWidget<MainLayoutParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const MainLayoutWidget({
    Key? key,
    this.mainLayoutComponent = MainLayoutComponent.body,
    this.mainLayoutPosition = MainLayoutPosition.fill,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    required Widget child,
  }) : super(key: key, child: child);

  final MainLayoutComponent mainLayoutComponent;
  final MainLayoutPosition mainLayoutPosition;
  final double? width;
  final double? height;
  final EdgeInsets padding;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is MainLayoutParentData);
    final MainLayoutParentData parentData =
        renderObject.parentData! as MainLayoutParentData;
    bool needsLayout = false;

    if (parentData.component != mainLayoutComponent) {
      parentData.component = mainLayoutComponent;
      needsLayout = true;
    }

    if (parentData.position != mainLayoutPosition) {
      parentData.position = mainLayoutPosition;
      needsLayout = true;
    }

    if (parentData.width != width) {
      parentData.width = width;
      needsLayout = true;
    }

    if (parentData.height != height) {
      parentData.height = height;
      needsLayout = true;
    }

    if (parentData.padding != padding) {
      parentData.padding = padding;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => MainLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('id', mainLayoutComponent));
  }
}

class MainLayoutParentData extends ContainerBoxParentData<RenderBox> {
  MainLayoutComponent component = MainLayoutComponent.body;
  MainLayoutPosition position = MainLayoutPosition.fill;
  double? width;
  double? height;
  EdgeInsets padding = EdgeInsets.zero;

  @override
  String toString() {
    return 'MainLayoutParentData(component: $component, position: $position, width: $width, height: $height, padding: $padding)';
  }
}

class RenderSummaryPieLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MainLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MainLayoutParentData> {
  double _innerPadding;

  RenderSummaryPieLayout({
    List<RenderBox>? children,
    required double innerPadding,
  }) : _innerPadding = innerPadding {
    addAll(children);
  }

  set innerPadding(double value) {
    if (value != _innerPadding) {
      _innerPadding = value;
      markNeedsLayout();
    }
  }

  double get innerPadding => _innerPadding;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! MainLayoutParentData) {
      child.parentData = MainLayoutParentData();
    }
  }

  @override
  void performLayout() {
    double width = constraints.maxWidth;
    double height = constraints.maxHeight;
    double leftCenter = 0.0;
    double topCenter = 0.0;
    double rightCenter = 0.0;
    double bottomCenter = 0.0;

    layoutChild(RenderBox child) {
      final MainLayoutParentData childParentData =
          child.parentData! as MainLayoutParentData;

      EdgeInsets padding = childParentData.padding;
      double? preferredWidth = childParentData.width;
      double? preferredHeight = childParentData.height;

      final maxWidth = (preferredWidth ?? width - leftCenter - rightCenter) -
          padding.horizontal;

      final maxHeight = (preferredHeight ?? height - topCenter - bottomCenter) -
          padding.vertical;

      bool hasPreferredWidth = preferredWidth != null;
      bool hasPreferredHeight = preferredHeight != null;

      child.layout(BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          parentUsesSize: !hasPreferredWidth && !hasPreferredHeight);

      Size layoutSize;

      if (hasPreferredWidth) {
        layoutSize = Size(preferredWidth, height);
      } else if (hasPreferredHeight) {
        layoutSize = Size(width, preferredHeight);
      } else {
        layoutSize = padding.inflateSize(child.size);
      }

      switch (childParentData.position) {
        case MainLayoutPosition.left:
          childParentData.offset =
              padding.topLeft + Offset(leftCenter, topCenter);
          leftCenter += layoutSize.width;
          break;
        case MainLayoutPosition.top:
          childParentData.offset =
              padding.topLeft + Offset(leftCenter, topCenter);
          topCenter += layoutSize.height;
          break;
        case MainLayoutPosition.right:
          childParentData.offset = padding.topLeft +
              Offset(width - rightCenter - layoutSize.width, topCenter);
          rightCenter += layoutSize.width;
          break;
        case MainLayoutPosition.bottom:
          childParentData.offset = padding.topLeft +
              Offset(leftCenter, height - bottomCenter - layoutSize.height);
          bottomCenter += layoutSize.height;
          break;
        case MainLayoutPosition.center:
          childParentData.offset =
              padding.topLeft + Offset(leftCenter, topCenter);
          break;

        default:
          {
            childParentData.offset = Offset.zero;
            break;
          }
      }
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final MainLayoutParentData childParentData =
          child.parentData! as MainLayoutParentData;

      switch (childParentData.position) {
        case MainLayoutPosition.left:
        case MainLayoutPosition.top:
        case MainLayoutPosition.right:
        case MainLayoutPosition.bottom:
          layoutChild(child);
          break;
        default:
          break;
      }
      child = childParentData.nextSibling;
    }

    child = firstChild;
    while (child != null) {
      final MainLayoutParentData childParentData =
          child.parentData! as MainLayoutParentData;

      switch (childParentData.position) {
        case MainLayoutPosition.center:
          layoutChild(child);
          break;
        case MainLayoutPosition.fill:
          child.layout(constraints.loosen());
          childParentData.offset = Offset.zero;
          break;
        default:
          break;
      }
      child = childParentData.nextSibling;
    }

    size = constraints.biggest;
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
