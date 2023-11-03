import 'package:flutter/material.dart';
import 'package:memo_planner/features/authentication/domain/entities/user_entity.dart';

import '../components/profile_menu.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    // required this.userEntity,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserEntity tUser;

  @override
  void initState() {
    super.initState();
    tUser = const UserEntity(
        uid: '81726387123',
        email: 'venh.ha@gmail.com',
        displayName: 'Venh Ha',
        photoURL: 'photoURL',
        phoneNumber: 'phoneNumber');
  }

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Image.network('https://picsum.photos/250?image=9'),
              /// -- IMAGE
              Stack(
                children: [
                  
                  SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network('https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png'),
                      )),
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
              Text(tUser.displayName ?? tUser.email ?? '',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.primaries[0],
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text('Edit',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: 'Settings', icon: Icons.settings, onPress: () {}),
              ProfileMenuWidget(
                  title: 'Billing Details', icon: Icons.wallet, onPress: () {}),
              ProfileMenuWidget(
                  title: 'User Management',
                  icon: Icons.person_pin,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: 'Information', icon: Icons.info, onPress: () {}),
              ProfileMenuWidget(
                  title: 'Logout',
                  icon: Icons.logout,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
