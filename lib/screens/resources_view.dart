import 'package:flutter/material.dart';

import '../models/resource_type.dart';
import '../widgets/resource_flow_table.dart';
import '../widgets/resource_icon.dart';

/// Pełnoekranowy widok zapasów wioski.
class ResourcesView extends StatelessWidget {
  final Map<ResourceType, int> stockpile;
  final int storageCap;
  final Set<ResourceType> unlockedTypes;
  final Map<ResourceType, int> weeklyProduction;
  final Map<ResourceType, int> weeklyConsumption;
  final Map<ResourceType, List<(String, int)>> weeklyProductionSources;
  final Map<ResourceType, List<(String, int)>> weeklyConsumptionSources;
  final VoidCallback? onTrade;

  const ResourcesView({
    super.key,
    required this.stockpile,
    required this.storageCap,
    this.unlockedTypes = const {...ResourceType.values},
    this.weeklyProduction = const {},
    this.weeklyConsumption = const {},
    this.weeklyProductionSources = const {},
    this.weeklyConsumptionSources = const {},
    this.onTrade,
  });

  void _showLockedInfo(BuildContext context, ResourceType type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 20),
            const SizedBox(width: 8),
            Text(type.label),
          ],
        ),
        content: Text(
          '${type.label} nie zostało jeszcze odkryte. Dopóki nie odblokujesz go w '
          'Okolicach wioski, wszystkie premie do tego surowca (np. z Ratusza czy '
          'budynków produkcyjnych) nie będą działać.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Rozumiem'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Surowce', style: Theme.of(context).textTheme.titleLarge)),
              if (onTrade != null)
                FilledButton.icon(
                  onPressed: onTrade,
                  icon: const Icon(Icons.swap_horiz, size: 18),
                  label: const Text('Rynek'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Magazyn: limit $storageCap każdego surowca.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.3,
            children: [
              for (final type in ResourceType.values)
                if (!kBattleOnlyResourceTypes.contains(type))
                Builder(
                  builder: (context) {
                    final unlocked = unlockedTypes.contains(type);
                    final scheme = Theme.of(context).colorScheme;
                    final tile = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Opacity(
                            opacity: unlocked ? 1 : 0.4,
                            child: SizedBox(
                              width: 34,
                              height: 34,
                              child: resourceIconAsset(type.assetPath, size: 34),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Opacity(
                              opacity: unlocked ? 1 : 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    type.label,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Text(
                                    '${stockpile[type] ?? 0} / $storageCap',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!unlocked)
                            Icon(Icons.lock, size: 16, color: scheme.onSurfaceVariant),
                        ],
                      ),
                    );
                    if (unlocked) return tile;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showLockedInfo(context, type),
                        child: tile,
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Produkcja i zużycie surowców (tygodniowo)',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          ResourceFlowTable(
            production: weeklyProduction,
            consumption: weeklyConsumption,
            productionSources: weeklyProductionSources,
            consumptionSources: weeklyConsumptionSources,
          ),
        ],
      ),
    );
  }
}
