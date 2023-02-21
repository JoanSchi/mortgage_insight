// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:mortgage_insight/utilities/device_info.dart';

class SelectedIdentifier<I, V> {
  I indentifier;
  V value;

  SelectedIdentifier({
    required this.indentifier,
    required this.value,
  });
}

class SelectableItem<T> {
  final Widget child;
  final T value;
  SelectableItem({required this.child, required this.value});
}

class SelectableRadioItem<T> {
  final String text;
  final T value;

  SelectableRadioItem({required this.text, required this.value});
}

class SelectableCheckItem {
  final String text;
  final bool value;
  final ValueChanged<bool?> changeChecked;
  SelectableCheckItem(
      {required this.text, required this.value, required this.changeChecked});
}

class SelectableButtonGroup<T> extends StatelessWidget {
  final List<SelectableItem<T>> selectableItems;

  final T groupValue;
  final ValueChanged<T> onChange;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? primaryColorSelected;
  final Color? backgroundColorSelected;

  const SelectableButtonGroup(
      {Key? key,
      required this.selectableItems,
      required this.groupValue,
      required this.onChange,
      this.primaryColor,
      this.backgroundColor,
      this.primaryColorSelected,
      this.backgroundColorSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: selectableItems
            .map((SelectableItem<T> v) => SelectedButton<T>(
                  value: v.value,
                  child: v.child,
                  groupValue: groupValue,
                  onChange: onChange,
                  primaryColor: primaryColor ?? Colors.black87,
                  backgroundColor:
                      backgroundColor ?? theme.backgroundColor.withOpacity(0.5),
                  primaryColorSelected: Colors.white,
                  backgroundColorSelected:
                      const Color.fromARGB(255, 87, 152, 187),
                ))
            .toList());
  }
}

class SelectedButton<T> extends StatelessWidget {
  final Widget child;
  final ValueChanged<T> onChange;
  final T value;
  final T groupValue;
  final EdgeInsets padding;
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? primaryColorSelected;
  final Color? backgroundColorSelected;

  const SelectedButton(
      {Key? key,
      required this.child,
      required this.onChange,
      required this.value,
      required this.groupValue,
      this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
      this.primaryColor,
      this.backgroundColor,
      this.primaryColorSelected,
      this.backgroundColorSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: selected ? primaryColorSelected : primaryColor,
      backgroundColor: selected ? backgroundColorSelected : backgroundColor,
      minimumSize: const Size(88.0, 52.0),
      padding: padding,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
    );

    return TextButton(
      style: flatButtonStyle,
      onPressed: () => onChange(value),
      child: child,
    );
  }
}

class SelectableRadioGroup<T> extends StatelessWidget {
  final List<SelectableRadioItem<T>> selectableRadioItems;

  final T groupValue;
  final ValueChanged<T?> onChange;

  const SelectableRadioGroup({
    Key? key,
    required this.selectableRadioItems,
    required this.groupValue,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    final children = selectableRadioItems
        .map((SelectableRadioItem<T> v) => SelectedRadioBox<T>(
              value: v.value,
              text: v.text,
              groupValue: groupValue,
              onChange: onChange,
            ))
        .toList();

    return deviceScreen.wrapSelectionWidgets
        ? Wrap(alignment: WrapAlignment.center, children: children)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
  }
}

class SelectedRadioBox<T> extends StatelessWidget {
  final String text;
  final ValueChanged<T?> onChange;
  final T value;
  final T groupValue;

  const SelectedRadioBox({
    Key? key,
    required this.text,
    required this.onChange,
    required this.value,
    required this.groupValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyText1;

    return InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () => onChange(value),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                groupValue: groupValue,
                value: value,
                onChanged: onChange,
                splashRadius: 0.0,
              ),
              Text(
                text,
                style: textStyle,
              ),
              SizedBox(
                width: 16.0,
              ),
            ],
          ),
        ));
  }
}

class SelectableCheck extends StatelessWidget {
  final SelectableCheckItem selectableItems;

  const SelectableCheck({
    Key? key,
    required this.selectableItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SelectableCheckBox(
      value: selectableItems.value,
      text: selectableItems.text,
      onChange: selectableItems.changeChecked,
    );
  }
}

class SelectableCheckGroup extends StatelessWidget {
  final List<SelectableCheckItem> selectableItems;

  const SelectableCheckGroup({
    Key? key,
    required this.selectableItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    final children = selectableItems
        .map((SelectableCheckItem v) => _SelectableCheckBox(
              value: v.value,
              text: v.text,
              onChange: v.changeChecked,
            ))
        .toList();

    return deviceScreen.wrapSelectionWidgets
        ? Wrap(alignment: WrapAlignment.center, children: children)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
  }
}

class _SelectableCheckBox extends StatelessWidget {
  final String text;
  final ValueChanged<bool?> onChange;
  final bool value;

  const _SelectableCheckBox({
    Key? key,
    required this.text,
    required this.onChange,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyText1;

    return InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          onChange(!value);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: value,
                onChanged: onChange,
                splashRadius: 0.0,
              ),
              Text(
                text,
                style: textStyle,
              ),
              SizedBox(
                width: 16.0,
              ),
            ],
          ),
        ));
  }
}

class UndefinedSelectableGroup extends StatelessWidget {
  final List<Widget> children;

  const UndefinedSelectableGroup({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    return deviceScreen.wrapSelectionWidgets
        ? Wrap(alignment: WrapAlignment.center, children: children)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
  }
}
