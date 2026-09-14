import 'package:shared_preferences/shared_preferences.dart';

/// Trwałe modyfikatory ze zdarzeń losowych (patrz village_event.dart) -
/// doliczane do wartości bazowych wyliczanych z budynków w HomeShell.
class VillageEventStorage {
  static const _moraleKey = 'event_morale_bonus';
  static const _securityKey = 'event_security_bonus';
  static const _populationKey = 'event_population_bonus';

  static Future<int> loadMoraleBonus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_moraleKey) ?? 0;
  }

  static Future<void> saveMoraleBonus(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_moraleKey, value);
  }

  static Future<int> loadSecurityBonus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_securityKey) ?? 0;
  }

  static Future<void> saveSecurityBonus(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_securityKey, value);
  }

  static Future<int> loadPopulationBonus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_populationKey) ?? 0;
  }

  static Future<void> savePopulationBonus(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_populationKey, value);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_moraleKey, 0);
    await prefs.setInt(_securityKey, 0);
    await prefs.setInt(_populationKey, 0);
  }
}
