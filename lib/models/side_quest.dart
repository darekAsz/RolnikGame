import '../services/app_locale.dart';
import 'resource_type.dart';
import 'side_quest_translations_en.dart';

/// Questy poboczne - opcjonalne, sprawdzane co tydzień względem realnego
/// stanu gry (budynki, odkrycia, statystyki, wyniki starć z bossami). Dają
/// jednorazową paczkę surowców do magazynu (patrz HomeShell._checkSideQuests)
/// - dobraną tak, żeby odpowiadała skali kosztów budowy w danym akcie i
/// tematycznie nawiązywała do treści questa.
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
  final Map<ResourceType, int> resourceReward;
  // Tydzień, od którego quest pojawia się w zakładce Cele - null, gdy
  // wystarczy sam numer aktu (większość questów). Potrzebne tam, gdzie akt
  // obejmuje wydarzenie dzielące go fabularnie na dwie części (patrz
  // StoryMilestone.fromWeek) - np. Akt 0 trwa tygodnie 1-13, ale Antoni
  // umiera dopiero w tygodniu 7, więc quest nawiązujący do jego śmierci nie
  // powinien być widoczny od samego początku aktu.
  final int? fromWeek;

  const SideQuest({
    required this.id,
    required this.actNumber,
    required this.title,
    required this.description,
    required this.resourceReward,
    this.fromWeek,
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
    fromWeek: 7,
    title: 'Ostatnia lekcja',
    description: 'Rozbuduj Ratusz do poziomu 2, żeby uczcić to, czego zdążył Cię nauczyć Antoni.',
    resourceReward: {ResourceType.wood: 15, ResourceType.stone: 15},
  ),
  SideQuest(
    id: SideQuestId.dobrySasiad,
    actNumber: 0,
    title: 'Dobry sąsiad',
    description: 'Zbuduj Karczmę - niech wioska ma gdzie wspólnie przepracować żałobę.',
    resourceReward: {ResourceType.grain: 10, ResourceType.apple: 10, ResourceType.coin: 5},
  ),
  SideQuest(
    id: SideQuestId.milczenieJadwigi,
    actNumber: 1,
    title: 'Milczenie Jadwigi',
    description: 'Zbuduj Kaplicę i zacznij wypytywać Jadwigę o przeszłość dziadka.',
    resourceReward: {ResourceType.stone: 20, ResourceType.coin: 10},
  ),
  SideQuest(
    id: SideQuestId.wdowaPoNajemniku,
    actNumber: 1,
    title: 'Wdowa po najemniku',
    description: 'Pokonaj Grota (min. 2 z 3 etapów starcia) i miej zbudowaną Karczmę, '
        'żeby przyjąć jego dawną rodzinę.',
    resourceReward: {ResourceType.wood: 20, ResourceType.stone: 15, ResourceType.coin: 10},
  ),
  SideQuest(
    id: SideQuestId.ostatniList,
    actNumber: 2,
    title: 'Ostatni list',
    description: 'Odblokuj odkrycie "Kartografia" w Uczelni, żeby odnaleźć niewysłany list dziadka.',
    resourceReward: {ResourceType.coin: 20, ResourceType.grass: 10},
  ),
  SideQuest(
    id: SideQuestId.martaIncognito,
    actNumber: 2,
    title: 'Marta incognito',
    description: 'Osiągnij morale wioski co najmniej 70 - dobra atmosfera przyciąga '
        'nieznajomych, którym można zaufać.',
    resourceReward: {ResourceType.apple: 20, ResourceType.grass: 15, ResourceType.coin: 10},
  ),
  SideQuest(
    id: SideQuestId.staryHandlarz,
    actNumber: 3,
    title: 'Stary handlarz',
    description: 'Zbuduj Rynek i wysłuchaj opowieści wędrownych kupców o dawnych czasach.',
    resourceReward: {ResourceType.coin: 25, ResourceType.wood: 15},
  ),
  SideQuest(
    id: SideQuestId.klatwaStudni,
    actNumber: 4,
    title: 'Klątwa studni',
    description: 'Rozbuduj Studnię do poziomu 2, żeby zbadać niepokojące zjawiska wokół niej.',
    resourceReward: {ResourceType.water: 30, ResourceType.stone: 15},
  ),
  SideQuest(
    id: SideQuestId.ostatniaSzarza,
    actNumber: 4,
    title: 'Ostatnia szarża',
    description: 'Zbuduj siłę armii co najmniej 20 - więcej, niż wymaga sama walka z Leszym.',
    resourceReward: {ResourceType.wood: 30, ResourceType.stone: 30, ResourceType.coin: 15},
  ),
  SideQuest(
    id: SideQuestId.sladyWPopiele,
    actNumber: 2,
    title: 'Ślady w popiele',
    description: 'Zakończ starcie z Martą z pełnym zaufaniem (wariant z bonusem za cierpliwość).',
    resourceReward: {ResourceType.grain: 20, ResourceType.water: 15, ResourceType.coin: 15},
  ),
  SideQuest(
    id: SideQuestId.rozmowaZJadwiga,
    actNumber: 3,
    title: 'Rozmowa z Jadwigą',
    description: 'Zbierz cały Dowód w starciu z Bogdanem, żeby poznać pełną prawdę.',
    resourceReward: {ResourceType.stone: 20, ResourceType.coin: 20},
  ),
];

/// Wszystkie questy odblokowane do (włącznie z) danego aktu - nie tylko te
/// przypisane dokładnie do niego. Bez tego quest z wcześniejszego aktu, nie
/// ukończony w swoim akcie, znikał z zakładki Cele w chwili przejścia do
/// kolejnego aktu (mimo że wciąż można go ukończyć - patrz komentarz przy
/// HomeShell._sideQuestMet: questy nie wygasają) - gracz tracił go z oczu,
/// choć mechanicznie wciąż mógł go zaliczyć "w tle".
List<SideQuest> sideQuestsUpToAct(int actNumber) =>
    kSideQuests.where((q) => q.actNumber <= actNumber).toList();
