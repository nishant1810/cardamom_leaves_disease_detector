import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/models/scan_result.dart';

class ScanStorage {
  static const String _key = 'scan_results';

  // Save scan
  static Future<void> saveScan(ScanResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing =
        prefs.getStringList(_key) ?? [];

    existing.add(jsonEncode(result.toJson()));
    await prefs.setStringList(_key, existing);
  }

  // Load all scans
  static Future<List<ScanResult>> loadScans() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data =
        prefs.getStringList(_key) ?? [];

    return data
        .map((e) => ScanResult.fromJson(jsonDecode(e)))
        .toList();
  }

  //  Delete one scan by index
  static Future<void> deleteScan(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> data =
        prefs.getStringList(_key) ?? [];

    if (index >= 0 && index < data.length) {
      data.removeAt(index);
      await prefs.setStringList(_key, data);
    }
  }

  // Clear all history
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
