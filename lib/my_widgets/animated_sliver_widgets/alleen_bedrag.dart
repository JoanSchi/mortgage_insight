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

import 'package:flutter/material.dart';
import 'package:mortgage_insight/utilities/my_number_format.dart';

class AlleenBedragBewerken extends StatefulWidget {
  final double bedrag;
  final String? hintText;
  final String? labelText;
  final bool animationComplete;
  final String? Function(double? value)? validator;
  final Function(double value) veranderingBedrag;

  const AlleenBedragBewerken({
    super.key,
    required this.bedrag,
    this.hintText,
    this.labelText,
    required this.animationComplete,
    required this.veranderingBedrag,
    this.validator,
  });

  @override
  State<AlleenBedragBewerken> createState() => _AlleenBedragBewerkenState();
}

class _AlleenBedragBewerkenState extends State<AlleenBedragBewerken> {
  late TextEditingController _textController;
  late MyNumberFormat nf = MyNumberFormat(context);
  late FocusNode _focusNode;

  @override
  void initState() {
    _textController = TextEditingController(
        text: widget.bedrag == 0.0 ? '' : nf.parseDblToText(widget.bedrag));
    _focusNode = FocusNode();

    if (widget.animationComplete) {
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.animationComplete) {
      _focusNode.requestFocus();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void verandering(String value) {
    widget.veranderingBedrag(nf.parsToDouble(value));
  }

  @override
  Widget build(BuildContext context) {
    const keyboardType = TextInputType.numberWithOptions(
      signed: true,
      decimal: true,
    );

    final inputFormatters = [MyNumberFormat(context).numberInputFormat('#.00')];

    final decoration = InputDecoration(
      hintText: widget.hintText,
      labelText: widget.labelText,
    );

    Widget child = Padding(
      padding:
          const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0, bottom: 2.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: const Color(0xFF21ABCD).withOpacity(0.1)),
          child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 4.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: widget.validator == null
                  ? TextField(
                      textAlign: TextAlign.right,
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: decoration,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (text) {
                        verandering(text);
                      },
                      // onEditingComplete: () {
                      //   FocusScope.of(context).nextFocus();

                      //   scheduleMicrotask(() {
                      //     verandering(_textController.text);
                      //   });
                      // }
                    )
                  : TextFormField(
                      textAlign: TextAlign.right,
                      validator: (String? value) =>
                          widget.validator?.call(nf.parsToDouble(value)),
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: decoration,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      textInputAction: TextInputAction.next,
                      // onEditingComplete: () {
                      //   FocusScope.of(context).nextFocus();
                      //   scheduleMicrotask(() {
                      //     verandering(_textController.text);
                      //   });
                      // }
                      onFieldSubmitted: (text) {
                        verandering(text);
                      },
                    ))),
    );

    return child;
  }
}

class AlleenBedrag extends StatelessWidget {
  final String omschrijving;
  final double bedrag;
  final MyNumberFormat nf;
  final VoidCallback changePanel;
  final double height;
  final String? Function()? validator;

  const AlleenBedrag(
      {Key? key,
      required this.omschrijving,
      required this.bedrag,
      required this.nf,
      required this.changePanel,
      required this.height,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child;

    if (validator != null) {
      child = FormField(
        validator: (String? value) => validator?.call(),
        builder: (FormFieldState state) {
          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              _build(context, theme),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Text(state.errorText ?? 'fout',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12.0,
                      )),
                )
            ],
          );
        },
      );
    } else {
      child = _build(context, theme);
    }

    return SizedBox(
        height: height,
        child: InkWell(
            canRequestFocus: false,
            onTap: changePanel,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            )));
  }

  Widget _build(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
            child: omschrijving.isEmpty
                ? Text(
                    'Omschrijving?',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.error),
                  )
                : Text(omschrijving, style: theme.textTheme.bodyLarge)),
        Text(
            nf.parseDoubleToText(
              bedrag,
            ),
            style: theme.textTheme.bodyLarge),
      ],
    );
  }
}
