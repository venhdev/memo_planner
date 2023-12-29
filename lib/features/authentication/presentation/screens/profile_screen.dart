import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/widgets.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../core/notification/local_notification_manager.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/authentication/authentication_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.user,
  });

  final UserEntity user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            label: const Text('Sign Out'),
            onPressed: () {
              // show dialog to confirm sign out
              showMyDialogConfirmSignOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24, left: 24, right: 24),
          child: Column(
            children: [
              // IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: widget.user.photoURL != null
                          ? Image.network(
                              widget.user.photoURL!,
                              fit: BoxFit.cover,
                            )
                          : CircleAvatar(
                              radius: 52.0,
                              backgroundColor: Colors.green.shade100,
                              child: Text(
                                widget.user.email!.substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 52.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 35,
                  //     height: 35,
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
                  //     child: const Icon(
                  //       Icons.edit,
                  //       color: Colors.black,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8.0),
              ListTile(
                title: Text(
                  widget.user.displayName ?? widget.user.email!.split('@')[0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Tap to edit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  // show dialog to edit name
                  showMyDialogEditName(context, widget.user.displayName ?? widget.user.email!.split('@')[0]);
                },
              ),

              const SizedBox(height: 18.0),

              // Email
              GestureDetector(
                onLongPress: () async {
                  final pending = await di<LocalNotificationManager>().I.pendingNotificationRequests();
                  final activate = await di<LocalNotificationManager>().I.getActiveNotifications();

                  // ignore: use_build_context_synchronously
                  await showDialog(
                    context: context,
                    builder: (_) {
                      return SimpleDialog(
                        children: [
                          Text('pending: ${pending.length}'),
                          for (int i = 0; i < pending.length; i++)
                            Text(
                              '${pending[i].id} - ${pending[i].title} - ${pending[i].body}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text('activate: ${activate.length}'),
                          for (int i = 0; i < activate.length; i++)
                            Text(
                              '${activate[i].id} - ${activate[i].title} - ${activate[i].body}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  widget.user.email!,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),

              // -- BUTTON EDIT
              // SizedBox(
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () => {},
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.primaries[0],
              //         side: BorderSide.none,
              //         shape: const StadiumBorder()),
              //     child:
              //         const Text('Edit', style: TextStyle(color: Colors.black)),
              //   ),
              // ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              // ProfileMenuWidget(
              //     title: 'Settings', icon: Icons.settings, onPress: () {}),
              // ProfileMenuWidget(
              //     title: 'Billing Details', icon: Icons.wallet, onPress: () {}),
              // ProfileMenuWidget(
              //     title: 'User Management',
              //     icon: Icons.person_pin,
              //     onPress: () {}),
              // const Divider(),
              // const SizedBox(height: 10),
              // ProfileMenuWidget(
              //     title: 'Information', icon: Icons.info, onPress: () {}),
              // ProfileMenuWidget(
              //   title: 'Sign Out',
              //   icon: Icons.logout,
              //   textColor: Colors.red,
              //   endIcon: false,
              //   onPress: () {
              //     // show dialog to confirm sign out
              //     showMyDialogConfirmSignOut(context);
              //   },
              // ),
              // ProfileMenuWidget(
              //   title: 'Test',
              //   icon: Icons.looks,
              //   textColor: Colors.green,
              //   endIcon: false,
              //   onPress: () {
              //     // test add reminder
              //     final reminder = ReminderEntity(
              //       useDefault: true,
              //       overrides: [
              //         OverrideReminder(rid: 123, method: 'popup', minutes: 5),
              //         OverrideReminder(rid: 321, method: 'email', minutes: 10),
              //       ]
              //     );

              //     FirebaseFirestore.instance
              //         .collection('test')
              //         .add(
              //           reminder.toMap(),
              //         )
              //         .then((value) => log('OK'));
              //   },
              // ),
              // ProfileMenuWidget(
              //   title: 'Test Read',
              //   icon: Icons.looks,
              //   textColor: Colors.green,
              //   endIcon: false,
              //   onPress: () {
              //     // test add reminder
              //     // final reminder = ReminderEntity(useDefault: true);

              //     // FirebaseFirestore.instance.collection('test').doc('').get().then((value) {
              //     //   final reminder = ReminderEntity.fromMap(value.data()!);
              //     //   log('OK ${reminder.useDefault}');
              //     // });
              //     // FirebaseFirestore.instance
              //     //   .collection('test')
              //     //   .doc('')
              //     //   .get()
              //     //   .then((value) {
              //     //     final reminder = ReminderEntity.fromMap(value.data()!);
              //     //     log('OK ${reminder}');
              //     //   });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void showMyDialogEditName(BuildContext context, String s) async {
    final controller = TextEditingController(text: s);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // update name
              context.read<AuthenticationBloc>().add(UpdateDisplayName(name: controller.text));
              log('object: ${controller.text}');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
