import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/theme/theme_provider.dart';
import '../../features/authentication/presentation/bloc/authentication/authentication_bloc.dart';
import '../components/dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await showMyDialogToConfirm(
                context,
                title: 'Sign Out',
                content: 'Are you sure to sign out?',
                onConfirm: () {
                  BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SettingItemBox(child: _buildChangeThemeButton(context)),
          SettingItemBox(child: _buildAppColorPicker(context)),
        ],
      ),
    );
  }

  Row _buildAppColorPicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          icon: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.color_lens,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          alignment: Alignment.centerRight,
          value: context.watch<ThemeProvider>().colorSchemeSeed,
          borderRadius: BorderRadius.circular(12.0),
          // remove underline of dropdown button
          underline: Container(),
          items: _appColors,
          menuMaxHeight: 256.0,
          onChanged: (value) {
            context.read<ThemeProvider>().setColorSchemeSeed(value as Color);
          },
        ),
      ],
    );
  }

  Row _buildChangeThemeButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Theme',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        DropdownButton(
          icon: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Theme.of(context).brightness == Brightness.light ? Icons.wb_sunny : Icons.nightlight_round,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          alignment: Alignment.centerRight,
          value: context.watch<ThemeProvider>().themeMode,
          borderRadius: BorderRadius.circular(12.0),
          // remove underline of dropdown button
          underline: Container(),
          items: const [
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light '),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark '),
            ),
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System '),
            ),
          ],
          onChanged: (value) {
            context.read<ThemeProvider>().setThemeMode(value as ThemeMode);
          },
        ),
      ],
    );
  }
}

class SettingItemBox extends StatelessWidget {
  const SettingItemBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: child,
    );
  }
}

const _appColors = [
  DropdownMenuItem(
    value: Colors.green,
    child: Text('Green '),
  ),
  DropdownMenuItem(
    value: Colors.red,
    child: Text('Red '),
  ),
  DropdownMenuItem(
    value: Colors.blue,
    child: Text('Blue '),
  ),
  DropdownMenuItem(
    value: Colors.purple,
    child: Text('Purple '),
  ),
  DropdownMenuItem(
    value: Colors.orange,
    child: Text('Orange '),
  ),
  DropdownMenuItem(
    value: Colors.pink,
    child: Text('Pink '),
  ),
  DropdownMenuItem(
    value: Colors.teal,
    child: Text('Teal '),
  ),
  DropdownMenuItem(
    value: Colors.amber,
    child: Text('Amber '),
  ),
  DropdownMenuItem(
    value: Colors.indigo,
    child: Text('Indigo '),
  ),
  DropdownMenuItem(
    value: Colors.cyan,
    child: Text('Cyan '),
  ),
  DropdownMenuItem(
    value: Colors.lime,
    child: Text('Lime '),
  ),
  DropdownMenuItem(
    value: Colors.brown,
    child: Text('Brown '),
  ),
];
