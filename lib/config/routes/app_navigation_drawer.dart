import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_planner/core/components/widgets.dart';

import '../../core/notification/local_notification_manager.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../dependency_injection.dart';

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
                    showMyDialogConfirmSignOut(context);
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
            leading: const Icon(Icons.checklist),
            title: const Text('Habit'),
            onTap: () {
              Navigator.pop(context);
              context.go('/habit');
            },
          ),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Task'),
            onTap: () {
              Navigator.pop(context);
              context.go('/task-group');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add New Habit'),
            onTap: () {
              Navigator.pop(context);
              context.go('/habit/add');
            },
          ),
          // ~test bloc
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cast),
            title: const Text('log pending & activate notification'),
            onTap: () async {
              final pending = await di<LocalNotificationManager>().I.pendingNotificationRequests();
              final activate = await di<LocalNotificationManager>().I.getActiveNotifications();

              for (var item in pending) {
                log('pending notification: ${item.id} - ${item.title} - ${item.body}');
              }
              for (var item in activate) {
                log('activate notification: ${item.id} - ${item.title} - ${item.body}');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.cast),
            title: const Text('remove all notification'),
            onTap: () async {
              await di<LocalNotificationManager>().I.cancelAll().then((value) => log('remove all notification'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.cast),
            title: const Text('show notification'),
            onTap: () async {
              await di<LocalNotificationManager>().showNotification(id: 1, title: 'Time to run 2', body: 'body', payload: 'payload');
            },
          ),
        ],
      ),
    );
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
}
