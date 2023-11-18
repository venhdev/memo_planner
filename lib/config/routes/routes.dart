import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/screens.dart';
import '../../features/goal/presentation/screens/goal_page.dart';
import '../../features/habit/presentation/screens/screens.dart';
import '../../features/habit/presentation/widgets/habit_form.dart';

part 'app_scaffold_navigation_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouters {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE only set to true if you need to debug
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/habit',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the widget that implements the custom shell (in this case
          // using a BottomNavigationBar). The StatefulNavigationShell is passed
          // to be able access the state of the shell and to navigate to other
          // branches in a stateful way.
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          // The route branch for the first tab of the bottom navigation bar.
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: <RouteBase>[
              habitRoutes(),
              GoRoute(
                path: '/',
                redirect: (context, state) => '/habit',
              ),
            ],
          ),
          // The route branch for the second tab
          StatefulShellBranch(
            routes: <RouteBase>[
              goalRoutes(),
            ],
          ),
          // The route branch for the third tab
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
        builder: (context, state) => const EditHabitScreen(type: EditType.addHabit),
        // builder: (context, state) => const AddHabitScreen(),
      ),
      GoRoute(
          path: 'detail/:hid',
          builder: (context, state) {
            final hid = state.pathParameters['hid']!;
            return HabitDetailScreen(hid: hid);
          }),
      GoRoute(
          path: 'edit-habit/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            // return EditHabitScreen(hid: id);
            return EditHabitScreen(id: id, type: EditType.editHabit);
          }),
      GoRoute(
          path: 'edit-instance/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            // return EditHabitInstanceScreen(iid: id);
            return EditHabitScreen(id: id, type: EditType.editInstance);
          }),
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

// https://pub.dev/documentation/go_router/latest/go_router/StatefulShellRoute-class.html