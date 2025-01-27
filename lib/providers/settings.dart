import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider with ChangeNotifier {
  late File _settingsFile;
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadSettingsFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _settingsFile = File('${directory.path}/settingsApp.json');

      if (await _settingsFile.exists()) {
        final settingsContent = await _settingsFile.readAsString();
        final settings = json.decode(settingsContent);
        _isDarkMode = settings["darkMode"];
      } else {
        _isDarkMode = false;
      }
    } catch (error) {
      print("Error: $error");
      _isDarkMode = false;
    }
  }

  Future<void> loadSettings() async {
    await _loadSettingsFile();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _updateSettingsFile();
  }

  Future<void> _updateSettingsFile() async {
    try {
      final settings = {"darkMode": _isDarkMode};
      final settingsJson = json.encode(settings);
      await _settingsFile.writeAsString(settingsJson);
    } catch (error) {
      print("Error: $error");
    }
  }
}
