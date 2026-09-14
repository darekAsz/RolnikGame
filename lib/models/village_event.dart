import 'resource_type.dart';
import 'season.dart';

/// Losowe wydarzenia tygodniowe - część zależy od morale wioski (wyższe
/// morale = większa szansa na wylosowanie wydarzenia pozytywnego zamiast
/// negatywnego), część od pory roku, a "choice" pozwala graczowi wybrać
/// jedną z dwóch opcji o różnych skutkach.
enum VillageEventKind { positive, negative, choice }

/// Skutek wydarzenia (lub jednej z opcji wydarzenia wyborowego) - wszystkie
/// pola są deltami dodawanymi do bieżącego stanu wioski.
class EventEffect {
  final Map<ResourceType, int> resourceDelta;
  final int moraleDelta;
  final int securityDelta;
  final int populationDelta;
  // Dodatnie: dołącza tylu żołnierzy losowego typu. Ujemne: dezercja/straty -
  // tylu żołnierzy odchodzi (najpierw najsłabsze typy), o ile są dostępni.
  final int soldierDelta;

  const EventEffect({
    this.resourceDelta = const {},
    this.moraleDelta = 0,
    this.securityDelta = 0,
    this.populationDelta = 0,
    this.soldierDelta = 0,
  });
}

class EventOption {
  final String label;
  final String resultText;
  final EventEffect effect;

  const EventOption({required this.label, required this.resultText, required this.effect});
}

class VillageEvent {
  final String id;
  final String title;
  final String description;
  final VillageEventKind kind;
  // null = może wystąpić w każdej porze roku.
  final Season? season;
  // Dla kind == positive/negative.
  final EventEffect? effect;
  // Dla kind == choice - zawsze dokładnie 2 opcje.
  final List<EventOption>? options;

  const VillageEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.kind,
    this.season,
    this.effect,
    this.options,
  });
}

const List<VillageEvent> kVillageEvents = [
  // ---- pozytywne ----
  VillageEvent(
    id: 'trader_gift',
    title: 'Wędrowny kupiec',
    description: 'Wędrowny kupiec, zachwycony gościnnością wioski, zostawia w darze część swojego towaru.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 8}),
  ),
  VillageEvent(
    id: 'bountiful_harvest',
    title: 'Obfite zbiory',
    description: 'Tegoroczne zbiory przerosły oczekiwania - spichlerze pękają w szwach.',
    kind: VillageEventKind.positive,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.apple: 6, ResourceType.grain: 6}),
  ),
  VillageEvent(
    id: 'spring_rains',
    title: 'Wiosenne deszcze',
    description: 'Łagodne, wiosenne deszcze użyźniły pola i napełniły studnie.',
    kind: VillageEventKind.positive,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.water: 6, ResourceType.grass: 4}),
  ),
  VillageEvent(
    id: 'stone_vein',
    title: 'Nowa żyła kamienia',
    description: 'Kamieniarze natrafili na bogatą żyłę dobrego kamienia.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.stone: 8}),
  ),
  VillageEvent(
    id: 'village_festival',
    title: 'Wiejskie święto',
    description: 'Spontaniczna zabawa poprawia nastroje w całej wiosce.',
    kind: VillageEventKind.positive,
    effect: EventEffect(moraleDelta: 8),
  ),

  // ---- negatywne ----
  VillageEvent(
    id: 'granary_fire',
    title: 'Pożar w spichlerzu',
    description: 'Nieuwaga przy piecu wznieciła pożar - część zapasów spłonęła.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.grain: -6, ResourceType.apple: -4}),
  ),
  VillageEvent(
    id: 'drought',
    title: 'Susza',
    description: 'Brak deszczu wysuszył studnie i pola.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.water: -8}),
  ),
  VillageEvent(
    id: 'harsh_winter',
    title: 'Ostra zima',
    description: 'Mróz i śnieg utrudniły życie mieszkańcom.',
    kind: VillageEventKind.negative,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.apple: -5}, moraleDelta: -5),
  ),
  VillageEvent(
    id: 'bandit_raid',
    title: 'Napad bandytów',
    description: 'Grupa bandytów splądrowała spichlerze, zanim obrona zdążyła zareagować.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.coin: -6, ResourceType.wood: -4}, securityDelta: -5),
  ),
  VillageEvent(
    id: 'livestock_illness',
    title: 'Choroba wśród zwierząt',
    description: 'Tajemnicza choroba dziesiątkuje inwentarz.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -6}, moraleDelta: -4),
  ),

  // ---- wybór ----
  VillageEvent(
    id: 'immigrants',
    title: 'Imigranci proszą o przyjęcie',
    description: 'Grupa wędrowców prosi o wpuszczenie do wioski i osiedlenie się na stałe.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij',
        resultText: 'Nowi mieszkańcy zwiększają limit populacji, ale zabierają część zapasów na start.',
        effect: EventEffect(
          populationDelta: 3,
          resourceDelta: {ResourceType.grain: -4, ResourceType.apple: -4},
        ),
      ),
      EventOption(
        label: 'Odpraw',
        resultText:
            'Wędrowcy odchodzą szukać szczęścia gdzie indziej, a wieść o chłodnym przyjęciu nie poprawia reputacji wioski.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'preacher',
    title: 'Wędrowny kaznodzieja',
    description: 'Kaznodzieja prosi o pozwolenie na głoszenie kazań na wiejskim rynku.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Pozwól',
        resultText: 'Kazania podnoszą morale, ale zbiórka na tacę uszczupla skarbiec.',
        effect: EventEffect(moraleDelta: 6, resourceDelta: {ResourceType.coin: -3}),
      ),
      EventOption(
        label: 'Przepędź',
        resultText: 'Kaznodzieja odchodzi z pustymi rękami.',
        effect: EventEffect(),
      ),
    ],
  ),
  VillageEvent(
    id: 'caravan',
    title: 'Karawana kupiecka',
    description: 'Kupcy oferują wymianę drewna i kamienia na złoto.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Handluj',
        resultText: 'Wymieniono część zapasów drewna i kamienia na złoto.',
        effect: EventEffect(
          resourceDelta: {ResourceType.wood: -5, ResourceType.stone: -5, ResourceType.coin: 8},
        ),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Karawana odjeżdża dalej.',
        effect: EventEffect(),
      ),
    ],
  ),
  VillageEvent(
    id: 'deserter',
    title: 'Dezerter szuka schronienia',
    description: 'Zbiegły żołnierz prosi o przyjęcie do koszar w zamian za schronienie.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij',
        resultText: 'Dezerter wzmacnia szeregi, choć część mieszkańców jest niezadowolona.',
        effect: EventEffect(soldierDelta: 1, moraleDelta: -3),
      ),
      EventOption(
        label: 'Odpraw',
        resultText: 'Dezerter znika w lesie.',
        effect: EventEffect(),
      ),
    ],
  ),

  // ============================================================
  // WIOSNA - 5 pozytywnych, 5 negatywnych
  // ============================================================
  VillageEvent(
    id: 'spring_pos_1',
    title: 'Kwitnące sady',
    description: 'Sady okrywają się kwieciem, zapowiadając obfity plon jabłek.',
    kind: VillageEventKind.positive,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.apple: 6}),
  ),
  VillageEvent(
    id: 'spring_pos_2',
    title: 'Roztopy zasilają studnie',
    description: 'Topniejący śnieg napełnił studnie czystą wodą.',
    kind: VillageEventKind.positive,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.water: 6}),
  ),
  VillageEvent(
    id: 'spring_pos_3',
    title: 'Udane siewy',
    description: 'Ziarno wsiane w żyzną, wiosenną ziemię szybko kiełkuje.',
    kind: VillageEventKind.positive,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 6}),
  ),
  VillageEvent(
    id: 'spring_pos_4',
    title: 'Powrót ptaków',
    description: 'Powrót ptaków po zimie wróży szczęście i podnosi nastroje w wiosce.',
    kind: VillageEventKind.positive,
    season: Season.spring,
    effect: EventEffect(moraleDelta: 6),
  ),
  VillageEvent(
    id: 'spring_pos_5',
    title: 'Wiosenny jarmark',
    description: 'Pierwszy po zimie jarmark przynosi nieoczekiwany zarobek.',
    kind: VillageEventKind.positive,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 6}),
  ),
  VillageEvent(
    id: 'spring_neg_1',
    title: 'Wiosenna powódź',
    description: 'Roztopy zalały część zapasów drewna złożonego nisko przy rzece.',
    kind: VillageEventKind.negative,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -6}),
  ),
  VillageEvent(
    id: 'spring_neg_2',
    title: 'Wiosenne przeziębienia',
    description: 'Zmienna pogoda rozłożyła połowę wioski z przeziębieniem.',
    kind: VillageEventKind.negative,
    season: Season.spring,
    effect: EventEffect(moraleDelta: -5),
  ),
  VillageEvent(
    id: 'spring_neg_3',
    title: 'Plaga ślimaków',
    description: 'Ślimaki zaatakowały młode uprawy zaraz po siewie.',
    kind: VillageEventKind.negative,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.grain: -5}),
  ),
  VillageEvent(
    id: 'spring_neg_4',
    title: 'Osunięcie zbocza',
    description: 'Rozmokła po roztopach ziemia osunęła się, niszcząc część zapasów kamienia.',
    kind: VillageEventKind.negative,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.stone: -5}),
  ),
  VillageEvent(
    id: 'spring_neg_5',
    title: 'Wiosenna wichura',
    description: 'Silny wiatr zerwał dach jednej z szop z zapasami trawy.',
    kind: VillageEventKind.negative,
    season: Season.spring,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -6}),
  ),

  // ============================================================
  // LATO - 5 pozytywnych, 5 negatywnych
  // ============================================================
  VillageEvent(
    id: 'summer_pos_1',
    title: 'Złote żniwa',
    description: 'Upalne, słoneczne dni przyspieszyły dojrzewanie zboża.',
    kind: VillageEventKind.positive,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 7}),
  ),
  VillageEvent(
    id: 'summer_pos_2',
    title: 'Owocny sad',
    description: 'Lato obdarowało sad wyjątkowo słodkimi jabłkami.',
    kind: VillageEventKind.positive,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.apple: 6}),
  ),
  VillageEvent(
    id: 'summer_pos_3',
    title: 'Letni jarmark',
    description: 'Podróżni kupcy chętnie płacą dobrą cenę za letnie zapasy.',
    kind: VillageEventKind.positive,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 7}),
  ),
  VillageEvent(
    id: 'summer_pos_4',
    title: 'Bujne pastwiska',
    description: 'Ciepłe dni sprawiły, że trawa rośnie jak na drożdżach.',
    kind: VillageEventKind.positive,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.grass: 7}),
  ),
  VillageEvent(
    id: 'summer_pos_5',
    title: 'Wieczorne ogniska',
    description: 'Ciepłe letnie wieczory sprzyjają wspólnym biesiadom przy ognisku.',
    kind: VillageEventKind.positive,
    season: Season.summer,
    effect: EventEffect(moraleDelta: 6),
  ),
  VillageEvent(
    id: 'summer_neg_1',
    title: 'Fala upałów',
    description: 'Rekordowe upały wysuszyły część zapasów wody.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.water: -7}),
  ),
  VillageEvent(
    id: 'summer_neg_2',
    title: 'Poparzenia słoneczne',
    description: 'Praca w pełnym słońcu odbiła się na zdrowiu mieszkańców.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(moraleDelta: -5),
  ),
  VillageEvent(
    id: 'summer_neg_3',
    title: 'Pożar suchej trawy',
    description: 'Iskra z ogniska strawiła połać wysuszonej słońcem trawy.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -6}),
  ),
  VillageEvent(
    id: 'summer_neg_4',
    title: 'Plaga szarańczy',
    description: 'Chmara szarańczy przetoczyła się przez pola zbożowe.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.grain: -6}),
  ),
  VillageEvent(
    id: 'summer_neg_5',
    title: 'Rozeschnięte narzędzia',
    description: 'Upał wysuszył i popękał drewniane trzonki narzędzi.',
    kind: VillageEventKind.negative,
    season: Season.summer,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -5}),
  ),

  // ============================================================
  // JESIEŃ - 5 pozytywnych, 5 negatywnych
  // ============================================================
  VillageEvent(
    id: 'autumn_pos_1',
    title: 'Winobranie',
    description: 'Drzewa owocowe obrodziły wyjątkowo słodkimi owocami.',
    kind: VillageEventKind.positive,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.apple: 7}),
  ),
  VillageEvent(
    id: 'autumn_pos_2',
    title: 'Jesienny targ',
    description: 'Jesienny targ przyciąga tłumy kupców z okolicy.',
    kind: VillageEventKind.positive,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 7}),
  ),
  VillageEvent(
    id: 'autumn_pos_3',
    title: 'Zapasy na zimę',
    description: 'Mieszkańcy sprawnie gromadzą zapasy przed nadchodzącą zimą.',
    kind: VillageEventKind.positive,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 6}),
  ),
  VillageEvent(
    id: 'autumn_pos_4',
    title: 'Babie lato',
    description: 'Ciepłe, słoneczne dni babiego lata poprawiają nastroje wszystkim.',
    kind: VillageEventKind.positive,
    season: Season.autumn,
    effect: EventEffect(moraleDelta: 6),
  ),
  VillageEvent(
    id: 'autumn_pos_5',
    title: 'Grzybobranie',
    description: 'Wilgotne po deszczu lasy obrodziły w grzyby i zioła.',
    kind: VillageEventKind.positive,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.grass: 6}),
  ),
  VillageEvent(
    id: 'autumn_neg_1',
    title: 'Jesienne roztopy',
    description: 'Ulewne jesienne deszcze zmoczyły i zniszczyły część drewna.',
    kind: VillageEventKind.negative,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -6}),
  ),
  VillageEvent(
    id: 'autumn_neg_2',
    title: 'Wczesne przymrozki',
    description: 'Niespodziewane przymrozki uszkodziły część sadu.',
    kind: VillageEventKind.negative,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.apple: -6}),
  ),
  VillageEvent(
    id: 'autumn_neg_3',
    title: 'Błoto na drogach',
    description: 'Rozmokłe drogi utrudniają handel z sąsiednimi wioskami.',
    kind: VillageEventKind.negative,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.coin: -5}),
  ),
  VillageEvent(
    id: 'autumn_neg_4',
    title: 'Gnijące liście',
    description: 'Gnijące liście zanieczyściły część zapasów paszy.',
    kind: VillageEventKind.negative,
    season: Season.autumn,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -5}),
  ),
  VillageEvent(
    id: 'autumn_neg_5',
    title: 'Jesienna chandra',
    description: 'Coraz krótsze dni wpływają na nastroje mieszkańców.',
    kind: VillageEventKind.negative,
    season: Season.autumn,
    effect: EventEffect(moraleDelta: -5),
  ),

  // ============================================================
  // ZIMA - 5 pozytywnych, 5 negatywnych
  // ============================================================
  VillageEvent(
    id: 'winter_pos_1',
    title: 'Skrząca się zima',
    description: 'Malowniczy, skrzący się śnieg poprawia nastroje mimo mrozu.',
    kind: VillageEventKind.positive,
    season: Season.winter,
    effect: EventEffect(moraleDelta: 6),
  ),
  VillageEvent(
    id: 'winter_pos_2',
    title: 'Udane polowanie',
    description: 'Zimowe polowanie przyniosło więcej zwierzyny niż zwykle.',
    kind: VillageEventKind.positive,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.grass: 6}),
  ),
  VillageEvent(
    id: 'winter_pos_3',
    title: 'Kolędnicy',
    description: 'Kolędnicy odwiedzający wioskę budzą radość i poczucie wspólnoty.',
    kind: VillageEventKind.positive,
    season: Season.winter,
    effect: EventEffect(moraleDelta: 6),
  ),
  VillageEvent(
    id: 'winter_pos_4',
    title: 'Lód na rzece',
    description: 'Zamarznięta rzeka ułatwia transport ciężkiego kamienia.',
    kind: VillageEventKind.positive,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.stone: 6}),
  ),
  VillageEvent(
    id: 'winter_pos_5',
    title: 'Łagodna zima',
    description: 'Wyjątkowo łagodna zima oszczędziła zapasy zboża.',
    kind: VillageEventKind.positive,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 6}),
  ),
  VillageEvent(
    id: 'winter_neg_1',
    title: 'Mroźna noc',
    description: 'Silny mróz zamroził część studni.',
    kind: VillageEventKind.negative,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.water: -6}),
  ),
  VillageEvent(
    id: 'winter_neg_2',
    title: 'Zawierucha śnieżna',
    description: 'Zawierucha zerwała dach magazynu z drewnem opałowym.',
    kind: VillageEventKind.negative,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -6}),
  ),
  VillageEvent(
    id: 'winter_neg_3',
    title: 'Zimowa grypa',
    description: 'Grypa rozprzestrzenia się szybko w zimowym chłodzie.',
    kind: VillageEventKind.negative,
    season: Season.winter,
    effect: EventEffect(moraleDelta: -5),
  ),
  VillageEvent(
    id: 'winter_neg_4',
    title: 'Wilki przy obejściu',
    description: 'Głodne wilki krążą wokół obejść, niepokojąc mieszkańców.',
    kind: VillageEventKind.negative,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -6}),
  ),
  VillageEvent(
    id: 'winter_neg_5',
    title: 'Pęknięte cembrowiny',
    description: 'Mróz popękał kamienne cembrowiny studni - trzeba je naprawić.',
    kind: VillageEventKind.negative,
    season: Season.winter,
    effect: EventEffect(resourceDelta: {ResourceType.stone: -5}),
  ),

  // ============================================================
  // OGÓLNE (dowolna pora roku) - 25 pozytywnych, 25 negatywnych
  // ============================================================
  VillageEvent(
    id: 'general_pos_1',
    title: 'Szczęśliwe znalezisko',
    description: 'Ktoś znalazł zgubione dawno temu monety.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 6}),
  ),
  VillageEvent(
    id: 'general_pos_2',
    title: 'Dobry omen',
    description: 'Wróżby zapowiadają pomyślność dla całej wioski.',
    kind: VillageEventKind.positive,
    effect: EventEffect(moraleDelta: 5),
  ),
  VillageEvent(
    id: 'general_pos_3',
    title: 'Nowa receptura piekarza',
    description: 'Piekarz udoskonalił przepis, wykorzystując zboże wydajniej.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 5}),
  ),
  VillageEvent(
    id: 'general_pos_4',
    title: 'Sprawny kowal',
    description: 'Kowal usprawnił produkcję, oszczędzając surowce.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.stone: 5}),
  ),
  VillageEvent(
    id: 'general_pos_5',
    title: 'Wprawny cieśla',
    description: 'Cieśla oszczędnie gospodaruje drewnem, zostawiając nadwyżki.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.wood: 5}),
  ),
  VillageEvent(
    id: 'general_pos_6',
    title: 'Czyste źródło',
    description: 'Odkryto nowe, czyste źródło wody na skraju wioski.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.water: 6}),
  ),
  VillageEvent(
    id: 'general_pos_7',
    title: 'Sad rodzi obficie',
    description: 'Drzewa owocowe obrodziły ponad wszelkie oczekiwania.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.apple: 6}),
  ),
  VillageEvent(
    id: 'general_pos_8',
    title: 'Bujna trawa',
    description: 'Łąki wokół wioski porosły gęstą, zdrową trawą.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.grass: 6}),
  ),
  VillageEvent(
    id: 'general_pos_9',
    title: 'Wesele w wiosce',
    description: 'Huczne wesele poprawia nastroje wszystkim mieszkańcom.',
    kind: VillageEventKind.positive,
    effect: EventEffect(moraleDelta: 7),
  ),
  VillageEvent(
    id: 'general_pos_10',
    title: 'Skuteczny handel',
    description: 'Udana transakcja z przejezdnym kupcem przynosi zysk.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 6}),
  ),
  VillageEvent(
    id: 'general_pos_11',
    title: 'Nowy pomysł budowlany',
    description: 'Cieśla zaproponował oszczędniejszą metodę budowy.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.wood: 5}),
  ),
  VillageEvent(
    id: 'general_pos_12',
    title: 'Żyzna gleba',
    description: 'Gleba na polach okazała się wyjątkowo żyzna w tym roku.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 5}),
  ),
  VillageEvent(
    id: 'general_pos_13',
    title: 'Odkryty skarb',
    description: 'Dzieci bawiące się za wioską znalazły zakopany skarb.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 9}),
  ),
  VillageEvent(
    id: 'general_pos_14',
    title: 'Gościnność popłaca',
    description: 'Podróżni doceniają gościnność i zostawiają drobne dary.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 5}),
  ),
  VillageEvent(
    id: 'general_pos_15',
    title: 'Sprawna organizacja pracy',
    description: 'Lepsza organizacja pracy przyspiesza wydobycie kamienia.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.stone: 5}),
  ),
  VillageEvent(
    id: 'general_pos_16',
    title: 'Deszcz w samą porę',
    description: 'Deszcz spadł dokładnie wtedy, gdy pola najbardziej go potrzebowały.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.water: 5}),
  ),
  VillageEvent(
    id: 'general_pos_17',
    title: 'Udana hodowla',
    description: 'Hodowla zwierząt przynosi lepsze efekty niż zwykle.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.grass: 5}),
  ),
  VillageEvent(
    id: 'general_pos_18',
    title: 'Czujna straż',
    description: 'Czujność strażników odstraszyła podejrzanych włóczęgów.',
    kind: VillageEventKind.positive,
    effect: EventEffect(securityDelta: 5),
  ),
  VillageEvent(
    id: 'general_pos_19',
    title: 'Radosne dzieci',
    description: 'Śmiech dzieci bawiących się na ulicach poprawia nastroje.',
    kind: VillageEventKind.positive,
    effect: EventEffect(moraleDelta: 5),
  ),
  VillageEvent(
    id: 'general_pos_20',
    title: 'Uczciwy poborca',
    description: 'Poborca podatków uczciwie rozliczył się z wioską.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.coin: 5}),
  ),
  VillageEvent(
    id: 'general_pos_21',
    title: 'Solidne fundamenty',
    description: 'Nowa metoda budowy fundamentów pozwala oszczędzić kamień.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.stone: 5}),
  ),
  VillageEvent(
    id: 'general_pos_22',
    title: 'Nowa studnia',
    description: 'Mieszkańcy wspólnymi siłami wykopali dodatkową studnię.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.water: 6}),
  ),
  VillageEvent(
    id: 'general_pos_23',
    title: 'Wsparcie sąsiadów',
    description: 'Sąsiednia wioska przekazała dar w postaci zboża.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.grain: 6}),
  ),
  VillageEvent(
    id: 'general_pos_24',
    title: 'Sprzyjający wiatr',
    description: 'Sprzyjająca pogoda przyspiesza dojrzewanie owoców.',
    kind: VillageEventKind.positive,
    effect: EventEffect(resourceDelta: {ResourceType.apple: 5}),
  ),
  VillageEvent(
    id: 'general_pos_25',
    title: 'Duch wspólnoty',
    description: 'Mieszkańcy spontanicznie pomagają sobie nawzajem.',
    kind: VillageEventKind.positive,
    effect: EventEffect(moraleDelta: 6),
  ),
  VillageEvent(
    id: 'general_neg_1',
    title: 'Złodziej w nocy',
    description: 'Nocny złodziej okradł część skarbca wioski.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.coin: -6}),
  ),
  VillageEvent(
    id: 'general_neg_2',
    title: 'Plotki i niesnaski',
    description: 'Plotki wywołały spory między sąsiadami.',
    kind: VillageEventKind.negative,
    effect: EventEffect(moraleDelta: -5),
  ),
  VillageEvent(
    id: 'general_neg_3',
    title: 'Zepsuty sprzęt',
    description: 'Zepsuło się kilka ważnych narzędzi ciesielskich.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -5}),
  ),
  VillageEvent(
    id: 'general_neg_4',
    title: 'Pęknięty kamień młyński',
    description: 'Kamień młyński pękł podczas pracy, trzeba go zastąpić.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.stone: -5}),
  ),
  VillageEvent(
    id: 'general_neg_5',
    title: 'Zanieczyszczona studnia',
    description: 'Jedna ze studni została przypadkowo zanieczyszczona.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.water: -6}),
  ),
  VillageEvent(
    id: 'general_neg_6',
    title: 'Szkodniki w spichlerzu',
    description: 'Gryzonie dobrały się do zapasów zboża.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grain: -6}),
  ),
  VillageEvent(
    id: 'general_neg_7',
    title: 'Robaczywe jabłka',
    description: 'Część zbiorów jabłek okazała się robaczywa.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.apple: -5}),
  ),
  VillageEvent(
    id: 'general_neg_8',
    title: 'Wypalona trawa',
    description: 'Niekontrolowany ogień strawił część łąki.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -5}),
  ),
  VillageEvent(
    id: 'general_neg_9',
    title: 'Spór o miedzę',
    description: 'Spór o granicę działek zepsuł nastroje w wiosce.',
    kind: VillageEventKind.negative,
    effect: EventEffect(moraleDelta: -5),
  ),
  VillageEvent(
    id: 'general_neg_10',
    title: 'Oszust na targu',
    description: 'Oszust wyłudził część zapasów złota podczas targu.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.coin: -6}),
  ),
  VillageEvent(
    id: 'general_neg_11',
    title: 'Zawalona ściana',
    description: 'Stara ściana zawaliła się, niszcząc zapasy kamienia.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.stone: -6}),
  ),
  VillageEvent(
    id: 'general_neg_12',
    title: 'Spróchniałe belki',
    description: 'Spróchniałe belki trzeba było pilnie wymienić.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -6}),
  ),
  VillageEvent(
    id: 'general_neg_13',
    title: 'Zatrucie wody',
    description: 'Zanieczyszczenie zatruło część zapasów wody.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.water: -5}),
  ),
  VillageEvent(
    id: 'general_neg_14',
    title: 'Nieurodzaj',
    description: 'Tegoroczne plony zboża są gorsze niż zwykle.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grain: -5}),
  ),
  VillageEvent(
    id: 'general_neg_15',
    title: 'Kradzież paszy',
    description: 'Złodzieje ukradli część zapasów paszy dla zwierząt.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -5}),
  ),
  VillageEvent(
    id: 'general_neg_16',
    title: 'Niezadowolenie z podatków',
    description: 'Podniesienie podatków wywołało niezadowolenie mieszkańców.',
    kind: VillageEventKind.negative,
    effect: EventEffect(moraleDelta: -6),
  ),
  VillageEvent(
    id: 'general_neg_17',
    title: 'Uszkodzony wóz',
    description: 'Uszkodzony wóz transportowy trzeba pilnie naprawić.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.wood: -5}),
  ),
  VillageEvent(
    id: 'general_neg_18',
    title: 'Fałszywy alarm',
    description: 'Fałszywy alarm o najeźdźcach zaniepokoił całą wioskę.',
    kind: VillageEventKind.negative,
    effect: EventEffect(securityDelta: -5),
  ),
  VillageEvent(
    id: 'general_neg_19',
    title: 'Kłótnia rodzin',
    description: 'Kłótnia dwóch rodzin zepsuła atmosferę w wiosce.',
    kind: VillageEventKind.negative,
    effect: EventEffect(moraleDelta: -5),
  ),
  VillageEvent(
    id: 'general_neg_20',
    title: 'Zepsute narzędzia górnicze',
    description: 'Narzędzia kamieniarzy wymagają pilnej naprawy.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.stone: -5}),
  ),
  VillageEvent(
    id: 'general_neg_21',
    title: 'Zaraza wśród drobiu',
    description: 'Zaraza zdziesiątkowała hodowlę drobiu w wiosce.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grass: -6}),
  ),
  VillageEvent(
    id: 'general_neg_22',
    title: 'Nieuczciwy kupiec',
    description: 'Kupiec oszukał na wadze sprzedawanego towaru.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.coin: -5}),
  ),
  VillageEvent(
    id: 'general_neg_23',
    title: 'Stęchłe zapasy',
    description: 'Część zboża zmokła i spleśniała w magazynie.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.grain: -6}),
  ),
  VillageEvent(
    id: 'general_neg_24',
    title: 'Owady w sadzie',
    description: 'Szkodniki zaatakowały drzewa owocowe w sadzie.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.apple: -6}),
  ),
  VillageEvent(
    id: 'general_neg_25',
    title: 'Wyschnięta studnia',
    description: 'Jedna ze studni nieoczekiwanie wyschła.',
    kind: VillageEventKind.negative,
    effect: EventEffect(resourceDelta: {ResourceType.water: -6}),
  ),

  // ============================================================
  // OGÓLNE Z WYBOREM - 50 pozycji
  // ============================================================
  VillageEvent(
    id: 'choice_alchemist',
    title: 'Wędrowny alchemik',
    description: 'Alchemik oferuje tajemniczy eliksir w zamian za surowce.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup eliksir',
        resultText: 'Eliksir okazuje się przydatny - mieszkańcy czują się lepiej.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4}, moraleDelta: 6),
      ),
      EventOption(label: 'Odmów', resultText: 'Alchemik rusza w dalszą drogę.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_fire_refugees',
    title: 'Uchodźcy z pożaru',
    description: 'Grupa uchodźców z pobliskiej, spalonej osady prosi o schronienie.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij',
        resultText: 'Nowi mieszkańcy osiedlają się w wiosce.',
        effect: EventEffect(
          populationDelta: 2,
          resourceDelta: {ResourceType.grain: -3, ResourceType.apple: -3},
        ),
      ),
      EventOption(
        label: 'Odeślij',
        resultText: 'Uchodźcy szukają pomocy gdzie indziej.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_grain_loan',
    title: 'Prośba o pożyczkę zboża',
    description: 'Sąsiednia wioska prosi o pożyczkę zboża do wiosennych siewów.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Pożycz',
        resultText: 'Sąsiedzi są bardzo wdzięczni za pomoc.',
        effect: EventEffect(resourceDelta: {ResourceType.grain: -5}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Sąsiedzi zapamiętają tę odmowę.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_bard',
    title: 'Wędrowny bard',
    description: 'Bard oferuje występ na rynku w zamian za zapłatę.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zapłać za występ',
        resultText: 'Występ umila wieczór całej wiosce.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -3}, moraleDelta: 6),
      ),
      EventOption(
        label: 'Przepędź',
        resultText: 'Bard odchodzi z żalem, a mieszkańcy żałują straconej rozrywki.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_well_dispute',
    title: 'Spór o studnię',
    description: 'Dwóch sąsiadów kłóci się o dostęp do wspólnej studni.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Rozsądź sprawiedliwie',
        resultText: 'Spór zostaje rozwiązany polubownie.',
        effect: EventEffect(moraleDelta: 5),
      ),
      EventOption(
        label: 'Zignoruj',
        resultText: 'Spór ciągnie się dalej, psując atmosferę.',
        effect: EventEffect(moraleDelta: -4),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_wood_offer',
    title: 'Oferta na drewno',
    description: 'Kupiec oferuje dobrą cenę za zapas drewna.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Sprzedaj',
        resultText: 'Drewno trafia na wóz kupca.',
        effect: EventEffect(resourceDelta: {ResourceType.wood: -6, ResourceType.coin: 8}),
      ),
      EventOption(label: 'Zatrzymaj', resultText: 'Drewno zostaje w magazynie.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_poor_family',
    title: 'Prośba biednej rodziny',
    description: 'Uboga rodzina prosi o część zapasów zboża na przetrwanie miesiąca.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Pomóż',
        resultText: 'Rodzina jest wdzięczna, a wioska solidarna.',
        effect: EventEffect(resourceDelta: {ResourceType.grain: -4}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Rodzina radzi sobie sama, niechętnie wspominając odmowę.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_healer',
    title: 'Wędrowny lekarz',
    description: 'Lekarz oferuje szczepienia mieszkańców za opłatą.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zapłać',
        resultText: 'Mieszkańcy czują się bezpieczniej.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odpraw',
        resultText: 'Lekarz rusza dalej, a mieszkańcy zostają bez szczepień, co ich niepokoi.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_wounded_traveler',
    title: 'Ranny podróżny',
    description: 'Ranny podróżny prosi o jedzenie i opiekę.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Opatrz go',
        resultText: 'Podróżny wraca do zdrowia i błogosławi wioskę.',
        effect: EventEffect(resourceDelta: {ResourceType.apple: -3}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Zostaw go',
        resultText: 'Podróżny odchodzi o własnych siłach.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_alliance',
    title: 'Oferta sojuszu',
    description: 'Sąsiednia wioska proponuje sojusz obronny w zamian za daninę.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij sojusz',
        resultText: 'Sojusz wzmacnia obronę wioski.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -5}, securityDelta: 6),
      ),
      EventOption(
        label: 'Odrzuć',
        resultText: 'Wioska pozostaje niezależna, ale bez wsparcia sojusznika czuje się mniej bezpieczna.',
        effect: EventEffect(securityDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_wedding_permission',
    title: 'Prośba o ślub',
    description: 'Młoda para prosi o zgodę na ślub bez tradycyjnego posagu.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zgódź się',
        resultText: 'Ślub odbywa się ku radości wioski.',
        effect: EventEffect(moraleDelta: 6),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Para jest rozczarowana decyzją.',
        effect: EventEffect(moraleDelta: -4),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_traveling_smith',
    title: 'Wędrowny kowal',
    description: 'Kowal oferuje darmową naprawę narzędzi w zamian za nocleg.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij nocleg',
        resultText: 'Narzędzia wracają do dobrej formy.',
        effect: EventEffect(resourceDelta: {ResourceType.stone: 5}),
      ),
      EventOption(label: 'Odmów', resultText: 'Kowal rusza dalej.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_old_mine_map',
    title: 'Mapa starej kopalni',
    description: 'Znaleziono starą mapę wskazującą opuszczoną kopalnię kamienia.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zbadaj kopalnię',
        resultText: 'Wyprawa przynosi cenny kamień.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -3, ResourceType.stone: 8}),
      ),
      EventOption(label: 'Zignoruj mapę', resultText: 'Mapa trafia do skrzyni ze starociami.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_shepherds',
    title: 'Wędrowni pasterze',
    description: 'Pasterze proszą o wypas swoich stad na wioskowych łąkach.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Pozwól za opłatą',
        resultText: 'Pasterze płacą za wypas, ale łąki nieco cierpią.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: 5, ResourceType.grass: -4}),
      ),
      EventOption(label: 'Przegoń ich', resultText: 'Pasterze szukają innych pastwisk.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_teacher',
    title: 'Wędrowny nauczyciel',
    description: 'Nauczyciel oferuje osiedlenie się i nauczanie dzieci za utrzymanie.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij',
        resultText: 'Dzieci uczą się chętnie, a wioska jest dumna.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4}, moraleDelta: 6),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Nauczyciel szuka innej wioski, a rodzice żałują straconej szansy dla dzieci.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_juggler',
    title: 'Wędrowny kuglarz',
    description: 'Kuglarz prosi o pozwolenie na występy na targu.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Pozwól',
        resultText: 'Występy cieszą się dużym powodzeniem.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -2}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Kuglarz odchodzi zawiedziony, a mieszkańcy nie kryją rozczarowania.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_orphan',
    title: 'Sierota szuka domu',
    description: 'Osierocone dziecko szuka schronienia w wiosce.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przygarnij',
        resultText: 'Dziecko znajduje nowy dom.',
        effect: EventEffect(resourceDelta: {ResourceType.grain: -3}, populationDelta: 1),
      ),
      EventOption(
        label: 'Odeślij',
        resultText: 'Dziecko trafia do odległego sierocińca.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_gold_rumor',
    title: 'Plotka o złocie',
    description: 'Krążą plotki o złocie ukrytym w pobliskim lesie.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Szukaj złota',
        resultText: 'Poszukiwania częściowo się opłacają.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: 6}),
      ),
      EventOption(label: 'Zignoruj plotki', resultText: 'Nikt nie traci czasu na poszukiwania.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_priest',
    title: 'Wędrowny kapłan',
    description: 'Kapłan innej wiary prosi o możliwość odprawienia nabożeństwa.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wysłuchaj go',
        resultText: 'Nabożeństwo przynosi otuchę części mieszkańców.',
        effect: EventEffect(moraleDelta: 5),
      ),
      EventOption(
        label: 'Odpraw go',
        resultText: 'Kapłan odchodzi bez słowa, a część mieszkańców czuje się pozbawiona otuchy.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_animal_trader',
    title: 'Handlarz zwierzętami',
    description: 'Handlarz oferuje zdrowe zwierzęta gospodarskie na sprzedaż.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup zwierzęta',
        resultText: 'Nowe zwierzęta wzbogacają gospodarstwa.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4, ResourceType.grass: 6}),
      ),
      EventOption(label: 'Odmów', resultText: 'Handlarz jedzie dalej.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_neighbor_famine',
    title: 'Głód u sąsiadów',
    description: 'Sąsiednia wioska dotknięta klęską nieurodzaju prosi o żywność.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Podziel się zapasami',
        resultText: 'Sąsiedzi długo pamiętają tę pomoc.',
        effect: EventEffect(
          resourceDelta: {ResourceType.grain: -5, ResourceType.apple: -5},
          moraleDelta: 6,
        ),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Sąsiedzi radzą sobie sami, urażeni odmową.',
        effect: EventEffect(moraleDelta: -4),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_herbalist',
    title: 'Wędrowny zielarz',
    description: 'Zielarz oferuje skuteczne leki ziołowe.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup leki',
        resultText: 'Leki poprawiają samopoczucie mieszkańców.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -3}, moraleDelta: 5),
      ),
      EventOption(label: 'Odmów', resultText: 'Zielarz rusza dalej.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_hunt',
    title: 'Wspólne polowanie',
    description: 'Myśliwi zapraszają do udziału we wspólnym polowaniu.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Dołącz',
        resultText: 'Polowanie przynosi dodatkowe zapasy.',
        effect: EventEffect(resourceDelta: {ResourceType.grass: 6}),
      ),
      EventOption(label: 'Zostań w domu', resultText: 'Życie toczy się normalnym trybem.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_wounded_horse',
    title: 'Ranny koń',
    description: 'Na drodze znaleziono rannego, porzuconego konia.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przygarnij konia',
        resultText: 'Koń po wyleczeniu staje się przydatny w gospodarstwie.',
        effect: EventEffect(resourceDelta: {ResourceType.grain: -2, ResourceType.stone: 4}),
      ),
      EventOption(label: 'Puść wolno', resultText: 'Koń odchodzi w swoją stronę.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_craftsman',
    title: 'Wędrowny rzemieślnik',
    description: 'Rzemieślnik szuka miejsca na warsztat w wiosce.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij go',
        resultText: 'Warsztat zaczyna przynosić korzyści.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -3, ResourceType.stone: 5}),
      ),
      EventOption(label: 'Odpraw go', resultText: 'Rzemieślnik szuka innej wioski.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_volunteers',
    title: 'Prośba o ochotników',
    description: 'Sąsiednia wioska prosi o wysłanie ochotników do wspólnej obrony.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wyślij ochotników',
        resultText: 'Sojusznicza pomoc wzmacnia relacje, ale osłabia szeregi.',
        effect: EventEffect(soldierDelta: -1, securityDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Wioska zatrzymuje wszystkich dla siebie.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_weapon_trade',
    title: 'Oferta handlu bronią',
    description: 'Kupiec oferuje broń przydatną do obrony wioski.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup broń',
        resultText: 'Lepiej uzbrojeni strażnicy czują się pewniej.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -5}, securityDelta: 6),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Kupiec jedzie dalej, a strażnicy zostają bez lepszego uzbrojenia.',
        effect: EventEffect(securityDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_suspicious_stranger',
    title: 'Podejrzany nieznajomy',
    description: 'Nieznajomy krąży po wiosce, wzbudzając niepokój.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przepytaj go',
        resultText: 'Nieznajomy okazuje się nieszkodliwy, straż jest czujniejsza.',
        effect: EventEffect(securityDelta: 5),
      ),
      EventOption(
        label: 'Zignoruj',
        resultText: 'Niepewność pozostaje w wiosce.',
        effect: EventEffect(securityDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_fortune_teller',
    title: 'Wędrowna wróżka',
    description: 'Wróżka oferuje przepowiednię przyszłości za opłatą.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zapłać za wróżbę',
        resultText: 'Przepowiednia dodaje otuchy mieszkańcom.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -2}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odpraw ją',
        resultText: 'Wróżka odchodzi z uśmiechem, choć niektórzy żałują niewysłuchanej przepowiedni.',
        effect: EventEffect(moraleDelta: -1),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_playground',
    title: 'Prośba o plac zabaw',
    description: 'Dzieci proszą o zbudowanie prostego placu zabaw.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zbuduj plac zabaw',
        resultText: 'Dzieci są zachwycone nowym miejscem do zabawy.',
        effect: EventEffect(resourceDelta: {ResourceType.wood: -4}, moraleDelta: 6),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Dzieci bawią się jak dotychczas, wyraźnie zawiedzione decyzją.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_orchard_investment',
    title: 'Inwestycja w sad',
    description: 'Ogrodnik proponuje inwestycję w rozszerzenie sadu.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zainwestuj',
        resultText: 'Nowe drzewka szybko zaczynają owocować.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4, ResourceType.apple: 7}),
      ),
      EventOption(label: 'Odmów', resultText: 'Sad pozostaje bez zmian.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_inheritance_dispute',
    title: 'Spór o dziedzictwo',
    description: 'Rodzina prosi o rozsądzenie sporu o dziedzictwo gospodarstwa.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Rozsądź sprawiedliwie',
        resultText: 'Rodzina godzi się z werdyktem.',
        effect: EventEffect(moraleDelta: 5),
      ),
      EventOption(
        label: 'Nie mieszaj się',
        resultText: 'Spór ciągnie się, psując relacje w wiosce.',
        effect: EventEffect(moraleDelta: -4),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_musician',
    title: 'Wędrowny muzyk',
    description: 'Muzyk szuka mecenasa, który sfinansuje jego pobyt.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wesprzyj muzyka',
        resultText: 'Muzyka umila wieczory całej wiosce.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -3}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Muzyk gra gdzie indziej, a wieczory w wiosce są trochę mniej radosne.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_mercenaries',
    title: 'Oferta najemników',
    description: 'Grupa najemników oferuje ochronę wioski za opłatą.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wynajmij ich',
        resultText: 'Najemnicy wzmacniają obronę na jakiś czas.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -6}, securityDelta: 7),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Wioska polega tylko na własnych siłach, bez dodatkowej ochrony najemników.',
        effect: EventEffect(securityDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_relative_letter',
    title: 'List od krewnego',
    description: 'List od dawno niewidzianego krewnego prosi o pomoc finansową.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wyślij pomoc',
        resultText: 'Krewny jest bardzo wdzięczny.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4}, moraleDelta: 4),
      ),
      EventOption(
        label: 'Zignoruj list',
        resultText: 'List zostaje bez odpowiedzi.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_risky_caravan',
    title: 'Ryzykowna karawana',
    description: 'Kupiec proponuje wysłanie karawany do odległego miasta.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wyślij karawanę',
        resultText: 'Karawana wraca z zyskiem, choć droga była trudna.',
        effect: EventEffect(resourceDelta: {ResourceType.wood: -4, ResourceType.coin: 9}),
      ),
      EventOption(label: 'Zrezygnuj', resultText: 'Wioska nie podejmuje ryzyka.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_elders_request',
    title: 'Prośba starszyzny',
    description: 'Starszyzna prosi o większy udział w decyzjach dotyczących wioski.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zgódź się',
        resultText: 'Starszyzna czuje się doceniona.',
        effect: EventEffect(moraleDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Starszyzna jest rozczarowana decyzją.',
        effect: EventEffect(moraleDelta: -4),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_abandoned_cart',
    title: 'Porzucony wóz',
    description: 'Na trakcie znaleziono porzucony wóz pełen towarów.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zwróć właścicielowi',
        resultText: 'Uczciwość zostaje doceniona przez okolicę.',
        effect: EventEffect(moraleDelta: 6),
      ),
      EventOption(
        label: 'Zatrzymaj towar',
        resultText: 'Wioska zyskuje towar, ale krążą plotki o nieuczciwości.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: 6}, moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_builder_plans',
    title: 'Plany budowniczego',
    description: 'Wędrowny budowniczy oferuje sprzedaż planów oszczędnej budowy.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup plany',
        resultText: 'Plany pozwalają zaoszczędzić materiały budowlane.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -3, ResourceType.wood: 6}),
      ),
      EventOption(label: 'Odrzuć ofertę', resultText: 'Wioska buduje po staremu.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_horse_race',
    title: 'Prośba o konia na wyścigi',
    description: 'Organizatorzy wyścigów proszą o użyczenie najlepszego konia.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Użycz konia',
        resultText: 'Koń wygrywa wyścig, przynosząc nagrodę.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: 6}),
      ),
      EventOption(label: 'Odmów', resultText: 'Koń zostaje bezpiecznie w stajni.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_pilgrims',
    title: 'Grupa pielgrzymów',
    description: 'Pielgrzymi proszą o nocleg w drodze do świętego miejsca.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Przyjmij ich',
        resultText: 'Pielgrzymi błogosławią wioskę za gościnność.',
        effect: EventEffect(resourceDelta: {ResourceType.grain: -3}, moraleDelta: 5),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Pielgrzymi szukają noclegu gdzie indziej, a odmowa gościny nie licuje z dobrą sławą wioski.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_new_crop',
    title: 'Nauka nowej uprawy',
    description: 'Wędrowiec oferuje nauczenie nowej metody uprawy zboża.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zapłać za naukę',
        resultText: 'Nowa metoda zwiększa plony.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4, ResourceType.grain: 7}),
      ),
      EventOption(label: 'Odmów', resultText: 'Wioska uprawia ziemię jak dotychczas.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_worker_conflict',
    title: 'Konflikt pracowników',
    description: 'Na budowie wybuchł spór między pracownikami.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Interweniuj',
        resultText: 'Spór zostaje szybko załagodzony.',
        effect: EventEffect(moraleDelta: 5),
      ),
      EventOption(
        label: 'Zignoruj',
        resultText: 'Spór odbija się na atmosferze pracy.',
        effect: EventEffect(moraleDelta: -4),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_debt_collector',
    title: 'Poborca długów',
    description: 'Wędrowny poborca żąda spłaty starego, zapomnianego długu.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Spłać dług',
        resultText: 'Sprawa zostaje zamknięta bez dalszych kłopotów.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -5}),
      ),
      EventOption(
        label: 'Odmów zapłaty',
        resultText: 'Poborca odchodzi zły, grożąc powrotem.',
        effect: EventEffect(moraleDelta: -3),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_shared_well',
    title: 'Wspólna studnia',
    description: 'Sąsiedzi proponują wspólną budowę studni na granicy wiosek.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Zbuduj wspólnie',
        resultText: 'Nowa studnia służy obu wioskom.',
        effect: EventEffect(resourceDelta: {ResourceType.stone: -4, ResourceType.water: 7}),
      ),
      EventOption(label: 'Odmów', resultText: 'Każda wioska radzi sobie sama.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_rare_animal',
    title: 'Rzadkie zwierzę gospodarskie',
    description: 'Handlarz oferuje rzadką, wartościową rasę zwierzęcia gospodarskiego.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup zwierzę',
        resultText: 'Zwierzę szybko staje się chlubą gospodarstwa.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -5, ResourceType.grass: 7}),
      ),
      EventOption(label: 'Odmów', resultText: 'Handlarz szuka innego nabywcy.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_chronicler',
    title: 'Kronikarz wioski',
    description: 'Wędrowny pisarz chce spisać kronikę historii wioski.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Pozwól mu',
        resultText: 'Mieszkańcy są dumni, że ich historia zostanie spisana.',
        effect: EventEffect(moraleDelta: 6),
      ),
      EventOption(
        label: 'Odmów',
        resultText: 'Historia wioski pozostaje niespisana, ku rozczarowaniu części mieszkańców.',
        effect: EventEffect(moraleDelta: -2),
      ),
    ],
  ),
  VillageEvent(
    id: 'choice_lend_tools',
    title: 'Prośba o narzędzia',
    description: 'Sąsiednia wioska prosi o pożyczenie narzędzi budowlanych.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Użycz narzędzi',
        resultText: 'Sąsiedzi są wdzięczni za pomoc.',
        effect: EventEffect(
          resourceDelta: {ResourceType.wood: -3, ResourceType.stone: -3},
          moraleDelta: 5,
        ),
      ),
      EventOption(label: 'Odmów', resultText: 'Wioska zatrzymuje narzędzia dla siebie.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_exotic_seeds',
    title: 'Egzotyczne nasiona',
    description: 'Tajemniczy kupiec oferuje egzotyczne nasiona nieznanych roślin.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Kup nasiona',
        resultText: 'Nowe rośliny zaskakująco dobrze plonują.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: -4, ResourceType.apple: 5, ResourceType.grain: 5}),
      ),
      EventOption(label: 'Odmów', resultText: 'Kupiec chowa nasiona z powrotem do sakwy.', effect: EventEffect()),
    ],
  ),
  VillageEvent(
    id: 'choice_tax_law',
    title: 'Nowe prawo podatkowe',
    description: 'Rada starszych proponuje wprowadzenie nowego, wyższego podatku.',
    kind: VillageEventKind.choice,
    options: [
      EventOption(
        label: 'Wprowadź podatek',
        resultText: 'Skarbiec rośnie, ale mieszkańcy są niezadowoleni.',
        effect: EventEffect(resourceDelta: {ResourceType.coin: 8}, moraleDelta: -5),
      ),
      EventOption(label: 'Odrzuć', resultText: 'Podatki pozostają bez zmian.', effect: EventEffect()),
    ],
  ),
];
