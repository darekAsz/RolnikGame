import 'package:shared_preferences/shared_preferences.dart';

class GameProgress {
  final int week;
  final bool tutorialSeen;
  final bool hasSave;
  final bool ratuszBuilt;
  final bool palisadeBuilt;
  final bool harvestTutorialSeen;

  const GameProgress({
    required this.week,
    required this.tutorialSeen,
    required this.hasSave,
    required this.ratuszBuilt,
    required this.palisadeBuilt,
    this.harvestTutorialSeen = false,
  });
}

class GameProgressStorage {
  static const _weekKey = 'game_week';
  // Samouczek wioski/zakładek z podświetleniem na żywo (patrz
  // HomeShell._startTour) - pokazuje się raz, przy pierwszym wejściu do
  // wioski w nowej grze.
  static const _tutorialKey = 'game_tutorial_seen';
  static const _hasSaveKey = 'game_has_save';
  static const _ratuszBuiltKey = 'game_ratusz_built';
  static const _palisadeBuiltKey = 'game_palisade_built';
  // Osobny samouczek planszy zbiorów (kulek) - pokazuje się kontekstowo,
  // przy pierwszym wejściu na tę planszę, więc potrzebuje własnej flagi.
  static const _harvestTutorialKey = 'game_harvest_tutorial_seen';

  static Future<GameProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GameProgress(
      week: prefs.getInt(_weekKey) ?? 1,
      tutorialSeen: prefs.getBool(_tutorialKey) ?? false,
      hasSave: prefs.getBool(_hasSaveKey) ?? false,
      ratuszBuilt: prefs.getBool(_ratuszBuiltKey) ?? false,
      palisadeBuilt: prefs.getBool(_palisadeBuiltKey) ?? false,
      harvestTutorialSeen: prefs.getBool(_harvestTutorialKey) ?? false,
    );
  }

  static Future<void> saveWeek(int week) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weekKey, week);
  }

  static Future<void> markTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialKey, true);
  }

  static Future<void> markHarvestTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_harvestTutorialKey, true);
  }

  static Future<void> setRatuszBuilt(bool built) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratuszBuiltKey, built);
  }

  static Future<void> setPalisadeBuilt(bool built) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_palisadeBuiltKey, built);
  }

  /// Zaczyna nową grę: tydzień 1, oznaczenie że istnieje zapis do
  /// kontynuowania, i zresetowanie samouczka - ma się pokazywać przy
  /// każdej nowej grze, nie tylko raz na urządzenie.
  static Future<void> startNewGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_weekKey, 1);
    await prefs.setBool(_hasSaveKey, true);
    await prefs.setBool(_ratuszBuiltKey, false);
    await prefs.setBool(_palisadeBuiltKey, false);
    await prefs.setBool(_tutorialKey, false);
    await prefs.setBool(_harvestTutorialKey, false);
  }
}
