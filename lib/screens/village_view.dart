import 'package:flutter/material.dart';

import '../widgets/village_board.dart';

/// Sam widok planszy wioski - bez paska surowców, bez AppBar, żeby zajmować
/// prawie cały ekran. Stan (zapasy, flagi budynków) trzyma HomeShell.
class VillageView extends StatelessWidget {
  final bool ratuszBuilt;
  final bool palisadeBuilt;
  final Map<BuildingKind, bool> builtMap;
  final List<bool> extraHousesBuilt;
  final List<bool> extraHousesActive;
  final Map<BuildingKind, int> workers;
  final Map<BuildingKind, bool> upgradedMap;
  final VoidCallback onTapRatusz;
  final VoidCallback onTapPalisade;
  final void Function(BuildingKind kind) onTapBuilding;
  final void Function(int index) onTapExtraHouse;
  final VoidCallback onTapEmptyPlot;

  const VillageView({
    super.key,
    required this.ratuszBuilt,
    required this.palisadeBuilt,
    required this.builtMap,
    required this.extraHousesBuilt,
    this.extraHousesActive = const [],
    this.workers = const {},
    this.upgradedMap = const {},
    required this.onTapRatusz,
    required this.onTapPalisade,
    required this.onTapBuilding,
    required this.onTapExtraHouse,
    required this.onTapEmptyPlot,
  });

  @override
  Widget build(BuildContext context) {
    return VillageBoard(
      ratuszBuilt: ratuszBuilt,
      palisadeBuilt: palisadeBuilt,
      builtMap: builtMap,
      extraHousesBuilt: extraHousesBuilt,
      extraHousesActive: extraHousesActive,
      workers: workers,
      upgradedMap: upgradedMap,
      onTapRatusz: onTapRatusz,
      onTapPalisade: onTapPalisade,
      onTapBuilding: onTapBuilding,
      onTapExtraHouse: onTapExtraHouse,
      onTapEmptyPlot: onTapEmptyPlot,
    );
  }
}
