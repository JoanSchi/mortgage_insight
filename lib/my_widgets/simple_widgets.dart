import 'package:flutter/material.dart';

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
          contentPadding: const EdgeInsets.all(32),
          //border: OutlineInputBorder(),
          border: const _RoundedFillBorder(),
          labelStyle: theme.textTheme.bodyLarge?.copyWith(fontSize: 22),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 32));
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
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0.0);

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
    const radial = 32.0;
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(radial),
          topRight: const Radius.circular(radial),
          bottomLeft: const Radius.circular(radial),
          bottomRight: const Radius.circular(radial),
        ),
        Paint()..color = const Color.fromARGB(255, 239, 249, 253));
  }
}

class CheckValidator extends FormField<String> {
  final Color? errorTextColor;
  final bool softWrap;
  final TextStyle? textStyle;

  CheckValidator(
      {Key? key,
      String? initialValue,
      this.softWrap = true,
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
              final color = errorTextColor ?? theme.colorScheme.error;
              final TextStyle style = textStyle ??
                  theme.textTheme.bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic) ??
                  const TextStyle();

              return Text(
                  (field.hasError ? field.errorText! : (initialValue ?? '')),
                  style: field.hasError ? style.copyWith(color: color) : style);
            });
}
