import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/village_board.dart';

/// Liczba dodatkowych, niezależnie budowalnych działek pod zwykłe domy
/// (patrz `_VillageLayout.extraSmallPlotRefs` w village_board.dart).
const kExtraHouseCount = 5;

/// Trwały stan piętnastu dodatkowych budynków wioski (poza Ratuszem i
/// Palisadą, które mają własne flagi "zbudowany" w [GameProgressStorage]),
/// dodatkowych, niezależnych działek pod zwykłe domy, oraz poziomu 2
/// ("rozbudowany") dla wszystkich 17 rodzajów budynków.
class VillageBuildingStorage {
  static String _keyFor(BuildingKind kind) => 'village_building_${kind.name}';
  static String _houseKeyFor(int index) => 'village_extra_house_$index';
  static String _houseActiveKeyFor(int index) => 'village_extra_house_active_$index';
  static String _houseUpgradedKeyFor(int index) => 'village_extra_house_upgraded_$index';
  static String _upgradedKeyFor(BuildingKind kind) => 'village_building_upgraded_${kind.name}';
  static String _workersKeyFor(BuildingKind kind) => 'village_building_workers_${kind.name}';

  static Future<Map<BuildingKind, bool>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final kind in kExtraBuildingKinds) kind: prefs.getBool(_keyFor(kind)) ?? false,
    };
  }

  static Future<void> setBuilt(BuildingKind kind, bool built) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(kind), built);
  }

  static Future<List<bool>> loadExtraHouses() async {
    final prefs = await SharedPreferences.getInstance();
    return [
      for (var i = 0; i < kExtraHouseCount; i++) prefs.getBool(_houseKeyFor(i)) ?? false,
    ];
  }

  static Future<void> setExtraHouseBuilt(int index, bool built) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_houseKeyFor(index), built);
  }

  /// Czy dany dom faktycznie daje bonus do populacji. Domyślnie true (każdy
  /// dom zbudowany normalnie przez gracza działa od razu) - false tylko dla
  /// zaniedbanych domów odziedziczonych na starcie gry (patrz SplashScreen),
  /// dopóki gracz ich nie odbuduje (patrz HomeShell._onTapExtraHouse).
  static Future<List<bool>> loadExtraHousesActive() async {
    final prefs = await SharedPreferences.getInstance();
    return [
      for (var i = 0; i < kExtraHouseCount; i++) prefs.getBool(_houseActiveKeyFor(i)) ?? true,
    ];
  }

  static Future<void> setExtraHouseActive(int index, bool active) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_houseActiveKeyFor(index), active);
  }

  /// Prawdziwa rozbudowa (poziom 2) dodatkowego domu - podwaja jego premię
  /// do populacji, tak jak poziom 2 głównego budynku "Dom". Niezależna od
  /// [loadExtraHousesActive]: dom musi być najpierw aktywny (zbudowany albo
  /// odbudowany z zaniedbania), zanim można go w ogóle rozbudować.
  static Future<List<bool>> loadExtraHousesUpgraded() async {
    final prefs = await SharedPreferences.getInstance();
    return [
      for (var i = 0; i < kExtraHouseCount; i++) prefs.getBool(_houseUpgradedKeyFor(i)) ?? false,
    ];
  }

  static Future<void> setExtraHouseUpgraded(int index, bool upgraded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_houseUpgradedKeyFor(index), upgraded);
  }

  static Future<Map<BuildingKind, bool>> loadAllUpgraded() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final kind in kAllBuildingKinds) kind: prefs.getBool(_upgradedKeyFor(kind)) ?? false,
    };
  }

  static Future<void> setUpgraded(BuildingKind kind, bool upgraded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_upgradedKeyFor(kind), upgraded);
  }

  /// Liczba mieszkańców przydzielonych jako pracownicy (0-2) do każdego z
  /// budynków - zwiększają premię budynku (patrz HomeShell._workerMultiplier).
  static Future<Map<BuildingKind, int>> loadAllWorkers() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final kind in kAllBuildingKinds) kind: prefs.getInt(_workersKeyFor(kind)) ?? 0,
    };
  }

  static Future<void> setWorkers(BuildingKind kind, int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_workersKeyFor(kind), count);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    for (final kind in kExtraBuildingKinds) {
      await prefs.setBool(_keyFor(kind), false);
    }
    for (var i = 0; i < kExtraHouseCount; i++) {
      await prefs.setBool(_houseKeyFor(i), false);
      await prefs.setBool(_houseActiveKeyFor(i), true);
      await prefs.setBool(_houseUpgradedKeyFor(i), false);
    }
    for (final kind in kAllBuildingKinds) {
      await prefs.setBool(_upgradedKeyFor(kind), false);
      await prefs.setInt(_workersKeyFor(kind), 0);
    }
  }
}
