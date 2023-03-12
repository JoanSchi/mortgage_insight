import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/model/nl/hypotheek_document/provider/hypotheek_document_provider.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import '../../model/nl/schulden/schulden.dart';
import '../../platform_page_format/default_page.dart';
import '../../platform_page_format/page_properties.dart';
import '../../utilities/device_info.dart';
import '../../utilities/message_listeners.dart';
import 'aflopend_krediet/aflopend_krediet_panel.dart';
import 'doorlopend_krediet.dart/doorlopend_krediet.dart';
import 'lease_auto/lease_auto.dart';
import 'schuld_provider.dart';
import 'verzend_krediet/verzend_krediet.dart';

class SchuldAanpassenPanel extends ConsumerStatefulWidget {
  const SchuldAanpassenPanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SchuldAanpassenPanel> createState() => _SchuldKeuzePanelState();
}

class _SchuldKeuzePanelState extends ConsumerState<SchuldAanpassenPanel> {
  final _messageListeners = MessageListener<AcceptCancelBackMessage>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultPage(
        matchPageProperties: const [
          MatchPageProperties(
              types: {FormFactorType.unknown}, pageProperties: PageProperties())
        ],
        title: 'Aanpassen',
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

    Widget child = bewerken.schuld?.map<Widget>(leaseAuto: (LeaseAuto value) {
          return LeaseAutoPanel(
            key: const Key('edit_operationalLeaseAuto'),
            topPadding: topPadding,
            bottomPadding: bottomPadding,
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
        }) ??
        OhNo(text: 'Schuld not found.');

    return MessageListenerWidget<AcceptCancelBackMessage>(
        onMessage: message,
        listener: _messageListeners,
        child: AcceptCanelPanel(
            accept: () => _messageListeners
                .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.accept)),
            cancel: () => _messageListeners
                .invoke(AcceptCancelBackMessage(msg: AcceptCancelBack.cancel)),
            child: Form(key: _formKey, child: child)));
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
        //didpop sets editState of routeEditPageProvider.notifier to null;
        context.pop();
        break;
      default:
        break;
    }

    if (msg.msg == AcceptCancelBack.back) {
      context.pop();
    }
  }
}
