import 'package:flutter/material.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_inkwell_group.dart';

class MyCheckbox extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool enabled;

  const MyCheckbox(
      {super.key,
      required this.text,
      required this.value,
      required this.onChanged,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MaterialInkWellSelectableCheckBox(
        text: text,
        onChange: onChanged,
        value: value,
        enabled: enabled,
      ),
    );
  }
}
