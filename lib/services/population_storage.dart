import 'package:shared_preferences/shared_preferences.dart';

/// Trwały licznik AKTUALNEJ populacji wioski - w odróżnieniu od limitu
/// wyliczanego z budynków (HomeShell._populationLimit), to jest prawdziwa
/// liczba mieszkańców, która rośnie co tydzień (jeśli jest miejsce i jedzenie)
/// i maleje przy głodzie.
class PopulationStorage {
  static const _populationKey = 'village_population';

  /// null = brak zapisu (nowa gra) - HomeShell inicjuje wtedy od
  /// _basePopulation.
  static Future<int?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_populationKey) ? prefs.getInt(_populationKey) : null;
  }

  static Future<void> save(int population) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_populationKey, population);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_populationKey);
  }
}
