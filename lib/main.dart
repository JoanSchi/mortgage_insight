import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/state_manager/routes/routes_app.dart';
import 'package:mortgage_insight/theme/theme.dart';
import 'dart:math' as math;

import 'package:mortgage_insight/utilities/device_info.dart';

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

class AppBackground extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppBackgroundState();
}

class AppBackgroundState extends ConsumerState<AppBackground> {
  GoRouter? route;

  @override
  void didChangeDependencies() {
    setOverlayStyle();
    updateFormFactorType();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AppBackground oldWidget) {
    updateFormFactorType();
    super.didUpdateWidget(oldWidget);
  }

  void updateFormFactorType() {
    ref
        .read(routeDocumentProvider.notifier)
        .setFormFactorType(DeviceScreen3.of(context).formFactorType);
    route = ref.read(routeDocumentProvider).routes[AppRoutes.main];
  }

  @override
  Widget build(BuildContext context) {
    if (route == null) {
      return OhNo(
        text: 'Main route not found',
      );
    }

    debugPrint('MediaQuery Size: ${MediaQuery.of(context).size}');
    debugPrint('main route location: ${route?.location}');

    return Router.withConfig(config: route!);

    //   if (constraints.biggest.shortestSide <= 900.0) {
    //     return body;
    //   } else {
    //     final width = constraints.biggest.width;

    //     double left = 0.0;
    //     double top = 0.0;
    //     double right = 0.0;
    //     double bottom = 0.0;

    //     if (width > 1200.0) {
    //       left = math.min((width - 1200) / 2.0, 300.0);
    //       right = left;
    //     }

    //     return Stack(
    //       children: [
    //         Positioned(
    //             left: left, top: top, right: right, bottom: bottom, child: body)
    //       ],
    //     );
    //   }
    // });
  }
}

setOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white, //Color(0xFFf1f4fb),
      systemNavigationBarIconBrightness: Brightness.dark));
}
