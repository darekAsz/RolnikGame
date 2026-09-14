import 'package:shared_preferences/shared_preferences.dart';

import '../models/resource_type.dart';

// Surowce, w które magazyn jest zaopatrzony na starcie nowej gry, żeby
// uniknąć głodu/dezercji w pierwszych tygodniach zanim gracz zdąży odblokować
// własną produkcję jedzenia.
const Map<ResourceType, int> _kStartingStockpile = {
  ResourceType.apple: 100,
  ResourceType.grain: 100,
};

class ResourceStorage {
  static String _keyFor(ResourceType type) => 'resource_${type.name}';

  // Wszystkie zapisy przechodzą przez tę samą kolejkę, żeby dwa równoległe
  // wywołania save() (np. z szybkich, następujących po sobie ruchów na
  // planszy zbiorów) nigdy się nie przeplatały i nie nadpisywały nawzajem -
  // inaczej część zebranych surowców potrafiła "zniknąć" przy szybkiej grze.
  static Future<void> _queue = Future.value();

  static Future<T> _synchronized<T>(Future<T> Function() action) {
    final result = _queue.then((_) => action());
    _queue = result.then((_) {}, onError: (_) {});
    return result;
  }

  static Future<Map<ResourceType, int>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final type in ResourceType.values)
        type: prefs.getInt(_keyFor(type)) ?? 0,
    };
  }

  static Future<void> save(Map<ResourceType, int> resources) {
    // Migawka na wypadek, gdyby wywołujący kod nadal mutował tę samą mapę
    // (np. kolejny ruch na planszy) zanim ten zapis zdąży się zakończyć.
    final snapshot = Map<ResourceType, int>.from(resources);
    return _synchronized(() async {
      final prefs = await SharedPreferences.getInstance();
      for (final entry in snapshot.entries) {
        await prefs.setInt(_keyFor(entry.key), entry.value);
      }
    });
  }

  static Future<void> reset() {
    return _synchronized(() async {
      final prefs = await SharedPreferences.getInstance();
      for (final type in ResourceType.values) {
        await prefs.setInt(_keyFor(type), _kStartingStockpile[type] ?? 0);
      }
    });
  }
}
