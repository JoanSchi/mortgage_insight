import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation_widget.dart';
import 'package:ltrb_navigation_drawer/drawer_layout.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_widgets.dart';
import 'package:ltrb_navigation_drawer/ltrb_scrollview_listener.dart';
import '../mobile/background_sliver_element.dart';
import '../model/nl/hypotheek_container/hypotheek_container.dart';
import '../routes/route_document.dart';
import '../routes/routes_items.dart';
import '../state_manager/edit_state.dart';
import '../theme/ltrb_navigation_style.dart';
import '../utilities/device_info.dart';
import 'navigation_mobile_left.dart';
import 'navigation_document_examples.dart';
import 'navigation_login_button.dart';

class BottomMobileDrawer extends ConsumerStatefulWidget {
  final DrawerModel drawerModel;

  BottomMobileDrawer({
    required this.drawerModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomDrawerState();
}

class _BottomDrawerState extends ConsumerState<BottomMobileDrawer> {
  @override
  Widget build(BuildContext context) {
    final DeviceScreen3 deviceScreen = DeviceScreen3.of(context);
    final navigationStyle = deviceScreen.theme.extension<LtrbNavigationStyle>();
    final drawerModel = widget.drawerModel;

    final actionGroup = Column(children: [
      LoginButton(onTap: () {}),
      IconButton(
        iconSize: 36.0,
        icon: const Icon(Icons.add),
        onPressed: () => print("add"),
      ),
      IconButton(
        iconSize: 36.0,
        icon: const ImageIcon(AssetImage('graphics/ic_open.png')),
        onPressed: () => print("open"),
      ),
      IconButton(
        iconSize: 36.0,
        icon: const Icon(Icons.save_alt),
        onPressed: () {
          ref.read(hypotheekContainerProvider).saveHypotheekContainer();
        },
      ),
      IconButton(
        iconSize: 36.0,
        icon: const Icon(Icons.import_export),
        onPressed: () {},
      ),
      Expanded(child: SizedBox.expand()),
      IconButton(
        iconSize: 36.0,
        icon: const Icon(Icons.settings),
        onPressed: () => print("save"),
      ),
    ]);

    List<Widget> sliver = [];

    bool haslogo = 560.0 < widget.drawerModel.preferredDrawerSize;
    if (haslogo) {
      sliver.add(SliverToBoxAdapter(
        child: BackgroundSliverElement(
          start: true,
          end: false,
          color: navigationStyle?.secondBackground ??
              deviceScreen.theme.backgroundColor,
          child: Column(children: [
            SizedBox(
                height: 96.0,
                child: Image.asset(
                  'graphics/mortgage_logo.png',
                  color: Colors.white,
                )),
            Divider(
              color: Colors.white,
              indent: 8.0,
              endIndent: 8.0,
            )
          ]),
        ),
      ));
    }
    final count = mortgageItemsList.length;

    final pageListSliver = SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        final i = mortgageItemsList[index];

        final selected = watchSelectedRoutePage(ref, i.id);

        return BackgroundSliverElement(
          start: index == 0 && !haslogo,
          end: index == count - 1,
          color: navigationStyle?.secondBackground ?? Colors.white,
          child: MyTile(
            title: i.title,
            selected: selected,
            onTap: () {
              widget.drawerModel.pop();
              setRoutePage(ref: ref, name: i.id);
            },
          ),
        );
      },
      childCount: count,
    ));

    sliver.add(Theme(
        child: pageListSliver,
        data: deviceScreen.theme.copyWith(platform: TargetPlatform.android)));

    sliver.add(SliverToBoxAdapter(
        child: SizedBox(
      height: 56.0,
      child: Row(
        children: [
          Expanded(
              child: Divider(
            indent: 8.0,
            endIndent: 8.0,
          )),
          TextButton(
            child: Text('Documenten'),
            onPressed: () => drawerModel.open(drawerStatus: DrawerStatus.end),
          ),
          Expanded(
              child: Divider(
            indent: 8.0,
            endIndent: 8.0,
          ))
        ],
      ),
    )));
    final length = documentsMobileVoorbeelden.length;
    sliver.add(SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return MobileDocumentCard(
          index: index,
          document: documentsMobileVoorbeelden[index],
          length: length);
    }, childCount: length)));

    return DrawerAnimationMapWidget(
      drawerModel: widget.drawerModel,
      animationMap: {
        'drawer': DrawerTransformAnimation(
          drawerAnimation: DrawerAnimationStartEnd(
              animationBegin: drawerModel.minimumSize,
              animationEnd: drawerModel.minimumSize * 2.0,
              reverse: false,
              toEnd: false),
          animatable: Tween<double>(begin: 64, end: 0),
        ),
        'corner': DrawerTransformAnimation(
          drawerAnimation: DrawerAnimationStartEnd(
              animationBegin: widget.drawerModel.maxSize - 24.0,
              animationEnd: widget.drawerModel.maxSize,
              reverse: false,
              toEnd: false),
          animatable: Tween<double>(begin: 1.0, end: 0.0),
        ),
        'disappear': DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: drawerModel.minimumSize,
                animationEnd: drawerModel.minimumSize * 2.0,
                reverse: false,
                toEnd: false),
            animatable: Tween<double>(begin: 1, end: 0))
      },
      builder:
          (BuildContext context, Map<String, dynamic> values, Widget? child) {
        final double drawer = values['drawer'];
        final double corner = values['corner'];
        final double disappear = values['disappear'];

        Widget stack = Stack(
          children: [
            // if (drawer != drawerModel.minimumSize)
            Positioned(
              key: Key('actionGroup'),
              top: 12,
              bottom: 8.0,
              left: 8.0,
              width: 56.0,
              child: DrawerOverflowBox(minHeight: 5 * 64.0, child: actionGroup),
            ),
            // if (drawer != drawerModel.minimumSize)
            Positioned(
              key: Key('sliver'),
              left: 72.0,
              top: 12,
              right: 12.0,
              bottom: 8.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: ScrollViewLtrbDrawerListener(
                    drawerModel: drawerModel,
                    child: CustomScrollView(slivers: sliver)),
              ),
            ),
          ],
        );

        return Stack(
          children: [
            if (disappear > 0.0)
              Positioned(
                  key: const Key('menu'),
                  left: 0.0,
                  right: 0.0,
                  top: 4.0 + 4.0 * disappear,
                  height: 48.0 * disappear,
                  child: Align(
                      alignment: Alignment.center,
                      child: Material(
                          color: deviceScreen.theme.primaryColor,
                          borderRadius: BorderRadius.circular(24.0),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            child: SizedBox(
                                height: 48.0 * disappear,
                                width: 128.0 * disappear,
                                child: DrawerOverflowBox(
                                    alignment: Alignment.center,
                                    minWidth: 64.0,
                                    minHeight: 48.0,
                                    child: disappear < 0.5
                                        ? null
                                        : Opacity(
                                            opacity: disappear * 2.0 - 1.0,
                                            child: Text(
                                              'menu',
                                              style:
                                                  navigationStyle?.barTextStyle,
                                            )))),
                            onTap: () {
                              widget.drawerModel.open();
                            },
                          )))),
            if (drawer != drawerModel.minimumSize)
              Positioned(
                key: const Key('drawer'),
                top: drawer,
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: CustomPaint(
                  painter: LtrbShapeDrawerPainter(
                      color: navigationStyle?.background,
                      radial: 24,
                      animationValue: corner,
                      roundLeftTop: true,
                      roundRightTop: true,
                      roundLeftBottom: false,
                      roundRightBottom: false),
                  child: Material(
                    type: MaterialType.transparency,
                    child: stack,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
