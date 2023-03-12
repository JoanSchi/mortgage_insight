import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek/gegevens/hypotheek_profiel_overzicht/hypotheek_profiel_overzicht.dart';
import 'package:mortgage_insight/model/nl/hypotheek_document/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/navigation/navigation_page_items.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_card.dart';
import 'package:mortgage_insight/pages/hypotheek/profiel_bewerken/hypotheek_profiel_model.dart';
import 'package:mortgage_insight/pages/hypotheek/profiel_card.dart';

import 'package:mortgage_insight/platform_page_format/default_page.dart';
import '../../model/nl/hypotheek/gegevens/hypotheek/hypotheek.dart';
import '../../model/nl/hypotheek/gegevens/hypotheek_profiel/hypotheek_profiel.dart';
import '../../model/nl/hypotheek/hypotheek.dart';
import '../../platform_page_format/fab_properties.dart';
import '../../state_manager/routes/routes_app.dart';
import '../../utilities/device_info.dart';
import 'state_hypotheek/state_page_hypotheek.dart';

class HypotheekPanel extends ConsumerStatefulWidget {
  const HypotheekPanel({super.key});

  @override
  ConsumerState<HypotheekPanel> createState() => HypotheekPanelState();
}

class HypotheekPanelState extends ConsumerState<HypotheekPanel>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  static const int profielOverzichtTab = 0, hypotheekOverzichtTab = 1;
  int tab = profielOverzichtTab;

  TabController get tabController {
    _tabController ??= TabController(initialIndex: tab, vsync: this, length: 3)
      ..animation?.addListener(() {
        final value = _tabController?.animation?.value;
        final toTab = (value == null) ? 0 : value.round();

        if (toTab != tab) {
          setState(() {
            tab = toTab;
          });
        }
      });
    return _tabController!;
  }

  add() {
    final document = ref.read(hypotheekDocumentProvider);

    switch (tab) {
      case profielOverzichtTab:
        {
          ref.read(profielBewerkenProvider.notifier).nieuw();
          ref
              .read(routeDocumentProvider.notifier)
              .setEditRouteName(name: routeNieuweHypotheekProfielEdit);
          break;
        }
      case hypotheekOverzichtTab:
        {
          break;
        }
    }
    // case XXXX:
    //   {
    //     ref.read(routeEditPageProvider.notifier).editState = EditRouteState(
    //         route: routeNieweHypotheekProfielEdit,
    //         object: HypotheekProfielViewModel(
    //           hypotheekProfielen:
    //               hypotheekContainer.container.hypotheekProfielen,
    //         ));

    //     break;
    //   }

    // ref.read(routeEditPageProvider.notifier).editState = EditRouteState(
    //     route: routeMortgageEdit,
    //     object: HypotheekViewModel(
    //       inkomenLijst: hypotheekContainer.inkomenLijst(),
    //       inkomenLijstPartner: hypotheekContainer.inkomenLijst(partner: true),
    //       profiel:
    //           hypotheekContainer.huidigeHypotheekProfielContainer!.profiel,
    //       schuldenLijst: hypotheekContainer.schuldenContainer.list,
    //     ));
  }

  @override
  void didUpdateWidget(covariant HypotheekPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hypotheekProvielOverzicht =
        ref.watch(hypotheekDocumentProvider).hypotheekProfielOverzicht;

    ref.listen(pageHypotheekProvider,
        (PageHypotheekState? previous, PageHypotheekState next) {
      scheduleMicrotask(() {
        if (_tabController != null) {
          final old = _tabController?.index ?? -1;
          if (old != next.page) {
            _tabController!.animateTo(next.page,
                duration: const Duration(milliseconds: 1000));
          }
        }
      });
    });

    final theme = Theme.of(context);

    bodyBuilder(
        {required BuildContext context,
        required bool nested,
        required double topPadding,
        required double bottomPadding}) {
      Widget subBody;

      if (hypotheekProvielOverzicht.hypotheekProfielen.isEmpty) {
        subBody = const _Empty();
      } else {
        subBody = TabBarView(controller: tabController, children: [
          ListViewHypotheekProfielen(
            nested: nested,
          ),
          ListViewHypotheekLeningen(
            nested: nested,
          ),
          const Center(
              child: Text(
            'Overzicht',
            textScaleFactor: 5.0,
          )),
        ]);
      }

      return subBody;
    }

    PreferredSizeWidget? bottomAppBar = hypotheekProvielOverzicht
            .hypotheekProfielen.isEmpty
        ? null
        : TabBar(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: 'Profiel',
              ),
              Tab(text: 'Leningen'),
            ],
            controller: tabController,
          );

    return DefaultPage(
      bottom: bottomAppBar,
      title: 'Hypotheek',
      imageBuilder: (_) => Image(
          image: const AssetImage(
            'graphics/geldzak.png',
          ),
          color: theme.colorScheme.onSurface),
      bodyBuilder: bodyBuilder,
      fabProperties: FabProperties(icon: const Icon(Icons.add), onTap: add),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      ':{',
      textScaleFactor: 24.0,
    ));
  }
}

class ListViewHypotheekProfielen extends ConsumerWidget {
  final bool nested;

  const ListViewHypotheekProfielen({
    super.key,
    required this.nested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    HypotheekProfielOverzicht overzicht = ref.watch(hypotheekDocumentProvider
        .select((value) => value.hypotheekProfielOverzicht));

    final listProfiels =
        overzicht.hypotheekProfielen.values.map((e) => e).toList();

    return CustomScrollView(
      key: const PageStorageKey<String>('listViewHypotheekProfiel'),
      slivers: [
        if (nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (listProfiels.isNotEmpty)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final hp = listProfiels[index];
                  return ProfielCard(
                    actief: overzicht.actief,
                    hp: hp,
                    selecteren: () => selecteren(hp),
                    verwijderen: () => verwijderen(hp),
                    bewerken: () => bewerken(hp),
                  );
                },
                childCount: listProfiels.length,
              )),
      ],
    );
  }

  void selecteren(HypotheekProfiel hp) {}

  void verwijderen(HypotheekProfiel hp) {}

  void bewerken(HypotheekProfiel hp) {}
}

class ListViewHypotheekLeningen extends ConsumerWidget {
  final bool nested;

  const ListViewHypotheekLeningen({Key? key, required this.nested})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = Theme.of(context);
    // final primaryColor = Colors.white; //theme.colorScheme.inversePrimary;
    // final headline4 = theme.textTheme.headline4?.copyWith(color: Colors.white);

    HypotheekProfiel? profiel =
        ref.watch(hypotheekDocumentProvider.select((value) {
      final overzicht = value.hypotheekProfielOverzicht;
      return overzicht.hypotheekProfielen[overzicht.actief];
    }));

    if (profiel == null) {
      return const Text(
        ':{',
        textScaleFactor: 24,
      );
    }

    final eersteHypotheken = profiel.eersteHypotheken;
    final hypotheken = profiel.hypotheken;

    List<Hypotheek> list = [];

    if (eersteHypotheken.isNotEmpty) {
      for (var e in eersteHypotheken) {
        list.add(e);
        debugPrint('eerste ${e.id}');

        while (e.volgende.isNotEmpty) {
          e = hypotheken[e.volgende]!;
          list.add(e);
          debugPrint('volgende ${e.id}');
        }
      }
    }

    return CustomScrollView(
      key: const PageStorageKey<String>('listViewHypotheekProfiel'),
      slivers: [
        if (nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (list.isNotEmpty)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final hypotheek = list[index];
                  return HypotheekCard(
                    hypotheek: hypotheek,
                    bewerken: () => bewerken,
                    verwijderen: () => verwijderen,
                  );
                },
                childCount: list.length,
              )),
      ],
    );

    // return Material(
    //     borderRadius: BorderRadius.circular(42.0),
    //     child: Padding(
    //         padding: const EdgeInsets.all(20.0),
    //         child: CustomScrollView(
    //           key: PageStorageKey<String>('listViewHypotheekProfiel'),
    //           slivers:
    //               // SliverOverlapInjector(
    //               //   // This is the flip side of the SliverOverlapAbsorber
    //               //   // above.
    //               //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
    //               // ),
    //               (list.length > 0) ? list : const [],
    //         )),
    //     color: Color(0xFFe6f5fa));
  }

  bewerken(Hypotheek hypotheek) {}

  verwijderen(Hypotheek hypotheek) {}
}
