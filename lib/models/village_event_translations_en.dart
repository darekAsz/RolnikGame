import 'village_event_translations_en_part1.dart';
import 'village_event_translations_en_part2.dart';

/// Angielskie tłumaczenia treści `kVillageEvents` (patrz `village_event.dart`),
/// kluczowane przez `VillageEvent.id`. Rozbite na dwie części (part1/part2)
/// tylko z powodu objętości (154 zdarzenia) - to jeden logiczny słownik,
/// połączony tutaj. Brakujący wpis = ekran bezpiecznie spada na polski
/// oryginał (patrz `VillageEventLocalization` w `village_event.dart`).
class VillageEventOptionTranslation {
  final String label;
  final String resultText;

  const VillageEventOptionTranslation(this.label, this.resultText);
}

class VillageEventTranslation {
  final String title;
  final String description;
  // Tylko dla kind == choice - zawsze dokładnie 2 opcje, w tej samej
  // kolejności co VillageEvent.options.
  final List<VillageEventOptionTranslation>? options;

  const VillageEventTranslation(this.title, this.description, [this.options]);
}

const Map<String, VillageEventTranslation> kVillageEventsEn = {
  ...kVillageEventsEnPart1,
  ...kVillageEventsEnPart2,
};
