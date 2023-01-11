import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/template_mortgage_items/AcceptCancelActions.dart';
import '../../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../model/nl/schulden/schulden_aflopend_krediet.dart';
import 'aflopend_krediet_model.dart';
import 'aflopend_krediet_segmenten.dart';
import 'aflopend_krediet_overview.dart';
import 'aflopend_krediet_table.dart';

class AflopendKredietPanel extends ConsumerStatefulWidget {
  final AflopendKrediet aflopendKrediet;
  final MessageListener<AcceptCancelBackMessage> messageListener;

  AflopendKredietPanel(
      {Key? key, required this.aflopendKrediet, required this.messageListener})
      : super(key: key);

  @override
  ConsumerState<AflopendKredietPanel> createState() =>
      _AflopendKredietPanelState();
}

class _AflopendKredietPanelState extends ConsumerState<AflopendKredietPanel> {
  final _formKey = GlobalKey<FormState>();
  late AflopendKredietModel aflopendKredietModel;

  @override
  void didChangeDependencies() {
    aflopendKredietModel = AflopendKredietModel(ak: widget.aflopendKrediet);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AflopendKredietPanel oldWidget) {
    if (aflopendKredietModel.ak != widget.aflopendKrediet) {
      aflopendKredietModel = AflopendKredietModel(ak: widget.aflopendKrediet);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    ScrollController? controller = PrimaryScrollController.of(context);

    final scrollView = CustomScrollView(
      // controller: controller,
      slivers: [
        AflopendKredietForm(
          formKey: _formKey,
          aflopendKredietModel: aflopendKredietModel,
        ),
        OverzichtLening(aflopendKredietModel: aflopendKredietModel),
        DebtTable(
            controller: controller, aflopendKredietModel: aflopendKredietModel),
        AflopendKredietErrorWidget(aflopendKredietModel: aflopendKredietModel),
        SliverToBoxAdapter(
            child: SizedBox(
          height: 16.0,
        ))
      ],
    );

    return MessageListenerWidget<AcceptCancelBackMessage>(
        listener: widget.messageListener,
        onMessage: (AcceptCancelBackMessage message) {
          switch (message.msg) {
            case AcceptCancelBack.accept:
              FocusScope.of(context).unfocus();

              scheduleMicrotask(() {
                if ((_formKey.currentState?.validate() ?? false) &&
                    widget.aflopendKrediet.berekend == Calculated.yes) {
                  ref
                      .read(hypotheekContainerProvider.notifier)
                      .addSchuld(widget.aflopendKrediet);

                  scheduleMicrotask(() {
                    context.pop();
                  });
                }
              });

              break;
            case AcceptCancelBack.cancel:
              // TODO: Fix
              // ref.read(routeEditPageProvider.notifier).clear();
              //import 'package:go_router/go_router.dart';
              context.pop();
              break;
            default:
              break;
          }
        },
        child: scrollView);
  }
}

class AflopendKredietForm extends StatelessWidget {
  final AflopendKredietModel aflopendKredietModel;

  final GlobalKey<FormState> formKey;
  const AflopendKredietForm(
      {Key? key, required this.aflopendKredietModel, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SliverList(
          delegate: SliverChildListDelegate.fixed(
        [
          AflopendKredietOptiePanel(aflopendKredietModel),
          Divider(),
          AflopendkredietInvulPanel(aflopendKredietModel),
        ],
      )),
    );
  }
}
