import 'package:flutter/material.dart';

import '../models/unit_type.dart';
import '../services/board_style_storage.dart';
import '../services/resource_icon_style_storage.dart';
import '../services/stats_storage.dart';
import '../widgets/unit_portrait.dart';

/// Pełnoekranowy widok statystyk gracza.
class StatsView extends StatelessWidget {
  final GameStats stats;
  final int population;
  final int populationLimit;
  final double morale;
  final int security;
  final Map<UnitType, int> soldierCounts;
  final int armyStrength;
  final int comicsUnreadCount;
  final VoidCallback? onOpenComics;
  final int xp;
  final BoardStyle boardStyle;
  final ValueChanged<BoardStyle>? onBoardStyleChanged;
  final ResourceIconStyle resourceIconStyle;
  final ValueChanged<ResourceIconStyle>? onResourceIconStyleChanged;

  const StatsView({
    super.key,
    required this.stats,
    this.population = 0,
    required this.populationLimit,
    required this.morale,
    this.security = 0,
    this.soldierCounts = const {},
    this.armyStrength = 0,
    this.comicsUnreadCount = 0,
    this.onOpenComics,
    this.xp = 0,
    this.boardStyle = BoardStyle.photo,
    this.onBoardStyleChanged,
    this.resourceIconStyle = ResourceIconStyle.orb,
    this.onResourceIconStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statystyki', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _StatCard(
            icon: Icons.star,
            label: 'Doświadczenie',
            value: '$xp XP',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.all_inclusive,
            label: 'Łącznie zebrane surowce',
            value: '${stats.totalCollected}',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.timeline,
            label: 'Najdłuższa ścieżka',
            value: '${stats.longestPath} kafelków',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.bolt,
            label: 'Najwięcej zebrane naraz',
            value: '${stats.maxSingleHarvest}',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.groups,
            label: 'Populacja',
            value: '$population / $populationLimit',
            description: 'Ogranicza, ilu mieszkańców można zwerbować jako żołnierzy albo '
                'przydzielić jako pracowników do budynków.',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.sentiment_satisfied,
            label: 'Morale wioski',
            value: '${morale.toStringAsFixed(1)}%',
            description: 'Im wyższe, tym więcej pozytywnych (a mniej negatywnych) wydarzeń '
                'tygodniowych. Wysokie morale ułatwia też niektóre walki z bossami.',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.security,
            label: 'Bezpieczeństwo wioski',
            value: '$security',
            description: 'Podnosi PŻ Wioski w finałowym starciu (do +40) i ułatwia niektóre '
                'walki z bossami.',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.shield,
            label: 'Żołnierze (siła armii)',
            value: '${stats.totalSoldierCount} ($armyStrength)',
            description: 'Liczba żołnierzy i siła armii (uwzględnia bonus Koszar poziom 2) '
                'ułatwiają niektóre walki z bossami.',
          ),
          if (stats.totalSoldierCount > 0) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                for (final type in UnitType.values)
                  if ((soldierCounts[type] ?? 0) > 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UnitPortrait(type: type, size: 28),
                        const SizedBox(width: 4),
                        Text(
                          '${type.label}: ${soldierCounts[type]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
              ],
            ),
          ],
          if (onOpenComics != null) ...[
            const SizedBox(height: 12),
            _ComicsCard(unreadCount: comicsUnreadCount, onTap: onOpenComics!),
          ],
          if (onBoardStyleChanged != null) ...[
            const SizedBox(height: 12),
            _BoardStyleCard(value: boardStyle, onChanged: onBoardStyleChanged!),
          ],
          if (onResourceIconStyleChanged != null) ...[
            const SizedBox(height: 12),
            _ResourceIconStyleCard(value: resourceIconStyle, onChanged: onResourceIconStyleChanged!),
          ],
        ],
      ),
    );
  }
}

class _ComicsCard extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const _ComicsCard({required this.unreadCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(Icons.auto_stories, size: 30, color: scheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Komiksy', style: Theme.of(context).textTheme.labelMedium),
                    Text(
                      unreadCount > 0 ? '$unreadCount nieprzeczytanych' : 'Wszystko przeczytane',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: scheme.error,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$unreadCount',
                    style: TextStyle(color: scheme.onError, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                )
              else
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardStyleCard extends StatelessWidget {
  final BoardStyle value;
  final ValueChanged<BoardStyle> onChanged;

  const _BoardStyleCard({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.grid_view, size: 30, color: scheme.primary),
              const SizedBox(width: 14),
              Text('Wygląd planszy', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<BoardStyle>(
            segments: const [
              ButtonSegment(
                value: BoardStyle.photo,
                label: Text('Nowy'),
                icon: Icon(Icons.image),
              ),
              ButtonSegment(
                value: BoardStyle.classic,
                label: Text('Starszy'),
                icon: Icon(Icons.gradient),
              ),
            ],
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

class _ResourceIconStyleCard extends StatelessWidget {
  final ResourceIconStyle value;
  final ValueChanged<ResourceIconStyle> onChanged;

  const _ResourceIconStyleCard({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 30, color: scheme.primary),
              const SizedBox(width: 14),
              Text('Wygląd ikon surowców', style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<ResourceIconStyle>(
            segments: const [
              ButtonSegment(
                value: ResourceIconStyle.orb,
                label: Text('Nowe'),
                icon: Icon(Icons.blur_circular),
              ),
              ButtonSegment(
                value: ResourceIconStyle.filled,
                label: Text('Pośrednie'),
                icon: Icon(Icons.circle),
              ),
              ButtonSegment(
                value: ResourceIconStyle.classic,
                label: Text('Starsze'),
                icon: Icon(Icons.category),
              ),
            ],
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? description;

  const _StatCard({required this.icon, required this.label, required this.value, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
