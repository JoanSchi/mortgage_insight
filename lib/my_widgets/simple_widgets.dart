import 'package:flutter/material.dart';

class RadioSimpel<T> extends StatelessWidget {
  final String title;
  final ValueChanged<T?> onChanged;
  final T value;
  final T groupValue;

  RadioSimpel({
    required this.title,
    required this.onChanged,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged),
      Text(title)
    ]);
  }
}

class CheckboxSimpel extends StatelessWidget {
  final String title;
  final ValueChanged<bool?>? onChanged;
  final bool value;

  CheckboxSimpel({
    required this.title,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Checkbox(value: value, onChanged: onChanged), Text(title)],
    );
  }
}

class OmschrijvingTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;

  const OmschrijvingTextField({
    Key? key,
    this.focusNode,
    this.onSubmitted,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return TextField(
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        enabled: true,
        textAlign: TextAlign.center,
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: 'Omschrijving',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding: EdgeInsets.all(32),
          //border: OutlineInputBorder(),
          border: _RoundedFillBorder(),
          labelStyle: theme.textTheme.bodyText1?.copyWith(fontSize: 22),
        ),
        style: theme.textTheme.bodyText1?.copyWith(fontSize: 32));
  }
}

class _RoundedFillBorder extends InputBorder {
  const _RoundedFillBorder() : super(borderSide: BorderSide.none);

  @override
  _RoundedFillBorder copyWith({BorderSide? borderSide}) =>
      const _RoundedFillBorder();

  @override
  bool get isOutline => true;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0.0);

  @override
  _RoundedFillBorder scale(double t) => const _RoundedFillBorder();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final radial = 32.0;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(radial),
          topRight: Radius.circular(radial),
          bottomLeft: Radius.circular(radial),
          bottomRight: Radius.circular(radial),
        ),
        Paint()..color = Color.fromARGB(255, 239, 249, 253));
  }
}

class CheckValidator extends FormField<String> {
  final Color? errorTextColor;
  final bool softWrap;
  final TextStyle? textStyle;

  CheckValidator(
      {Key? key,
      String? initialValue,
      this.softWrap: true,
      FormFieldSetter<String>? onSaved,
      FormFieldValidator<String>? validator,
      AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
      bool enabled = true,
      this.errorTextColor,
      this.textStyle})
      : super(
            key: key,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            builder: (FormFieldState<String> field) {
              final ThemeData theme = Theme.of(field.context);
              final color = errorTextColor ?? theme.errorColor;
              final TextStyle style = textStyle ??
                  theme.textTheme.caption!
                      .copyWith(fontStyle: FontStyle.italic);

              return Text(
                  (field.hasError ? field.errorText! : (initialValue ?? '')),
                  style: field.hasError ? style.copyWith(color: color) : style);
            });
}
