import 'package:flutter/material.dart';

// const Duration _kMenuDuration = Duration(milliseconds: 300);
// const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
// const double _kMenuDividerHeight = 16.0;
// const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
// const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
// const double _kMenuVerticalPadding = 8.0;
// const double _kMenuWidthStep = 56.0;
// const double _kMenuScreenPadding = 8.0;
// const double _kDefaultIconSize = 24.0;

typedef ChangeSelectedPopupItem = Widget Function(bool selected);

class GroupValueNotifier<V> extends ChangeNotifier {
  V value;

  GroupValueNotifier({
    required this.value,
  });

  setValue(V value) {
    this.value = value;
    notifyListeners();
  }
}

class SelectedMenuPopupIdentifierValue<I, V> {
  I identifier;
  V value;

  SelectedMenuPopupIdentifierValue({
    required this.identifier,
    required this.value,
  });
}

class SinglePopupMenuItem<I> extends SelectablePopupMenuItem<I, bool> {
  const SinglePopupMenuItem(
      {super.key,
      required super.identifierAndValue,
      required super.buildChild,
      super.padding = EdgeInsets.zero});

  @override
  State<SinglePopupMenuItem<I>> createState() => PopupMenuItemState<I>();

  @override
  bool represents(SelectedMenuPopupIdentifierValue<I, bool>? value) =>
      value?.value ?? false;
}

class PopupMenuItemState<I> extends State<SinglePopupMenuItem<I>>
    with _PopupMenuItemState<SinglePopupMenuItem<I>> {
  late SelectedMenuPopupIdentifierValue<I, bool> indentifierAndValue =
      widget.identifierAndValue;

  @override
  void handleTap() {
    widget.onTap?.call();

    setState(() {
      indentifierAndValue.value = !indentifierAndValue.value;
    });

    Navigator.pop<SelectedMenuPopupIdentifierValue<I, bool>>(
        context, widget.identifierAndValue);
  }

  @override
  buildChild() => widget.buildChild(indentifierAndValue.value);
}

class GroupPopupMenuItem<I, V> extends SelectablePopupMenuItem<I, V> {
  final GroupValueNotifier groupValueNotifier;

  const GroupPopupMenuItem(
      {super.key,
      required super.identifierAndValue,
      required this.groupValueNotifier,
      required super.buildChild,
      super.padding = EdgeInsets.zero});

  @override
  State<SelectablePopupMenuItem<I, V>> createState() =>
      GroupPopupMenuItemState<I, V>();

  @override
  bool represents(SelectedMenuPopupIdentifierValue<I, V>? value) =>
      groupValueNotifier.value == identifierAndValue.value;
}

abstract class SelectablePopupMenuItem<I, V>
    extends PopupMenuEntry<SelectedMenuPopupIdentifierValue<I, V>> {
  /// Creates an item for a popup menu.
  ///
  /// By default, the item is [enabled].
  ///
  /// The `enabled` and `height` arguments must not be null.
  const SelectablePopupMenuItem({
    super.key,
    required this.identifierAndValue,
    this.onTap,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.buildChild,
  });

  /// The value that will be returned by [showMenu] if this entry is selected.
  final SelectedMenuPopupIdentifierValue<I, V> identifierAndValue;

  /// Called when the menu item is tapped.
  final VoidCallback? onTap;

  /// Whether the user is permitted to select this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;

  /// The minimum height of the menu item.
  ///
  /// Defaults to [kMinInteractiveDimension] pixels.
  @override
  final double height;

  /// The padding of the menu item.
  ///
  /// Note that [height] may interact with the applied padding. For example,
  /// If a [height] greater than the height of the sum of the padding and [buildChild]
  /// is provided, then the padding's effect will not be visible.
  ///
  /// When null, the horizontal padding defaults to 16.0 on both sides.
  final EdgeInsets? padding;

  /// The text style of the popup menu item.
  ///
  /// If this property is null, then [PopupMenuThemeData.textStyle] is used.
  /// If [PopupMenuThemeData.textStyle] is also null, then [TextTheme.titleMedium]
  /// of [ThemeData.textTheme] is used.
  final TextStyle? textStyle;

  /// {@template flutter.material.popupmenu.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [PopupMenuThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  final MouseCursor? mouseCursor;

  /// The widget below this widget in the tree.
  ///
  /// Typically a single-line [ListTile] (for menus with icons) or a [Text]. An
  /// appropriate [DefaultTextStyle] is put in scope for the child. In either
  /// case, the text should be short enough that it won't wrap.
  final ChangeSelectedPopupItem buildChild;

  // @override
  // SelectableGroupPopupMenuItemState<I, V> createState() =>
  //     SelectableGroupPopupMenuItemState<I, V>();
}

class GroupPopupMenuItemState<I, V> extends State<GroupPopupMenuItem<I, V>>
    with _PopupMenuItemState<GroupPopupMenuItem<I, V>> {
  late GroupValueNotifier groupValueNotifer = widget.groupValueNotifier;
  late SelectedMenuPopupIdentifierValue<I, V> indentifierAndValue =
      widget.identifierAndValue;

  @override
  void initState() {
    groupValueNotifer.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    groupValueNotifer.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  void handleTap() {
    widget.onTap?.call();

    groupValueNotifer.setValue(indentifierAndValue.value);

    Navigator.pop<SelectedMenuPopupIdentifierValue<I, V>>(
        context, widget.identifierAndValue);
  }

  @override
  buildChild() =>
      widget.buildChild(groupValueNotifer.value == indentifierAndValue.value);
}

mixin _PopupMenuItemState<T extends SelectablePopupMenuItem> on State<T> {
  Widget buildChild();

  void handleTap();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.titleMedium!;

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: _EffectiveMouseCursor(
              widget.mouseCursor, popupMenuTheme.mouseCursor),
          child: item,
        ),
      ),
    );
  }
}

class _EffectiveMouseCursor extends MaterialStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final MaterialStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MaterialStateProperty.resolveAs<MouseCursor?>(
            widgetCursor, states) ??
        themeCursor?.resolve(states) ??
        MaterialStateMouseCursor.clickable.resolve(states);
  }

  @override
  String get debugDescription => 'MaterialStateMouseCursor(PopupMenuItemState)';
}
