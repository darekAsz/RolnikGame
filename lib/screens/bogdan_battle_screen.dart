import 'dart:math';

import 'package:flutter/material.dart';

import '../models/resource_type.dart';
import '../models/season.dart';
import '../services/board_style_storage.dart';
import '../utils/battle_balance.dart';
import '../widgets/harvest_grid.dart';
import '../widgets/resource_icon.dart';
import '../widgets/season_background.dart';

/// Wynik starcia z Bogdanem - czy Dowód (dziennik) został zebrany, ile razy
/// spalił pełną część magazynu (-15%/spalenie) i ile razy Marta zdążyła to
/// złagodzić (-5%/spalenie, najwyżej raz w całej walce).
class BogdanBattleResult {
  final bool proofComplete;
  final int fullBurns;
  final int discountedBurns;

  const BogdanBattleResult({
    required this.proofComplete,
    required this.fullBurns,
    required this.discountedBurns,
  });

  int get totalBurns => fullBurns + discountedBurns;
}

enum _SubPhase { furia, peknicie }

enum _IntroReason { start, furiaRetry, furiaRetryDiscounted, peknicieStart, furiaAfterPeknicie }

/// Starcie z Bogdanem (koniec Aktu III, tydzień 52) - zastępuje zwykłą rundę
/// zbiorów. Inaczej niż Grot (liniowe etapy) i Marta (jeden ciągły balans
/// dwóch liczników): to pętla dwóch naprzemiennych faz - "Furia" (uspokój go,
/// zanim spali część PRAWDZIWEGO magazynu wioski) i "Pęknięcie" (krótkie
/// okno, w którym zbiera się Dowód - dziennik dziadka). Porażka w Furii ma
/// natychmiastowy, trwały koszt, niezależny od końcowego wyniku walki.
/// Jeśli poprzednie starcie z Martą zakończyło się pełnym zaufaniem, ona
/// interweniuje przy pierwszym spaleniu, łagodząc je.
class BogdanBattleScreen extends StatefulWidget {
  final int week;
  final int security;
  final double morale;
  final bool martaFullTrust;
  final int autoMatchTier;
  final BoardStyle boardStyle;
  final Set<ResourceType> bonusTypes;

  const BogdanBattleScreen({
    super.key,
    required this.week,
    required this.security,
    this.morale = 50,
    required this.martaFullTrust,
    this.autoMatchTier = 0,
    this.boardStyle = BoardStyle.photo,
    this.bonusTypes = const {},
  });

  @override
  State<BogdanBattleScreen> createState() => _BogdanBattleScreenState();
}

enum _Phase { intro, fighting, summary }

class _BogdanBattleScreenState extends State<BogdanBattleScreen> {
  static const _totalMoves = 40;
  static const _peknicieLimit = 5;
  static const _dowodTarget = 20;
  static const _furiaTypes = {ResourceType.wood, ResourceType.stone, ResourceType.water};
  static const _peknicieTypes = {
    ResourceType.evidence,
    ResourceType.wood,
    ResourceType.stone,
    ResourceType.water,
    ResourceType.grass,
  };
  // Stała liczba ruchów na próbę Furii - nie maleje z kolejnymi porażkami
  // (wcześniej malała o 1 za każdym razem, aż do minimum).
  static const _furiaLimit = 8;

  late final int _calmTarget;

  int _totalMovesLeft = _totalMoves;
  _SubPhase _subPhase = _SubPhase.furia;
  _Phase _phase = _Phase.intro;
  _IntroReason _introReason = _IntroReason.start;

  int _furiaMovesLeft = _furiaLimit;
  int _calmProgress = 0;

  int _peknicieMovesLeft = _peknicieLimit;
  int _totalDowod = 0;

  int _fullBurns = 0;
  int _discountedBurns = 0;
  bool _martaBonusUsed = false;

  @override
  void initState() {
    super.initState();
    _calmTarget = max(10, 25 - widget.security ~/ 4);
    _furiaMovesLeft = _furiaLimit;
  }

  Season get _season => seasonForWeek(widget.week);

  void _useMove() {
    setState(() {
      _totalMovesLeft--;
      if (_subPhase == _SubPhase.furia) {
        _furiaMovesLeft--;
      } else {
        _peknicieMovesLeft--;
      }
    });
    if (_totalMovesLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _phase = _Phase.summary);
      });
      return;
    }
    if (_subPhase == _SubPhase.furia && _furiaMovesLeft <= 0 && _calmProgress < _calmTarget) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _handleFuriaFailure();
      });
    } else if (_subPhase == _SubPhase.peknicie && _peknicieMovesLeft <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _returnToFuria();
      });
    }
  }

  void _handleFuriaFailure() {
    final discount = widget.martaFullTrust && !_martaBonusUsed;
    setState(() {
      if (discount) {
        _discountedBurns++;
        _martaBonusUsed = true;
      } else {
        _fullBurns++;
      }
      _furiaMovesLeft = _furiaLimit;
      _calmProgress = 0;
      _introReason = discount ? _IntroReason.furiaRetryDiscounted : _IntroReason.furiaRetry;
      _phase = _Phase.intro;
    });
  }

  void _returnToFuria() {
    setState(() {
      _subPhase = _SubPhase.furia;
      _furiaMovesLeft = _furiaLimit;
      _calmProgress = 0;
      _introReason = _IntroReason.furiaAfterPeknicie;
      _phase = _Phase.intro;
    });
  }

  void _onHarvestFuria(ResourceType type, int count) {
    // Guard analogiczny do BossBattleScreen: bomba wybuchająca na ruchu,
    // który już osiągnął cel, wywołuje ten handler ponownie przez zniszczone
    // sąsiednie kafelki - bez guardu podfaza potrafiła się rozstrzygnąć
    // dwukrotnie (np. resetując limit ruchów Pęknięcia).
    if (_subPhase != _SubPhase.furia) return;
    if (type != ResourceType.water) return;
    final bonused = widget.bonusTypes.contains(type) ? count + 1 : count;
    setState(() => _calmProgress += bonused);
    if (_calmProgress >= _calmTarget) {
      setState(() {
        _subPhase = _SubPhase.peknicie;
        _peknicieMovesLeft = _peknicieLimit;
        _introReason = _IntroReason.peknicieStart;
        _phase = _Phase.intro;
      });
    }
  }

  void _onHarvestPeknicie(ResourceType type, int count) {
    if (_subPhase != _SubPhase.peknicie) return;
    if (type != ResourceType.evidence) return;
    setState(() => _totalDowod += count);
    if (_totalDowod >= _dowodTarget) {
      setState(() => _phase = _Phase.summary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _phase == _Phase.summary,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Starcie z Bogdanem - Tydzień ${widget.week}'),
          automaticallyImplyLeading: false,
          actions: [
            if (_phase == _Phase.fighting)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(child: Text('Ruchy: $_totalMovesLeft')),
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

  (String, String, List<String>) _introContent() {
    if (_subPhase == _SubPhase.peknicie) {
      return (
        'Pęknięcie',
        'Bogdan się waha, sięga po dziennik... Masz $_peknicieLimit ruchów, żeby zebrać jak '
            'najwięcej Dowodu, zanim znów się zamknie w gniewie.',
        ['assets/icons/evidence.png'],
      );
    }
    return switch (_introReason) {
      _IntroReason.start => (
          'Furia',
          'Bogdan przyjeżdża osobiście, w gniewie. Uspokój go - zbierz $_calmTarget wody, zanim '
              'skończą się ruchy ($_furiaLimit), bo inaczej podpali część magazynu.',
          ['assets/icons/water.png'],
        ),
      _IntroReason.furiaRetry => (
          'Furia (ponownie)',
          'Bogdan zdążył podpalić część spichlerza! (-15% zboża i jabłek) Spróbuj ponownie - masz '
              '$_furiaLimit ruchów.',
          ['assets/icons/water.png'],
        ),
      _IntroReason.furiaRetryDiscounted => (
          'Furia (ponownie)',
          'Marta wbiegła i powstrzymała ojca! Zdążył podpalić tylko trochę (-5%). Spróbuj ponownie '
              '- masz $_furiaLimit ruchów.',
          ['assets/icons/water.png'],
        ),
      _IntroReason.furiaAfterPeknicie => (
          'Furia',
          'Bogdan znów wpada w gniew. Uspokój go raz jeszcze - $_calmTarget wody, $_furiaLimit '
              'ruchów.',
          ['assets/icons/water.png'],
        ),
      _IntroReason.peknicieStart => ('', '', const []),
    };
  }

  Widget _buildIntro(BuildContext context) {
    final (title, text, icons) = _introContent();
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final asset in icons) ...[
                  SizedBox(width: 56, height: 56, child: resourceIconAsset(asset, size: 56)),
                  const SizedBox(width: 12),
                ],
              ],
            ),
            const SizedBox(height: 24),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            if (_totalDowod > 0) ...[
              const SizedBox(height: 8),
              Text(
                'Zebrany dotąd Dowód: $_totalDowod/$_dowodTarget',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
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
    final isFuria = _subPhase == _SubPhase.furia;
    return SafeArea(
      top: false,
      child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFuria ? 'Furia' : 'Pęknięcie',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildProgress(context, isFuria),
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
                      image: AssetImage('assets/boards/bogdan_plansza.webp'),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  SeasonBackground(season: _season),
                  HarvestGrid(
                    key: ValueKey(isFuria ? 'furia-$_furiaLimit' : 'peknicie'),
                    rows: 6,
                    cols: 6,
                    availableTypes: isFuria ? _furiaTypes : _peknicieTypes,
                    autoMatchMinLength: switch (widget.autoMatchTier) {
                      0 => null,
                      1 => 4,
                      _ => 3,
                    },
                    season: _season,
                    spoiledChance: 0,
                    typeWeightMultipliers: isFuria
                        ? null
                        : {ResourceType.evidence: battleWeightMultiplier(widget.morale)},
                    onHarvest: isFuria ? _onHarvestFuria : _onHarvestPeknicie,
                    onAutoMatch: isFuria ? _onHarvestFuria : _onHarvestPeknicie,
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

  Widget _buildProgress(BuildContext context, bool isFuria) {
    final scheme = Theme.of(context).colorScheme;
    final current = isFuria ? _calmProgress : _totalDowod;
    final target = isFuria ? _calmTarget : _dowodTarget;
    final label = isFuria
        ? 'Opanowanie: $_calmProgress/$_calmTarget (pozostało ${_furiaMovesLeft.clamp(0, _furiaLimit)} '
            'ruchów tej próby)'
        : 'Dowód: $_totalDowod/$_dowodTarget (pozostało ${_peknicieMovesLeft.clamp(0, _peknicieLimit)} '
            'ruchów okna)';
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
    final proofComplete = _totalDowod >= _dowodTarget;
    final totalBurns = _fullBurns + _discountedBurns;
    final (title, text) = proofComplete
        ? (totalBurns == 0
            ? (
                '🎉 Pełne zwycięstwo',
                'Bogdan pęka całkowicie pod ciężarem dowodów. Ucieka w las bez zemsty.',
              )
            : (
                '⚔️ Zwycięstwo okupione stratami',
                'Bogdan w końcu ucieka, ale zdążył zaszkodzić wiosce po drodze.',
              ))
        : (
            '💀 Porażka',
            'Ruchy się skończyły, zanim udało się go przełamać. Bogdan odjeżdża, nadal '
                'przekonany o swojej racji.',
          );
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
              'Dowód: $_totalDowod/$_dowodTarget - Spalenia magazynu: $totalBurns',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                BogdanBattleResult(
                  proofComplete: proofComplete,
                  fullBurns: _fullBurns,
                  discountedBurns: _discountedBurns,
                ),
              ),
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
