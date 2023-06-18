import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/routes/routes.dart';
import 'package:mortgage_insight/theme/theme.dart';

void main() {
  setOverlayStyle();
  runApp(const ProviderScope(child: SizeDependentRoute()));
}

class SizeDependentRoute extends StatefulWidget {
  const SizeDependentRoute({Key? key}) : super(key: key);

  @override
  State<SizeDependentRoute> createState() => _SizeDependentRouteState();
}

class _SizeDependentRouteState extends State<SizeDependentRoute> {
  final BeamerDelegate _beamerDelegate = BeamerDelegate(
      initialPath: '/document',
      locationBuilder:
          (RouteInformation routeInformation, BeamParameters? beamParameters) {
        return DocumentLocation(routeInformation);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _beamerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher:
          BeamerBackButtonDispatcher(delegate: _beamerDelegate),
      theme: buildTheme(context),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('nl', 'NL'),
      ],
    );
  }
}

setOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white, //Color(0xFFf1f4fb),
      systemNavigationBarIconBrightness: Brightness.dark));
}
