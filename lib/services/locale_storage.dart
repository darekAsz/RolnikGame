import 'package:shared_preferences/shared_preferences.dart';

class LocaleStorage {
  static const _key = 'app_locale';

  static Future<String> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) == 'en' ? 'en' : 'pl';
  }

  static Future<void> save(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }
}
