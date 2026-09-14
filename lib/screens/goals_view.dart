import 'package:flutter/material.dart';

import '../models/goal_requirement.dart';
import '../models/side_quest.dart';
import '../models/story_act.dart';

/// Zakładka "Cele" - pokazuje bieżący tydzień/akt fabuły oraz cel główny
/// (z żywą listą wymagań i postępem), questy poboczne (z nagrodą w XP i
/// postępem, gdzie to ma sens) i kontekst fabularny dla aktualnego etapu
/// historii.
class GoalsView extends StatelessWidget {
  final int week;
  // Czy cel główny danego aktu (numer aktu jako argument) jest obecnie
  // spełniony - używane do pokazania bieżącego statusu przed rozstrzygnięciem
  // aktu na końcu jego ostatniego tygodnia.
  final bool Function(int actNumber)? goalMet;
  // Szczegółowa lista wymagań celu głównego danego aktu, z aktualnym
  // postępem - patrz HomeShell._actGoalRequirements.
  final List<GoalRequirement> Function(int actNumber)? goalRequirements;
  final Set<SideQuestId> claimedSideQuests;
  // Opcjonalny tekst postępu questa pobocznego (np. "62/70 morale") - null,
  // gdy warunek jest zero-jedynkowy i sama ikonka statusu wystarcza.
  final String? Function(SideQuestId id)? sideQuestProgress;
  // Akty, których cel główny został już rozstrzygnięty jako sukces - pokazane
  // osobno jako historia ukończonych celów, nie tylko bieżący akt.
  final Set<int> resolvedActs;

  const GoalsView({
    super.key,
    required this.week,
    this.goalMet,
    this.goalRequirements,
    this.claimedSideQuests = const {},
    this.sideQuestProgress,
    this.resolvedActs = const {},
  });

  @override
  Widget build(BuildContext context) {
    final act = storyActForWeek(week);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cele', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            act == null ? 'Tydzień $week' : 'Tydzień $week — Akt ${act.actNumber}: ${act.actName}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          if (act == null)
            const Expanded(
              child: Center(
                child: Text(
                  'Historia dobiegła końca. Wioska żyje dalej własnym tempem.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  _GoalCard(
                    icon: Icons.flag,
                    label: 'Cel główny',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Wszystkie etapy odblokowane do tej pory w tym akcie
                        // naraz, nie tylko najnowszy - np. gdy Antoni umiera
                        // w tygodniu 7, gracz nadal ma widzieć etap "naucz
                        // się gospodarki" obok nowego "zorganizuj pogrzeb",
                        // bo oba są nadal wymagane razem na koniec aktu.
                        for (final milestone in act.milestones.where((m) => m.fromWeek <= week))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  milestone.goal,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 3),
                                Text(milestone.flavor, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        if (goalRequirements != null) ...[
                          const SizedBox(height: 4),
                          Text('Warunki', style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 6),
                          for (final req in goalRequirements!(act.actNumber))
                            _RequirementRow(requirement: req),
                        ],
                        if (goalMet != null) ...[
                          const SizedBox(height: 8),
                          _GoalStatusChip(met: goalMet!(act.actNumber), endWeek: act.endWeek),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GoalCard(
                    icon: Icons.checklist,
                    label: 'Questy poboczne',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final quest in sideQuestsForAct(act.actNumber))
                          _SideQuestRow(
                            quest: quest,
                            claimed: claimedSideQuests.contains(quest.id),
                            progress:
                                claimedSideQuests.contains(quest.id) ? null : sideQuestProgress?.call(quest.id),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GoalCard(
                    icon: Icons.menu_book,
                    label: 'Kontekst fabularny',
                    child: Text(act.context),
                  ),
                  if (resolvedActs.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _GoalCard(
                      icon: Icons.military_tech,
                      label: 'Ukończone cele',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final pastAct in kStoryActs.where((a) => resolvedActs.contains(a.actNumber)))
                            _ResolvedActRow(act: pastAct),
                        ],
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

class _RequirementRow extends StatelessWidget {
  final GoalRequirement requirement;

  const _RequirementRow({required this.requirement});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = requirement.met ? const Color(0xFF2F9E57) : scheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            requirement.met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  requirement.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color,
                        decoration: requirement.met ? TextDecoration.lineThrough : null,
                      ),
                ),
                if (requirement.progress != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    requirement.progress!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
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

class _ResolvedActRow extends StatelessWidget {
  final StoryAct act;

  const _ResolvedActRow({required this.act});

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF2F9E57);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Akt ${act.actNumber}: ${act.actName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideQuestRow extends StatelessWidget {
  final SideQuest quest;
  final bool claimed;
  final String? progress;

  const _SideQuestRow({required this.quest, required this.claimed, this.progress});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = claimed ? const Color(0xFF2F9E57) : scheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            claimed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${quest.title} (+${quest.xpReward} XP)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                        decoration: claimed ? TextDecoration.lineThrough : null,
                      ),
                ),
                Text(quest.description, style: Theme.of(context).textTheme.bodySmall),
                if (progress != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    progress!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          fontStyle: FontStyle.italic,
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

class _GoalStatusChip extends StatelessWidget {
  final bool met;
  final int endWeek;

  const _GoalStatusChip({required this.met, required this.endWeek});

  @override
  Widget build(BuildContext context) {
    final color = met ? const Color(0xFF2F9E57) : const Color(0xFFC0392B);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(met ? Icons.check_circle : Icons.error_outline, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                met ? 'Warunki spełnione już teraz' : 'Warunki jeszcze niespełnione',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        // Jawnie tłumaczy, że to sprawdzane dopiero na koniec aktu -
        // inaczej łatwo pomyśleć, że "niespełniony" znaczy porażkę już
        // teraz, albo że dotyczy tylko ostatnio wyświetlonego etapu (np.
        // samej Palisady, która tylko ułatwia starcie, a nie jest sama w
        // sobie warunkiem) zamiast całego, ostatecznego wymagania aktu.
        Text(
          'Powyższe warunki decydują o wyniku dopiero na koniec aktu (tydzień $endWeek).',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _GoalCard({required this.icon, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
