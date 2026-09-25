import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/resource_type.dart';
import 'resource_icon.dart';

/// Jedna pozycja w oknie "co można teraz zbudować" - okolica albo budynek
/// wioski, którego wymagania (poprzednik w łańcuchu Okolic / Ratusz) są już
/// spełnione, ale który nie jest jeszcze zbudowany.
class BuildableOverviewEntry {
  final String title;
  final Widget icon;
  final Map<ResourceType, int> cost;

  const BuildableOverviewEntry({required this.title, required this.icon, required this.cost});
}

/// Pokazuje podgląd wszystkiego, co można teraz zbudować (Okolice + Wioska)
/// razem z kosztem i porównaniem do bieżącego magazynu - żeby w trakcie
/// zbierania surowców wiedzieć, czego jeszcze brakuje. Dostępne tylko z
/// planszy zwykłych, cotygodniowych zbiorów (HarvestScreen) - nie z ekranów
/// zarządzania wioską ani ze starć z bossami, tam plansza ma zupełnie inny,
/// doraźny cel.
void showBuildableOverviewSheet(
  BuildContext context, {
  required List<BuildableOverviewEntry> areaEntries,
  required List<BuildableOverviewEntry> buildingEntries,
  required Map<ResourceType, int> stockpile,
}) {
  final l10n = AppLocalizations.of(context)!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (context, scrollController) {
          final sections = <Widget>[];
          if (areaEntries.isNotEmpty) {
            sections.add(_SectionHeader(l10n.buildOverviewAreasSection));
            sections.addAll(
                areaEntries.map((entry) => _BuildableRow(entry: entry, stockpile: stockpile)));
          }
          if (buildingEntries.isNotEmpty) {
            sections.add(_SectionHeader(l10n.buildOverviewBuildingsSection));
            sections.addAll(
                buildingEntries.map((entry) => _BuildableRow(entry: entry, stockpile: stockpile)));
          }
          if (sections.isEmpty) {
            sections.add(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.buildOverviewEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }
          return ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(l10n.buildOverviewTitle, style: Theme.of(context).textTheme.titleLarge),
              ),
              ...sections,
            ],
          );
        },
      );
    },
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _BuildableRow extends StatelessWidget {
  final BuildableOverviewEntry entry;
  final Map<ResourceType, int> stockpile;

  const _BuildableRow({required this.entry, required this.stockpile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 28, height: 28, child: entry.icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    for (final costEntry in entry.cost.entries)
                      _CostChip(
                        type: costEntry.key,
                        need: costEntry.value,
                        have: stockpile[costEntry.key] ?? 0,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CostChip extends StatelessWidget {
  final ResourceType type;
  final int need;
  final int have;

  const _CostChip({required this.type, required this.need, required this.have});

  @override
  Widget build(BuildContext context) {
    final enough = have >= need;
    final color = enough ? const Color(0xFF2F9E57) : const Color(0xFFC0392B);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 16, height: 16, child: resourceIconAsset(type.assetPath, size: 16)),
        const SizedBox(width: 4),
        Text(
          '$have/$need',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
