import 'dart:math' as math;

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation_widget.dart';
import 'package:ltrb_navigation_drawer/drawer_layout.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_widgets.dart';
import 'package:ltrb_navigation_drawer/overlay_indicator/ltbr_drawer_indicator.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import '../layout/transition/scale_size_transition.dart';
import '../platform_page_format/adjust_scroll_configuration.dart';
import 'routes.dart';
import '../theme/ltrb_navigation_style.dart';
import 'navigation_document_examples.dart';
import 'navigation_login_button.dart';
import 'navigation_page_items.dart';
import '../utilities/device_info.dart';

class MediumNavigation extends StatelessWidget {
  const MediumNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScrollConfiguration(
        behavior: MyMaterialScrollBarBehavior(),
        child: Scaffold(body: MediumDrawer(body: Pagina())));
  }
}

class MediumDrawer extends StatefulWidget {
  final Widget body;
  const MediumDrawer({super.key, required this.body});

  @override
  State<MediumDrawer> createState() => _MediumDrawerState();
}

const double narrowMinSize = 84.0;
const double minSize = 208.0;
const List<double> sizeExtend = [650.0, 500.0];
const boxPaddingStart = EdgeInsets.all(0.0);
const boxPaddingEnd = EdgeInsets.all(16.0);

const double maxSizePageList = 264.0;
const double documentWidth = 280.0;
const iconRibbonSize = 64.0;

class _MediumDrawerState extends State<MediumDrawer> {
  LtrbDrawerController ltrbDrawerController = LtrbDrawerController();

  @override
  Widget build(BuildContext context) {
    final deviceScreen = DeviceScreen3.of(context);

    final minimumSize =
        deviceScreen.isTabletWidthNarrow ? narrowMinSize : minSize;

    return LtrbDrawer(
      buildOverlay: defaultArrowIndicator(),
      body: widget.body, //const MyRoutePage(),
      expandBody: false,
      allowMaximumSize: false,
      scrimeColorEnd: const Color.fromARGB(9, 0, 0, 0),

      minimumSize: minimumSize,
      preferredSize: sizeExtend,
      drawerPosition: DrawerPosition.left,
      buildDrawer: ({
        required DrawerModel drawerModel,
        required DrawerPosition drawerPosition,
      }) {
        return LeftNavigation(
          drawerModel: drawerModel,
        );
      },
      drawerController: ltrbDrawerController, navigationBarSize: minimumSize,
      // leftBar: LeftNavigation(padding: padding),
    );
  }
}

const paddingAnimation = 'paddingAnimation';
const backgroundColorAnimation = 'backgroundColorAnimation';

// const logoScaleAnimation = 'logoAnimation';
const logoHeightAnimation = 'logoHeightAnimation';
const logoPaddingAnimation = 'logoPaddingAnimation';
const menuTitleHeightAnimation = 'menuTitleHeightAnimation';
const menuTitlePaddingAnimation = 'menuPaddingAnimation';
const listWidthAnimation = 'listWidthAnimation';
const menuWidthAnimation = 'menuWidthAnimation';
const backgroundWidthAnimation = 'backgroundWidthAnimation';
const listItemHeightAnimation = 'listItemHeightAnimation';
const minHeightExpandAnimation = 'minHeightExpandAnimation';
const generalAnimation = 'generalAnimation';
const listWidthDocumentsAnimation = 'listWidthDocumentsAnimation';
const leftBottomActionsScaleAnimation = 'leftBottomActionsScaleAnimation';
const radialCornerAnimation = 'radialCornerAnimation';

class LeftNavigation extends ConsumerWidget {
  final DrawerModel drawerModel;

  const LeftNavigation({
    Key? key,
    required this.drawerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DeviceScreen3 deviceScreen = DeviceScreen3.of(context);

    final List<Widget> defaultActionsList = [
      SizedBox(
        height: 48.0,
        width: 48.0,
        child: IconButton(
            onPressed: () => debugPrint('setting'),
            icon: const Icon(Icons.settings)),
      ),
      SizedBox(
        height: 48.0,
        width: 48.0,
        child: IconButton(
            onPressed: () => debugPrint('info'), icon: const Icon(Icons.info)),
      )
    ];

    final extendedActions = [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          ref.read(hypotheekDocumentProvider.notifier).reset();
          drawerModel.pop();
        },
      ),
      IconButton(
        icon: const ImageIcon(AssetImage('graphics/ic_open.png')),
        onPressed: () {
          Beamer.of(context, root: true).beamToNamed('/document');
          ref.read(hypotheekDocumentProvider.notifier).openHypotheek();
        },
      ),
      IconButton(
        icon: const Icon(Icons.save_alt),
        onPressed: () =>
            ref.read(hypotheekDocumentProvider.notifier).saveHypotheek(),
      ),
      IconButton(
        icon: const Icon(Icons.rotate_left),
        onPressed: () {
          Beamer.of(context, root: true).beamToNamed('/document');
          ref.read(hypotheekDocumentProvider.notifier).reset();
        },
      )
    ];

    int bottomLeftColumnNumberDefaultActions;
    int bottomLeftRowNumberActionButtons;

    if (defaultActionsList.isNotEmpty) {
      bottomLeftRowNumberActionButtons =
          (drawerModel.minimumSize - boxPaddingStart.horizontal) ~/ 56.0;
      bottomLeftColumnNumberDefaultActions =
          (defaultActionsList.length / bottomLeftRowNumberActionButtons).ceil();
    } else {
      bottomLeftRowNumberActionButtons = 0;
      bottomLeftColumnNumberDefaultActions = 0;
    }

    ThemeData dataTheme = Theme.of(context);
    final navigationStyle = dataTheme.extension<LtrbNavigationStyle>();

    final isNarrow = drawerModel.minimumSize == narrowMinSize;
    double maxLogoHeight = isNarrow ? 180.0 : 148.0;

    double minSize = drawerModel.minimumSize;
    double maxSize = drawerModel.maxSize;

    return DrawerAnimationMapWidget(
        drawerModel: drawerModel,
        animationMap: {
          //Animation
          paddingAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.maxSize),
              animatable: EdgeInsetsTween(
                  begin: EdgeInsets.zero, end: const EdgeInsets.all(8.0))),

          //Animation
          backgroundColorAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.maxSize),
              animatable:
                  ColorTween(begin: null, end: navigationStyle?.background)),
          //Animation
          // logoScaleAnimation: DrawerTransformAnimation(
          //   drawerAnimation: DrawerAnimationStartEnd(
          //       animationBegin: minSize, animationEnd: maxSize),
          //   animatable: Tween(begin: minScaleLogo, end: 1.0),
          // ),

          //
          // Logo Animation
          //
          //
          logoPaddingAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: minSize, animationEnd: maxSize),
              animatable: isNarrow
                  ? Tween<EdgeInsets>(
                      begin: const EdgeInsets.only(top: 28.0, bottom: 28.0),
                      end: const EdgeInsets.only(top: 24.0, bottom: 8.0))
                  : Tween<EdgeInsets>(
                      begin: const EdgeInsets.only(
                          top: 6.0, left: 12.0, bottom: 8.0),
                      end: const EdgeInsets.only(top: 12.0, bottom: 8.0))),
          //Animation
          logoHeightAnimation: DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: minSize, animationEnd: maxSize),
            animatable: isNarrow
                ? Tween(begin: 0.0, end: maxLogoHeight)
                : Tween(
                    begin: 112.0,
                    end: maxLogoHeight,
                  ),
          ),
          //
          // Menu Animation
          //
          //
          menuTitlePaddingAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: minSize, animationEnd: maxSize),
              animatable: isNarrow
                  ? Tween<EdgeInsets>(
                      begin: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                      end: const EdgeInsets.only(top: 24.0, bottom: 0.0),
                    )
                  : Tween<EdgeInsets>(
                      begin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      end: const EdgeInsets.only(top: 24.0, bottom: 0.0),
                    )),
          //Animation
          menuTitleHeightAnimation: DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: minSize, animationEnd: maxSize),
            animatable: isNarrow
                ? Tween(begin: 0.0, end: 48.0)
                : Tween(begin: 48.0, end: 48.0),
          ),

          //Animation
          listWidthAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.maxSize),
              animatable: Tween(
                  begin: drawerModel.minimumSize - boxPaddingStart.horizontal,
                  end: maxSizePageList)),
          //Animation
          menuWidthAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.maxSize),
              animatable: Tween(
                  begin: drawerModel.minimumSize - boxPaddingStart.horizontal,
                  end: maxSizePageList)),
          //Animation
          backgroundWidthAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.maxSize),
              animatable: Tween(
                  begin: drawerModel.minimumSize - boxPaddingStart.horizontal,
                  end: maxSizePageList + documentWidth / 2.0)),
          //Animation
          listItemHeightAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.preferredDrawerSize),
              animatable: Tween(begin: 54.0, end: 56.0)),
          //Animation
          minHeightExpandAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.preferredDrawerSize),
              animatable: Tween(begin: 56.0, end: 52.0)),

          //Animation
          generalAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.preferredDrawerSize),
              animatable: Tween<double>(begin: 0.0, end: 1.0)),
          //Animation
          listWidthDocumentsAnimation: DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: maxSizePageList,
                  animationEnd: drawerModel.maxSize),
              animatable: Tween<double>(begin: 0.0, end: documentWidth)),

          //Animation
          leftBottomActionsScaleAnimation: DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: minSize, animationEnd: maxSize),
            animatable: Tween(begin: 1.0, end: 0.0),
          ),

          //Animation
          radialCornerAnimation: DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: minSize, animationEnd: maxSize),
            animatable: Tween(begin: 16.0, end: 40.0),
          ),
          //Animation
          'fadeActions': DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.maxSize - 96.0,
                  animationEnd: drawerModel.maxSize - 12.0),
              animatable: Tween<double>(begin: 0.0, end: 1.0)),
          //Animation
          'surfacePadding': DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.preferredDrawerSize),
              animatable:
                  EdgeInsetsTween(begin: boxPaddingStart, end: boxPaddingEnd)),
          'boxRoundingLeft': DrawerTransformAnimation(
              drawerAnimation: DrawerAnimationStartEnd(
                  animationBegin: drawerModel.minimumSize,
                  animationEnd: drawerModel.preferredDrawerSize),
              animatable: Tween<double>(begin: 0.0, end: 64.0)),
        },
        builder: (BuildContext context, Map values, Widget? child) {
          EdgeInsets padding = values[paddingAnimation];
          Color? backgroundColor = values[backgroundColorAnimation];

          EdgeInsets logoPadding = values[logoPaddingAnimation];
          double logoSize = values[logoHeightAnimation];
          EdgeInsets menuPadding = values[menuTitlePaddingAnimation];
          double menuSize = values[menuTitleHeightAnimation];
          double listWidth = values[listWidthAnimation];
          double menuWidth = values[menuWidthAnimation];
          double backgroundWidth = values[backgroundWidthAnimation];
          double listItemHeight = values[listItemHeightAnimation];
          double minHeightExpand = values[minHeightExpandAnimation];
          double listWidthDocuments = values[listWidthDocumentsAnimation];
          double radialCorner = values[radialCornerAnimation];
          double fadeActions = values['fadeActions'];
          EdgeInsets surfacePadding = values['surfacePadding'];
          double boxRoundingLeft = values['boxRoundingLeft'];

          double leftBottomActionsScale =
              values[leftBottomActionsScaleAnimation];

          double heightPageSelection =
              mortgageItemsList.length * listItemHeight;

          double bottomLeftHeightDefaultActions =
              56.0 * bottomLeftColumnNumberDefaultActions;

          bool minimizeLogo = false;
          bool minimizeButtons = false;

          const boxPadding = EdgeInsets.all(8.0);

          double sizeLeft = drawerModel.sizeParent.height -
              drawerModel.drawerPadding.vertical -
              surfacePadding.vertical -
              boxPadding.vertical;

          if (sizeLeft <
              maxLogoHeight +
                  logoPadding.vertical +
                  heightPageSelection +
                  bottomLeftHeightDefaultActions * leftBottomActionsScale) {
            minimizeLogo = true;
            sizeLeft -= minHeightExpand;
          } else {
            sizeLeft -= logoSize - logoPadding.vertical;
          }

          if (sizeLeft < heightPageSelection + bottomLeftHeightDefaultActions) {
            minimizeButtons = true;
          } else {
            sizeLeft -= bottomLeftHeightDefaultActions;
          }

          return DefaultTextStyle(
            textAlign: TextAlign.center,
            style: dataTheme.textTheme.bodyMedium!
                .copyWith(color: Colors.white, fontSize: 22.0),
            child: Padding(
              padding: padding,
              child: CustomPaint(
                painter: LtrbShapeDrawerPainter(
                    color: backgroundColor,
                    radial: radialCorner,
                    animationValue: 1.0,
                    roundLeftBottom: true,
                    roundLeftTop: true,
                    roundRightBottom: true,
                    roundRightTop: true),
                child: Stack(
                  children: [
                    Positioned(
                        top: surfacePadding.top,
                        left: surfacePadding.left,
                        bottom: surfacePadding.bottom,
                        width: backgroundWidth,
                        child: CustomPaint(
                            painter: RoundedShapeDrawerPainter(
                                color: navigationStyle?.secondBackground,
                                radialLeftBottom: boxRoundingLeft,
                                radialLeftTop: boxRoundingLeft,
                                radialRightBottom: 64.0,
                                radialRightTop: 64.0),
                            child: Container())),
                    Positioned(
                        top: 0.0,
                        left: surfacePadding.left,
                        bottom: 0.0,
                        width: menuWidth,
                        child: Padding(
                          padding: boxPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Logo(
                                  logoPadding: logoPadding,
                                  logoSize: logoSize,
                                  menuTitlePadding: menuPadding,
                                  menuTitleSize: menuSize,
                                  showLogo: !minimizeLogo,
                                  color: deviceScreen.theme
                                      .extension<LtrbNavigationStyle>()!
                                      .imageColor),
                              // const SizedBox(
                              //   height: 8.0,
                              // ),
                              Expanded(
                                  child: MenuList(
                                drawerModel: drawerModel,
                              )),
                              DefaultActions(
                                rowNumber: bottomLeftRowNumberActionButtons,
                                scale: leftBottomActionsScale,
                                visible: !minimizeButtons,
                                children: defaultActionsList,
                              ),
                            ],
                          ),
                        )),
                    if (listWidthDocuments > 0.0)
                      Positioned(
                          left: surfacePadding.left + listWidth,
                          top: padding.top + surfacePadding.top,
                          bottom: padding.bottom + surfacePadding.bottom,
                          width: listWidthDocuments,
                          child: Documents(
                            drawerModel: drawerModel,
                          )),
                    if (fadeActions > 0.0)
                      Positioned(
                          top: surfacePadding.top,
                          left: drawerModel.preferredDrawerSize -
                              surfacePadding.left -
                              72.0,
                          bottom: surfacePadding.bottom,
                          width: 56.0,
                          child: RightExtendRibbon(
                            drawerModel: drawerModel,
                            defaultActions: defaultActionsList,
                            extendedActions: extendedActions,
                            fadeActions: fadeActions,
                          )),
                    Positioned(
                        left: 8.0 + surfacePadding.left,
                        top: 8.0 + surfacePadding.top,
                        child: ExpandDrawerButton(
                          drawerModel: drawerModel,
                        )),
                    // SimpleSwitcher(child: buttons),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class Logo extends StatefulWidget {
  final double menuTitleSize;
  final EdgeInsets menuTitlePadding;
  final double logoSize;
  final EdgeInsets logoPadding;
  final bool showLogo;
  final Color? color;

  const Logo(
      {Key? key,
      required this.menuTitlePadding,
      required this.menuTitleSize,
      required this.logoPadding,
      required this.logoSize,
      required this.showLogo,
      this.color})
      : super(key: key);

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.value = widget.showLogo ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(Logo oldWidget) {
    super.didUpdateWidget(oldWidget);
    check();
  }

  check() {
    if (widget.showLogo &&
        (_controller.status == AnimationStatus.reverse ||
            _controller.status == AnimationStatus.dismissed)) {
      _controller.forward();
    } else if (!widget.showLogo &&
        (_controller.status == AnimationStatus.forward ||
            _controller.status == AnimationStatus.completed)) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationStyle = Theme.of(context).extension<LtrbNavigationStyle>();

    final animationValue = _controller.value;
    final animateValueReverse = 1.0 - animationValue;
    return Stack(
      alignment: Alignment.center,
      children: [
        animateValueReverse == 0.0
            ? const SizedBox.shrink()
            : Padding(
                padding: widget.menuTitlePadding * animateValueReverse,
                child: widget.menuTitleSize == 0.0
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: widget.menuTitleSize * animateValueReverse,
                        child: Center(
                          child: Text('Menu',
                              style: navigationStyle?.headerTextStyle),
                        ),
                      ),
              ),
        animationValue == 0.0
            ? const SizedBox.shrink()
            : Padding(
                padding: widget.logoPadding * animationValue,
                child: widget.logoSize == 0.0
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: widget.logoSize * animationValue,
                        child: Image(
                          image: const AssetImage('graphics/mortgage_logo.png'),
                          color: widget.color,
                        ),
                      )),
      ],
    );
  }
}

class DefaultActions extends StatefulWidget {
  final List<Widget> children;
  final bool visible;
  final int rowNumber;
  final double scale;

  const DefaultActions(
      {Key? key,
      required this.children,
      required this.rowNumber,
      required this.visible,
      required this.scale})
      : super(key: key);

  @override
  State<DefaultActions> createState() => _DefaultActionsState();
}

class _DefaultActionsState extends State<DefaultActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double scale = 0.0;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.value = widget.visible ? 1.0 : 0.0;
    scale = widget.scale * _controller.value;
  }

  @override
  void didUpdateWidget(DefaultActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    check();

    if (oldWidget.scale != widget.scale) {
      setState(() {});
    }
  }

  check() {
    if (widget.visible &&
        (_controller.status == AnimationStatus.reverse ||
            _controller.status == AnimationStatus.dismissed)) {
      _controller.forward();
    } else if (!widget.visible &&
        (_controller.status == AnimationStatus.forward ||
            _controller.status == AnimationStatus.completed)) {
      _controller.reverse();
    }
  }

  change() {
    if (scale == _controller.value * widget.scale) {
      setState(() {
        scale = _controller.value * widget.scale;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    scale = widget.scale * _controller.value;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.rowNumber * 56.0),
      child: scale == 0.0
          ? null
          : ScaleResized(
              scale: scale,
              child: Wrap(
                children: widget.children,
              ),
            ),
    );
  }
}

class MenuList extends StatefulWidget {
  final DrawerModel drawerModel;

  const MenuList({
    Key? key,
    required this.drawerModel,
  }) : super(key: key);

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final navigationStyle = themeData.extension<LtrbNavigationStyle>();

    final pathPatternSegments =
        (context.currentBeamLocation.state as BeamState).pathPatternSegments;
    final String route =
        pathPatternSegments.length >= 2 ? pathPatternSegments[1] : '';

    final list = ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: mortgageItemsList.length,
        itemBuilder: (BuildContext context, int index) {
          final MortgageItems item = mortgageItemsList[index];

          return SizedBox(
              height: 56.0,
              child: Stack(
                children: [
                  DrawerTransformAnimationWidget<double>(
                      drawerModel: widget.drawerModel,
                      animation: DrawerTransformAnimation(
                          drawerAnimation: DrawerAnimationStartEnd(
                              animationBegin: 140.0, animationEnd: 180.0),
                          animatable: Tween(begin: 1.0, end: 0.0)),
                      builder: (BuildContext context, double value,
                          double tweenValue, Widget? child) {
                        final double scaleValue = tweenValue;
                        final Matrix4 transform = Matrix4.identity()
                          ..scale(scaleValue, scaleValue, 1.0);

                        return Transform(
                            transform: transform,
                            alignment: Alignment.center,
                            child: SelectedIconButton<String>(
                                onChanged: onChanged,
                                value: item.id,
                                groupValue: route,
                                icon: ImageIcon(AssetImage(
                                  item.imageName,
                                )),
                                iconColor: navigationStyle?.colorItem,
                                iconColorSelected:
                                    navigationStyle?.colorSelectedItem,
                                backgroundColorSelected:
                                    navigationStyle?.backgroundSelectedItem));
                      }),
                  DrawerTransformAnimationWidget<double>(
                      drawerModel: widget.drawerModel,
                      animation: DrawerTransformAnimation(
                          drawerAnimation: DrawerAnimationStartEnd(
                              animationBegin: 160.0, animationEnd: 180.0),
                          animatable: Tween(begin: 0.0, end: 1.0)),
                      builder: (BuildContext context, double value,
                          double tweenValue, Widget? child) {
                        final double scaleValue = tweenValue;
                        final Matrix4 transform = Matrix4.identity()
                          ..scale(scaleValue, scaleValue, 1.0);
                        return Transform(
                          transform: transform,
                          alignment: Alignment.center,
                          child: Center(
                            child: SelectedTextButton<String>(
                              minWidthText: 208.0,
                              textColor: navigationStyle?.colorItem,
                              selectedTextColor:
                                  navigationStyle?.colorSelectedItem,
                              selectedBackbround:
                                  navigationStyle?.backgroundSelectedItem,
                              onChanged: onChanged,
                              onPress: () => widget.drawerModel.pop(),
                              value: item.id,
                              groupValue: route,
                              child: Text(item.title),
                            ),
                          ),
                        );
                      })
                ],
              ));
        });
    return list;
  }

  void onChanged(String value) {
    setState(() {
      Beamer.of(context).beamToNamed('/document/$value', stacked: false);
    });
  }
}

class SelectedTextButton<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T>? onChanged;
  final Widget child;
  final Color? selectedBackbround;
  final Color? textColor;
  final Color? selectedTextColor;
  final double minWidthText;
  final VoidCallback? onPress;

  const SelectedTextButton(
      {Key? key,
      required this.child,
      required this.value,
      required this.groupValue,
      required this.selectedBackbround,
      required this.textColor,
      required this.selectedTextColor,
      required this.minWidthText,
      this.onChanged,
      this.onPress})
      : super(key: key);

  @override
  State<SelectedTextButton<T>> createState() => _SelectedTextButtonState<T>();

  bool get _selected => value == groupValue;
}

class _SelectedTextButtonState<T> extends State<SelectedTextButton<T>> {
  void handlePress() {
    if (!widget._selected) {
      widget.onChanged!(widget.value);
    }
    widget.onPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final navigationStyle = themeData.extension<LtrbNavigationStyle>();

    return LayoutBuilder(builder: (context, constraints) {
      return TextButton(
          onPressed: handlePress,
          style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
              textStyle:
                  themeData.textTheme.bodyMedium!.copyWith(fontSize: 18.0),
              minimumSize: const Size(56.0, 56.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: widget._selected
                  ? widget.selectedTextColor
                  : widget.textColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)),
              backgroundColor: widget._selected
                  ? navigationStyle?.backgroundSelectedItem
                  : null),
          child: DrawerOverflowBox(
            minWidth: widget.minWidthText,
            child: widget.child,
          )

          // animationDuration: Duration.zero
          );
    });
  }
}

class SelectedIconButton<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T>? onChanged;
  final Widget icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? backgroundColorSelected;
  final Color? iconColorSelected;

  const SelectedIconButton(
      {Key? key,
      required this.icon,
      required this.value,
      required this.groupValue,
      this.onChanged,
      this.backgroundColor,
      this.iconColor,
      this.backgroundColorSelected,
      required this.iconColorSelected})
      : super(key: key);

  @override
  State<SelectedIconButton<T>> createState() => _SelectedIconButtonState<T>();

  bool get _selected => value == groupValue;

  Color? get _iconColor => value == groupValue ? iconColorSelected : iconColor;

  Color? get _backgroundColor =>
      value == groupValue ? backgroundColorSelected : backgroundColor;
}

class _SelectedIconButtonState<T> extends State<SelectedIconButton<T>> {
  void handlePress() {
    if (!widget._selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final navigationStyle = themeData.extension<LtrbNavigationStyle>();

    final child = IconButton(
      color: widget._iconColor,
      iconSize: 28.0,
      icon: widget.icon,
      onPressed: handlePress,
    );

    final background = widget._backgroundColor;

    return Center(
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: background == null
            ? MaterialType.transparency
            : MaterialType.canvas,
        color: navigationStyle?.backgroundSelectedItem,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: child,
      ),
    );
  }
}

class ExpandDrawerButton extends StatelessWidget {
  final DrawerModel drawerModel;
  const ExpandDrawerButton({Key? key, required this.drawerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final navigationStyle = themeData.extension<LtrbNavigationStyle>();

    final drawerStatus = drawerModel.drawerStatus;

    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (drawerStatus == DrawerStatus.start) {
            drawerModel.open();
          } else {
            drawerModel.pop();
          }
        },
        child: Stack(
          children: [
            DrawerTransformAnimationWidget(
              drawerModel: drawerModel,
              animation: DrawerTransformAnimation(
                  drawerAnimation: DrawerAnimationStartEnd(
                      animationEndRatio: 0.5, reverse: false, toEnd: false),
                  animatable: Tween<double>(begin: 0.0, end: 0.5 * math.pi)),
              child: Icon(
                Icons.chevron_right,
                color: navigationStyle?.colorItem,
              ),
              builder: (BuildContext context, double value, double valueTween,
                  Widget? child) {
                return SizedBox(
                    height: 64.0,
                    width: 64.0,
                    child: value == 1.0
                        ? null
                        : Transform(
                            transform: Matrix4.rotationY(valueTween),
                            alignment: Alignment.center,
                            child: child,
                          ));
              },
            ),
            DrawerTransformAnimationWidget<double>(
              drawerModel: drawerModel,
              animation: DrawerTransformAnimation(
                  drawerAnimation: DrawerAnimationStartEnd(
                      animationBeginRatio: 0.5, reverse: false, toEnd: false),
                  animatable: Tween<double>(begin: 0.5 * math.pi, end: 0.0)),
              child: Icon(
                Icons.chevron_left,
                color: navigationStyle?.colorItem,
              ),
              builder: (BuildContext context, double value, double valueTween,
                  Widget? child) {
                return SizedBox(
                    width: 64.0,
                    height: 64.0,
                    child: value == 0.0
                        ? null
                        : Transform(
                            transform: Matrix4.rotationY(valueTween),
                            alignment: Alignment.center,
                            child: child,
                          ));
              },
            )
          ],
        ),
      ),
    );
  }
}

class Documents extends StatelessWidget {
  final DrawerModel drawerModel;
  const Documents({Key? key, required this.drawerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigationStyle = theme.extension<LtrbNavigationStyle>();

    int length = documentsMobileVoorbeelden.length;

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: boxPaddingStart.vertical, horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Flexible(
                flex: 1,
                child: DrawerOverflowBox(
                    fitWidth: FitDrawerOverflowBox.fill,
                    minWidth: 200.0,
                    child: Text(
                      'Documenten',
                      style: navigationStyle?.headerTextStyle
                          ?.copyWith(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    )),
              ),
              Flexible(
                  flex: 1,
                  child: DrawerOverflowBox(
                    fitWidth: FitDrawerOverflowBox.fill,
                    minWidth: 200.0,
                    child: Text(
                      'Nieuws',
                      style: navigationStyle?.headerTextStyle
                          ?.copyWith(fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 12.0,
          ),
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: DrawerOverflowBox(
              fitWidth: FitDrawerOverflowBox.fill,
              fitHeight: FitDrawerOverflowBox.fill,
              minWidth: 200.0,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                    return MobileDocumentCard(
                      index: index,
                      document: documentsMobileVoorbeelden[index],
                      length: length,
                    );
                  }, childCount: length))
                ],
                // )
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class RightExtendRibbon extends StatelessWidget {
  final DrawerModel drawerModel;
  final List<Widget> defaultActions;
  final List<Widget> extendedActions;
  final double fadeActions;

  const RightExtendRibbon(
      {Key? key,
      required this.drawerModel,
      this.defaultActions = const [],
      this.extendedActions = const [],
      required this.fadeActions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: fadeActions,
        child: Column(
          children: [
            LoginButton(
              onTap: () {},
            ),
            ...extendedActions,
            const Expanded(
                child: Center(
              child: Divider(),
            )),
            ...defaultActions,
          ],
        ));
  }
}
