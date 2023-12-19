import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/components/widgets.dart';
import '../../core/constants/enum.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../features/authentication/presentation/screens/screens.dart';
import '../../features/habit/domain/entities/habit_entity.dart';
import '../../features/habit/presentation/bloc/habit/habit_bloc.dart';
import '../../features/habit/presentation/screens/screens.dart';
import '../../features/task/presentation/bloc/task_bloc.dart';
import '../../features/task/presentation/screens/screens.dart';

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
              // goalRoutes(),
              taskRoute(),
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
    builder: (context, state) => const HabitScreen(),
    routes: [
      GoRoute(
        path: 'add',
        builder: (context, state) => const EditHabitScreen(type: EditType.add),
        // builder: (context, state) => const AddHabitScreen(),
      ),
      GoRoute(
          path: 'detail',
          builder: (context, state) {
            final habit = GoRouterState.of(context).extra! as HabitEntity;
            return HabitDetailScreenV2(habit: habit);
          }),
      // GoRoute(
      //     path: 'detail/:hid',
      //     builder: (context, state) {
      //       final hid = state.pathParameters['hid']!;
      //       return HabitDetailScreen(hid: hid);
      //     }),
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

// GoRoute goalRoutes() {
//   return GoRoute(
//     path: '/goal',
//     builder: (context, state) => const GoalScreen(),
//     routes: [
//       // task routes
//       GoRoute(
//         path: 'task',
//         builder: (context, state) => const GoalScreen(),
//         routes: [
//           GoRoute(
//             path: 'add',
//             builder: (context, state) {
//               return const TaskEditScreen(type: EditType.add);
//             },
//           ),
//           GoRoute(
//             path: 'edit/:id',
//             builder: (context, state) {
//               final taskId = state.pathParameters['id']!;
//               return TaskEditScreen(id: taskId, type: EditType.edit);
//             },
//           ),
//           GoRoute(
//             path: 'detail',
//             builder: (context, state) {
//               final task = GoRouterState.of(context).extra! as TaskEntity;
//               return TaskDetailScreen(task: task);
//             },
//           ),
//         ],
//       ),
//       // target routes
//       GoRoute(
//         path: 'target',
//         builder: (context, state) => const GoalScreen(initialIndex: 1),
//       ),
//     ],
//   );
// }
GoRoute taskRoute() {
  return GoRoute(
    path: '/task-list',
    builder: (context, state) => const TaskHomeScreen(),
    routes: [
      GoRoute(
        path: 'single-list/:lid',
        builder: (context, state) {
          final String lid = state.pathParameters['lid']!;
          return SingleTaskListScreen(lid);
        },
      ),
      GoRoute(
        path: 'multi-list',
        builder: (context, state) {
          final GroupType type = GoRouterState.of(context).extra! as GroupType;

          return MultiTaskListScreen(type: type);
        },
      ),
    ],
  );
}

GoRoute authenticationRoutes() {
  return GoRoute(
    path: '/authentication',
    builder: (context, state) => const AuthenticationScreen(),
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