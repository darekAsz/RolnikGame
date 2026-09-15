import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/resource_type.dart';
import 'resource_icon.dart';

/// Tabela "produkcja / zużycie / netto na tydzień" dla każdego surowca -
/// współdzielona przez StatsView i ResourcesView, żeby liczby wyglądały tak
/// samo w obu miejscach. Każdy wiersz można rozwinąć, żeby zobaczyć, co
/// dokładnie dany surowiec produkuje i zużywa (który budynek/kto).
class ResourceFlowTable extends StatelessWidget {
  final Map<ResourceType, int> production;
  final Map<ResourceType, int> consumption;
  final Map<ResourceType, List<(String, int)>> productionSources;
  final Map<ResourceType, List<(String, int)>> consumptionSources;

  const ResourceFlowTable({
    super.key,
    required this.production,
    required this.consumption,
    this.productionSources = const {},
    this.consumptionSources = const {},
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final type in ResourceType.values)
        if ((production[type] ?? 0) != 0 || (consumption[type] ?? 0) != 0) type,
    ];

    if (rows.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(l10n.resourceFlowEmptyState),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          children: [
            for (final type in rows) ...[
              _ResourceFlowRow(
                type: type,
                production: production[type] ?? 0,
                consumption: consumption[type] ?? 0,
                productionSources: productionSources[type] ?? const [],
                consumptionSources: consumptionSources[type] ?? const [],
              ),
              if (type != rows.last) const Divider(height: 1, indent: 8, endIndent: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResourceFlowRow extends StatelessWidget {
  final ResourceType type;
  final int production;
  final int consumption;
  final List<(String, int)> productionSources;
  final List<(String, int)> consumptionSources;

  const _ResourceFlowRow({
    required this.type,
    required this.production,
    required this.consumption,
    this.productionSources = const [],
    this.consumptionSources = const [],
  });

  Color _netColor(BuildContext context, int net) => net > 0
      ? const Color(0xFF2E7D32)
      : net < 0
          ? const Color(0xFFC0392B)
          : Theme.of(context).colorScheme.onSurfaceVariant;

  Widget _header(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final net = production - consumption;
    final netText = '${net >= 0 ? '+' : ''}$net';
    return Row(
      children: [
        SizedBox(width: 22, height: 22, child: resourceIconAsset(type.assetPath, size: 22)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(type.label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        if (production > 0)
          Text('+$production', style: const TextStyle(color: Color(0xFF2E7D32))),
        if (production > 0 && consumption > 0) const SizedBox(width: 8),
        if (consumption > 0)
          Text('-$consumption', style: const TextStyle(color: Color(0xFFC0392B))),
        const SizedBox(width: 12),
        Text(
          '= ${l10n.resourceFlowNetPerWeek(netText)}',
          style: TextStyle(color: _netColor(context, net), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasBreakdown = productionSources.isNotEmpty || consumptionSources.isNotEmpty;
    if (!hasBreakdown) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: _header(context),
      );
    }

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      childrenPadding: const EdgeInsets.only(left: 40, right: 12, bottom: 10),
      title: _header(context),
      children: [
        for (final source in productionSources)
          _SourceLine(label: source.$1, amount: source.$2, positive: true),
        for (final source in consumptionSources)
          _SourceLine(label: source.$1, amount: source.$2, positive: false),
      ],
    );
  }
}

class _SourceLine extends StatelessWidget {
  final String label;
  final int amount;
  final bool positive;

  const _SourceLine({required this.label, required this.amount, required this.positive});

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF2E7D32) : const Color(0xFFC0392B);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Text(
            '${positive ? '+' : '-'}$amount',
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
