import 'package:shared_preferences/shared_preferences.dart';

import '../models/side_quest.dart';

/// Ukończone questy poboczne (i cele główne aktów - patrz HomeShell) dają
/// surowce bezpośrednio do magazynu, więc jedyne, co trzeba tu trwale
/// zapamiętać, to które questy poboczne zostały już odebrane (żeby nie dać
/// ich nagrody dwa razy).
class ExperienceStorage {
  static const _claimedSideQuestsKey = 'experience_claimed_side_quests';

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
    await prefs.remove(_claimedSideQuestsKey);
  }
}
