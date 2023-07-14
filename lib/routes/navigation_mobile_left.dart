// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation_widget.dart';
import 'package:ltrb_navigation_drawer/drawer_layout.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_widgets.dart';
import 'package:mortgage_insight/routes/navigation_document_examples.dart';
import 'package:mortgage_insight/routes/navigation_login_button.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../layout/t.dart';
import '../model/nl/provider/hypotheek_document_provider.dart';
import 'navigation_page_items.dart';
import '../theme/ltrb_navigation_style.dart';

class MobileLeftDrawer extends ConsumerStatefulWidget {
  final DrawerModel drawerModel;

  const MobileLeftDrawer({
    Key? key,
    required this.drawerModel,
  }) : super(key: key);

  @override
  ConsumerState<MobileLeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends ConsumerState<MobileLeftDrawer> {
  LtrbDrawerController ltrbDrawerController = LtrbDrawerController();

  @override
  Widget build(BuildContext context) {
    final DeviceScreen3 deviceScreen = DeviceScreen3.of(context);
    final navigationStyle = deviceScreen.theme.extension<LtrbNavigationStyle>();
    final drawerModel = widget.drawerModel;

    Widget listItem(int index, String selected) {
      final i = mortgageItemsList[index];

      return MyTile(
        title: i.title,
        selected: i.id == selected,
        onTap: () {
          widget.drawerModel.pop();
          Beamer.of(context).beamToNamed('/document/${i.id}', stacked: false);
        },
      );
    }

    final pathPatternSegments =
        (context.currentBeamLocation.state as BeamState).pathPatternSegments;
    final String selected =
        pathPatternSegments.length >= 2 ? pathPatternSegments[1] : '';

    final pageListSliver = GridView.custom(
      padding: EdgeInsets.zero,
      gridDelegate: MySliverQuiltedGridDelegate(
        crossAxisCount: 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        pattern: const [
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(2, 1),
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(1, 1),
          MyQuiltedGridTile(1, 1),
        ],
      ),
      childrenDelegate: SliverChildBuilderDelegate((context, index) {
        switch (index) {
          case 0:
            {
              return listItem(0, selected);
            }
          case 1:
            {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'graphics/mortgage_logo.png',
                  color: navigationStyle?.imageColor,
                ),
              );
            }

          default:
            {
              return listItem(index - 1, selected);
            }
        }
      }, childCount: mortgageItemsList.length + 1),
    );

    return DrawerAnimationMapWidget(
      drawerModel: drawerModel,
      animationMap: {
        'boxWidth': DrawerTransformAnimation(
          drawerAnimation: DrawerAnimationStartEnd(
              animationBegin: 72.0 * 2.0,
              animationEnd: 550,
              reverse: false,
              toEnd: false),
          animatable: Tween<double>(begin: 0.0, end: 550.0 - 72.0 * 2),
        ),
        'listWidth': DrawerTransformAnimation(
          drawerAnimation: DrawerAnimationStartEnd(
              animationBegin: 550 + 16.0,
              animationEnd: drawerModel.maxSize,
              reverse: false,
              toEnd: false),
          animatable: Tween<double>(
              begin: 0.0,
              end: drawerModel.maxSize - 72.0 - (550 - 72.0 + 16.0)),
        ),
        'disappear': DrawerTransformAnimation(
          drawerAnimation: DrawerAnimationStartEnd(
              animationBegin: drawerModel.minimumSize,
              animationEnd: drawerModel.minimumSize * 2.0,
              reverse: false,
              toEnd: false),
          animatable: Tween<double>(begin: 1.0, end: 0.0),
        ),
        'shiftLeftIcons': DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: drawerModel.minimumSize + 24,
                animationEnd: drawerModel.minimumSize + 24 + 48,
                reverse: false,
                toEnd: false),
            animatable: Tween<double>(begin: -64.0, end: 0.0)),
        'shifRightIcons': DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: drawerModel.minimumSize,
                animationEnd: drawerModel.minimumSize + 48,
                reverse: false,
                toEnd: false),
            animatable: Tween<double>(begin: 48.0, end: 0.0)),
      },
      builder:
          (BuildContext context, Map<String, dynamic> values, Widget? child) {
        final double boxWidth = values['boxWidth'];
        final double listWidth = values['listWidth'];
        final double disappear = values['disappear'];
        final double shiftLeftIcons = values['shiftLeftIcons'];
        final double shifRightIcons = values['shifRightIcons'];

        final stack = Stack(
          children: [
            if (disappear > 0.0)
              Positioned(
                  key: const Key('menu'),
                  top: 0.0,
                  bottom: 0.0,
                  right: 4.0 + 4.0 * disappear,
                  width: 48.0 * disappear,
                  child: Align(
                      alignment: Alignment.center,
                      child: Material(
                          color: deviceScreen.theme.primaryColor,
                          borderRadius: BorderRadius.circular(24.0),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            child: SizedBox(
                                height: 128.0 * disappear,
                                width: 48.0 * disappear,
                                child: DrawerOverflowBox(
                                    alignment: Alignment.center,
                                    minWidth: 48.0,
                                    minHeight: 64.0,
                                    child: disappear < 0.5
                                        ? null
                                        : Opacity(
                                            opacity: disappear * 2.0 - 1.0,
                                            child: RotatedBox(
                                              quarterTurns: -1,
                                              child: Text(
                                                'menu',
                                                style: navigationStyle
                                                    ?.barTextStyle,
                                              ),
                                            )))),
                            onTap: () {
                              widget.drawerModel.open();
                            },
                          )))),
            Positioned(
              left: shiftLeftIcons,
              top: 8.0,
              width: 72.0,
              bottom: 8.0,
              child: Column(
                children: [
                  LoginButton(onTap: () {}),
                  const Expanded(child: SizedBox.expand()),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Positioned(
                left: 72.0,
                top: 8.0,
                bottom: 8.0,
                width: boxWidth,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
                      color: navigationStyle?.secondBackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DrawerOverflowBox(
                          minWidth: 350, child: pageListSliver),
                    ))),
            Positioned(
              right: shifRightIcons,
              top: 8.0,
              width: 72.0,
              bottom: 8.0,
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 36.0,
                    icon: const ImageIcon(AssetImage('graphics/ic_open.png')),
                    onPressed: () {
                      Beamer.of(context, root: true).beamToNamed('/document');
                      ref
                          .read(hypotheekDocumentProvider.notifier)
                          .openHypotheek();
                    },
                  ),
                  IconButton(
                    iconSize: 36.0,
                    icon: const Icon(Icons.save_alt),
                    onPressed: () => ref
                        .read(hypotheekDocumentProvider.notifier)
                        .saveHypotheek(),
                  ),
                  IconButton(
                    iconSize: 36.0,
                    icon: const Icon(Icons.rotate_left),
                    onPressed: () {
                      Beamer.of(context, root: true).beamToNamed('/document');
                      ref.read(hypotheekDocumentProvider.notifier).reset();
                    },
                  ),
                  const Expanded(child: SizedBox.expand()),
                ],
              ),
            ),
            Positioned(
                left: 550 - 72 + 16.0,
                top: 8.0,
                bottom: 8.0,
                width: listWidth,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 4.0,
                    ),
                    const DrawerOverflowBox(
                        minWidth: 200.0, child: Text('Documents')),
                    const SizedBox(
                      height: 4.0,
                    ),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0))),
                        child: CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return MobileDocumentCard(
                                    minOverflowWidth: 200.0,
                                    index: index,
                                    document: documentsMobileVoorbeelden[index],
                                    length: documentsMobileVoorbeelden.length);
                              }, childCount: documentsMobileVoorbeelden.length),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        );

        return CustomPaint(
          painter: LtrbShapeDrawerPainter(
              drawerCorner: LtrbDrawerCorner.quadraticFlap,
              color: Colors.white,
              animationValue: 1,
              roundLeftTop: false,
              roundLeftBottom: false,
              roundRightBottom: false,
              roundRightTop: true,
              radial: 42.0,
              drawerPosition: DrawerPosition.left,
              padding: EdgeInsets.zero),
          child: stack,
        );
      },
    );
  }
}

class SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight
    extends SliverGridDelegate {
  /// Creates a delegate that makes grid layouts with a fixed number of tiles in
  /// the cross axis.
  ///
  /// All of the arguments must not be null. The `mainAxisSpacing` and
  /// `crossAxisSpacing` arguments must not be negative. The `crossAxisCount`
  /// and `childAspectRatio` arguments must be greater than zero.
  const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.height = 56.0,
  });

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// The height of the crossAxis.
  final double height;

  bool _debugAssertIsValid() {
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(height > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent =
        constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = height;
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(
      SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight oldDelegate) {
    return oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.height != height;
  }
}

class MyTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String title;
  final String? imageName;

  const MyTile({
    Key? key,
    required this.selected,
    required this.onTap,
    required this.title,
    this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationStyle = theme.extension<LtrbNavigationStyle>();

    Widget child;
    if (imageName != null) {
      child = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ImageIcon(
                AssetImage(imageName!),
                color: selected
                    ? navigationStyle?.colorSelectedItem
                    : navigationStyle?.colorItem,
              ),
            ),
            Text(title)
          ]);
    } else {
      child = Center(child: Text(title));
    }
    final background = selected
        ? navigationStyle?.backgroundSelectedItem
        : navigationStyle?.backgroundItem;

    return Material(
      type:
          background == null ? MaterialType.transparency : MaterialType.canvas,
      color: background,
      textStyle: theme.textTheme.bodyMedium!.copyWith(
          color: selected
              ? navigationStyle?.colorSelectedItem
              : navigationStyle?.colorItem,
          fontSize: 16.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      child: InkWell(onTap: onTap, child: SizedBox(height: 56.0, child: child)),
    );
  }
}
