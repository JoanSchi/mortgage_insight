import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/hypotheek/hypotheek_card.dart';
import 'package:mortgage_insight/hypotheek/profiel_card.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/my_widgets/my_page/my_page.dart';
import 'package:mortgage_insight/routes/routes_items.dart';
import 'package:mortgage_insight/state_manager/widget_state.dart';
import '../model/nl/hypotheek/hypotheek.dart';
import '../utilities/device_info.dart';
import 'bewerken/hypotheek_model.dart';
import 'profiel_bewerken/hypotheek_profiel_model.dart';

class HypotheekBlub extends StatelessWidget {
  const HypotheekBlub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HypotheekPanel();
  }
}

class HypotheekPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<HypotheekPanel> createState() => HypotheekPanelState();
}

class HypotheekPanelState extends ConsumerState<HypotheekPanel>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int tab = profielenTab;
  static const int profielenTab = 0, profielTab = 1, overzichtTab = 2;

  TabController get tabController {
    if (_tabController == null) {
      _tabController = TabController(initialIndex: tab, vsync: this, length: 3)
        ..animation?.addListener(() {
          final value = _tabController?.animation?.value;
          final toTab = (value == null) ? 0 : value.round();

          if (toTab != tab) {
            setState(() {
              tab = toTab;
            });
          }
        });
    }
    return _tabController!;
  }

  void initState() {
    super.initState();
  }

  add() {
    final hypotheekContainer = ref.read(hypotheekContainerProvider);

    switch (tab) {
      case profielenTab:
        {
          ref.read(routeEditPageProvider.notifier).editState = EditRouteState(
              route: routeNieweHypotheekProfielEdit,
              object: HypotheekProfielViewModel(
                hypotheekProfielen:
                    hypotheekContainer.container.hypotheekProfielen,
              ));

          break;
        }
      case profielTab:
        {
          ref.read(routeEditPageProvider.notifier).editState = EditRouteState(
              route: routeMortgageEdit,
              object: HypotheekViewModel(
                inkomenLijst: hypotheekContainer.inkomenLijst(),
                inkomenLijstPartner:
                    hypotheekContainer.inkomenLijst(partner: true),
                profiel: hypotheekContainer
                    .huidigeHypotheekProfielContainer!.profiel,
                schuldenLijst: hypotheekContainer.schuldenContainer.list,
              ));

          break;
        }
    }
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
    final hypotheekProfielen =
        ref.watch(hypotheekContainerProvider).container.hypotheekProfielen;

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
    final deviceScreen = DeviceScreen3.of(context);

    Color floatingbackgroundColor;
    Color floatingForgroundColor;

    switch (deviceScreen.formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
        floatingbackgroundColor = theme.primaryColor;
        floatingForgroundColor = Colors.white;
        break;
      default:
        floatingbackgroundColor = theme.colorScheme.primaryContainer;
        //Color(0xFFd7eef4);
        floatingForgroundColor = Colors.white;
        break;
    }

    Widget floatingButton = FloatingActionButton(
        backgroundColor: floatingbackgroundColor,
        foregroundColor: floatingForgroundColor,
        onPressed: add,
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ));

    Widget subBody;
    PreferredSizeWidget? bottomAppBar;

    if (hypotheekProfielen.isEmpty) {
      subBody = _Empty();
    } else {
      bottomAppBar = TabBar(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            text: 'Profiel',
          ),
          Tab(text: 'Leningen'),
          Tab(text: 'Overzicht')
        ],
        controller: tabController,
      );

      subBody = TabBarView(controller: tabController, children: [
        ListViewHypotheekProfielen(),
        ListViewHypotheekProfiel(),
        Center(
            child: Text(
          'Overzicht',
          textScaleFactor: 5.0,
        )),
      ]);
    }

    Widget body = Builder(
        builder: (context) => Stack(children: [
              Positioned(
                  left: 0.0, top: 0.0, right: 0.0, bottom: 0.0, child: subBody),
              Positioned(
                  width: 100.0,
                  height: 100.0,
                  right: 24.0,
                  bottom: 16.0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: tab == overzichtTab
                        ? SizedBox.shrink()
                        : Align(
                            alignment: Alignment.bottomRight,
                            child: floatingButton),
                  ))
            ]));

    return MyPage(
        bottom: bottomAppBar,
        title: 'Hypotheek',
        imageName: 'graphics/fit_geldzak.png',
        body: body);
  }
}

class _Empty extends ConsumerWidget {
  const _Empty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: Text(
      ':{',
      textScaleFactor: 24.0,
    ));
  }
}

class ListViewHypotheekProfielen extends ConsumerWidget {
  const ListViewHypotheekProfielen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    HypotheekProfielen hypotheekProfielen = ref.watch(hypotheekContainerProvider
        .select((value) => value.container.hypotheekProfielen));

    final listProfiels =
        hypotheekProfielen.profielen.values.map((e) => e.profiel).toList();

    return CustomScrollView(
      key: PageStorageKey<String>('listViewHypotheekProfiel'),
      slivers: [
        // SliverOverlapInjector(
        //   // This is the flip side of the SliverOverlapAbsorber
        //   // above.
        //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        // ),
        if (hypotheekProfielen.profielen.length > 0)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ProfielCard(
                    selected: hypotheekProfielen.profielContainer?.profiel.id,
                    profiel: listProfiels[index],
                  );
                },
                childCount: listProfiels.length,
              )),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 72.0,
          ),
        )
      ],
    );
  }
}

class ListViewHypotheekProfiel extends ConsumerWidget {
  const ListViewHypotheekProfiel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = Theme.of(context);
    // final primaryColor = Colors.white; //theme.colorScheme.inversePrimary;
    // final headline4 = theme.textTheme.headline4?.copyWith(color: Colors.white);

    HypotheekProfiel? profiel = ref
        .watch(hypotheekContainerProvider.select(
            (value) => value.container.hypotheekProfielen.profielContainer))
        ?.profiel;

    if (profiel == null) {
      return Text(
        ':{',
        textScaleFactor: 24,
      );
    }

    final eersteHypotheken = profiel.eersteHypotheken;
    final hypotheken = profiel.hypotheken;

    List<Hypotheek> list = [];

    if (eersteHypotheken.isNotEmpty) {
      eersteHypotheken.forEach((Hypotheek e) {
        list.add(e);
        print('eerste ${e.id}');

        while (e.volgende.isNotEmpty) {
          e = hypotheken[e.volgende]!;
          list.add(e);
          print('volgende ${e.id}');
        }
      });
    }

    return CustomScrollView(
      key: PageStorageKey<String>('listViewHypotheekProfiel'),
      slivers:
          // SliverOverlapInjector(
          //   // This is the flip side of the SliverOverlapAbsorber
          //   // above.
          //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          // ),
          (list.length > 0)
              ? [
                  SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 600.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return HypotheekCard(
                            hypotheek: list[index],
                          );
                        },
                        childCount: list.length,
                      )),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 72.0,
                    ),
                  )
                ]
              : const [],
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
}
