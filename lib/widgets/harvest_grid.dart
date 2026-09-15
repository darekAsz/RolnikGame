import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/grid_position.dart';
import '../models/resource_type.dart';
import '../models/season.dart';
import '../services/sound_service.dart';
import 'path_painter.dart';

enum SpecialTile { none, joker, bomb }

class _Cell {
  final int id;
  final ResourceType type;
  final SpecialTile special;
  // Spalone (lato) albo zamarznięte (zima) - nadal łączy się normalnie
  // w ścieżkę, ale nie daje żadnego surowca po zebraniu.
  final bool spoiled;

  const _Cell({
    required this.id,
    required this.type,
    this.special = SpecialTile.none,
    this.spoiled = false,
  });

  bool get isJoker => special == SpecialTile.joker;
  bool get isBomb => special == SpecialTile.bomb;

  // Tylko joker i bomba łączą się z dowolnym surowcem w ścieżce - złoto
  // jest normalnym surowcem i łączy się wyłącznie z innym złotem.
  bool get isWild => special != SpecialTile.none;
}

class _Explosion {
  final int id;
  final Offset center;

  const _Explosion({required this.id, required this.center});
}

class HarvestGrid extends StatefulWidget {
  final int rows;
  final int cols;
  final void Function(ResourceType type, int count) onHarvest;
  final void Function(ResourceType type, int count)? onAutoMatch;
  final VoidCallback? onMoveUsed;
  final ValueChanged<int>? onPathCompleted;
  final VoidCallback? onJokerSpawned;
  final VoidCallback? onJokerUsed;
  final VoidCallback? onBombSpawned;
  final VoidCallback? onBombDetonated;
  final VoidCallback? onShuffleUsed;
  final Set<ResourceType> availableTypes;
  final ResourceType? boostedType;
  // null = automatyczne usuwanie wyłączone. W przeciwnym razie: minimalna
  // długość ciągu, która znika sama (4 = tylko czwórki i więcej, odblokowane
  // pierwszym zakupem w sklepie; 3 = też trójki, po ulepszeniu).
  final int? autoMatchMinLength;
  final Season season;
  // Szansa na zepsucie sezonowego surowca (0..kSpoiledChance) - zmniejszana
  // przez Kaplicę/Studnię/Spichlerz (patrz HomeShell._spoiledChance).
  final double spoiledChance;
  // Minimalna długość ścieżki, przy której pojawia się joker/bomba -
  // domyślnie 5/6, obniżane o 1 przez odkrycia "Szczęśliwa passa"/
  // "Wybuchowy zapał" z Uczelni (patrz HomeShell._minComboForJoker/Bomb).
  final int minComboForJoker;
  final int minComboForBomb;
  // Mnożnik wagi losowania dla konkretnych typów - używane w starciach z
  // bossami, żeby surowiec-cel (np. Miecz, Prawda) był rzadszy niż reszta
  // planszy, tym rzadszy im słabsze morale/bezpieczeństwo wioski (patrz
  // HomeShell._battleWeightMultiplier). Typy spoza mapy zachowują normalną
  // wagę; wynikowa waga jest zawsze przycinana do min. 1, żeby cel nigdy nie
  // stał się dosłownie niemożliwy do zebrania.
  final Map<ResourceType, double>? typeWeightMultipliers;

  const HarvestGrid({
    super.key,
    required this.rows,
    required this.cols,
    required this.onHarvest,
    this.onAutoMatch,
    this.onMoveUsed,
    this.onPathCompleted,
    this.onJokerSpawned,
    this.onJokerUsed,
    this.onBombSpawned,
    this.onBombDetonated,
    this.onShuffleUsed,
    this.availableTypes = kStarterResourceTypes,
    this.boostedType,
    this.autoMatchMinLength,
    this.season = Season.spring,
    this.spoiledChance = kSpoiledChance,
    this.minComboForJoker = 5,
    this.minComboForBomb = 6,
    this.typeWeightMultipliers,
  });

  @override
  State<HarvestGrid> createState() => HarvestGridState();
}

class HarvestGridState extends State<HarvestGrid> {
  static const _baseWeight = 100;
  static const _minBoostMultiplier = 1.10;
  static const _maxBoostBonus = 0.10;
  static const _fallDuration = Duration(milliseconds: 380);
  static const _initialRevealPause = Duration(milliseconds: 550);

  final _random = Random();
  final _gridKey = GlobalKey();

  late List<List<_Cell>> _grid;
  int _nextId = 0;
  int _nextExplosionId = 0;
  List<GridPosition> _path = [];
  ResourceType? _pathType;
  bool _shufflePromptShown = false;
  Offset? _lastLocalPoint;

  // Id nowo powstałych kafelków -> ile "wierszy nad planszą" mają w tej klatce.
  final Map<int, int> _spawnOffsetRows = {};
  final List<_Explosion> _explosions = [];

  late final Map<ResourceType, int> _weights = _computeWeights();

  Map<ResourceType, int> _computeWeights() {
    final weights = <ResourceType, int>{
      for (final type in widget.availableTypes) type: _baseWeight,
    };
    for (final entry in widget.season.weightMultipliers.entries) {
      if (weights.containsKey(entry.key)) {
        weights[entry.key] = (weights[entry.key]! * entry.value).round();
      }
    }
    final battleMultipliers = widget.typeWeightMultipliers;
    if (battleMultipliers != null) {
      for (final entry in battleMultipliers.entries) {
        if (weights.containsKey(entry.key)) {
          weights[entry.key] = (weights[entry.key]! * entry.value).round().clamp(1, 1 << 30);
        }
      }
    }
    final boosted = widget.boostedType;
    if (boosted != null && weights.containsKey(boosted)) {
      // Premia "surowca tygodnia" to losowe 10-20%, nie stała wartość.
      final multiplier = _minBoostMultiplier + _random.nextDouble() * _maxBoostBonus;
      weights[boosted] = (weights[boosted]! * multiplier).round();
    }
    return weights;
  }

  @override
  void initState() {
    super.initState();
    _grid = List.generate(
      widget.rows,
      (_) => List.generate(widget.cols, (_) => _newRandomCell()),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Krótka pauza, żeby gracz zobaczył świeżo rozdaną planszę, zanim
      // ewentualne trójki same znikną.
      await Future.delayed(_initialRevealPause);
      if (!mounted) return;
      _resolveAutoMatches();
    });
  }

  _Cell _newCell(ResourceType type, {SpecialTile special = SpecialTile.none, bool spoiled = false}) {
    final cell = _Cell(id: _nextId, type: type, special: special, spoiled: spoiled);
    _nextId++;
    return cell;
  }

  /// Losuje typ surowca i - w sezonach, które psują dany surowiec (spalone
  /// zboże latem, zamarznięta woda zimą) - z 10% szansą oznacza go jako
  /// zepsuty (nadal łączy się w ścieżkę, ale nie da nic po zebraniu).
  _Cell _newRandomCell() {
    final type = _randomType();
    final spoiled = type == widget.season.spoiledResourceType && _random.nextDouble() < widget.spoiledChance;
    return _newCell(type, spoiled: spoiled);
  }

  ResourceType _randomType() {
    final total = _weights.values.fold(0, (a, b) => a + b);
    var roll = _random.nextInt(total);
    for (final entry in _weights.entries) {
      if (roll < entry.value) return entry.key;
      roll -= entry.value;
    }
    return widget.availableTypes.first;
  }

  _Cell _cellAt(GridPosition p) => _grid[p.row][p.col];

  _Cell _findCellById(int id) {
    for (final row in _grid) {
      for (final cell in row) {
        if (cell.id == id) return cell;
      }
    }
    throw StateError('Cell with id $id not found');
  }

  Iterable<GridPosition> _neighborsOf(GridPosition p) sync* {
    for (var dr = -1; dr <= 1; dr++) {
      for (var dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        final r = p.row + dr;
        final c = p.col + dc;
        if (r >= 0 && r < widget.rows && c >= 0 && c < widget.cols) {
          yield GridPosition(r, c);
        }
      }
    }
  }

  bool _hasAvailableMove() {
    for (var r = 0; r < widget.rows; r++) {
      for (var c = 0; c < widget.cols; c++) {
        final cell = _grid[r][c];
        for (final n in _neighborsOf(GridPosition(r, c))) {
          final other = _cellAt(n);
          if (cell.isWild || other.isWild || cell.type == other.type) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _checkForMoves() {
    if (!mounted || _shufflePromptShown) return;
    if (_hasAvailableMove()) return;
    _shufflePromptShown = true;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.harvestGridNoMovesTitle),
        content: Text(l10n.harvestGridNoMovesMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shufflePromptShown = false;
            },
            child: Text(l10n.harvestGridCloseButton),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shufflePromptShown = false;
              _shuffleBoard();
              widget.onShuffleUsed?.call();
            },
            child: Text(l10n.harvestGridReshuffleButton),
          ),
        ],
      ),
    );
  }

  /// Pozwala rodzicowi (ekranowi gry) wywołać przetasowanie planszy w dowolnym
  /// momencie, np. z przycisku "Przetasuj (−1 ruch)" w AppBar.
  void shuffleNow() => _shuffleBoard();

  /// Liczba kafelków danego surowca aktualnie widocznych na planszy (nie
  /// zebranych) - używane np. przez starcie z Leszym, żeby licznik Cienia
  /// uwzględniał też niezebrane jeszcze kulki, nie tylko punkty z jego ruchów.
  int countType(ResourceType type) {
    var count = 0;
    for (final row in _grid) {
      for (final cell in row) {
        if (cell.type == type) count++;
      }
    }
    return count;
  }

  /// Zamienia losowy ułamek kafelków (0..1) na podany typ, bez animacji
  /// spadania - zachowuje pozycję i id, tylko podmienia typ i czyści
  /// ewentualny status specjalny/zepsucia. Używane np. przez mgłę Leszego
  /// (patrz LeszyBattleScreen), która zamienia część planszy w cienie.
  void corruptRandomTiles(double fraction, ResourceType type) {
    final positions = <GridPosition>[
      for (var r = 0; r < widget.rows; r++)
        for (var c = 0; c < widget.cols; c++) GridPosition(r, c),
    ]..shuffle(_random);
    final count = (positions.length * fraction).round();
    setState(() {
      for (final pos in positions.take(count)) {
        final cell = _grid[pos.row][pos.col];
        _grid[pos.row][pos.col] = _Cell(id: cell.id, type: type);
      }
    });
  }

  /// Zamienia WSZYSTKIE kafelki podanego typu na świeżo wylosowane inne typy
  /// (nigdy ponownie ten sam), bez animacji spadania - symuluje "wybuch"
  /// (licznik Cienia u Leszego, patrz LeszyBattleScreen._checkShadowExplosion),
  /// po którym żaden kafelek tego typu nie zostaje na planszy.
  void explodeType(ResourceType type) {
    setState(() {
      for (var r = 0; r < widget.rows; r++) {
        for (var c = 0; c < widget.cols; c++) {
          final cell = _grid[r][c];
          if (cell.type == type) {
            _grid[r][c] = _newCell(_randomTypeExcluding(type));
          }
        }
      }
    });
  }

  ResourceType _randomTypeExcluding(ResourceType exclude) {
    final entries = _weights.entries.where((e) => e.key != exclude).toList();
    if (entries.isEmpty) return exclude;
    final total = entries.fold(0, (sum, e) => sum + e.value);
    var roll = _random.nextInt(total);
    for (final entry in entries) {
      if (roll < entry.value) return entry.key;
      roll -= entry.value;
    }
    return entries.first.key;
  }

  void _shuffleBoard() {
    final cells = <_Cell>[
      for (final row in _grid) ...row,
    ];
    cells.shuffle(_random);
    setState(() {
      var i = 0;
      for (var r = 0; r < widget.rows; r++) {
        for (var c = 0; c < widget.cols; c++) {
          _grid[r][c] = cells[i];
          i++;
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveAutoMatches());
  }

  Set<GridPosition> _findAutoMatches() {
    final matched = <GridPosition>{};
    final minLength = widget.autoMatchMinLength ?? 3;

    void addRun(List<GridPosition> run) {
      if (run.length >= minLength) matched.addAll(run);
    }

    // Poziomo.
    for (var r = 0; r < widget.rows; r++) {
      var run = <GridPosition>[GridPosition(r, 0)];
      for (var c = 1; c < widget.cols; c++) {
        final prev = _grid[r][c - 1];
        final curr = _grid[r][c];
        final continues = prev.special == SpecialTile.none &&
            curr.special == SpecialTile.none &&
            prev.type == curr.type;
        if (continues) {
          run.add(GridPosition(r, c));
        } else {
          addRun(run);
          run = [GridPosition(r, c)];
        }
      }
      addRun(run);
    }

    // Pionowo.
    for (var c = 0; c < widget.cols; c++) {
      var run = <GridPosition>[GridPosition(0, c)];
      for (var r = 1; r < widget.rows; r++) {
        final prev = _grid[r - 1][c];
        final curr = _grid[r][c];
        final continues = prev.special == SpecialTile.none &&
            curr.special == SpecialTile.none &&
            prev.type == curr.type;
        if (continues) {
          run.add(GridPosition(r, c));
        } else {
          addRun(run);
          run = [GridPosition(r, c)];
        }
      }
      addRun(run);
    }

    return matched;
  }

  /// Automatycznie usuwa ciągi tego samego surowca stojące w rzędzie/kolumnie
  /// (bez udziału gracza), dodaje je do zapasów i kaskadowo sprawdza,
  /// czy opadnięcie nowych kafelków nie utworzyło kolejnych takich ciągów.
  void _resolveAutoMatches() {
    if (!mounted) return;
    // Domyślnie wyłączone - ciągi zostają na planszy, dopóki gracz nie
    // zbierze ich ręcznie. Odblokowywane jako płatne ulepszenie w sklepie
    // (najpierw czwórki, potem ulepszenie na trójki - autoMatchMinLength).
    if (widget.autoMatchMinLength == null) {
      _checkForMoves();
      return;
    }
    final matches = _findAutoMatches();
    if (matches.isEmpty) {
      _checkForMoves();
      return;
    }

    final tally = <ResourceType, int>{};
    for (final pos in matches) {
      final cell = _cellAt(pos);
      if (cell.spoiled) continue;
      tally[cell.type] = (tally[cell.type] ?? 0) + 1;
    }

    setState(() {
      final spawnOffsets = _removeAndRefill(matches);
      _spawnOffsetRows.addAll(spawnOffsets);
    });

    SoundService.playCollect();
    for (final entry in tally.entries) {
      widget.onAutoMatch?.call(entry.key, entry.value);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _spawnOffsetRows.clear());
      // Czekamy, aż kafelki faktycznie skończą spadać, zanim sprawdzimy
      // kolejną falę kaskady - inaczej znikałyby "w locie", ledwo widocznie.
      await Future.delayed(_fallDuration);
      if (!mounted) return;
      _resolveAutoMatches();
    });
  }

  /// Usuwa podane pozycje, przesuwa ocalałe kafelki w dół kolumny i dokłada
  /// nowe na górze. Zwraca mapę id->offset dla nowych kafelków (do animacji
  /// spadania) - NIE modyfikuje `_spawnOffsetRows` bezpośrednio.
  Map<int, int> _removeAndRefill(Set<GridPosition> toRemove) {
    final spawnOffsets = <int, int>{};
    for (var c = 0; c < widget.cols; c++) {
      final survivors = <_Cell>[];
      for (var r = 0; r < widget.rows; r++) {
        if (!toRemove.contains(GridPosition(r, c))) {
          survivors.add(_grid[r][c]);
        }
      }
      final missing = widget.rows - survivors.length;
      final newCells = List.generate(missing, (_) => _newRandomCell());
      final column = [...newCells, ...survivors];
      for (var r = 0; r < widget.rows; r++) {
        _grid[r][c] = column[r];
        if (r < missing) {
          spawnOffsets[column[r].id] = r + 1;
        }
      }
    }
    return spawnOffsets;
  }

  GridPosition? _positionFromLocal(Offset local, double cellSize) {
    final col = (local.dx / cellSize).floor();
    final row = (local.dy / cellSize).floor();
    if (row < 0 || row >= widget.rows || col < 0 || col >= widget.cols) {
      return null;
    }
    return GridPosition(row, col);
  }

  Offset _globalToLocal(Offset global) {
    final box = _gridKey.currentContext!.findRenderObject() as RenderBox;
    return box.globalToLocal(global);
  }

  Offset _centerOf(GridPosition p, double cellSize) =>
      Offset((p.col + 0.5) * cellSize, (p.row + 0.5) * cellSize);

  // Sąsiad po przekątnej ma środek w odległości cellSize*√2 od `last`,
  // a sąsiad z boku/góry/dołu tylko cellSize - czyli jest geometrycznie
  // BLIŻEJ niemal każdego punktu dotyku. Wybieranie "najbliższego" sąsiada
  // przez samą odległość systemowo faworyzuje więc ortogonalne kierunki,
  // zwłaszcza gdy oba są "dzikie" (jak przy jokerze) i żaden nie dostaje
  // kary za niezgodność typu. Zamiast odległości do środka kafelka patrzymy
  // więc na KIERUNEK, w który faktycznie ciągnie palec względem `last` -
  // to jednakowo traktuje wszystkie 8 kierunków.
  GridPosition? _nearestNeighbor(
    Offset local,
    GridPosition last,
    double cellSize,
  ) {
    final lastCenter = _centerOf(last, cellSize);
    final dragVector = local - lastCenter;
    final dragDistance = dragVector.distance;
    // Za mało ruchu od ostatniego kafelka, żeby sensownie ocenić kierunek.
    if (dragDistance < cellSize * 0.2) return null;

    GridPosition? best;
    var bestScore = -double.infinity;
    for (final n in _neighborsOf(last)) {
      final dirVector = _centerOf(n, cellSize) - lastCenter;
      final alignment = (dragVector.dx * dirVector.dx + dragVector.dy * dirVector.dy) /
          (dragDistance * dirVector.distance);
      final cell = _cellAt(n);
      final connectable =
          cell.isWild || _pathType == null || cell.type == _pathType;
      // Kierunek decyduje, "łączliwość" jest tylko drobnym rozstrzygnięciem remisu.
      final score = alignment + (connectable ? 0.05 : -0.2);
      if (score > bestScore) {
        bestScore = score;
        best = n;
      }
    }
    if (best != null && bestScore > 0.3 && dragDistance <= cellSize * 1.3) {
      return best;
    }
    return null;
  }

  void _handleStart(Offset globalPosition, double cellSize) {
    final local = _globalToLocal(globalPosition);
    final pos = _positionFromLocal(local, cellSize);
    _lastLocalPoint = local;
    if (pos == null) return;
    final cell = _cellAt(pos);
    setState(() {
      _path = [pos];
      _pathType = cell.isWild ? null : cell.type;
    });
  }

  void _handleUpdate(Offset globalPosition, double cellSize) {
    if (_path.isEmpty) return;
    final newLocal = _globalToLocal(globalPosition);
    final from = _lastLocalPoint ?? newLocal;
    _lastLocalPoint = newLocal;

    // Przy szybkim geście onPanUpdate dostaje tylko końcowy punkt zdarzenia,
    // więc pojedyncza próbka potrafi "przeskoczyć" nad kafelkiem po skosie
    // (gdzie hit-region jest mniejszy niż przy sąsiadach po bokach).
    // Próbkujemy więc kilka punktów pośrednich wzdłuż całego ruchu palca,
    // żeby żaden kafelek na trasie nie został pominięty.
    final travelled = (newLocal - from).distance;
    final steps = max(1, (travelled / (cellSize * 0.25)).ceil());
    for (var i = 1; i <= steps; i++) {
      final point = Offset.lerp(from, newLocal, i / steps)!;
      _advanceTo(point, cellSize);
    }
  }

  void _advanceTo(Offset local, double cellSize) {
    if (_path.isEmpty) return;
    final last = _path.last;

    // Cofnięcie palca w stronę przedostatniego kafelka odznacza ostatni wybór.
    if (_path.length > 1) {
      final prev = _path[_path.length - 2];
      if ((local - _centerOf(prev, cellSize)).distance <= cellSize * 0.6) {
        setState(() {
          _path.removeLast();
          _pathType = _recomputePathType();
        });
        return;
      }
    }

    final pos = _nearestNeighbor(local, last, cellSize);
    if (pos == null) return;
    if (_path.contains(pos)) return;

    final candidate = _cellAt(pos);
    if (!candidate.isWild && _pathType != null && candidate.type != _pathType) {
      return;
    }

    setState(() {
      _path.add(pos);
      if (!candidate.isWild && _pathType == null) {
        _pathType = candidate.type;
      }
    });
  }

  ResourceType? _recomputePathType() {
    for (final pos in _path) {
      final cell = _cellAt(pos);
      if (!cell.isWild) return cell.type;
    }
    return null;
  }

  void _handleEnd() {
    if (_path.length < 2) {
      setState(() => _path = []);
      return;
    }

    final rawCount = _path.length;
    widget.onPathCompleted?.call(rawCount);
    final pathCells = _path.map(_cellAt).toList();
    final jokerCount = pathCells.where((c) => c.isJoker).length;
    // Spalone/zamarznięte kafelki nadal łączą się w ścieżkę, ale nie liczą
    // się do zebranej ilości.
    final base = pathCells.where((c) => c.special == SpecialTile.none && !c.spoiled).length;
    final harvestType = _pathType ?? ResourceType.coin;
    final bombPositions = [
      for (var i = 0; i < _path.length; i++)
        if (pathCells[i].isBomb) _path[i],
    ];

    final int finalCount;
    if (base == 0 && jokerCount > 0) {
      finalCount = jokerCount * jokerCount;
    } else if (jokerCount == 0) {
      finalCount = base;
    } else if (jokerCount == 1) {
      finalCount = base + 1;
    } else {
      finalCount = base * jokerCount;
    }

    // Bomby niszczą swoich 8-kierunkowych sąsiadów oprócz kafelków ze ścieżki.
    final matched = _path.toSet();
    final destroyedByBomb = <GridPosition>{};
    for (final bombPos in bombPositions) {
      for (final n in _neighborsOf(bombPos)) {
        if (!matched.contains(n)) destroyedByBomb.add(n);
      }
    }
    final destroyedTally = <ResourceType, int>{};
    for (final pos in destroyedByBomb) {
      final cell = _cellAt(pos);
      if (cell.spoiled) continue;
      destroyedTally[cell.type] = (destroyedTally[cell.type] ?? 0) + 1;
    }

    final explosionCenters = [
      for (final bombPos in bombPositions)
        Offset(bombPos.col + 0.5, bombPos.row + 0.5),
    ];

    final allRemoved = {...matched, ...destroyedByBomb};
    final spawnOffsets = _removeAndRefill(allRemoved);
    final spawned = [
      for (final id in spawnOffsets.keys) _findCellById(id),
    ];

    var jokerJustSpawned = false;
    var bombJustSpawned = false;
    if (rawCount >= widget.minComboForBomb && spawned.isNotEmpty) {
      final chosen = spawned[_random.nextInt(spawned.length)];
      _replaceCellById(chosen.id, special: SpecialTile.bomb);
      bombJustSpawned = true;
    } else if (rawCount >= widget.minComboForJoker && spawned.isNotEmpty) {
      final chosen = spawned[_random.nextInt(spawned.length)];
      _replaceCellById(chosen.id, special: SpecialTile.joker);
      jokerJustSpawned = true;
    }

    setState(() {
      _spawnOffsetRows.addAll(spawnOffsets);
      _path = [];
      _pathType = null;
      for (final center in explosionCenters) {
        final id = _nextExplosionId++;
        _explosions.add(_Explosion(id: id, center: center));
        Future.delayed(const Duration(milliseconds: 380), () {
          if (!mounted) return;
          setState(() => _explosions.removeWhere((e) => e.id == id));
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _spawnOffsetRows.clear());
      await Future.delayed(_fallDuration);
      if (!mounted) return;
      _resolveAutoMatches();
    });

    if (finalCount > 0) widget.onHarvest(harvestType, finalCount);
    for (final entry in destroyedTally.entries) {
      widget.onHarvest(entry.key, entry.value);
    }
    // Dokładnie jeden ruch na przeciągnięcie palcem, niezależnie od tego, ile
    // razy powyżej wywołano onHarvest (np. bomba dodaje osobne wywołanie dla
    // każdego zniszczonego typu surowca sąsiada).
    widget.onMoveUsed?.call();
    SoundService.playCollect();
    if (jokerCount > 0) widget.onJokerUsed?.call();
    if (bombPositions.isNotEmpty) {
      SoundService.playBombExplosion();
      // Jedno przeciągnięcie może przejść przez kilka bomb naraz - każda
      // z nich ma się liczyć osobno (np. cel "zdetonuj N bomb" w starciu
      // z Grotem), więc wywołujemy callback raz na bombę, nie raz na ruch.
      for (var i = 0; i < bombPositions.length; i++) {
        widget.onBombDetonated?.call();
      }
    }
    if (jokerJustSpawned) widget.onJokerSpawned?.call();
    if (bombJustSpawned) widget.onBombSpawned?.call();
  }

  void _replaceCellById(int id, {required SpecialTile special}) {
    for (var r = 0; r < widget.rows; r++) {
      for (var c = 0; c < widget.cols; c++) {
        if (_grid[r][c].id == id) {
          // Świeżo powstały joker/bomba nigdy nie jest "zepsuty" (spoiled: false domyślnie).
          _grid[r][c] = _Cell(id: id, type: _grid[r][c].type, special: special);
          return;
        }
      }
    }
  }

  Color get _currentPathColor => _pathType?.color ?? const Color(0xFF9B5DE5);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = min(
          constraints.maxWidth / widget.cols,
          constraints.maxHeight / widget.rows,
        );
        final gridWidth = cellSize * widget.cols;
        final gridHeight = cellSize * widget.rows;
        // Liczony raz na rebuild (nie per-kafelek), żeby sprawdzanie "czy ten
        // kafelek jest w bieżącej ścieżce" było O(1) zamiast przeszukiwania
        // całej listy dla każdego z kilkudziesięciu kafelków na planszy.
        final pathSet = _path.toSet();

        return Center(
          child: GestureDetector(
            onPanStart: (details) =>
                _handleStart(details.globalPosition, cellSize),
            onPanUpdate: (details) =>
                _handleUpdate(details.globalPosition, cellSize),
            onPanEnd: (_) => _handleEnd(),
            child: SizedBox(
              key: _gridKey,
              width: gridWidth,
              height: gridHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  for (var r = 0; r < widget.rows; r++)
                    for (var c = 0; c < widget.cols; c++)
                      _buildAnimatedTile(r, c, cellSize, pathSet),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: PathPainter(
                          path: _path,
                          cellSize: cellSize,
                          color: _path.isEmpty ? null : _currentPathColor,
                        ),
                      ),
                    ),
                  ),
                  for (final explosion in _explosions)
                    Positioned(
                      left: explosion.center.dx * cellSize - cellSize * 1.5,
                      top: explosion.center.dy * cellSize - cellSize * 1.5,
                      width: cellSize * 3,
                      height: cellSize * 3,
                      child: IgnorePointer(child: _ExplosionBurst()),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTile(int r, int c, double cellSize, Set<GridPosition> pathSet) {
    final cell = _grid[r][c];
    final offset = _spawnOffsetRows[cell.id] ?? 0;
    final displayRow = r - offset;
    return AnimatedPositioned(
      key: ValueKey(cell.id),
      duration: _fallDuration,
      curve: Curves.easeIn,
      left: c * cellSize,
      top: displayRow * cellSize,
      width: cellSize,
      height: cellSize,
      // RepaintBoundary izoluje każdy kafelek na własnej warstwie - bez tego
      // przemalowanie JEDNEGO zaznaczonego kafelka podczas przeciągania palcem
      // zmuszało silnik do przerysowania całego stosu kafelków (widoczne
      // przycinanie na słabszych telefonach przy szybkim rysowaniu ścieżki).
      child: RepaintBoundary(
        child: _TileView(
          type: cell.type,
          special: cell.special,
          spoiled: cell.spoiled,
          cellSize: cellSize,
          selected: pathSet.contains(GridPosition(r, c)),
        ),
      ),
    );
  }
}

class _ExplosionBurst extends StatefulWidget {
  @override
  State<_ExplosionBurst> createState() => _ExplosionBurstState();
}

class _ExplosionBurstState extends State<_ExplosionBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Opacity(
          opacity: (1 - t).clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.3 + t * 0.9,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.orange.withValues(alpha: 0.9),
                    Colors.deepOrange.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TileView extends StatelessWidget {
  final ResourceType type;
  final SpecialTile special;
  final bool spoiled;
  final double cellSize;
  final bool selected;

  const _TileView({
    required this.type,
    required this.special,
    required this.spoiled,
    required this.cellSize,
    required this.selected,
  });

  static const _jokerColor = Color(0xFF9B5DE5);
  static const _bombColor = Color(0xFF2B2B2E);
  static const _burntColor = Color(0xFF2B2B2B);
  static const _frozenColor = Color(0xFFAEE3F5);

  @override
  Widget build(BuildContext context) {
    final isSpecial = special != SpecialTile.none;
    final accent = special == SpecialTile.joker
        ? _jokerColor
        : special == SpecialTile.bomb
            ? _bombColor
            : spoiled
                ? (type == ResourceType.water ? _frozenColor : _burntColor)
                : type.color;
    final assetPath = special == SpecialTile.joker
        ? 'assets/icons/joker.png'
        : special == SpecialTile.bomb
            ? 'assets/icons/bomb.png'
            : type.assetPath;
    // Niektóre surowce (patrz ResourceType.assetPath) mają już gotowy,
    // w pełni wyrenderowany obrazek "kulki" (szklanej albo płaskiej, patrz
    // ResourceIconStyle) zamiast płaskiej samodzielnej ikony SVG - dla nich
    // pomijamy proceduralny gradient/cień poniżej (byłaby to podwójna
    // kulka) i pokazujemy sam obrazek wypełniający kafelek. Bomba/Joker
    // mają teraz też gotowe obrazki PNG, ale to wciąż SAME ikony bez tła
    // (patrz A10 w docs/midjourney_prompts.md) - dla nich proceduralna
    // kulka w tle zostaje.
    final usesImageOrb = !isSpecial && !spoiled && assetPath.endsWith('.png');
    final assetIsPng = assetPath.endsWith('.png');

    // Kafelek jako szklista "kulka" (gem), nie kwadratowa karta - zasób
    // siedzi bezpośrednio wewnątrz sfery z gradientem i cieniem, podobnie
    // jak elementy planszy w grach typu Gems of War.
    final outerPadding = cellSize * 0.05;
    return Padding(
      padding: EdgeInsets.all(outerPadding),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: selected ? 1.1 : 1.0,
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: usesImageOrb
                ? null
                : RadialGradient(
                    center: const Alignment(-0.35, -0.4),
                    radius: 0.95,
                    colors: [
                      Color.lerp(accent, Colors.white, 0.6)!,
                      accent,
                      Color.lerp(accent, Colors.black, 0.3)!,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
            border: selected
                ? Border.all(color: Colors.white, width: cellSize * 0.035)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: cellSize * 0.1,
                offset: Offset(0, cellSize * 0.05),
              ),
              if (isSpecial || selected)
                BoxShadow(
                  color: accent.withValues(alpha: 0.75),
                  blurRadius: cellSize * 0.28,
                  spreadRadius: cellSize * 0.02,
                ),
            ],
          ),
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.all(usesImageOrb ? 0 : cellSize * 0.17),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: Opacity(
                    opacity: spoiled ? 0.55 : 1,
                    child: assetIsPng
                        ? Image.asset(
                            assetPath,
                            key: ValueKey(assetPath),
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            assetPath,
                            key: ValueKey(assetPath),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
              if (spoiled)
                Positioned(
                  right: cellSize * 0.02,
                  bottom: cellSize * 0.02,
                  child: Icon(
                    type == ResourceType.water ? Icons.ac_unit : Icons.local_fire_department,
                    size: cellSize * 0.26,
                    color: type == ResourceType.water ? Colors.white : Colors.deepOrange,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
