// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:selectable_group_widgets/selectable_group_layout/selectable_group_layout.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_group.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_inkwell_group.dart';
import 'package:selectable_group_widgets/selected_group_themes/rounded_group.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../../utilities/match_properties.dart';

typedef GetGroupLayoutProperties = GroupLayoutProperties Function(
  TargetPlatform targetPlatform,
  FormFactorType formFactorType,
);

enum SelectedGroupTheme {
  material,
  materialInkWell,
  button,
}

class SelectableGroupOptions {
  final SelectedGroupTheme selectedGroupTheme;
  final double space;

  const SelectableGroupOptions({
    this.selectedGroupTheme = SelectedGroupTheme.materialInkWell,
    this.space = 0.0,
  });
}

class MyRadioGroup<V> extends RadioGroup<V, SelectableGroupOptions> {
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final List<MatchTargetWrap<SelectableGroupOptions>>? listMatch;

  MyRadioGroup({
    required super.list,
    required super.groupValue,
    required super.onChange,
    super.enabled = true,
    this.primaryColor,
    this.onPrimaryColor,
    this.listMatch,
  });

  @override
  List<Widget> buildChildren(
      BuildContext context, SelectableGroupOptions? options) {
    final o = options ?? const SelectableGroupOptions();

    switch (o.selectedGroupTheme) {
      case SelectedGroupTheme.material:
        {
          return [
            for (RadioSelectable<V> s in list)
              MaterialSelectedRadioBox<V>(
                  enabled: enabled,
                  text: s.text,
                  onChange: onChange,
                  value: s.value,
                  groupValue: groupValue)
          ];
        }
      case SelectedGroupTheme.materialInkWell:
        {
          return [
            for (RadioSelectable<V> s in list)
              MaterialInkwellSelectedRadioBox<V>(
                enabled: enabled,
                text: s.text,
                onChange: onChange,
                value: s.value,
                groupValue: groupValue,
              )
          ];
        }
      case SelectedGroupTheme.button:
        {
          return [
            for (RadioSelectable<V> s in list)
              GroupSpacing(
                space: o.space,
                child: SelectedButton(
                    text: s.text,
                    onChange: onChange,
                    value: s.value,
                    groupValue: groupValue,
                    enabled: enabled,
                    primaryColor: primaryColor,
                    onPrimaryColor: onPrimaryColor,
                    outlinedBorder: const StadiumBorder()),
              )
          ];
        }
    }
  }
}

class MyCheckGroup<V> extends CheckGroup<V, SelectableGroupOptions> {
  final Color? primaryColor;
  final Color? onPrimaryColor;

  MyCheckGroup({
    required super.list,
    required super.onChange,
    super.enabled,
    this.primaryColor,
    this.onPrimaryColor,
  });

  @override
  List<Widget> buildChildren(
      BuildContext context, SelectableGroupOptions? options) {
    final o = options ?? const SelectableGroupOptions();

    switch (o.selectedGroupTheme) {
      case SelectedGroupTheme.material:
        {
          return [
            for (CheckSelectable<V> s in list)
              MaterialSelectableCheckBox(
                text: s.text,
                onChange: (bool? value) => onChange(s.identifier, s.value),
                value: s.value,
                primaryColor: primaryColor,
                onPrimaryColor: onPrimaryColor,
                enabled: s.enabled,
              )
          ];
        }
      case SelectedGroupTheme.materialInkWell:
        {
          return [
            for (CheckSelectable<V> s in list)
              MaterialInkWellSelectableCheckBox(
                text: s.text,
                onChange: (bool? value) => onChange(s.identifier, s.value),
                value: s.value,
                primaryColor: primaryColor,
                onPrimaryColor: onPrimaryColor,
                enabled: s.enabled,
              )
          ];
        }
      case SelectedGroupTheme.button:
        {
          return [
            for (CheckSelectable<V> s in list)
              GroupSpacing(
                space: o.space,
                child: SelectedButton(
                  text: s.text,
                  onChange: (bool? value) => onChange(s.identifier, s.value),
                  value: true,
                  groupValue: s.value,
                  enabled: s.enabled,
                  primaryColor: primaryColor,
                  onPrimaryColor: onPrimaryColor,
                ),
              )
          ];
        }
    }
  }
}

class GroupLayoutProperties {
  final bool wrap;
  final int directionMaxWidgets;
  final Axis direction;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAlignment;
  final WrapAlignment runAlignment;
  final SelectableGroupOptions options;

  GroupLayoutProperties.horizontal({
    this.wrap = true,
    this.directionMaxWidgets = 3,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAlignment = WrapCrossAlignment.center,
    this.runAlignment = WrapAlignment.start,
    this.options = const SelectableGroupOptions(),
  });

  GroupLayoutProperties.vertical({
    this.wrap = false,
    this.directionMaxWidgets = -1,
    this.direction = Axis.vertical,
    this.alignment = WrapAlignment.start,
    this.crossAlignment = WrapCrossAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.options = const SelectableGroupOptions(),
  });
}

class UndefinedSelectableGroup extends StatelessWidget {
  final List<SelectableGroup> groups;
  final GetGroupLayoutProperties? getGroupLayoutProperties;

  const UndefinedSelectableGroup({
    Key? key,
    required this.groups,
    this.getGroupLayoutProperties,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    final properties = getGroupLayoutProperties?.call(
            deviceScreen.platform, deviceScreen.formFactorType) ??
        (deviceScreen.wrapSelectionWidgets
            ? GroupLayoutProperties.horizontal()
            : GroupLayoutProperties.vertical());

    final children = [
      for (SelectableGroup group in groups)
        ...group.buildChildren(context, properties.options)
    ];

    return SelectableGroupLayout(
      wrap: properties.wrap,
      directionMaxWidgets: properties.directionMaxWidgets,
      direction: properties.direction,
      alignment: properties.alignment,
      crossAxisAlignment: properties.crossAlignment,
      runAlignment: properties.runAlignment,
      runSpacing: 0.0,
      // dynamicMaxRuns: const [
      //   DynamicMaxRun(numberList: [2, 1, 2], maxAxisLimit: 350),
      //   DynamicMaxRun(numberList: [5], maxAxisLimit: 900),
      // ],
      children: children,
    );
  }
}
