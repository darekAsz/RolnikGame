import 'package:shared_preferences/shared_preferences.dart';

/// Wygląd tła planszy zbiorów - `photo` to obrazki tekstur w assets/boards/
/// (domyślne), `classic` to dawny płaski gradient koloru pory roku sprzed
/// dodania tych grafik, zachowany jako opcja dla graczy, którym stary
/// wygląd bardziej odpowiadał (np. słabszy sprzęt, minimalizm).
enum BoardStyle { photo, classic }

class BoardStyleStorage {
  static const _key = 'board_style';

  static Future<BoardStyle> load() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) == 'classic' ? BoardStyle.classic : BoardStyle.photo;
  }

  static Future<void> save(BoardStyle style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, style.name);
  }
}
