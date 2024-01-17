import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/components/avatar.dart';
import '../../core/components/widgets.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(context),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.only(
        top: 16 + MediaQuery.of(context).padding.top,
        bottom: 16.0,
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return Column(
              children: [
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () async {
                    showMyImagePicker().then((value) {
                      if (value != null) {
                        context.read<AuthBloc>().add(UpdateAvatar(imageFile: value));
                      }
                    });
                  },
                  child: Avatar.photoURL(
                    photoURL: state.user?.photoURL,
                    placeholder: state.user!.email!,
                    radius: 48.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                ListTile(
                  title: Text(
                    state.user!.displayName ?? state.user!.email!.split('@')[0],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  subtitle: Text(
                    'Tap to edit',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                  onTap: () {
                    showDialogForEditName(
                      context,
                      state.user!.displayName ?? state.user!.email!.split('@')[0],
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                Text(
                  state.user!.email!,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/authentication');
                  },
                  child: const Text('Sign In'),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        runSpacing: 8.0,
        children: [
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.go('/settings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              context.go('/about');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const AboutScreen(),
              //   ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
// Widget getRandomAvatar() {
//   final randomImage = Random().nextInt(3) + 1;
//   return CircleAvatar(
//     radius: 52.0,
//     backgroundImage: AssetImage(
//       'assets/images/avatars/avatar-$randomImage.png',
//     ),
//   );
// }