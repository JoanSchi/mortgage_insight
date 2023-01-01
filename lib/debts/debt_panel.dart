import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/debts/doorlopend_krediet.dart/doorlopend_krediet.dart';
import 'package:mortgage_insight/debts/lease_auto/lease_auto.dart';
import 'package:mortgage_insight/debts/verzend_krediet/verzend_krediet.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_doorlopend_krediet.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_lease_auto.dart';
import 'package:mortgage_insight/model/nl/schulden/schulden_verzend_krediet.dart';
import 'package:mortgage_insight/state_manager/edit_state.dart';
import 'package:mortgage_insight/state_manager/state_edit_object.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import 'package:nested_scroll_view_3m/nested_scroll_view_3m.dart';
import '../model/nl/schulden/schulden.dart';
import '../model/nl/schulden/schulden_aflopend_krediet.dart';
import '../my_widgets/my_page/my_page.dart';
import '../routes/routes_items.dart';
import '../template_mortgage_items/AcceptCancelActions.dart';
import 'aflopend_krediet/aflopend_krediet_panel.dart';
import 'package:go_router/go_router.dart';

import 'debt_list/debt_list.dart';

final _messageListeners = MessageListener<AcceptCancelBackMessage>();

class LastPanel extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DebtPanelState();
}

class _DebtPanelState extends ConsumerState<LastPanel> {
  add() {
    // TODO: Fix
    // ref.read(routeEditPageProvider.notifier).editState =
    //     EditRouteState(route: routeDebtsEdit);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceScreen = DeviceScreen3.of(context);

    SchuldenContainer schulden = ref.watch(
        hypotheekContainerProvider.select((value) => value.schuldenContainer));

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

    Widget body = Builder(
        builder: (context) => Stack(children: [
              Positioned(
                  left: 0.0,
                  top: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: GridList(list: schulden.list)),
              Positioned(
                  width: 100.0,
                  height: 100.0,
                  right: 24.0,
                  bottom: 16.0,
                  child: Align(
                      alignment: Alignment.bottomRight, child: floatingButton))
            ]));

    return MyPage(
        handleSliverOverlap: false,
        title: 'Schulden',
        imageName: 'graphics/fit_debts.png',
        body: body);
  }
}

final debtsList = <DebtItem>[
  DebtItem(
      title: 'Aflopende Krediet',
      level: 0,
      schuld: AflopendKrediet(
        categorie: SchuldenCategorie.aflopend_krediet,
      )),
  DebtItem(
      title: 'Verzendhuiskrediet',
      level: 0,
      schuld: VerzendhuisKrediet(
        categorie: SchuldenCategorie.verzendhuiskrediet,
      )),
  DebtItem(
      title: 'Operationele Lease Auto',
      level: 0,
      schuld: OperationalLeaseAuto(
        categorie: SchuldenCategorie.operationele_autolease,
      )),
  DebtItem(
      title: 'Doorlopend Krediet',
      level: 0,
      schuld: DoorlopendKrediet(
        categorie: SchuldenCategorie.doorlopend_krediet,
      ))
];

class DebtItem {
  String title;
  int level;
  Schuld schuld;

  DebtItem({
    required this.title,
    required this.level,
    required this.schuld,
  });

  @override
  String toString() => 'DebtItem(title: $title, sub: $level, schuld: $schuld)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DebtItem &&
        other.title == title &&
        other.level == level &&
        other.schuld == schuld;
  }

  @override
  int get hashCode => title.hashCode ^ level.hashCode ^ schuld.hashCode;
}

class BewerkSchulden extends StatelessWidget {
  const BewerkSchulden({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyPage(
        backgroundColor: Colors.white,
        handleSliverOverlap: true,
        leftActions: IconButton(
            onPressed: () => _messageListeners
                .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.back)),
            icon: Icon(Icons.arrow_back)),
        title: 'Toevoegen',
        imageName: 'graphics/fit_debts.png',
        hasNavigationBar: false,
        body: SelectieNieuwOfBestaandeSchuld());
  }
}

class SelectieNieuwOfBestaandeSchuld extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Schuld? s = ref.watch(editObjectProvider).object;

    if (s != null && s.id > 0) {
      return MessageListenerWidget<AcceptCancelBackMessage>(
          onMessage: (AcceptCancelBackMessage msg) {
            if (msg.msg == AcceptCancelBack.back) context.pop();
          },
          listener: _messageListeners,
          child: _editPanel(s));
    } else {
      return SchuldSelectiePageViewer();
    }
  }
}

class SchuldSelectiePageViewer extends ConsumerStatefulWidget {
  SchuldSelectiePageViewer({Key? key}) : super(key: key);

  @override
  ConsumerState<SchuldSelectiePageViewer> createState() =>
      _DebtPageViewerState();
}

class _DebtPageViewerState extends ConsumerState<SchuldSelectiePageViewer> {
  late PageController _pageController;

  setDebt(Schuld? schuld) {
    setState(() {
      if (schuld != null) {
        ref.watch(editObjectProvider).object = schuld.copyWith();
        _pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Schuld? s = ref.watch(editObjectProvider).object;

    final list = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            CustomScrollView(slivers: [
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber
                // above.
                handle:
                    NestedScrollView3M.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                  child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: debtsList.map((DebtItem e) {
                    return SelectedTextButton(
                        value: e.schuld,
                        groupValue: s,
                        onChanged: setDebt,
                        minWidthText: 300.0,
                        selectedBackbround: theme.primaryColor,
                        selectedTextColor: Colors.white,
                        textColor: theme.colorScheme.onSecondary,
                        text: e.title);
                  }).toList(),
                ),
              )),
            ]));

    final pageView = PageView(
      controller: _pageController,
      children: [list, if (s != null) _editPanel(s)],
    );

    return MessageListenerWidget<AcceptCancelBackMessage>(
        onMessage: message, listener: _messageListeners, child: pageView);
  }

  void message(AcceptCancelBackMessage msg) {
    if (msg.msg == AcceptCancelBack.back) {
      if (_pageController.page == 1) {
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      } else {
        context.pop();
      }
    }
  }
}

Widget _editPanel(Schuld s) {
  Widget editPanel;

  switch (s.runtimeType) {
    case AflopendKrediet:
      {
        editPanel = AflopendKredietPanel(
          messageListener: _messageListeners,
          key: Key('edit'),
          aflopendKrediet: s as AflopendKrediet,
        );
        break;
      }
    case VerzendhuisKrediet:
      {
        editPanel = VerzendKredietPanel(
          messageListener: _messageListeners,
          key: Key('edit_verzendhuiskrediet'),
          verzendHuisKrediet: s as VerzendhuisKrediet,
        );
        break;
      }
    case OperationalLeaseAuto:
      {
        editPanel = LeaseAutoPanel(
          messageListener: _messageListeners,
          key: Key('edit_operationalLeaseAuto'),
          operationalLeaseAuto: s as OperationalLeaseAuto,
        );
        break;
      }

    case DoorlopendKrediet:
      {
        editPanel = DoorlopendKredietPanel(
          messageListener: _messageListeners,
          key: Key('edit_operationalLeaseAuto'),
          doorlopendKrediet: s as DoorlopendKrediet,
        );
        break;
      }
    default:
      {
        return Center(child: Text(':{', textScaleFactor: 20.0));
      }
  }

  return AcceptCanelPanel(
      accept: () => _messageListeners
          .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.accept)),
      cancel: () => _messageListeners
          .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)),
      child: editPanel);
}

class SelectedTextButton extends StatefulWidget {
  final Schuld value;
  final Schuld? groupValue;
  final ValueChanged<Schuld?>? onChanged;
  final String text;
  final Color selectedBackbround;
  final int level;

  final Color textColor;

  final Color selectedTextColor;
  final double minWidthText;

  SelectedTextButton(
      {Key? key,
      required this.text,
      required this.value,
      required this.groupValue,
      required this.selectedBackbround,
      required this.textColor,
      required this.selectedTextColor,
      required this.minWidthText,
      this.level = 0,
      this.onChanged})
      : super(key: key);

  @override
  State<SelectedTextButton> createState() => _SelectedTextButtonState();

  bool get _selected => Schuld.equalSubCategorie(value, groupValue);
}

class _SelectedTextButtonState<T> extends State<SelectedTextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ColorTween colorTween;
  late CurveTween curvedTween = CurveTween(curve: Curves.easeInCubic);
  late Animation<Color?> _colorAnimation;
  late Animation _curvedAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorTween = ColorTween(begin: null, end: widget.selectedBackbround);

    _colorAnimation = colorTween
        .chain(CurveTween(curve: Curves.easeInCubic))
        .animate(_controller);

    _curvedAnimation = curvedTween.animate(_controller);

    _controller.value = widget._selected ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handlePress() {
    widget.onChanged!(widget.value);
  }

  @override
  void didUpdateWidget(covariant SelectedTextButton oldWidget) {
    if (widget._selected && _controller.value != 1.0) {
      _controller.forward();
    } else if (!widget._selected && _controller.value != 0.0) {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final inkWell = Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          child: SizedBox(
              width: 300,
              height: 56,
              child: Center(
                  child: Text(
                widget.text,
                style: themeData.textTheme.bodyText2?.copyWith(
                    fontSize: 18.0,
                    color: widget._selected
                        ? Colors.white
                        : themeData.colorScheme.onSecondary),
              ))),
          onTap: handlePress,
        ));

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
            painter: BackgroundSelectedTextButton(
                color: _colorAnimation.value, value: _curvedAnimation.value),
            child: child);
      },
      child: inkWell,
    );
  }
}

class BackgroundSelectedTextButton extends CustomPainter {
  final Color? color;
  final double value;
  final double radial;

  BackgroundSelectedTextButton({
    this.color,
    required this.value,
    this.radial = 16.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (color != null) {
      double min = 2.0 * radial;
      double width = min + (size.width - min) * value;
      double height = min + (size.height - min) * value;

      double left = (size.width - width) / 2.0;
      double top = (size.height - height) / 2.0;
      double right = left + width;
      double bottom = top + height;

      Paint _paint = Paint()
        ..color = color!
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
          RRect.fromLTRBR(left, top, right, bottom, Radius.circular(radial)),
          _paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundSelectedTextButton oldDelegate) {
    return color != oldDelegate.color || value != oldDelegate.value;
  }
}
