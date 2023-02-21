import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation.dart';
import 'package:ltrb_navigation_drawer/drawer_animation/drawer_animation_widget.dart';
import 'package:ltrb_navigation_drawer/drawer_layout.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_model.dart';
import 'package:ltrb_navigation_drawer/ltbr_drawer_widgets.dart';
import 'package:ltrb_navigation_drawer/overlay_indicator/ltbr_drawer_indicator.dart';
import '../layout/transition/scale_size_transition.dart';
import '../route_widgets/document/route_widget_page.dart';
import '../state_manager/routes/routes_app.dart';
import '../state_manager/routes/routes_handle_app.dart';
import '../theme/ltrb_navigation_style.dart';
import 'navigation_document_examples.dart';
import '../model/nl/hypotheek_container/hypotheek_container.dart';
import 'navigation_login_button.dart';
import 'navigation_page_items.dart';
import '../utilities/device_info.dart';

class MediumDrawer extends StatefulWidget {
  const MediumDrawer({Key? key}) : super(key: key);

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
      body: MyRoutePage(),
      expandBody: false,
      allowMaximumSize: false,
      scrimeColorEnd: Color.fromARGB(9, 0, 0, 0),

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
const menuPaddingAnimation = 'menuPaddingAnimation';
const logoScaleAnimation = 'logoAnimation';
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

    final Widget menu = MenuList(
      drawerModel: drawerModel,
    );

    final List<Widget> defaultActionsList = [
      SizedBox(
        height: 48.0,
        width: 48.0,
        child: IconButton(
            onPressed: () => print('setting'), icon: Icon(Icons.settings)),
      ),
      SizedBox(
        height: 48.0,
        width: 48.0,
        child:
            IconButton(onPressed: () => print('info'), icon: Icon(Icons.info)),
      )
    ];

    final extendedActions = [
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          resetHypotheekInzicht(ref);
          drawerModel.pop();
        },
      ),
      IconButton(
        icon: const ImageIcon(AssetImage('graphics/ic_open.png')),
        onPressed: () => print("open"),
      ),
      IconButton(
        icon: const Icon(Icons.import_export),
        onPressed: () {
          ref.read(hypotheekContainerProvider).saveHypotheekContainer();
          drawerModel.pop();
        },
      )
    ];

    int bottomLeftColumnNumberDefaultActions;
    int bottomLeftRowNumberActionButtons;

    if (defaultActionsList.length > 0) {
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

    final minScaleLogo = drawerModel.minimumSize == narrowMinSize ? 0.0 : 0.9;
    double maxLogo = 148.0;

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
          logoScaleAnimation: DrawerTransformAnimation(
            drawerAnimation: DrawerAnimationStartEnd(
                animationBegin: minSize, animationEnd: maxSize),
            animatable: Tween(begin: minScaleLogo, end: 1.0),
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
          'boxPadding': DrawerTransformAnimation(
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

          double logoScale = values[logoScaleAnimation];
          double listWidth = values[listWidthAnimation];
          double menuWidth = values[menuWidthAnimation];
          double backgroundWidth = values[backgroundWidthAnimation];
          double listItemHeight = values[listItemHeightAnimation];
          double minHeightExpand = values[minHeightExpandAnimation];
          // double general = values[generalAnimation];
          double listWidthDocuments = values[listWidthDocumentsAnimation];
          double radialCorner = values[radialCornerAnimation];
          double fadeActions = values['fadeActions'];
          EdgeInsets boxPadding = values['boxPadding'];
          double boxRoundingLeft = values['boxRoundingLeft'];

          double leftBottomActionsScale =
              values[leftBottomActionsScaleAnimation];

          double heightPageSelection =
              mortgageItemsList.length * listItemHeight;

          double bottomLeftHeightDefaultActions =
              56.0 * bottomLeftColumnNumberDefaultActions;

          bool minimizeLogo = false;
          bool minimizeButtons = false;

          double logoHeight = maxLogo * logoScale + minHeightExpand / 2.0;

          double sizeLeft = drawerModel.sizeParent.height -
              drawerModel.drawerPadding.vertical;

          if (sizeLeft <
              logoHeight +
                  heightPageSelection +
                  bottomLeftHeightDefaultActions) {
            minimizeLogo = true;
            sizeLeft -= minHeightExpand;
          } else {
            sizeLeft -= logoHeight;
          }

          if (sizeLeft < heightPageSelection + bottomLeftHeightDefaultActions) {
            minimizeButtons = true;
          } else {
            sizeLeft -= bottomLeftHeightDefaultActions;
          }

          return DefaultTextStyle(
            textAlign: TextAlign.center,
            style: dataTheme.textTheme.bodyText2!
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
                        top: boxPadding.top,
                        left: boxPadding.left,
                        bottom: boxPadding.bottom,
                        width: backgroundWidth,
                        child: CustomPaint(
                            painter: RoundedShapeDrawerPainter(
                                color: navigationStyle?.secondBackground,
                                radialLeftBottom: boxRoundingLeft,
                                radialLeftTop: boxRoundingLeft,
                                radialRightBottom: 64,
                                radialRightTop: 64),
                            child: Container())),
                    Positioned(
                        top: 0.0,
                        left: boxPadding.left,
                        bottom: 0.0,
                        width: menuWidth,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Logo(
                                  minimumHeight: minHeightExpand,
                                  height: maxLogo,
                                  visible: !minimizeLogo,
                                  scale: logoScale,
                                  color: deviceScreen.theme
                                      .extension<LtrbNavigationStyle>()!
                                      .imageColor),
                              SizedBox(
                                height: 8.0,
                              ),
                              Expanded(child: menu),
                              DefaultActions(
                                children: defaultActionsList,
                                rowNumber: bottomLeftRowNumberActionButtons,
                                scale: leftBottomActionsScale,
                                visible: !minimizeButtons,
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                            ],
                          ),
                        )),
                    if (listWidthDocuments > 0.0)
                      Positioned(
                          left: boxPadding.left + listWidth,
                          top: padding.top + boxPadding.top,
                          bottom: padding.bottom + boxPadding.bottom,
                          width: listWidthDocuments,
                          child: Documents(
                            drawerModel: drawerModel,
                          )),
                    if (fadeActions > 0.0)
                      Positioned(
                          top: boxPadding.top,
                          left: drawerModel.preferredDrawerSize -
                              boxPadding.left -
                              72.0,
                          bottom: boxPadding.bottom,
                          width: 56.0,
                          child: RightExtendRibbon(
                            drawerModel: drawerModel,
                            defaultActions: defaultActionsList,
                            extendedActions: extendedActions,
                            fadeActions: fadeActions,
                          )),
                    Positioned(
                        left: 8.0 + boxPadding.left,
                        top: 8.0 + boxPadding.top,
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
  final double height;
  final bool visible;
  final double minimumHeight;
  final double scale;
  final Color? color;

  const Logo(
      {Key? key,
      required this.minimumHeight,
      required this.height,
      required this.visible,
      required this.scale,
      this.color})
      : super(key: key);

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(Logo oldWidget) {
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
    final navigationStyle = Theme.of(context).extension<LtrbNavigationStyle>();

    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: widget.minimumHeight),
        child: widget.scale == 0.0
            ? null
            : Stack(
                children: [
                  _controller.value == 1.0
                      ? SizedBox.shrink()
                      : Padding(
                          padding:
                              EdgeInsets.only(top: boxPaddingStart.top + 8.0),
                          child: Text('Menu',
                              style: navigationStyle?.headerTextStyle),
                        ),
                  _controller.value == 0.0
                      ? SizedBox.shrink()
                      : Padding(
                          padding:
                              EdgeInsets.only(top: widget.minimumHeight / 2.0),
                          child: ScaleResized(
                            scale: scale,
                            child: Image(
                              height: widget.height,
                              image: const AssetImage(
                                  'graphics/mortgage_logo.png'),
                              color: widget.color,
                            ),
                          ),
                        ),
                ],
              ));
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

    final list = ListView.builder(
        itemCount: mortgageItemsList.length,
        itemBuilder: (BuildContext context, int index) {
          final MortgageItems item = mortgageItemsList[index];

          return SizedBox(
              height: 56.0,
              child: Consumer(builder: (context, ref, child) {
                final String route = watchRoutePage(ref);

                return Stack(
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
                                  onChanged: (String value) {
                                    HandleRoutes.setRoutePage(ref, value);
                                  },
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
                            child: SizedBox(
                              width: tweenValue * 240.0,
                              child: SelectedTextButton<String>(
                                minWidthText: 208.0,
                                textColor: navigationStyle?.colorItem,
                                selectedTextColor:
                                    navigationStyle?.colorSelectedItem,
                                selectedBackbround:
                                    navigationStyle?.backgroundSelectedItem,
                                onChanged: (String value) {
                                  HandleRoutes.setRoutePage(ref, value);
                                },
                                onPress: () => widget.drawerModel.pop(),
                                value: item.id,
                                groupValue: route,
                                child: Text(item.title),
                              ),
                            ),
                          );
                        })
                  ],
                );
              }));
        });
    return list;
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

  SelectedTextButton(
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

    return LayoutBuilder(builder: (context, constraints) {
      return TextButton(
          onPressed: handlePress,
          child: DrawerOverflowBox(
            child: widget.child,
            minWidth: widget.minWidthText,
          ),
          style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              textStyle:
                  themeData.textTheme.bodyText2!.copyWith(fontSize: 18.0),
              minimumSize: Size(56.0, 56.0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: widget._selected
                  ? widget.selectedTextColor
                  : widget.textColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              backgroundColor:
                  widget._selected ? widget.selectedBackbround : null)

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

  SelectedIconButton(
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
    final child = Center(
      child: IconButton(
        color: widget._iconColor,
        iconSize: 24.0,
        icon: widget.icon,
        onPressed: handlePress,
      ),
    );

    final background = widget._backgroundColor;

    return Material(
      clipBehavior: Clip.antiAlias,
      type:
          background == null ? MaterialType.transparency : MaterialType.canvas,
      color: widget._backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: child,
    );
  }
}

class ExpandDrawerButton extends StatelessWidget {
  final DrawerModel drawerModel;
  const ExpandDrawerButton({Key? key, required this.drawerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                // color: Colors.white,
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
                            child: child,
                            alignment: Alignment.center,
                          ));
              },
            ),
            DrawerTransformAnimationWidget<double>(
              drawerModel: drawerModel,
              animation: DrawerTransformAnimation(
                  drawerAnimation: DrawerAnimationStartEnd(
                      animationBeginRatio: 0.5, reverse: false, toEnd: false),
                  animatable: Tween<double>(begin: 0.5 * math.pi, end: 0.0)),
              child: Icon(Icons.chevron_left),
              builder: (BuildContext context, double value, double valueTween,
                  Widget? child) {
                return SizedBox(
                    width: 64.0,
                    height: 64.0,
                    child: value == 0.0
                        ? null
                        : Transform(
                            transform: Matrix4.rotationY(valueTween),
                            child: child,
                            alignment: Alignment.center,
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
          SizedBox(
            height: 8,
          ),
          DrawerOverflowBox(
              minWidth: 200.0,
              child: Text(
                'Documenten',
                style: navigationStyle?.headerTextStyle,
              )),
          SizedBox(
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
            Expanded(
                child: Center(
              child: Divider(),
            )),
            ...defaultActions,
          ],
        ));
  }
}

  // _list(BuildContext context, double scale) {
  //   return LayoutBuilder(
  //       builder: (BuildContext context, BoxConstraints constraints) {
  //     Widget list;
  //     if ((defaultActions.length + extendedActions.length + 0.5) * 48.0 >
  //         constraints.maxHeight) {
  //       list = ListView(
  //         children: [
  //           ...extendedActions,
  //           ...defaultActions,
  //         ],
  //       );
  //       return list;
  //     } else {
  //       return Stack(children: [
  //         Positioned(
  //             left: 0.0,
  //             top: 0.0,
  //              right: 0.0,
  //             child: ScaleResized(
  //                 scale: scale,
  //                 alignment: Alignment.center,
  //                 child: Column(children: extendedActions))),
  //         if (defaultActions.length > 0)
  //           Positioned(
  //               left: 0.0,
  //               bottom: 0.0,
  //               right: 0.0,
  //               child: ScaleResized(
  //                   scale: scale,
  //                   alignment: Alignment.center,
  //                   child: Column(children: defaultActions)))
  //       ]);
  //     }
  //   });
  // }
