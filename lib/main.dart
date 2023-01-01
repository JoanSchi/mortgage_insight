import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/routes/route_document.dart';
import 'package:mortgage_insight/theme/theme.dart';
import 'package:mortgage_insight/utilities/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'large/large_document.dart';
import 'medium/medium_document.dart';
import 'mobile/mobile_document.dart';
import 'dart:math' as math;

import 'routes/route_main.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppBackground(),
      theme: buildTheme(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('nl', 'NL'),
      ],
    );
  }
}

class AppBackground extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppBackgroundState();
}

class AppBackgroundState extends State<AppBackground> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget body = Router.withConfig(config: routeMain);

      if (constraints.biggest.shortestSide <= 900.0) {
        return body;
      } else {
        final width = constraints.biggest.width;

        double left = 0.0;
        double top = 0.0;
        double right = 0.0;
        double bottom = 0.0;

        if (width > 1200.0) {
          left = math.min((width - 1200) / 2.0, 300.0);
          right = left;
        }

        return Stack(
          children: [
            Positioned(
                left: left, top: top, right: right, bottom: bottom, child: body)
          ],
        );
      }
    });
  }
}

setOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white, //Color(0xFFf1f4fb),
      systemNavigationBarIconBrightness: Brightness.dark));
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Document(formFactorType: DeviceScreen3.of(context).formFactorType);
  }
}

class Document extends ConsumerStatefulWidget {
  final FormFactorType formFactorType;
  const Document({Key? key, required this.formFactorType}) : super(key: key);

  @override
  ConsumerState<Document> createState() => _DocumentState();
}

class _DocumentState extends ConsumerState<Document> {
  @override
  void initState() {
    super.initState();
    setOverlayStyle();

    Future.delayed(Duration(seconds: 30), () async {
      print('delay');
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('test3', 'hihi');
    });
  }

  @override
  void didChangeDependencies() {
    ref.read(routeDocumentProvider).formFactorType = widget.formFactorType;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Document oldWidget) {
    if (widget.formFactorType != oldWidget.formFactorType) {
      ref.read(routeDocumentProvider).formFactorType = widget.formFactorType;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    RouteDocument d = ref.watch(routeDocumentProvider);

    switch (DeviceScreen3.of(context).formFactorType) {
      case FormFactorType.SmallPhone:
      case FormFactorType.LargePhone:
        // body = MobileRoute();
        final router = d.listOfRoutes[AppRoute.mobile];

        body = router == null
            ? Text(':(')
            : Router(
                backButtonDispatcher: ChildBackButtonDispatcher(
                    Router.of(context).backButtonDispatcher!)
                  ..takePriority(),
                routeInformationProvider: router.routeInformationProvider,
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate);
        break;
      case FormFactorType.Tablet:
        body = MediumRoute();
        break;
      case FormFactorType.Monitor:
        body = LargeRoute();
        break;
      case FormFactorType.Unknown:
        {
          throw ('FormFactorType is unknown.');
        }
    }

    return Theme(data: buildFactorTheme(context), child: body);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        ref.read(hypotheekContainerProvider).saveHypotheekContainer();
        break;
      case AppLifecycleState.detached:
        ref.read(hypotheekContainerProvider).saveHypotheekContainer();
        break;
    }
  }
}
