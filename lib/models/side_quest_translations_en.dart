import 'side_quest.dart';

/// Angielskie tłumaczenia treści `kSideQuests` (patrz `side_quest.dart`),
/// kluczowane przez `SideQuestId`. Brakujący wpis = ekran bezpiecznie spada
/// na polski oryginał (patrz `SideQuestLocalization` w `side_quest.dart`).
class SideQuestTranslation {
  final String title;
  final String description;

  const SideQuestTranslation(this.title, this.description);
}

const Map<SideQuestId, SideQuestTranslation> kSideQuestsEn = {
  SideQuestId.ostatniaLekcja: SideQuestTranslation(
    'The Last Lesson',
    'Upgrade the Town Hall to level 2 to honor what Antoni managed to teach you.',
  ),
  SideQuestId.dobrySasiad: SideQuestTranslation(
    'A Good Neighbor',
    'Build the Tavern - give the village a place to grieve together.',
  ),
  SideQuestId.milczenieJadwigi: SideQuestTranslation(
    "Jadwiga's Silence",
    "Build the Chapel and start asking Jadwiga about your grandfather's past.",
  ),
  SideQuestId.wdowaPoNajemniku: SideQuestTranslation(
    "The Mercenary's Widow",
    'Defeat Grot (win at least 2 of the 3 stages) and have the Tavern built, '
        'so you can take in his late family.',
  ),
  SideQuestId.ostatniList: SideQuestTranslation(
    'The Last Letter',
    'Unlock the "Cartography" discovery at the Academy to find your '
        "grandfather's unsent letter.",
  ),
  SideQuestId.martaIncognito: SideQuestTranslation(
    'Marta Incognito',
    'Reach a village morale of at least 70 - a good atmosphere draws in '
        'strangers worth trusting.',
  ),
  SideQuestId.staryHandlarz: SideQuestTranslation(
    'The Old Trader',
    "Build the Market and listen to traveling merchants' tales of times gone by.",
  ),
  SideQuestId.klatwaStudni: SideQuestTranslation(
    "The Well's Curse",
    'Upgrade the Well to level 2 to look into the unsettling things happening around it.',
  ),
  SideQuestId.ostatniaSzarza: SideQuestTranslation(
    'The Last Charge',
    'Build an army strength of at least 20 - more than the fight with Leszy alone requires.',
  ),
  SideQuestId.sladyWPopiele: SideQuestTranslation(
    'Traces in the Ashes',
    'End the confrontation with Marta with full trust (the variant rewarding patience).',
  ),
  SideQuestId.rozmowaZJadwiga: SideQuestTranslation(
    'A Conversation with Jadwiga',
    'Gather all the Evidence in the confrontation with Bogdan to learn the whole truth.',
  ),
};
