import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/area_kind.dart';
import '../models/comic.dart';
import '../models/discovery.dart';
import '../models/goal_requirement.dart';
import '../models/resource_type.dart';
import '../models/season.dart';
import '../models/side_quest.dart';
import '../models/story_act.dart';
import '../models/tutorial_step.dart';
import '../models/unit_type.dart';
import '../models/village_event.dart';
import '../services/area_storage.dart';
import '../services/board_style_storage.dart';
import '../services/checkpoint_storage.dart';
import '../services/comic_storage.dart';
import '../services/discovery_storage.dart';
import '../services/experience_storage.dart';
import '../services/game_progress_storage.dart';
import '../services/population_storage.dart';
import '../services/resource_icon_style_storage.dart';
import '../services/resource_storage.dart';
import '../services/shop_storage.dart';
import '../services/stats_storage.dart';
import '../services/story_progress_storage.dart';
import '../services/village_building_storage.dart';
import '../services/village_event_storage.dart';
import '../widgets/buildable_overview_sheet.dart';
import '../widgets/event_popup.dart';
import '../widgets/resource_icon.dart';
import '../widgets/tutorial_overlay.dart';
import '../widgets/unit_portrait.dart';
import '../widgets/village_board.dart';
import 'act_failure_screen.dart';
import 'bogdan_battle_screen.dart';
import 'boss_battle_screen.dart';
import 'boss_intro_screen.dart';
import 'comics_view.dart';
import 'debug_view.dart';
import 'ending_screen.dart';
import 'goals_view.dart';
import 'leszy_battle_screen.dart';
import 'harvest_screen.dart';
import 'resources_view.dart';
import 'shop_view.dart';
import 'stats_view.dart';
import 'surroundings_view.dart';
import 'village_view.dart';
import 'week_transition_screen.dart';
import 'marta_battle_screen.dart';

/// Główna "powłoka" gry: dolny pasek nawigacji (Wioska / Surowce / przejście
/// do kolejnego tygodnia) bez górnego AppBar, żeby plansza wioski mogła
/// zajmować prawie cały ekran.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Ratusz wymaga odblokowania wszystkich 7 surowców (patrz Okolice), więc
  // jego koszt to zamierzenie spory pierwszy "milowy" wydatek z każdego typu.
  static const Map<ResourceType, int> _ratuszCost = {
    ResourceType.grass: 15,
    ResourceType.grain: 15,
    ResourceType.wood: 20,
    ResourceType.stone: 15,
    ResourceType.water: 15,
    ResourceType.coin: 10,
    ResourceType.apple: 15,
  };
  static const Map<ResourceType, int> _palisadeCost = {
    ResourceType.wood: 20,
    ResourceType.stone: 15,
  };
  static const int _ratuszWeeklyBonus = 2;
  static const int _baseMovesConst = 10;
  // Maks. liczba dokupionych na stałe ruchów: +2 z samym Sklepem (poziom 1),
  // +4 więcej (razem +6) po rozbudowie do poziomu 2 - świadomie rosnący
  // skok, żeby rozbudowa (kosztująca dodatkowe 25 złota) była wyraźnie
  // odczuwalna, nie płaska progresja. Plus osobny bonus od pracowników
  // (patrz _maxExtraMoves) - w późnej grze i tak jest już dużo ruchów na
  // turę dzięki odkryciom w Uczelni, więc bazowy limit ma zostać niski.
  static const int _maxMovePurchasesBase = 2;
  static const int _sklepMovesCapBonus = 4;
  static const int _moveCoinBaseCost = 50;
  static const int _moveCoinCostIncrement = 15;
  static const int _moveWoodBaseCost = 15;
  static const int _moveWoodCostIncrement = 5;
  static const int _moveStoneBaseCost = 10;
  static const int _moveStoneCostIncrement = 5;
  // Poziom 1: automatyczne czwórki (i więcej). Poziom 2 (ulepszenie): też
  // trójki - realna zmiana samej mechaniki match-3, stąd wyraźnie wyższy koszt.
  static const Map<ResourceType, int> _autoMatchTier1Cost = {
    ResourceType.coin: 60,
    ResourceType.wood: 20,
    ResourceType.stone: 20,
  };
  static const Map<ResourceType, int> _autoMatchTier2Cost = {
    ResourceType.coin: 100,
    ResourceType.wood: 30,
    ResourceType.stone: 30,
  };
  static const int _basePopulation = 5;
  static const int _housePopulationBonus = 3;
  static const int _palisadePopulationBonus = 1;
  static const int _karczmaPopulationBonus = 2;
  static const int _baseSecurity = 0;
  static const int _palisadeSecurityBonus = 20;
  static const int _koszarySecurityBonusPerLevel = 5;
  static const int _baseMorale = 50;
  static const int _breweryMoraleBonus = 10;
  static const int _kaplicaMoraleBonus = 5;
  static const int _baseStorageCap = 100;
  // Za poziom Magazynu (nie mnożone przez pracowników, w odróżnieniu od
  // większości innych bonusów budynków - patrz _storageCap) i osobno, wprost
  // za każdego przydzielonego pracownika - prosty, addytywny model, tak samo
  // jak limit dokupywanych ruchów w Sklepie czy zniżka na Rynku.
  static const int _warehouseStorageBonusPerLevel = 50;
  static const int _warehouseWorkerStorageBonus = 25;
  static const int _weeklyProductionBonus = 3;
  static const int _kuzniaWeeklyGoldBonus = 2;
  static const int _szkolaMovesBonus = 1;
  // Kaplica zmniejsza ogólną szansę zepsucia (patrz kSpoiledChance), Studnia
  // dodatkowo zmniejsza ryzyko pożaru, a Spichlerz - ryzyko głodu; wszystkie
  // trzy redukcje sumują się i są ograniczane do kSpoiledChance w _spoiledChance.
  static const double _kaplicaRiskReductionPerLevel = 0.05;
  static const double _fireRiskReductionPerLevel = 0.03;
  static const double _hungerRiskReductionPerLevel = 0.03;
  // Kurs wymiany zawsze daje _marketReceiveAmount (1) - to, ile surowca
  // trzeba oddać, spada z 3 niezależnych ulepszeń: Rynek poziom 2 (-2),
  // odkrycie Dyplomacji (-2), przydzieleni pracownicy (0-2, -1 każdy). Bez
  // żadnego z nich kurs jest celowo surowy (8:1), z KOMPLETEM wszystkich
  // trzech dochodzi dokładnie do 2:1 - nigdy więcej, żeby handel nie stał
  // się darmowym generatorem surowców. Patrz _marketGiveAmount.
  static const int _marketGiveAmountBase = 8;
  static const int _marketGiveAmountBest = 2;
  static const int _marketReceiveAmount = 1;
  static const int _marketRynekLevelReduction = 2;
  static const int _marketDiscoveryReduction = 2;
  static const int _marketPerWorkerReduction = 1;
  // Koszary: rekrutacja żołnierzy (poziom 1, wymaga zbudowanej Kuźni na broń),
  // poziom 2 podwaja siłę każdego żołnierza (na razie tylko wskaźnik w
  // Statystykach - bez systemu walki). Koszt rekrutacji to złoto (wspólne dla
  // wszystkich typów) plus surowiec zależny od typu jednostki (patrz UnitType).
  // Koniec Aktu I - zamiast zwykłej rundy zbiorów rozgrywa się starcie z
  // Grotem (patrz BossBattleScreen).
  static const int _grotBattleWeek = 26;
  // Koniec Aktu II - starcie z Martą (patrz MartaBattleScreen).
  static const int _martaBattleWeek = 39;
  // Koniec Aktu III - starcie z Bogdanem (patrz BogdanBattleScreen).
  static const int _bogdanBattleWeek = 52;
  // Tydzień 64, w środku Aktu V (nie na jego końcu - po walce zostaje jeszcze
  // tydzień epilogu, patrz komiks #30 i StoryAct akt 5) - starcie z Leszym
  // (patrz LeszyBattleScreen). Jedyny boss, którego trzeba pokonać, żeby
  // tydzień w ogóle minął - porażka nie przesuwa historii dalej (patrz
  // _startWeek).
  static const int _leszyBattleWeek = 64;
  // Rozbudowa Ratusza do poziomu 2 odblokowuje się dopiero z Aktem II (tydzień
  // 27, patrz kStoryActs) - to też nowy cel główny tego aktu (patrz
  // _actGoalRequirements), więc gracz nie może "przeskoczyć" tego etapu
  // fabuły, rozbudowując Ratusz od razu w Akcie 0.
  static const int _ratuszLevel2UnlockWeek = 27;
  static const int _soldierRecruitCostGold = 3;
  // Rekrutacja zabiera jednego mieszkańca z wioski (zostaje żołnierzem) -
  // populacja spada tak samo jak przy głodzie, tylko od razu i celowo.
  static const int _soldierRecruitCostPopulation = 1;
  static const int _soldierStrengthMultiplierLevel2 = 2;
  // Każdy żołnierz zużywa co tydzień 1 jabłko; przy niedoborze dezerteruje
  // dokładnie tylu żołnierzy, ilu brakowało jabłek (patrz _startWeek).
  static const int _foodPerSoldierWeekly = 1;
  // _population to prawdziwy, trwały licznik obecnych mieszkańców (w
  // odróżnieniu od _populationLimit, który jest tylko pojemnością wynikającą
  // z budynków). Zjadają zboże - 1 zboże na każde _populationFoodDivisor
  // mieszkańców (czyli bazowo 1 mieszkaniec = 1 zboże); brakujące zboże jest
  // dobierane z jabłek jako zapasowe źródło jedzenia (patrz _startWeek), a
  // głód następuje dopiero, gdy zabraknie obu. Przy wystarczającej ilości
  // jedzenia i wolnym miejscu poniżej limitu populacja rośnie co tydzień -
  // tempo zależy od morale wioski, patrz _effectivePopulationGrowthRate;
  // przy głodzie maleje, a morale spada.
  static const int _populationFoodDivisor = 1;
  static const int _populationStarvationLoss = 1;
  static const int _populationStarvationMoraleLoss = 5;
  // Odkrycia z Uczelni, które dają stałe premie niezależne od innych
  // budynków (patrz models/discovery.dart).
  static const int _discoveryStorageBonus = 150;
  // +1 do dzielnika (1 -> 2), czyli 2 mieszkańców na 1 zboże zamiast 1:1.
  static const int _discoveryFoodDivisorBonus = 1;
  static const int _discoveryMilitaryBonus = 1;
  // Mnoży tempo przyrostu (zależne od morale) razy 2, zamiast dawać stały
  // dodatek - patrz _effectivePopulationGrowthRate.
  static const double _discoveryFastGrowthMultiplier = 2.0;
  static const double _discoveryWeatherForecastBonus = 0.15;
  // Koszt rozbudowy (poziom 2) - jednolity dla wszystkich budynków wioski,
  // czysta inwestycja złota niezależna od surowców poziomu 1.
  static const Map<ResourceType, int> _villageUpgradeCost = {ResourceType.coin: 25};
  static const Map<BuildingKind, ResourceType> _productionBuildings = {
    BuildingKind.spichlerz: ResourceType.apple,
    BuildingKind.piekarnia: ResourceType.grain,
    BuildingKind.tartak: ResourceType.wood,
    BuildingKind.studnia: ResourceType.water,
    BuildingKind.kamieniarz: ResourceType.stone,
    BuildingKind.kuznia: ResourceType.coin,
  };
  // Studnia i Spichlerz nie podwajają produkcji przy rozbudowie - ich poziom 2
  // zamiast tego dalej zmniejsza ryzyko (pożaru / głodu).
  static const Set<BuildingKind> _productionDoublingExempt = {
    BuildingKind.studnia,
    BuildingKind.spichlerz,
  };

  int _tab = 0;
  bool _loaded = false;
  bool _busy = false;
  int _week = 1;
  int _population = _basePopulation;
  // Ułamkowa reszta z przyrostu populacji zależnego od morale - patrz
  // _effectivePopulationGrowthRate. Trzyma się w [0, 1), odkładana między
  // tygodniami, żeby np. stałe 0,5/tydzień faktycznie dawało +1 co dwa tygodnie.
  double _populationGrowthProgress = 0.0;
  Set<DiscoveryId> _unlockedDiscoveries = {};
  Set<int> _resolvedActs = {};
  int _lastStarvationWeek = 0;
  int _bossBattleStagesCleared = -1;
  int _martaBattleStagesCleared = -1;
  bool _martaFullTrust = false;
  int _bogdanProofComplete = -1;
  bool _leszyVictorious = false;
  Set<SideQuestId> _claimedSideQuests = {};
  Set<int> _readComics = {};
  bool _ratuszBuilt = false;
  bool _palisadeBuilt = false;
  BoardStyle _boardStyle = BoardStyle.photo;
  ResourceIconStyle _resourceIconStyle = ResourceIconStyle.orb;
  int _extraMoves = 0;
  int _autoMatchTier = 0;
  Map<AreaKind, bool> _areasBuilt = {
    for (final area in AreaKind.values) area: false,
  };
  Map<AreaKind, bool> _areasUpgraded = {
    for (final area in AreaKind.values) area: false,
  };
  Map<BuildingKind, bool> _villageBuilt = {
    for (final kind in kExtraBuildingKinds) kind: false,
  };
  Map<BuildingKind, bool> _villageUpgraded = {
    for (final kind in kAllBuildingKinds) kind: false,
  };
  Map<BuildingKind, int> _villageWorkers = {
    for (final kind in kAllBuildingKinds) kind: 0,
  };
  List<bool> _extraHousesBuilt = List.filled(kExtraHouseCount, false);
  // Domyślnie true - fałsz tylko dla zaniedbanych domów odziedziczonych na
  // starcie gry, dopóki gracz ich nie odbuduje (patrz _onTapExtraHouse).
  List<bool> _extraHousesActive = List.filled(kExtraHouseCount, true);
  // Prawdziwa rozbudowa (poziom 2, podwaja premię) - niezależna od aktywacji.
  List<bool> _extraHousesUpgraded = List.filled(kExtraHouseCount, false);
  Map<UnitType, int> _soldierCounts = {
    for (final type in UnitType.values) type: 0,
  };
  int _eventMoraleBonus = 0;
  int _eventSecurityBonus = 0;
  int _eventPopulationBonus = 0;
  final _random = Random();
  Map<ResourceType, int> _stockpile = {
    for (final type in ResourceType.values) type: 0,
  };
  GameStats _stats = const GameStats(totalCollected: 0, longestPath: 0, maxSingleHarvest: 0);

  bool _upgradedL2(BuildingKind kind) => _villageUpgraded[kind] ?? false;

  // 0 = niezbudowana, 1 = zbudowana, 2 = rozbudowana - skala trudności dla
  // MartaBattleScreen (przygotowanie duchowe/społeczne zamiast wojska).
  int get _kaplicaLevel {
    if (!(_villageBuilt[BuildingKind.kaplica] ?? false)) return 0;
    return _upgradedL2(BuildingKind.kaplica) ? 2 : 1;
  }

  /// "Zbudowany" ujednolicony dla wszystkich 17 rodzajów budynków - Ratusz i
  /// Palisada mają własne, osobne flagi (_ratuszBuilt/_palisadeBuilt), reszta
  /// jest w _villageBuilt.
  bool _isBuilt(BuildingKind kind) {
    switch (kind) {
      case BuildingKind.ratusz:
        return _ratuszBuilt;
      case BuildingKind.palisade:
        return _palisadeBuilt;
      default:
        return _villageBuilt[kind] ?? false;
    }
  }

  bool _hasDiscovery(DiscoveryId id) => _unlockedDiscoveries.contains(id);

  /// Przydzielanie pracowników jest zablokowane, dopóki w Uczelni nie odkryje
  /// się "Zarządzania pracownikami" (0 = zablokowane, 1/2 = limit na budynek).
  int get _maxWorkersPerBuilding {
    if (_hasDiscovery(DiscoveryId.workers2)) return 2;
    if (_hasDiscovery(DiscoveryId.workers1)) return 1;
    return 0;
  }

  int _workersFor(BuildingKind kind) => _villageWorkers[kind] ?? 0;
  int get _totalWorkersAssigned => _villageWorkers.values.fold(0, (a, b) => a + b);

  /// Wolni mieszkańcy, których można jeszcze przydzielić jako pracowników -
  /// różnica między limitem populacji a już przydzielonymi pracownikami.
  int get _availableWorkers => (_populationLimit - _totalWorkersAssigned).clamp(0, 1 << 30);

  /// Każdy pracownik zwiększa premię budynku o +50% (maks. 2 pracowników =
  /// podwójna premia).
  double _workerMultiplier(BuildingKind kind) => 1.0 + 0.5 * _workersFor(kind);

  int _scaled(int amount, BuildingKind kind) => (amount * _workerMultiplier(kind)).round();

  /// Premia budynku (poziom 1 + poziom 2, jeśli rozbudowany) PRZED premią od
  /// pracowników - "co produkuje budynek sam z siebie".
  int _tieredBaseAmount(BuildingKind kind, int perLevel) {
    if (!_isBuilt(kind)) return 0;
    var amount = perLevel;
    if (_upgradedL2(kind)) amount += perLevel;
    return amount;
  }

  double _tieredBaseFraction(BuildingKind kind, double perLevel) {
    if (!_isBuilt(kind)) return 0;
    var amount = perLevel;
    if (_upgradedL2(kind)) amount += perLevel;
    return amount;
  }

  /// Łączna premia (poziom 1 + poziom 2, jeśli rozbudowany) danego budynku,
  /// przeskalowana przez liczbę przydzielonych pracowników.
  int _tieredBonus(BuildingKind kind, int perLevel) =>
      _scaled(_tieredBaseAmount(kind, perLevel), kind);

  double _tieredFraction(BuildingKind kind, double perLevel) =>
      _tieredBaseFraction(kind, perLevel) * _workerMultiplier(kind);

  Future<void> _setWorkers(BuildingKind kind, int count) async {
    final clamped = count.clamp(0, _maxWorkersPerBuilding);
    final current = _workersFor(kind);
    if (clamped == current) return;
    if (clamped > current && _availableWorkers < (clamped - current)) return;
    setState(() {
      _villageWorkers[kind] = clamped;
    });
    await VillageBuildingStorage.setWorkers(kind, clamped);
  }

  int get _baseMoves {
    var total = _baseMovesConst;
    if (_hasDiscovery(DiscoveryId.moves1)) total += _szkolaMovesBonus;
    if (_hasDiscovery(DiscoveryId.moves2)) total += _szkolaMovesBonus;
    return total;
  }

  // Pracownicy dają tu prosty, addytywny +1 do limitu za osobę (nie
  // dawny mnożnik _scaled/_workerMultiplier, który podwajał bonus budynku -
  // to właśnie było źródło "12 ruchów do wykupienia" zamiast zamierzonych
  // max. 4/6, patrz historia tej stałej).
  int get _maxExtraMoves =>
      _maxMovePurchasesBase +
      (_upgradedL2(BuildingKind.sklep) ? _sklepMovesCapBonus : 0) +
      _workersFor(BuildingKind.sklep).clamp(0, _maxWorkersPerBuilding);

  int get _maxTotalMoves => _baseMoves + _maxExtraMoves;

  /// Ile surowca trzeba oddać na Rynku za _marketReceiveAmount - spada z 3
  /// niezależnych ulepszeń: Rynek poziom 2 (-_marketRynekLevelReduction),
  /// odkrycie Dyplomacji (-_marketDiscoveryReduction), przydzieleni
  /// pracownicy (0-2, -_marketPerWorkerReduction każdy). Bez żadnego z nich
  /// kurs to _marketGiveAmountBase (surowy), z kompletem wszystkich trzech
  /// dochodzi dokładnie do _marketGiveAmountBest (2:1) - nigdy więcej.
  int get _marketGiveAmount {
    var reduction = 0;
    if (_upgradedL2(BuildingKind.rynek)) reduction += _marketRynekLevelReduction;
    if (_hasDiscovery(DiscoveryId.diplomacy)) reduction += _marketDiscoveryReduction;
    reduction += _workersFor(BuildingKind.rynek).clamp(0, _maxWorkersPerBuilding) * _marketPerWorkerReduction;
    return (_marketGiveAmountBase - reduction).clamp(_marketGiveAmountBest, _marketGiveAmountBase);
  }

  int get _populationLimit {
    var total = _basePopulation;
    total += _tieredBonus(BuildingKind.dom, _housePopulationBonus);
    total += _tieredBonus(BuildingKind.karczma, _karczmaPopulationBonus);
    total += _tieredBonus(BuildingKind.palisade, _palisadePopulationBonus);
    for (var i = 0; i < kExtraHouseCount; i++) {
      if (!_extraHousesBuilt[i] || !_extraHousesActive[i]) continue;
      total += _extraHousesUpgraded[i] ? _housePopulationBonus * 2 : _housePopulationBonus;
    }
    total += _eventPopulationBonus;
    return (total).clamp(0, 1 << 30);
  }

  double get _spoiledChance {
    var reduction = 0.0;
    reduction += _tieredFraction(BuildingKind.kaplica, _kaplicaRiskReductionPerLevel);
    reduction += _tieredFraction(BuildingKind.studnia, _fireRiskReductionPerLevel);
    reduction += _tieredFraction(BuildingKind.spichlerz, _hungerRiskReductionPerLevel);
    return (kSpoiledChance - reduction).clamp(0.0, kSpoiledChance);
  }

  double get _moraleValue {
    var total = _baseMorale.toDouble();
    total += _tieredBonus(BuildingKind.browar, _breweryMoraleBonus);
    total += _tieredBonus(BuildingKind.kaplica, _kaplicaMoraleBonus);
    total += _eventMoraleBonus;
    // Bezpieczeństwo dokłada się do morale ułamkowo (np. 40 bezpieczeństwa = +0,4 morale).
    total += _securityValue / 100;
    return total.clamp(0.0, 100.0);
  }

  int get _storageCap =>
      _baseStorageCap +
      _tieredBaseAmount(BuildingKind.magazyn, _warehouseStorageBonusPerLevel) +
      _workersFor(BuildingKind.magazyn).clamp(0, _maxWorkersPerBuilding) * _warehouseWorkerStorageBonus +
      (_hasDiscovery(DiscoveryId.storageBonus) ? _discoveryStorageBonus : 0);

  int _strengthFor(UnitType type) {
    final base = type.baseStrength * (_upgradedL2(BuildingKind.koszary) ? _soldierStrengthMultiplierLevel2 : 1);
    return _scaled(base, BuildingKind.koszary) +
        (_hasDiscovery(DiscoveryId.militarySmithing) ? _discoveryMilitaryBonus : 0);
  }

  int get _totalArmyStrength => [
        for (final type in UnitType.values) (_soldierCounts[type] ?? 0) * _strengthFor(type),
      ].fold(0, (a, b) => a + b);

  int get _securityValue {
    var total = _baseSecurity;
    total += _tieredBonus(BuildingKind.palisade, _palisadeSecurityBonus);
    total += _tieredBonus(BuildingKind.koszary, _koszarySecurityBonusPerLevel);
    total += _eventSecurityBonus;
    return total.clamp(0, 1 << 30);
  }

  bool get _shopUnlocked => _villageBuilt[BuildingKind.sklep] ?? false;
  bool get _marketUnlocked => _villageBuilt[BuildingKind.rynek] ?? false;

  int get _ratuszWeeklyBonusValue =>
      _scaled(_ratuszWeeklyBonus * (_upgradedL2(BuildingKind.ratusz) ? 2 : 1), BuildingKind.ratusz);

  int _productionBaseAmountFor(BuildingKind kind) {
    var amount = kind == BuildingKind.kuznia ? _kuzniaWeeklyGoldBonus : _weeklyProductionBonus;
    if (_upgradedL2(kind) && !_productionDoublingExempt.contains(kind)) amount *= 2;
    return amount;
  }

  int _productionAmountFor(BuildingKind kind) => _scaled(_productionBaseAmountFor(kind), kind);

  /// Projekcja produkcji tygodniowej wg surowca na podstawie obecnego stanu
  /// budynków - używana zarówno przez _startWeek, jak i podsumowanie w
  /// Statystykach, żeby liczby się nigdy nie rozjechały.
  Map<ResourceType, int> get _weeklyProductionByType {
    final result = <ResourceType, int>{};
    if (_ratuszBuilt) {
      for (final type in kGoalEligibleTypes.where(_unlockedTypes.contains)) {
        result[type] = (result[type] ?? 0) + _ratuszWeeklyBonusValue;
      }
    }
    for (final entry in _productionBuildings.entries) {
      if ((_villageBuilt[entry.key] ?? false) && _unlockedTypes.contains(entry.value)) {
        result[entry.value] = (result[entry.value] ?? 0) + _productionAmountFor(entry.key);
      }
    }
    return result;
  }

  /// To samo co _weeklyProductionByType, ale z rozbiciem na źródła (który
  /// budynek daje ile) - używane w rozwijanym wierszu w Statystykach/
  /// Surowcach, żeby gracz widział, co dokładnie produkuje dany surowiec.
  Map<ResourceType, List<(String, int)>> get _weeklyProductionSourcesByType {
    final l10n = AppLocalizations.of(context)!;
    final result = <ResourceType, List<(String, int)>>{};
    if (_ratuszBuilt) {
      for (final type in kGoalEligibleTypes.where(_unlockedTypes.contains)) {
        (result[type] ??= []).add((l10n.homeBuildingNameRatusz, _ratuszWeeklyBonusValue));
      }
    }
    for (final entry in _productionBuildings.entries) {
      if ((_villageBuilt[entry.key] ?? false) && _unlockedTypes.contains(entry.value)) {
        (result[entry.value] ??= []).add((entry.key.label, _productionAmountFor(entry.key)));
      }
    }
    return result;
  }

  /// Zboże zjadane co tydzień przez zwykłych mieszkańców (limit populacji) -
  /// patrz _populationFoodDivisor.
  int get _effectivePopulationFoodDivisor =>
      _populationFoodDivisor + (_hasDiscovery(DiscoveryId.foodEfficiency) ? _discoveryFoodDivisorBonus : 0);

  int get _populationFoodConsumption => (_population / _effectivePopulationFoodDivisor).ceil();

  // Tempo przyrostu w mieszkańcach/tydzień jest teraz ułamkowe i zależne od
  // morale wioski: 100% morale = +1/tydzień, 50% morale = +0,5/tydzień, 0%
  // morale = brak przyrostu. Odkrycie "Szybszy przyrost" PODWAJA to tempo
  // (nie dodaje stałej wartości). Ułamkowa reszta jest odkładana między
  // tygodniami - patrz _populationGrowthProgress.
  double get _effectivePopulationGrowthRate {
    final base = _moraleValue / 100.0;
    return _hasDiscovery(DiscoveryId.fastGrowth) ? base * _discoveryFastGrowthMultiplier : base;
  }

  int get _effectivePopulationStarvationLoss =>
      _hasDiscovery(DiscoveryId.ruralMedicine) ? 0 : _populationStarvationLoss;

  /// Projekcja zużycia tygodniowego wg surowca - jabłka dla żołnierzy, zboże
  /// dla zwykłych mieszkańców.
  Map<ResourceType, int> get _weeklyConsumptionByType {
    final result = <ResourceType, int>{};
    final totalSoldiers = _soldierCounts.values.fold(0, (a, b) => a + b);
    if (totalSoldiers > 0) {
      result[ResourceType.apple] = totalSoldiers * _foodPerSoldierWeekly;
    }
    final populationFood = _populationFoodConsumption;
    if (populationFood > 0) {
      result[ResourceType.grain] = populationFood;
    }
    return result;
  }

  /// To samo co _weeklyConsumptionByType, ale z rozbiciem na źródła.
  Map<ResourceType, List<(String, int)>> get _weeklyConsumptionSourcesByType {
    final l10n = AppLocalizations.of(context)!;
    final result = <ResourceType, List<(String, int)>>{};
    final totalSoldiers = _soldierCounts.values.fold(0, (a, b) => a + b);
    if (totalSoldiers > 0) {
      result[ResourceType.apple] = [(l10n.homeSourceSoldiers, totalSoldiers * _foodPerSoldierWeekly)];
    }
    final populationFood = _populationFoodConsumption;
    if (populationFood > 0) {
      result[ResourceType.grain] = [(l10n.homeSourceResidents, populationFood)];
    }
    return result;
  }

  Map<ResourceType, int> _villageCostFor(BuildingKind kind) {
    switch (kind) {
      case BuildingKind.sklep:
        return const {ResourceType.wood: 12, ResourceType.stone: 8, ResourceType.coin: 8};
      case BuildingKind.karczma:
        return const {ResourceType.wood: 15, ResourceType.stone: 10};
      case BuildingKind.dom:
        return const {ResourceType.wood: 10, ResourceType.stone: 6};
      case BuildingKind.kuznia:
        return const {ResourceType.wood: 15, ResourceType.stone: 12};
      case BuildingKind.spichlerz:
        return const {ResourceType.wood: 15, ResourceType.stone: 10};
      case BuildingKind.piekarnia:
        return const {ResourceType.wood: 15, ResourceType.stone: 10};
      case BuildingKind.tartak:
        return const {ResourceType.wood: 12, ResourceType.stone: 10};
      case BuildingKind.studnia:
        return const {ResourceType.wood: 12, ResourceType.stone: 10};
      case BuildingKind.browar:
        return const {ResourceType.wood: 12, ResourceType.stone: 8, ResourceType.coin: 6};
      case BuildingKind.kaplica:
        return const {ResourceType.wood: 15, ResourceType.stone: 10, ResourceType.coin: 8};
      case BuildingKind.szkola:
        return const {ResourceType.wood: 18, ResourceType.stone: 12, ResourceType.coin: 10};
      case BuildingKind.rynek:
        return const {ResourceType.wood: 18, ResourceType.stone: 12, ResourceType.coin: 10};
      case BuildingKind.magazyn:
        return const {ResourceType.wood: 20, ResourceType.stone: 15};
      case BuildingKind.kamieniarz:
        return const {ResourceType.wood: 12, ResourceType.stone: 8};
      case BuildingKind.koszary:
        return const {ResourceType.wood: 20, ResourceType.stone: 15, ResourceType.coin: 12};
      default:
        return const {};
    }
  }

  String _villageBonusTextFor(BuildingKind kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case BuildingKind.sklep:
        return l10n.homeBonusSklep;
      case BuildingKind.karczma:
        return l10n.homeBonusPopulation(_karczmaPopulationBonus);
      case BuildingKind.dom:
        return l10n.homeBonusPopulation(_housePopulationBonus);
      case BuildingKind.kuznia:
        return l10n.homeBonusKuznia(_kuzniaWeeklyGoldBonus);
      case BuildingKind.spichlerz:
        return l10n.homeBonusSpichlerz(_weeklyProductionBonus, _pct(_hungerRiskReductionPerLevel));
      case BuildingKind.piekarnia:
        return l10n.homeBonusPiekarnia(_weeklyProductionBonus);
      case BuildingKind.tartak:
        return l10n.homeBonusTartak(_weeklyProductionBonus);
      case BuildingKind.studnia:
        return l10n.homeBonusStudnia(_weeklyProductionBonus, _pct(_fireRiskReductionPerLevel));
      case BuildingKind.browar:
        return l10n.homeBonusMorale(_breweryMoraleBonus);
      case BuildingKind.kaplica:
        return l10n.homeBonusKaplica(_pct(_kaplicaRiskReductionPerLevel), _kaplicaMoraleBonus);
      case BuildingKind.szkola:
        return l10n.homeBonusSzkola;
      case BuildingKind.rynek:
        return l10n.homeBonusRynek(_marketGiveAmountBase, _marketReceiveAmount, _marketGiveAmountBest);
      case BuildingKind.magazyn:
        return l10n.homeBonusMagazyn(_warehouseStorageBonusPerLevel);
      case BuildingKind.kamieniarz:
        return l10n.homeBonusKamieniarz(_weeklyProductionBonus);
      case BuildingKind.koszary:
        return l10n.homeBonusKoszary(_koszarySecurityBonusPerLevel, _foodPerSoldierWeekly);
      default:
        return '';
    }
  }

  String _pct(double fraction) => '${(fraction * 100).round()}%';

  /// Opis premii poziomu 2 (rozbudowy) - wyświetlany w oknie budynku obok
  /// (lub zamiast) premii poziomu 1, analogicznie do _showAreaDialog.
  String _villageUpgradeTextFor(BuildingKind kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case BuildingKind.ratusz:
        return l10n.homeUpgradeRatusz(_ratuszWeeklyBonus * 2);
      case BuildingKind.palisade:
        return l10n.homeUpgradePalisade(_palisadePopulationBonus, _palisadePopulationBonus * 2,
            _palisadeSecurityBonus, _palisadeSecurityBonus * 2);
      case BuildingKind.sklep:
        return l10n.homeUpgradeSklep(_sklepMovesCapBonus);
      case BuildingKind.karczma:
        return l10n.homeUpgradePopulation(_karczmaPopulationBonus, _karczmaPopulationBonus * 2);
      case BuildingKind.dom:
        return l10n.homeUpgradePopulation(_housePopulationBonus, _housePopulationBonus * 2);
      case BuildingKind.kuznia:
        return l10n.homeUpgradeKuznia(_kuzniaWeeklyGoldBonus, _kuzniaWeeklyGoldBonus * 2);
      case BuildingKind.spichlerz:
        return l10n.homeUpgradeSpichlerz(
            _pct(_hungerRiskReductionPerLevel), _pct(_hungerRiskReductionPerLevel * 2));
      case BuildingKind.piekarnia:
        return l10n.homeUpgradePiekarnia(_weeklyProductionBonus, _weeklyProductionBonus * 2);
      case BuildingKind.tartak:
        return l10n.homeUpgradeTartak(_weeklyProductionBonus, _weeklyProductionBonus * 2);
      case BuildingKind.studnia:
        return l10n.homeUpgradeStudnia(
            _pct(_fireRiskReductionPerLevel), _pct(_fireRiskReductionPerLevel * 2));
      case BuildingKind.browar:
        return l10n.homeUpgradeBrowar(_breweryMoraleBonus, _breweryMoraleBonus * 2);
      case BuildingKind.kaplica:
        return l10n.homeUpgradeKaplica(_kaplicaMoraleBonus, _kaplicaMoraleBonus * 2);
      case BuildingKind.szkola:
        return l10n.homeUpgradeSzkola;
      case BuildingKind.rynek:
        final afterUpgrade = (_marketGiveAmount - _marketRynekLevelReduction)
            .clamp(_marketGiveAmountBest, _marketGiveAmountBase);
        return l10n.homeUpgradeRynek(afterUpgrade, _marketReceiveAmount, _marketGiveAmountBest);
      case BuildingKind.magazyn:
        return l10n.homeUpgradeMagazyn(
            _warehouseStorageBonusPerLevel, _warehouseStorageBonusPerLevel * 2);
      case BuildingKind.kamieniarz:
        return l10n.homeUpgradeKamieniarz(_weeklyProductionBonus, _weeklyProductionBonus * 2);
      case BuildingKind.koszary:
        return l10n.homeUpgradeKoszary(_koszarySecurityBonusPerLevel, _koszarySecurityBonusPerLevel * 2);
    }
  }

  /// "$label: baza X$unit, pracownicy +Y$unit → premia ogólna Z$unit" (albo
  /// samo "$label: X$unit", jeśli budynek nie ma jeszcze pracowników).
  String _bonusLine(AppLocalizations l10n, String label, num base, num total, String unit) {
    final workerBonus = total - base;
    if (workerBonus == 0) return l10n.homeBonusLineSimple(label, base, unit);
    final sign = workerBonus > 0 ? '+' : '';
    return l10n.homeBonusLineWithWorkers(label, base, unit, sign, workerBonus, total);
  }

  String _bonusPercentLine(AppLocalizations l10n, String label, double base, double total) {
    if (base == total) return l10n.homeBonusPercentSimple(label, _pct(base));
    return l10n.homeBonusPercentWithWorkers(label, _pct(base), _pct(total));
  }

  /// Rozbicie premii budynku na "co produkuje sam budynek" / "ile dają
  /// pracownicy" / "premia ogólna razem" - pokazywane w oknie budynku, żywo
  /// aktualizowane przy zmianie liczby przydzielonych pracowników.
  List<String> _bonusBreakdownFor(BuildingKind kind) {
    final l10n = AppLocalizations.of(context)!;
    switch (kind) {
      case BuildingKind.ratusz:
        final base = _ratuszWeeklyBonus * (_upgradedL2(kind) ? 2 : 1);
        return [_bonusLine(l10n, l10n.homeLabelResourceProduction, base, _ratuszWeeklyBonusValue, '/tydz.')];
      case BuildingKind.palisade:
        return [
          _bonusLine(l10n, l10n.homeLabelPopulationLimit, _tieredBaseAmount(kind, _palisadePopulationBonus),
              _tieredBonus(kind, _palisadePopulationBonus), ''),
          _bonusLine(l10n, l10n.homeLabelSecurity, _tieredBaseAmount(kind, _palisadeSecurityBonus),
              _tieredBonus(kind, _palisadeSecurityBonus), ''),
        ];
      case BuildingKind.sklep:
        if (!_upgradedL2(kind)) {
          return [l10n.homeSklepLockedBonusNote];
        }
        return [
          l10n.homeSklepMovesBonusText(
              _maxExtraMoves, _workersFor(kind).clamp(0, _maxWorkersPerBuilding)),
        ];
      case BuildingKind.karczma:
        return [
          _bonusLine(l10n, l10n.homeLabelPopulationLimit, _tieredBaseAmount(kind, _karczmaPopulationBonus),
              _tieredBonus(kind, _karczmaPopulationBonus), ''),
        ];
      case BuildingKind.dom:
        return [
          _bonusLine(l10n, l10n.homeLabelPopulationLimit, _tieredBaseAmount(kind, _housePopulationBonus),
              _tieredBonus(kind, _housePopulationBonus), ''),
        ];
      case BuildingKind.kuznia:
        return [
          _bonusLine(l10n, l10n.homeLabelGoldPerWeek, _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
        ];
      case BuildingKind.spichlerz:
        return [
          _bonusLine(l10n, l10n.homeLabelAppleProductionPerWeek, _productionBaseAmountFor(kind),
              _productionAmountFor(kind), ''),
          _bonusPercentLine(l10n, l10n.homeLabelHungerRiskReduction,
              _tieredBaseFraction(kind, _hungerRiskReductionPerLevel),
              _tieredFraction(kind, _hungerRiskReductionPerLevel)),
        ];
      case BuildingKind.piekarnia:
        return [
          _bonusLine(l10n, l10n.homeLabelGrainProductionPerWeek, _productionBaseAmountFor(kind),
              _productionAmountFor(kind), ''),
        ];
      case BuildingKind.tartak:
        return [
          _bonusLine(l10n, l10n.homeLabelWoodProductionPerWeek, _productionBaseAmountFor(kind),
              _productionAmountFor(kind), ''),
        ];
      case BuildingKind.studnia:
        return [
          _bonusLine(l10n, l10n.homeLabelWaterProductionPerWeek, _productionBaseAmountFor(kind),
              _productionAmountFor(kind), ''),
          _bonusPercentLine(l10n, l10n.homeLabelFireRiskReduction,
              _tieredBaseFraction(kind, _fireRiskReductionPerLevel),
              _tieredFraction(kind, _fireRiskReductionPerLevel)),
        ];
      case BuildingKind.browar:
        return [
          _bonusLine(l10n, l10n.homeLabelVillageMorale, _tieredBaseAmount(kind, _breweryMoraleBonus),
              _tieredBonus(kind, _breweryMoraleBonus), ''),
        ];
      case BuildingKind.kaplica:
        return [
          _bonusPercentLine(l10n, l10n.homeLabelSpoilRiskReduction,
              _tieredBaseFraction(kind, _kaplicaRiskReductionPerLevel),
              _tieredFraction(kind, _kaplicaRiskReductionPerLevel)),
          _bonusLine(l10n, l10n.homeLabelVillageMorale, _tieredBaseAmount(kind, _kaplicaMoraleBonus),
              _tieredBonus(kind, _kaplicaMoraleBonus), ''),
        ];
      case BuildingKind.szkola:
        // Uczelnia nie ma standardowej premii budynku - jej efekt to dostęp
        // do odkryć (patrz _uczelniaDiscoveryPanel), pokazywany zamiast tej
        // sekcji.
        return const [];
      case BuildingKind.rynek:
        // Własny tekst zamiast _bonusLine, bo kurs zależy od 3 niezależnych
        // czynników naraz (poziom Rynku, Dyplomacja, pracownicy), nie tylko
        // od pracowników - patrz komentarz przy _marketGiveAmount.
        return [
          l10n.homeMarketRateBonus(_marketGiveAmount, _marketReceiveAmount, _marketGiveAmountBest),
        ];
      case BuildingKind.magazyn:
        final base = _tieredBaseAmount(kind, _warehouseStorageBonusPerLevel);
        final withWorkers = base +
            _workersFor(kind).clamp(0, _maxWorkersPerBuilding) * _warehouseWorkerStorageBonus;
        return [
          _bonusLine(l10n, l10n.homeLabelWarehouseLimit, base, withWorkers, ''),
        ];
      case BuildingKind.kamieniarz:
        return [
          _bonusLine(l10n, l10n.homeLabelStoneProductionPerWeek, _productionBaseAmountFor(kind),
              _productionAmountFor(kind), ''),
        ];
      case BuildingKind.koszary:
        return [
          _bonusLine(l10n, l10n.homeLabelSecurity, _tieredBaseAmount(kind, _koszarySecurityBonusPerLevel),
              _tieredBonus(kind, _koszarySecurityBonusPerLevel), ''),
        ];
    }
  }

  int get _totalMoves => _baseMoves + _extraMoves;
  Map<ResourceType, int> get _nextMoveCost => {
        ResourceType.coin: _moveCoinBaseCost + _extraMoves * _moveCoinCostIncrement,
        ResourceType.wood: _moveWoodBaseCost + _extraMoves * _moveWoodCostIncrement,
        ResourceType.stone: _moveStoneBaseCost + _extraMoves * _moveStoneCostIncrement,
      };

  Map<ResourceType, int> _costFor(AreaKind area) {
    switch (area) {
      case AreaKind.orchard:
        return const {ResourceType.wood: 7, ResourceType.stone: 8};
      case AreaKind.meadow:
        return const {ResourceType.wood: 9, ResourceType.stone: 10, ResourceType.apple: 8};
      case AreaKind.field:
        return const {
          ResourceType.wood: 11,
          ResourceType.stone: 12,
          ResourceType.apple: 10,
          ResourceType.grass: 8,
        };
      // Las to teraz czwarty (a nie ostatni) teren w kolejności odblokowania
      // (patrz AreaKind.prerequisite), więc jego drewno jest obniżone razem
      // z pierwszymi trzema - w przeciwieństwie do Rzeki/Gór, które zostają
      // przy pełnym koszcie jako faktycznie ostatni etap ścieżki.
      case AreaKind.forest:
        return const {
          ResourceType.wood: 14,
          ResourceType.stone: 15,
          ResourceType.apple: 12,
          ResourceType.grass: 10,
          ResourceType.grain: 10,
        };
      case AreaKind.river:
      case AreaKind.mountains:
        return const {
          ResourceType.wood: 18,
          ResourceType.stone: 15,
          ResourceType.apple: 12,
          ResourceType.grass: 10,
          ResourceType.grain: 10,
        };
    }
  }

  // Poziom 2 (rozbudowa) to inwestycja złota, niezależna od łańcucha
  // surowców poziomu 1 - odblokowuje możliwość wyboru tego surowca jako
  // "surowca tygodnia" na planszy zbiorów.
  Map<ResourceType, int> _upgradeCostFor(AreaKind area) => const {ResourceType.coin: 20};

  // Kolejność wyświetlania zgodna ze ścieżką odblokowania w
  // SurroundingsView._path - to tylko kolejność w oknie "co można teraz
  // zbudować" (patrz _buildableAreaEntries), bez wspólnego źródła prawdy z
  // tamtym plikiem, stąd niewielka duplikacja tej samej listy.
  static const _areaDisplayOrder = [
    AreaKind.orchard,
    AreaKind.meadow,
    AreaKind.field,
    AreaKind.forest,
    AreaKind.river,
    AreaKind.mountains,
  ];

  /// Okolice, których wymóg (poprzednik w łańcuchu, patrz AreaKind.prerequisite)
  /// jest już spełniony, ale które nie są jeszcze zbudowane - do okna "co
  /// można teraz zbudować" (showBuildableOverviewSheet).
  List<BuildableOverviewEntry> _buildableAreaEntries() {
    final entries = <BuildableOverviewEntry>[];
    for (final area in _areaDisplayOrder) {
      if (_areasBuilt[area] ?? false) continue;
      final prereq = area.prerequisite;
      if (prereq != null && !(_areasBuilt[prereq] ?? false)) continue;
      entries.add(BuildableOverviewEntry(
        title: area.label,
        icon: resourceIconAsset(area.resourceType.assetPath, size: 28),
        cost: _costFor(area),
      ));
    }
    return entries;
  }

  /// Budynki wioski, których wymóg (wszystkie surowce odblokowane przez
  /// Okolice, a dla wszystkiego poza samym Ratuszem - też zbudowany Ratusz,
  /// patrz _allResourcesUnlocked) jest już spełniony, ale które nie są
  /// jeszcze zbudowane.
  List<BuildableOverviewEntry> _buildableBuildingEntries() {
    if (!_allResourcesUnlocked) return const [];
    final entries = <BuildableOverviewEntry>[];
    for (final kind in BuildingKind.values) {
      final built = switch (kind) {
        BuildingKind.ratusz => _ratuszBuilt,
        BuildingKind.palisade => _palisadeBuilt,
        _ => _villageBuilt[kind] ?? false,
      };
      if (built) continue;
      if (kind != BuildingKind.ratusz && !_ratuszBuilt) continue;
      final cost = switch (kind) {
        BuildingKind.ratusz => _ratuszCost,
        BuildingKind.palisade => _palisadeCost,
        _ => _villageCostFor(kind),
      };
      entries.add(BuildableOverviewEntry(
        title: kind.label,
        icon: Icon(kind.icon, color: kind.color, size: 26),
        cost: cost,
      ));
    }
    return entries;
  }

  Set<ResourceType> get _unlockedTypes => {
        ...kStarterResourceTypes,
        ResourceType.coin,
        for (final area in AreaKind.values)
          if (!area.isStarterResource && (_areasBuilt[area] ?? false)) area.resourceType,
      };

  Set<ResourceType> get _bonusTypes => {
        for (final area in AreaKind.values)
          if (area.isStarterResource && (_areasBuilt[area] ?? false)) area.resourceType,
      };

  // Budowa jakiegokolwiek budynku wioski, włącznie z Ratuszem, jest
  // zablokowana, dopóki gracz nie odblokuje wszystkich 7 surowców przez
  // rozwinięcie Okolic (Sad -> Łąka -> Pole) - to wymusza kolejność zgodną
  // z fabułą Aktu 0: najpierw okolice, potem Ratusz, potem reszta wioski.
  bool get _allResourcesUnlocked =>
      _unlockedTypes.length == ResourceType.values.length - kBattleOnlyResourceTypes.length;

  String get _resourcesNotUnlockedMessage =>
      AppLocalizations.of(context)!.homeResourcesNotUnlockedMessage;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _load();
    if (!mounted) return;
    await _showPendingComics();
    if (!mounted) return;
    await _maybeStartTour();
  }

  bool _tourActive = false;
  int _tourStepIndex = 0;
  List<TutorialStep> _tourSteps = [];
  List<int?> _tourStepTab = [];
  final GlobalKey _navBarKey = GlobalKey();
  final GlobalKey _tabContentKey = GlobalKey();
  final GlobalKey _startWeekButtonKey = GlobalKey();

  /// Samouczek wioski/zakładek z podświetleniem na żywo - pokazuje się tylko
  /// raz (patrz GameProgressStorage.markTutorialSeen), po pierwszym
  /// wczytaniu gry i ewentualnych komiksach, żeby po kolei przejść przez
  /// każdy ekran, zanim gracz zacznie samodzielnie klikać. Odtwarzalny w
  /// dowolnym momencie przyciskiem w Statystykach - patrz _startTour,
  /// wywoływane stąd i z StatsView.onReplayTutorial.
  Future<void> _maybeStartTour() async {
    final progress = await GameProgressStorage.load();
    if (!mounted || progress.tutorialSeen) return;
    await GameProgressStorage.markTutorialSeen();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startTour();
    });
  }

  // Dopasowanie po ikonie zakładki (te same stałe co w _tabs) - prościej niż
  // osobny identyfikator na _TabSpec tylko dla samouczka.
  String _tourTabDescription(AppLocalizations l10n, IconData icon) {
    if (icon == Icons.home_work) return l10n.homeTutorialVillageDesc;
    if (icon == Icons.terrain) return l10n.homeTutorialSurroundingsDesc;
    if (icon == Icons.backpack) return l10n.homeTutorialResourcesDesc;
    if (icon == Icons.storefront) return l10n.homeTutorialShopDesc;
    if (icon == Icons.bar_chart) return l10n.homeTutorialStatsDesc;
    return l10n.homeTutorialGoalsDesc;
  }

  /// Buduje i uruchamia samouczek od nowa, na podstawie AKTUALNIE dostępnych
  /// zakładek (patrz _tabs - np. Sklep dochodzi dopiero po jego zbudowaniu),
  /// więc odtworzony później pokazuje więcej ekranów niż za pierwszym razem.
  void _startTour() {
    final l10n = AppLocalizations.of(context)!;
    final tabs = _tabs;
    final steps = <TutorialStep>[
      TutorialStep(
        targetKey: _navBarKey,
        title: l10n.homeTutorialNavBarTitle,
        description: l10n.homeTutorialNavBarDesc,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
      ),
    ];
    final stepTabs = <int?>[null];
    for (var i = 0; i < tabs.length; i++) {
      steps.add(TutorialStep(
        targetKey: _tabContentKey,
        title: tabs[i].label,
        description: _tourTabDescription(l10n, tabs[i].icon),
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.zero,
      ));
      stepTabs.add(i);
    }
    steps.add(TutorialStep(
      targetKey: _startWeekButtonKey,
      title: l10n.homeTutorialArrowTitle,
      description: l10n.homeTutorialArrowDesc,
    ));
    stepTabs.add(null);
    setState(() {
      _tourSteps = steps;
      _tourStepTab = stepTabs;
      _tourStepIndex = 0;
      _tourActive = true;
      _tab = 0;
    });
  }

  void _tourGoTo(int index) {
    if (index < 0) return;
    if (index >= _tourSteps.length) {
      _finishTour();
      return;
    }
    setState(() {
      _tourStepIndex = index;
      final targetTab = _tourStepTab[index];
      if (targetTab != null) _tab = targetTab;
    });
  }

  void _finishTour() {
    setState(() => _tourActive = false);
  }

  // Komiksy #10/#15/#20/#29 opisują WYNIK starcia z bossem (Grot/Marta/
  // Bogdan/Leszy) - odblokowanie ich czysto po numerze tygodnia zdradzałoby
  // wynik walki, zanim gracz w ogóle w nią wejdzie (tydzień "domyka się" w
  // _startWeek dopiero PO walce, ale sam numer tygodnia jest już aktualny
  // wcześniej - patrz _showPendingComics/_openComics). Domyślnie true dla
  // każdego innego komiksu - blokada dotyczy tylko tej czwórki.
  bool _isComicRevealed(int comicNumber) {
    switch (comicNumber) {
      case 10:
        return _bossBattleStagesCleared >= 0;
      case 15:
        return _martaBattleStagesCleared >= 0;
      case 20:
        return _bogdanProofComplete >= 0;
      case 29:
        return _leszyVictorious;
      default:
        return true;
    }
  }

  Set<int> get _hiddenComicNumbers =>
      {10, 15, 20, 29}.where((n) => !_isComicRevealed(n)).toSet();

  Future<void> _showPendingComics() async {
    final pending = comicsUnlockedThroughWeek(_week)
        .where((c) => !_readComics.contains(c.number) && _isComicRevealed(c.number))
        .toList();
    for (final comic in pending) {
      await _markComicRead(comic.number);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ComicReaderScreen(comic: comic)),
      );
      if (!mounted) return;
    }
  }

  Future<void> _load() async {
    final progress = await GameProgressStorage.load();
    final stockpile = await ResourceStorage.load();
    final stats = await StatsStorage.load();
    final areasBuilt = await AreaStorage.load();
    final areasUpgraded = await AreaStorage.loadUpgraded();
    final extraMoves = await ShopStorage.loadExtraMoves();
    final autoMatchTier = await ShopStorage.loadAutoMatchTier();
    final villageBuilt = await VillageBuildingStorage.load();
    final villageUpgraded = await VillageBuildingStorage.loadAllUpgraded();
    final villageWorkers = await VillageBuildingStorage.loadAllWorkers();
    final extraHousesBuilt = await VillageBuildingStorage.loadExtraHouses();
    final extraHousesActive = await VillageBuildingStorage.loadExtraHousesActive();
    final extraHousesUpgraded = await VillageBuildingStorage.loadExtraHousesUpgraded();
    final eventMoraleBonus = await VillageEventStorage.loadMoraleBonus();
    final eventSecurityBonus = await VillageEventStorage.loadSecurityBonus();
    final eventPopulationBonus = await VillageEventStorage.loadPopulationBonus();
    final storedPopulation = await PopulationStorage.load();
    final storedGrowthProgress = await PopulationStorage.loadGrowthProgress();
    final unlockedDiscoveries = await DiscoveryStorage.load();
    final resolvedActs = await StoryProgressStorage.loadResolvedActs();
    final lastStarvationWeek = await StoryProgressStorage.loadLastStarvationWeek();
    final bossBattleStagesCleared = await StoryProgressStorage.loadBossBattleStagesCleared();
    final martaBattleStagesCleared = await StoryProgressStorage.loadMartaBattleStagesCleared();
    final martaFullTrust = await StoryProgressStorage.loadMartaFullTrust();
    final bogdanProofComplete = await StoryProgressStorage.loadBogdanProofComplete();
    final leszyVictorious = await StoryProgressStorage.loadLeszyVictorious();
    final claimedSideQuests = await ExperienceStorage.loadClaimedSideQuests();
    final readComics = await ComicStorage.loadRead();
    final boardStyle = await BoardStyleStorage.load();
    final resourceIconStyle = await ResourceIconStyleStorage.load();
    if (!mounted) return;
    setState(() {
      _extraMoves = extraMoves;
      _autoMatchTier = autoMatchTier;
      _week = progress.week;
      _ratuszBuilt = progress.ratuszBuilt;
      _palisadeBuilt = progress.palisadeBuilt;
      _stockpile = stockpile;
      _stats = stats;
      _soldierCounts = stats.soldierCounts;
      _areasBuilt = areasBuilt;
      _areasUpgraded = areasUpgraded;
      _villageBuilt = villageBuilt;
      _villageUpgraded = villageUpgraded;
      _villageWorkers = villageWorkers;
      _extraHousesBuilt = extraHousesBuilt;
      _extraHousesActive = extraHousesActive;
      _extraHousesUpgraded = extraHousesUpgraded;
      _eventMoraleBonus = eventMoraleBonus;
      _eventSecurityBonus = eventSecurityBonus;
      _eventPopulationBonus = eventPopulationBonus;
      _population = storedPopulation ?? _basePopulation;
      _populationGrowthProgress = storedGrowthProgress;
      _unlockedDiscoveries = unlockedDiscoveries;
      _resolvedActs = resolvedActs;
      _lastStarvationWeek = lastStarvationWeek;
      _bossBattleStagesCleared = bossBattleStagesCleared;
      _martaBattleStagesCleared = martaBattleStagesCleared;
      _martaFullTrust = martaFullTrust;
      _bogdanProofComplete = bogdanProofComplete;
      _leszyVictorious = leszyVictorious;
      _claimedSideQuests = claimedSideQuests;
      _readComics = readComics;
      _boardStyle = boardStyle;
      _resourceIconStyle = resourceIconStyle;
      _loaded = true;
    });
    // Jeśli limit populacji spadł (np. zburzono budynek) poniżej obecnej
    // liczby mieszkańców, przycinamy ją do nowego limitu.
    if (_population > _populationLimit) {
      setState(() => _population = _populationLimit);
      await PopulationStorage.save(_population);
    }
    // Zapis sprzed obniżenia limitu dokupionych ruchów (patrz historia stałej
    // _maxMovePurchasesBase) mógł zapamiętać więcej ruchów, niż pozwala
    // obecny limit - bez tego przycięcia pasek w Sklepie potrafił pokazać
    // np. "20 / 12" (dokupione > obecny maks.).
    if (_extraMoves > _maxExtraMoves) {
      setState(() => _extraMoves = _maxExtraMoves);
      await ShopStorage.saveExtraMoves(_extraMoves);
    }
    // Jeśli limit pracowników spadł (np. odkrycie jeszcze niewykupione po
    // wprowadzeniu tej funkcji), przycinamy istniejące przydziały.
    for (final kind in kAllBuildingKinds) {
      final current = _workersFor(kind);
      if (current > _maxWorkersPerBuilding) {
        setState(() => _villageWorkers[kind] = _maxWorkersPerBuilding);
        await VillageBuildingStorage.setWorkers(kind, _maxWorkersPerBuilding);
      }
    }
    // Self-healing: bieżący tydzień powinien zawsze mieć zapisany checkpoint
    // (normalnie robi to _saveCheckpoint na końcu poprzedniego _startWeek),
    // ale nowa gra go nie tworzy dla tygodnia 1, a stare zapisy sprzed
    // dodania "Zagraj tydzień ponownie" też go nie mają - bez tego ten
    // przycisk nie miałby czego przywrócić.
    if (await CheckpointStorage.load(_week) == null) {
      await _saveCheckpoint();
    }
  }

  Future<void> _setBoardStyle(BoardStyle style) async {
    setState(() => _boardStyle = style);
    await BoardStyleStorage.save(style);
  }

  Future<void> _setResourceIconStyle(ResourceIconStyle style) async {
    setState(() => _resourceIconStyle = style);
    await ResourceIconStyleStorage.save(style);
  }

  void _showSnack(String message) {
    showEventPopup(context, message);
  }

  bool _canAfford(Map<ResourceType, int> cost) =>
      cost.entries.every((e) => (_stockpile[e.key] ?? 0) >= e.value);

  /// Dodatkowe potwierdzenie przed faktycznym zburzeniem - "Zburz" w oknie
  /// budynku otwiera to okno zamiast od razu wykonywać akcję.
  Future<bool> _confirmDemolish(BuildContext dialogContext, String name) async {
    final l10n = AppLocalizations.of(dialogContext)!;
    final confirmed = await showDialog<bool>(
      context: dialogContext,
      builder: (context) => AlertDialog(
        title: Text(l10n.homeConfirmDemolishTitle),
        content: Text(l10n.homeConfirmDemolishMessage(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.homeCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC0392B)),
            child: Text(l10n.homeDemolish),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _onTapRatusz() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_ratuszBuilt && !_allResourcesUnlocked) {
      _showSnack(_resourcesNotUnlockedMessage);
      return;
    }
    final level2 = _upgradedL2(BuildingKind.ratusz);
    final action = await _showBuildingDialog(
      title: l10n.homeBuildingNameRatusz,
      kind: BuildingKind.ratusz,
      level1: _ratuszBuilt,
      level2: level2,
      cost: _ratuszCost,
      upgradeCost: _villageUpgradeCost,
      bonusText: l10n.homeRatuszBonusText(_ratuszWeeklyBonus),
      upgradeText: _villageUpgradeTextFor(BuildingKind.ratusz),
      demolishable: false,
    );

    if (action == 'build' && !_ratuszBuilt) {
      setState(() {
        for (final entry in _ratuszCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _ratuszBuilt = true;
      });
      await ResourceStorage.save(_stockpile);
      await GameProgressStorage.setRatuszBuilt(true);
    } else if (action == 'upgrade' && _ratuszBuilt && !level2) {
      setState(() {
        for (final entry in _villageUpgradeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _villageUpgraded[BuildingKind.ratusz] = true;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setUpgraded(BuildingKind.ratusz, true);
      _showSnack(l10n.homeRatuszUpgradedSnack);
    }
  }

  Future<void> _onTapPalisade() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_palisadeBuilt && !_allResourcesUnlocked) {
      _showSnack(_resourcesNotUnlockedMessage);
      return;
    }
    final level2 = _upgradedL2(BuildingKind.palisade);
    final action = await _showBuildingDialog(
      title: l10n.homeBuildingNamePalisade,
      kind: BuildingKind.palisade,
      level1: _palisadeBuilt,
      level2: level2,
      cost: _palisadeCost,
      upgradeCost: _villageUpgradeCost,
      bonusText: l10n.homePalisadeBonusText(_palisadePopulationBonus, _palisadeSecurityBonus),
      upgradeText: _villageUpgradeTextFor(BuildingKind.palisade),
    );

    if (action == 'build' && !_palisadeBuilt) {
      setState(() {
        for (final entry in _palisadeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _palisadeBuilt = true;
      });
      await ResourceStorage.save(_stockpile);
      await GameProgressStorage.setPalisadeBuilt(true);
    } else if (action == 'upgrade' && _palisadeBuilt && !level2) {
      setState(() {
        for (final entry in _villageUpgradeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _villageUpgraded[BuildingKind.palisade] = true;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setUpgraded(BuildingKind.palisade, true);
      _showSnack(l10n.homePalisadeUpgradedSnack);
    } else if (action == 'demolish' && _palisadeBuilt) {
      setState(() {
        for (final entry in _palisadeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
        }
        if (level2) {
          for (final entry in _villageUpgradeCost.entries) {
            _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
          }
        }
        _palisadeBuilt = false;
        _villageUpgraded[BuildingKind.palisade] = false;
        _villageWorkers[BuildingKind.palisade] = 0;
      });
      await ResourceStorage.save(_stockpile);
      await GameProgressStorage.setPalisadeBuilt(false);
      await VillageBuildingStorage.setUpgraded(BuildingKind.palisade, false);
      await VillageBuildingStorage.setWorkers(BuildingKind.palisade, 0);
      _showSnack(l10n.homePalisadeDemolishedSnack);
    }
  }

  // Puste działki na planszy wioski to na razie tylko dekoracja - nie mają
  // jeszcze przypisanej treści, więc kliknięcie w nie celowo nic nie robi.
  void _onTapEmptyPlot() {}

  bool get _kuzniaBuilt => _villageBuilt[BuildingKind.kuznia] ?? false;

  bool _canAffordUnit(UnitType type) {
    if (_population < _soldierRecruitCostPopulation) return false;
    if ((_stockpile[ResourceType.coin] ?? 0) < _soldierRecruitCostGold) return false;
    return type.recruitCost.entries.every((e) => (_stockpile[e.key] ?? 0) >= e.value);
  }

  Future<void> _recruitSoldier(UnitType type) async {
    if (!_kuzniaBuilt || !_canAffordUnit(type)) return;
    setState(() {
      _stockpile[ResourceType.coin] =
          (_stockpile[ResourceType.coin] ?? 0) - _soldierRecruitCostGold;
      for (final entry in type.recruitCost.entries) {
        _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
      }
      _population = (_population - _soldierRecruitCostPopulation).clamp(0, _populationLimit);
      _soldierCounts[type] = (_soldierCounts[type] ?? 0) + 1;
    });
    await ResourceStorage.save(_stockpile);
    await PopulationStorage.save(_population);
    await StatsStorage.saveSoldierCount(type, _soldierCounts[type] ?? 0);
  }

  Widget _koszaryRecruitPanel(BuildContext context, StateSetter setDialogState) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.homeMilitaryTitle, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(l10n.homeMilitaryTotalStrength(_totalArmyStrength)),
        Text(
          l10n.homeMilitaryAvailableResidents(_population),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (!_kuzniaBuilt) ...[
          const SizedBox(height: 8),
          Text(
            l10n.homeMilitaryRequiresForge,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ] else ...[
          if (_population < _soldierRecruitCostPopulation) ...[
            const SizedBox(height: 8),
            Text(
              l10n.homeMilitaryNotEnoughResidents,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
          for (final type in UnitType.values) ...[
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UnitPortrait(type: type, size: 40),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeMilitaryUnitLine(
                            type.label, _soldierCounts[type] ?? 0, _strengthFor(type)),
                      ),
                      const SizedBox(height: 4),
                      FilledButton(
                        onPressed: _canAffordUnit(type)
                            ? () async {
                                await _recruitSoldier(type);
                                setDialogState(() {});
                              }
                            : null,
                        child: Text(
                          l10n.homeMilitaryRecruitButton(
                            _soldierRecruitCostPopulation,
                            _soldierRecruitCostGold,
                            type.recruitCost.entries
                                .map((e) => ', -${e.value} ${e.key.label.toLowerCase()}')
                                .join(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Future<void> _unlockDiscovery(DiscoveryId id) async {
    if (_hasDiscovery(id)) return;
    final discovery = kDiscoveries.firstWhere((d) => d.id == id);
    if (!_canAfford(discovery.cost)) return;
    setState(() {
      for (final entry in discovery.cost.entries) {
        _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
      }
      _unlockedDiscoveries.add(id);
    });
    await ResourceStorage.save(_stockpile);
    await DiscoveryStorage.setUnlocked(id, true);
    // Odkrycie limitu pracowników może od razu podnieść limit wcześniej
    // przydzielonych - nic tu nie robimy, _maxWorkersPerBuilding po prostu
    // zacznie zwracać wyższą wartość.
  }

  Widget _uczelniaDiscoveryPanel(BuildContext context, StateSetter setDialogState) {
    final l10n = AppLocalizations.of(context)!;
    final uczelniaLevel = _upgradedL2(BuildingKind.szkola) ? 2 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.homeDiscoveriesTitle, style: Theme.of(context).textTheme.labelLarge),
        for (final discovery in kDiscoveries) ...[
          const SizedBox(height: 10),
          _discoveryRow(context, setDialogState, discovery, uczelniaLevel),
        ],
      ],
    );
  }

  Widget _discoveryRow(
    BuildContext context,
    StateSetter setDialogState,
    Discovery discovery,
    int uczelniaLevel,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final unlocked = _hasDiscovery(discovery.id);
    final locked = discovery.requiredBuildingLevel > uczelniaLevel;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(discovery.localizedName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(discovery.localizedDescription, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          if (unlocked)
            Text(
              l10n.homeDiscoveryUnlocked,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F9E57)),
            )
          else if (locked)
            Text(
              l10n.homeDiscoveryRequiresLevel(discovery.requiredBuildingLevel),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
            )
          else
            FilledButton(
              onPressed: _canAfford(discovery.cost)
                  ? () async {
                      await _unlockDiscovery(discovery.id);
                      setDialogState(() {});
                    }
                  : null,
              child: Text(
                l10n.homeDiscoveryUnlockButton(
                  discovery.cost.entries.map((e) => '-${e.value} ${e.key.label.toLowerCase()}').join(', '),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTapVillageBuilding(BuildingKind kind) async {
    final l10n = AppLocalizations.of(context)!;
    final builtNow = _villageBuilt[kind] ?? false;
    if (!builtNow && !_allResourcesUnlocked) {
      _showSnack(_resourcesNotUnlockedMessage);
      return;
    }
    final level2 = _upgradedL2(kind);
    final cost = _villageCostFor(kind);
    Widget Function(BuildContext, StateSetter)? extraContentBuilder;
    if (builtNow && kind == BuildingKind.koszary) {
      extraContentBuilder = _koszaryRecruitPanel;
    } else if (builtNow && kind == BuildingKind.szkola) {
      extraContentBuilder = _uczelniaDiscoveryPanel;
    }
    final action = await _showBuildingDialog(
      title: kind.label,
      kind: kind,
      level1: builtNow,
      level2: level2,
      cost: cost,
      upgradeCost: _villageUpgradeCost,
      bonusText: _villageBonusTextFor(kind),
      upgradeText: _villageUpgradeTextFor(kind),
      // Dom (tak jak Uczelnia) nie ma żadnej premii zależnej od pracowników -
      // limit populacji z Domu rośnie tylko z jego poziomu (patrz
      // _bonusBreakdownFor), więc panel pracowników byłby tu czysto
      // dekoracyjny i mylący (sugerowałby efekt, którego nie ma). Dodatkowe
      // działki pod dodatkowe domy (_onTapExtraHouse) już konsekwentnie go
      // nie pokazują - to ujednolica oba miejsca.
      showWorkers: kind != BuildingKind.szkola && kind != BuildingKind.dom,
      extraContentBuilder: extraContentBuilder,
    );

    if (action == 'build' && !builtNow) {
      setState(() {
        for (final entry in cost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _villageBuilt[kind] = true;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setBuilt(kind, true);
    } else if (action == 'upgrade' && builtNow && !level2) {
      setState(() {
        for (final entry in _villageUpgradeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _villageUpgraded[kind] = true;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setUpgraded(kind, true);
      _showSnack(l10n.homeBuildingUpgradedSnack(kind.label));
    } else if (action == 'demolish' && builtNow) {
      setState(() {
        for (final entry in cost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
        }
        if (level2) {
          for (final entry in _villageUpgradeCost.entries) {
            _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
          }
        }
        _villageBuilt[kind] = false;
        _villageUpgraded[kind] = false;
        _villageWorkers[kind] = 0;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setBuilt(kind, false);
      await VillageBuildingStorage.setUpgraded(kind, false);
      await VillageBuildingStorage.setWorkers(kind, 0);
      _showSnack(l10n.homeBuildingDemolishedSnack(kind.label));
    }
  }

  /// Dodatkowe, niezależne działki pod zwykłe domy - każda budowalna osobno,
  /// za ten sam koszt, premię i rozbudowę co budynek "Dom" na standardowej
  /// działce (_onTapVillageBuilding). Dwa z pięciu startują jako "zaniedbane"
  /// (odziedziczone po Antonim, patrz SplashScreen._newGame) - trzeba je
  /// najpierw odbudować (osobny, wcześniejszy krok niżej), zanim staną się w
  /// pełni aktywne i będzie można je rozbudować do prawdziwego poziomu 2.
  Future<void> _onTapExtraHouse(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final builtNow = _extraHousesBuilt[index];
    final activeNow = _extraHousesActive[index];
    final decrepit = builtNow && !activeNow;
    if (!builtNow && !_allResourcesUnlocked) {
      _showSnack(_resourcesNotUnlockedMessage);
      return;
    }
    final cost = _villageCostFor(BuildingKind.dom);

    if (decrepit) {
      final action = await _showBuildingDialog(
        title: l10n.homeBuildingNameDom,
        kind: BuildingKind.dom,
        level1: true,
        level2: false,
        cost: cost,
        upgradeCost: _villageUpgradeCost,
        showWorkers: false,
        demolishable: false,
        upgradeRequiresRatuszLevel2: false,
        levelLabel: l10n.homeLevel0,
        upgradeSectionLabel: l10n.homeRebuildToLevel1,
        notDemolishableText: l10n.homeDecrepitHouseNotDemolishable,
        bonusText: l10n.homeDecrepitHouseBonusText,
        upgradeText: l10n.homeDecrepitHouseUpgradeText(_housePopulationBonus),
      );
      if (action == 'upgrade') {
        setState(() {
          for (final entry in _villageUpgradeCost.entries) {
            _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
          }
          _extraHousesActive[index] = true;
        });
        await ResourceStorage.save(_stockpile);
        await VillageBuildingStorage.setExtraHouseActive(index, true);
        _showSnack(l10n.homeHouseRebuiltSnack);
      }
      return;
    }

    final upgradedNow = builtNow && _extraHousesUpgraded[index];
    final action = await _showBuildingDialog(
      title: l10n.homeBuildingNameDom,
      kind: BuildingKind.dom,
      level1: builtNow,
      level2: upgradedNow,
      cost: cost,
      upgradeCost: _villageUpgradeCost,
      showWorkers: false,
      bonusText: _villageBonusTextFor(BuildingKind.dom),
      upgradeText: _villageUpgradeTextFor(BuildingKind.dom),
    );

    if (action == 'build' && !builtNow) {
      setState(() {
        for (final entry in cost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _extraHousesBuilt[index] = true;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setExtraHouseBuilt(index, true);
    } else if (action == 'upgrade' && builtNow && !upgradedNow) {
      setState(() {
        for (final entry in _villageUpgradeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _extraHousesUpgraded[index] = true;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setExtraHouseUpgraded(index, true);
      _showSnack(l10n.homeBuildingUpgradedSnack(l10n.homeBuildingNameDom));
    } else if (action == 'demolish' && builtNow) {
      setState(() {
        for (final entry in cost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
        }
        if (upgradedNow) {
          for (final entry in _villageUpgradeCost.entries) {
            _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
          }
        }
        _extraHousesBuilt[index] = false;
        _extraHousesActive[index] = true;
        _extraHousesUpgraded[index] = false;
      });
      await ResourceStorage.save(_stockpile);
      await VillageBuildingStorage.setExtraHouseBuilt(index, false);
      await VillageBuildingStorage.setExtraHouseActive(index, true);
      await VillageBuildingStorage.setExtraHouseUpgraded(index, false);
      _showSnack(l10n.homeHouseDemolishedSnack);
    }
  }

  Future<void> _showTradeDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final types = _unlockedTypes.toList();
    if (types.length < 2) return;
    final giveAmount = _marketGiveAmount;
    final receiveAmount = _marketReceiveAmount;
    var give = types.first;
    var receive = types.firstWhere((t) => t != give);
    // Ile jednorazowych wymian na raz - żeby nie trzeba było klikać "Wymień"
    // osobno dla każdej porcji giveAmount. Resetowane do 1 przy zmianie
    // surowca (posiadany zapas, więc i maksimum, mogą się mocno różnić).
    var multiplier = 1;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final receiveOptions = types.where((t) => t != give).toList();
          final maxMultiplier = (_stockpile[give] ?? 0) ~/ giveAmount;
          final canTrade = maxMultiplier > 0 && multiplier <= maxMultiplier;
          final totalGive = giveAmount * multiplier;
          final totalReceive = receiveAmount * multiplier;
          return AlertDialog(
            title: Text(l10n.homeMarketTradeTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.homeMarketRateLine(giveAmount, receiveAmount)),
                const SizedBox(height: 12),
                DropdownButton<ResourceType>(
                  isExpanded: true,
                  value: give,
                  items: [
                    for (final t in types)
                      DropdownMenuItem(
                        value: t,
                        child: Text(l10n.homeMarketGiveOption(t.label, _stockpile[t] ?? 0)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() {
                      give = value;
                      if (receive == give) {
                        receive = types.firstWhere((t) => t != give);
                      }
                      multiplier = 1;
                    });
                  },
                ),
                const SizedBox(height: 8),
                DropdownButton<ResourceType>(
                  isExpanded: true,
                  value: receive,
                  items: [
                    for (final t in receiveOptions)
                      DropdownMenuItem(value: t, child: Text(l10n.homeMarketReceiveOption(t.label))),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() => receive = value);
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: multiplier > 1 ? () => setDialogState(() => multiplier--) : null,
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '$multiplier',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed:
                          multiplier < maxMultiplier ? () => setDialogState(() => multiplier++) : null,
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: maxMultiplier > 0
                          ? () => setDialogState(() => multiplier = maxMultiplier)
                          : null,
                      child: Text(l10n.homeMax),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  maxMultiplier > 0
                      ? l10n.homeMarketSummaryLine(totalGive, give.label, totalReceive, receive.label)
                      : l10n.homeMarketNotEnough(give.label),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.homeClose),
              ),
              FilledButton(
                onPressed: canTrade
                    ? () {
                        setState(() {
                          _stockpile[give] = (_stockpile[give] ?? 0) - totalGive;
                          _stockpile[receive] =
                              ((_stockpile[receive] ?? 0) + totalReceive).clamp(0, _storageCap);
                        });
                        ResourceStorage.save(_stockpile);
                        Navigator.of(context).pop();
                        _showSnack(
                          l10n.homeMarketTradeSnack(totalGive, give.label, totalReceive, receive.label),
                        );
                      }
                    : null,
                child: Text(l10n.homeExchangeButton),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _buyMove() async {
    if (_extraMoves >= _maxExtraMoves) return;
    final l10n = AppLocalizations.of(context)!;
    final cost = _nextMoveCost;
    if (!_canAfford(cost)) return;
    setState(() {
      for (final entry in cost.entries) {
        _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
      }
      _extraMoves += 1;
    });
    await ResourceStorage.save(_stockpile);
    await ShopStorage.saveExtraMoves(_extraMoves);
    _showSnack(l10n.homeMoveBoughtSnack(_totalMoves));
  }

  Future<void> _buyAutoMatchTier1() async {
    if (_autoMatchTier >= 1) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_canAfford(_autoMatchTier1Cost)) return;
    setState(() {
      for (final entry in _autoMatchTier1Cost.entries) {
        _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
      }
      _autoMatchTier = 1;
    });
    await ResourceStorage.save(_stockpile);
    await ShopStorage.saveAutoMatchTier(1);
    _showSnack(l10n.homeAutoMatchTier1Snack);
  }

  Future<void> _buyAutoMatchTier2() async {
    if (_autoMatchTier < 1 || _autoMatchTier >= 2) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_canAfford(_autoMatchTier2Cost)) return;
    setState(() {
      for (final entry in _autoMatchTier2Cost.entries) {
        _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
      }
      _autoMatchTier = 2;
    });
    await ResourceStorage.save(_stockpile);
    await ShopStorage.saveAutoMatchTier(2);
    _showSnack(l10n.homeAutoMatchTier2Snack);
  }

  Future<void> _onTapArea(AreaKind area) async {
    final l10n = AppLocalizations.of(context)!;
    final level1 = _areasBuilt[area] ?? false;
    final level2 = _areasUpgraded[area] ?? false;
    final prereq = area.prerequisite;
    if (!level1 && prereq != null && !(_areasBuilt[prereq] ?? false)) {
      _showSnack(l10n.homeAreaBuildFirst(prereq.label));
      return;
    }

    final cost = _costFor(area);
    final upgradeCost = _upgradeCostFor(area);
    final resource = area.resourceType;
    final bonusText = area.isStarterResource
        ? l10n.homeAreaBonusStarter(resource.label)
        : l10n.homeAreaBonusUnlock(resource.label.toLowerCase());
    final upgradeText = l10n.homeAreaUpgradeText(resource.label.toLowerCase());

    final action = await _showAreaDialog(
      area: area,
      level1: level1,
      level2: level2,
      cost: cost,
      upgradeCost: upgradeCost,
      bonusText: bonusText,
      upgradeText: upgradeText,
    );

    if (action == 'build' && !level1) {
      setState(() {
        for (final entry in cost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _areasBuilt[area] = true;
      });
      await ResourceStorage.save(_stockpile);
      await AreaStorage.setBuilt(area, true);
    } else if (action == 'upgrade' && level1 && !level2) {
      setState(() {
        for (final entry in upgradeCost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) - entry.value;
        }
        _areasUpgraded[area] = true;
      });
      await ResourceStorage.save(_stockpile);
      await AreaStorage.setUpgraded(area, true);
      _showSnack(l10n.homeAreaUpgradedSnack(area.label, resource.label.toLowerCase()));
    }
  }

  Future<String?> _showAreaDialog({
    required AreaKind area,
    required bool level1,
    required bool level2,
    required Map<ResourceType, int> cost,
    required Map<ResourceType, int> upgradeCost,
    required String bonusText,
    required String upgradeText,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final canAffordBuild = _canAfford(cost);
    final canAffordUpgrade = _canAfford(upgradeCost);
    final resource = area.resourceType;
    final title = !level1
        ? area.label
        : level2
            ? l10n.homeTitleUpgradedSuffix(area.label)
            : l10n.homeTitleBuiltSuffix(area.label);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(width: 64, height: 64, child: resourceIconAsset(resource.assetPath, size: 64)),
              ),
              const SizedBox(height: 14),
              if (!level1) ...[
                Text(l10n.homeAreaBuildCostTitle, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                for (final entry in cost.entries)
                  _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                const SizedBox(height: 12),
                Text(l10n.homeEffectLabel, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(bonusText),
              ] else ...[
                Text(l10n.homeLevel1, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(bonusText),
                const SizedBox(height: 14),
                if (!level2) ...[
                  Text(l10n.homeUpgradeToLevel2, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  for (final entry in upgradeCost.entries)
                    _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                  const SizedBox(height: 4),
                  Text(upgradeText),
                ] else ...[
                  Text(l10n.homeLevel2, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(upgradeText),
                ],
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(level1 && level2 ? l10n.homeClose : l10n.homeCancel),
          ),
          if (!level1)
            FilledButton(
              onPressed: canAffordBuild ? () => Navigator.of(context).pop('build') : null,
              child: Text(l10n.homeBuild),
            ),
          if (level1 && !level2)
            FilledButton(
              onPressed: canAffordUpgrade ? () => Navigator.of(context).pop('upgrade') : null,
              child: Text(l10n.homeUpgrade),
            ),
        ],
      ),
    );
  }

  /// Okno budynku - jeśli [upgradable] jest true (domyślnie), pokazuje
  /// dwupoziomowy przebieg (poziom 1 / rozbudowa) analogiczny do
  /// _showAreaDialog; w przeciwnym razie zachowuje się jak prosty
  /// jednopoziomowy dialog (używane dla dodatkowych działek pod "Dom").
  Future<String?> _showBuildingDialog({
    required String title,
    required BuildingKind kind,
    required bool level1,
    bool level2 = false,
    required Map<ResourceType, int> cost,
    Map<ResourceType, int> upgradeCost = const {},
    required String bonusText,
    String upgradeText = '',
    bool upgradable = true,
    bool showWorkers = true,
    bool demolishable = true,
    // false dla odbudowy zaniedbanego domu (patrz _onTapExtraHouse) - to
    // "poziom 0 -> 1", czyli dokończenie podstawowej naprawy odziedziczonego
    // domu, a nie prawdziwa rozbudowa do poziomu 2, więc nie powinno zależeć
    // od rozbudowanego Ratusza tak jak reszta budynków.
    bool upgradeRequiresRatuszLevel2 = true,
    String? levelLabel,
    String? upgradeSectionLabel,
    String? notDemolishableText,
    Widget Function(BuildContext, StateSetter)? extraContentBuilder,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final effectiveLevelLabel = levelLabel ?? l10n.homeLevel1;
    final effectiveUpgradeSectionLabel = upgradeSectionLabel ?? l10n.homeUpgradeToLevel2;
    final effectiveNotDemolishableText = notDemolishableText ?? l10n.homeMainBuildingNotDemolishable;
    // Ratusz to "główny budynek" wioski: musi być zbudowany, zanim można
    // zbudować cokolwiek innego, a jego rozbudowa (poziom 2) odblokowuje
    // rozbudowę pozostałych budynków. Nie dotyczy to samego Ratusza.
    final buildLocked = kind != BuildingKind.ratusz && !level1 && !_ratuszBuilt;
    // Rozbudowa samego Ratusza ma własną, osobną blokadę (odblokowuje się z
    // Aktem II, patrz _ratuszLevel2UnlockWeek) zamiast tej ogólnej - wymaganie
    // "rozbudowany Ratusz" byłoby bez sensu dla samego Ratusza.
    final upgradeLocked = kind == BuildingKind.ratusz
        ? _week < _ratuszLevel2UnlockWeek
        : upgradeRequiresRatuszLevel2 && !_upgradedL2(BuildingKind.ratusz);
    final canAffordBuild = !buildLocked && _canAfford(cost);
    final canAffordUpgrade = !upgradeLocked && _canAfford(upgradeCost);
    final dialogTitle = !level1
        ? title
        : (upgradable && level2)
            ? l10n.homeTitleUpgradedSuffix(title)
            : l10n.homeTitleBuiltSuffix(title);

    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(dialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: BuildingPreview(kind: kind, upgraded: level2)),
                const SizedBox(height: 14),
                if (!level1) ...[
                  if (buildLocked) ...[
                    Text(
                      l10n.homeLocked,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                    ),
                    const SizedBox(height: 6),
                    Text(l10n.homeBuildRatuszFirst),
                  ] else ...[
                    Text(l10n.homeBuildCostTitle, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    for (final entry in cost.entries)
                      _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                    const SizedBox(height: 12),
                    Text(l10n.homePerksLabel, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(bonusText),
                  ],
                ] else if (!upgradable) ...[
                  Text(l10n.homeDemolishRefund50Title, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  for (final entry in cost.entries)
                    _RefundRow(type: entry.key, refund: entry.value ~/ 2),
                  const SizedBox(height: 12),
                  Text(l10n.homePerksLabel, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(bonusText),
                ] else ...[
                  Text(effectiveLevelLabel, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(bonusText),
                  const SizedBox(height: 14),
                  if (!level2) ...[
                    Text(effectiveUpgradeSectionLabel, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    if (upgradeLocked) ...[
                      Text(
                        kind == BuildingKind.ratusz
                            ? l10n.homeRatuszLevel2LockedRequirement
                            : l10n.homeRequiresUpgradedRatusz,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                      ),
                    ] else ...[
                      for (final entry in upgradeCost.entries)
                        _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                      const SizedBox(height: 4),
                      Text(upgradeText),
                    ],
                  ] else ...[
                    Text(l10n.homeLevel2, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(upgradeText),
                  ],
                  const SizedBox(height: 14),
                  if (demolishable) ...[
                    Text(l10n.homeDemolishRefund50Title, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    for (final entry in cost.entries)
                      _RefundRow(type: entry.key, refund: entry.value ~/ 2),
                    if (level2)
                      for (final entry in upgradeCost.entries)
                        _RefundRow(type: entry.key, refund: entry.value ~/ 2),
                  ] else
                    Text(effectiveNotDemolishableText, style: Theme.of(context).textTheme.bodySmall),
                ],
                if (level1 && showWorkers) ...[
                  const SizedBox(height: 14),
                  Text(l10n.homeGeneralBonusTitle, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  for (final line in _bonusBreakdownFor(kind))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(line),
                    ),
                  const SizedBox(height: 14),
                  Text(l10n.homeWorkersTitle, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 2),
                  if (_maxWorkersPerBuilding == 0) ...[
                    Text(
                      l10n.homeWorkersRequiresDiscovery,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ] else ...[
                    Text(
                      l10n.homeWorkerBonusExplanation(_maxWorkersPerBuilding,
                          _maxWorkersPerBuilding == 2 ? l10n.homeWorkerMultiplierDouble : '+50%'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _workersFor(kind) > 0
                              ? () async {
                                  await _setWorkers(kind, _workersFor(kind) - 1);
                                  setDialogState(() {});
                                }
                              : null,
                        ),
                        Text(
                          '${_workersFor(kind)} / $_maxWorkersPerBuilding',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: (_workersFor(kind) < _maxWorkersPerBuilding && _availableWorkers > 0)
                              ? () async {
                                  await _setWorkers(kind, _workersFor(kind) + 1);
                                  setDialogState(() {});
                                }
                              : null,
                        ),
                      ],
                    ),
                    Text(
                      l10n.homeAvailableResidents(_availableWorkers),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
                if (extraContentBuilder != null) ...[
                  const SizedBox(height: 14),
                  extraContentBuilder(context, setDialogState),
                ],
              ],
            ),
          ),
          actions: [
            if (level1 && demolishable)
              TextButton(
                onPressed: () async {
                  final confirmed = await _confirmDemolish(context, title);
                  if (confirmed && context.mounted) Navigator.of(context).pop('demolish');
                },
                style: TextButton.styleFrom(foregroundColor: const Color(0xFFC0392B)),
                child: Text(l10n.homeDemolish),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(level1 && (!upgradable || level2) ? l10n.homeClose : l10n.homeCancel),
            ),
            if (!level1)
              FilledButton(
                onPressed: canAffordBuild ? () => Navigator.of(context).pop('build') : null,
                child: Text(l10n.homeBuild),
              ),
            if (level1 && upgradable && !level2)
              FilledButton(
                onPressed: canAffordUpgrade ? () => Navigator.of(context).pop('upgrade') : null,
                child: Text(l10n.homeUpgrade),
              ),
          ],
        ),
      ),
    );
  }

  Future<ResourceType?> _showWeeklyBoostPicker(List<ResourceType> options) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<ResourceType>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.homeWeeklyBoostTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.homeWeeklyBoostDescription),
            const SizedBox(height: 10),
            for (final type in options)
              ListTile(
                leading: SizedBox(width: 24, height: 24, child: resourceIconAsset(type.assetPath, size: 24)),
                title: Text(type.label),
                onTap: () => Navigator.of(context).pop(type),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.homeSkipButton)),
        ],
      ),
    );
  }

  // Szansa na wylosowanie JAKIEGOKOLWIEK wydarzenia w danym tygodniu; jeśli
  // wystąpi, _eventChoiceChance decyduje czy to wydarzenie z wyborem, a w
  // przeciwnym razie morale decyduje o proporcji pozytywne/negatywne.
  static const double _eventChance = 0.5;
  static const double _eventChoiceChance = 0.3;

  // Wydarzenia z wyborem (kind == choice) często mają opcję kosztującą
  // surowce (np. "Zapłać bardowi" -3 złota) obok darmowej alternatywy
  // ("Przepędź") - jeśli gracza nie stać na KTÓRĄKOLWIEK z opcji, całe
  // wydarzenie jest pomijane przy losowaniu (nie tylko ta jedna opcja),
  // żeby nie proponować wyboru, który faktycznie wyborem nie jest.
  // Wydarzenia positive/negative bez wyboru nie są tu sprawdzane - ich
  // ujemne delty to zamierzona strata z pecha, nie koszt do "stać nas na
  // to", a ewentualny niedobór i tak jest bezpiecznie przycinany do zera
  // przy zastosowaniu efektu (patrz _applyEventEffect).
  bool _canAffordEventOptions(VillageEvent event) {
    if (event.kind != VillageEventKind.choice) return true;
    for (final option in event.options!) {
      for (final entry in option.effect.resourceDelta.entries) {
        if (entry.value < 0 && (_stockpile[entry.key] ?? 0) < -entry.value) {
          return false;
        }
      }
    }
    return true;
  }

  Future<void> _resolveWeeklyEvent() async {
    if (_random.nextDouble() > _eventChance) return;
    final l10n = AppLocalizations.of(context)!;

    final season = seasonForWeek(_week);
    final VillageEventKind kind;
    if (_random.nextDouble() < _eventChoiceChance) {
      kind = VillageEventKind.choice;
    } else {
      final weatherBonus = _hasDiscovery(DiscoveryId.weatherForecast) ? _discoveryWeatherForecastBonus : 0.0;
      final positiveChance = (_moraleValue / 100.0 + weatherBonus).clamp(0.15, 0.9);
      kind = _random.nextDouble() < positiveChance ? VillageEventKind.positive : VillageEventKind.negative;
    }

    final eligible = kVillageEvents
        .where((e) =>
            e.kind == kind && (e.season == null || e.season == season) && _canAffordEventOptions(e))
        .toList();
    if (eligible.isEmpty) return;
    final event = eligible[_random.nextInt(eligible.length)];

    if (event.kind == VillageEventKind.choice) {
      final options = event.localizedOptions!;
      final choiceIndex = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(event.localizedTitle),
          content: Text(event.localizedDescription),
          actions: [
            for (var i = 0; i < options.length; i++)
              FilledButton(
                onPressed: () => Navigator.of(context).pop(i),
                child: Text(options[i].label),
              ),
          ],
        ),
      );
      if (!mounted || choiceIndex == null) return;
      final option = options[choiceIndex];
      await _applyEventEffect(option.effect);
      if (!mounted) return;
      final bonusText = _formatEventEffect(l10n, option.effect);
      _showSnack(
        l10n.homeEventChoiceResultSnack(
            event.localizedTitle, option.resultText, bonusText.isEmpty ? '' : ' ($bonusText)'),
      );
    } else {
      await _applyEventEffect(event.effect!);
      if (!mounted) return;
      final icon = event.kind == VillageEventKind.positive ? '✨' : '⚠️';
      final bonusText = _formatEventEffect(l10n, event.effect!);
      _showSnack(
        l10n.homeEventResultSnack(
            icon, event.localizedTitle, event.localizedDescription, bonusText.isEmpty ? '' : ' ($bonusText)'),
      );
    }
  }

  // Zamienia efekt wydarzenia na czytelny tekst premii/kar, np.
  // "+5 drewna, -8 morale" - dołączany do opisu wydarzenia w powiadomieniu.
  String _formatEventEffect(AppLocalizations l10n, EventEffect effect) {
    final parts = <String>[];
    for (final entry in effect.resourceDelta.entries) {
      if (entry.value == 0) continue;
      final sign = entry.value > 0 ? '+' : '';
      parts.add('$sign${entry.value} ${entry.key.label.toLowerCase()}');
    }
    if (effect.moraleDelta != 0) {
      parts.add('${effect.moraleDelta > 0 ? '+' : ''}${effect.moraleDelta} ${l10n.homeEventUnitMorale}');
    }
    if (effect.securityDelta != 0) {
      parts.add(
          '${effect.securityDelta > 0 ? '+' : ''}${effect.securityDelta} ${l10n.homeEventUnitSecurity}');
    }
    if (effect.populationDelta != 0) {
      parts.add(
          '${effect.populationDelta > 0 ? '+' : ''}${effect.populationDelta} ${l10n.homeEventUnitPopulation}');
    }
    if (effect.soldierDelta != 0) {
      parts.add(
        effect.soldierDelta > 0
            ? '+${effect.soldierDelta} ${l10n.homeEventUnitSoldiers}'
            : '${effect.soldierDelta} ${l10n.homeEventUnitSoldiers} ${l10n.homeEventLossesSuffix}',
      );
    }
    return parts.join(', ');
  }

  Future<void> _applyEventEffect(EventEffect effect) async {
    setState(() {
      for (final entry in effect.resourceDelta.entries) {
        _stockpile[entry.key] = ((_stockpile[entry.key] ?? 0) + entry.value).clamp(0, _storageCap);
      }
      _eventMoraleBonus += effect.moraleDelta;
      _eventSecurityBonus += effect.securityDelta;
      _eventPopulationBonus += effect.populationDelta;
    });
    await ResourceStorage.save(_stockpile);
    await VillageEventStorage.saveMoraleBonus(_eventMoraleBonus);
    await VillageEventStorage.saveSecurityBonus(_eventSecurityBonus);
    await VillageEventStorage.savePopulationBonus(_eventPopulationBonus);

    if (effect.soldierDelta > 0) {
      final type = UnitType.values[_random.nextInt(UnitType.values.length)];
      setState(() => _soldierCounts[type] = (_soldierCounts[type] ?? 0) + effect.soldierDelta);
      await StatsStorage.saveSoldierCount(type, _soldierCounts[type] ?? 0);
    } else if (effect.soldierDelta < 0) {
      var remaining = -effect.soldierDelta;
      for (final type in UnitType.values) {
        if (remaining <= 0) break;
        final count = _soldierCounts[type] ?? 0;
        final lost = remaining < count ? remaining : count;
        if (lost > 0) {
          setState(() => _soldierCounts[type] = count - lost);
          await StatsStorage.saveSoldierCount(type, _soldierCounts[type] ?? 0);
        }
        remaining -= lost;
      }
    }
  }

  /// Nagroda surowcowa za osiągnięcie celu głównego aktu - rośnie z numerem
  /// aktu, żeby nadążać za skalą kosztów budowy w danym momencie gry (patrz
  /// analogiczna, tematyczna skala w kSideQuests).
  Map<ResourceType, int> _actGoalReward(int actNumber) => {
        ResourceType.wood: 20 + actNumber * 4,
        ResourceType.stone: 20 + actNumber * 4,
        ResourceType.coin: 10 + actNumber * 4,
      };

  /// Czy cel główny danego aktu jest obecnie spełniony - sprawdzane w
  /// ostatnim tygodniu aktu, żeby zdecydować o karze za porażkę. Wyprowadzone
  /// z _actGoalRequirements, żeby lista pokazywana w zakładce Cele i
  /// faktyczny warunek rozstrzygający akt nigdy się nie rozjechały.
  bool _actGoalMet(int actNumber) => _actGoalRequirements(actNumber).every((r) => r.met);

  GoalRequirement _resourceRequirement(ResourceType type, int target) {
    final have = _stockpile[type] ?? 0;
    return GoalRequirement(label: type.label, met: have >= target, progress: '$have/$target');
  }

  /// Wynik starcia z bossem jako pojedyncze wymaganie z postępem - -1 znaczy
  /// "jeszcze nie stoczono", więc to NIE to samo co "0 etapów ukończonych".
  GoalRequirement _battleRequirement(
      AppLocalizations l10n, String label, int stagesCleared, int requiredStages) {
    if (stagesCleared < 0) {
      return GoalRequirement(label: label, met: false, progress: l10n.homeGoalNotFoughtYet);
    }
    return GoalRequirement(
      label: label,
      met: stagesCleared >= requiredStages,
      progress: l10n.homeGoalBattleProgress(stagesCleared, requiredStages),
    );
  }

  /// Szczegółowa, żywa lista wymagań celu głównego danego aktu - pokazywana
  /// w zakładce Cele z aktualnym postępem, nie tylko jako opis tekstowy.
  List<GoalRequirement> _actGoalRequirements(int actNumber) {
    final l10n = AppLocalizations.of(context)!;
    switch (actNumber) {
      case 0:
        return [
          GoalRequirement(label: l10n.homeGoalRatuszBuilt, met: _ratuszBuilt),
          GoalRequirement(label: l10n.homeGoalOrchardDeveloped, met: _areasBuilt[AreaKind.orchard] ?? false),
          GoalRequirement(label: l10n.homeGoalMeadowDeveloped, met: _areasBuilt[AreaKind.meadow] ?? false),
          GoalRequirement(label: l10n.homeGoalFieldDeveloped, met: _areasBuilt[AreaKind.field] ?? false),
          _resourceRequirement(ResourceType.wood, 30),
          _resourceRequirement(ResourceType.stone, 20),
          _resourceRequirement(ResourceType.coin, 15),
          _resourceRequirement(ResourceType.water, 15),
          _resourceRequirement(ResourceType.grain, 15),
          _resourceRequirement(ResourceType.apple, 15),
          _resourceRequirement(ResourceType.grass, 15),
        ];
      case 1:
        // Rozstrzygane przez starcie z Grotem (tydzień 26, BossBattleScreen) -
        // 2 lub 3 z 3 ukończonych etapów liczą się jako sukces.
        return [_battleRequirement(l10n, l10n.homeGoalBattleGrot, _bossBattleStagesCleared, 2)];
      case 2:
        // Rozstrzygane przez starcie z Martą (tydzień 39, MartaBattleScreen) -
        // 2 lub 3 z 3 ukończonych etapów liczą się jako sukces. Rozbudowa
        // Ratusza do poziomu 2 odblokowuje się dopiero teraz (patrz
        // _ratuszLevel2UnlockWeek) - to drugi, niezależny cel tego aktu.
        return [
          _battleRequirement(l10n, l10n.homeGoalBattleMarta, _martaBattleStagesCleared, 2),
          GoalRequirement(
              label: l10n.homeGoalRatuszUpgraded, met: _upgradedL2(BuildingKind.ratusz)),
        ];
      case 3:
        // Rozstrzygane przez starcie z Bogdanem (tydzień 52,
        // BogdanBattleScreen) - trzeba zebrać cały Dowód.
        return [GoalRequirement(label: l10n.homeGoalBogdanProof, met: _bogdanProofComplete == 1)];
      case 4:
        // Leszy budzi się w komiksie #24 ("Przebudzenie", tydzień 58), ale
        // sama walka jest teraz dopiero w środku Aktu V (patrz
        // _leszyBattleWeek) - cel Aktu IV to sprawdzian gotowości wioski na
        // to, co nadchodzi, nie sama walka.
        return [
          GoalRequirement(
              label: l10n.homeGoalArmyStrength,
              met: _totalArmyStrength >= 20,
              progress: '$_totalArmyStrength/20'),
          GoalRequirement(
            label: l10n.homeGoalVillageSecurity,
            met: _securityValue >= 50,
            progress: '$_securityValue/50',
          ),
        ];
      case 5:
        // "Leszy pokonany" rozstrzygane przez starcie w tygodniu 64
        // (LeszyBattleScreen) - w praktyce zawsze true w tygodniu 65, bo
        // porażka nie pozwala tygodniowi minąć (patrz _startWeek).
        return [
          GoalRequirement(label: l10n.homeGoalLeszyDefeated, met: _leszyVictorious),
          GoalRequirement(
            label: l10n.homeGoalQuestSladyWPopiele,
            met: _claimedSideQuests.contains(SideQuestId.sladyWPopiele),
          ),
          GoalRequirement(
            label: l10n.homeGoalQuestRozmowaZJadwiga,
            met: _claimedSideQuests.contains(SideQuestId.rozmowaZJadwiga),
          ),
        ];
      default:
        return const [];
    }
  }

  /// Czy warunek danego questu pobocznego jest obecnie spełniony - sprawdzane
  /// co tydzień dla wszystkich jeszcze nieodebranych questów (patrz
  /// _startWeek). Questy nie wygasają - można je ukończyć w dowolnym
  /// tygodniu, niezależnie od tego, który akt aktualnie trwa.
  bool _sideQuestMet(SideQuestId id) {
    switch (id) {
      case SideQuestId.ostatniaLekcja:
        return _upgradedL2(BuildingKind.ratusz);
      case SideQuestId.dobrySasiad:
        return _villageBuilt[BuildingKind.karczma] ?? false;
      case SideQuestId.milczenieJadwigi:
        return _villageBuilt[BuildingKind.kaplica] ?? false;
      case SideQuestId.wdowaPoNajemniku:
        return _bossBattleStagesCleared >= 2 && (_villageBuilt[BuildingKind.karczma] ?? false);
      case SideQuestId.ostatniList:
        return _hasDiscovery(DiscoveryId.cartography);
      case SideQuestId.martaIncognito:
        return _moraleValue >= 70;
      case SideQuestId.staryHandlarz:
        return _villageBuilt[BuildingKind.rynek] ?? false;
      case SideQuestId.klatwaStudni:
        return _upgradedL2(BuildingKind.studnia);
      case SideQuestId.ostatniaSzarza:
        return _totalArmyStrength >= 20;
      case SideQuestId.sladyWPopiele:
        return _martaFullTrust;
      case SideQuestId.rozmowaZJadwiga:
        return _bogdanProofComplete == 1;
    }
  }

  /// Postęp liczbowy questa pobocznego, jeśli warunek ma naturalny licznik
  /// (null dla warunków zero-jedynkowych typu "budynek zbudowany", gdzie
  /// sama ikonka statusu wystarcza).
  String? _sideQuestProgress(SideQuestId id) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case SideQuestId.martaIncognito:
        return l10n.homeSideQuestMoraleProgress(_moraleValue.round());
      case SideQuestId.ostatniaSzarza:
        return l10n.homeSideQuestArmyStrengthProgress(_totalArmyStrength);
      case SideQuestId.wdowaPoNajemniku:
        final stages = _bossBattleStagesCleared < 0 ? 0 : _bossBattleStagesCleared;
        final karczma = (_villageBuilt[BuildingKind.karczma] ?? false)
            ? l10n.homeBuilt
            : l10n.homeNotBuilt;
        return l10n.homeSideQuestGrotKarczmaProgress(stages, karczma);
      case SideQuestId.ostatniaLekcja:
      case SideQuestId.dobrySasiad:
      case SideQuestId.milczenieJadwigi:
      case SideQuestId.ostatniList:
      case SideQuestId.staryHandlarz:
      case SideQuestId.klatwaStudni:
      case SideQuestId.sladyWPopiele:
      case SideQuestId.rozmowaZJadwiga:
        return null;
    }
  }

  /// Rozstrzyga skutki starcia z Grotem (tydzień 26) zaraz po powrocie z
  /// BossBattleScreen. Porażka (0-1/3 etapów) NIE dostaje tu żadnej kary -
  /// tę nakłada automatycznie generyczny mechanizm końca aktu niżej w
  /// _startWeek, bo _actGoalMet(1) zwróci false.
  Future<void> _resolveBossBattleResult(BossBattleResult result) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _bossBattleStagesCleared = result.stagesCleared);
    await StoryProgressStorage.saveBossBattleStagesCleared(result.stagesCleared);
    if (result.stagesCleared == 3) {
      setState(() {
        _stockpile[ResourceType.coin] = ((_stockpile[ResourceType.coin] ?? 0) + 15).clamp(0, _storageCap);
        _stockpile[ResourceType.wood] = ((_stockpile[ResourceType.wood] ?? 0) + 15).clamp(0, _storageCap);
      });
      await ResourceStorage.save(_stockpile);
      _showSnack(l10n.homeGrotVictoryFullSnack);
    } else if (result.stagesCleared == 2) {
      setState(() {
        _stockpile[ResourceType.wood] = ((_stockpile[ResourceType.wood] ?? 0) * 0.9).round();
        _stockpile[ResourceType.coin] = ((_stockpile[ResourceType.coin] ?? 0) * 0.9).round();
      });
      await ResourceStorage.save(_stockpile);
      _showSnack(l10n.homeGrotVictoryPartialSnack);
    } else {
      _showSnack(l10n.homeGrotDefeatSnack(result.stagesCleared));
    }
  }

  /// Rozstrzyga skutki starcia z Martą (tydzień 39) zaraz po powrocie z
  /// MartaBattleScreen. Porażka (0-1/3 etapów) NIE dostaje tu żadnej kary -
  /// tę nakłada automatycznie generyczny mechanizm końca aktu niżej w
  /// _startWeek, bo _actGoalMet(2) zwróci false.
  Future<void> _resolveMartaBattleResult(MartaBattleResult result) async {
    final l10n = AppLocalizations.of(context)!;
    final fullTrust = result.stagesCleared == 3 && result.fullTrustBonus;
    setState(() {
      _martaBattleStagesCleared = result.stagesCleared;
      _martaFullTrust = fullTrust;
    });
    await StoryProgressStorage.saveMartaBattleStagesCleared(result.stagesCleared);
    await StoryProgressStorage.saveMartaFullTrust(fullTrust);
    if (result.stagesCleared == 3) {
      final bonus = result.fullTrustBonus ? 15 : 10;
      setState(() => _eventMoraleBonus = (_eventMoraleBonus + bonus).clamp(-100, 100));
      await VillageEventStorage.saveMoraleBonus(_eventMoraleBonus);
      _showSnack(
        result.fullTrustBonus ? l10n.homeMartaVictoryFullTrustSnack : l10n.homeMartaVictoryTrustSnack,
      );
    } else if (result.stagesCleared == 2) {
      _showSnack(l10n.homeMartaVictoryPartialSnack);
    } else {
      _showSnack(l10n.homeMartaDefeatSnack(result.stagesCleared));
    }
  }

  /// Rozstrzyga skutki starcia z Bogdanem (tydzień 52) zaraz po powrocie z
  /// BogdanBattleScreen. Spalenia magazynu (fullBurns/discountedBurns) mają
  /// realny, natychmiastowy skutek niezależnie od tego, czy Dowód finalnie
  /// zebrano - w przeciwieństwie do Grota/Marty, gdzie kara istniała tylko
  /// w podsumowaniu. Porażka (proofComplete == false) NIE dostaje tu
  /// dodatkowej kary poza już zadanymi spaleniami - kara z sekcji 5 nakłada
  /// się automatycznie niżej w _startWeek, bo _actGoalMet(3) zwróci false.
  Future<void> _resolveBogdanBattleResult(BogdanBattleResult result) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _bogdanProofComplete = result.proofComplete ? 1 : 0);
    await StoryProgressStorage.saveBogdanProofComplete(result.proofComplete);
    if (result.totalBurns > 0) {
      setState(() {
        for (var i = 0; i < result.fullBurns; i++) {
          _stockpile[ResourceType.grain] = ((_stockpile[ResourceType.grain] ?? 0) * 0.85).round();
          _stockpile[ResourceType.apple] = ((_stockpile[ResourceType.apple] ?? 0) * 0.85).round();
        }
        for (var i = 0; i < result.discountedBurns; i++) {
          _stockpile[ResourceType.grain] = ((_stockpile[ResourceType.grain] ?? 0) * 0.95).round();
          _stockpile[ResourceType.apple] = ((_stockpile[ResourceType.apple] ?? 0) * 0.95).round();
        }
      });
      await ResourceStorage.save(_stockpile);
    }
    if (result.proofComplete && result.totalBurns == 0) {
      _showSnack(l10n.homeBogdanVictoryFullSnack);
    } else if (result.proofComplete) {
      _showSnack(l10n.homeBogdanVictoryPartialSnack(result.totalBurns));
    } else {
      _showSnack(l10n.homeBogdanDefeatSnack(result.totalBurns));
    }
  }

  // Poniższe cztery metody uruchamiają starcia z bossami bezpośrednio z
  // zakładki Debug, niezależnie od bieżącego tygodnia - do szybkiego
  // testowania balansu/mechaniki bez konieczności dogrywania do tygodnia
  // 26/39/52/64. To "walka treningowa": używa prawdziwych, aktualnych
  // statystyk wioski (żołnierze, Palisada, bezpieczeństwo itd.), ale
  // celowo NIE zapisuje wyniku ani nie rusza surowców/flag fabularnych -
  // inaczej powtarzane testy zaśmiecałyby prawdziwy zapis gry.
  Future<void> _debugFightGrot() async {
    final result = await Navigator.of(context).push<BossBattleResult>(
      MaterialPageRoute(
        builder: (_) => BossBattleScreen(
          week: _week,
          soldierCount: _soldierCounts.values.fold(0, (a, b) => a + b),
          palisadeBuilt: _palisadeBuilt,
          security: _securityValue,
          // W starciach z bossami ulepszenia auto-dopasowywania (Sklep) się
          // nie liczą - to walka, nie zwykłe zbiory, ma zostać ręczna.
          autoMatchTier: 0,
          minComboForBomb: _hasDiscovery(DiscoveryId.earlyBomb) ? 5 : 6,
          boardStyle: _boardStyle,
          bonusTypes: _bonusTypes,
        ),
      ),
    );
    if (!mounted || result == null) return;
    _showSnack(AppLocalizations.of(context)!.homeDebugGrotResultSnack(result.stagesCleared));
  }

  Future<void> _debugFightMarta() async {
    final result = await Navigator.of(context).push<MartaBattleResult>(
      MaterialPageRoute(
        builder: (_) => MartaBattleScreen(
          week: _week,
          kaplicaLevel: _kaplicaLevel,
          morale: _moraleValue,
          autoMatchTier: 0,
          minComboForJoker: _hasDiscovery(DiscoveryId.earlyJoker) ? 4 : 5,
          boardStyle: _boardStyle,
          bonusTypes: _bonusTypes,
        ),
      ),
    );
    if (!mounted || result == null) return;
    final l10n = AppLocalizations.of(context)!;
    _showSnack(l10n.homeDebugMartaResultSnack(
        result.stagesCleared, result.fullTrustBonus ? l10n.homeDebugMartaFullTrustSuffix : ''));
  }

  Future<void> _debugFightBogdan() async {
    final result = await Navigator.of(context).push<BogdanBattleResult>(
      MaterialPageRoute(
        builder: (_) => BogdanBattleScreen(
          week: _week,
          security: _securityValue,
          morale: _moraleValue,
          martaFullTrust: _martaFullTrust,
          autoMatchTier: 0,
          boardStyle: _boardStyle,
          bonusTypes: _bonusTypes,
        ),
      ),
    );
    if (!mounted || result == null) return;
    final l10n = AppLocalizations.of(context)!;
    _showSnack(l10n.homeDebugBogdanResultSnack(
        result.proofComplete ? l10n.homeDebugProofGathered : l10n.homeDebugProofIncomplete,
        result.totalBurns));
  }

  Future<void> _debugFightLeszy() async {
    final result = await Navigator.of(context).push<LeszyBattleResult>(
      MaterialPageRoute(
        builder: (_) => LeszyBattleScreen(
          week: _week,
          security: _securityValue,
          armyStrength: _totalArmyStrength,
          autoMatchTier: 0,
          boardStyle: _boardStyle,
          bonusTypes: _bonusTypes,
        ),
      ),
    );
    if (!mounted || result == null) return;
    final l10n = AppLocalizations.of(context)!;
    _showSnack(l10n.homeDebugLeszyResultSnack(
        result.victory ? l10n.homeDebugVictory : l10n.homeDebugDefeat));
  }

  // Tekst wyjaśniający, co poszło nie tak, pokazywany na ActFailureScreen -
  // porażka celu głównego aktu to teraz prawdziwy koniec próby (ekran
  // porażki + wczytanie checkpointu), nie "miękka" kara pozwalająca grać
  // dalej, dlatego te opisy już nie mutują żadnego stanu gry.
  String _actFailureFlavorText(int actNumber) {
    final l10n = AppLocalizations.of(context)!;
    switch (actNumber) {
      case 0:
        return l10n.homeActFailure0;
      case 1:
        return l10n.homeActFailure1;
      case 2:
        return l10n.homeActFailure2;
      case 3:
        return l10n.homeActFailure3;
      case 4:
        return l10n.homeActFailure4;
      case 5:
        return l10n.homeActFailure5;
      default:
        return l10n.homeActFailureDefault;
    }
  }

  Map<String, dynamic> _buildCheckpointSnapshot() {
    return {
      'week': _week,
      'ratuszBuilt': _ratuszBuilt,
      'palisadeBuilt': _palisadeBuilt,
      'stockpile': {for (final e in _stockpile.entries) e.key.name: e.value},
      'stats': {
        'totalCollected': _stats.totalCollected,
        'longestPath': _stats.longestPath,
        'maxSingleHarvest': _stats.maxSingleHarvest,
      },
      'soldierCounts': {for (final e in _soldierCounts.entries) e.key.name: e.value},
      'areasBuilt': {for (final e in _areasBuilt.entries) e.key.name: e.value},
      'areasUpgraded': {for (final e in _areasUpgraded.entries) e.key.name: e.value},
      'extraMoves': _extraMoves,
      'autoMatchTier': _autoMatchTier,
      'villageBuilt': {for (final e in _villageBuilt.entries) e.key.name: e.value},
      'villageUpgraded': {for (final e in _villageUpgraded.entries) e.key.name: e.value},
      'villageWorkers': {for (final e in _villageWorkers.entries) e.key.name: e.value},
      'extraHousesBuilt': _extraHousesBuilt,
      'extraHousesActive': _extraHousesActive,
      'extraHousesUpgraded': _extraHousesUpgraded,
      'eventMoraleBonus': _eventMoraleBonus,
      'eventSecurityBonus': _eventSecurityBonus,
      'eventPopulationBonus': _eventPopulationBonus,
      'population': _population,
      'populationGrowthProgress': _populationGrowthProgress,
      'unlockedDiscoveries': _unlockedDiscoveries.map((d) => d.name).toList(),
      'resolvedActs': _resolvedActs.toList(),
      'lastStarvationWeek': _lastStarvationWeek,
      'bossBattleStagesCleared': _bossBattleStagesCleared,
      'martaBattleStagesCleared': _martaBattleStagesCleared,
      'martaFullTrust': _martaFullTrust,
      'bogdanProofComplete': _bogdanProofComplete,
      'leszyVictorious': _leszyVictorious,
      'claimedSideQuests': _claimedSideQuests.map((q) => q.name).toList(),
      'readComics': _readComics.toList(),
    };
  }

  // Wywoływane co tydzień (patrz _startWeek) - migawka pozwala potem wrócić
  // do stanu sprzed próby, jeśli kolejny akt zakończy się porażką.
  Future<void> _saveCheckpoint() async {
    await CheckpointStorage.save(_week, _buildCheckpointSnapshot());
  }

  Future<void> _restoreCheckpoint(int week) async {
    final snapshot = await CheckpointStorage.load(week);
    if (snapshot == null) return;

    Map<String, dynamic> asMap(String key) => (snapshot[key] as Map).cast<String, dynamic>();
    List<dynamic> asList(String key) => snapshot[key] as List;

    await GameProgressStorage.saveWeek(snapshot['week'] as int);
    await GameProgressStorage.setRatuszBuilt(snapshot['ratuszBuilt'] as bool);
    await GameProgressStorage.setPalisadeBuilt(snapshot['palisadeBuilt'] as bool);

    await ResourceStorage.save({
      for (final entry in asMap('stockpile').entries)
        ResourceType.values.byName(entry.key): entry.value as int,
    });

    final statsMap = asMap('stats');
    await StatsStorage.saveAll(GameStats(
      totalCollected: statsMap['totalCollected'] as int,
      longestPath: statsMap['longestPath'] as int,
      maxSingleHarvest: statsMap['maxSingleHarvest'] as int,
      soldierCounts: {
        for (final entry in asMap('soldierCounts').entries)
          UnitType.values.byName(entry.key): entry.value as int,
      },
    ));

    for (final entry in asMap('areasBuilt').entries) {
      await AreaStorage.setBuilt(AreaKind.values.byName(entry.key), entry.value as bool);
    }
    for (final entry in asMap('areasUpgraded').entries) {
      await AreaStorage.setUpgraded(AreaKind.values.byName(entry.key), entry.value as bool);
    }

    await ShopStorage.saveExtraMoves(snapshot['extraMoves'] as int);
    await ShopStorage.saveAutoMatchTier(snapshot['autoMatchTier'] as int);

    for (final entry in asMap('villageBuilt').entries) {
      await VillageBuildingStorage.setBuilt(BuildingKind.values.byName(entry.key), entry.value as bool);
    }
    for (final entry in asMap('villageUpgraded').entries) {
      await VillageBuildingStorage.setUpgraded(BuildingKind.values.byName(entry.key), entry.value as bool);
    }
    for (final entry in asMap('villageWorkers').entries) {
      await VillageBuildingStorage.setWorkers(BuildingKind.values.byName(entry.key), entry.value as int);
    }
    final extraHousesBuilt = asList('extraHousesBuilt').cast<bool>();
    for (var i = 0; i < extraHousesBuilt.length; i++) {
      await VillageBuildingStorage.setExtraHouseBuilt(i, extraHousesBuilt[i]);
    }
    final extraHousesActive = asList('extraHousesActive').cast<bool>();
    for (var i = 0; i < extraHousesActive.length; i++) {
      await VillageBuildingStorage.setExtraHouseActive(i, extraHousesActive[i]);
    }
    // Klucz może brakować w checkpointach zapisanych przed dodaniem
    // rozbudowy dodatkowych domów - domyślnie żaden nie jest rozbudowany.
    final extraHousesUpgraded = snapshot.containsKey('extraHousesUpgraded')
        ? asList('extraHousesUpgraded').cast<bool>()
        : List<bool>.filled(kExtraHouseCount, false);
    for (var i = 0; i < extraHousesUpgraded.length; i++) {
      await VillageBuildingStorage.setExtraHouseUpgraded(i, extraHousesUpgraded[i]);
    }

    await VillageEventStorage.saveMoraleBonus(snapshot['eventMoraleBonus'] as int);
    await VillageEventStorage.saveSecurityBonus(snapshot['eventSecurityBonus'] as int);
    await VillageEventStorage.savePopulationBonus(snapshot['eventPopulationBonus'] as int);

    await PopulationStorage.save(snapshot['population'] as int);
    // Klucz może brakować w checkpointach zapisanych przed wprowadzeniem
    // ułamkowego przyrostu - domyślnie 0.
    await PopulationStorage.saveGrowthProgress(
        (snapshot['populationGrowthProgress'] as num?)?.toDouble() ?? 0.0);

    final unlockedDiscoveries = asList('unlockedDiscoveries').cast<String>().map(DiscoveryId.values.byName).toSet();
    for (final id in DiscoveryId.values) {
      await DiscoveryStorage.setUnlocked(id, unlockedDiscoveries.contains(id));
    }

    await StoryProgressStorage.saveResolvedActs(asList('resolvedActs').cast<int>().toSet());
    await StoryProgressStorage.saveLastStarvationWeek(snapshot['lastStarvationWeek'] as int);
    await StoryProgressStorage.saveBossBattleStagesCleared(snapshot['bossBattleStagesCleared'] as int);
    await StoryProgressStorage.saveMartaBattleStagesCleared(snapshot['martaBattleStagesCleared'] as int);
    await StoryProgressStorage.saveMartaFullTrust(snapshot['martaFullTrust'] as bool);
    await StoryProgressStorage.saveBogdanProofCompleteValue(snapshot['bogdanProofComplete'] as int);
    await StoryProgressStorage.saveLeszyVictorious(snapshot['leszyVictorious'] as bool);

    // Pomija nierozpoznane nazwy - stary checkpoint może odwoływać się do
    // questa usuniętego z gry w międzyczasie (patrz models/side_quest.dart).
    final validSideQuestNames = SideQuestId.values.map((id) => id.name).toSet();
    await ExperienceStorage.saveClaimedSideQuests(
      asList('claimedSideQuests')
          .cast<String>()
          .where(validSideQuestNames.contains)
          .map(SideQuestId.values.byName)
          .toSet(),
    );

    await ComicStorage.saveAllRead(asList('readComics').cast<int>().toSet());

    if (!mounted) return;
    await _load();
  }

  /// Reset pełnej gry - ta sama sekwencja co "Nowa gra" na SplashScreen,
  /// wywoływana z ActFailureScreen, kiedy gracz nie chce wczytywać żadnego
  /// checkpointu tylko zacząć od zera.
  Future<void> _startNewGameFromFailure() async {
    await ResourceStorage.reset();
    await GameProgressStorage.startNewGame();
    await StatsStorage.reset();
    await AreaStorage.reset();
    await ShopStorage.reset();
    await VillageBuildingStorage.reset();
    await VillageEventStorage.reset();
    await PopulationStorage.reset();
    await DiscoveryStorage.reset();
    await StoryProgressStorage.reset();
    await ComicStorage.reset();
    await ExperienceStorage.reset();
    await CheckpointStorage.clearAll();
    if (!mounted) return;
    await _load();
  }

  Future<void> _startWeek() async {
    setState(() => _busy = true);
    // Nowy tydzień zaczyna własną, świeżą serię powiadomień - nieważne, czy
    // gracz zdążył zamknąć poprzednią (np. po zbudowaniu czegoś).
    clearEventPopups();

    ResourceType? weeklyBoost;
    final upgradedAreaResources = [
      for (final area in AreaKind.values)
        if (_areasUpgraded[area] == true) area.resourceType,
    ];
    if (upgradedAreaResources.isNotEmpty) {
      weeklyBoost = await _showWeeklyBoostPicker(upgradedAreaResources);
      if (!mounted) return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => WeekTransitionScreen(week: _week)),
    );
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;

    if (_week == _grotBattleWeek) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BossIntroScreen(
            week: _week,
            bossName: 'Grot',
            message: l10n.homeBossIntroGrotMessage,
            portraitKey: 'grot',
          ),
        ),
      );
      if (!mounted) return;
      final result = await Navigator.of(context).push<BossBattleResult>(
        MaterialPageRoute(
          builder: (_) => BossBattleScreen(
            week: _week,
            soldierCount: _soldierCounts.values.fold(0, (a, b) => a + b),
            palisadeBuilt: _palisadeBuilt,
            security: _securityValue,
            autoMatchTier: 0,
            minComboForBomb: _hasDiscovery(DiscoveryId.earlyBomb) ? 5 : 6,
            boardStyle: _boardStyle,
            bonusTypes: _bonusTypes,
          ),
        ),
      );
      if (!mounted) return;
      if (result != null) {
        await _resolveBossBattleResult(result);
        if (!mounted) return;
      }
    } else if (_week == _martaBattleWeek) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BossIntroScreen(
            week: _week,
            bossName: 'Marta',
            message: l10n.homeBossIntroMartaMessage,
            portraitKey: 'marta',
          ),
        ),
      );
      if (!mounted) return;
      final result = await Navigator.of(context).push<MartaBattleResult>(
        MaterialPageRoute(
          builder: (_) => MartaBattleScreen(
            week: _week,
            kaplicaLevel: _kaplicaLevel,
            morale: _moraleValue,
            autoMatchTier: 0,
            minComboForJoker: _hasDiscovery(DiscoveryId.earlyJoker) ? 4 : 5,
            boardStyle: _boardStyle,
            bonusTypes: _bonusTypes,
          ),
        ),
      );
      if (!mounted) return;
      if (result != null) {
        await _resolveMartaBattleResult(result);
        if (!mounted) return;
      }
    } else if (_week == _bogdanBattleWeek) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BossIntroScreen(
            week: _week,
            bossName: 'Bogdan Kruk',
            message: l10n.homeBossIntroBogdanMessage,
            portraitKey: 'bogdan',
          ),
        ),
      );
      if (!mounted) return;
      final result = await Navigator.of(context).push<BogdanBattleResult>(
        MaterialPageRoute(
          builder: (_) => BogdanBattleScreen(
            week: _week,
            security: _securityValue,
            morale: _moraleValue,
            martaFullTrust: _martaFullTrust,
            autoMatchTier: 0,
            boardStyle: _boardStyle,
            bonusTypes: _bonusTypes,
          ),
        ),
      );
      if (!mounted) return;
      if (result != null) {
        await _resolveBogdanBattleResult(result);
        if (!mounted) return;
      }
    } else if (_week == _leszyBattleWeek) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BossIntroScreen(
            week: _week,
            bossName: 'Leszy',
            message: l10n.homeBossIntroLeszyMessage,
            portraitKey: 'leszy',
          ),
        ),
      );
      if (!mounted) return;
      final result = await Navigator.of(context).push<LeszyBattleResult>(
        MaterialPageRoute(
          builder: (_) => LeszyBattleScreen(
            week: _week,
            security: _securityValue,
            armyStrength: _totalArmyStrength,
            autoMatchTier: 0,
            boardStyle: _boardStyle,
            bonusTypes: _bonusTypes,
          ),
        ),
      );
      if (!mounted) return;
      if (result == null || !result.victory) {
        // Porażka (albo wyjście bez zwycięstwa) - tydzień NIE mija, gracz
        // wraca do wioski, żeby się lepiej przygotować i spróbować później.
        setState(() => _busy = false);
        return;
      }
      setState(() => _leszyVictorious = true);
      await StoryProgressStorage.saveLeszyVictorious(true);
      _showSnack(l10n.homeLeszyVictorySnack);
    } else {
      // Pętla obsługuje "Zagraj tydzień ponownie" z panelu podsumowania
      // rundy (HarvestScreen zwraca true) - checkpoint(_week) to migawka
      // stanu sprzed TEJ próby (zapisana na końcu poprzedniego _startWeek,
      // patrz _saveCheckpoint), więc jej przywrócenie cofa dokładnie to, co
      // zdążyła zebrać przerwana runda, i rozdaje świeżą planszę od zera.
      var replay = true;
      while (replay) {
        replay = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => HarvestScreen(
                  week: _week,
                  ratuszBuilt: _ratuszBuilt,
                  unlockedTypes: _unlockedTypes,
                  bonusTypes: _bonusTypes,
                  weeklyBoostType: weeklyBoost,
                  builtAreaCount: _areasBuilt.values.where((b) => b).length,
                  movesPerRound: _totalMoves,
                  autoMatchTier: _autoMatchTier,
                  storageCap: _storageCap,
                  spoiledChance: _spoiledChance,
                  extraColumnFromDiscovery: _hasDiscovery(DiscoveryId.cartography),
                  minComboForJoker: _hasDiscovery(DiscoveryId.earlyJoker) ? 4 : 5,
                  minComboForBomb: _hasDiscovery(DiscoveryId.earlyBomb) ? 5 : 6,
                  boardStyle: _boardStyle,
                  areaEntries: _buildableAreaEntries(),
                  buildingEntries: _buildableBuildingEntries(),
                ),
              ),
            ) ??
            false;
        if (!mounted) return;
        if (replay) {
          await _restoreCheckpoint(_week);
          if (!mounted) return;
        }
      }
    }

    // HarvestScreen zapisuje zebrane surowce bezpośrednio do trwałego
    // magazynu w trakcie gry, ale nigdy nie aktualizuje _stockpile w pamięci
    // - trzeba to zrobić tutaj, zanim _resolveWeeklyEvent/_applyEventEffect
    // zdąży nadpisać zapis starym stanem sprzed zbiorów (inaczej zebrane w
    // tym tygodniu surowce giną, gdy akurat trafi się wydarzenie z premią).
    final freshStockpile = await ResourceStorage.load();
    if (!mounted) return;
    setState(() => _stockpile = freshStockpile);

    // Wydarzenie tygodniowe - dopiero PO powrocie z planszy zbiorów na
    // widok wioski (początek nowego tygodnia "w wiosce"), nie przed nią.
    await _resolveWeeklyEvent();
    if (!mounted) return;

    final totalSoldiers = _soldierCounts.values.fold(0, (a, b) => a + b);
    if (_ratuszBuilt ||
        _productionBuildings.keys.any((k) => _villageBuilt[k] ?? false) ||
        totalSoldiers > 0 ||
        _populationFoodConsumption > 0) {
      final stockpile = await ResourceStorage.load();
      if (_ratuszBuilt) {
        // Tylko odblokowane surowce - inaczej premia Ratusza pozwoliłaby
        // uzbierać np. jabłka bez budowania Sadu, omijając ścieżkę rozwoju.
        for (final type in kGoalEligibleTypes.where(_unlockedTypes.contains)) {
          stockpile[type] = ((stockpile[type] ?? 0) + _ratuszWeeklyBonusValue).clamp(0, _storageCap);
        }
      }
      for (final entry in _productionBuildings.entries) {
        if ((_villageBuilt[entry.key] ?? false) && _unlockedTypes.contains(entry.value)) {
          final amount = _productionAmountFor(entry.key);
          stockpile[entry.value] = ((stockpile[entry.value] ?? 0) + amount).clamp(0, _storageCap);
        }
      }
      if (totalSoldiers > 0) {
        final foodNeeded = totalSoldiers * _foodPerSoldierWeekly;
        final haveFood = stockpile[ResourceType.apple] ?? 0;
        if (haveFood >= foodNeeded) {
          stockpile[ResourceType.apple] = haveFood - foodNeeded;
        } else {
          final shortage = foodNeeded - haveFood;
          stockpile[ResourceType.apple] = 0;
          var remaining = shortage;
          for (final type in UnitType.values) {
            if (remaining <= 0) break;
            final count = _soldierCounts[type] ?? 0;
            final deserted = remaining < count ? remaining : count;
            if (deserted > 0) {
              _soldierCounts[type] = count - deserted;
              await StatsStorage.saveSoldierCount(type, _soldierCounts[type] ?? 0);
            }
            remaining -= deserted;
          }
        }
      }
      final populationFoodNeeded = _populationFoodConsumption;
      var starving = false;
      if (populationFoodNeeded > 0) {
        final haveGrain = stockpile[ResourceType.grain] ?? 0;
        if (haveGrain >= populationFoodNeeded) {
          stockpile[ResourceType.grain] = haveGrain - populationFoodNeeded;
        } else {
          // Brakujące zboże jest dobierane z jabłek jako zapasowe źródło
          // jedzenia (dokładnie ten brakujący kawałek, nie cała potrzeba) -
          // głód następuje dopiero, gdy i jabłek nie starcza.
          final grainShortfall = populationFoodNeeded - haveGrain;
          stockpile[ResourceType.grain] = 0;
          final haveApple = stockpile[ResourceType.apple] ?? 0;
          if (haveApple >= grainShortfall) {
            stockpile[ResourceType.apple] = haveApple - grainShortfall;
          } else {
            stockpile[ResourceType.apple] = 0;
            starving = true;
          }
        }
      }
      if (starving) {
        setState(() {
          _population = (_population - _effectivePopulationStarvationLoss).clamp(0, _populationLimit);
          _eventMoraleBonus = (_eventMoraleBonus - _populationStarvationMoraleLoss).clamp(-100, 100);
          _lastStarvationWeek = _week;
        });
        await PopulationStorage.save(_population);
        await VillageEventStorage.saveMoraleBonus(_eventMoraleBonus);
        await StoryProgressStorage.saveLastStarvationWeek(_lastStarvationWeek);
      } else if (_population < _populationLimit) {
        final newProgress = _populationGrowthProgress + _effectivePopulationGrowthRate;
        final wholeGrowth = newProgress.floor();
        final grown = (_population + wholeGrowth).clamp(0, _populationLimit);
        setState(() {
          _population = grown;
          _populationGrowthProgress = newProgress - wholeGrowth;
        });
        await PopulationStorage.save(_population);
        await PopulationStorage.saveGrowthProgress(_populationGrowthProgress);
      }
      await ResourceStorage.save(stockpile);
      if (!mounted) return;
    }

    final endingWeek = _week;
    await GameProgressStorage.saveWeek(_week + 1);
    await _load();
    if (!mounted) return;
    // Migawka stanu na początek tego tygodnia - jeśli akt kończący się
    // właśnie teraz okaże się porażką, gracz będzie mógł wczytać dowolny
    // wcześniejszy tydzień (patrz ActFailureScreen/_restoreCheckpoint).
    await _saveCheckpoint();

    final endingAct = storyActForWeek(endingWeek);
    // Ustawiane, gdy właśnie w tym wywołaniu rozstrzygnięto Akt V (ostatni)
    // sukcesem - pokazujemy EndingScreen po komiksie #30, niżej.
    var justWonGame = false;
    if (endingAct != null &&
        endingWeek == endingAct.endWeek &&
        !_resolvedActs.contains(endingAct.actNumber)) {
      final met = _actGoalMet(endingAct.actNumber);
      if (met) {
        final reward = _actGoalReward(endingAct.actNumber);
        setState(() {
          for (final entry in reward.entries) {
            _stockpile[entry.key] = ((_stockpile[entry.key] ?? 0) + entry.value).clamp(0, _storageCap);
          }
        });
        await ResourceStorage.save(_stockpile);
        final rewardText =
            reward.entries.map((e) => '+${e.value} ${e.key.label.toLowerCase()}').join(', ');
        _showSnack(
          l10n.homeActGoalReachedSnack(endingAct.actNumber, endingAct.localizedActName, rewardText),
        );
        setState(() => _resolvedActs = {..._resolvedActs, endingAct.actNumber});
        await StoryProgressStorage.saveResolvedActs(_resolvedActs);
        justWonGame = endingAct.actNumber == 5;
      } else {
        // Porażka celu głównego aktu kończy bieżącą próbę - jedyna droga
        // dalej to wczytać wcześniejszy tydzień albo zacząć od nowa. Checkpoint
        // dla endingWeek+1 (ten zapisany chwilę wyżej) trzeba odfiltrować -
        // to migawka stanu TUŻ PO właśnie stwierdzonej porażce (już w
        // kolejnym tygodniu/porze roku), więc jej "wczytanie" niczego by nie
        // cofnęło - bez tego trafiała na szczyt listy (najnowsza) i wyglądała
        // jak bezpieczny wybór, mimo że nie naprawiała porażki.
        final checkpointWeeks =
            (await CheckpointStorage.listWeeks()).where((w) => w <= endingWeek).toList();
        if (!mounted) return;
        final choice = await Navigator.of(context).push<int>(
          MaterialPageRoute(
            builder: (_) => ActFailureScreen(
              actNumber: endingAct.actNumber,
              actName: endingAct.localizedActName,
              flavorText: _actFailureFlavorText(endingAct.actNumber),
              checkpointWeeks: checkpointWeeks,
            ),
          ),
        );
        if (!mounted) return;
        if (choice == -1) {
          await _startNewGameFromFailure();
        } else if (choice != null) {
          await _restoreCheckpoint(choice);
        }
        if (!mounted) return;
        setState(() => _busy = false);
        return;
      }
    }

    await _checkSideQuests();

    await _showPendingComics();
    if (!mounted) return;
    // Checkpoint zapisany wyżej (przed sprawdzeniem questów i komiksów)
    // jeszcze NIE widział komiksu/questów rozstrzygniętych w tym tygodniu -
    // bez tego powtórnego zapisu "Zagraj tydzień ponownie" w NASTĘPNYM
    // tygodniu (przywracające właśnie ten checkpoint) cofałoby flagę
    // "przeczytany" komiksu tego tygodnia, więc pokazywał się on ponownie.
    await _saveCheckpoint();
    if (!mounted) return;

    if (justWonGame) {
      final optionalQuestIds = kSideQuests
          .map((q) => q.id)
          .where((id) => id != SideQuestId.sladyWPopiele && id != SideQuestId.rozmowaZJadwiga)
          .toList();
      final optionalClaimed = optionalQuestIds.where(_claimedSideQuests.contains).length;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EndingScreen(
            population: _population,
            populationLimit: _populationLimit,
            morale: _moraleValue,
            bossBattleStagesCleared: _bossBattleStagesCleared,
            everStarved: _lastStarvationWeek > 0,
            optionalSideQuestsClaimed: optionalClaimed,
            optionalSideQuestsTotal: optionalQuestIds.length,
            totalSideQuestsClaimed: _claimedSideQuests.length,
            totalSideQuestsCount: kSideQuests.length,
          ),
        ),
      );
      if (!mounted) return;
    }

    setState(() => _busy = false);
  }

  // Sprawdza warunki wszystkich jeszcze nieodebranych questów pobocznych
  // względem bieżącego stanu gry i przyznaje surowce za te już spełnione.
  // Wywoływane co tydzień (koniec _startWeek) oraz przy każdym wejściu w
  // zakładkę "Cele", żeby quest zaliczał się od razu, a nie dopiero po
  // zmianie tygodnia.
  Future<void> _checkSideQuests() async {
    final l10n = AppLocalizations.of(context)!;
    for (final quest in kSideQuests) {
      if (_claimedSideQuests.contains(quest.id)) continue;
      if (!_sideQuestMet(quest.id)) continue;
      setState(() {
        for (final entry in quest.resourceReward.entries) {
          _stockpile[entry.key] = ((_stockpile[entry.key] ?? 0) + entry.value).clamp(0, _storageCap);
        }
        _claimedSideQuests = {..._claimedSideQuests, quest.id};
      });
      await ResourceStorage.save(_stockpile);
      await ExperienceStorage.saveClaimedSideQuests(_claimedSideQuests);
      final rewardText =
          quest.resourceReward.entries.map((e) => '+${e.value} ${e.key.label.toLowerCase()}').join(', ');
      _showSnack(l10n.homeSideQuestCompletedSnack(quest.localizedTitle, rewardText));
    }
  }

  List<_TabSpec> get _tabs {
    final l10n = AppLocalizations.of(context)!;
    return [
        _TabSpec(
          icon: Icons.home_work,
          label: l10n.homeTabVillage,
          builder: () => VillageView(
            ratuszBuilt: _ratuszBuilt,
            palisadeBuilt: _palisadeBuilt,
            builtMap: _villageBuilt,
            extraHousesBuilt: _extraHousesBuilt,
            extraHousesActive: _extraHousesActive,
            workers: _villageWorkers,
            upgradedMap: _villageUpgraded,
            onTapRatusz: _onTapRatusz,
            onTapPalisade: _onTapPalisade,
            onTapBuilding: _onTapVillageBuilding,
            onTapExtraHouse: _onTapExtraHouse,
            onTapEmptyPlot: _onTapEmptyPlot,
          ),
        ),
        _TabSpec(
          icon: Icons.terrain,
          label: l10n.homeTabSurroundings,
          builder: () => SurroundingsView(
            built: _areasBuilt,
            upgraded: _areasUpgraded,
            onTapArea: _onTapArea,
          ),
        ),
        _TabSpec(
          icon: Icons.backpack,
          label: l10n.homeTabResources,
          builder: () => ResourcesView(
            stockpile: _stockpile,
            storageCap: _storageCap,
            unlockedTypes: _unlockedTypes,
            weeklyProduction: _weeklyProductionByType,
            weeklyConsumption: _weeklyConsumptionByType,
            weeklyProductionSources: _weeklyProductionSourcesByType,
            weeklyConsumptionSources: _weeklyConsumptionSourcesByType,
            onTrade: _marketUnlocked ? _showTradeDialog : null,
          ),
        ),
        if (_shopUnlocked)
          _TabSpec(
            icon: Icons.storefront,
            label: l10n.homeTabShop,
            builder: () => ShopView(
              baseMoves: _baseMoves,
              extraMoves: _extraMoves,
              maxTotalMoves: _maxTotalMoves,
              stockpile: _stockpile,
              nextCost: _nextMoveCost,
              onBuy: _buyMove,
              autoMatchTier: _autoMatchTier,
              autoMatchTier1Cost: _autoMatchTier1Cost,
              autoMatchTier2Cost: _autoMatchTier2Cost,
              onBuyAutoMatchTier1: _buyAutoMatchTier1,
              onBuyAutoMatchTier2: _buyAutoMatchTier2,
              sklepLevel2Unlocked: _upgradedL2(BuildingKind.sklep),
              sklepLevel2Bonus: _sklepMovesCapBonus,
              sklepWorkers: _workersFor(BuildingKind.sklep).clamp(0, _maxWorkersPerBuilding),
              maxWorkersPerBuilding: _maxWorkersPerBuilding,
              discovery1Unlocked: _hasDiscovery(DiscoveryId.moves1),
              discovery2Unlocked: _hasDiscovery(DiscoveryId.moves2),
              discoveryMovesBonus: _szkolaMovesBonus,
            ),
          ),
        _TabSpec(
          icon: Icons.bar_chart,
          label: l10n.homeTabStats,
          badgeCount: comicsUnlockedThroughWeek(_week)
              .where((c) => !_readComics.contains(c.number) && _isComicRevealed(c.number))
              .length,
          builder: () => StatsView(
            stats: _stats,
            population: _population,
            populationLimit: _populationLimit,
            morale: _moraleValue,
            security: _securityValue,
            soldierCounts: _soldierCounts,
            armyStrength: _totalArmyStrength,
            comicsUnreadCount: comicsUnlockedThroughWeek(_week)
                .where((c) => !_readComics.contains(c.number) && _isComicRevealed(c.number))
                .length,
            onOpenComics: _openComics,
            boardStyle: _boardStyle,
            onBoardStyleChanged: _setBoardStyle,
            resourceIconStyle: _resourceIconStyle,
            onResourceIconStyleChanged: _setResourceIconStyle,
            onOpenDebug: _openDebug,
            onReplayTutorial: _startTour,
          ),
        ),
        _TabSpec(
          icon: Icons.flag,
          label: l10n.homeTabGoals,
          builder: () => GoalsView(
            week: _week,
            goalMet: (actNumber) => _actGoalMet(actNumber),
            goalRequirements: _actGoalRequirements,
            claimedSideQuests: _claimedSideQuests,
            sideQuestProgress: _sideQuestProgress,
            resolvedActs: _resolvedActs,
          ),
        ),
      ];
  }

  void _openComics() {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(l10n.comicsTitle)),
          body: ComicsView(
            week: _week,
            readComics: _readComics,
            onRead: _markComicRead,
            hiddenComicNumbers: _hiddenComicNumbers,
          ),
        ),
      ),
    );
  }

  void _openDebug() {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(l10n.debugTitle)),
          body: DebugView(
            currentWeek: _week,
            onJumpToWeek: _debugJumpToWeek,
            onAddResource: _debugAddResource,
            onAddAllResources: _debugAddAllResources,
            onFightGrot: _debugFightGrot,
            onFightMarta: _debugFightMarta,
            onFightBogdan: _debugFightBogdan,
            onFightLeszy: _debugFightLeszy,
          ),
        ),
      ),
    );
  }

  Future<void> _debugJumpToWeek(int week) async {
    await GameProgressStorage.saveWeek(week);
    await _load();
    if (!mounted) return;
    _showSnack(AppLocalizations.of(context)!.homeDebugJumpedToWeekSnack(week));
  }

  Future<void> _debugAddResource(ResourceType type) async {
    setState(() {
      _stockpile[type] = ((_stockpile[type] ?? 0) + 100).clamp(0, _storageCap);
    });
    await ResourceStorage.save(_stockpile);
  }

  Future<void> _debugAddAllResources() async {
    setState(() {
      for (final type in ResourceType.values) {
        if (kBattleOnlyResourceTypes.contains(type)) continue;
        _stockpile[type] = ((_stockpile[type] ?? 0) + 100).clamp(0, _storageCap);
      }
    });
    await ResourceStorage.save(_stockpile);
  }

  Future<void> _markComicRead(int number) async {
    if (_readComics.contains(number)) return;
    setState(() => _readComics = {..._readComics, number});
    await ComicStorage.markRead(number);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final tabs = _tabs;
    final safeTab = _tab.clamp(0, tabs.length - 1);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onBackPressed,
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              bottom: false,
              child: KeyedSubtree(key: _tabContentKey, child: tabs[safeTab].builder()),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              child: Container(
                key: _navBarKey,
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < tabs.length; i++)
                      Expanded(
                        child: _NavButton(
                          icon: tabs[i].icon,
                          label: tabs[i].label,
                          selected: safeTab == i,
                          onTap: () {
                            setState(() => _tab = i);
                            if (tabs[i].icon == Icons.flag) {
                              _checkSideQuests();
                            }
                          },
                          badgeCount: tabs[i].badgeCount,
                        ),
                      ),
                    SizedBox(
                      key: _startWeekButtonKey,
                      width: 78,
                      height: 48,
                      child: FilledButton(
                        onPressed: _busy ? null : _startWeek,
                        style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text('→ $_week'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_tourActive)
            TutorialOverlay(
              steps: _tourSteps,
              stepIndex: _tourStepIndex,
              onNext: () => _tourGoTo(_tourStepIndex + 1),
              onBack: _tourStepIndex > 0 ? () => _tourGoTo(_tourStepIndex - 1) : null,
              onSkip: _finishTour,
            ),
        ],
      ),
    );
  }

  /// Przechwytuje przycisk "wstecz" na Androidzie - zamiast od razu zamykać
  /// grę, pyta o potwierdzenie (i tylko na potwierdzenie faktycznie wychodzi).
  Future<void> _onBackPressed(bool didPop, Object? result) async {
    if (didPop) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.homeExitGameTitle),
        content: Text(l10n.homeExitGameMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.homeCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.homeExit),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      SystemNavigator.pop();
    }
  }
}

class _TabSpec {
  final IconData icon;
  final String label;
  final Widget Function() builder;
  final int badgeCount;

  const _TabSpec({
    required this.icon,
    required this.label,
    required this.builder,
    this.badgeCount = 0,
  });
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
    // Bez tekstu pod ikoną (patrz komentarz przy _tabs) zaznaczona zakładka
    // musi się odróżniać samym wyglądem ikony - stąd owalne tło w kolorze
    // akcentu, podobnie jak w standardowym Material 3 NavigationBar.
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? scheme.secondaryContainer : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Badge(
              isLabelVisible: badgeCount > 0,
              label: Text('$badgeCount'),
              child: Icon(icon, color: color, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

class _CostRow extends StatelessWidget {
  final ResourceType type;
  final int have;
  final int need;

  const _CostRow({required this.type, required this.have, required this.need});

  @override
  Widget build(BuildContext context) {
    final ok = have >= need;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 18, height: 18, child: resourceIconAsset(type.assetPath, size: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(type.label)),
          Text(
            '$have / $need',
            style: TextStyle(
              color: ok ? const Color(0xFF2F9E57) : const Color(0xFFC0392B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundRow extends StatelessWidget {
  final ResourceType type;
  final int refund;

  const _RefundRow({required this.type, required this.refund});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 18, height: 18, child: resourceIconAsset(type.assetPath, size: 18)),
          const SizedBox(width: 8),
          Expanded(child: Text(type.label)),
          Text(
            '+$refund',
            style: const TextStyle(color: Color(0xFF2F9E57), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
