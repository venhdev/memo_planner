import 'package:flutter/material.dart';

import '../../../../core/components/widgets.dart';
import '../../domain/entities/user_entity.dart';
import '../components/profile_menu.dart';
import '../../../../core/screens/about_screen.dart';

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
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     TextButton.icon(
      //       style: TextButton.styleFrom(foregroundColor: Colors.red),
      //       label: const Text('Sign Out'),
      //       onPressed: () {
      //         // show dialog to confirm sign out
      //         showMyDialogConfirmSignOut(context);
      //       },
      //       icon: const Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            actions: [
              TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                label: const Text('Sign Out'),
                onPressed: () {
                  // show dialog to confirm sign out
                  // showMyDialogConfirmSignOut(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildAvatar(),
                const SizedBox(height: 8.0),
                _buildUserName(context),

                const SizedBox(height: 12.0),

                // Email
                Text(
                  widget.user.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

                const Divider(),
                // MENU
                SettingMenuItem(
                  title: 'Settings',
                  icon: Icons.settings,
                  onPress: () {},
                ),
                SettingMenuItem(
                  title: 'Billing Details',
                  icon: Icons.wallet,
                  onPress: () {},
                ),
                SettingMenuItem(
                  title: 'User Management',
                  icon: Icons.person_pin,
                  onPress: () {},
                ),
                const Divider(),
                SettingMenuItem(
                  title: 'About',
                  icon: Icons.info,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildUserName(BuildContext context) {
    return ListTile(
      title: Text(
        widget.user.displayName ?? widget.user.email!.split('@')[0],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
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
        showDialogForEditName(
          context,
          widget.user.displayName ?? widget.user.email!.split('@')[0],
        );
      },
    );
  }

  Center _buildAvatar() {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
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
    );
  }
}
