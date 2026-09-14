import 'package:shared_preferences/shared_preferences.dart';

/// Trwały stan sklepu: liczba dokupionych na stałe dodatkowych ruchów na
/// planszy zbiorów oraz poziom odblokowanego automatycznego usuwania ciągów
/// (0 = wyłączone, 1 = czwórki, 2 = po ulepszeniu - też trójki).
class ShopStorage {
  static const _extraMovesKey = 'shop_extra_moves';
  static const _autoMatchTierKey = 'shop_automatch_tier';

  static Future<int> loadExtraMoves() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_extraMovesKey) ?? 0;
  }

  static Future<void> saveExtraMoves(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_extraMovesKey, value);
  }

  static Future<int> loadAutoMatchTier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_autoMatchTierKey) ?? 0;
  }

  static Future<void> saveAutoMatchTier(int tier) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_autoMatchTierKey, tier);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_extraMovesKey, 0);
    await prefs.setInt(_autoMatchTierKey, 0);
  }
}
