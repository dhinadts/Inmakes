import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme_provider.dart';
import '../profile/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(themeProvider.notifier);
    final theme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(title: Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold))),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: theme,
            onChanged: (m)=> controller.setTheme(m!),
            title: const Text('System'),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: theme,
            onChanged: (m)=> controller.setTheme(m!),
            title: const Text('Light'),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: theme,
            onChanged: (m)=> controller.setTheme(m!),
            title: const Text('Dark'),
          ),
          const Divider(),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: const Text('Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const ProfileScreen())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=> const LoginScreen()), (r)=>false);
              }
            },
          )
        ],
      ),
    );
  }
}
