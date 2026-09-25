import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/resource_type.dart';
import '../models/season.dart';
import '../models/tutorial_step.dart';
import '../services/board_style_storage.dart';
import '../services/game_progress_storage.dart';
import '../services/resource_storage.dart';
import '../services/stats_storage.dart';
import '../widgets/buildable_overview_sheet.dart';
import '../widgets/harvest_grid.dart';
import '../widgets/resource_icon.dart';
import '../widgets/season_background.dart';
import '../widgets/tutorial_overlay.dart';

class HarvestScreen extends StatefulWidget {
  final int week;
  final bool ratuszBuilt;
  final Set<ResourceType> unlockedTypes;
  final Set<ResourceType> bonusTypes;
  final ResourceType? weeklyBoostType;
  final int builtAreaCount;
  final int movesPerRound;
  // 0 = wyłączone, 1 = automatyczne czwórki (i więcej), 2 = po ulepszeniu -
  // automatyczne trójki (i więcej).
  final int autoMatchTier;
  final int storageCap;
  final double spoiledChance;
  // Odkrycie "Kartografia" z Uczelni - dodatkowa kolumna niezależnie od
  // ukończenia wszystkich Okolic wioski.
  final bool extraColumnFromDiscovery;
  final int minComboForJoker;
  final int minComboForBomb;
  final BoardStyle boardStyle;
  // Migawka z HomeShell (w trakcie zbiorów nie da się nic zbudować, więc nie
  // trzeba tego przeliczać na bieżąco) - do okna "co można teraz zbudować"
  // dostępnego z tego ekranu (patrz _BuildOverviewButton w AppBar).
  final List<BuildableOverviewEntry> areaEntries;
  final List<BuildableOverviewEntry> buildingEntries;

  const HarvestScreen({
    super.key,
    required this.week,
    this.boardStyle = BoardStyle.photo,
    this.ratuszBuilt = false,
    this.unlockedTypes = const {...kStarterResourceTypes, ResourceType.coin},
    this.bonusTypes = const {},
    this.weeklyBoostType,
    this.builtAreaCount = 0,
    this.movesPerRound = 10,
    this.autoMatchTier = 0,
    this.storageCap = 500,
    this.spoiledChance = kSpoiledChance,
    this.extraColumnFromDiscovery = false,
    this.minComboForJoker = 5,
    this.minComboForBomb = 6,
    this.areaEntries = const [],
    this.buildingEntries = const [],
  });

  @override
  State<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends State<HarvestScreen> {
  static const int _baseRows = 6;
  static const int _baseCols = 6;
  static const int _totalAreaCount = 6;

  final _gridKey = GlobalKey<HarvestGridState>();
  final _boardKey = GlobalKey();
  final _movesLabelKey = GlobalKey();
  final _buildOverviewButtonKey = GlobalKey();

  bool _tourActive = false;
  int _tourStepIndex = 0;
  List<TutorialStep> _tourSteps = [];

  late int _movesLeft;
  bool _loaded = false;

  final Map<ResourceType, int> _collected = {
    for (final type in ResourceType.values) type: 0,
  };

  // Ile faktycznie zebrano w TYM tygodniu - w odróżnieniu od _collected,
  // które od razu zawiera też zapasy wioski sprzed rozpoczęcia zbiorów -
  // pokazywane w podsumowaniu na koniec rundy.
  final Map<ResourceType, int> _roundCollected = {
    for (final type in ResourceType.values) type: 0,
  };

  @override
  void initState() {
    super.initState();
    _movesLeft = widget.movesPerRound;
    _loadStockpile();
    _maybeShowTutorial();
  }

  /// Samouczek planszy zbiorów - pokazuje się tylko raz (patrz
  /// GameProgressStorage.markHarvestTutorialSeen), przy pierwszym wejściu na
  /// tę planszę, żeby wyjaśnić mechanikę kontekstowo (z podświetleniem na
  /// żywo, patrz TutorialOverlay), zanim gracz dotknie kafelków.
  Future<void> _maybeShowTutorial() async {
    final progress = await GameProgressStorage.load();
    if (!mounted || progress.harvestTutorialSeen) return;
    await GameProgressStorage.markHarvestTutorialSeen();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _startTour();
    });
  }

  void _startTour() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _tourSteps = [
        TutorialStep(
          targetKey: _boardKey,
          title: l10n.harvestScreenTutorialStep1Title,
          description: l10n.harvestScreenTutorialStep1Description,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
        ),
        TutorialStep(
          targetKey: _boardKey,
          title: l10n.harvestScreenTutorialStep2Title,
          description: l10n.harvestScreenTutorialStep2Description,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
        ),
        TutorialStep(
          targetKey: _boardKey,
          title: l10n.harvestScreenTutorialStep3Title,
          description: l10n.harvestScreenTutorialStep3Description,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.zero,
        ),
        TutorialStep(
          targetKey: _movesLabelKey,
          title: l10n.harvestScreenTutorialStep4Title,
          description: l10n.harvestScreenTutorialStep4Description,
        ),
        TutorialStep(
          targetKey: _buildOverviewButtonKey,
          title: l10n.buildOverviewTooltip,
          description: l10n.harvestScreenTutorialBuildOverviewDescription,
        ),
      ];
      _tourStepIndex = 0;
      _tourActive = true;
    });
  }

  void _tourGoTo(int index) {
    if (index < 0) return;
    if (index >= _tourSteps.length) {
      setState(() => _tourActive = false);
      return;
    }
    setState(() => _tourStepIndex = index);
  }

  List<ResourceType> get _visibleTypes =>
      ResourceType.values.where(widget.unlockedTypes.contains).toList();

  // Każda zbudowana okolica wioski dodaje 1 rząd; skompletowanie wszystkich
  // 6 dodaje dodatkowo 1 kolumnę jako premię za pełne wykorzystanie terenu.
  int get _gridRows => _baseRows + widget.builtAreaCount;
  int get _gridCols =>
      _baseCols +
      (widget.builtAreaCount >= _totalAreaCount ? 1 : 0) +
      (widget.extraColumnFromDiscovery ? 1 : 0);

  int? get _autoMatchMinLength => switch (widget.autoMatchTier) {
        0 => null,
        1 => 4,
        _ => 3,
      };

  Season get _season => seasonForWeek(widget.week);

  Future<void> _loadStockpile() async {
    final stored = await ResourceStorage.load();
    if (!mounted) return;
    setState(() {
      _collected.addAll(stored);
      _loaded = true;
    });
  }

  void _onHarvest(ResourceType type, int count) {
    // Ratusz: złoto zebrane w ścieżce daje dodatkowo +1 (np. 4 w ścieżce = 5).
    // Budynek w okolicach wioski (rzeka/góry/las) daje tę samą premię +1 do
    // surowca, który był już dostępny na planszy przed jego zbudowaniem.
    var bonused = count;
    if (widget.ratuszBuilt && type == ResourceType.coin) bonused += 1;
    if (widget.bonusTypes.contains(type)) bonused += 1;
    setState(() {
      _collected[type] = ((_collected[type] ?? 0) + bonused).clamp(0, widget.storageCap);
      _roundCollected[type] = (_roundCollected[type] ?? 0) + bonused;
    });
    ResourceStorage.save(_collected);
    StatsStorage.recordHarvest(bonused);
  }

  void _useMove() {
    setState(() => _movesLeft--);
    if (_movesLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showRoundResult());
    }
  }

  void _showRoundResult() {
    final l10n = AppLocalizations.of(context)!;
    final collectedTypes = [
      for (final type in ResourceType.values)
        if ((_roundCollected[type] ?? 0) > 0) type,
    ];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.harvestScreenRoundEndTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.harvestScreenRoundEndCollectedLabel),
            const SizedBox(height: 4),
            if (collectedTypes.isEmpty)
              Text(l10n.harvestScreenRoundEndNothingCollected)
            else
              for (final type in collectedTypes)
                Text('${type.label}: +${_roundCollected[type]}'),
          ],
        ),
        actions: [
          // Cofa zebrane w tym tygodniu surowce (HomeShell przywraca
          // checkpoint sprzed tej rundy) i rozdaje nową planszę od zera -
          // przydatne, gdy trafiła się wyjątkowo pechowa plansza.
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
            child: Text(l10n.harvestScreenRoundEndReplayButton),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
            child: Text(l10n.harvestScreenRoundEndReturnButton),
          ),
        ],
      ),
    );
  }

  void _showBuildableOverview() {
    showBuildableOverviewSheet(
      context,
      areaEntries: widget.areaEntries,
      buildingEntries: widget.buildingEntries,
      stockpile: _collected,
    );
  }

  void _confirmManualShuffle() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.harvestScreenShuffleConfirmTitle),
        content: Text(l10n.harvestScreenShuffleConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.harvestScreenShuffleCancelButton),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _gridKey.currentState?.shuffleNow();
              _useMove();
            },
            child: Text(l10n.harvestScreenShuffleConfirmButton),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmGiveUpWeek() async {
    final l10n = AppLocalizations.of(context)!;
    final giveUp = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.harvestScreenGiveUpTitle),
        content: Text(l10n.harvestScreenGiveUpContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.harvestScreenGiveUpStayButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.harvestScreenGiveUpConfirmButton),
          ),
        ],
      ),
    );
    if (giveUp == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmGiveUpWeek();
      },
      child: Stack(
        children: [
      Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.harvestScreenAppBarTitle(widget.week)),
              Text(
                '${_season.emoji} ${_season.label} — ${_season.description}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            IconButton(
              key: _buildOverviewButtonKey,
              onPressed: _showBuildableOverview,
              icon: const Icon(Icons.construction),
              tooltip: l10n.buildOverviewTooltip,
            ),
            IconButton(
              onPressed: _movesLeft > 0 ? _confirmManualShuffle : null,
              icon: const Icon(Icons.shuffle),
              tooltip: l10n.harvestScreenShuffleTooltip,
            ),
            Padding(
              key: _movesLabelKey,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text(l10n.harvestScreenMovesLabel(_movesLeft))),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: SizedBox(
                height: 30,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _visibleTypes.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final type = _visibleTypes[index];
                    return Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      avatar: SizedBox(
                        width: 14,
                        height: 14,
                        child: resourceIconAsset(type.assetPath, size: 14),
                      ),
                      label: Text(
                        '${_collected[type]}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                key: _boardKey,
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
                        image: DecorationImage(
                          image: AssetImage(boardImagePathForWeek(widget.week)),
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
                        rows: _gridRows,
                        cols: _gridCols,
                        availableTypes: widget.unlockedTypes,
                        boostedType: widget.weeklyBoostType,
                        autoMatchMinLength: _autoMatchMinLength,
                        season: _season,
                        spoiledChance: widget.spoiledChance,
                        onHarvest: _onHarvest,
                        onAutoMatch: _onHarvest,
                        onMoveUsed: _useMove,
                        onPathCompleted: StatsStorage.recordPathLength,
                        onShuffleUsed: _useMove,
                        minComboForJoker: widget.minComboForJoker,
                        minComboForBomb: widget.minComboForBomb,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
      if (_tourActive)
        TutorialOverlay(
          steps: _tourSteps,
          stepIndex: _tourStepIndex,
          onNext: () => _tourGoTo(_tourStepIndex + 1),
          onBack: _tourStepIndex > 0 ? () => _tourGoTo(_tourStepIndex - 1) : null,
          onSkip: () => setState(() => _tourActive = false),
        ),
        ],
      ),
    );
  }
}
