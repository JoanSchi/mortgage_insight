import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import '../mobile/mobile_start.dart';

final routeMain = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/document',
      builder: (context, state) => const MyWidget(),
    ),
  ],
);
