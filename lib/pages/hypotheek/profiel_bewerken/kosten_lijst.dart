// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mortgage_insight/my_widgets/animated_scale_resize_switcher.dart';
import 'package:sliver_row_box/sliver_row_box.dart';
import '../../../model/nl/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import '../../../model/nl/hypotheek/kosten_hypotheek.dart';
import '../../../my_widgets/selectable_popupmenu.dart';
import '../../../utilities/my_number_format.dart';

class TotaleKostenRowItem extends StatefulWidget {
  final double totaleKosten;
  final Color? backgroundColor;
  const TotaleKostenRowItem({
    Key? key,
    required this.totaleKosten,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<TotaleKostenRowItem> createState() => _TotaleKostenRowItemState();
}

class _TotaleKostenRowItemState extends State<TotaleKostenRowItem> {
  late final theme = Theme.of(context);
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    Widget child = (widget.totaleKosten > 0.0)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 80.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Divider(
                      indent: 0.0,
                      height: 16.0,
                      thickness: 1.0,
                      color: theme.colorScheme.onPrimary,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        nf.parseDoubleToText(widget.totaleKosten),
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 48.0,
              ),
            ],
          )
        : const SizedBox(
            height: 4.0,
          );

    return AnimatedScaleResizeSwitcher(child: child);
  }
}

class ToevoegenKostenButton extends StatelessWidget {
  final double roundedLeft;
  final double roundedRight;
  final VoidCallback pressed;
  final IconData icon;
  final Color? color;

  const ToevoegenKostenButton({
    Key? key,
    this.roundedLeft = 26.0,
    this.roundedRight = 26.0,
    this.icon = Icons.add,
    required this.pressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final RoundedRectangleBorder outlinedBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(roundedLeft),
      bottomLeft: Radius.circular(roundedLeft),
      topRight: Radius.circular(roundedRight),
      bottomRight: Radius.circular(roundedRight),
    ));

    final backgroundColor = theme.colorScheme.onSecondary;
    final primaryColor = theme.colorScheme.onInverseSurface;

    final button = OutlinedButton(
        style: ButtonStyle(
          visualDensity: const VisualDensity(horizontal: 1, vertical: 1),
          // padding: MaterialStateProperty.all<EdgeInsets>(
          //     const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0)),

          minimumSize: MaterialStateProperty.all<Size>(const Size(88.0, 42.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(outlinedBorder),
          backgroundColor: MaterialStateProperty.all<Color?>(backgroundColor),
          side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
            final color = states.contains(MaterialState.pressed)
                ? primaryColor
                : primaryColor;

            return BorderSide(color: color, width: 1.0);
          }),
        ),
        onPressed: pressed,
        child: Icon(
          icon,
          color: primaryColor,
        ));
    return button;
  }
}

class DefaultKostenRowItem extends StatefulWidget {
  final SliverBoxItemState<Waarde> state;
  final Function(String omschrijving) omschrijvingAanpassen;
  final Function(double value) waardeAanpassen;
  final Widget Function(SliverBoxItemState<Waarde> state) button;
  final bool lastItem;

  const DefaultKostenRowItem(
      {super.key,
      required this.state,
      required this.omschrijvingAanpassen,
      required this.waardeAanpassen,
      required this.button,
      this.lastItem = false});

  @override
  State<DefaultKostenRowItem> createState() => _DefaultKostenRowItemState();
}

class _DefaultKostenRowItemState extends State<DefaultKostenRowItem> {
  late final MyNumberFormat nf = MyNumberFormat(context);

  Waarde get waarde => widget.state.value;

  late final TextEditingController _tecName =
      TextEditingController(text: waarde.omschrijving);

  late final FocusNode _fnName = FocusNode()
    ..addListener(() {
      if (!_fnName.hasFocus) {
        widget.omschrijvingAanpassen(_tecName.text);
      }
    });

  late final TextEditingController _tecWaarde = TextEditingController(
      text: waarde.getal == 0.0 ? '' : nf.parseDblToText(waarde.getal));

  late final FocusNode _fnWaarde = FocusNode()
    ..addListener(() {
      if (!_fnWaarde.hasFocus) {
        widget.waardeAanpassen(nf.parsToDouble(_tecWaarde.text));
      }
    });

  @override
  void dispose() {
    _tecName.dispose();
    _fnName.dispose();
    _tecWaarde.dispose();
    _fnWaarde.dispose();
    super.dispose();
  }

  String get label {
    switch (waarde.eenheid) {
      case Eenheid.percentageWoningWaarde:
        return 'Wonings (%)';
      case Eenheid.percentageLening:
        return 'Lening (%)';
      case Eenheid.bedrag:
        return 'Bedrag';
    }
  }

  String get hintText {
    switch (waarde.eenheid) {
      case Eenheid.percentageLening:
      case Eenheid.percentageWoningWaarde:
        return '%';
      case Eenheid.bedrag:
        return '€';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: _tecName,
              focusNode: _fnName,
              decoration:
                  const InputDecoration(hintText: '...', labelText: 'Naam'),
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          SizedBox(
            width: 80.0,
            child: TextFormField(
              textAlign: TextAlign.right,
              controller: _tecWaarde,
              focusNode: _fnWaarde,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: label,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              inputFormatters: [
                MyNumberFormat(context).numberInputFormat('#.00')
              ],
              textInputAction:
                  widget.lastItem ? TextInputAction.done : TextInputAction.done,
            ),
          ),
          Focus(
              skipTraversal: true,
              descendantsAreTraversable: false,
              child: widget.button(widget.state)),
        ],
      ),
    );
  }
}

class StandaardKostenMenu extends StatefulWidget {
  final Waarde waarde;
  final PopupMenuItemSelected<SelectedMenuPopupIdentifierValue<String, dynamic>>
      aanpassenWaarde;

  const StandaardKostenMenu({
    Key? key,
    required this.aanpassenWaarde,
    required this.waarde,
  }) : super(key: key);

  @override
  State<StandaardKostenMenu> createState() => _StandaardKostenMenuState();
}

class _StandaardKostenMenuState extends State<StandaardKostenMenu> {
  late Eenheid eenheid = widget.waarde.eenheid;
  late bool aftrekbaar = widget.waarde.aftrekbaar;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SelectedMenuPopupIdentifierValue<String, dynamic>>(
      icon: const Icon(Icons.more_vert),
      onSelected: widget.aanpassenWaarde,
      itemBuilder: (BuildContext context) {
        final Waarde w = widget.waarde;

        final eenheidGroupNotifier = GroupValueNotifier(value: w.eenheid);

        return [
          GroupPopupMenuItem<String, Eenheid>(
              identifierAndValue: SelectedMenuPopupIdentifierValue(
                  identifier: 'eenheid', value: Eenheid.bedrag),
              groupValueNotifier: eenheidGroupNotifier,
              buildChild: (bool selected) => KostenMenuItem(
                  selected: selected,
                  icon: const Text('€'),
                  text: 'Bedrag',
                  color: Colors.amber)),

          GroupPopupMenuItem<String, Eenheid>(
              identifierAndValue: SelectedMenuPopupIdentifierValue(
                  identifier: 'eenheid', value: Eenheid.percentageWoningWaarde),
              groupValueNotifier: eenheidGroupNotifier,
              buildChild: (bool selected) => KostenMenuItem(
                  selected: selected,
                  icon: const Text('%'),
                  text: 'Woning',
                  color: Colors.amber)),

          GroupPopupMenuItem<String, Eenheid>(
              identifierAndValue: SelectedMenuPopupIdentifierValue(
                  identifier: 'eenheid', value: Eenheid.percentageLening),
              groupValueNotifier: eenheidGroupNotifier,
              buildChild: (bool selected) => KostenMenuItem(
                  selected: selected,
                  icon: const Text('%'),
                  text: 'Lening',
                  color: Colors.amber)),

          SinglePopupMenuItem<String>(
              identifierAndValue: SelectedMenuPopupIdentifierValue(
                  identifier: 'aftrekbaar', value: w.aftrekbaar),
              buildChild: (bool selected) => KostenMenuItem(
                  selected: selected,
                  icon: const Icon(Icons.mail, color: Color(0XFF154273)),
                  text: 'Aftrekbaar',
                  color: const Color(0xFFddeff8))),

          // if (widget.verwijderen != null)
          const PopupMenuDivider(),
          // if (widget.verwijderen != null)
          PopupMenuItem<SelectedMenuPopupIdentifierValue<String, String>>(
              padding: EdgeInsets.zero,
              value: SelectedMenuPopupIdentifierValue(
                  identifier: 'verwijderen', value: ''),
              child: const KostenMenuItem(
                icon: Icon(Icons.delete, color: Color(0XFF154273)),
                text: 'Verwijderen',
              )),
        ];
      },
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }
}

class VerbouwenVerduurzamenKostenMenu extends StatelessWidget {
  final Waarde waarde;
  final PopupMenuItemSelected<SelectedMenuPopupIdentifierValue<String, dynamic>>
      aanpassenWaarde;

  const VerbouwenVerduurzamenKostenMenu(
      {Key? key, required this.waarde, required this.aanpassenWaarde})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SelectedMenuPopupIdentifierValue<String, dynamic>>(
        icon: const Icon(Icons.more_vert),
        onSelected: aanpassenWaarde,
        itemBuilder: (BuildContext context) {
          return [
            SinglePopupMenuItem<String>(
                identifierAndValue: SelectedMenuPopupIdentifierValue(
                    identifier: 'verduurzamen', value: waarde.verduurzamen),
                buildChild: (bool selected) => KostenMenuItem(
                    selected: selected,
                    icon: const Icon(Icons.eco, color: Color(0XFFBABD42)),
                    text: 'Verduurzamen',
                    color: const Color(0xFF224B0C))),
            const PopupMenuDivider(),
            PopupMenuItem<SelectedMenuPopupIdentifierValue<String, String>>(
                padding: EdgeInsets.zero,
                value: SelectedMenuPopupIdentifierValue(
                    identifier: 'verwijderen', value: ''),
                child: const KostenMenuItem(
                  icon: Icon(Icons.delete, color: Color(0XFF154273)),
                  text: 'Verwijderen',
                )),
          ];
        });
  }
}

class KostenMenuItem extends StatelessWidget {
  final Widget icon;
  final String text;
  final bool selected;
  final Color? color;

  const KostenMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    this.selected = false,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                width: 32.0,
                height: 32.0,
                child: Container(
                  alignment: Alignment.center,
                  decoration: selected
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        )
                      : null,
                  child: icon,
                )),
            const SizedBox(
              width: 8.0,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}

class PopupMenuHeader extends PopupMenuEntry<Never> {
  final Widget child;

  const PopupMenuHeader({Key? key, this.height = 56.0, required this.child})
      : super(key: key);

  @override
  final double height;

  @override
  bool represents(void value) => false;

  @override
  State<PopupMenuHeader> createState() => _PopupMenuHeaderState();
}

class _PopupMenuHeaderState extends State<PopupMenuHeader> {
  @override
  Widget build(BuildContext context) => widget.child;
}

class _SelectedItem<T> {
  T value;
  bool selected;

  _SelectedItem(
    this.value, {
    this.selected = false,
  });
}

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

  DialogListLayout({
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
