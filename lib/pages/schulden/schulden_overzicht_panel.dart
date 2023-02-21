import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/navigation/navigation_page_items.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';

import '../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../model/nl/schulden/schulden.dart';
import '../../platform_page_format/default_page.dart';
import '../../platform_page_format/fabProperties.dart';
import '../../utilities/device_info.dart';
import 'debt_list/debt_list.dart';

class SchuldenOverzichtPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SchuldenOverzichtPanelState();
}

class _SchuldenOverzichtPanelState
    extends ConsumerState<SchuldenOverzichtPanel> {
  add() {
    ref.read(schuldProvider.notifier).resetSchuld();
    ref
        .read(routeDocumentProvider.notifier)
        .setEditRouteName(name: routeDebtsEdit);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SchuldenOverzicht schulden = ref.watch(
        hypotheekContainerProvider.select((value) => value.schuldenOverzicht));

    final bodyBuilder =
        ({required BuildContext context, required bool nested}) => Builder(
            builder: (context) => GridList(
                  list: schulden.lijst,
                  nested: nested,
                ));

    return DefaultPage(
      title: 'Schulden',
      imageBuilder: (_) => Image(
          image: AssetImage(
            'graphics/fit_debts.png',
          ),
          color: theme.colorScheme.onSurface),
      bodyBuilder: bodyBuilder,
      fabProperties: FabProperties(onTap: add, icon: Icon(Icons.add)),
    );
  }
}
