import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Debug', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Narzędzia testowe - nie są częścią normalnej rozgrywki.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Text('Przejdź do tygodnia', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weekController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitWeek(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numer tygodnia (1-65)',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _submitWeek,
                child: const Text('Przejdź'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Dodaj surowce', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonal(
                onPressed: widget.onAddAllResources,
                child: const Text('+100 wszystkich'),
              ),
              for (final type in ResourceType.values)
                if (!kBattleOnlyResourceTypes.contains(type))
                  OutlinedButton(
                    onPressed: () => widget.onAddResource(type),
                    child: Text('+100 ${type.label.toLowerCase()}'),
                  ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Walka treningowa z bossem', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Uruchamia starcie od razu, z aktualnymi statystykami wioski - wynik NIE jest '
            'zapisywany ani nie wpływa na fabułę/surowce.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(onPressed: widget.onFightGrot, child: const Text('Grot (tydz. 26)')),
              OutlinedButton(onPressed: widget.onFightMarta, child: const Text('Marta (tydz. 39)')),
              OutlinedButton(onPressed: widget.onFightBogdan, child: const Text('Bogdan (tydz. 52)')),
              OutlinedButton(onPressed: widget.onFightLeszy, child: const Text('Leszy (tydz. 59)')),
            ],
          ),
        ],
      ),
    );
  }
}
