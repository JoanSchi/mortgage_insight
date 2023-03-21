import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_document/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/pages/schulden/aflopend_krediet/aflopend_krediet_panel.dart';

import 'package:mortgage_insight/pages/schulden/doorlopend_krediet.dart/doorlopend_krediet.dart';
import 'package:mortgage_insight/pages/schulden/lease_auto/lease_auto.dart';

import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import 'package:mortgage_insight/pages/schulden/verzend_krediet/verzend_krediet.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import '../../model/nl/schulden/schulden.dart';
import '../../platform_page_format/default_page.dart';
import '../../platform_page_format/page_properties.dart';
import '../../utilities/message_listeners.dart';

import 'package:go_router/go_router.dart';

class SchuldKeuzePanel extends ConsumerStatefulWidget {
  const SchuldKeuzePanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SchuldKeuzePanel> createState() => _SchuldKeuzePanelState();
}

class _SchuldKeuzePanelState extends ConsumerState<SchuldKeuzePanel> {
  final _messageListeners = MessageListener<AcceptCancelBackMessage>();
  late PageController _pageController;
  final _formKey = GlobalKey<FormState>();

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

  void selected(SchuldItem item) {
    ref.read(schuldProvider.notifier).selectSchuld(item);

    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

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
              types: {FormFactorType.unknown},
              pageProperties: PageProperties(leftTopActions: [back]))
        ],
        title: 'Toevoegen',
        imageBuilder: (_) => Image(
            image: const AssetImage(
              'graphics/schuld.png',
            ),
            color: theme.colorScheme.onSurface),
        bodyBuilder: (
                {required BuildContext context,
                required bool nested,
                required double topPadding,
                required double bottomPadding}) =>
            _build(context, theme, nested, topPadding, bottomPadding));
  }

  Widget _build(BuildContext context, ThemeData theme, bool nested,
      double topPadding, double bottomPadding) {
    SchuldBewerken bewerken = ref.watch(schuldProvider);

    final list = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            CustomScrollView(slivers: [
              if (nested)
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
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        key: const Key('edit_operationalLeaseAuto'),
      );
    }, verzendKrediet: (VerzendKrediet verzend) {
      return VerzendKredietPanel(
        topPadding: topPadding,
        bottomPadding: bottomPadding,
      );
    }, doorlopendKrediet: (DoorlopendKrediet value) {
      return DoorlopendKredietPanel(
        topPadding: topPadding,
        bottomPadding: bottomPadding,
      );
    }, aflopendKrediet: (AflopendKrediet value) {
      return AflopendKredietPanel(
        topPadding: topPadding,
        bottomPadding: bottomPadding,
      );
    });

    final pageView = MediaQuery(
      data: MediaQuery.of(context).copyWith(
          gestureSettings: const DeviceGestureSettings(touchSlop: kTouchSlop)),
      child: PageView(
        controller: _pageController,
        children: [
          list,
          if (editPanel != null)
            AcceptCanelPanel(
                accept: () => _messageListeners.invoke(
                    AcceptCancelBackMessage(msg: AcceptCancelBack.accept)),
                cancel: () => _messageListeners.invoke(
                    AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)),
                child: Form(key: _formKey, child: editPanel))
        ],
      ),
    );

    return MessageListenerWidget<AcceptCancelBackMessage>(
        onMessage: message, listener: _messageListeners, child: pageView);
  }

  void message(AcceptCancelBackMessage msg) {
    switch (msg.msg) {
      case AcceptCancelBack.accept:
        FocusScope.of(context).unfocus();

        scheduleMicrotask(() {
          if ((_formKey.currentState?.validate() ?? false)) {
            final schuld = ref.read(schuldProvider).schuld;
            if (schuld != null) {
              ref
                  .read(hypotheekDocumentProvider.notifier)
                  .schuldToevoegen(schuld);
            }

            scheduleMicrotask(() {
              context.pop();
            });
          }
        });

        break;
      case AcceptCancelBack.cancel:
        if (_pageController.page == 1) {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        } else {
          context.pop();
        }
        break;
      default:
        break;
    }

    if (msg.msg == AcceptCancelBack.back) {
      context.pop();
    }
  }
}

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

  const SelectedTextButton(
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
          onTap: handlePress,
          child: SizedBox(
              width: 300,
              height: 56,
              child: Center(
                  child: Text(
                widget.text,
                style: themeData.textTheme.bodyMedium?.copyWith(
                    fontSize: 18.0,
                    color: widget._selected
                        ? Colors.white
                        : themeData.colorScheme.onSurface),
              ))),
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
    this.radial = 32.0,
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

      Paint paint = Paint()
        ..color = color!
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
          RRect.fromLTRBR(left, top, right, bottom, Radius.circular(radial)),
          paint);
    }
  }

  @override
  bool shouldRepaint(BackgroundSelectedTextButton oldDelegate) {
    return color != oldDelegate.color || value != oldDelegate.value;
  }
}
