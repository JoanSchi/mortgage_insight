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

class Welkom extends StatefulWidget {
  const Welkom({super.key});

  @override
  State<Welkom> createState() => _WelkomState();
}

class _WelkomState extends State<Welkom> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Welkom'));
  }
}
