import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/unit_type.dart';
import '../services/app_locale.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.statsTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _StatCard(
            icon: Icons.star,
            label: l10n.statsXpLabel,
            value: l10n.statsXpValue(xp),
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.all_inclusive,
            label: l10n.statsTotalCollectedLabel,
            value: '${stats.totalCollected}',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.timeline,
            label: l10n.statsLongestPathLabel,
            value: l10n.statsLongestPathValue(stats.longestPath),
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.bolt,
            label: l10n.statsMaxSingleHarvestLabel,
            value: '${stats.maxSingleHarvest}',
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.groups,
            label: l10n.statsPopulationLabel,
            value: '$population / $populationLimit',
            description: l10n.statsPopulationDescription,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.sentiment_satisfied,
            label: l10n.statsMoraleLabel,
            value: '${morale.toStringAsFixed(1)}%',
            description: l10n.statsMoraleDescription,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.security,
            label: l10n.statsSecurityLabel,
            value: '$security',
            description: l10n.statsSecurityDescription,
          ),
          const SizedBox(height: 12),
          _StatCard(
            icon: Icons.shield,
            label: l10n.statsSoldiersLabel,
            value: '${stats.totalSoldierCount} ($armyStrength)',
            description: l10n.statsSoldiersDescription,
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
          const SizedBox(height: 12),
          const _LanguageCard(),
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
    final l10n = AppLocalizations.of(context)!;
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
                    Text(l10n.statsComicsLabel, style: Theme.of(context).textTheme.labelMedium),
                    Text(
                      unreadCount > 0 ? l10n.statsComicsUnread(unreadCount) : l10n.statsComicsAllRead,
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
    final l10n = AppLocalizations.of(context)!;
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
              Text(l10n.statsBoardStyleLabel, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<BoardStyle>(
            segments: [
              ButtonSegment(
                value: BoardStyle.photo,
                label: Text(l10n.statsBoardStyleNew),
                icon: const Icon(Icons.image),
              ),
              ButtonSegment(
                value: BoardStyle.classic,
                label: Text(l10n.statsBoardStyleOld),
                icon: const Icon(Icons.gradient),
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
    final l10n = AppLocalizations.of(context)!;
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
              Text(l10n.statsIconStyleLabel, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<ResourceIconStyle>(
            segments: [
              ButtonSegment(
                value: ResourceIconStyle.orb,
                label: Text(l10n.statsIconStyleNew),
                icon: const Icon(Icons.blur_circular),
              ),
              ButtonSegment(
                value: ResourceIconStyle.filled,
                label: Text(l10n.statsIconStyleMid),
                icon: const Icon(Icons.circle),
              ),
              ButtonSegment(
                value: ResourceIconStyle.classic,
                label: Text(l10n.statsIconStyleOld),
                icon: const Icon(Icons.category),
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

/// Przełącznik języka gry (PL/EN) - w przeciwieństwie do `_BoardStyleCard`/
/// `_ResourceIconStyleCard` nie dostaje stanu przez propsy z `HomeShell`,
/// tylko czyta i zapisuje globalny singleton `AppLocale` bezpośrednio - to on
/// (nie ten widget) jest źródłem prawdy, żeby ten sam wybór języka mogły
/// czytać też miejsca bez `BuildContext` (patrz `AppLocale`).
class _LanguageCard extends StatelessWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Locale>(
      valueListenable: AppLocale.instance,
      builder: (context, locale, _) {
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
                  Icon(Icons.language, size: 30, color: scheme.primary),
                  const SizedBox(width: 14),
                  Text(l10n.statsLanguageLabel, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'pl', label: Text(l10n.statsLanguagePolish)),
                  ButtonSegment(value: 'en', label: Text(l10n.statsLanguageEnglish)),
                ],
                selected: {locale.languageCode},
                onSelectionChanged: (selection) => AppLocale.instance.set(Locale(selection.first)),
              ),
            ],
          ),
        );
      },
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
