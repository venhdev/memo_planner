import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/widgets.dart';
import '../../features/authentication/presentation/screens/screens.dart';
import '../../features/goal/presentation/screens/goal_page.dart';
import '../../features/habit/presentation/screens/screens.dart';

part 'app_navigation_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouters {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE only set to true if you need to debug
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/habit',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: <RouteBase>[
              habitRoutes(),
            ],
          ),
          StatefulShellBranch(
            routes: [
              goalRoutes(),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              authenticationRoutes(),
            ],
          ),
        ],
      )
    ],
  );
}

GoRoute habitRoutes() {
  return GoRoute(
    path: '/habit',
    builder: (context, state) => const HabitPage(),
    routes: [
      GoRoute(
        path: 'add',
        builder: (context, state) => const AddHabitScreen(),
      ),
    ],
  );
}

GoRoute goalRoutes() {
  return GoRoute(
    path: '/goal',
    builder: (context, state) => const GoalPage(),
  );
}

GoRoute authenticationRoutes() {
  return GoRoute(
    path: '/authentication',
    builder: (context, state) => const AuthenticationPage(),
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
  );
}
