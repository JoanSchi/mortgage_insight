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

import 'dart:async';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import '../../platform_page_format/default_match_page_properties.dart';
import '../../platform_page_format/default_page.dart';
import '../../platform_page_format/page_actions.dart';
import 'aflopend_krediet/aflopend_krediet_panel.dart';
import 'doorlopend_krediet.dart/doorlopend_krediet.dart';
import 'lease_auto/lease_auto.dart';
import 'schuld_provider.dart';
import 'verzend_krediet/verzend_krediet.dart';

class SchuldBewerkenPanel extends ConsumerStatefulWidget {
  const SchuldBewerkenPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SchuldBewerkenPanel> createState() =>
      _SchuldBewerkenPanelState();
}

class _SchuldBewerkenPanelState extends ConsumerState<SchuldBewerkenPanel> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SchuldBewerken bewerken = ref.watch(schuldProvider);

    final save = PageActionItem(
        text: 'Opslaan',
        icon: Icons.done,
        voidCallback: () {
          FocusScope.of(context).unfocus();

          if ((_formKey.currentState?.validate() ?? false)) {
            final schuld = ref.read(schuldProvider).schuld;
            if (schuld != null) {
              ref
                  .read(hypotheekDocumentProvider.notifier)
                  .schuldToevoegen(schuld);
            }

            scheduleMicrotask(() {
              Beamer.of(context).popToNamed('/document/schulden');
            });
          }
        });

    final cancel = PageActionItem(
        text: 'Annuleren',
        icon: Icons.arrow_back,
        voidCallback: Beamer.of(context).beamBack);

    var (title, image) = switch (bewerken.schuld) {
      (LeaseAuto _) => ('Leaseauto', 'graphics/leaseauto.png'),
      (VerzendKrediet _) => ('Verzendkrediet', 'graphics/verzendkrediet.png'),
      (DoorlopendKrediet _) => (
          'Doorlopendkrediet',
          'graphics/doorlopendkrediet.png'
        ),
      (AflopendKrediet _) => (
          'Aflopendkrediet',
          'graphics/aflopendkrediet.png'
        ),
      (_) => ('Onbekend?', 'graphics/schuld.png')
    };

    return DefaultPage(
        getPageProperties: (
                {required hasScrollBars,
                required formFactorType,
                required orientation,
                required bottom}) =>
            hypotheekPageProperties(
                hasScrollBars: hasScrollBars,
                formFactorType: formFactorType,
                orientation: orientation,
                bottom: bottom,
                leftTopActions: [cancel],
                rightTopActions: [save]),
        title: title,
        imageBuilder: (_) => Image(
            image: AssetImage(
              image,
            ),
            color: theme.colorScheme.onSurface),
        sliversBuilder: (
                {required BuildContext context,
                Widget? appBar,
                required EdgeInsets padding}) =>
            _build(context, theme, appBar, padding, bewerken));
  }

  Widget _build(BuildContext context, ThemeData theme, Widget? appBar,
      EdgeInsets padding, SchuldBewerken bewerken) {
    return Form(
        key: _formKey,
        child: switch (bewerken.schuld) {
          (LeaseAuto _) => LeaseAutoPanel(
              key: const Key('edit_operationalLeaseAuto'),
              padding: padding,
              appBar: appBar,
            ),
          (VerzendKrediet _) => VerzendKredietPanel(
              padding: padding,
              appBar: appBar,
            ),
          (DoorlopendKrediet _) =>
            DoorlopendKredietPanel(padding: padding, appBar: appBar),
          (AflopendKrediet _) => AflopendKredietPanel(
              padding: padding,
              appBar: appBar,
            ),
          (_) => const OhNo(text: 'Schuld not found.')
        });
  }
}
