import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Migawki pełnego stanu gry, zapisywane co tydzień - pozwalają wczytać
/// wcześniejszy tydzień po ekranie porażki aktu (patrz ActFailureScreen).
/// Każdy checkpoint to jeden zakodowany JSON-em napis pod osobnym kluczem
/// SharedPreferences, więc przechowywanie kilkudziesięciu tygodni (cała gra
/// trwa 65) to niewielka ilość danych - nie trzeba ich przycinać.
class CheckpointStorage {
  static const _weeksKey = 'checkpoint_weeks';
  static String _snapshotKey(int week) => 'checkpoint_snapshot_$week';

  static Future<List<int>> listWeeks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_weeksKey) ?? const [];
    final weeks = raw.map(int.parse).toList()..sort();
    return weeks;
  }

  static Future<void> save(int week, Map<String, dynamic> snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_snapshotKey(week), jsonEncode(snapshot));
    final weeks = await listWeeks();
    if (!weeks.contains(week)) {
      weeks.add(week);
      await prefs.setStringList(_weeksKey, weeks.map((w) => w.toString()).toList());
    }
  }

  static Future<Map<String, dynamic>?> load(int week) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_snapshotKey(week));
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final weeks = await listWeeks();
    for (final week in weeks) {
      await prefs.remove(_snapshotKey(week));
    }
    await prefs.remove(_weeksKey);
  }
}
