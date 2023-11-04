import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/authentication_view.dart';
import '../../features/authentication/presentation/screens/sign_in_screen.dart';
import '../../features/authentication/presentation/screens/sign_up_screen.dart';
import '../../features/habit/presentation/screens/habit_page.dart';
import 'app_navigation_drawer.dart';

part 'app_navigation_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouters {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE only set to true if you need to debug
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: '/',
                builder: (context, state) => HabitPage(),
              )
            ],
          ),
          // StatefulShellBranch(
          //   routes: [
          //     authenticationRoute2,
          //   ],
          // ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/authentication',
                builder: (context, state) => const AuthenticationView(),
                routes: [
                  GoRoute(
                    path: 'sign-in',
                    builder: (context, state) => const SignInScreen(),
                  ),
                  GoRoute(
                    path: 'sign-up',
                    builder: (context, state) => const SignUpScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    ],
  );
}
