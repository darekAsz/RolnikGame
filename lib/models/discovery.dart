import '../services/app_locale.dart';
import 'discovery_translations_en.dart';
import 'resource_type.dart';

/// Odkrycia badane w Uczelni (BuildingKind.szkola) - trwałe, jednorazowo
/// wykupywane bonusy. Część dostępna od razu po zbudowaniu Uczelni (poziom
/// 1), reszta dopiero po jej rozbudowie do poziomu 2.
enum DiscoveryId {
  moves1,
  moves2,
  workers1,
  workers2,
  storageBonus,
  cartography,
  ruralMedicine,
  foodEfficiency,
  diplomacy,
  militarySmithing,
  fastGrowth,
  weatherForecast,
  earlyJoker,
  earlyBomb,
}

class Discovery {
  final DiscoveryId id;
  final String name;
  final String description;
  // 1 = dostępne po zbudowaniu Uczelni, 2 = wymaga jej rozbudowy.
  final int requiredBuildingLevel;
  final Map<ResourceType, int> cost;

  const Discovery({
    required this.id,
    required this.name,
    required this.description,
    required this.requiredBuildingLevel,
    required this.cost,
  });
}

extension DiscoveryLocalization on Discovery {
  String get localizedName =>
      AppLocale.instance.isEnglish ? (kDiscoveriesEn[id]?.name ?? name) : name;

  String get localizedDescription =>
      AppLocale.instance.isEnglish ? (kDiscoveriesEn[id]?.description ?? description) : description;
}

// Koszty stopniowane wg wartości efektu i wymaganego poziomu Uczelni:
// tanie usprawnienia poziomu 1 (13-20 złota, czasem + odrobina surowców)
// -> solidniejsze inwestycje poziomu 2 (20-33 złota + surowce, bo wymagają
// już rozbudowanej Uczelni, czyli dodatkowych 25 złota samo w sobie)
// -> Szczęśliwa passa/Wybuchowy zapał jako szczyt (33-47 złota + surowce) -
// to jedyne odkrycia zmieniające samą mechanikę match-3 na stałe, więc mają
// zostać najdroższe w całej Uczelni. Całość podniesiona o ~1/3 względem
// pierwotnych cen - odkrycia mają być trochę droższe, nie skokowo.
const List<Discovery> kDiscoveries = [
  Discovery(
    id: DiscoveryId.moves1,
    name: 'Podstawy agronomii',
    description: '+1 do bazowej liczby ruchów na planszy zbiorów.',
    requiredBuildingLevel: 1,
    cost: {ResourceType.coin: 13},
  ),
  Discovery(
    id: DiscoveryId.moves2,
    name: 'Zaawansowana agronomia',
    description: '+1 więcej do bazowej liczby ruchów (razem +2).',
    requiredBuildingLevel: 2,
    cost: {ResourceType.coin: 20},
  ),
  Discovery(
    id: DiscoveryId.workers1,
    name: 'Zarządzanie pracownikami I',
    description: 'Odblokowuje przydzielanie 1 pracownika do budynków dających premię.',
    requiredBuildingLevel: 1,
    cost: {ResourceType.coin: 20, ResourceType.wood: 13, ResourceType.stone: 13},
  ),
  Discovery(
    id: DiscoveryId.workers2,
    name: 'Zarządzanie pracownikami II',
    description: 'Zwiększa limit do 2 pracowników na budynek.',
    requiredBuildingLevel: 2,
    cost: {ResourceType.coin: 33, ResourceType.wood: 20, ResourceType.stone: 20},
  ),
  Discovery(
    id: DiscoveryId.storageBonus,
    name: 'Rachunkowość',
    description: 'Dodatkowe +150 do limitu magazynowania każdego surowca, niezależnie od Magazynu.',
    requiredBuildingLevel: 1,
    cost: {ResourceType.coin: 16, ResourceType.wood: 13},
  ),
  Discovery(
    id: DiscoveryId.ruralMedicine,
    name: 'Medycyna wiejska',
    description: 'Głód nie zabiera już mieszkańców - zostaje tylko kara do morale.',
    requiredBuildingLevel: 1,
    cost: {ResourceType.coin: 13, ResourceType.grain: 11},
  ),
  Discovery(
    id: DiscoveryId.foodEfficiency,
    name: 'Agronomia zapasowa',
    description: 'Mieszkańcy zużywają mniej zboża (1 zboże żywi więcej osób).',
    requiredBuildingLevel: 1,
    cost: {ResourceType.coin: 13, ResourceType.grain: 11},
  ),
  Discovery(
    id: DiscoveryId.weatherForecast,
    name: 'Meteorologia',
    description: 'Zwiększa szansę na pozytywne (zamiast negatywnego) wydarzenie losowe.',
    requiredBuildingLevel: 1,
    cost: {ResourceType.coin: 16},
  ),
  Discovery(
    id: DiscoveryId.cartography,
    name: 'Kartografia',
    description: 'Dodaje dodatkową kolumnę na planszy zbiorów, niezależnie od Okolic wioski.',
    requiredBuildingLevel: 2,
    cost: {ResourceType.coin: 27, ResourceType.wood: 20, ResourceType.stone: 20},
  ),
  Discovery(
    id: DiscoveryId.diplomacy,
    name: 'Dyplomacja',
    description: 'Poprawia kurs wymiany w Rynku - jeden z trzech niezależnych ulepszeń do '
        'najlepszego możliwego kursu (obok poziomu Rynku i przydzielonych pracowników).',
    requiredBuildingLevel: 2,
    cost: {ResourceType.coin: 20},
  ),
  Discovery(
    id: DiscoveryId.militarySmithing,
    name: 'Kowalstwo wojskowe',
    description: 'Zwiększa siłę każdego żołnierza o +1, niezależnie od poziomu Koszar.',
    requiredBuildingLevel: 2,
    cost: {ResourceType.coin: 24, ResourceType.stone: 13},
  ),
  Discovery(
    id: DiscoveryId.fastGrowth,
    name: 'Szybszy przyrost',
    description: 'Podwaja tempo przyrostu populacji (zależne od morale wioski), przy wystarczającym jedzeniu.',
    requiredBuildingLevel: 2,
    cost: {ResourceType.coin: 24, ResourceType.grain: 13},
  ),
  // Te dwa odkrycia mają zostać najdroższe w całej Uczelni - to jedyne,
  // które trwale zmieniają samą mechanikę match-3 (próg jokera/bomby),
  // nie tylko ekonomię wioski wokół niej.
  Discovery(
    id: DiscoveryId.earlyJoker,
    name: 'Szczęśliwa passa',
    description: 'Dziki joker pojawia się już przy ścieżce z 4 kafelków (zamiast 5).',
    requiredBuildingLevel: 2,
    cost: {
      ResourceType.coin: 33,
      ResourceType.wood: 27,
      ResourceType.stone: 27,
    },
  ),
  Discovery(
    id: DiscoveryId.earlyBomb,
    name: 'Wybuchowy zapał',
    description: 'Bomba pojawia się już przy ścieżce z 5 kafelków (zamiast 6).',
    requiredBuildingLevel: 2,
    cost: {
      ResourceType.coin: 47,
      ResourceType.wood: 33,
      ResourceType.stone: 33,
      ResourceType.grain: 20,
    },
  ),
];
