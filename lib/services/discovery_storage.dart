import 'package:shared_preferences/shared_preferences.dart';

import '../models/discovery.dart';

/// Trwały zbiór odblokowanych odkryć z Uczelni (patrz discovery.dart).
class DiscoveryStorage {
  static const _keyPrefix = 'discovery_unlocked_';
  static String _keyFor(DiscoveryId id) => '$_keyPrefix${id.name}';

  static Future<Set<DiscoveryId>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final id in DiscoveryId.values)
        if (prefs.getBool(_keyFor(id)) ?? false) id,
    };
  }

  static Future<void> setUnlocked(DiscoveryId id, bool unlocked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(id), unlocked);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in DiscoveryId.values) {
      await prefs.setBool(_keyFor(id), false);
    }
  }
}
