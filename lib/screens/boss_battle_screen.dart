import 'package:flutter/material.dart';

import '../models/resource_type.dart';
import '../models/season.dart';
import '../services/board_style_storage.dart';
import '../utils/battle_balance.dart';
import '../widgets/harvest_grid.dart';
import '../widgets/resource_icon.dart';
import '../widgets/season_background.dart';

/// Wynik starcia z bossem - ile z 3 etapów gracz ukończył, zanim skończyły
/// się ruchy. 3 = pełne zwycięstwo, 2 = zwycięstwo okupione stratami,
/// 0-1 = porażka.
class BossBattleResult {
  final int stagesCleared;
  const BossBattleResult(this.stagesCleared);
}

class _StageInfo {
  final String title;
  final String introText;
  final List<String> iconAssets;

  const _StageInfo({required this.title, required this.introText, required this.iconAssets});
}

/// Starcie z Grotem (koniec Aktu I, tydzień 26) - zastępuje zwykłą rundę
/// zbiorów. Trzy etapy rozgrywane na tej samej planszy dopasowań, ze
/// wspólną pulą ruchów: 1) zbierz surowce na umocnienia, 2) zdetonuj bomby-
/// pułapki, 3) odeprzyj szturm mieczami. Trudność etapów 2-3 skaluje się w
/// dół wraz z liczbą żołnierzy (i Palisadą w etapie 2) - nagroda za
/// wcześniejsze przygotowanie.
class BossBattleScreen extends StatefulWidget {
  final int week;
  final int soldierCount;
  final bool palisadeBuilt;
  final int security;
  final int autoMatchTier;
  final int minComboForBomb;
  final BoardStyle boardStyle;
  // Premia +1 do zbioru danego surowca z Okolic (Rzeka/Góry/Las - patrz
  // HomeShell._bonusTypes) - działała dotąd tylko w zwykłych zbiorach, nie w
  // starciach z bossami, mimo że te same surowce (drewno/kamień) też się tu
  // zbiera.
  final Set<ResourceType> bonusTypes;

  const BossBattleScreen({
    super.key,
    required this.week,
    required this.soldierCount,
    required this.palisadeBuilt,
    this.security = 0,
    this.autoMatchTier = 0,
    this.minComboForBomb = 6,
    this.boardStyle = BoardStyle.photo,
    this.bonusTypes = const {},
  });

  @override
  State<BossBattleScreen> createState() => _BossBattleScreenState();
}

enum _Phase { intro, fighting, summary }

class _BossBattleScreenState extends State<BossBattleScreen> {
  static const _totalMoves = 30;
  static const _stage1WoodTarget = 30;
  static const _stage1StoneTarget = 20;
  // Dodatkowe "szumowe" typy nie liczą się do żadnego celu - utrudniają
  // wyłącznie trafianie w potrzebne surowce/kombinacje.
  static const _stage1Types = {
    ResourceType.wood,
    ResourceType.stone,
    ResourceType.water,
    ResourceType.grain,
  };
  static const _stage2Types = {
    ResourceType.wood,
    ResourceType.stone,
    ResourceType.water,
    ResourceType.grass,
    ResourceType.apple,
  };
  static const _stage3Types = {
    ResourceType.sword,
    ResourceType.wood,
    ResourceType.stone,
    ResourceType.water,
  };

  late final int _stage2BombTarget;
  late final int _stage3SwordTarget;
  late final List<_StageInfo> _stages;

  int _stageIndex = 0;
  _Phase _phase = _Phase.intro;
  int _movesLeft = _totalMoves;
  int _stagesCleared = 0;

  int _stage1Wood = 0;
  int _stage1Stone = 0;
  int _stage2Bombs = 0;
  int _stage3Swords = 0;

  @override
  void initState() {
    super.initState();
    _stage2BombTarget =
        (6 - widget.soldierCount - (widget.palisadeBuilt ? 1 : 0)).clamp(2, 6);
    _stage3SwordTarget = (20 - widget.soldierCount * 3).clamp(5, 20);
    _stages = [
      const _StageInfo(
        title: 'Etap 1: Umocnienia',
        introText: 'Wróg nadciąga. Zbuduj zasieki i wykop doły, zanim dotrze do wioski.',
        iconAssets: ['assets/icons/wood.png', 'assets/icons/stone.png'],
      ),
      _StageInfo(
        title: 'Etap 2: Pułapki',
        introText: 'Grot i jego ludzie już przy bramie - połącz dłuższe ścieżki, żeby '
            'stworzyć bomby, i zdetonuj ${_stage2BombTarget == 1 ? 'jedną z nich' : '$_stage2BombTarget z nich'}.',
        iconAssets: const ['assets/icons/bomb.png'],
      ),
      _StageInfo(
        title: 'Etap 3: Starcie',
        introText: 'Ostatnia szarża - wśród zamieszania walki wyławiaj miecze ($_stage3SwordTarget), '
            'drewno i kamień tylko zawadzają pod ręką.',
        iconAssets: const ['assets/icons/sword.png', 'assets/icons/wood.png', 'assets/icons/stone.png'],
      ),
    ];
  }

  Season get _season => seasonForWeek(widget.week);

  void _useMove() {
    setState(() => _movesLeft--);
    if (_movesLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _phase = _Phase.summary);
      });
    }
  }

  void _clearStage() {
    setState(() {
      _stagesCleared++;
      if (_stageIndex >= _stages.length - 1) {
        _phase = _Phase.summary;
      } else {
        _stageIndex++;
        _phase = _Phase.intro;
      }
    });
  }

  void _onHarvestStage1(ResourceType type, int count) {
    // Zabezpieczenie przed podwójnym rozstrzygnięciem etapu: gdy bomba
    // wybucha na tym samym ruchu, który już osiągnął cel etapu, zniszczone
    // przez nią sąsiednie kafelki wywołują ten handler ponownie - bez tego
    // guardu cel potrafił się zaliczyć dwukrotnie z rzędu. Sprawdzamy fazę,
    // nie tylko numer etapu, bo na OSTATNIM etapie _clearStage() nie zmienia
    // _stageIndex (nie ma dokąd awansować) - sam numer etapu by tu nie
    // wystarczył i _stagesCleared mógłby "przelecieć" ponad 3 (patrz niżej).
    if (_stageIndex != 0 || _phase != _Phase.fighting) return;
    final bonused = widget.bonusTypes.contains(type) ? count + 1 : count;
    setState(() {
      if (type == ResourceType.wood) {
        _stage1Wood = (_stage1Wood + bonused).clamp(0, _stage1WoodTarget);
      } else if (type == ResourceType.stone) {
        _stage1Stone = (_stage1Stone + bonused).clamp(0, _stage1StoneTarget);
      }
    });
    if (_stage1Wood >= _stage1WoodTarget && _stage1Stone >= _stage1StoneTarget) {
      _clearStage();
    }
  }

  void _onHarvestStage2(ResourceType type, int count) {}

  void _onBombDetonatedStage2() {
    if (_stageIndex != 1 || _phase != _Phase.fighting) return;
    setState(() => _stage2Bombs++);
    if (_stage2Bombs >= _stage2BombTarget) {
      _clearStage();
    }
  }

  void _onHarvestStage3(ResourceType type, int count) {
    if (_stageIndex != 2 || _phase != _Phase.fighting) return;
    if (type != ResourceType.sword) return;
    setState(() => _stage3Swords += count);
    if (_stage3Swords >= _stage3SwordTarget) {
      _clearStage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _phase == _Phase.summary,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Starcie z Grotem - Tydzień ${widget.week}'),
          automaticallyImplyLeading: false,
          actions: [
            if (_phase == _Phase.fighting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: Text('Ruchy: $_movesLeft')),
              ),
          ],
        ),
        body: switch (_phase) {
          _Phase.intro => _buildIntro(context),
          _Phase.fighting => _buildFight(context),
          _Phase.summary => _buildSummary(context),
        },
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final stage = _stages[_stageIndex];
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final asset in stage.iconAssets) ...[
                  SizedBox(width: 56, height: 56, child: resourceIconAsset(asset, size: 56)),
                  const SizedBox(width: 12),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Text(stage.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              stage.introText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => setState(() => _phase = _Phase.fighting),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Rozpocznij'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFight(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_stages[_stageIndex].title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _buildProgress(context),
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
                      image: AssetImage('assets/boards/grot_plansza.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  SeasonBackground(season: _season),
                  HarvestGrid(
                    key: ValueKey(_stageIndex),
                    rows: 6,
                    cols: 6,
                    availableTypes: switch (_stageIndex) {
                      0 => _stage1Types,
                      1 => _stage2Types,
                      _ => _stage3Types,
                    },
                    autoMatchMinLength: switch (widget.autoMatchTier) {
                      0 => null,
                      1 => 4,
                      _ => 3,
                    },
                    season: _season,
                    spoiledChance: 0,
                    minComboForBomb: widget.minComboForBomb,
                    typeWeightMultipliers: _stageIndex == 2
                        ? {ResourceType.sword: battleWeightMultiplier(widget.security)}
                        : null,
                    onHarvest: switch (_stageIndex) {
                      0 => _onHarvestStage1,
                      1 => _onHarvestStage2,
                      _ => _onHarvestStage3,
                    },
                    onAutoMatch: switch (_stageIndex) {
                      0 => _onHarvestStage1,
                      1 => _onHarvestStage2,
                      _ => _onHarvestStage3,
                    },
                    onMoveUsed: _useMove,
                    onShuffleUsed: _useMove,
                    onBombDetonated: _stageIndex == 1 ? _onBombDetonatedStage2 : null,
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

  Widget _buildProgress(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (current, target, label) = switch (_stageIndex) {
      0 => (_stage1Wood + _stage1Stone, _stage1WoodTarget + _stage1StoneTarget,
          'Drewno $_stage1Wood/$_stage1WoodTarget - Kamień $_stage1Stone/$_stage1StoneTarget'),
      1 => (_stage2Bombs, _stage2BombTarget, 'Zdetonowane bomby: $_stage2Bombs/$_stage2BombTarget'),
      _ => (_stage3Swords, _stage3SwordTarget, 'Miecze: $_stage3Swords/$_stage3SwordTarget'),
    };
    final ratio = target == 0 ? 1.0 : (current / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10,
            backgroundColor: scheme.surfaceContainerHighest,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    final (title, text) = switch (_stagesCleared) {
      3 => ('🎉 Pełne zwycięstwo!', 'Grot pada na kolano, pokonany. Wioska obroniła się bez strat.'),
      2 => ('⚔️ Zwycięstwo okupione stratami', 'Grot się wycofuje, ale starcie kosztowało wioskę część zapasów.'),
      _ => ('💀 Porażka', 'Grot przełamał obronę wioski i splądrował zapasy.'),
    };
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text(
              'Ukończone etapy: $_stagesCleared/3',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(BossBattleResult(_stagesCleared)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text('Wróć do wioski'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
