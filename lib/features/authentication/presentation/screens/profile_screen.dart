import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';

import '../bloc/bloc/authentication_bloc.dart';
import '../widgets/profile_menu.dart';

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              left: 24,
              right: 24),
          child: Column(
            children: [
              // IMAGE

              Stack(
                children: [
                  SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
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
                                ))),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 35,
                  //     height: 35,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(100),
                  //         color: Colors.primaries[2]),
                  //     child: const Icon(
                  //       Icons.edit,
                  //       color: Colors.black,
                  //       size: 20,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.user.displayName ?? widget.user.email!.split('@')[0],
                  style: const TextStyle(fontSize: 32, color: Colors.black)),
              const SizedBox(height: 20),

              // Email
              Text(
                widget.user.email!,
                style: const TextStyle(fontSize: 16, color: Colors.black),
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
              ProfileMenuWidget(
                  title: 'Logout',
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(
                      SignOutEvent(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
