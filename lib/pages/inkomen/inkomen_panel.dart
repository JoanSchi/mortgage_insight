import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_document/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/platform_page_format/default_page.dart';
import 'package:mortgage_insight/platform_page_format/fab_properties.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../../navigation/navigation_page_items.dart';
import '../../platform_page_format/page_properties.dart';
import '../../theme/tabbar_overview_page_style.dart';
import 'inkomen_card.dart';
import 'inkomen_bewerken/inkomen_bewerken_model.dart';

enum IncomeCardOptions { edit, delete }

int _tabIndex = 0;

class InkomenPanel extends ConsumerStatefulWidget {
  const InkomenPanel({Key? key}) : super(key: key);

  @override
  ConsumerState<InkomenPanel> createState() => _InkomenPanelState();
}

class _InkomenPanelState extends ConsumerState<InkomenPanel>
    with TickerProviderStateMixin {
  late final TabController _tabController =
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
        lijst: ref
            .read(hypotheekDocumentProvider)
            .inkomenOverzicht
            .lijst(partner: partner),
        partner: partner);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final deviceScreen = DeviceScreen3.of(context);

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

    bodyBuilder(
            {required BuildContext context,
            required bool nested,
            required double topPadding,
            required double bottomPadding}) =>
        TabBarView(
          controller: _tabController,
          children: [
            LijstInkomenPanel(
              nested: nested,
              topPadding: topPadding,
              bottomPadding: bottomPadding,
            ),
            LijstInkomenPanel(
              partner: true,
              nested: nested,
              topPadding: topPadding,
              bottomPadding: bottomPadding,
            )
          ],
        );

    return DefaultPage(
      title: 'Inkomen',
      imageBuilder: (_) => Image(
          image: const AssetImage(
            'graphics/wallet.png',
          ),
          color: theme.colorScheme.onSurface),
      bottom: tabBar,
      matchPageProperties: const [
        MatchPageProperties(
            pageProperties: PageProperties(hasNavigationBar: true))
      ],
      bodyBuilder: bodyBuilder,
      fabProperties: FabProperties(icon: const Icon(Icons.add), onTap: add),
      notificationDept: 1,
    );
  }
}

class LijstInkomenPanel extends ConsumerStatefulWidget {
  final bool partner;
  final bool nested;
  final double topPadding;
  final double bottomPadding;

  const LijstInkomenPanel(
      {Key? key,
      this.partner = false,
      required this.nested,
      required this.topPadding,
      required this.bottomPadding})
      : super(key: key);

  @override
  ConsumerState<LijstInkomenPanel> createState() => _LijstInkomenPanelState();
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
    final inkomenLijst = ref.watch(hypotheekDocumentProvider.select(
        (value) => value.inkomenOverzicht.lijst(partner: widget.partner)));

    return CustomScrollView(
      key: PageStorageKey<String>('inkomen_partner_${widget.partner}'),
      slivers: [
        if (widget.nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (inkomenLijst.isNotEmpty)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkomenCard(
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
