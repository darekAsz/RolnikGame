import 'package:shared_preferences/shared_preferences.dart';

/// Trwały postęp fabuły: które akty zostały już rozstrzygnięte (cel
/// osiągnięty albo kara nałożona za jego brak), w którym tygodniu ostatnio
/// doszło do głodu (potrzebne do sprawdzenia celu Aktu III - "przetrwaj
/// zimę bez głodu") oraz wyniki starć z bossami (Grot - tydzień 26, Marta -
/// tydzień 39, Bogdan - tydzień 52, Leszy - tydzień 59).
class StoryProgressStorage {
  static const _resolvedActsKey = 'story_resolved_acts';
  static const _lastStarvationWeekKey = 'story_last_starvation_week';
  static const _bossBattleStagesClearedKey = 'story_boss_battle_stages_cleared';
  static const _martaBattleStagesClearedKey = 'story_marta_battle_stages_cleared';
  static const _martaFullTrustKey = 'story_marta_full_trust';
  static const _bogdanProofCompleteKey = 'story_bogdan_proof_complete';
  static const _leszyVictoriousKey = 'story_leszy_victorious';

  static Future<Set<int>> loadResolvedActs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_resolvedActsKey) ?? const [];
    return raw.map(int.parse).toSet();
  }

  static Future<void> saveResolvedActs(Set<int> acts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_resolvedActsKey, acts.map((a) => a.toString()).toList());
  }

  static Future<int> loadLastStarvationWeek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastStarvationWeekKey) ?? 0;
  }

  static Future<void> saveLastStarvationWeek(int week) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastStarvationWeekKey, week);
  }

  // -1 = starcie jeszcze się nie odbyło, 0-3 = liczba ukończonych etapów.
  static Future<int> loadBossBattleStagesCleared() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bossBattleStagesClearedKey) ?? -1;
  }

  static Future<void> saveBossBattleStagesCleared(int stagesCleared) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bossBattleStagesClearedKey, stagesCleared);
  }

  // -1 = starcie jeszcze się nie odbyło, 0-3 = liczba ukończonych etapów.
  static Future<int> loadMartaBattleStagesCleared() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_martaBattleStagesClearedKey) ?? -1;
  }

  static Future<void> saveMartaBattleStagesCleared(int stagesCleared) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_martaBattleStagesClearedKey, stagesCleared);
  }

  // Czy starcie z Martą zakończyło się najlepszym wariantem (3/3 etapy +
  // bonus za cierpliwość) - odblokowuje jej interwencję w starciu z Bogdanem.
  static Future<bool> loadMartaFullTrust() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_martaFullTrustKey) ?? false;
  }

  static Future<void> saveMartaFullTrust(bool fullTrust) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_martaFullTrustKey, fullTrust);
  }

  // -1 = starcie jeszcze się nie odbyło, 0 = porażka, 1 = dowód zebrany.
  static Future<int> loadBogdanProofComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bogdanProofCompleteKey) ?? -1;
  }

  static Future<void> saveBogdanProofComplete(bool complete) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bogdanProofCompleteKey, complete ? 1 : 0);
  }

  /// Zapisuje surową wartość (-1/0/1) wprost - w odróżnieniu od
  /// saveBogdanProofComplete(bool) pozwala odtworzyć też stan "starcie
  /// jeszcze się nie odbyło" (-1), potrzebny przy wczytywaniu checkpointu
  /// sprzed tygodnia 52 (patrz CheckpointStorage).
  static Future<void> saveBogdanProofCompleteValue(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bogdanProofCompleteKey, value);
  }

  // Leszy to jedyny boss, którego trzeba pokonać, żeby historia poszła
  // dalej - porażka nie przesuwa tygodnia, więc ta flaga w praktyce zawsze
  // jest true w momencie, gdy w ogóle zostaje sprawdzona (patrz
  // HomeShell._actGoalMet), ale zapisujemy ją dla spójności z resztą.
  static Future<bool> loadLeszyVictorious() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_leszyVictoriousKey) ?? false;
  }

  static Future<void> saveLeszyVictorious(bool victorious) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_leszyVictoriousKey, victorious);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_resolvedActsKey);
    await prefs.setInt(_lastStarvationWeekKey, 0);
    await prefs.setInt(_bossBattleStagesClearedKey, -1);
    await prefs.setInt(_martaBattleStagesClearedKey, -1);
    await prefs.setBool(_martaFullTrustKey, false);
    await prefs.setInt(_bogdanProofCompleteKey, -1);
    await prefs.setBool(_leszyVictoriousKey, false);
  }
}
