import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fabProperties.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../../navigation/navigation_page_items.dart';
import '../../platform_page_format/page_properties.dart';
import '../../theme/tabbar_overview_page_style.dart';
import 'inkomen_card.dart';
import 'inkomen_bewerken/inkomen_bewerken_model.dart';

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
    editRoute(
      ref: ref,
      name: routeIncomeEdit,
      edit: null,
    );

    ref.read(inkomenBewerkenProvider.notifier).nieuw(
        lijst:
            ref.read(hypotheekContainerProvider).inkomenLijst(partner: partner),
        partner: partner);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);

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
          text: 'Inkomen',
        ),
        Tab(
          height: tabBarPageStyle?.height,
          text: 'Partner',
        )
      ],
    );

    final bodyBuilder =
        ({required BuildContext context, required bool nested}) => TabBarView(
              controller: _tabController,
              children: [
                LijstInkomenPanel(
                  nested: nested,
                ),
                LijstInkomenPanel(
                  partner: true,
                  nested: nested,
                )
              ],
            );

    return DefaultPage(
      title: 'Inkomen',
      imageBuilder: (_) => Image(
          image: AssetImage(
            'graphics/wallet.png',
          ),
          color: theme.colorScheme.onSurface),
      bottom: tabBar,
      matchPageProperties: [
        MatchPageProperties(
            pageProperties: PageProperties(hasNavigationBar: true))
      ],
      bodyBuilder: bodyBuilder,
      fabProperties: FabProperties(icon: Icon(Icons.add), onTap: add),
      notificationDept: 1,
    );
  }
}

class LijstInkomenPanel extends ConsumerStatefulWidget {
  final bool partner;
  final bool nested;

  LijstInkomenPanel({Key? key, this.partner = false, required this.nested})
      : super(key: key);

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
        .lijst;

    return CustomScrollView(
      key: PageStorageKey<String>('inkomen_partner_${widget.partner}'),
      slivers: [
        if (widget.nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (inkomenLijst.length > 0)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
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
      ],
    );
  }
}
