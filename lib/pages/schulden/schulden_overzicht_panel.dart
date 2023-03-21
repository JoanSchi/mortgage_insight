import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_document/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/navigation/navigation_page_items.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';
import '../../model/nl/schulden/schulden.dart';
import '../../platform_page_format/default_page.dart';
import '../../platform_page_format/fab_properties.dart';
import '../../platform_page_format/page_properties.dart';
import '../../utilities/device_info.dart';
import 'schulden_card/schulden_card.dart';

class SchuldenOverzichtPanel extends ConsumerStatefulWidget {
  const SchuldenOverzichtPanel({super.key});

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
        .setEditRouteName(name: routeDebtsAdd);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SchuldenOverzicht schulden = ref.watch(
        hypotheekDocumentProvider.select((value) => value.schuldenOverzicht));

    final lijst = schulden.lijst;
    bodyBuilder(
            {required BuildContext context,
            required bool nested,
            required double topPadding,
            required double bottomPadding}) =>
        Builder(
            builder: (context) => CustomScrollView(slivers: [
                  if (nested)
                    SliverOverlapInjector(
                      // This is the flip side of the SliverOverlapAbsorber
                      // above.
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                  if (schulden.lijst.isNotEmpty)
                    SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 600.0,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: 1.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final schuld = lijst[index];

                            return schuld.map(
                                leaseAuto: (LeaseAuto leaseAuto) =>
                                    LeaseAutoCard(
                                        leaseAuto: leaseAuto,
                                        aanpassen: () => aanpassen(leaseAuto),
                                        verwijderen: () =>
                                            verwijderen(leaseAuto)),
                                aflopendKrediet: (AflopendKrediet ak) =>
                                    AflopendKredietCard(
                                        ak: ak,
                                        aanpassen: () => aanpassen(ak),
                                        verwijderen: () => verwijderen(ak)),
                                verzendKrediet: (VerzendKrediet vk) =>
                                    VerzendKredietCard(
                                        vk: vk,
                                        aanpassen: () => aanpassen(vk),
                                        verwijderen: () => verwijderen(vk)),
                                doorlopendKrediet: (DoorlopendKrediet dk) =>
                                    DoorlopendKredietCard(
                                        dk: dk,
                                        aanpassen: () => aanpassen(dk),
                                        verwijderen: () => verwijderen(dk)));
                          },
                          childCount: lijst.length,
                        ))
                ]));

    return DefaultPage(
      title: 'Schulden',
      matchPageProperties: const [
        MatchPageProperties(
            types: {FormFactorType.unknown},
            pageProperties: PageProperties(hasNavigationBar: true))
      ],
      imageBuilder: (_) => Image(
          image: const AssetImage(
            'graphics/schuld.png',
          ),
          color: theme.colorScheme.onSurface),
      bodyBuilder: bodyBuilder,
      fabProperties: FabProperties(onTap: add, icon: const Icon(Icons.add)),
    );
  }

  void aanpassen(Schuld schuld) {
    ref.read(schuldProvider.notifier).editSchuld(schuld);
    ref
        .read(routeDocumentProvider.notifier)
        .setEditRouteName(name: routeDebtsEdit);
  }

  void verwijderen(Schuld schuld) {
    ref.read(hypotheekDocumentProvider.notifier).schuldVerwijderen(schuld);
  }
}
