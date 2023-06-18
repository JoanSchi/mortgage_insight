// Copyright (C) 2023 Joan Schipper
//
// This file is part of mortgage_insight.
//
// mortgage_insight is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// mortgage_insight is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'dart:math' as math;

Future<List<Waarde>?> showKosten(
    {required BuildContext context,
    required String title,
    required Image? image,
    required List<Waarde> lijst}) async {
  final size = MediaQuery.of(context).size;

  final EdgeInsets insetPadding;

  if (size.width < 500.0) {
    insetPadding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0);
  } else {
    insetPadding = const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);
  }

  return await showDialog<List<Waarde>?>(
    useRootNavigator: true,
    context: context,
    builder: (BuildContext context) => Dialog(
        clipBehavior: Clip.antiAlias,
        insetPadding: insetPadding,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: _SelectableLijst(
          lijst: lijst,
          title: title,
          image: image,
        )),
  );
}

class _SelectableLijst extends StatefulWidget {
  final List<Waarde> lijst;
  final String title;
  final Image? image;

  const _SelectableLijst({
    Key? key,
    required this.title,
    required this.lijst,
    this.image,
  }) : super(key: key);

  @override
  State<_SelectableLijst> createState() => _SelectableLijstState();
}

class _SelectableLijstState extends State<_SelectableLijst> {
  late List<_SelectedItem<Waarde>> l =
      widget.lijst.map((Waarde e) => _SelectedItem<Waarde>(e)).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const heightItem = 56.0;
    final children = l
        .map((_SelectedItem<Waarde> e) => SizedBox(
              height: heightItem,
              child: CheckboxListTile(
                value: e.selected,
                title: Text(e.value.omschrijving.isEmpty
                    ? 'Overige'
                    : e.value.omschrijving),
                onChanged: (bool? value) {
                  setState(() {
                    e.selected = value ?? false;
                  });
                },
              ),
            ))
        .toList();

    final itemsHeight = l.length * heightItem;

    return DialogListLayout(
      minHeightContent: 6 * heightItem,
      heightContent: itemsHeight,
      maxWidth: 900.0,
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Text(
          widget.title,
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const Divider(),
        DialogListLayoutDataWidget(
          content: DialogListLayoutContent.list,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints boxConstraints) {
            Widget lv;
            if (itemsHeight <= boxConstraints.maxHeight) {
              lv = Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              );
            } else {
              lv = ListView(
                children: children,
              );
            }

            Image? image;
            double right = 0.0;
            double widthImage = math.min(boxConstraints.maxWidth / 2.0, 256.0);
            double heightImage = 0.0;

            if (boxConstraints.maxWidth > 500.0) {
              right = 56.0;
              image = widget.image;
              heightImage =
                  math.min(boxConstraints.maxHeight / 3.0 * 2.0, 256.0);
            } else if (boxConstraints.maxHeight - itemsHeight > 80.0) {
              right = 4.0;
              heightImage = boxConstraints.maxHeight - itemsHeight + 8.0;
              image = widget.image;
            }

            return Stack(
              children: [
                if (image != null)
                  Positioned(
                    right: right,
                    bottom: 0.0,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: widthImage,
                          maxHeight: heightImage,
                        ),
                        child: image),
                  ),
                Positioned(
                    left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: lv)
              ],
            );
          }),
        ),
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(
              child: const Text('Annuleren'),
              onPressed: () {
                Navigator.of(context).pop<List<Waarde>?>(null);
              }),
          TextButton(
              child: const Text('Invoegen'),
              onPressed: () {
                Navigator.of(context).pop<List<Waarde>?>(
                    (List<_SelectedItem>.from(l)
                          ..retainWhere((_SelectedItem e) => e.selected))
                        .map<Waarde>((_SelectedItem e) => e.value)
                        .toList());
              }),
        ]),
      ],
    );
  }
}

class DialogListLayout extends MultiChildRenderObjectWidget {
  final double minHeightContent;
  final double heightContent;
  final EdgeInsets padding;
  final double maxWidth;

  const DialogListLayout({
    super.key,
    super.children,
    this.minHeightContent = 12.0,
    required this.heightContent,
    this.maxWidth = double.infinity,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  RenderDialogListLayout createRenderObject(BuildContext context) {
    return RenderDialogListLayout(
        padding: padding,
        minHeightContent: minHeightContent,
        heightContent: heightContent,
        maxWidth: maxWidth);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderDialogListLayout renderObject) {
    renderObject
      ..padding = padding
      ..heightContent = heightContent
      ..minHeightContent = minHeightContent
      ..maxWidth = maxWidth;
  }
}

enum DialogListLayoutContent {
  list,
  sized,
}

class DialogListLayoutDataWidget
    extends ParentDataWidget<DialogListLayoutParentData> {
  /// Creates a widget that controls how a child of a [Row], [Column], or [Flex]
  /// flexes.
  const DialogListLayoutDataWidget({
    Key? key,
    required this.content,
    required Widget child,
  }) : super(key: key, child: child);

  final DialogListLayoutContent content;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is DialogListLayoutParentData);
    final DialogListLayoutParentData parentData =
        renderObject.parentData! as DialogListLayoutParentData;
    bool needsLayout = false;

    if (parentData.content != content) {
      parentData.content = content;
      needsLayout = true;
    }

    if (needsLayout) {
      final AbstractNode? targetParent = renderObject.parent;
      if (targetParent is RenderObject) targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => DialogListLayout;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty('content', content));
  }
}

class DialogListLayoutParentData extends ContainerBoxParentData<RenderBox> {
  DialogListLayoutContent content = DialogListLayoutContent.sized;
  double height = 0.0;

  @override
  String toString() => '${super.toString()}; id=$content';
}

class RenderDialogListLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, DialogListLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, DialogListLayoutParentData> {
  double _minHeight;
  double _height;
  EdgeInsets _padding;
  double _maxWidth;

  RenderDialogListLayout({
    List<RenderBox>? children,
    required double minHeightContent,
    required double heightContent,
    required EdgeInsets padding,
    required double maxWidth,
  })  : _minHeight = minHeightContent,
        _maxWidth = maxWidth,
        _height = heightContent,
        _padding = padding {
    addAll(children);
  }

  set heightContent(double value) {
    if (value != heightContent) {
      _height = value;
      markNeedsLayout();
    }
  }

  double get heightContent => _height;

  set minHeightContent(double value) {
    if (value != _minHeight) {
      _minHeight = value;
      markNeedsLayout();
    }
  }

  double get minHeightContent => _minHeight;

  set maxWidth(double value) {
    if (value != _maxWidth) {
      _maxWidth = value;
      markNeedsLayout();
    }
  }

  double get maxWidth => _maxWidth;

  set padding(EdgeInsets value) {
    if (value != _padding) {
      _padding = value;
      markNeedsLayout();
    }
  }

  EdgeInsets get padding => _padding;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! DialogListLayoutParentData) {
      child.parentData = DialogListLayoutParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    double width = math.min(constraints.maxWidth, _maxWidth);
    double height = constraints.maxHeight;

    double maxHeightContent = height - padding.vertical;
    double calculatedHeightContent = heightContent;

    while (child != null) {
      final DialogListLayoutParentData childParentData =
          child.parentData! as DialogListLayoutParentData;

      if (childParentData.content != DialogListLayoutContent.list) {
        child.layout(
            BoxConstraints(
                minWidth: width - padding.horizontal,
                maxWidth: width - padding.horizontal,
                maxHeight: calculatedHeightContent),
            parentUsesSize: true);
        childParentData.height = child.size.height;
        maxHeightContent -= child.size.height;
      }
      child = childParentData.nextSibling;
    }

    if (calculatedHeightContent < minHeightContent) {
      calculatedHeightContent = minHeightContent;
    }

    if (calculatedHeightContent > maxHeightContent) {
      calculatedHeightContent = maxHeightContent;
    }

    double x = padding.left;
    double y = padding.top;
    child = firstChild;
    while (child != null) {
      final DialogListLayoutParentData childParentData =
          child.parentData! as DialogListLayoutParentData;

      if (childParentData.content == DialogListLayoutContent.list) {
        child.layout(
            BoxConstraints(
                maxWidth: width - padding.horizontal,
                maxHeight: calculatedHeightContent),
            parentUsesSize: true);
        childParentData.offset = Offset(x, y);
        y += child.size.height;
      } else {
        childParentData.offset = Offset(x, y);
        y += childParentData.height;
      }

      child = childParentData.nextSibling;
    }

    height = y + padding.bottom;
    size = Size(width, height);
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

class _SelectedItem<T> {
  T value;
  bool selected;

  _SelectedItem(
    this.value, {
    this.selected = false,
  });
}
