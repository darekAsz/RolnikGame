import 'package:shared_preferences/shared_preferences.dart';

/// Trwały licznik AKTUALNEJ populacji wioski - w odróżnieniu od limitu
/// wyliczanego z budynków (HomeShell._populationLimit), to jest prawdziwa
/// liczba mieszkańców, która rośnie co tydzień (jeśli jest miejsce i jedzenie)
/// i maleje przy głodzie.
class PopulationStorage {
  static const _populationKey = 'village_population';
  // Przyrost jest teraz ułamkowy (zależny od morale, patrz
  // HomeShell._effectivePopulationGrowthRate) - ta reszta ułamkowa musi
  // przetrwać między tygodniami, inaczej np. 0.5/tydzień nigdy nie
  // uskładałoby się do +1.
  static const _growthProgressKey = 'village_population_growth_progress';

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

  static Future<double> loadGrowthProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_growthProgressKey) ?? 0.0;
  }

  static Future<void> saveGrowthProgress(double progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_growthProgressKey, progress);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_populationKey);
    await prefs.remove(_growthProgressKey);
  }
}
