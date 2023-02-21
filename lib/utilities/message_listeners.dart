import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum AcceptCancelBack { accept, cancel, back }

abstract class Message {}

class AcceptCancelBackMessage extends Message {
  final AcceptCancelBack msg;

  AcceptCancelBackMessage({
    this.msg: AcceptCancelBack.accept,
  });
}

typedef MessageListenerCallback<T extends Message> = void Function(T action);

class MessageListenerWidget<T extends Message> extends StatefulWidget {
  const MessageListenerWidget({
    Key? key,
    required this.onMessage,
    required this.listener,
    required this.child,
  }) : super(key: key);

  final MessageListener<T> listener;
  final MessageListenerCallback<T> onMessage;
  final Widget child;

  @override
  State<MessageListenerWidget<T>> createState() =>
      _MessageListenerWidgetState<T>();
}

class _MessageListenerWidgetState<T extends Message>
    extends State<MessageListenerWidget<T>> {
  @override
  void initState() {
    super.initState();
    widget.listener.addActionListener(widget.onMessage);
  }

  @override
  void didUpdateWidget(MessageListenerWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listener == widget.listener &&
        oldWidget.onMessage == widget.onMessage) {
      return;
    }
    oldWidget.listener.removeActionListener(oldWidget.onMessage);
    widget.listener.addActionListener(widget.onMessage);
  }

  @override
  void dispose() {
    widget.listener.removeActionListener(widget.onMessage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class MessageListener<T extends Message> with Diagnosticable {
  /// Creates an [Action].
  MessageListener();

  final ObserverList<MessageListenerCallback<T>> _listeners =
      ObserverList<MessageListenerCallback<T>>();

  void addActionListener(MessageListenerCallback<T> listener) =>
      _listeners.add(listener);

  void removeActionListener(MessageListenerCallback<T> listener) =>
      _listeners.remove(listener);

  void invoke(T message) {
    if (_listeners.isEmpty) {
      return;
    }

    // Make a local copy so that a listener can unregister while the list is
    // being iterated over.
    final List<MessageListenerCallback<T>> localListeners =
        List<MessageListenerCallback<T>>.from(_listeners);
    for (final MessageListenerCallback<T> listener in localListeners) {
      InformationCollector? collector;
      assert(() {
        collector = () sync* {
          yield DiagnosticsProperty<MessageListener<T>>(
            'The $runtimeType sending notification was',
            this,
            style: DiagnosticsTreeStyle.errorProperty,
          );
        };
        return true;
      }());
      try {
        if (_listeners.contains(listener)) {
          listener(message);
        }
      } catch (exception, stack) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: exception,
          stack: stack,
          library: 'widgets library',
          context: ErrorDescription(
              'while dispatching notifications for $runtimeType'),
          informationCollector: collector,
        ));
      }
    }
  }
}
