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

class EndFocus extends StatefulWidget {
  const EndFocus({super.key});

  @override
  State<EndFocus> createState() => _EndFocusState();
}

class _EndFocusState extends State<EndFocus> {
  bool hasFocus = false;
  late FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode()..addListener(handleFocus);
    super.initState();
  }

  void handleFocus() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    focusNode
      ..removeListener(handleFocus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeepAlive(
        keepAlive: true,
        child: Focus(
            focusNode: focusNode,
            child: Container(
              color: Colors.lightGreen,
              height: 0,
            )));
  }
}
