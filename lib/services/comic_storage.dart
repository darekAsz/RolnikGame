import 'package:shared_preferences/shared_preferences.dart';

/// Które komiksy fabularne gracz już otworzył/przeczytał (po numerze komiksu).
class ComicStorage {
  static const _readKey = 'comics_read';

  static Future<Set<int>> loadRead() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_readKey) ?? const [];
    return raw.map(int.parse).toSet();
  }

  static Future<void> markRead(int number) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_readKey) ?? const [];
    final updated = {...current, number.toString()};
    await prefs.setStringList(_readKey, updated.toList());
  }

  /// Nadpisuje cały zbiór przeczytanych komiksów naraz - używane przy
  /// wczytywaniu checkpointu (patrz CheckpointStorage), gdzie stan musi
  /// dokładnie odpowiadać temu z zapisanego tygodnia, nie tylko dokładać.
  static Future<void> saveAllRead(Set<int> read) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_readKey, read.map((n) => n.toString()).toList());
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_readKey);
  }
}
