import 'package:shared_preferences/shared_preferences.dart';

import '../models/unit_type.dart';

class GameStats {
  final int totalCollected;
  final int longestPath;
  final int maxSingleHarvest;
  final Map<UnitType, int> soldierCounts;

  const GameStats({
    required this.totalCollected,
    required this.longestPath,
    required this.maxSingleHarvest,
    this.soldierCounts = const {},
  });

  int get totalSoldierCount => soldierCounts.values.fold(0, (a, b) => a + b);
}

class StatsStorage {
  static const _totalKey = 'stats_total_collected';
  static const _longestPathKey = 'stats_longest_path';
  static const _maxHarvestKey = 'stats_max_single_harvest';
  static String _soldierCountKey(UnitType type) => 'stats_soldier_count_${type.name}';

  // Bez tej kolejki dwa niemal równoczesne wywołania recordHarvest (szybkie,
  // następujące po sobie ruchy na planszy zbiorów) mogły obie odczytać tę
  // samą starą sumę przed zapisaniem nowej - i jeden z przyrostów po prostu
  // ginął ("zgubiona aktualizacja").
  static Future<void> _queue = Future.value();

  static Future<T> _synchronized<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  static Future<GameStats> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GameStats(
      totalCollected: prefs.getInt(_totalKey) ?? 0,
      longestPath: prefs.getInt(_longestPathKey) ?? 0,
      maxSingleHarvest: prefs.getInt(_maxHarvestKey) ?? 0,
      soldierCounts: {
        for (final type in UnitType.values) type: prefs.getInt(_soldierCountKey(type)) ?? 0,
      },
    );
  }

  /// Rekrutacja w Koszarach - zapisuje nową liczbę żołnierzy danego typu.
  static Future<void> saveSoldierCount(UnitType type, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_soldierCountKey(type), count);
  }

  /// Nadpisuje wszystkie statystyki naraz dokładnymi wartościami - używane
  /// przy wczytywaniu checkpointu (patrz CheckpointStorage), w
  /// przeciwieństwie do recordHarvest/recordPathLength, które tylko
  /// przyrostowo aktualizują rekordy.
  static Future<void> saveAll(GameStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalKey, stats.totalCollected);
    await prefs.setInt(_longestPathKey, stats.longestPath);
    await prefs.setInt(_maxHarvestKey, stats.maxSingleHarvest);
    for (final entry in stats.soldierCounts.entries) {
      await prefs.setInt(_soldierCountKey(entry.key), entry.value);
    }
  }

  /// Rejestruje ilość surowców dodaną do zapasów w jednym zdarzeniu (ścieżka,
  /// auto-dopasowanie lub zniszczenie przez bombę) - aktualizuje sumę łączną
  /// i rekord "najwięcej naraz".
  static Future<void> recordHarvest(int amount) {
    if (amount <= 0) return Future.value();
    return _synchronized(() async {
      final prefs = await SharedPreferences.getInstance();
      final total = (prefs.getInt(_totalKey) ?? 0) + amount;
      await prefs.setInt(_totalKey, total);
      final maxHarvest = prefs.getInt(_maxHarvestKey) ?? 0;
      if (amount > maxHarvest) {
        await prefs.setInt(_maxHarvestKey, amount);
      }
    });
  }

  /// Rejestruje surową długość ręcznie połączonej ścieżki (przed premiami).
  static Future<void> recordPathLength(int length) {
    return _synchronized(() async {
      final prefs = await SharedPreferences.getInstance();
      final longest = prefs.getInt(_longestPathKey) ?? 0;
      if (length > longest) {
        await prefs.setInt(_longestPathKey, length);
      }
    });
  }

  static Future<void> reset() {
    return _synchronized(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_totalKey, 0);
      await prefs.setInt(_longestPathKey, 0);
      await prefs.setInt(_maxHarvestKey, 0);
      for (final type in UnitType.values) {
        await prefs.setInt(_soldierCountKey(type), 0);
      }
    });
  }
}
