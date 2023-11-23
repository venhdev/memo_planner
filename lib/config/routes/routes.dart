import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/features/goal/domain/entities/task_entity.dart';

import '../../core/constants/enum.dart';
import '../../features/authentication/presentation/screens/screens.dart';
import '../../features/goal/presentation/screens/goal_page.dart';
import '../../features/goal/presentation/screens/target_screen/target_screen.dart';
import '../../features/goal/presentation/screens/task_screen/task_screen.dart';
import '../../features/habit/presentation/screens/screens.dart';

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
        builder: (context, state) => const EditHabitScreen(type: EditType.add),
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
            return EditHabitScreen(id: id, type: EditType.edit);
          }),
      GoRoute(
          path: 'edit-instance/:id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EditHabitScreen(id: id, type: EditType.editInstance);
          }),
    ],
  );
}

GoRoute goalRoutes() {
  return GoRoute(
    path: '/goal',
    builder: (context, state) => const GoalPage(),
    routes: [
      // task routes
      GoRoute(
        path: 'task',
        builder: (context, state) => const GoalPage(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) {
              return const TaskEditScreen(type: EditType.add);
            },
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) {
              final taskId = state.pathParameters['id']!;
              return TaskEditScreen(id: taskId, type: EditType.edit);
            },
          ),
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final task = GoRouterState.of(context).extra! as TaskEntity;
              return TaskDetailScreen(task: task);
            },
          ),
        ],
      ),
      // target routes
      GoRoute(
        path: 'target',
        builder: (context, state) => const GoalPage(initialIndex: 1),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const TargetEditScreen(),
          ),
        ],
      ),
    ],
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