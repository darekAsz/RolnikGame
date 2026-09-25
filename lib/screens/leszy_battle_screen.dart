import 'dart:math';

import 'package:flutter/material.dart';

import '../models/resource_type.dart';
import '../models/season.dart';
import '../services/board_style_storage.dart';
import '../utils/battle_balance.dart';
import '../widgets/harvest_grid.dart';
import '../widgets/resource_icon.dart';
import '../widgets/season_background.dart';
import '../l10n/gen/app_localizations.dart';

/// Wynik starcia z Leszym - zawsze true, bo w razie porażki gracz dostaje
/// ekran Game Over z możliwością powtórzenia całej walki od nowa (patrz
/// _Phase.gameOver) albo wyjścia bez przechodzenia tygodnia (false).
class LeszyBattleResult {
  final bool victory;
  const LeszyBattleResult(this.victory);
}

enum _Screen { onslaught, heartOfShadow }

enum _Phase { intro, fighting, gameOver, victory }

enum _LeszyMove {
  strike,
  drain,
  shadow,
  fury,
  fog,
  poison,
  hunger,
  consume,
  rend,
  despair,
  blight,
  otherworld,
  crumblingResolve,
}

// Ruchy Nawałnicy (faza 1) i Serca Cienia (faza 2, patrz _rollNextMove) się
// NIE powtarzają - to naprawdę inny, "prawdziwy" przeciwnik, nie ta sama
// lista z wyższymi liczbami - poza Uderzeniem, które zostaje wspólnym,
// podstawowym atakiem obu faz.
const _onslaughtMoves = [
  _LeszyMove.strike,
  _LeszyMove.drain,
  _LeszyMove.shadow,
  _LeszyMove.fury,
  _LeszyMove.fog,
  _LeszyMove.poison,
  _LeszyMove.hunger,
];

const _heartOfShadowMoves = [
  _LeszyMove.strike,
  _LeszyMove.consume,
  _LeszyMove.rend,
  _LeszyMove.despair,
  _LeszyMove.blight,
  _LeszyMove.otherworld,
  _LeszyMove.crumblingResolve,
];

/// Starcie z Leszym (koniec Aktu IV, tydzień 59) - ostatni i najtrudniejszy
/// boss. W przeciwieństwie do Grota/Marty/Bogdana to prawdziwa walka na PŻ
/// (bo Leszy to nie człowiek, którego trzeba przekonać, tylko istota, którą
/// trzeba powstrzymać) rozgrywana w dwóch następujących po sobie ekranach -
/// oba trzeba wygrać. Porażka w którymkolwiek = Game Over i powtórka całej
/// walki od nowa (bez utraty postępu w grze poza samą bitwą).
class LeszyBattleScreen extends StatefulWidget {
  final int week;
  final int security;
  final int armyStrength;
  final int autoMatchTier;
  final BoardStyle boardStyle;
  final Set<ResourceType> bonusTypes;

  const LeszyBattleScreen({
    super.key,
    required this.week,
    required this.security,
    required this.armyStrength,
    this.autoMatchTier = 0,
    this.boardStyle = BoardStyle.photo,
    this.bonusTypes = const {},
  });

  @override
  State<LeszyBattleScreen> createState() => _LeszyBattleScreenState();
}

class _LeszyBattleScreenState extends State<LeszyBattleScreen> {
  static const _leszyTurnInterval = 5;
  static const _shieldCap = 50;
  // Próg wybuchu Cienia zaczyna się na 15, ale "Zagęszczenie cienia"
  // (patrz _LeszyMove.shadow) obniża go trwale o 1 za każdym użyciem, więc
  // z czasem coraz mniej kulek Cienia na planszy wystarcza do wybuchu - stąd
  // zwykłe pole, nie stała, z dolnym limitem, żeby nigdy nie spadł do
  // absurdalnie niskiej wartości.
  static const _corruptionThresholdStart = 15;
  static const _corruptionThresholdMin = 10;
  late int _corruptionThreshold;
  // Jedno źródło opisów zdolności - używane zarówno na planszy wstępnej
  // (_abilityLegend), jak i jako tooltip przycisków na ekranie walki
  // (_abilityButton), żeby koszt/efekt nie rozjechał się w dwóch miejscach.
  static List<({String name, String cost, String effect})> _abilitiesList(AppLocalizations l10n) => [
    (name: l10n.leszyAbilityCounterName, cost: l10n.leszyAbilityCounterCost, effect: l10n.leszyAbilityCounterEffect),
    (name: l10n.leszyAbilityGuardName, cost: l10n.leszyAbilityGuardCost, effect: l10n.leszyAbilityGuardEffect),
    (name: l10n.leszyAbilityHealName, cost: l10n.leszyAbilityHealCost, effect: l10n.leszyAbilityHealEffect),
    (
      name: l10n.leszyAbilityCleanseName,
      cost: l10n.leszyAbilityCleanseCost,
      effect: l10n.leszyAbilityCleanseEffect,
    ),
    (name: l10n.leszyAbilityPrayerName, cost: l10n.leszyAbilityPrayerCost, effect: l10n.leszyAbilityPrayerEffect),
    (name: l10n.leszyAbilityCalmName, cost: l10n.leszyAbilityCalmCost, effect: l10n.leszyAbilityCalmEffect),
    (
      name: l10n.leszyAbilityWallName,
      cost: l10n.leszyAbilityWallCost,
      effect: l10n.leszyAbilityWallEffect,
    ),
    (
      name: l10n.leszyAbilityDispelFuryName,
      cost: l10n.leszyAbilityDispelFuryCost,
      effect: l10n.leszyAbilityDispelFuryEffect,
    ),
    (
      name: l10n.leszyAbilityAbundanceName,
      cost: l10n.leszyAbilityAbundanceCost,
      effect: l10n.leszyAbilityAbundanceEffect,
    ),
  ];
  // Ikony przycisków paska umiejętności (patrz _abilityButton) - kolejność
  // 1:1 z _abilities.
  static const _abilityIcons = [
    Icons.flash_on,
    Icons.shield,
    Icons.healing,
    Icons.auto_fix_high,
    Icons.self_improvement,
    Icons.spa,
    Icons.fort,
    Icons.blur_off,
    Icons.auto_awesome,
  ];
  static const _boardTypes = {
    ResourceType.wood,
    ResourceType.stone,
    ResourceType.water,
    ResourceType.sword,
    ResourceType.shield,
    ResourceType.shadow,
  };

  final _random = Random();
  GlobalKey<HarvestGridState> _gridKey = GlobalKey<HarvestGridState>();

  // Prawdziwe maksimum wyliczone z bezpieczeństwa wioski - niezmienne, do
  // przywracania przy "Spróbuj ponownie" (patrz _retry). _villageMaxHp
  // zaczyna się od tej wartości, ale "Zachwianie Woli" (Serce Cienia) może
  // je trwale obniżyć w trakcie walki - stąd nie jest to samo pole.
  late final int _villageMaxHpBase;
  late int _villageMaxHp;
  late int _villageHp;

  late _Screen _screen;
  _Phase _phase = _Phase.intro;

  late int _leszyMaxHp;
  late int _leszyHp;
  int _shieldPoints = 0;

  // Bez limitu - liczy tylko ile ruchów gracz zrobił na tym ekranie (do
  // wyświetlenia), walka trwa aż PŻ Wioski albo Leszego spadnie do zera.
  int _movesUsedInScreen = 0;
  int _movesSinceLeszyTurn = 0;
  // Bomba wybuchająca na tym samym ruchu, który już powalił Leszego,
  // wywołuje _onHarvestBoard/_afterLeszyDamage ponownie przez zniszczone
  // sąsiednie kafelki - bez tego guardu przejście onslaught->heartOfShadow
  // potrafiło się rozstrzygnąć dwukrotnie z rzędu i od razu kończyć walkę.
  bool _leszyDefeatHandled = false;

  int _bankedWood = 0;
  int _bankedStone = 0;
  int _bankedWater = 0;
  int _corruption = 0;

  bool _furiaPending = false;
  bool _prayerActive = false;
  int _poisonTicksRemaining = 0;
  // Prawda/blokada przed wielokrotnym zakolejkowaniem wybuchu Cienia w
  // trakcie opóźnienia (patrz _checkShadowExplosion) - bez tego kolejny ruch
  // zdążony tuż przed właściwym wybuchem potrafiłby zaplanować drugi.
  bool _shadowExploding = false;
  // Obfitość: liczba kolejnych zebranych ścieżek (dowolnego typu), które
  // mają zostać podwojone - patrz _onHarvestBoard.
  int _doubleHarvestCharges = 0;
  // Zaświat (Serce Cienia): liczba kolejnych trafień Mieczem, które zadadzą
  // tylko połowę obrażeń - patrz _onHarvestBoard.
  int _leszyEvasionCharges = 0;
  // Rośnie o 1 z każdą turą Leszego (patrz _leszyTurn) - dolicza się wprost
  // do obrażeń uderzenia, więc przeciąganie walki w nieskończoność robi się
  // coraz bardziej karane.
  int _leszyStrength = 0;

  String _lastLeszyAction = '';
  // Ruch wylosowany z wyprzedzeniem, zaraz po poprzedniej turze Leszego -
  // dzięki temu gracz widzi zapowiedź ("co zrobi") zamiast dowiadywać się
  // o ataku dopiero po fakcie.
  late _LeszyMove _nextMove;

  @override
  void initState() {
    super.initState();
    // Bezpieczeństwo teoretycznie sięga aż +100 (Palisada i Koszary obie na
    // poziomie 2 plus podwojenie przez maks. pracowników) - bez capa PŻ
    // Wioski dochodziłoby do 200. Ograniczone tu do +40, żeby maksymalne
    // możliwe PŻ Wioski wynosiło 140, niezależnie od tego, jak wysoko
    // bezpieczeństwo sięga gdzie indziej (np. w premii do morale).
    _villageMaxHpBase = 100 + min(widget.security, 40);
    _villageMaxHp = _villageMaxHpBase;
    _villageHp = _villageMaxHp;
    _resetScreenState(_Screen.onslaught);
  }

  void _resetScreenState(_Screen screen) {
    _screen = screen;
    // Minimalne PŻ Leszego podniesione do 90 w obu fazach (było 60/80) -
    // nawet przy maksymalnej sile armii walka ma zostać realnym wyzwaniem.
    // Baza Serca Cienia obniżona ze 130 przez 120 do tej samej bazy co
    // Nawałnica (100) - realnie mniej PŻ niż wcześniej, ale wchodzi w tę
    // fazę z siłą 2 od pierwszego ruchu i własną, mocniejszą pulą ruchów
    // (patrz niżej) - krótsza, ale bardziej natychmiastowo groźna faza,
    // zamiast po prostu dłuższej wersji fazy 1.
    _leszyMaxHp = max(90, (100 - widget.armyStrength * 1.5).round());
    _leszyHp = _leszyMaxHp;
    _shieldPoints = 0;
    _movesUsedInScreen = 0;
    _movesSinceLeszyTurn = 0;
    _bankedWood = 0;
    _bankedStone = 0;
    _bankedWater = 0;
    _corruption = 0;
    _corruptionThreshold = _corruptionThresholdStart;
    _furiaPending = false;
    _prayerActive = false;
    _poisonTicksRemaining = 0;
    _shadowExploding = false;
    _doubleHarvestCharges = 0;
    _leszyEvasionCharges = 0;
    _lastLeszyAction = '';
    _phase = _Phase.intro;
    _gridKey = GlobalKey<HarvestGridState>();
    _leszyDefeatHandled = false;
    // Serce Cienia zaczyna już z siłą 2 (zamiast 0) - "prawdziwa forma"
    // uderza mocniej od pierwszego ruchu, nie musi dopiero się "rozkręcić"
    // jak w Nawałnicy.
    _leszyStrength = screen == _Screen.heartOfShadow ? 2 : 0;
    _nextMove = _rollNextMove();
  }

  /// Losuje kolejny ruch Leszego - "Zagęszczenie cienia" wypada z puli, gdy
  /// próg wybuchu jest już na minimum (_corruptionThresholdMin), bo dalsze
  /// jego obniżanie nic by już nie zmieniło.
  _LeszyMove _rollNextMove() {
    var pool = _screen == _Screen.heartOfShadow ? _heartOfShadowMoves : _onslaughtMoves;
    if (_corruptionThreshold <= _corruptionThresholdMin) {
      pool = pool.where((m) => m != _LeszyMove.shadow).toList();
    }
    return pool[_random.nextInt(pool.length)];
  }

  String _moveDescription(AppLocalizations l10n, _LeszyMove move) {
    switch (move) {
      case _LeszyMove.strike:
        final base = 10 + _leszyStrength;
        if (_furiaPending) {
          return l10n.leszyMoveStrikeFuryDesc(base, base * 2);
        }
        return l10n.leszyMoveStrikeDesc(base);
      case _LeszyMove.drain:
        return l10n.leszyMoveDrainDesc;
      case _LeszyMove.shadow:
        return l10n.leszyMoveShadowDesc(_corruptionThreshold);
      case _LeszyMove.fury:
        return l10n.leszyMoveFuryDesc;
      case _LeszyMove.fog:
        return l10n.leszyMoveFogDesc;
      case _LeszyMove.poison:
        return l10n.leszyMovePoisonDesc;
      case _LeszyMove.hunger:
        return l10n.leszyMoveHungerDesc;
      case _LeszyMove.consume:
        return l10n.leszyMoveConsumeDesc;
      case _LeszyMove.rend:
        final base = 12 + _leszyStrength;
        return l10n.leszyMoveRendDesc(base);
      case _LeszyMove.despair:
        return l10n.leszyMoveDespairDesc;
      case _LeszyMove.blight:
        return l10n.leszyMoveBlightDesc;
      case _LeszyMove.otherworld:
        return l10n.leszyMoveOtherworldDesc;
      case _LeszyMove.crumblingResolve:
        return l10n.leszyMoveCrumblingResolveDesc;
    }
  }

  Season get _season => seasonForWeek(widget.week);

  /// Kulki Cienia leżące na planszy w tej chwili (niezebrane) - licznik
  /// wybuchu ma je uwzględniać, nie tylko punkty z ruchów Leszego, żeby
  /// zostawianie Cienia bez zbierania też realnie zbliżało wybuch.
  int get _boardShadowCount => _gridKey.currentState?.countType(ResourceType.shadow) ?? 0;

  int get _totalCorruption => _corruption + _boardShadowCount;

  void _retry() {
    setState(() {
      // Pełny reset PŻ Wioski - jeśli poprzednia próba dotarła do Serca
      // Cienia i "Zachwianie Woli" zdążyło obniżyć maksimum, to obniżenie
      // NIE ma przechodzić na nową próbę (patrz _villageMaxHpBase).
      _villageMaxHp = _villageMaxHpBase;
      _villageHp = _villageMaxHp;
      _resetScreenState(_Screen.onslaught);
    });
  }

  void _dealDamageToVillage(int amount) {
    final absorbed = min(_shieldPoints, amount);
    _shieldPoints -= absorbed;
    _villageHp = (_villageHp - (amount - absorbed)).clamp(0, _villageMaxHp);
  }

  void _afterVillageDamage() {
    if (_villageHp <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _phase = _Phase.gameOver);
      });
    }
  }

  void _afterLeszyDamage() {
    if (_leszyHp <= 0 && !_leszyDefeatHandled) {
      _leszyDefeatHandled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_screen == _Screen.onslaught) {
          setState(() => _resetScreenState(_Screen.heartOfShadow));
        } else {
          setState(() => _phase = _Phase.victory);
        }
      });
    }
  }

  /// Przejście z ekranu wstępnego do walki. Świeżo rozdana plansza (z
  /// losowymi kulkami Cienia od startu, patrz _boardTypes) mocuje się
  /// DOPIERO w kolejnej klatce (HarvestGrid buduje się poniżej
  /// _resourceCounters w drzewie widgetów) - bez tego dodatkowego
  /// odświeżenia licznik "Cień X/15" pokazywał 0 aż do pierwszego ruchu,
  /// mimo że na planszy mogły już leżeć kulki Cienia.
  void _startFighting() {
    setState(() => _phase = _Phase.fighting);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  void _useMove() {
    setState(() {
      _movesUsedInScreen++;
      if (_poisonTicksRemaining > 0) {
        _poisonTicksRemaining--;
        _dealDamageToVillage(5);
      }
      _movesSinceLeszyTurn++;
    });
    _afterVillageDamage();
    // Sprawdzane po KAŻDYM ruchu gracza, nie tylko po turze Leszego -
    // zostawienie kulek Cienia na planszy bez zbierania samo w sobie zbliża
    // wybuch (patrz _totalCorruption), więc próg może zostać przekroczony
    // w dowolnym momencie, nie tylko co 5 ruchów.
    _checkShadowExplosion();
    if (_phase != _Phase.fighting) return;
    if (_movesSinceLeszyTurn >= _leszyTurnInterval) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _leszyTurn();
      });
    }
  }

  /// Licznik Cienia (punkty z ruchów Leszego + kulki Cienia wciąż leżące na
  /// planszy, patrz _totalCorruption) sprawdzany po KAŻDYM ruchu - gracza
  /// (_useMove) i Leszego (_leszyTurn). Przy progu: wszystkie kulki Cienia
  /// znikają z planszy (prawdziwy "wybuch", nie tylko zerowanie licznika),
  /// Wioska traci PŻ dokładnie tyle, ile licznik wynosił w tej chwili (może
  /// przekroczyć 15, jeśli na planszy leżało więcej kulek niż sam
  /// _corruption sugerował), licznik wraca do 0.
  void _checkShadowExplosion() {
    if (_phase != _Phase.fighting || _shadowExploding || _totalCorruption < _corruptionThreshold) return;
    // Krótkie opóźnienie zamiast natychmiastowego wybuchu - bez niego kulki
    // Cienia potrafiły zniknąć z planszy w tej samej klatce, w której gracz
    // dopiero co dobił do progu (np. 14/15 -> nowa kulka spada -> od razu
    // puste pola), więc wybuch wyglądał jak przypadkowe zniknięcie, nie
    // skutek przekroczenia progu. Licznik/pasek Cienia celowo NIE zeruje się
    // od razu - zostaje widoczny na pełnej wartości przez czas opóźnienia,
    // żeby gracz zdążył zobaczyć, że to właśnie on wywołał wybuch.
    final explosionDamage = _totalCorruption;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _shadowExploding = true;
      _lastLeszyAction = l10n.leszyShadowExplosionWarning;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted || _phase != _Phase.fighting) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _corruption = 0;
        _shadowExploding = false;
        _dealDamageToVillage(explosionDamage);
        _lastLeszyAction = l10n.leszyShadowExplosionResult(explosionDamage);
      });
      _gridKey.currentState?.explodeType(ResourceType.shadow);
      _afterVillageDamage();
    });
  }

  void _leszyTurn() {
    final move = _nextMove;
    var consumedShadow = 0;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _movesSinceLeszyTurn = 0;
      _nextMove = _rollNextMove();
      switch (move) {
        case _LeszyMove.strike:
          var dmg = 10 + _leszyStrength;
          if (_furiaPending) {
            dmg *= 2;
            _furiaPending = false;
          }
          if (_prayerActive) {
            dmg = (dmg / 2).round();
            _prayerActive = false;
          }
          _dealDamageToVillage(dmg);
          _lastLeszyAction = l10n.leszyActionStrike(dmg);
          // Siła rośnie PO rozstrzygnięciu tego uderzenia (nie przed), więc
          // dopiero KOLEJNE uderzenie jest silniejsze - tylko Uderzenie
          // rozwija siłę, w przeciwieństwie do dawnego automatycznego +1 co
          // każdy ruch (Furia nadal dolicza swój własny punkt, niezależnie).
          _leszyStrength++;
        case _LeszyMove.drain:
          final banked = {
            ResourceType.wood: _bankedWood,
            ResourceType.stone: _bankedStone,
            ResourceType.water: _bankedWater,
          };
          final richest = banked.entries.reduce((a, b) => a.value >= b.value ? a : b);
          if (richest.value > 0) {
            switch (richest.key) {
              case ResourceType.wood:
                _bankedWood = 0;
              case ResourceType.stone:
                _bankedStone = 0;
              case ResourceType.water:
                _bankedWater = 0;
              default:
                break;
            }
            final healed = (richest.value / 2).round();
            _leszyHp = (_leszyHp + healed).clamp(0, _leszyMaxHp);
            _lastLeszyAction = l10n.leszyActionDrainSuccess(richest.key.label.toLowerCase(), healed);
          } else {
            _lastLeszyAction = l10n.leszyActionDrainFail;
          }
        case _LeszyMove.shadow:
          _corruptionThreshold = (_corruptionThreshold - 1).clamp(_corruptionThresholdMin, _corruptionThresholdStart);
          _lastLeszyAction = l10n.leszyActionShadowThicken(_corruptionThreshold);
        case _LeszyMove.fury:
          _furiaPending = true;
          _leszyStrength++;
          _lastLeszyAction = l10n.leszyActionFury;
        case _LeszyMove.fog:
          _lastLeszyAction = l10n.leszyActionFog;
        case _LeszyMove.poison:
          _poisonTicksRemaining = 3;
          _lastLeszyAction = l10n.leszyActionPoison;
        case _LeszyMove.hunger:
          _bankedWood = max(0, _bankedWood - 10);
          _bankedStone = max(0, _bankedStone - 10);
          _bankedWater = max(0, _bankedWater - 10);
          _lastLeszyAction = l10n.leszyActionHunger;
        case _LeszyMove.consume:
          // Wyłącznie Serce Cienia - odwraca logikę Cienia z fazy 1: zamiast
          // czekać na wybuch (kara dla gracza), Leszy sam zjada to, co leży
          // na planszy i leczy się o tyle, ile pochłonął. Zerowanie puli +
          // fizyczne usunięcie kulek (poniżej, po setState) w jednym ruchu.
          consumedShadow = _totalCorruption;
          if (consumedShadow > 0) {
            _corruption = 0;
            _leszyHp = (_leszyHp + consumedShadow).clamp(0, _leszyMaxHp);
            _lastLeszyAction = l10n.leszyActionConsumeSuccess(consumedShadow);
          } else {
            _lastLeszyAction = l10n.leszyActionConsumeFail;
          }
        case _LeszyMove.rend:
          // Wyłącznie Serce Cienia - Tarcza chroni tylko w połowie, więc
          // sama Osłona przestaje wystarczać jako jedyna obrona.
          final base = 12 + _leszyStrength;
          final piercedAbsorb = (_shieldPoints / 2).round();
          final dmg = max(0, base - piercedAbsorb);
          _villageHp = (_villageHp - dmg).clamp(0, _villageMaxHp);
          _lastLeszyAction = _shieldPoints > 0
              ? l10n.leszyActionRendPierce(dmg)
              : l10n.leszyActionRendClaws(dmg);
        case _LeszyMove.despair:
          // Wyłącznie Serce Cienia - dwa razy szybszy przyrost siły niż
          // zwykłe Uderzenie, bez zadawania obrażeń tym razem.
          _leszyStrength += 2;
          _lastLeszyAction = l10n.leszyActionDespair;
        case _LeszyMove.blight:
          // Faktyczne skażenie kafelków dzieje się PO setState (patrz niżej,
          // jak przy mgle) - tu tylko komunikat.
          _lastLeszyAction = l10n.leszyActionBlight;
        case _LeszyMove.otherworld:
          _leszyEvasionCharges = 2;
          _lastLeszyAction = l10n.leszyActionOtherworld;
        case _LeszyMove.crumblingResolve:
          // Trwałe skurczenie limitu, nie jednorazowe obrażenia - jeśli
          // aktualne PŻ Wioski przekraczają nowy, niższy limit, też się do
          // niego przycinają (tak samo jak przy spadku limitu populacji).
          _villageMaxHp = max(30, _villageMaxHp - 10);
          _villageHp = _villageHp.clamp(0, _villageMaxHp);
          _lastLeszyAction = l10n.leszyActionCrumblingResolve(_villageMaxHp);
      }
      // Tarcza chroni przed obrażeniami z TEGO ruchu Leszego (powyżej), ale
      // nie kumuluje się bezterminowo - trzeba ją odbudować przed każdym
      // kolejnym atakiem, inaczej raz zebrana Osłona chroniłaby na zawsze.
      _shieldPoints = 0;
    });
    if (move == _LeszyMove.fog) {
      _gridKey.currentState?.shuffleNow();
      _gridKey.currentState?.corruptRandomTiles(0.2, ResourceType.shadow);
    }
    if (move == _LeszyMove.consume && consumedShadow > 0) {
      _gridKey.currentState?.explodeType(ResourceType.shadow);
    }
    if (move == _LeszyMove.blight) {
      // Bez tasowania (w przeciwieństwie do mgły) i mocniej (30% zamiast
      // 20%) - to bezpośrednie skażenie planszy, nie chaos.
      _gridKey.currentState?.corruptRandomTiles(0.3, ResourceType.shadow);
    }
    _afterVillageDamage();
    // Sprawdzane też tutaj (po ruchu Leszego), nie tylko po ruchach gracza -
    // patrz _checkShadowExplosion. Wołane PO ewentualnej mgle (fog), która
    // sama mogła dolać kulek Cienia na planszę.
    _checkShadowExplosion();
  }

  void _onHarvestBoard(ResourceType type, int count) {
    final bonused = widget.bonusTypes.contains(type) ? count + 1 : count;
    // Obfitość: kolejne 3 zebrane ścieżki (patrz _useObfitosc) liczą się
    // podwójnie - zużywa się jedna "szarża" na ścieżkę, niezależnie od tego,
    // ile kafelków ta ścieżka obejmowała. Cień celowo wyłączony z tej
    // premii - to zagrożenie do neutralizowania, nie zysk do pomnażania, a
    // podwojenie zbierania nie powinno dodatkowo przyspieszać usuwania puli
    // Cienia ani zużywać na to szarż Obfitości.
    final doubling = _doubleHarvestCharges > 0 && type != ResourceType.shadow;
    final effective = doubling ? bonused * 2 : bonused;
    setState(() {
      if (doubling) _doubleHarvestCharges--;
      switch (type) {
        case ResourceType.sword:
          // Zaświat (Serce Cienia): póki trwa, Leszy jest częściowo
          // wycofany do zaświatów - Miecz trafia w niego tylko połowicznie.
          var swordDamage = effective;
          if (_leszyEvasionCharges > 0) {
            _leszyEvasionCharges--;
            swordDamage = (swordDamage / 2).round();
          }
          _leszyHp = (_leszyHp - swordDamage).clamp(0, _leszyMaxHp);
        case ResourceType.shield:
          _shieldPoints = (_shieldPoints + effective).clamp(0, _shieldCap);
        case ResourceType.shadow:
          _corruption = (_corruption - count * 5).clamp(0, _corruptionThresholdStart);
        case ResourceType.wood:
          _bankedWood += effective;
        case ResourceType.stone:
          _bankedStone += effective;
        case ResourceType.water:
          _bankedWater += effective;
        default:
          break;
      }
    });
    _afterLeszyDamage();
  }

  // Zdolności NIE zużywają ruchu (w przeciwieństwie do zbierania na
  // planszy) - to świadoma decyzja, żeby gracz mógł użyć zdolności bez
  // przybliżania kolejnej tury Leszego.
  void _useKontratak() {
    if (_phase != _Phase.fighting || _bankedWater < 25) return;
    setState(() {
      _bankedWater -= 25;
      _leszyHp = (_leszyHp - 10).clamp(0, _leszyMaxHp);
    });
    _afterLeszyDamage();
  }

  void _useOslona() {
    if (_phase != _Phase.fighting || _bankedStone < 25) return;
    setState(() {
      _bankedStone -= 25;
      _shieldPoints = (_shieldPoints + 10).clamp(0, _shieldCap);
    });
  }

  void _useUzdrowienie() {
    if (_phase != _Phase.fighting || _bankedWood < 25) return;
    setState(() {
      _bankedWood -= 25;
      _villageHp = (_villageHp + 10).clamp(0, _villageMaxHp);
      _poisonTicksRemaining = 0;
    });
  }

  void _useOczyszczenie() {
    if (_phase != _Phase.fighting || _bankedWood < 20 || _bankedStone < 20) return;
    setState(() {
      _bankedWood -= 20;
      _bankedStone -= 20;
      _corruption = 0;
    });
    // Zeruje samą pulę (powyżej) ORAZ fizycznie usuwa kulki Cienia leżące na
    // planszy - bez tego druga część licznika (_boardShadowCount) i tak
    // natychmiast odbudowałaby _totalCorruption z tego, co wciąż tam leży.
    _gridKey.currentState?.explodeType(ResourceType.shadow);
  }

  void _useModlitwa() {
    if (_phase != _Phase.fighting || _bankedWater < 20 || _bankedWood < 20) return;
    setState(() {
      _bankedWater -= 20;
      _bankedWood -= 20;
      _prayerActive = true;
    });
  }

  void _useUspokojenie() {
    if (_phase != _Phase.fighting || _bankedWater < 30) return;
    setState(() {
      _bankedWater -= 30;
      _leszyStrength = max(0, _leszyStrength - 3);
    });
  }

  void _useWzmocnienieMuru() {
    if (_phase != _Phase.fighting || _bankedWood < 15 || _bankedStone < 15) return;
    setState(() {
      _bankedWood -= 15;
      _bankedStone -= 15;
      _corruptionThreshold = (_corruptionThreshold + 2).clamp(_corruptionThresholdMin, _corruptionThresholdStart);
    });
  }

  void _useRozproszenieFurii() {
    if (_phase != _Phase.fighting || _bankedWater < 15 || !_furiaPending) return;
    setState(() {
      _bankedWater -= 15;
      _furiaPending = false;
    });
  }

  void _useObfitosc() {
    if (_phase != _Phase.fighting || _bankedWater < 20 || _bankedStone < 20) return;
    setState(() {
      _bankedWater -= 20;
      _bankedStone -= 20;
      _doubleHarvestCharges = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: _phase == _Phase.victory,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.leszyAppBarTitle(widget.week)),
          automaticallyImplyLeading: false,
          actions: [
            if (_phase == _Phase.fighting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: Text(l10n.leszyMovesUsedLabel(_movesUsedInScreen))),
              ),
          ],
        ),
        body: switch (_phase) {
          _Phase.intro => _buildIntro(context),
          _Phase.fighting => _buildFight(context),
          _Phase.gameOver => _buildGameOver(context),
          _Phase.victory => _buildVictory(context),
        },
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOnslaught = _screen == _Screen.onslaught;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOnslaught)
              SizedBox(width: 64, height: 64, child: resourceIconAsset('assets/icons/shadow.png', size: 64))
            else
              // Osobna ilustracja "prawdziwej formy" wyłącznie na przejściu
              // Nawałnica -> Serce Cienia; errorBuilder to tylko zabezpieczenie
              // na wypadek brakującego pliku, spada wtedy na tę samą małą
              // ikonkę cienia co w fazie 1.
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/ui/leszy_serce_cienia.webp',
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      SizedBox(width: 64, height: 64, child: resourceIconAsset('assets/icons/shadow.png', size: 64)),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              isOnslaught ? l10n.leszyPhaseOnslaughtTitle : l10n.leszyPhaseHeartOfShadowTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              isOnslaught ? l10n.leszyOnslaughtIntroText : l10n.leszyHeartOfShadowIntroText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.leszyIntroHpSummary(_villageHp, _villageMaxHp, _leszyHp, _leszyMaxHp),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            _boardLegend(context),
            const SizedBox(height: 20),
            _abilityLegend(context),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _startFighting,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(l10n.leszyStartButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Trzy nowe, "mroczniejsze" typy kafelków na tej planszy (miecz/tarcza/
  /// cień) obok znajomych drewna/kamienia/wody - wyjaśnione zawczasu, zanim
  /// gracz w ogóle dotknie planszy (patrz _boardTypes/_onHarvestBoard).
  Widget _boardLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rows = [
      ('assets/icons/sword.png', l10n.leszyBoardLegendSwordLabel, l10n.leszyBoardLegendSwordDesc),
      ('assets/icons/shield.png', l10n.leszyBoardLegendShieldLabel, l10n.leszyBoardLegendShieldDesc),
      (
        'assets/icons/shadow.png',
        l10n.leszyBoardLegendShadowLabel,
        l10n.leszyBoardLegendShadowDesc(_corruptionThreshold),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.leszyBoardLegendTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        for (final (asset, label, effect) in rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(width: 20, height: 20, child: resourceIconAsset(asset, size: 20)),
                const SizedBox(width: 8),
                Text('$label: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                Expanded(child: Text(effect, style: Theme.of(context).textTheme.bodySmall)),
              ],
            ),
          ),
        Text(
          l10n.leszyBoardLegendResourceNote,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  /// Co robi każda zdolność i ile kosztuje - to samo źródło tekstu, którego
  /// używają tooltipy przycisków na ekranie walki (patrz _abilityButton).
  Widget _abilityLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.leszyAbilitiesTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        for (final ability in _abilitiesList(l10n))
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: '${ability.name} (${ability.cost}): ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ability.effect),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Pasek aktywnych efektów czasowych (Furia/Zatrucie/Modlitwa) - osobno od
  /// PŻ i Tarczy, bo to jedyne trzy stany, które nie mają dziś żadnej stałej
  /// liczby obok siebie (włącz/wyłącz + licznik tur), więc łatwo je przeoczyć
  /// bez własnej ikonki.
  Widget _statusBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chips = <Widget>[
      if (_furiaPending)
        _statusChip(
          context,
          Icons.local_fire_department,
          Colors.deepOrange,
          l10n.leszyStatusFuryName,
          l10n.leszyStatusFuryDesc,
        ),
      if (_poisonTicksRemaining > 0)
        _statusChip(
          context,
          Icons.coronavirus,
          Colors.lightGreen,
          l10n.leszyStatusPoisonName,
          l10n.leszyStatusPoisonDesc(_poisonTicksRemaining),
          label: '$_poisonTicksRemaining',
        ),
      if (_prayerActive)
        _statusChip(
          context,
          Icons.auto_fix_high,
          Colors.lightBlueAccent,
          l10n.leszyStatusPrayerName,
          l10n.leszyStatusPrayerDesc,
        ),
      if (_doubleHarvestCharges > 0)
        _statusChip(
          context,
          Icons.auto_awesome,
          Colors.amber,
          l10n.leszyStatusAbundanceName,
          l10n.leszyStatusAbundanceDesc(_doubleHarvestCharges),
          label: '$_doubleHarvestCharges',
        ),
      if (_leszyEvasionCharges > 0)
        _statusChip(
          context,
          Icons.blur_on,
          Colors.deepPurpleAccent,
          l10n.leszyStatusOtherworldName,
          l10n.leszyStatusOtherworldDesc(_leszyEvasionCharges),
          label: '$_leszyEvasionCharges',
        ),
    ];
    if (chips.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(spacing: 8, runSpacing: 6, children: chips),
    );
  }

  /// Ikonka statusu - dotknięcie pokazuje pełny opis efektu (na telefonie
  /// zwykły Tooltip wymaga długiego przytrzymania, co jest mało odkrywalne),
  /// długie przytrzymanie nadal działa jako dodatkowy skrót na innych
  /// platformach.
  Widget _statusChip(
    BuildContext context,
    IconData icon,
    Color color,
    String name,
    String description, {
    String? label,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: description,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            icon: Icon(icon, color: color, size: 32),
            title: Text(name),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.leszyCloseButton),
              ),
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              if (label != null) ...[
                const SizedBox(width: 4),
                Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFight(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _hpBar(context, l10n.leszyBossName, _leszyHp, _leszyMaxHp, Colors.deepPurple)),
                  const SizedBox(width: 8),
                  Icon(Icons.bolt, size: 16, color: Theme.of(context).colorScheme.error),
                  Text(' $_leszyStrength', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              _statusBar(context),
              const SizedBox(height: 6),
              _nextMoveBanner(context),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _hpBar(context, l10n.leszyVillageLabel, _villageHp, _villageMaxHp, scheme.primary),
                  ),
                  if (_shieldPoints > 0) ...[
                    const SizedBox(width: 8),
                    SizedBox(width: 16, height: 16, child: resourceIconAsset('assets/icons/shield.png', size: 16)),
                    Text(' $_shieldPoints', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
              if (_lastLeszyAction.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _lastLeszyAction,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ],
              const SizedBox(height: 8),
              _resourceCounters(context),
              const SizedBox(height: 8),
              Row(
                children: [
                  _abilitySlot(context, 0, _bankedWater >= 25, _useKontratak),
                  _abilitySlot(context, 1, _bankedStone >= 25, _useOslona),
                  _abilitySlot(context, 2, _bankedWood >= 25, _useUzdrowienie),
                  _abilitySlot(context, 3, _bankedWood >= 20 && _bankedStone >= 20, _useOczyszczenie),
                  _abilitySlot(context, 4, _bankedWater >= 20 && _bankedWood >= 20, _useModlitwa),
                  _abilitySlot(context, 5, _bankedWater >= 30, _useUspokojenie),
                  _abilitySlot(context, 6, _bankedWood >= 15 && _bankedStone >= 15, _useWzmocnienieMuru),
                  _abilitySlot(context, 7, _bankedWater >= 15 && _furiaPending, _useRozproszenieFurii),
                  _abilitySlot(context, 8, _bankedWater >= 20 && _bankedStone >= 20, _useObfitosc),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(10),
            decoration: widget.boardStyle == BoardStyle.classic
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _season.boardGradientColors,
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    image: const DecorationImage(
                      image: AssetImage('assets/boards/leszy_plansza.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  SeasonBackground(season: _season),
                  HarvestGrid(
                    key: _gridKey,
                    // Największy rozmiar osiągalny w normalnej grze (patrz
                    // HarvestScreen._gridRows/_gridCols: baza 6, +1 wiersz za
                    // każdą z 6 zbudowanych Okolic, +1 kolumna za komplet
                    // Okolic, +1 kolumna za odkrycie Kartografia) - w starciu
                    // z bossem zawsze od razu w pełnej skali.
                    rows: 12,
                    cols: 8,
                    availableTypes: _boardTypes,
                    autoMatchMinLength: switch (widget.autoMatchTier) {
                      0 => null,
                      1 => 4,
                      _ => 3,
                    },
                    season: _season,
                    spoiledChance: 0,
                    typeWeightMultipliers: {
                      ResourceType.sword: battleWeightMultiplier(widget.security),
                      ResourceType.shield: battleWeightMultiplier(widget.security),
                    },
                    onHarvest: _onHarvestBoard,
                    onAutoMatch: _onHarvestBoard,
                    onMoveUsed: _useMove,
                    onShuffleUsed: _useMove,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      ),
    );
  }

  Widget _hpBar(BuildContext context, String label, int current, int max, Color color) {
    final l10n = AppLocalizations.of(context)!;
    final ratio = max == 0 ? 0.0 : (current / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(l10n.leszyHpBarLabel(label, current, max), style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  static String _movesLabel(AppLocalizations l10n, int n) {
    if (n == 1) return l10n.leszyMovesUnitOne;
    if (n >= 2 && n <= 4) return l10n.leszyMovesUnitFew;
    return l10n.leszyMovesUnitMany;
  }

  /// Zapowiedź kolejnego ruchu Leszego - licznik ruchów do jego tury i opis
  /// tego, co zamierza zrobić (_nextMove jest wylosowany z wyprzedzeniem,
  /// patrz _rollNextMove/_leszyTurn), żeby gracz mógł się na to przygotować.
  Widget _nextMoveBanner(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final movesUntil = (_leszyTurnInterval - _movesSinceLeszyTurn).clamp(0, _leszyTurnInterval);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.hourglass_bottom, size: 16, color: scheme.error),
          const SizedBox(width: 6),
          Text(
            l10n.leszyMovesUntilLabel(movesUntil, _movesLabel(l10n, movesUntil)),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(_moveDescription(l10n, _nextMove), style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }

  /// Zapasy zebrane na zdolności (drewno/kamień/woda) jako czytelne
  /// ikony+liczby zamiast skrótów tekstowych, plus pasek Cienia zamiast
  /// gołej liczby - widać od razu, jak blisko wybuchu (patrz _leszyTurn).
  /// Pasek Cienia jest widoczny cały czas (nie tylko gdy > 0), a jego
  /// wartość to punkty z ruchów Leszego PLUS kulki Cienia wciąż leżące na
  /// planszy (_totalCorruption) - patrz komentarz przy tym getterze.
  Widget _resourceCounters(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final total = _totalCorruption;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _resourceChip(context, ResourceType.wood.assetPath, _bankedWood, scheme),
        const SizedBox(width: 8),
        _resourceChip(context, ResourceType.stone.assetPath, _bankedStone, scheme),
        const SizedBox(width: 8),
        _resourceChip(context, ResourceType.water.assetPath, _bankedWater, scheme),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 14, height: 14, child: resourceIconAsset('assets/icons/shadow.png', size: 14)),
                  const SizedBox(width: 4),
                  Text(l10n.leszyShadowCounterLabel(total, _corruptionThreshold), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (total / _corruptionThreshold).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _resourceChip(BuildContext context, String assetPath, int value, ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16, height: 16, child: resourceIconAsset(assetPath, size: 16)),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Symbol umiejętności na pasku - dotknięcie otwiera miniokno z pełnym
  /// opisem (_showAbilityDialog), zamiast od razu zużywać zasoby. Dzięki
  /// temu przypadkowe stuknięcie w trakcie szybkiego grania na planszy nie
  /// zużywa surowców niechcący.
  /// Jeden slot w rzędzie 8 umiejętności - kwadratowy, skalujący się do
  /// równej 1/8 szerokości ekranu (patrz _buildFight), żeby wszystkie 8
  /// zawsze mieściło się w jednym rzędzie, niezależnie od rozmiaru telefonu.
  /// Wcześniej to był stały krąg 52x52 w Wrap - na węższych ekranach 8 sztuk
  /// nie mieściło się w jednym rzędzie i przechodziło na dwa, co razem ze
  /// zmienną liczbą linijek tekstu wyżej powodowało "skakanie" wysokości
  /// planszy pod spodem.
  Widget _abilitySlot(BuildContext context, int abilityIndex, bool enabled, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: _abilityButton(context, abilityIndex, enabled, onPressed),
      ),
    );
  }

  Widget _abilityButton(BuildContext context, int abilityIndex, bool enabled, VoidCallback onPressed) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => _showAbilityDialog(context, abilityIndex, enabled, onPressed),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? scheme.secondaryContainer : scheme.surfaceContainerHighest,
            border: Border.all(
              color: enabled ? scheme.secondary : scheme.outlineVariant,
              width: 1.5,
            ),
          ),
          child: Icon(
            _abilityIcons[abilityIndex],
            size: 18,
            color: enabled ? scheme.onSecondaryContainer : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// Miniokno otwierane po dotknięciu symbolu umiejętności - pełny opis
  /// kosztu/efektu i świadomy wybór "Użyj"/"Anuluj" (zamiast od razu
  /// wykonywać akcję pod palcem, jak wcześniej robił zwykły przycisk).
  Future<void> _showAbilityDialog(
    BuildContext context,
    int abilityIndex,
    bool enabled,
    VoidCallback onUse,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final ability = _abilitiesList(l10n)[abilityIndex];
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(_abilityIcons[abilityIndex], size: 32),
        title: Text(ability.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.leszyAbilityCostLabel(ability.cost)),
            const SizedBox(height: 6),
            Text(l10n.leszyAbilityEffectLabel(ability.effect)),
            if (!enabled) ...[
              const SizedBox(height: 12),
              Text(
                l10n.leszyNotEnoughResources,
                style: TextStyle(color: Theme.of(dialogContext).colorScheme.error),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.leszyCancelButton),
          ),
          FilledButton(
            onPressed: enabled
                ? () {
                    Navigator.of(dialogContext).pop();
                    onUse();
                  }
                : null,
            child: Text(l10n.leszyUseButton),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOver(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.leszyDefeatTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              l10n.leszyDefeatMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _retry,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(l10n.leszyRetryButton),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(const LeszyBattleResult(false)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(l10n.leszyReturnPrepareButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVictory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.leszyVictoryTitle, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              l10n.leszyVictoryMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.leszyVictoryHpSummary(_villageHp, _villageMaxHp),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(const LeszyBattleResult(true)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(l10n.leszyReturnToVillageButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
