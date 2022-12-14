import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/income/income_card.dart';

import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/my_widgets/my_page/my_page.dart';
import 'package:mortgage_insight/state_manager/widget_state.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../my_widgets/my_page/my_large_page.dart';
import '../routes/routes_items.dart';
import '../theme/tabbar_overview_page_style.dart';

import 'income_model.dart';

enum IncomeCardOptions { edit, delete }

int _tabIndex = 0;

class IncomePanel extends ConsumerStatefulWidget {
  IncomePanel({Key? key}) : super(key: key);

  @override
  _IncomePanelState createState() => _IncomePanelState();
}

class _IncomePanelState extends ConsumerState<IncomePanel>
    with TickerProviderStateMixin {
  late TabController _tabController =
      TabController(length: 2, vsync: this, initialIndex: _tabIndex)
        ..addListener(() {
          _tabIndex = _tabController.index;
        });
  bool partner = false;

  @override
  void initState() {
    _tabController.animation?.addListener(() {
      int index = ((_tabController.animation?.value ?? 0.0) + 0.5).toInt();
      partner = index == 1;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  add() {
    ref.read(routeEditPageProvider.notifier).editState =
        EditRouteState<BewerkenInkomen>(
      route: routeIncomeEdit,
      object: BewerkenInkomen.nieuw(
          lijst:
              //     ref.read(partner ? inkomenPartnerProvider : inkomenProvider).list,
              // partner: partner),
              ref
                  .read(hypotheekContainerProvider)
                  .inkomenLijst(partner: partner),
          partner: partner),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);

    final floatingActionButton = FloatingActionButton(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        onPressed: add,
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ));

    TabBarPageStyle? tabBarPageStyle = theme.extension<TabBarPageStyle>();

    final tabBar = TabBar(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
      controller: _tabController,
      labelStyle: tabBarPageStyle?.textStyle,
      indicatorColor: tabBarPageStyle?.indicatorColor,
      labelColor: tabBarPageStyle?.labelColor,
      tabs: [
        Tab(
          height: tabBarPageStyle?.height,
          // icon: Icon(
          //   Icons.person,
          //   size: 56,
          // ),
          text: 'Inkomen',
        ),
        Tab(
          height: tabBarPageStyle?.height,
          // icon: Icon(
          //   Icons.group,
          //   size: 56,
          // ),
          text: 'Partner',
        )
      ],
    );

    final body = Stack(children: [
      Positioned(
        left: 0.0,
        top: 0.0,
        right: 0.0,
        bottom: 0.0,
        child: TabBarView(
          controller: _tabController,
          children: [
            LijstInkomenPanel(),
            LijstInkomenPanel(
              partner: true,
            )
          ],
        ),
      ),
      Positioned(
          width: 100.0,
          height: 100,
          right: 24.0,
          bottom: 16.0,
          child: Align(
              alignment: Alignment.bottomRight, child: floatingActionButton))
    ]);

    switch (deviceScreen.formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
      case FormFactorType.Tablet:
        return MyPage(
            title: 'Inkomen',
            imageName: 'graphics/fit_wallet.png',
            bottom: tabBar,
            handleSliverOverlap: true,
            body: body);
      case FormFactorType.Monitor:
        return MyLargePage(preferredSizeWidget: tabBar, body: body);
    }
  }
}

class LijstInkomenPanel extends ConsumerStatefulWidget {
  final bool partner;

  LijstInkomenPanel({
    Key? key,
    this.partner = false,
  }) : super(key: key);

  @override
  _LijstInkomenPanelState createState() => _LijstInkomenPanelState();
}

class _LijstInkomenPanelState extends ConsumerState<LijstInkomenPanel> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inkomenLijst = ref
        .watch(hypotheekContainerProvider
            .select((value) => value.inkomenContainer(widget.partner)))
        .list;

    return CustomScrollView(
      key: PageStorageKey<String>('inkomen_partner_${widget.partner}'),
      slivers: [
        // SliverOverlapInjector(
        //   // This is the flip side of the SliverOverlapAbsorber
        //   // above.
        //   handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        // ),
        if (inkomenLijst.length > 0)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return IncomeCard(
                    inkomenItem: inkomenLijst[index],
                    partner: widget.partner,
                  );
                },
                childCount: inkomenLijst.length,
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
