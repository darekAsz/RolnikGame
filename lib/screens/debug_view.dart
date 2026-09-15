import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/resource_type.dart';

/// Narzędzia testowe - nie są częścią normalnej rozgrywki. Pozwala szybko
/// przeskoczyć do dowolnego tygodnia (np. żeby przetestować starcie z
/// bossem albo dany akt fabuły) oraz doładować surowce bez grania na
/// planszy zbiorów.
class DebugView extends StatefulWidget {
  final int currentWeek;
  final ValueChanged<int> onJumpToWeek;
  final ValueChanged<ResourceType> onAddResource;
  final VoidCallback onAddAllResources;
  final VoidCallback onFightGrot;
  final VoidCallback onFightMarta;
  final VoidCallback onFightBogdan;
  final VoidCallback onFightLeszy;

  const DebugView({
    super.key,
    required this.currentWeek,
    required this.onJumpToWeek,
    required this.onAddResource,
    required this.onAddAllResources,
    required this.onFightGrot,
    required this.onFightMarta,
    required this.onFightBogdan,
    required this.onFightLeszy,
  });

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  late final _weekController = TextEditingController(text: '${widget.currentWeek}');

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  void _submitWeek() {
    final week = int.tryParse(_weekController.text);
    if (week != null && week >= 1) {
      widget.onJumpToWeek(week);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.debugTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            l10n.debugSubtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Text(l10n.debugJumpToWeekHeader, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weekController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitWeek(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: l10n.debugWeekNumberLabel,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _submitWeek,
                child: Text(l10n.debugJumpButton),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.debugAddResourcesHeader, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: widget.onAddAllResources,
                child: Text(l10n.debugAddAllButton),
              ),
              for (final type in ResourceType.values)
                if (!kBattleOnlyResourceTypes.contains(type))
                  OutlinedButton(
                    onPressed: () => widget.onAddResource(type),
                    child: Text(l10n.debugAddResourceButton(type.label.toLowerCase())),
                  ),
            ],
          ),
          const SizedBox(height: 24),
          Text(l10n.debugBossTrainingHeader, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            l10n.debugBossTrainingDescription,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(onPressed: widget.onFightGrot, child: Text(l10n.debugFightGrot)),
              OutlinedButton(onPressed: widget.onFightMarta, child: Text(l10n.debugFightMarta)),
              OutlinedButton(onPressed: widget.onFightBogdan, child: Text(l10n.debugFightBogdan)),
              OutlinedButton(onPressed: widget.onFightLeszy, child: Text(l10n.debugFightLeszy)),
            ],
          ),
        ],
      ),
    );
  }
}
