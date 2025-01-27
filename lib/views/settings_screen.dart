import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/settings.dart';
import 'package:shop/widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Theme",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary),
          ),
          const SizedBox(height: 20),
          Card(
            child: SwitchListTile(
              title: const Text(
                "Dark Mode",
              ),
              subtitle: const Text("Enable/Disable Dark Mode"),
              value: settings.isDarkMode,
              onChanged: (_) {
                settings.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
