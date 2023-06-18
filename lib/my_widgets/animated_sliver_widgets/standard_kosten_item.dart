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

import 'kosten_item_box_properties.dart';

class StandardKostenItem extends StatelessWidget {
  final KostenItemBoxProperties properties;

  final VoidCallback changePanel;

  const StandardKostenItem({
    Key? key,
    required this.properties,
    required this.changePanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyNumberFormat nf = MyNumberFormat(context);

    final theme = Theme.of(context);
    return SizedBox(
      height: KostenItemBoxProperties.kostenHeightNormal,
      child: InkWell(
        canRequestFocus: false,
        onTap: changePanel,
        child: Row(
          children: [
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
                child: properties.value.omschrijving.isEmpty
                    ? Text(
                        'Omschrijving?',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: theme.colorScheme.error),
                      )
                    : Text(properties.value.omschrijving,
                        style: theme.textTheme.bodyLarge)),
            Text(
                nf.parseDoubleToText(
                  properties.value.getal,
                ),
                style: theme.textTheme.bodyLarge),
            const SizedBox(
              width: 16.0,
            )
          ],
        ),
      ),
    );
  }
}
