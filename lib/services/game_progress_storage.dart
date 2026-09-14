import 'package:shared_preferences/shared_preferences.dart';

class GameProgress {
  final int week;
  final bool tutorialSeen;
  final bool hasSave;
  final bool ratuszBuilt;
  final bool palisadeBuilt;
  final bool harvestTutorialSeen;
  final bool villageTutorialSeen;

  const GameProgress({
    required this.week,
    required this.tutorialSeen,
    required this.hasSave,
    required this.ratuszBuilt,
    required this.palisadeBuilt,
    this.harvestTutorialSeen = false,
    this.villageTutorialSeen = false,
  });
}

class GameProgressStorage {
  static const _weekKey = 'game_week';
  static const _tutorialKey = 'game_tutorial_seen';
  static const _hasSaveKey = 'game_has_save';
  static const _ratuszBuiltKey = 'game_ratusz_built';
  static const _palisadeBuiltKey = 'game_palisade_built';
  // Osobne od _tutorialKey (ekran "Jak grać" pokazywany raz przed pierwszym
  // wejściem do gry) - te dwa pokazują się kontekstowo, przy pierwszym
  // wejściu na planszę zbiorów i na ekran wioski, więc potrzebują własnych
  // flag "widziane".
  static const _harvestTutorialKey = 'game_harvest_tutorial_seen';
  static const _villageTutorialKey = 'game_village_tutorial_seen';

  static Future<GameProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GameProgress(
      week: prefs.getInt(_weekKey) ?? 1,
      tutorialSeen: prefs.getBool(_tutorialKey) ?? false,
      hasSave: prefs.getBool(_hasSaveKey) ?? false,
      ratuszBuilt: prefs.getBool(_ratuszBuiltKey) ?? false,
      palisadeBuilt: prefs.getBool(_palisadeBuiltKey) ?? false,
      harvestTutorialSeen: prefs.getBool(_harvestTutorialKey) ?? false,
      villageTutorialSeen: prefs.getBool(_villageTutorialKey) ?? false,
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

  static Future<void> markVillageTutorialSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_villageTutorialKey, true);
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
    await prefs.setBool(_villageTutorialKey, false);
  }
}
