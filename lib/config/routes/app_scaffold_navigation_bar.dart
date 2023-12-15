part of 'routes.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // handle authentication
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          showMyAlertDialogMessage(
            context: context,
            message: state.message ?? 'Hi ${state.user!.displayName}',
            icon: const Icon(Icons.check),
          );
          
          //? because when user sign out, maybe not in the habit screen
          context.go('/habit');
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          showMyAlertDialogMessage(
            context: context,
            message: state.message!,
            icon: const Icon(Icons.error),
          );
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Habit'),
                BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Task'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'User'),
              ],
              currentIndex: navigationShell.currentIndex,
              onTap: (int index) => _onTap(context, index),
            ),
          );
        } else {
          return const SignInScreen();
        }
      },
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
