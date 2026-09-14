import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/area_kind.dart';
import '../models/comic.dart';
import '../models/discovery.dart';
import '../models/goal_requirement.dart';
import '../models/resource_type.dart';
import '../models/season.dart';
import '../models/side_quest.dart';
import '../models/story_act.dart';
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
import '../widgets/event_popup.dart';
import '../widgets/resource_icon.dart';
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
  static const int _moveBaseCost = 5;
  static const int _moveCostIncrement = 5;
  // Poziom 1: automatyczne czwórki (i więcej). Poziom 2 (ulepszenie): też trójki.
  static const int _autoMatchTier1Cost = 15;
  static const int _autoMatchTier2Cost = 25;
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
  static const int _baseStorageCap = 500;
  static const int _warehouseStorageBonus = 300;
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
  // XP za osiągnięcie celu głównego aktu (questy poboczne mają własne, niższe
  // nagrody zdefiniowane w kSideQuests).
  static const int _mainQuestXpReward = 25;
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
  // mieszkańców. Przy wystarczającej ilości jedzenia i wolnym miejscu poniżej
  // limitu populacja rośnie co tydzień; przy głodzie - maleje, a morale spada.
  static const int _populationFoodDivisor = 4;
  static const int _populationGrowthPerWeek = 1;
  static const int _populationStarvationLoss = 1;
  static const int _populationStarvationMoraleLoss = 5;
  // Odkrycia z Uczelni, które dają stałe premie niezależne od innych
  // budynków (patrz models/discovery.dart).
  static const int _discoveryStorageBonus = 150;
  static const int _discoveryFoodDivisorBonus = 2;
  static const int _discoveryMilitaryBonus = 1;
  static const int _discoveryFastGrowthBonus = 1;
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
  Set<DiscoveryId> _unlockedDiscoveries = {};
  Set<int> _resolvedActs = {};
  int _lastStarvationWeek = 0;
  int _bossBattleStagesCleared = -1;
  int _martaBattleStagesCleared = -1;
  bool _martaFullTrust = false;
  int _bogdanProofComplete = -1;
  bool _leszyVictorious = false;
  int _xp = 0;
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
      _tieredBonus(BuildingKind.magazyn, _warehouseStorageBonus) +
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
    final result = <ResourceType, List<(String, int)>>{};
    if (_ratuszBuilt) {
      for (final type in kGoalEligibleTypes.where(_unlockedTypes.contains)) {
        (result[type] ??= []).add(('Ratusz', _ratuszWeeklyBonusValue));
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

  int get _effectivePopulationGrowth =>
      _populationGrowthPerWeek + (_hasDiscovery(DiscoveryId.fastGrowth) ? _discoveryFastGrowthBonus : 0);

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
    final result = <ResourceType, List<(String, int)>>{};
    final totalSoldiers = _soldierCounts.values.fold(0, (a, b) => a + b);
    if (totalSoldiers > 0) {
      result[ResourceType.apple] = [('Żołnierze', totalSoldiers * _foodPerSoldierWeekly)];
    }
    final populationFood = _populationFoodConsumption;
    if (populationFood > 0) {
      result[ResourceType.grain] = [('Mieszkańcy', populationFood)];
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
    switch (kind) {
      case BuildingKind.sklep:
        return 'Odblokowuje zakładkę "Sklep" w dolnym pasku nawigacji.';
      case BuildingKind.karczma:
        return 'Zwiększa limit populacji o $_karczmaPopulationBonus (widoczne w Statystykach).';
      case BuildingKind.dom:
        return 'Zwiększa limit populacji o $_housePopulationBonus (widoczne w Statystykach).';
      case BuildingKind.kuznia:
        return 'Co tydzień: +$_kuzniaWeeklyGoldBonus złota.';
      case BuildingKind.spichlerz:
        return 'Co tydzień: +$_weeklyProductionBonus do produkcji jabłek. Zmniejsza ryzyko '
            'głodu (utraty zbiorów) o ${_pct(_hungerRiskReductionPerLevel)}.';
      case BuildingKind.piekarnia:
        return 'Co tydzień: +$_weeklyProductionBonus do produkcji zboża.';
      case BuildingKind.tartak:
        return 'Co tydzień: +$_weeklyProductionBonus do produkcji drewna.';
      case BuildingKind.studnia:
        return 'Co tydzień: +$_weeklyProductionBonus do produkcji wody. Zmniejsza ryzyko '
            'pożaru (spalenia zbiorów) o ${_pct(_fireRiskReductionPerLevel)}.';
      case BuildingKind.browar:
        return 'Zwiększa morale wioski o $_breweryMoraleBonus (widoczne w Statystykach).';
      case BuildingKind.kaplica:
        return 'Zmniejsza ogólną szansę zepsucia sezonowego surowca o '
            '${_pct(_kaplicaRiskReductionPerLevel)}. Zwiększa morale wioski o $_kaplicaMoraleBonus.';
      case BuildingKind.szkola:
        return 'Odblokowuje odkrycia w Uczelni (panel poniżej) - m.in. +1 do bazowej '
            'liczby ruchów i możliwość przydzielania pracowników do budynków.';
      case BuildingKind.rynek:
        return 'Odblokowuje handel surowcami w zakładce Surowce (kurs '
            '$_marketGiveAmountBase→$_marketReceiveAmount, poprawia się z rozbudową, '
            'odkryciem Dyplomacji i pracownikami - najlepszy możliwy to '
            '$_marketGiveAmountBest→$_marketReceiveAmount).';
      case BuildingKind.magazyn:
        return 'Zwiększa maksymalną ilość każdego przechowywanego surowca o '
            '$_warehouseStorageBonus.';
      case BuildingKind.kamieniarz:
        return 'Co tydzień: +$_weeklyProductionBonus do produkcji kamienia.';
      case BuildingKind.koszary:
        return 'Zwiększa bezpieczeństwo wioski o $_koszarySecurityBonusPerLevel. Odblokowuje '
            'rekrutację żołnierzy (wymaga zbudowanej Kuźni) - panel poniżej. Każdy żołnierz '
            'zużywa $_foodPerSoldierWeekly jabłko/tydzień - przy braku jabłek część zdezerteruje.';
      default:
        return '';
    }
  }

  String _pct(double fraction) => '${(fraction * 100).round()}%';

  /// Opis premii poziomu 2 (rozbudowy) - wyświetlany w oknie budynku obok
  /// (lub zamiast) premii poziomu 1, analogicznie do _showAreaDialog.
  String _villageUpgradeTextFor(BuildingKind kind) {
    switch (kind) {
      case BuildingKind.ratusz:
        return 'Podwaja premię tygodniową do +${_ratuszWeeklyBonus * 2} każdego surowca.';
      case BuildingKind.palisade:
        return 'Zwiększa limit populacji o kolejne $_palisadePopulationBonus '
            '(razem +${_palisadePopulationBonus * 2}) i bezpieczeństwo wioski o kolejne '
            '$_palisadeSecurityBonus (razem +${_palisadeSecurityBonus * 2}).';
      case BuildingKind.sklep:
        return 'Zwiększa maksymalną liczbę ruchów możliwych do wykupienia w sklepie o '
            '$_sklepMovesCapBonus (niezależnie od bonusu za przydzielonych pracowników).';
      case BuildingKind.karczma:
        return 'Zwiększa limit populacji o kolejne $_karczmaPopulationBonus '
            '(razem +${_karczmaPopulationBonus * 2}).';
      case BuildingKind.dom:
        return 'Zwiększa limit populacji o kolejne $_housePopulationBonus '
            '(razem +${_housePopulationBonus * 2}).';
      case BuildingKind.kuznia:
        return 'Zwiększa premię tygodniową o kolejne $_kuzniaWeeklyGoldBonus złota '
            '(razem +${_kuzniaWeeklyGoldBonus * 2}/tydz.).';
      case BuildingKind.spichlerz:
        return 'Dalej zmniejsza ryzyko głodu o kolejne ${_pct(_hungerRiskReductionPerLevel)} '
            '(razem -${_pct(_hungerRiskReductionPerLevel * 2)}). Produkcja jabłek bez zmian.';
      case BuildingKind.piekarnia:
        return 'Zwiększa produkcję zboża o kolejne $_weeklyProductionBonus '
            '(razem +${_weeklyProductionBonus * 2}/tydz.).';
      case BuildingKind.tartak:
        return 'Zwiększa produkcję drewna o kolejne $_weeklyProductionBonus '
            '(razem +${_weeklyProductionBonus * 2}/tydz.).';
      case BuildingKind.studnia:
        return 'Dalej zmniejsza ryzyko pożaru o kolejne ${_pct(_fireRiskReductionPerLevel)} '
            '(razem -${_pct(_fireRiskReductionPerLevel * 2)}). Produkcja wody bez zmian.';
      case BuildingKind.browar:
        return 'Zwiększa morale wioski o kolejne $_breweryMoraleBonus '
            '(razem +${_breweryMoraleBonus * 2}).';
      case BuildingKind.kaplica:
        return 'Całkowicie usuwa ogólną szansę zepsucia (od tego budynku) i zwiększa morale '
            'wioski o kolejne $_kaplicaMoraleBonus (razem +${_kaplicaMoraleBonus * 2}).';
      case BuildingKind.szkola:
        return 'Odblokowuje zaawansowane odkrycia - m.in. kolejne +1 do bazowej liczby '
            'ruchów (razem +2) i limit 2 pracowników na budynek.';
      case BuildingKind.rynek:
        final afterUpgrade = (_marketGiveAmount - _marketRynekLevelReduction)
            .clamp(_marketGiveAmountBest, _marketGiveAmountBase);
        return 'Poprawia kurs wymiany do $afterUpgrade→$_marketReceiveAmount '
            '(jeden z 3 niezależnych ulepszeń do najlepszego możliwego kursu '
            '$_marketGiveAmountBest→$_marketReceiveAmount).';
      case BuildingKind.magazyn:
        return 'Zwiększa limit magazynowania o kolejne $_warehouseStorageBonus '
            '(razem +${_warehouseStorageBonus * 2}).';
      case BuildingKind.kamieniarz:
        return 'Zwiększa produkcję kamienia o kolejne $_weeklyProductionBonus '
            '(razem +${_weeklyProductionBonus * 2}/tydz.).';
      case BuildingKind.koszary:
        return 'Zwiększa bezpieczeństwo wioski o kolejne $_koszarySecurityBonusPerLevel '
            '(razem +${_koszarySecurityBonusPerLevel * 2}) i podwaja siłę każdego żołnierza.';
    }
  }

  /// "$label: baza X$unit, pracownicy +Y$unit → premia ogólna Z$unit" (albo
  /// samo "$label: X$unit", jeśli budynek nie ma jeszcze pracowników).
  String _bonusLine(String label, num base, num total, String unit) {
    final workerBonus = total - base;
    if (workerBonus == 0) return '$label: $base$unit';
    final sign = workerBonus > 0 ? '+' : '';
    return '$label: baza $base$unit, pracownicy $sign$workerBonus$unit → premia ogólna $total$unit';
  }

  String _bonusPercentLine(String label, double base, double total) {
    if (base == total) return '$label: ${_pct(base)}';
    return '$label: baza ${_pct(base)}, z pracownikami → premia ogólna ${_pct(total)}';
  }

  /// Rozbicie premii budynku na "co produkuje sam budynek" / "ile dają
  /// pracownicy" / "premia ogólna razem" - pokazywane w oknie budynku, żywo
  /// aktualizowane przy zmianie liczby przydzielonych pracowników.
  List<String> _bonusBreakdownFor(BuildingKind kind) {
    switch (kind) {
      case BuildingKind.ratusz:
        final base = _ratuszWeeklyBonus * (_upgradedL2(kind) ? 2 : 1);
        return [_bonusLine('Produkcja każdego surowca', base, _ratuszWeeklyBonusValue, '/tydz.')];
      case BuildingKind.palisade:
        return [
          _bonusLine('Limit populacji', _tieredBaseAmount(kind, _palisadePopulationBonus),
              _tieredBonus(kind, _palisadePopulationBonus), ''),
          _bonusLine('Bezpieczeństwo', _tieredBaseAmount(kind, _palisadeSecurityBonus),
              _tieredBonus(kind, _palisadeSecurityBonus), ''),
        ];
      case BuildingKind.sklep:
        if (!_upgradedL2(kind)) {
          return ['Odblokowuje zakładkę Sklep (liczbowa premia dopiero po rozbudowie).'];
        }
        return [
          'Maks. liczba ruchów do wykupienia: $_maxExtraMoves '
              '(w tym +${_workersFor(kind).clamp(0, _maxWorkersPerBuilding)} od pracowników).',
        ];
      case BuildingKind.karczma:
        return [
          _bonusLine('Limit populacji', _tieredBaseAmount(kind, _karczmaPopulationBonus),
              _tieredBonus(kind, _karczmaPopulationBonus), ''),
        ];
      case BuildingKind.dom:
        return [
          _bonusLine('Limit populacji', _tieredBaseAmount(kind, _housePopulationBonus),
              _tieredBonus(kind, _housePopulationBonus), ''),
        ];
      case BuildingKind.kuznia:
        return [
          _bonusLine('Złoto/tydz.', _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
        ];
      case BuildingKind.spichlerz:
        return [
          _bonusLine('Produkcja jabłek/tydz.', _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
          _bonusPercentLine('Redukcja ryzyka głodu', _tieredBaseFraction(kind, _hungerRiskReductionPerLevel),
              _tieredFraction(kind, _hungerRiskReductionPerLevel)),
        ];
      case BuildingKind.piekarnia:
        return [
          _bonusLine('Produkcja zboża/tydz.', _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
        ];
      case BuildingKind.tartak:
        return [
          _bonusLine('Produkcja drewna/tydz.', _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
        ];
      case BuildingKind.studnia:
        return [
          _bonusLine('Produkcja wody/tydz.', _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
          _bonusPercentLine('Redukcja ryzyka pożaru', _tieredBaseFraction(kind, _fireRiskReductionPerLevel),
              _tieredFraction(kind, _fireRiskReductionPerLevel)),
        ];
      case BuildingKind.browar:
        return [
          _bonusLine('Morale wioski', _tieredBaseAmount(kind, _breweryMoraleBonus),
              _tieredBonus(kind, _breweryMoraleBonus), ''),
        ];
      case BuildingKind.kaplica:
        return [
          _bonusPercentLine('Redukcja ogólnej szansy zepsucia', _tieredBaseFraction(kind, _kaplicaRiskReductionPerLevel),
              _tieredFraction(kind, _kaplicaRiskReductionPerLevel)),
          _bonusLine('Morale wioski', _tieredBaseAmount(kind, _kaplicaMoraleBonus),
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
          'Kurs wymiany: $_marketGiveAmount→$_marketReceiveAmount '
              '(najlepszy możliwy: $_marketGiveAmountBest→$_marketReceiveAmount = 2:1)',
        ];
      case BuildingKind.magazyn:
        return [
          _bonusLine('Limit magazynu', _tieredBaseAmount(kind, _warehouseStorageBonus),
              _tieredBonus(kind, _warehouseStorageBonus), ''),
        ];
      case BuildingKind.kamieniarz:
        return [
          _bonusLine('Produkcja kamienia/tydz.', _productionBaseAmountFor(kind), _productionAmountFor(kind), ''),
        ];
      case BuildingKind.koszary:
        return [
          _bonusLine('Bezpieczeństwo', _tieredBaseAmount(kind, _koszarySecurityBonusPerLevel),
              _tieredBonus(kind, _koszarySecurityBonusPerLevel), ''),
        ];
    }
  }

  int get _totalMoves => _baseMoves + _extraMoves;
  int get _nextMoveCost => _moveBaseCost + _extraMoves * _moveCostIncrement;

  Map<ResourceType, int> _costFor(AreaKind area) {
    switch (area) {
      case AreaKind.orchard:
        return const {ResourceType.wood: 10, ResourceType.stone: 8};
      case AreaKind.meadow:
        return const {ResourceType.wood: 12, ResourceType.stone: 10, ResourceType.apple: 8};
      case AreaKind.field:
        return const {
          ResourceType.wood: 15,
          ResourceType.stone: 12,
          ResourceType.apple: 10,
          ResourceType.grass: 8,
        };
      case AreaKind.river:
      case AreaKind.mountains:
      case AreaKind.forest:
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

  static const _resourcesNotUnlockedMessage =
      'Najpierw odkryj wszystkie surowce w Okolicach (zbuduj Sad, Łąkę i Pole).';

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
    await _maybeShowVillageTutorial();
  }

  /// Samouczek ekranu wioski - pokazuje się tylko raz (patrz
  /// GameProgressStorage.markVillageTutorialSeen), po pierwszym wczytaniu
  /// gry i ewentualnych komiksach, żeby wyjaśnić planszę wioski i zakładki
  /// na dole, zanim gracz zacznie samodzielnie klikać.
  Future<void> _maybeShowVillageTutorial() async {
    final progress = await GameProgressStorage.load();
    if (!mounted || progress.villageTutorialSeen) return;
    await GameProgressStorage.markVillageTutorialSeen();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showVillageTutorialDialog();
    });
  }

  static const _villageTutorialSteps = [
    (
      Icons.home_work,
      'Wioska',
      'Dotknij pustej działki, żeby zbudować budynek, albo gotowego budynku, żeby go '
          'rozbudować lub zobaczyć szczegóły. Ratusz buduje się jako pierwszy i odblokowuje resztę.',
    ),
    (
      Icons.terrain,
      'Okolice',
      'Tereny wokół wioski (rzeka, las, góry...) - ich zabudowa powiększa planszę zbiorów '
          'i daje premie do surowców.',
    ),
    (
      Icons.inventory_2,
      'Surowce',
      'Podgląd zapasów, produkcji i zużycia tygodniowego każdego surowca, a stąd też '
          'wymiana na targu, gdy Rynek jest gotowy.',
    ),
    (
      Icons.storefront,
      'Sklep',
      'Kupuj dodatkowe ruchy na planszy zbiorów i ulepszenia automatycznego dopasowywania '
          '(odblokowuje się w trakcie gry).',
    ),
    (
      Icons.bar_chart,
      'Statystyki',
      'Rekordy, populacja, morale, bezpieczeństwo, armia i komiksy fabularne, a także '
          'wybór wyglądu planszy zbiorów.',
    ),
    (
      Icons.flag,
      'Cele',
      'Cele bieżącego aktu fabuły i questy poboczne - realizuj je, żeby zdobywać '
          'doświadczenie.',
    ),
    (
      Icons.arrow_forward,
      'Przycisk "→"',
      'Kończy tydzień i przenosi do planszy zbiorów (albo starcia z bossem, jeśli akurat wypada).',
    ),
  ];

  void _showVillageTutorialDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Witaj w wiosce'),
        content: SizedBox(
          width: 360,
          height: 420,
          child: ListView.separated(
            itemCount: _villageTutorialSteps.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final (icon, title, description) = _villageTutorialSteps[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(icon, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 2),
                        Text(description, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Rozumiem'),
          ),
        ],
      ),
    );
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
    final unlockedDiscoveries = await DiscoveryStorage.load();
    final resolvedActs = await StoryProgressStorage.loadResolvedActs();
    final lastStarvationWeek = await StoryProgressStorage.loadLastStarvationWeek();
    final bossBattleStagesCleared = await StoryProgressStorage.loadBossBattleStagesCleared();
    final martaBattleStagesCleared = await StoryProgressStorage.loadMartaBattleStagesCleared();
    final martaFullTrust = await StoryProgressStorage.loadMartaFullTrust();
    final bogdanProofComplete = await StoryProgressStorage.loadBogdanProofComplete();
    final leszyVictorious = await StoryProgressStorage.loadLeszyVictorious();
    final xp = await ExperienceStorage.loadXp();
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
      _unlockedDiscoveries = unlockedDiscoveries;
      _resolvedActs = resolvedActs;
      _lastStarvationWeek = lastStarvationWeek;
      _bossBattleStagesCleared = bossBattleStagesCleared;
      _martaBattleStagesCleared = martaBattleStagesCleared;
      _martaFullTrust = martaFullTrust;
      _bogdanProofComplete = bogdanProofComplete;
      _leszyVictorious = leszyVictorious;
      _xp = xp;
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
    final confirmed = await showDialog<bool>(
      context: dialogContext,
      builder: (context) => AlertDialog(
        title: const Text('Zburzyć budynek?'),
        content: Text('Na pewno chcesz zburzyć: $name?\nOdzyskasz połowę zainwestowanych surowców.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFC0392B)),
            child: const Text('Zburz'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _onTapRatusz() async {
    if (!_ratuszBuilt && !_allResourcesUnlocked) {
      _showSnack(_resourcesNotUnlockedMessage);
      return;
    }
    final level2 = _upgradedL2(BuildingKind.ratusz);
    final action = await _showBuildingDialog(
      title: 'Ratusz',
      kind: BuildingKind.ratusz,
      level1: _ratuszBuilt,
      level2: level2,
      cost: _ratuszCost,
      upgradeCost: _villageUpgradeCost,
      bonusText: 'Co tydzień: +$_ratuszWeeklyBonus każdego surowca.\n'
          'Złoto zebrane w ścieżce daje dodatkowo +1 (np. 4 w ścieżce = 5).\n'
          'Wymaga odblokowania wszystkich surowców w Okolicach. Musi zostać '
          'zbudowany jako pierwszy budynek wioski - odblokowuje budowę '
          'pozostałych, a jego rozbudowa (poziom 2) odblokowuje ich rozbudowę.',
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
      _showSnack('Ratusz rozbudowany!');
    }
  }

  Future<void> _onTapPalisade() async {
    if (!_palisadeBuilt && !_allResourcesUnlocked) {
      _showSnack(_resourcesNotUnlockedMessage);
      return;
    }
    final level2 = _upgradedL2(BuildingKind.palisade);
    final action = await _showBuildingDialog(
      title: 'Palisada',
      kind: BuildingKind.palisade,
      level1: _palisadeBuilt,
      level2: level2,
      cost: _palisadeCost,
      upgradeCost: _villageUpgradeCost,
      bonusText: 'Zwiększa limit populacji o $_palisadePopulationBonus i bezpieczeństwo '
          'wioski o $_palisadeSecurityBonus (widoczne w Statystykach).',
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
      _showSnack('Palisada rozbudowana!');
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
      _showSnack('Palisada zburzona - odzyskano połowę surowców.');
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Wojsko', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 4),
        Text('Łączna siła armii: $_totalArmyStrength'),
        Text(
          'Dostępni mieszkańcy: $_population (każda rekrutacja zabiera jednego z wioski).',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (!_kuzniaBuilt) ...[
          const SizedBox(height: 8),
          const Text(
            'Rekrutacja wymaga zbudowanej Kuźni (broń dla żołnierzy).',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ] else ...[
          if (_population < _soldierRecruitCostPopulation) ...[
            const SizedBox(height: 8),
            const Text(
              'Za mało mieszkańców, żeby rekrutować kolejnego żołnierza.',
              style: TextStyle(fontStyle: FontStyle.italic),
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
                        '${type.label}: ${_soldierCounts[type] ?? 0} '
                        '(siła każdego: ${_strengthFor(type)})',
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
                          'Rekrutuj (-$_soldierRecruitCostPopulation mieszkaniec, '
                          '-$_soldierRecruitCostGold złota'
                          '${type.recruitCost.entries.map((e) => ', -${e.value} ${e.key.label.toLowerCase()}').join()})',
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
    final uczelniaLevel = _upgradedL2(BuildingKind.szkola) ? 2 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Odkrycia', style: Theme.of(context).textTheme.labelLarge),
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
          Text(discovery.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(discovery.description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 6),
          if (unlocked)
            const Text(
              'Odkryto',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F9E57)),
            )
          else if (locked)
            Text(
              'Wymaga Uczelni na poziomie ${discovery.requiredBuildingLevel}.',
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
                'Odkryj ('
                '${discovery.cost.entries.map((e) => '-${e.value} ${e.key.label.toLowerCase()}').join(', ')})',
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTapVillageBuilding(BuildingKind kind) async {
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
      showWorkers: kind != BuildingKind.szkola,
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
      _showSnack('${kind.label} rozbudowany!');
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
      _showSnack('${kind.label}: budynek zburzony - odzyskano połowę surowców.');
    }
  }

  /// Dodatkowe, niezależne działki pod zwykłe domy - każda budowalna osobno,
  /// za ten sam koszt, premię i rozbudowę co budynek "Dom" na standardowej
  /// działce (_onTapVillageBuilding). Dwa z pięciu startują jako "zaniedbane"
  /// (odziedziczone po Antonim, patrz SplashScreen._newGame) - trzeba je
  /// najpierw odbudować (osobny, wcześniejszy krok niżej), zanim staną się w
  /// pełni aktywne i będzie można je rozbudować do prawdziwego poziomu 2.
  Future<void> _onTapExtraHouse(int index) async {
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
        title: 'Dom',
        kind: BuildingKind.dom,
        level1: true,
        level2: false,
        cost: cost,
        upgradeCost: _villageUpgradeCost,
        showWorkers: false,
        demolishable: false,
        levelLabel: 'Poziom 0',
        upgradeSectionLabel: 'Odbuduj do poziomu 1',
        notDemolishableText: 'Opuszczonego domu nie można zburzyć - w środku wciąż mieszkają ludzie.',
        bonusText: 'Dom stoi opuszczony i zaniedbany od lat - obecnie nie daje żadnego bonusu do populacji.',
        upgradeText: 'Odbuduj dom, żeby zaczął dawać +$_housePopulationBonus do limitu populacji.',
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
        _showSnack('Dom odbudowany - znów daje bonus do populacji!');
      }
      return;
    }

    final upgradedNow = builtNow && _extraHousesUpgraded[index];
    final action = await _showBuildingDialog(
      title: 'Dom',
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
      _showSnack('Dom rozbudowany!');
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
      _showSnack('Dom zburzony - odzyskano połowę surowców.');
    }
  }

  Future<void> _showTradeDialog() async {
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
            title: const Text('Rynek - handel'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Kurs: $giveAmount surowca za $receiveAmount innego.'),
                const SizedBox(height: 12),
                DropdownButton<ResourceType>(
                  isExpanded: true,
                  value: give,
                  items: [
                    for (final t in types)
                      DropdownMenuItem(
                        value: t,
                        child: Text('Daj: ${t.label} (masz ${_stockpile[t] ?? 0})'),
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
                      DropdownMenuItem(value: t, child: Text('Otrzymaj: ${t.label}')),
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
                      child: const Text('Maks.'),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  maxMultiplier > 0
                      ? 'Razem: oddajesz $totalGive ${give.label}, dostajesz $totalReceive ${receive.label}.'
                      : 'Za mało ${give.label}, żeby wymienić choć raz.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Zamknij'),
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
                          'Wymieniono $totalGive ${give.label} na $totalReceive ${receive.label}.',
                        );
                      }
                    : null,
                child: const Text('Wymień'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _buyMove() async {
    if (_extraMoves >= _maxExtraMoves) return;
    final cost = _nextMoveCost;
    if ((_stockpile[ResourceType.coin] ?? 0) < cost) return;
    setState(() {
      _stockpile[ResourceType.coin] = (_stockpile[ResourceType.coin] ?? 0) - cost;
      _extraMoves += 1;
    });
    await ResourceStorage.save(_stockpile);
    await ShopStorage.saveExtraMoves(_extraMoves);
    _showSnack('Kupiono +1 ruch na tydzień! Teraz: $_totalMoves ruchów.');
  }

  Future<void> _buyAutoMatchTier1() async {
    if (_autoMatchTier >= 1) return;
    if ((_stockpile[ResourceType.coin] ?? 0) < _autoMatchTier1Cost) return;
    setState(() {
      _stockpile[ResourceType.coin] = (_stockpile[ResourceType.coin] ?? 0) - _autoMatchTier1Cost;
      _autoMatchTier = 1;
    });
    await ResourceStorage.save(_stockpile);
    await ShopStorage.saveAutoMatchTier(1);
    _showSnack('Odblokowano automatyczne usuwanie czwórek!');
  }

  Future<void> _buyAutoMatchTier2() async {
    if (_autoMatchTier < 1 || _autoMatchTier >= 2) return;
    if ((_stockpile[ResourceType.coin] ?? 0) < _autoMatchTier2Cost) return;
    setState(() {
      _stockpile[ResourceType.coin] = (_stockpile[ResourceType.coin] ?? 0) - _autoMatchTier2Cost;
      _autoMatchTier = 2;
    });
    await ResourceStorage.save(_stockpile);
    await ShopStorage.saveAutoMatchTier(2);
    _showSnack('Odblokowano automatyczne usuwanie trójek!');
  }

  Future<void> _onTapArea(AreaKind area) async {
    final level1 = _areasBuilt[area] ?? false;
    final level2 = _areasUpgraded[area] ?? false;
    final prereq = area.prerequisite;
    if (!level1 && prereq != null && !(_areasBuilt[prereq] ?? false)) {
      _showSnack('Najpierw zbuduj: ${prereq.label}.');
      return;
    }

    final cost = _costFor(area);
    final upgradeCost = _upgradeCostFor(area);
    final resource = area.resourceType;
    final bonusText = area.isStarterResource
        ? '${resource.label} jest już dostępne na planszy zbiorów - ten budynek '
            'daje dodatkowo +1 do każdej zebranej ścieżki tego surowca.'
        : 'Odblokowuje ${resource.label.toLowerCase()} jako nowy surowiec do '
            'zbierania na planszy zbiorów.';
    final upgradeText = 'Odblokowuje możliwość wyboru ${resource.label.toLowerCase()} jako '
        '"surowca tygodnia" (10-20% więcej na planszy zbiorów w wybranym tygodniu).';

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
      _showSnack(
        '${area.label} rozbudowany! Możesz teraz wybierać ${resource.label.toLowerCase()} '
        'jako surowiec tygodnia.',
      );
    } else if (action == 'demolish' && level1) {
      setState(() {
        for (final entry in cost.entries) {
          _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
        }
        if (level2) {
          for (final entry in upgradeCost.entries) {
            _stockpile[entry.key] = (_stockpile[entry.key] ?? 0) + entry.value ~/ 2;
          }
        }
        _areasBuilt[area] = false;
        _areasUpgraded[area] = false;
      });
      await ResourceStorage.save(_stockpile);
      await AreaStorage.setBuilt(area, false);
      await AreaStorage.setUpgraded(area, false);
      _showSnack('${area.label}: budynek zburzony - odzyskano połowę surowców.');
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
    final canAffordBuild = _canAfford(cost);
    final canAffordUpgrade = _canAfford(upgradeCost);
    final resource = area.resourceType;
    final title = !level1
        ? area.label
        : level2
            ? '${area.label} (rozbudowany)'
            : '${area.label} (zbudowany)';

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
                Text('Koszt budowy (poziom 1)', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                for (final entry in cost.entries)
                  _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                const SizedBox(height: 12),
                Text('Efekt', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(bonusText),
              ] else ...[
                Text('Poziom 1', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(bonusText),
                const SizedBox(height: 14),
                if (!level2) ...[
                  Text('Rozbudowa do poziomu 2', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  for (final entry in upgradeCost.entries)
                    _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                  const SizedBox(height: 4),
                  Text(upgradeText),
                ] else ...[
                  Text('Poziom 2', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(upgradeText),
                ],
                const SizedBox(height: 14),
                Text(
                  'Zburzenie zwróci połowę wszystkich zainwestowanych surowców.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (level1)
            TextButton(
              onPressed: () async {
                final confirmed = await _confirmDemolish(context, title);
                if (confirmed && context.mounted) Navigator.of(context).pop('demolish');
              },
              style: TextButton.styleFrom(foregroundColor: const Color(0xFFC0392B)),
              child: const Text('Zburz'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(level1 && level2 ? 'Zamknij' : 'Anuluj'),
          ),
          if (!level1)
            FilledButton(
              onPressed: canAffordBuild ? () => Navigator.of(context).pop('build') : null,
              child: const Text('Zbuduj'),
            ),
          if (level1 && !level2)
            FilledButton(
              onPressed: canAffordUpgrade ? () => Navigator.of(context).pop('upgrade') : null,
              child: const Text('Rozbuduj'),
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
    String levelLabel = 'Poziom 1',
    String upgradeSectionLabel = 'Rozbudowa do poziomu 2',
    String notDemolishableText = 'Głównego budynku wioski nie można zburzyć.',
    Widget Function(BuildContext, StateSetter)? extraContentBuilder,
  }) {
    // Ratusz to "główny budynek" wioski: musi być zbudowany, zanim można
    // zbudować cokolwiek innego, a jego rozbudowa (poziom 2) odblokowuje
    // rozbudowę pozostałych budynków. Nie dotyczy to samego Ratusza.
    final buildLocked = kind != BuildingKind.ratusz && !level1 && !_ratuszBuilt;
    final upgradeLocked = kind != BuildingKind.ratusz && !_upgradedL2(BuildingKind.ratusz);
    final canAffordBuild = !buildLocked && _canAfford(cost);
    final canAffordUpgrade = !upgradeLocked && _canAfford(upgradeCost);
    final dialogTitle = !level1
        ? title
        : (upgradable && level2)
            ? '$title (rozbudowany)'
            : '$title (zbudowany)';

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
                    const Text(
                      'Zablokowane',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                    ),
                    const SizedBox(height: 6),
                    const Text('Najpierw zbuduj Ratusz (główny budynek wioski).'),
                  ] else ...[
                    Text('Koszt budowy', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    for (final entry in cost.entries)
                      _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                    const SizedBox(height: 12),
                    Text('Premie', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(bonusText),
                  ],
                ] else if (!upgradable) ...[
                  Text('Odzysk przy zburzeniu (50%)', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 6),
                  for (final entry in cost.entries)
                    _RefundRow(type: entry.key, refund: entry.value ~/ 2),
                  const SizedBox(height: 12),
                  Text('Premie', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(bonusText),
                ] else ...[
                  Text(levelLabel, style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(bonusText),
                  const SizedBox(height: 14),
                  if (!level2) ...[
                    Text(upgradeSectionLabel, style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    if (upgradeLocked) ...[
                      const Text(
                        'Wymaga rozbudowanego (poziom 2) Ratusza.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                      ),
                    ] else ...[
                      for (final entry in upgradeCost.entries)
                        _CostRow(type: entry.key, have: _stockpile[entry.key] ?? 0, need: entry.value),
                      const SizedBox(height: 4),
                      Text(upgradeText),
                    ],
                  ] else ...[
                    Text('Poziom 2', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(upgradeText),
                  ],
                  const SizedBox(height: 14),
                  Text(
                    demolishable
                        ? 'Zburzenie zwróci połowę wszystkich zainwestowanych surowców.'
                        : notDemolishableText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (level1 && showWorkers) ...[
                  const SizedBox(height: 14),
                  Text('Premia ogólna', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  for (final line in _bonusBreakdownFor(kind))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(line),
                    ),
                  const SizedBox(height: 14),
                  Text('Pracownicy', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 2),
                  if (_maxWorkersPerBuilding == 0) ...[
                    const Text(
                      'Wymaga odkrycia "Zarządzanie pracownikami" w Uczelni.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ] else ...[
                    Text(
                      'Każdy przydzielony mieszkaniec zwiększa premię budynku o +50% '
                      '(maks. $_maxWorkersPerBuilding = '
                      '${_maxWorkersPerBuilding == 2 ? "podwójna" : "+50%"} premia).',
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
                      'Wolni mieszkańcy: $_availableWorkers',
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
                child: const Text('Zburz'),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(level1 && (!upgradable || level2) ? 'Zamknij' : 'Anuluj'),
            ),
            if (!level1)
              FilledButton(
                onPressed: canAffordBuild ? () => Navigator.of(context).pop('build') : null,
                child: const Text('Zbuduj'),
              ),
            if (level1 && upgradable && !level2)
              FilledButton(
                onPressed: canAffordUpgrade ? () => Navigator.of(context).pop('upgrade') : null,
                child: const Text('Rozbuduj'),
              ),
          ],
        ),
      ),
    );
  }

  Future<ResourceType?> _showWeeklyBoostPicker(List<ResourceType> options) {
    return showDialog<ResourceType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Surowiec tygodnia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Dzięki rozbudowanym (poziom 2) okolicom wioski możesz wybrać '
              'surowiec, który w tym tygodniu będzie pojawiał się częściej (+10-20%).',
            ),
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
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Pomiń')),
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
      final options = event.options!;
      final choiceIndex = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(event.title),
          content: Text(event.description),
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
      final bonusText = _formatEventEffect(option.effect);
      _showSnack(
        '${event.title}: ${option.resultText}${bonusText.isEmpty ? '' : ' ($bonusText)'}',
      );
    } else {
      await _applyEventEffect(event.effect!);
      if (!mounted) return;
      final icon = event.kind == VillageEventKind.positive ? '✨' : '⚠️';
      final bonusText = _formatEventEffect(event.effect!);
      _showSnack(
        '$icon ${event.title}: ${event.description}${bonusText.isEmpty ? '' : ' ($bonusText)'}',
      );
    }
  }

  // Zamienia efekt wydarzenia na czytelny tekst premii/kar, np.
  // "+5 drewna, -8 morale" - dołączany do opisu wydarzenia w powiadomieniu.
  String _formatEventEffect(EventEffect effect) {
    final parts = <String>[];
    for (final entry in effect.resourceDelta.entries) {
      if (entry.value == 0) continue;
      final sign = entry.value > 0 ? '+' : '';
      parts.add('$sign${entry.value} ${entry.key.label.toLowerCase()}');
    }
    if (effect.moraleDelta != 0) {
      parts.add('${effect.moraleDelta > 0 ? '+' : ''}${effect.moraleDelta} morale');
    }
    if (effect.securityDelta != 0) {
      parts.add('${effect.securityDelta > 0 ? '+' : ''}${effect.securityDelta} bezpieczeństwa');
    }
    if (effect.populationDelta != 0) {
      parts.add('${effect.populationDelta > 0 ? '+' : ''}${effect.populationDelta} populacji');
    }
    if (effect.soldierDelta != 0) {
      parts.add(
        effect.soldierDelta > 0
            ? '+${effect.soldierDelta} żołnierzy'
            : '${effect.soldierDelta} żołnierzy (straty)',
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
  GoalRequirement _battleRequirement(String label, int stagesCleared, int requiredStages) {
    if (stagesCleared < 0) {
      return GoalRequirement(label: label, met: false, progress: 'jeszcze nie stoczono');
    }
    return GoalRequirement(
      label: label,
      met: stagesCleared >= requiredStages,
      progress: '$stagesCleared/3 etapów (min. $requiredStages)',
    );
  }

  /// Szczegółowa, żywa lista wymagań celu głównego danego aktu - pokazywana
  /// w zakładce Cele z aktualnym postępem, nie tylko jako opis tekstowy.
  List<GoalRequirement> _actGoalRequirements(int actNumber) {
    switch (actNumber) {
      case 0:
        return [
          GoalRequirement(label: 'Ratusz zbudowany', met: _ratuszBuilt),
          GoalRequirement(label: 'Sad rozwinięty', met: _areasBuilt[AreaKind.orchard] ?? false),
          GoalRequirement(label: 'Łąka rozwinięta', met: _areasBuilt[AreaKind.meadow] ?? false),
          GoalRequirement(label: 'Pole rozwinięte', met: _areasBuilt[AreaKind.field] ?? false),
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
        return [_battleRequirement('Starcie z Grotem', _bossBattleStagesCleared, 2)];
      case 2:
        // Rozstrzygane przez starcie z Martą (tydzień 39, MartaBattleScreen) -
        // 2 lub 3 z 3 ukończonych etapów liczą się jako sukces.
        return [_battleRequirement('Starcie z Martą', _martaBattleStagesCleared, 2)];
      case 3:
        // Rozstrzygane przez starcie z Bogdanem (tydzień 52,
        // BogdanBattleScreen) - trzeba zebrać cały Dowód.
        return [GoalRequirement(label: 'Pełny Dowód zebrany u Bogdana', met: _bogdanProofComplete == 1)];
      case 4:
        // Leszy budzi się w komiksie #24 ("Przebudzenie", tydzień 58), ale
        // sama walka jest teraz dopiero w środku Aktu V (patrz
        // _leszyBattleWeek) - cel Aktu IV to sprawdzian gotowości wioski na
        // to, co nadchodzi, nie sama walka.
        return [
          GoalRequirement(label: 'Siła armii', met: _totalArmyStrength >= 20, progress: '$_totalArmyStrength/20'),
          GoalRequirement(
            label: 'Bezpieczeństwo wioski',
            met: _securityValue >= 50,
            progress: '$_securityValue/50',
          ),
        ];
      case 5:
        // "Leszy pokonany" rozstrzygane przez starcie w tygodniu 64
        // (LeszyBattleScreen) - w praktyce zawsze true w tygodniu 65, bo
        // porażka nie pozwala tygodniowi minąć (patrz _startWeek).
        return [
          GoalRequirement(label: 'Leszy pokonany', met: _leszyVictorious),
          GoalRequirement(
            label: 'Quest "Ślady w popiele"',
            met: _claimedSideQuests.contains(SideQuestId.sladyWPopiele),
          ),
          GoalRequirement(
            label: 'Quest "Rozmowa z Jadwigą"',
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
    switch (id) {
      case SideQuestId.martaIncognito:
        return '${_moraleValue.round()}/70 morale';
      case SideQuestId.ostatniaSzarza:
        return '$_totalArmyStrength/20 siły armii';
      case SideQuestId.wdowaPoNajemniku:
        final stages = _bossBattleStagesCleared < 0 ? 0 : _bossBattleStagesCleared;
        final karczma = (_villageBuilt[BuildingKind.karczma] ?? false) ? 'zbudowana' : 'niezbudowana';
        return 'Grot: $stages/3 etapów (min. 2) • Karczma: $karczma';
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
    setState(() => _bossBattleStagesCleared = result.stagesCleared);
    await StoryProgressStorage.saveBossBattleStagesCleared(result.stagesCleared);
    if (result.stagesCleared == 3) {
      setState(() {
        _stockpile[ResourceType.coin] = ((_stockpile[ResourceType.coin] ?? 0) + 15).clamp(0, _storageCap);
        _stockpile[ResourceType.wood] = ((_stockpile[ResourceType.wood] ?? 0) + 15).clamp(0, _storageCap);
      });
      await ResourceStorage.save(_stockpile);
      _showSnack('Grot pokonany bez strat! Łup: +15 złota, +15 drewna.');
    } else if (result.stagesCleared == 2) {
      setState(() {
        _stockpile[ResourceType.wood] = ((_stockpile[ResourceType.wood] ?? 0) * 0.9).round();
        _stockpile[ResourceType.coin] = ((_stockpile[ResourceType.coin] ?? 0) * 0.9).round();
      });
      await ResourceStorage.save(_stockpile);
      _showSnack('Grot odparty, ale starcie kosztowało wioskę: -10% drewna i złota.');
    } else {
      _showSnack('Grot przełamał obronę wioski - ukończono tylko ${result.stagesCleared}/3 etapów starcia.');
    }
  }

  /// Rozstrzyga skutki starcia z Martą (tydzień 39) zaraz po powrocie z
  /// MartaBattleScreen. Porażka (0-1/3 etapów) NIE dostaje tu żadnej kary -
  /// tę nakłada automatycznie generyczny mechanizm końca aktu niżej w
  /// _startWeek, bo _actGoalMet(2) zwróci false.
  Future<void> _resolveMartaBattleResult(MartaBattleResult result) async {
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
        result.fullTrustBonus
            ? 'Marta w pełni Ci zaufała, dając sobie czas na rozmowę: +15 morale.'
            : 'Marta przełamana - staje się sojuszniczką: +10 morale.',
      );
    } else if (result.stagesCleared == 2) {
      _showSnack('Marta częściowo Ci zaufała, ale wciąż coś ukrywa.');
    } else {
      _showSnack('Marta wycofała się, nie zdradzając niczego więcej - ukończono tylko '
          '${result.stagesCleared}/3 etapów starcia.');
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
      _showSnack('Bogdan pęka całkowicie pod ciężarem dowodów i ucieka bez zemsty.');
    } else if (result.proofComplete) {
      _showSnack('Bogdan ucieka, ale zdążył podpalić część magazynu '
          '(${result.totalBurns} raz(y)) po drodze.');
    } else {
      _showSnack('Nie udało się przełamać Bogdana - magazyn ucierpiał '
          '${result.totalBurns} raz(y), a on wciąż jest przekonany o swojej racji.');
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
    _showSnack('Debug: starcie z Grotem zakończone - ${result.stagesCleared}/3 etapów '
        '(bez wpływu na zapis gry).');
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
    _showSnack('Debug: starcie z Martą zakończone - ${result.stagesCleared}/3 etapów'
        '${result.fullTrustBonus ? ' (pełne zaufanie)' : ''} (bez wpływu na zapis gry).');
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
    _showSnack('Debug: starcie z Bogdanem zakończone - Dowód ${result.proofComplete ? "zebrany" : "niepełny"}, '
        '${result.totalBurns} spalenie(a) (bez wpływu na zapis gry).');
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
    _showSnack('Debug: starcie z Leszym zakończone - '
        '${result.victory ? "zwycięstwo" : "porażka"} (bez wpływu na zapis gry).');
  }

  // Tekst wyjaśniający, co poszło nie tak, pokazywany na ActFailureScreen -
  // porażka celu głównego aktu to teraz prawdziwy koniec próby (ekran
  // porażki + wczytanie checkpointu), nie "miękka" kara pozwalająca grać
  // dalej, dlatego te opisy już nie mutują żadnego stanu gry.
  String _actFailureFlavorText(int actNumber) {
    switch (actNumber) {
      case 0:
        return 'Wioska nie zdążyła przygotować się na czas - dziedzictwo Antoniego zostało zaprzepaszczone.';
      case 1:
        return 'Grot przełamał obronę nieprzygotowanej wioski.';
      case 2:
        return 'Marta nie zdradziła kluczowej prawdy, a wioska straciła nadzieję.';
      case 3:
        return 'Osłabiona głodem i słabą obroną wioska nie przetrwała konfrontacji z Bogdanem.';
      case 4:
        return 'Wioska nie zdążyła się przygotować - armia zbyt słaba, mury zbyt kruche na to, co nadchodzi z lasu.';
      case 5:
        return 'Leszy został pokonany, ale niektóre wątki pozostają niedomknięte - historia kończy się bez pełnej odpowiedzi.';
      default:
        return 'Cel tego aktu nie został osiągnięty.';
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
      'unlockedDiscoveries': _unlockedDiscoveries.map((d) => d.name).toList(),
      'resolvedActs': _resolvedActs.toList(),
      'lastStarvationWeek': _lastStarvationWeek,
      'bossBattleStagesCleared': _bossBattleStagesCleared,
      'martaBattleStagesCleared': _martaBattleStagesCleared,
      'martaFullTrust': _martaFullTrust,
      'bogdanProofComplete': _bogdanProofComplete,
      'leszyVictorious': _leszyVictorious,
      'xp': _xp,
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

    await ExperienceStorage.saveXp(snapshot['xp'] as int);
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

    if (_week == _grotBattleWeek) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BossIntroScreen(
            week: _week,
            bossName: 'Grot',
            message: 'Grot i jego zbrojni zbliżają się do wioski. Czas przygotować obronę.',
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
            message: 'Marta staje naprzeciw Ciebie, uzbrojona, wysłana przez ojca. Nie ma odwrotu.',
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
            message: 'Bogdan Kruk przybywa osobiście, żądając prawdy. Konfrontacja jest nieunikniona.',
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
            message: 'Mroczny cień lasu budzi się w pełni. Ostateczne starcie o los wioski zaczyna się teraz.',
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
      _showSnack('Leszy pokonany! Cień cofa się w głąb ziemi.');
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
          stockpile[ResourceType.grain] = 0;
          starving = true;
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
        final grown = (_population + _effectivePopulationGrowth).clamp(0, _populationLimit);
        if (grown != _population) {
          setState(() => _population = grown);
          await PopulationStorage.save(_population);
        }
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
        setState(() => _xp += _mainQuestXpReward);
        await ExperienceStorage.saveXp(_xp);
        _showSnack(
          'Cel Aktu ${endingAct.actNumber} ("${endingAct.actName}") osiągnięty! (+$_mainQuestXpReward XP)',
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
              actName: endingAct.actName,
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
            xp: _xp,
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
  // względem bieżącego stanu gry i przyznaje XP za te już spełnione.
  // Wywoływane co tydzień (koniec _startWeek) oraz przy każdym wejściu w
  // zakładkę "Cele", żeby quest zaliczał się od razu, a nie dopiero po
  // zmianie tygodnia.
  Future<void> _checkSideQuests() async {
    for (final quest in kSideQuests) {
      if (_claimedSideQuests.contains(quest.id)) continue;
      if (!_sideQuestMet(quest.id)) continue;
      setState(() {
        _xp += quest.xpReward;
        _claimedSideQuests = {..._claimedSideQuests, quest.id};
      });
      await ExperienceStorage.saveXp(_xp);
      await ExperienceStorage.saveClaimedSideQuests(_claimedSideQuests);
      _showSnack('Quest poboczny ukończony: "${quest.title}" (+${quest.xpReward} XP)');
    }
  }

  List<_TabSpec> get _tabs => [
        _TabSpec(
          icon: Icons.home_work,
          label: 'Wioska',
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
          label: 'Okolice',
          builder: () => SurroundingsView(
            built: _areasBuilt,
            upgraded: _areasUpgraded,
            onTapArea: _onTapArea,
          ),
        ),
        _TabSpec(
          icon: Icons.inventory_2,
          label: 'Surowce',
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
            label: 'Sklep',
            builder: () => ShopView(
              baseMoves: _baseMoves,
              extraMoves: _extraMoves,
              maxTotalMoves: _maxTotalMoves,
              goldAvailable: _stockpile[ResourceType.coin] ?? 0,
              nextCost: _nextMoveCost,
              onBuy: _buyMove,
              autoMatchTier: _autoMatchTier,
              autoMatchTier1Cost: _autoMatchTier1Cost,
              autoMatchTier2Cost: _autoMatchTier2Cost,
              onBuyAutoMatchTier1: _buyAutoMatchTier1,
              onBuyAutoMatchTier2: _buyAutoMatchTier2,
            ),
          ),
        _TabSpec(
          icon: Icons.bar_chart,
          label: 'Statystyki',
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
            xp: _xp,
            boardStyle: _boardStyle,
            onBoardStyleChanged: _setBoardStyle,
            resourceIconStyle: _resourceIconStyle,
            onResourceIconStyleChanged: _setResourceIconStyle,
          ),
        ),
        _TabSpec(
          icon: Icons.flag,
          label: 'Cele',
          builder: () => GoalsView(
            week: _week,
            goalMet: (actNumber) => _actGoalMet(actNumber),
            goalRequirements: _actGoalRequirements,
            claimedSideQuests: _claimedSideQuests,
            sideQuestProgress: _sideQuestProgress,
            resolvedActs: _resolvedActs,
          ),
        ),
        _TabSpec(
          icon: Icons.bug_report,
          label: 'Debug',
          builder: () => DebugView(
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
      ];

  void _openComics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Komiksy')),
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

  Future<void> _debugJumpToWeek(int week) async {
    await GameProgressStorage.saveWeek(week);
    await _load();
    if (!mounted) return;
    _showSnack('Debug: przeniesiono do tygodnia $week.');
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
      child: Scaffold(
      body: SafeArea(
        bottom: false,
        child: tabs[safeTab].builder(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
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
                      if (tabs[i].label == 'Cele') {
                        _checkSideQuests();
                      }
                    },
                    badgeCount: tabs[i].badgeCount,
                  ),
                ),
              SizedBox(
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
    );
  }

  /// Przechwytuje przycisk "wstecz" na Androidzie - zamiast od razu zamykać
  /// grę, pyta o potwierdzenie (i tylko na potwierdzenie faktycznie wychodzi).
  Future<void> _onBackPressed(bool didPop, Object? result) async {
    if (didPop) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wyjść z gry?'),
        content: const Text('Na pewno chcesz zamknąć Rolnika?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Wyjdź'),
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
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: badgeCount > 0,
              label: Text('$badgeCount'),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
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
