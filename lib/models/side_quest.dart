import '../services/app_locale.dart';
import 'side_quest_translations_en.dart';

/// Questy poboczne - opcjonalne, sprawdzane co tydzień względem realnego
/// stanu gry (budynki, odkrycia, statystyki, wyniki starć z bossami). Na
/// razie dają wyłącznie punkty doświadczenia (patrz HomeShell._sideQuestMet/
/// ExperienceStorage) - nic więcej się z nimi jeszcze nie dzieje.
enum SideQuestId {
  ostatniaLekcja,
  dobrySasiad,
  milczenieJadwigi,
  wdowaPoNajemniku,
  ostatniList,
  martaIncognito,
  staryHandlarz,
  klatwaStudni,
  ostatniaSzarza,
  sladyWPopiele,
  rozmowaZJadwiga,
}

class SideQuest {
  final SideQuestId id;
  final int actNumber;
  final String title;
  final String description;
  final int xpReward;

  const SideQuest({
    required this.id,
    required this.actNumber,
    required this.title,
    required this.description,
    required this.xpReward,
  });
}

extension SideQuestLocalization on SideQuest {
  String get localizedTitle =>
      AppLocale.instance.isEnglish ? (kSideQuestsEn[id]?.title ?? title) : title;

  String get localizedDescription =>
      AppLocale.instance.isEnglish ? (kSideQuestsEn[id]?.description ?? description) : description;
}

const List<SideQuest> kSideQuests = [
  SideQuest(
    id: SideQuestId.ostatniaLekcja,
    actNumber: 0,
    title: 'Ostatnia lekcja',
    description: 'Rozbuduj Ratusz do poziomu 2, zanim wioska pogrąży się w żałobie.',
    xpReward: 10,
  ),
  SideQuest(
    id: SideQuestId.dobrySasiad,
    actNumber: 0,
    title: 'Dobry sąsiad',
    description: 'Zbuduj Karczmę - niech wioska ma gdzie wspólnie przepracować żałobę.',
    xpReward: 10,
  ),
  SideQuest(
    id: SideQuestId.milczenieJadwigi,
    actNumber: 1,
    title: 'Milczenie Jadwigi',
    description: 'Zbuduj Kaplicę i zacznij wypytywać Jadwigę o przeszłość dziadka.',
    xpReward: 15,
  ),
  SideQuest(
    id: SideQuestId.wdowaPoNajemniku,
    actNumber: 1,
    title: 'Wdowa po najemniku',
    description: 'Pokonaj Grota (min. 2 z 3 etapów starcia) i miej zbudowaną Karczmę, '
        'żeby przyjąć jego dawną rodzinę.',
    xpReward: 15,
  ),
  SideQuest(
    id: SideQuestId.ostatniList,
    actNumber: 2,
    title: 'Ostatni list',
    description: 'Odblokuj odkrycie "Kartografia" w Uczelni, żeby odnaleźć niewysłany list dziadka.',
    xpReward: 15,
  ),
  SideQuest(
    id: SideQuestId.martaIncognito,
    actNumber: 2,
    title: 'Marta incognito',
    description: 'Osiągnij morale wioski co najmniej 70 - dobra atmosfera przyciąga '
        'nieznajomych, którym można zaufać.',
    xpReward: 15,
  ),
  SideQuest(
    id: SideQuestId.staryHandlarz,
    actNumber: 3,
    title: 'Stary handlarz',
    description: 'Zbuduj Rynek i wysłuchaj opowieści wędrownych kupców o dawnych czasach.',
    xpReward: 20,
  ),
  SideQuest(
    id: SideQuestId.klatwaStudni,
    actNumber: 4,
    title: 'Klątwa studni',
    description: 'Rozbuduj Studnię do poziomu 2, żeby zbadać niepokojące zjawiska wokół niej.',
    xpReward: 20,
  ),
  SideQuest(
    id: SideQuestId.ostatniaSzarza,
    actNumber: 4,
    title: 'Ostatnia szarża',
    description: 'Zbuduj siłę armii co najmniej 20 - więcej, niż wymaga sama walka z Leszym.',
    xpReward: 20,
  ),
  SideQuest(
    id: SideQuestId.sladyWPopiele,
    actNumber: 5,
    title: 'Ślady w popiele',
    description: 'Zakończ starcie z Martą z pełnym zaufaniem (wariant z bonusem za cierpliwość).',
    xpReward: 25,
  ),
  SideQuest(
    id: SideQuestId.rozmowaZJadwiga,
    actNumber: 5,
    title: 'Rozmowa z Jadwigą',
    description: 'Zbierz cały Dowód w starciu z Bogdanem, żeby poznać pełną prawdę.',
    xpReward: 25,
  ),
];

List<SideQuest> sideQuestsForAct(int actNumber) =>
    kSideQuests.where((q) => q.actNumber == actNumber).toList();
