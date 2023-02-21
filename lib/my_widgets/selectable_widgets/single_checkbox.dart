import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_group.dart';
import 'package:selectable_group_widgets/selected_group_themes/material_inkwell_group.dart';

class MyCheckbox extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const MyCheckbox(
      {super.key,
      required this.text,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: MaterialInkWellSelectableCheckBox(
        text: text,
        onChange: onChanged,
        value: value,
      ),
    );
  }
}
