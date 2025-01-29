import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  String? _cachedDbUrl;

  Future<File> get _settingsFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/settingsDb.json');
  }

  Future<String> getDatabaseUrl() async {
    if (_cachedDbUrl != null) return _cachedDbUrl!;
    try {
      final file = await _settingsFile;
      if (await file.exists()) {
        final settingsContent = await file.readAsString();
        final settings = json.decode(settingsContent);
        _cachedDbUrl = settings["database_url"] ?? "";
        return _cachedDbUrl!;
      }
    } catch (e) {
      debugPrint("Error reading database URL: $e");
    }
    return "";
  }
}
