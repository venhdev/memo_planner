part of 'routes.dart';

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    // required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  // final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          if (state.message != null) Fluttertoast.showToast(msg: state.message!);
            // showMyAlertDialogMessage(
            //   context: context,
            //   message: state.message!,
            //   icon: const Icon(Icons.check),
            // );

          // call initial event on each branch to load data according to user
          // context.read<HabitBloc>().add(HabitInitial());
          context.read<TaskBloc>().add(const TaskInitial());

          //? because when user sign out, maybe in user branch
          // context.go('/task-list');
        } else if (state.status == AuthenticationStatus.unauthenticated) {
          Fluttertoast.showToast(msg: state.message!);
          // showMyAlertDialogMessage(
          //   context: context,
          //   message: state.message!,
          //   icon: const Icon(Icons.error),
          // );
        }
      },
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated) {
          return const Scaffold(
            drawer: AppNavigationDrawer(),
            body: TaskHomeScreen(),
            // body: navigationShell,
            // bottomNavigationBar: BottomNavigationBar(
            //   items: const <BottomNavigationBarItem>[
            //     // BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'Habit'),
            //     BottomNavigationBarItem(icon: Icon(Icons.task_alt_outlined), label: 'TASK'),
            //     BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined), label: 'ME'),
            //   ],
            //   // currentIndex: navigationShell.currentIndex,
            //   // onTap: (int index) => _onTap(context, index),
            // ),
          );
        } else {
          return const SignInScreen();
        }
      },
    );
  }

  // void _onTap(BuildContext context, int index) {
  //   navigationShell.goBranch(
  //     index,
  //     initialLocation: index == navigationShell.currentIndex,
  //   );
  // }
}
