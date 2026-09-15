import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/area_kind.dart';
import '../models/resource_type.dart';
import '../widgets/resource_icon.dart';

/// Ekran "okolic wioski" - jedna ścieżka rozwoju przez wszystkie sześć
/// terenów: Sad -> Łąka -> Pole odblokowują po kolei jabłko/trawę/zboże,
/// a Rzeka -> Góry -> Las to końcowe ulepszenia, które te trzy surowce
/// zużywają jako koszt (dając w zamian premię +1/ścieżkę do surowca
/// dostępnego od początku gry). Każdy etap wymaga ukończenia poprzedniego.
/// Każdy teren ma dwa poziomy: 1 (zbudowany) i 2 (rozbudowany - odblokowuje
/// wybór tego surowca jako "surowca tygodnia").
class SurroundingsView extends StatelessWidget {
  final Map<AreaKind, bool> built;
  final Map<AreaKind, bool> upgraded;
  final void Function(AreaKind area) onTapArea;

  const SurroundingsView({
    super.key,
    required this.built,
    required this.upgraded,
    required this.onTapArea,
  });

  static const _path = [
    AreaKind.orchard,
    AreaKind.meadow,
    AreaKind.field,
    AreaKind.river,
    AreaKind.mountains,
    AreaKind.forest,
  ];

  bool _isLocked(AreaKind area) {
    final prereq = area.prerequisite;
    if (prereq == null) return false;
    return !(built[area] ?? false) && !(built[prereq] ?? false);
  }

  @override
  Widget build(BuildContext context) {
    // Cały ekran przewija się jako jedna całość (nagłówek + karty) - tak samo
    // jak w Surowcach/Statystykach - zamiast dzielić go na osobny, "sztywny"
    // nagłówek i osobno przewijaną listę kart: to drugie podejście na części
    // urządzeń potrafiło powodować nachodzenie przewijanej karty na nagłówek.
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.surroundingsTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            l10n.surroundingsSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 14),
          for (final area in _path) ...[
            SizedBox(
              height: 88,
              child: _AreaCard(
                area: area,
                built: built[area] ?? false,
                upgraded: upgraded[area] ?? false,
                locked: _isLocked(area),
                onTap: () => onTapArea(area),
              ),
            ),
            if (area != _path.last)
              SizedBox(
                height: 28,
                child: Center(
                  child: Icon(
                    Icons.arrow_downward,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final AreaKind area;
  final bool built;
  final bool upgraded;
  final bool locked;
  final VoidCallback onTap;

  const _AreaCard({
    required this.area,
    required this.built,
    required this.upgraded,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resource = area.resourceType;
    final baseColor = area.terrainColor;
    final topColor = locked ? Color.lerp(baseColor, Colors.black, 0.55)! : baseColor;
    final bottomColor = Color.lerp(topColor, Colors.black, 0.25)!;

    final statusIcon = locked
        ? const Icon(Icons.lock, color: Colors.white70, size: 20)
        : !built
            ? Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.black87, size: 18),
              )
            : upgraded
                ? const Icon(Icons.check_circle, color: Colors.white)
                : const Icon(Icons.arrow_circle_up, color: Colors.white);

    final subtitle = locked
        ? l10n.surroundingsRequiresLabel(area.prerequisite!.label)
        : !built
            ? (area.isStarterResource
                ? l10n.surroundingsPathBonus(resource.label.toLowerCase())
                : l10n.surroundingsUnlockResource(resource.label.toLowerCase()))
            : upgraded
                ? l10n.surroundingsLevelMaxLabel
                : l10n.surroundingsLevelUpgradableLabel;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topColor, bottomColor],
          ),
          borderRadius: BorderRadius.circular(16),
          border: built ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Opacity(
            opacity: locked ? 0.75 : 1,
            child: Row(
              children: [
                SizedBox(width: 36, height: 36, child: resourceIconAsset(resource.assetPath, size: 36)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        area.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                statusIcon,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
