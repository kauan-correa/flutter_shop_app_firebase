import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/settings.dart';
import 'package:shop/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsApp = Provider.of<SettingsProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Theme",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text(
                "Dark Mode",
              ),
              subtitle: const Text("Enable/Disable Dark Mode"),
              value: settingsApp.isDarkMode,
              onChanged: (_) {
                settingsApp.toggleTheme();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Firebase",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
          const Card(
            child: ListTile(
              title: Text("Firebase"),
              subtitle: TextField(
                decoration: InputDecoration(
                  hintText: "Enter your firebase URL",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
