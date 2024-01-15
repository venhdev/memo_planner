import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/components/avatar.dart';
import '../../core/components/widgets.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../../features/authentication/presentation/screens/about_screen.dart';

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
      color: Colors.green.shade500,
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
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  subtitle: const Text(
                    'Tap to edit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                  onTap: () {
                    // show dialog to edit name
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
          // ListTile(
          //   leading: const Icon(Icons.checklist),
          //   title: const Text('Habit'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     context.go('/habit');
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.task_alt),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),

          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.add),
          //   title: const Text('Add New Habit'),
          //   onTap: () {
          //     Navigator.pop(context);
          //     context.go('/habit/add');
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutScreen(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.add),
          //   title: const Text('Send test notification'),
          //   onTap: () async {
          //     final fcm = di<FirebaseCloudMessagingManager>();

          //     await fcm.sendDataMessage(
          //       token: fcm.currentFCMToken!,
          //       data: {
          //         'test': 'test',
          //       },
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.add),
          //   title: const Text('Test Retrieve tokens'),
          //   onTap: () async {
          //     final repo = di<TaskListRepository>();

          //     final tokensEither = await repo.getAllMemberTokens('4GmGZenVHC6QVdALcHac');
          //     tokensEither.fold(
          //       (l) => log('getAllMemberTokens Fail: ${l.message}'),
          //       (tokens) {
          //         log('getAllMemberTokens Success: ${tokens.toString()}\n');
          //         log('getAllMemberTokens length: ${tokens.length}');
          //       },
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.cast),
          //   title: const Text('(dev) show pending & activate notification'),
          //   onTap: () async {
          //     final pending = await di<LocalNotificationManager>().I.pendingNotificationRequests();
          //     final activate = await di<LocalNotificationManager>().I.getActiveNotifications();

          //     // ignore: use_build_context_synchronously
          //     await showDialog(
          //       context: context,
          //       builder: (_) {
          //         return SimpleDialog(
          //           children: [
          //             Text('pending: ${pending.length}'),
          //             for (int i = 0; i < pending.length; i++)
          //               Text(
          //                 '${pending[i].id} - ${pending[i].title} - ${pending[i].body}',
          //                 maxLines: 2,
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //             Text('activate: ${activate.length}'),
          //             for (int i = 0; i < activate.length; i++)
          //               Text(
          //                 '${activate[i].id} - ${activate[i].title} - ${activate[i].body}',
          //                 maxLines: 2,
          //                 overflow: TextOverflow.ellipsis,
          //               ),
          //           ],
          //         );
          //       },
          //     );
          //     // for (var item in pending) {
          //     //   log('pending notification: ${item.id} - ${item.title} - ${item.body}');
          //     // }
          //     // for (var item in activate) {
          //     //   log('activate notification: ${item.id} - ${item.title} - ${item.body}');
          //     // }
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.cast),
          //   title: const Text('remove all notification'),
          //   onTap: () async {
          //     await di<LocalNotificationManager>().I.cancelAll().then((value) => log('remove all notification'));
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.cast),
          //   title: const Text('show notification'),
          //   onTap: () async {
          //     await di<LocalNotificationManager>()
          //         .showNotification(id: 1, title: 'Time to run 2', body: 'body', payload: 'payload');
          //   },
          // ),
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
