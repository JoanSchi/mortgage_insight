// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:selectable_group_widgets/selectable_group_layout/selectable_group_layout.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_group.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_inkwell_group.dart';
import 'package:selectable_group_widgets/selected_group_themes/rounded_group.dart';

import 'package:mortgage_insight/utilities/device_info.dart';

import '../../platform_page_format/page_properties.dart';
import '../../utilities/match_properties.dart';

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
    final o = findOption(context) ?? options ?? const SelectableGroupOptions();

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

  SelectableGroupOptions? findOption(context) {
    final match = listMatch;

    if (match == null) {
      return null;
    }

    final wrap = DeviceScreen3.of(context).wrapSelectionWidgets;
    final target = defaultTargetPlatform;

    int latestMatchPoints = -1;
    SelectableGroupOptions? object;

    for (MatchTargetWrap f in match) {
      final matchPoints = f.matchPoints(target, wrap);

      if (matchPoints > latestMatchPoints) {
        if (matchPoints == MatchPageProperties.maxPoints) {
          return f.object;
        } else {
          latestMatchPoints = matchPoints;
          object = f.object;
        }
      }
    }

    return object ?? const SelectableGroupOptions();
  }
}

class MyCheckGroup<V> extends CheckGroup<V, SelectableGroupOptions> {
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final List<MatchTargetWrap<SelectableGroupOptions>>? listMatch;

  MyCheckGroup({
    required super.list,
    required super.onChange,
    super.enabled,
    this.primaryColor,
    this.onPrimaryColor,
    this.listMatch,
  });

  @override
  List<Widget> buildChildren(
      BuildContext context, SelectableGroupOptions? options) {
    final o =
        this.findMatch(context) ?? options ?? const SelectableGroupOptions();

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

  SelectableGroupOptions? findMatch(context) {
    final match = listMatch;

    if (match == null) {
      return null;
    }

    final wrap = DeviceScreen3.of(context).wrapSelectionWidgets;
    final target = defaultTargetPlatform;

    int latestMatchPoints = -1;
    SelectableGroupOptions? object;

    for (MatchTargetWrap f in match) {
      final matchPoints = f.matchPoints(target, wrap);

      if (matchPoints > latestMatchPoints) {
        if (matchPoints == MatchPageProperties.maxPoints) {
          return f.object;
        } else {
          latestMatchPoints = matchPoints;
          object = f.object;
        }
      }
    }

    return object ?? const SelectableGroupOptions();
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
  final List<MatchTargetWrap<GroupLayoutProperties>>? matchTargetWrap;

  const UndefinedSelectableGroup({
    Key? key,
    required this.groups,
    this.matchTargetWrap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    final properties = findPageProperties(
        defaultTargetPlatform, deviceScreen.wrapSelectionWidgets);

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

  GroupLayoutProperties findPageProperties(TargetPlatform target, bool wrap) {
    final gl = matchTargetWrap;

    if (gl == null) {
      return (wrap
          ? GroupLayoutProperties.horizontal()
          : GroupLayoutProperties.vertical());
    }
    int latestMatchPoints = -1;
    GroupLayoutProperties? object;

    for (MatchTargetWrap f in gl) {
      final matchPoints = f.matchPoints(target, wrap);

      if (matchPoints > latestMatchPoints) {
        if (matchPoints == MatchPageProperties.maxPoints) {
          return f.object;
        } else {
          latestMatchPoints = matchPoints;
          object = f.object;
        }
      }
    }

    return object ??
        (wrap
            ? GroupLayoutProperties.horizontal()
            : GroupLayoutProperties.vertical());
  }
}
