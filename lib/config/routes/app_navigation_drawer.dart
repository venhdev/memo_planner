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
            _buildMenuItems(),
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
                CircleAvatar(
                  radius: 52,
                  backgroundImage: NetworkImage(
                    state.user!.photoURL!,
                  )
                ),
                const SizedBox(height: 12.0),
                Text(
                  state.user!.displayName!,
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
                  child: const Text('Sign Out'),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/authentication/sign-in');
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

  Widget _buildMenuItems() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        runSpacing: 8.0,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('User'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
