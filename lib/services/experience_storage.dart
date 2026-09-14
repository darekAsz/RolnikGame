import 'package:shared_preferences/shared_preferences.dart';

import '../models/side_quest.dart';

/// Punkty doświadczenia i ukończone questy poboczne - na razie samo XP nic
/// nie odblokowuje, to tylko licznik pokazywany w Statystykach.
class ExperienceStorage {
  static const _xpKey = 'experience_xp';
  static const _claimedSideQuestsKey = 'experience_claimed_side_quests';

  static Future<int> loadXp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  static Future<void> saveXp(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, xp);
  }

  /// Pomija nierozpoznane nazwy zamiast rzucać wyjątkiem - stary zapis może
  /// zawierać questa usuniętego z gry w międzyczasie (patrz models/side_quest.dart).
  static Future<Set<SideQuestId>> loadClaimedSideQuests() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_claimedSideQuestsKey) ?? const [];
    final names = SideQuestId.values.map((id) => id.name).toSet();
    return raw.where(names.contains).map((name) => SideQuestId.values.byName(name)).toSet();
  }

  static Future<void> saveClaimedSideQuests(Set<SideQuestId> claimed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_claimedSideQuestsKey, claimed.map((id) => id.name).toList());
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_xpKey, 0);
    await prefs.remove(_claimedSideQuestsKey);
  }
}
