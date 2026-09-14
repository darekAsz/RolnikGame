import 'package:shared_preferences/shared_preferences.dart';

import '../models/area_kind.dart';

/// Trwały stan okolic wioski. Każdy teren ma dwa poziomy: "zbudowany"
/// (poziom 1 - odblokowuje/wzmacnia surowiec) i "rozbudowany" (poziom 2 -
/// odblokowuje możliwość wyboru tego surowca jako "surowca tygodnia").
class AreaStorage {
  static String _builtKeyFor(AreaKind area) => 'area_built_${area.name}';
  static String _upgradedKeyFor(AreaKind area) => 'area_upgraded_${area.name}';

  static Future<Map<AreaKind, bool>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final area in AreaKind.values) area: prefs.getBool(_builtKeyFor(area)) ?? false,
    };
  }

  static Future<void> setBuilt(AreaKind area, bool built) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_builtKeyFor(area), built);
  }

  static Future<Map<AreaKind, bool>> loadUpgraded() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      for (final area in AreaKind.values) area: prefs.getBool(_upgradedKeyFor(area)) ?? false,
    };
  }

  static Future<void> setUpgraded(AreaKind area, bool upgraded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_upgradedKeyFor(area), upgraded);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    for (final area in AreaKind.values) {
      await prefs.setBool(_builtKeyFor(area), false);
      await prefs.setBool(_upgradedKeyFor(area), false);
    }
  }
}
