import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/resource_type.dart';
import '../widgets/resource_icon.dart';

bool _canAfford(Map<ResourceType, int> cost, Map<ResourceType, int> stockpile) =>
    cost.entries.every((e) => (stockpile[e.key] ?? 0) >= e.value);

/// Ekran sklepu - trwałe dokupienie dodatkowych ruchów na planszy zbiorów i
/// ulepszenia automatycznego dopasowywania. Koszty (surowce, nie tylko
/// złoto) rosną z każdym zakupem - patrz HomeShell._nextMoveCost/
/// _autoMatchTier1Cost/_autoMatchTier2Cost.
class ShopView extends StatelessWidget {
  final int baseMoves;
  final int extraMoves;
  final int maxTotalMoves;
  final Map<ResourceType, int> stockpile;
  final Map<ResourceType, int> nextCost;
  final VoidCallback onBuy;
  final int autoMatchTier;
  final Map<ResourceType, int> autoMatchTier1Cost;
  final Map<ResourceType, int> autoMatchTier2Cost;
  final VoidCallback onBuyAutoMatchTier1;
  final VoidCallback onBuyAutoMatchTier2;
  // Co jeszcze podnosi maxTotalMoves ponad to, co widać tutaj w Sklepie -
  // patrz HomeShell._maxExtraMoves/._baseMoves. Same dane, którymi już
  // sterują inne ekrany (poziom Sklepu, pracownicy, odkrycia Uczelni),
  // tylko przekazane tutaj do wyświetlenia jako checklista.
  final bool sklepLevel2Unlocked;
  final int sklepLevel2Bonus;
  final int sklepWorkers;
  final int maxWorkersPerBuilding;
  final bool discovery1Unlocked;
  final bool discovery2Unlocked;
  final int discoveryMovesBonus;

  const ShopView({
    super.key,
    required this.baseMoves,
    required this.extraMoves,
    required this.maxTotalMoves,
    required this.stockpile,
    required this.nextCost,
    required this.onBuy,
    required this.autoMatchTier,
    required this.autoMatchTier1Cost,
    required this.autoMatchTier2Cost,
    required this.onBuyAutoMatchTier1,
    required this.onBuyAutoMatchTier2,
    required this.sklepLevel2Unlocked,
    required this.sklepLevel2Bonus,
    required this.sklepWorkers,
    required this.maxWorkersPerBuilding,
    required this.discovery1Unlocked,
    required this.discovery2Unlocked,
    required this.discoveryMovesBonus,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalMoves = baseMoves + extraMoves;
    final atMax = totalMoves >= maxTotalMoves;
    final canAfford = !atMax && _canAfford(nextCost, stockpile);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.shopTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            l10n.shopSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 30, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.shopMovesPerWeekLabel, style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        '$totalMoves',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        l10n.shopMovesBreakdown(baseMoves, extraMoves),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.shopMovesUnlockTitle,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _MovesUnlockRow(
                  done: sklepLevel2Unlocked,
                  text: l10n.shopMovesUnlockSklepLevel2(sklepLevel2Bonus),
                ),
                _MovesUnlockRow(
                  done: sklepWorkers >= maxWorkersPerBuilding && maxWorkersPerBuilding > 0,
                  text: l10n.shopMovesUnlockSklepWorkers(sklepWorkers, maxWorkersPerBuilding),
                ),
                _MovesUnlockRow(
                  done: discovery1Unlocked,
                  text: l10n.shopMovesUnlockDiscovery1(discoveryMovesBonus),
                ),
                _MovesUnlockRow(
                  done: discovery2Unlocked,
                  text: l10n.shopMovesUnlockDiscovery2(discoveryMovesBonus),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: resourceIconAsset(ResourceType.coin.assetPath, size: 32),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.shopBuyMoveTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (atMax)
                  Text(
                    l10n.shopMaxMovesReached,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                  )
                else
                  _CostList(cost: nextCost, stockpile: stockpile),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: canAfford ? onBuy : null,
                    child: Text(l10n.shopBuyButton),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _AutoMatchTierCard(
            icon: Icons.auto_awesome,
            title: l10n.shopAutoMatchTier1Title,
            description: l10n.shopAutoMatchTier1Description,
            unlocked: autoMatchTier >= 1,
            locked: false,
            lockedText: null,
            stockpile: stockpile,
            cost: autoMatchTier1Cost,
            onBuy: onBuyAutoMatchTier1,
          ),
          const SizedBox(height: 16),
          _AutoMatchTierCard(
            icon: Icons.auto_awesome_motion,
            title: l10n.shopAutoMatchTier2Title,
            description: l10n.shopAutoMatchTier2Description,
            unlocked: autoMatchTier >= 2,
            locked: autoMatchTier < 1,
            lockedText: l10n.shopAutoMatchTier2LockedRequirement,
            stockpile: stockpile,
            cost: autoMatchTier2Cost,
            onBuy: onBuyAutoMatchTier2,
          ),
        ],
      ),
    );
  }
}

/// Karta jednego stopnia ulepszenia automatycznego usuwania ciągów - może
/// być zablokowana (wymaga poprzedniego stopnia), dostępna do kupienia albo
/// już odblokowana.
class _AutoMatchTierCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;
  final bool locked;
  final String? lockedText;
  final Map<ResourceType, int> stockpile;
  final Map<ResourceType, int> cost;
  final VoidCallback onBuy;

  const _AutoMatchTierCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
    required this.locked,
    required this.lockedText,
    required this.stockpile,
    required this.cost,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canAfford = !locked && !unlocked && _canAfford(cost, stockpile);
    return Opacity(
      opacity: locked ? 0.6 : 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  locked ? Icons.lock : icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            if (unlocked)
              Text(
                l10n.shopUnlockedLabel,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F9E57)),
              )
            else if (locked)
              Text(
                lockedText ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
              )
            else ...[
              _CostList(cost: cost, stockpile: stockpile),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canAfford ? onBuy : null,
                  child: Text(l10n.shopBuyButton),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Rozpisany koszt (może być kilka surowców naraz) - każda pozycja pokazuje
/// ikonę, "masz/potrzeba", na zielono gdy starcza, na czerwono gdy brakuje.
class _CostList extends StatelessWidget {
  final Map<ResourceType, int> cost;
  final Map<ResourceType, int> stockpile;

  const _CostList({required this.cost, required this.stockpile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      children: [
        for (final entry in cost.entries)
          _CostItem(type: entry.key, need: entry.value, have: stockpile[entry.key] ?? 0),
      ],
    );
  }
}

class _CostItem extends StatelessWidget {
  final ResourceType type;
  final int need;
  final int have;

  const _CostItem({required this.type, required this.need, required this.have});

  @override
  Widget build(BuildContext context) {
    final enough = have >= need;
    final color = enough ? const Color(0xFF2F9E57) : const Color(0xFFC0392B);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 18, height: 18, child: resourceIconAsset(type.assetPath, size: 18)),
        const SizedBox(width: 4),
        Text(
          '$have/$need',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}

/// Jedna pozycja checklisty "jak zwiększyć limit ruchów" - odhaczona, gdy
/// dany warunek jest już spełniony, w przeciwnym razie wyszarzona z ikoną
/// kłódki.
class _MovesUnlockRow extends StatelessWidget {
  final bool done;
  final String text;

  const _MovesUnlockRow({required this.done, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = done ? const Color(0xFF2F9E57) : Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(done ? Icons.check_circle : Icons.lock_outline, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
