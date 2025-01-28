import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Future<File> get settingsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/settingsApp.json');
  }

  Future<void> _loadSettingsFile() async {
    try {
      final settingsFile = await this.settingsFile;

      if (await settingsFile.exists()) {
        final settingsContent = await settingsFile.readAsString();
        final settings = json.decode(settingsContent);
        _isDarkMode = settings["darkMode"];
      } else {
        _isDarkMode = false;
      }
    } catch (error) {
      debugPrint("Error: $error");
      _isDarkMode = false;
    }
  }

  Future<void> loadSettings() async {
    await _loadSettingsFile();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _updateSettingsFile();
    notifyListeners();
  }

  Future<void> _updateSettingsFile() async {
    try {
      final settingsFile = await this.settingsFile;

      final settings = {"darkMode": _isDarkMode};
      final settingsJson = json.encode(settings);

      await settingsFile.writeAsString(settingsJson);
    } catch (error) {
      debugPrint("Error: $error");
    }
  }
}
