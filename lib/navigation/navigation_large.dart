import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/routes/routes_items.dart';
import '../routes/page_route.dart';
import '../state_manager/widget_state.dart';
import '../theme/ltrb_navigation_style.dart';

class LargeDrawer extends StatefulWidget {
  const LargeDrawer({super.key});

  @override
  State<LargeDrawer> createState() => _LargeDrawerState();
}

class _LargeDrawerState extends State<LargeDrawer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    LtrbNavigationStyle? navigationStyle =
        theme.extension<LtrbNavigationStyle>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(minWidth: 400, maxWidth: 1100, maxHeight: 128.0),
          child: Row(children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Image(
                image: const AssetImage('graphics/mortgage_logo.png'),
                color: theme.primaryColor,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: RichText(
                            text: TextSpan(
                              style: navigationStyle?.headerTextStyle?.copyWith(
                                fontSize: 36,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Hypotheek ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic)),
                                TextSpan(
                                    text: 'Inzicht',
                                    style: TextStyle(
                                        color: theme.primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 52.0, child: HorizontalTabBar())
                ],
              ),
            )
          ]),
        ),
        Divider(
          height: 2.0,
        ),
        Expanded(
          child: RoutePage(),
        )
      ],
    );
  }
}

class HorizontalTabBar extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HorizontalTabBarState();
}

class _HorizontalTabBarState extends ConsumerState<HorizontalTabBar> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: Scrollbar(
            controller: controller,
            child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final MortgageItems mi = mortgageItemsList[index];
                  final bool selected =
                      ref.watch(routePageProvider.select((id) => id == mi.id));

                  return InkWell(
                      key: Key(mi.id),
                      child: _LineUnder(
                        selected: selected,
                        strokeWidth: 4.0,
                        color: theme.primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 10.0),
                          child: Text(
                            mi.title,
                            style: TextStyle(
                                fontSize: 24, color: theme.primaryColor),
                          ),
                        ),
                      ),
                      onTap: () {
                        ref.read(routePageProvider.notifier).pageRoute = mi.id;
                      });
                },
                itemCount: mortgageItemsList.length)));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class _LineUnder extends StatefulWidget {
  final bool selected;
  final Color color;
  final double strokeWidth;
  final Widget child;

  const _LineUnder(
      {required this.child,
      required this.selected,
      required this.color,
      required this.strokeWidth});

  @override
  State<_LineUnder> createState() => _LineUnderState();
}

class _LineUnderState extends State<_LineUnder>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool selected = false;

  @override
  void initState() {
    selected = widget.selected;
    _animationController = AnimationController(
        value: widget.selected ? 1.0 : 0.0,
        vsync: this,
        duration: const Duration(milliseconds: 200));
    super.initState();
  }

  @override
  void didUpdateWidget(_LineUnder oldWidget) {
    if (selected != widget.selected) {
      selected = widget.selected;
      if (selected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        child: widget.child,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            child: child,
            painter: LinePaint(
                animationValue: _animationController.value,
                color: widget.color,
                strokeWidth: widget.strokeWidth,
                horizontalPadding: 12.0,
                bottomPadding: 4.0),
          );
        });
  }
}

class LinePaint extends CustomPainter {
  final Color color;
  final double animationValue;
  final double strokeWidth;
  final double horizontalPadding;
  final double bottomPadding;

  LinePaint(
      {required this.animationValue,
      required this.color,
      required this.strokeWidth,
      required this.horizontalPadding,
      required this.bottomPadding});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    final x1 = horizontalPadding +
        (size.width - horizontalPadding * 2) / 2.0 * (1.0 - animationValue);
    final x2 = size.width - x1;
    final y = size.height - strokeWidth / 2.0 - bottomPadding;

    canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
  }

  @override
  bool shouldRepaint(LinePaint oldDelegate) {
    return animationValue != oldDelegate.animationValue ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        horizontalPadding != oldDelegate.horizontalPadding ||
        bottomPadding != oldDelegate.bottomPadding;
  }
}



//   t(){
      
//       ListView.builder(itemBuilder: itemBuilder)
//       final i = mortgageItemsList[index];

//       final selected = ref.watch(routePageProvider.select((id) => id == i.id));

//       return MyTile(
//         title: i.title,
//         selected: selected,
//         onTap: () {
//           widget.drawerModel.pop();
//           ref.read(routePageProvider.notifier).pageRoute = i.id;
//         },
//       );
//     }
//   }
// }
