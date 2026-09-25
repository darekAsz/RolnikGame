import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/resource_type.dart';
import '../models/season.dart';
import '../services/board_style_storage.dart';
import '../utils/battle_balance.dart';
import '../widgets/harvest_grid.dart';
import '../widgets/resource_icon.dart';
import '../widgets/season_background.dart';

/// Wynik starcia z Martą - ile z 3 etapów gracz ukończył, oraz czy etap 3
/// (Prawda) został ukończony z zapasem ruchów (podnosi ostateczny ton
/// zwycięstwa, patrz HomeShell._resolveMartaBattleResult).
class MartaBattleResult {
  final int stagesCleared;
  final bool fullTrustBonus;
  const MartaBattleResult(this.stagesCleared, {this.fullTrustBonus = false});
}

class _StageInfo {
  final String title;
  final String introText;
  final List<String> iconAssets;

  const _StageInfo({required this.title, required this.introText, required this.iconAssets});
}

/// Starcie z Martą (koniec Aktu II, tydzień 39) - zastępuje zwykłą rundę
/// zbiorów. Inaczej niż starcie z Grotem: etap 1 to przedział (nie tylko
/// próg minimalny - przesada też ma koszt), etap 2 opiera się o jokery
/// ("chwile wahania") zamiast bomb, a etap 3 nagradza cierpliwość zapasem
/// ruchów. Trudność skaluje się poziomem Kaplicy i morale wioski - inna oś
/// przygotowania niż wojsko/Palisada u Grota.
class MartaBattleScreen extends StatefulWidget {
  final int week;
  final int kaplicaLevel;
  final double morale;
  final int autoMatchTier;
  final int minComboForJoker;
  final BoardStyle boardStyle;
  final Set<ResourceType> bonusTypes;

  const MartaBattleScreen({
    super.key,
    required this.week,
    required this.kaplicaLevel,
    required this.morale,
    this.autoMatchTier = 0,
    this.minComboForJoker = 5,
    this.boardStyle = BoardStyle.photo,
    this.bonusTypes = const {},
  });

  @override
  State<MartaBattleScreen> createState() => _MartaBattleScreenState();
}

enum _Phase { intro, fighting, summary }

class _MartaBattleScreenState extends State<MartaBattleScreen> {
  static const _stageCount = 3;
  static const _totalMoves = 40;
  // Gwarantowane minimum ruchów na wejściu w każdy etap - patrz analogiczna
  // stała w boss_battle_screen.dart (Grot).
  static const _minMovesPerStage = 20;
  // Woda i zboże w etapie 1 nie liczą się do niczego - to tylko "szum"
  // utrudniający trafianie w drewno/kamień (patrz _onHarvestStage1). Liczba
  // typów (4 w etapie 1, 5 w etapie 2) dobrana tak, żeby dorównać gęstości
  // planszy u Grota (BossBattleScreen._stage1Types/_stage2Types).
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
  // Prawda wciąż jedynym surowcem, który się liczy (patrz _onHarvestStage3),
  // ale reszta miesza planszę tak jak w etapach 1-2 - bez tego cała plansza
  // była jednym kolorem i każde przeciągnięcie trafiało.
  static const _stage3Types = {
    ResourceType.truth,
    ResourceType.wood,
    ResourceType.stone,
    ResourceType.water,
  };

  late int _minWood;
  late final int _maxWood;
  late int _minStone;
  late final int _maxStone;
  late int _stage2Target;
  late final int _stage3Target;

  int _stageIndex = 0;
  _Phase _phase = _Phase.intro;
  int _movesLeft = _totalMoves;
  int _stagesCleared = 0;
  bool _fullTrustBonus = false;

  int _stage1Wood = 0;
  int _stage1Stone = 0;
  // Ustawiane po przekroczeniu limitu w etapie 1 - _buildIntro pokazuje wtedy
  // inny tekst, a cel na kolejne podejście jest o 1 wyższy (patrz
  // _onHarvestStage1/_restartStage1).
  bool _stage1Overshot = false;
  int _stage2JokersUsed = 0;
  int _stage3Truth = 0;

  @override
  void initState() {
    super.initState();
    final kaplica = widget.kaplicaLevel;
    _minWood = max(8, 15 - kaplica * 4);
    _maxWood = 25 + kaplica * 5;
    _minStone = max(6, 10 - kaplica * 3);
    _maxStone = 18 + kaplica * 4;
    // Podniesione wg poprawki: minimalny impas (nawet z Kaplicą L2 i wysokim
    // morale) to teraz 5, maksymalny 8 - poprzednio potrafił spaść aż do 1,
    // co robiło z Etapu 2 formalność.
    final stage2Base = 8 - kaplica - (widget.morale >= 60 ? 1 : 0);
    _stage2Target = stage2Base.clamp(5, 8);
    _stage3Target = (20 - (widget.morale / 5).floor()).clamp(5, 20);
  }

  List<_StageInfo> _buildStages(AppLocalizations l10n) => [
        _StageInfo(
          title: l10n.martaStage1Title,
          introText: l10n.martaStage1IntroDefault(_minWood, _minStone),
          iconAssets: const ['assets/icons/wood.png', 'assets/icons/stone.png'],
        ),
        _StageInfo(
          title: l10n.martaStage2Title,
          introText: _stage2Target == 1
              ? l10n.martaStage2IntroOne
              : l10n.martaStage2IntroMany(_stage2Target),
          iconAssets: const ['assets/icons/joker.png'],
        ),
        _StageInfo(
          title: l10n.martaStage3Title,
          introText: l10n.martaStage3Intro,
          iconAssets: const ['assets/icons/truth.png'],
        ),
      ];

  Season get _season => seasonForWeek(widget.week);

  void _useMove() {
    setState(() => _movesLeft--);
    if (_movesLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _phase = _Phase.summary);
      });
    }
  }

  void _advanceStage() {
    setState(() {
      _stagesCleared++;
      if (_stageIndex >= _stageCount - 1) {
        _phase = _Phase.summary;
      } else {
        _stageIndex++;
        _phase = _Phase.intro;
        if (_movesLeft < _minMovesPerStage) {
          _movesLeft = _minMovesPerStage;
        }
      }
    });
  }

  void _onHarvestStage1(ResourceType type, int count) {
    // Zabezpieczenie przed podwójnym rozstrzygnięciem etapu: bomba
    // wybuchająca na tym samym ruchu, który już osiągnął cel etapu, wywołuje
    // ten handler ponownie przez zniszczone sąsiednie kafelki - bez tego
    // guardu etap potrafił się rozstrzygnąć dwukrotnie z rzędu. Sprawdzamy
    // fazę, nie tylko numer etapu, bo na OSTATNIM etapie _advanceStage() nie
    // zmienia _stageIndex (nie ma dokąd awansować) - sam numer etapu by tu
    // nie wystarczył.
    if (_stageIndex != 0 || _phase != _Phase.fighting) return;
    final bonused = widget.bonusTypes.contains(type) ? count + 1 : count;
    setState(() {
      if (type == ResourceType.wood) {
        _stage1Wood += bonused;
      } else if (type == ResourceType.stone) {
        _stage1Stone += bonused;
      }
    });
    // Przesada zdradza się od razu - plotka zaczyna żyć własnym życiem, więc
    // to podejście przepada i trzeba spróbować jeszcze raz od zera. Marta
    // robi się przez to czujniejsza - cel etapu 2 rośnie o 1 (patrz
    // _restartStage1), a nie wymaganie tu, w etapie 1.
    if (_stage1Wood > _maxWood || _stage1Stone > _maxStone) {
      _restartStage1();
      return;
    }
    if (_stage1Wood >= _minWood && _stage1Stone >= _minStone) {
      _advanceStage();
    }
  }

  void _restartStage1() {
    setState(() {
      _stage2Target += 1;
      _stage1Wood = 0;
      _stage1Stone = 0;
      _stage1Overshot = true;
      _phase = _Phase.intro;
    });
  }

  void _onHarvestStage2(ResourceType type, int count) {}

  void _onBombDetonatedStage2() {
    if (_stageIndex != 1 || _phase != _Phase.fighting) return;
    setState(() => _stage2Target += 1);
  }

  void _onJokerUsedStage2() {
    if (_stageIndex != 1 || _phase != _Phase.fighting) return;
    setState(() => _stage2JokersUsed++);
    if (_stage2JokersUsed >= _stage2Target) {
      _advanceStage();
    }
  }

  void _onHarvestStage3(ResourceType type, int count) {
    if (_stageIndex != 2 || _phase != _Phase.fighting) return;
    // Drewno/kamień/woda są tu tylko "szumem" utrudniającym trafianie w
    // Prawdę (patrz _stage3Types) - nie mają się liczyć do celu.
    if (type != ResourceType.truth) return;
    setState(() => _stage3Truth += count);
    if (_stage3Truth >= _stage3Target) {
      _fullTrustBonus = _movesLeft >= 5;
      _advanceStage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: _phase == _Phase.summary,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.martaAppBarTitle(widget.week)),
          automaticallyImplyLeading: false,
          actions: [
            if (_phase == _Phase.fighting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: Text(l10n.martaMovesLabel(_movesLeft))),
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

  String _stage1IntroText(AppLocalizations l10n) {
    if (_stage1Overshot) {
      return l10n.martaStage1IntroOvershot(_minWood, _minStone, _stage2Target);
    }
    return l10n.martaStage1IntroDefault(_minWood, _minStone);
  }

  String _stage2IntroText(AppLocalizations l10n) => _stage2Target == 1
      ? l10n.martaStage2IntroOne
      : l10n.martaStage2IntroMany(_stage2Target);

  Widget _buildIntro(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stage = _buildStages(l10n)[_stageIndex];
    return Center(
      child: SingleChildScrollView(
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
              switch (_stageIndex) {
                0 => _stage1IntroText(l10n),
                1 => _stage2IntroText(l10n),
                _ => stage.introText,
              },
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => setState(() => _phase = _Phase.fighting),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(l10n.martaStartButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFight(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stages = _buildStages(l10n);
    return SafeArea(
      top: false,
      child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stages[_stageIndex].title, style: Theme.of(context).textTheme.titleMedium),
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
                      image: AssetImage('assets/boards/marta_plansza.webp'),
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
                    // Największy rozmiar osiągalny w normalnej grze (patrz
                    // HarvestScreen._gridRows/_gridCols: baza 6, +1 wiersz za
                    // każdą z 6 zbudowanych Okolic, +1 kolumna za komplet
                    // Okolic, +1 kolumna za odkrycie Kartografia) - w starciu
                    // z bossem zawsze od razu w pełnej skali.
                    rows: 12,
                    cols: 8,
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
                    minComboForJoker: widget.minComboForJoker,
                    typeWeightMultipliers: _stageIndex == 2
                        ? {ResourceType.truth: battleWeightMultiplier(widget.morale)}
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
                    onJokerUsed: _stageIndex == 1 ? _onJokerUsedStage2 : null,
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
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final (current, target, label) = switch (_stageIndex) {
      0 => (
          _stage1Wood + _stage1Stone,
          _minWood + _minStone,
          l10n.martaProgressStage1(_stage1Wood, _minWood, _maxWood, _stage1Stone, _minStone, _maxStone),
        ),
      1 => (_stage2JokersUsed, _stage2Target, l10n.martaProgressStage2(_stage2JokersUsed, _stage2Target)),
      _ => (_stage3Truth, _stage3Target, l10n.martaProgressStage3(_stage3Truth, _stage3Target)),
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
    final l10n = AppLocalizations.of(context)!;
    final (title, text) = switch (_stagesCleared) {
      3 => (
          _fullTrustBonus ? l10n.martaSummaryFullTrustTitle : l10n.martaSummaryPartialTrustTitle,
          _fullTrustBonus ? l10n.martaSummaryFullTrustText : l10n.martaSummaryPartialTrustText,
        ),
      2 => (l10n.martaSummaryClashTitle, l10n.martaSummaryClashText),
      _ => (l10n.martaSummaryWithdrawTitle, l10n.martaSummaryWithdrawText),
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
              l10n.martaSummaryStagesCleared(_stagesCleared),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => Navigator.of(context)
                  .pop(MartaBattleResult(_stagesCleared, fullTrustBonus: _fullTrustBonus)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(l10n.martaReturnButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
