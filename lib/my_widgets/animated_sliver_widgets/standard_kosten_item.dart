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

class StandardKostenItem extends StatelessWidget {
  final double height;
  final String omschrijving;
  final String bedrag;
  final String sup;

  final VoidCallback changePanel;

  const StandardKostenItem({
    Key? key,
    required this.height,
    required this.omschrijving,
    required this.bedrag,
    this.sup = '',
    required this.changePanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: InkWell(
        canRequestFocus: false,
        onTap: changePanel,
        child: Row(
          children: [
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
                child: omschrijving.isEmpty
                    ? Text(
                        '...',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.blueGrey[500]),
                      )
                    : Text(omschrijving, style: theme.textTheme.bodyLarge)),
            if (sup.isNotEmpty)
              Align(
                  alignment: const Alignment(0, -0.35),
                  child: Text(
                    sup,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.blueGrey[500]),
                    textScaleFactor: 0.5,
                  )),
            Text(bedrag, style: theme.textTheme.bodyLarge),
            const SizedBox(
              width: 8.0,
            )
          ],
        ),
      ),
    );
  }
}
