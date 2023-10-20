import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import '../../features/authentication/presentation/bloc/bloc/authentication_bloc.dart';
import '../../features/authentication/presentation/pages/user_page.dart';

part 'app_routes.dart';
part 'authentication_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouters {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true, // NOTE only set to true if you need to debug
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
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
                path: '/home',
                builder: (context, state) => Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              final result =
                                  context.read<AuthenticationBloc>().state;
                              debugPrint(
                                  '===================> state.user: ${result.user}');
                              debugPrint(
                                  '===================> state.status: ${result.status}');
                              debugPrint(
                                  '===================> state.message: ${result.message}');
                              debugPrint(
                                  '===================> state.runtimeType: ${result.runtimeType}');
                              // notify to user using scaffold snackbar

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'User: ${result.user?.email ?? 'null'}',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Test AuthenticationBloc')),
                        const Text('Home'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          StatefulShellBranch(
            routes: [
              authenticationRoute,
            ],
          ),
        ],
      )
    ],
  );
}
