import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier_overzicht/hypotheek_dossier_overzicht.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_card.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_view_model.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_dossier_card.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import '../../platform_page_format/default_match_page_properties.dart';
import '../../platform_page_format/fab_properties.dart';
import 'hypotheek_bewerken/model/hypotheek_view_model.dart';
import 'state_hypotheek/state_page_hypotheek.dart';

class HypotheekPanel extends ConsumerStatefulWidget {
  final String onderwerp;
  const HypotheekPanel({super.key, required this.onderwerp});

  @override
  ConsumerState<HypotheekPanel> createState() => HypotheekPanelState();
}

class HypotheekPanelState extends ConsumerState<HypotheekPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BeamerDelegate? beamerDelegate;

  static const int dossierOverzichtTab = 0,
      hypotheekOverzichtTab = 1,
      hyptheekTabel = 2;
  int tab = dossierOverzichtTab;

  @override
  void initState() {
    tab = onderwerpNaTabIndex(widget.onderwerp);
    _tabController = TabController(initialIndex: tab, vsync: this, length: 3)
      ..animation?.addListener(() {
        final value = _tabController.animation?.value;
        final toTab = (value == null) ? 0 : value.round();

        if (toTab != tab) {
          setState(() {
            tab = toTab;
          });
          Beamer.of(context).beamToNamed('/document/hypotheek/${switch (toTab) {
            0 => 'dossier',
            1 => 'lening',
            _ => 'overzicht'
          }}');
        }
      });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    beamerDelegate ??= Beamer.of(context)..addListener(changeTab);
    super.didChangeDependencies();
  }

  void changeTab() {
    String onderwerp =
        (beamerDelegate?.currentBeamLocation.state.routeInformation.location ??
                '')
            .split('/')
            .last;

    if ((onderwerp == 'dossier' ||
            onderwerp == 'lening' ||
            onderwerp == 'overzicht') &&
        onderwerp != tabIndexNaOnderwerp(tab)) {
      _tabController.animateTo(onderwerpNaTabIndex(onderwerp));
    }
  }

  @override
  void didUpdateWidget(covariant HypotheekPanel oldWidget) {
    if (widget.onderwerp != oldWidget.onderwerp) {
      _tabController.animateTo(onderwerpNaTabIndex(widget.onderwerp));
    }
    super.didUpdateWidget(oldWidget);
  }

  int onderwerpNaTabIndex(String onderwerp) =>
      switch (onderwerp) { 'lening' => 1, 'overzicht' => 2, _ => 0 };

  String tabIndexNaOnderwerp(int tab) =>
      switch (tab) { 1 => 'lening', 2 => 'overzicht', _ => 'dossier' };

  @override
  void dispose() {
    beamerDelegate?.removeListener(changeTab);
    _tabController.dispose();
    super.dispose();
  }

  add() {
    final document = ref.read(hypotheekDocumentProvider);

    switch (tab) {
      case dossierOverzichtTab:
        {
          ref.read(hypotheekDossierProvider.notifier).bewerken(
              dossiers: document.hypotheekDossierOverzicht.hypotheekDossiers);
          Beamer.of(context, root: true).beamToNamed(
            '/document/hypotheek/dossier/toevoegen',
          );
          break;
        }
      case hypotheekOverzichtTab:
        {
          final hypotheekDossier =
              document.hypotheekDossierOverzicht.hypotheekDossierGeselecteerd;
          if (hypotheekDossier != null) {
            ref
                .read(hypotheekBewerkenProvider.notifier)
                .bewerken(hypotheekDocument: document);
            Beamer.of(context, root: true).beamToNamed(
              '/document/hypotheek/lening/toevoegen',
            );
          }
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
  Widget build(BuildContext context) {
    final hypotheekDossierOverzicht =
        ref.watch(hypotheekDocumentProvider).hypotheekDossierOverzicht;

    ref.listen(pageHypotheekProvider,
        (PageHypotheekState? previous, PageHypotheekState next) {
      scheduleMicrotask(() {
        final old = _tabController.index;
        if (old != next.page) {
          _tabController.animateTo(next.page,
              duration: const Duration(milliseconds: 1000));
        }
      });
    });

    final theme = Theme.of(context);

    Widget bodyBuilder(
        {required BuildContext context, required EdgeInsets padding}) {
      Widget subBody;

      if (hypotheekDossierOverzicht.isEmpty) {
        subBody = const _Empty();
      } else {
        subBody = TabBarView(controller: _tabController, children: [
          HypotheekDossiersOverzicht(
            padding: padding,
          ),
          ListViewHypotheekLeningen(
            padding: padding,
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

    bool hasBottomAppBar = !hypotheekDossierOverzicht.isEmpty;

    return DefaultPage(
      title: 'Hypotheek',
      imageBuilder: (_) => Image(
          image: const AssetImage(
            'graphics/geldzak.png',
          ),
          color: theme.colorScheme.onSurface),
      bodyBuilder: bodyBuilder,
      getPageProperties: (
              {required hasScrollBars,
              required formFactorType,
              required orientation,
              required bottom}) =>
          hypotheekPageProperties(
              hasScrollBars: hasScrollBars,
              formFactorType: formFactorType,
              orientation: orientation,
              hasNavigationBar: true,
              bottom: bottom),
      fabProperties: FabProperties(icon: const Icon(Icons.add), onTap: add),
      tabController: hasBottomAppBar ? _tabController : null,
      tabs: hasBottomAppBar
          ? const [
              Tab(
                text: 'Dossier',
              ),
              Tab(
                text: 'Lening',
              ),
              Tab(
                text: 'Overzicht',
              )
            ]
          : null,
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

class HypotheekDossiersOverzicht extends ConsumerStatefulWidget {
  final EdgeInsets padding;

  const HypotheekDossiersOverzicht({
    super.key,
    required this.padding,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HypotheekDossiersOverzichtState();
}

class _HypotheekDossiersOverzichtState
    extends ConsumerState<HypotheekDossiersOverzicht> {
  @override
  Widget build(BuildContext context) {
    HypotheekDossierOverzicht overzicht = ref.watch(hypotheekDocumentProvider
        .select((value) => value.hypotheekDossierOverzicht));

    final dossiers = overzicht.hypotheekDossiers.values.map((e) => e).toList();

    return CustomScrollView(
      key: const PageStorageKey<String>('hypotheekDossier'),
      slivers: [
        // if (widget.nested)
        //   SliverOverlapInjector(
        //     // This is the flip side of the SliverOverlapAbsorber
        //     // above.
        //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        //   ),
        if (dossiers.isNotEmpty)
          SliverPadding(
            padding: widget.padding,
            sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 600.0,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final hd = dossiers[index];
                    return DossierCard(
                      geselecteerd: overzicht.geselecteerd,
                      hd: hd,
                      selecteren: () => selecteren(hd),
                      verwijderen: () => verwijderen(hd),
                      bewerken: () => bewerken(hd),
                    );
                  },
                  childCount: dossiers.length,
                )),
          ),
      ],
    );
  }

  void selecteren(HypotheekDossier hypotheekDossier) {
    ref
        .read(hypotheekDocumentProvider.notifier)
        .selecteerHypotheekDossier(hypotheekDossier);
  }

  void verwijderen(HypotheekDossier hypotheekDossier) {
    ref
        .read(hypotheekDocumentProvider.notifier)
        .hypotheekDossierVerwijderen(hypotheekDossier: hypotheekDossier);
  }

  void bewerken(HypotheekDossier hypotheekDossier) {
    ref
        .read(hypotheekDossierProvider.notifier)
        .bewerken(hypotheekDossier: hypotheekDossier);

    Beamer.of(context, root: true)
        .beamToNamed('/document/hypotheek/dossier/aanpassen');
  }
}

class ListViewHypotheekLeningen extends ConsumerStatefulWidget {
  final EdgeInsets padding;

  const ListViewHypotheekLeningen({
    super.key,
    required this.padding,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ListViewHypotheekLeningenState();
}

class _ListViewHypotheekLeningenState
    extends ConsumerState<ListViewHypotheekLeningen> {
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final primaryColor = Colors.white; //theme.colorScheme.inversePrimary;
    // final headline4 = theme.textTheme.headline4?.copyWith(color: Colors.white);

    HypotheekDossier? dossier =
        ref.watch(hypotheekDocumentProvider.select((value) {
      final overzicht = value.hypotheekDossierOverzicht;
      return overzicht.hypotheekDossiers[overzicht.geselecteerd];
    }));

    if (dossier == null) {
      return const Text(
        ':{',
        textScaleFactor: 24.0,
      );
    }

    final eersteHypotheken = dossier.eersteHypotheken;
    final hypotheken = dossier.hypotheken;

    List<Hypotheek> list = [];

    if (eersteHypotheken.isNotEmpty) {
      for (String id in eersteHypotheken) {
        Hypotheek? hypotheek = dossier.hypotheken[id];

        if (hypotheek == null) {
          continue;
        }
        list.add(hypotheek);
        debugPrint('eerste $id');
        String volgende = hypotheek.volgende;

        while (volgende.isNotEmpty) {
          hypotheek = hypotheken[volgende];
          assert(hypotheek != null, 'Hypotheek kan niet null zijn!');
          if (hypotheek != null) {
            list.add(hypotheek);
          }

          volgende = hypotheek?.volgende ?? '';
        }
      }
    }

    return CustomScrollView(
      key: const PageStorageKey<String>('Lening'),
      slivers: [
        // if (nested)
        //   SliverOverlapInjector(
        //     // This is the flip side of the SliverOverlapAbsorber
        //     // above.
        //     handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        //   ),
        if (list.isNotEmpty)
          SliverPadding(
            padding: widget.padding,
            sliver: SliverGrid(
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
                      bewerken: () => bewerken(hypotheek),
                      verwijderen: () => verwijderen(hypotheek),
                    );
                  },
                  childCount: list.length,
                )),
          ),
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

  void bewerken(Hypotheek hypotheek) {
    ref.read(hypotheekBewerkenProvider.notifier).bewerken(
        hypotheekDocument: ref.read(hypotheekDocumentProvider),
        hypotheek: hypotheek);

    Beamer.of(context, root: true)
        .beamToNamed('/document/hypotheek/lening/aanpassen');
  }

  verwijderen(Hypotheek hypotheek) {
    ref
        .read(hypotheekDocumentProvider.notifier)
        .hypotheekVerwijderen(hypotheek);
  }
}
