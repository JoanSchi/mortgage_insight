import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mortgage_insight/pages/schulden/doorlopend_krediet.dart/doorlopend_krediet.dart';
import 'package:mortgage_insight/pages/schulden/lease_auto/lease_auto.dart';

import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';

import 'package:mortgage_insight/platform_page_format/page_actions.dart';

import 'package:mortgage_insight/utilities/Kalender.dart';
import 'package:mortgage_insight/utilities/device_info.dart';

import '../../model/nl/schulden/schulden.dart';

import '../../platform_page_format/default_page.dart';
import '../../platform_page_format/page_properties.dart';
import '../../utilities/message_listeners.dart';

import 'package:go_router/go_router.dart';

final _messageListeners = MessageListener<AcceptCancelBackMessage>();

class SchuldKeuzePanel extends StatelessWidget {
  const SchuldKeuzePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final back = PageActionItem(
        voidCallback: () => _messageListeners
            .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.back)),
        icon: Icons.arrow_back);

    return DefaultPage(
        matchPageProperties: [
          MatchPageProperties(
              types: {FormFactorType.Unknown},
              pageProperties: PageProperties(leftTopActions: [back]))
        ],
        title: 'Toevoegen',
        imageBuilder: (_) => Image(
            image: AssetImage(
              'graphics/fit_debts.png',
            ),
            color: theme.colorScheme.onSurface),
        bodyBuilder: ({required BuildContext context, required bool nested}) =>
            SchuldSelectiePageViewer(nested: nested));
  }
}

// class SelectieNieuwOfBestaandeSchuld extends ConsumerWidget {
//   final bool nested;

//   SelectieNieuwOfBestaandeSchuld({Key? key, required this.nested})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     SchuldItem? s = ref.watch(schuldProvider);

//     if (s != null && s.id > 0) {
//       return MessageListenerWidget<AcceptCancelBackMessage>(
//           onMessage: (AcceptCancelBackMessage msg) {
//             if (msg.msg == AcceptCancelBack.back) context.pop();
//           },
//           listener: _messageListeners,
//           child: _editPanel(s));
//     } else {
//       return SchuldSelectiePageViewer(
//         nested: nested,
//       );
//     }
//   }
// }

class SchuldSelectiePageViewer extends ConsumerStatefulWidget {
  final bool nested;

  SchuldSelectiePageViewer({Key? key, required this.nested}) : super(key: key);

  @override
  ConsumerState<SchuldSelectiePageViewer> createState() =>
      _DebtPageViewerState();
}

class _DebtPageViewerState extends ConsumerState<SchuldSelectiePageViewer> {
  late PageController _pageController;

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

  selected(SchuldItem item) {
    Schuld? schuld = ref.read(schuldProvider).schuld;
    setState(() {
      switch (item.categorie) {
        case SchuldenCategorie.aflopend_krediet:
          break;
        case SchuldenCategorie.doorlopend_krediet:
          if (schuld != null) {
            schuld.maybeMap<void>(
                doorlopendKrediet: (DoorlopendKrediet value) {},
                orElse: () => nieuwLeaseAuto(item));
          } else {
            nieuwDoorlopendKrediet(item);
          }
          break;
        case SchuldenCategorie.verzendhuiskrediet:
          // TODO: Handle this case.
          break;
        case SchuldenCategorie.operationele_autolease:
          if (schuld != null) {
            schuld.maybeMap<void>(
                leaseAuto: (LeaseAuto value) {},
                orElse: () => nieuwLeaseAuto(item));
          } else {
            nieuwLeaseAuto(item);
          }

          break;
      }
      _pageController.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  void nieuwLeaseAuto(SchuldItem item) {
    ref.read(schuldProvider.notifier).setSchuld(
        schuld: LeaseAuto(
            id: -1,
            categorie: SchuldenCategorie.operationele_autolease,
            omschrijving: 'Lease Auto',
            beginDatum: DateUtils.dateOnly(DateTime.now()),
            statusBerekening: StatusBerekening.nietBerekend,
            error: '',
            jaren: 2,
            maanden: 0,
            mndBedrag: 0.0),
        schuldItem: item);
  }

  void nieuwDoorlopendKrediet(SchuldItem item) {
    final begin = DateUtils.dateOnly(DateTime.now());
    ref.read(schuldProvider.notifier).setSchuld(
        schuld: DoorlopendKrediet(
          id: -1,
          categorie: SchuldenCategorie.doorlopend_krediet,
          omschrijving: 'DK',
          beginDatum: begin,
          statusBerekening: StatusBerekening.nietBerekend,
          error: '',
          eindDatumGebruiker: Kalender.voegPeriodeToe(begin, jaren: 1),
          heeftEindDatum: true,
          bedrag: 0.0,
        ),
        schuldItem: item);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SchuldBewerken bewerken = ref.watch(schuldProvider);

    final list = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            CustomScrollView(slivers: [
              if (widget.nested)
                SliverOverlapInjector(
                  // This is the flip side of the SliverOverlapAbsorber
                  // above.
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                  children: schuldenLijst.map((SchuldItem si) {
                    return SelectedTextButton(
                        value: si,
                        groupValue: bewerken.selectedSchuldItem,
                        onChanged: selected,
                        minWidthText: 300.0,
                        selectedBackbround: theme.primaryColor,
                        selectedTextColor: Colors.white,
                        textColor: theme.colorScheme.onSecondary,
                        text: si.omschrijving);
                  }).toList(),
                ),
              )),
            ]));

    Widget? editPanel =
        bewerken.schuld?.map<Widget>(leaseAuto: (LeaseAuto value) {
      return LeaseAutoPanel(
        messageListener: _messageListeners,
        key: Key('edit_operationalLeaseAuto'),
      );
    }, verzendKrediet: (VerzendKrediet verzend) {
      return Text(':(');
    }, doorlopendKrediet: (DoorlopendKrediet value) {
      return DoorlopendKredietPanel(
        messageListener: _messageListeners,
      );
    }, aflopendKrediet: (AflopendKrediet value) {
      return Text(':(');
    });

    final pageView = PageView(
      controller: _pageController,
      children: [
        list,
        if (editPanel != null)
          AcceptCanelPanel(
              accept: () => _messageListeners.invoke(
                  AcceptCancelBackMessage(msg: AcceptCancelBack.accept)),
              cancel: () => _messageListeners.invoke(
                  AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)),
              child: editPanel)
      ],
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

// Widget _editPanel(SchuldBewerken item) {
//   Widget editPanel = item.schuld?.map<Widget>(leaseAuto: (LeaseAuto value) {
//         return LeaseAutoPanel(
//           messageListener: _messageListeners,
//           key: Key('edit_operationalLeaseAuto'),
//         );
//       }, verzendKrediet: (VerzendKrediet verzend) {
//         return Text(':(');
//       }, doorlopendKrediet: (DoorlopendKrediet value) {
//         return Text(':(');
//       }, aflopendKrediet: (AflopendKrediet value) {
//         return Text(':(');
//       }) ??
//       OhNo(text: 'Schuld is null!');

//   // case RemoveAflopendKrediet:
//   //   {
//   //     editPanel = AflopendKredietPanel(
//   //       messageListener: _messageListeners,
//   //       key: Key('edit'),
//   //       aflopendKrediet: s as RemoveAflopendKrediet,
//   //     );
//   //     break;
//   //   }
//   // case RemoveVerzendhuisKrediet:
//   //   {
//   //     editPanel = VerzendKredietPanel(
//   //       messageListener: _messageListeners,
//   //       key: Key('edit_verzendhuiskrediet'),
//   //       verzendHuisKrediet: s as RemoveVerzendhuisKrediet,
//   //     );
//   //     break;
//   //   }
//   // case RemoveOperationalLeaseAuto:
//   //   {
//   //     editPanel = LeaseAutoPanel(
//   //       messageListener: _messageListeners,
//   //       key: Key('edit_operationalLeaseAuto'),
//   //       operationalLeaseAuto: s as RemoveOperationalLeaseAuto,
//   //     );
//   //     break;
//   //   }

//   // case DoorlopendKrediet:
//   //   {
//   //     editPanel = DoorlopendKredietPanel(
//   //       messageListener: _messageListeners,
//   //       key: Key('edit_operationalLeaseAuto'),
//   //       doorlopendKrediet: s as RemoveDoorlopendKrediet,
//   //     );
//   //     break;
//   //   }
//   // default:
//   //   {
//   //     return Center(child: Text(':{', textScaleFactor: 20.0));
//   //   }
//   // }

//   return AcceptCanelPanel(
//       accept: () => _messageListeners
//           .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.accept)),
//       cancel: () => _messageListeners
//           .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)),
//       child: editPanel);
// }

class SelectedTextButton extends StatefulWidget {
  final SchuldItem value;
  final SchuldItem? groupValue;
  final ValueChanged<SchuldItem> onChanged;
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
      required this.onChanged})
      : super(key: key);

  @override
  State<SelectedTextButton> createState() => _SelectedTextButtonState();

  bool get _selected => value == groupValue;
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
    widget.onChanged(widget.value);
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
