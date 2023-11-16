import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/bloc/bloc/authentication_bloc.dart';

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
      color: Colors.blue.shade500,
      padding: EdgeInsets.only(
        top: 16 + MediaQuery.of(context).padding.top,
        bottom: 16.0,
      ),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return Column(
              children: [
                const SizedBox(height: 24.0),
                Builder(builder: (context) {
                  if (state.user!.photoURL != null) {
                    return CircleAvatar(
                      radius: 52.0,
                      backgroundColor: Colors.green.shade100,
                      backgroundImage: NetworkImage(state.user!.photoURL!),
                    );
                  } else {
                    // random image <assets/images/avatars> in case of no image --> no use for now
                    // use the first letter of email instead
                    return CircleAvatar(
                      radius: 52.0,
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        state.user!.email!.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 52.0,
                          color: Colors.white,
                        ),
                      ),
                    );
                    // return getRandomAvatar();
                  }
                }),
                const SizedBox(height: 12.0),
                Text(
                  state.user!.displayName ?? state.user!.email!.split('@')[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  state.user!.email!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
                // logout button
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red.shade500,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      SignOutEvent(),
                    );
                  },
                  child: const Text('Logout'),
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
            leading: const Icon(Icons.calendar_month),
            title: const Text('Habit'),
            onTap: () {
              Navigator.pop(context);
              context.go('/habit');
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Settings'),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User'),
            onTap: () {
              Navigator.pop(context);
              context.go('/authentication');
            },
          ),
        ],
      ),
    );
  }

  Widget getRandomAvatar() {
    final randomImage = Random().nextInt(3) + 1;
    return CircleAvatar(
      radius: 52.0,
      backgroundImage: AssetImage(
        'assets/images/avatars/avatar-$randomImage.png',
      ),
    );
  }
}
