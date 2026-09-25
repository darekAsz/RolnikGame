import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// Ekran zakończenia gry - pokazywany raz, zaraz po pomyślnym rozstrzygnięciu
/// Aktu V (tydzień 65, ostatni akt fabuły), po komiksie #30. Który z trzech
/// wariantów epilogu się pojawia zależy od tego, jak przebiegła cała
/// rozgrywka (patrz _score) - to jedyny etap fabuły, który się rozgałęzia,
/// bo w przeciwieństwie do poprzednich aktów nie ma tu dalszego starcia,
/// które mogłoby ocenić wynik za gracza.
class EndingScreen extends StatelessWidget {
  final int population;
  final int populationLimit;
  final double morale;
  // Starcie z Grotem (Akt I) - jedyny wcześniejszy boss fight, który NIE jest
  // wymuszony na "pełny wynik" przez sam fakt dotarcia do tego ekranu (Marta
  // i Bogdan muszą być rozstrzygnięci bezbłędnie, żeby w ogóle odblokować
  // questy poboczne wymagane w Akcie V - więc tylko Grot niesie realną
  // wariancję jako sygnał jakości przejścia).
  final int bossBattleStagesCleared;
  final bool everStarved;
  final int optionalSideQuestsClaimed;
  final int optionalSideQuestsTotal;
  final int totalSideQuestsClaimed;
  final int totalSideQuestsCount;

  const EndingScreen({
    super.key,
    required this.population,
    required this.populationLimit,
    required this.morale,
    required this.bossBattleStagesCleared,
    required this.everStarved,
    required this.optionalSideQuestsClaimed,
    required this.optionalSideQuestsTotal,
    required this.totalSideQuestsClaimed,
    required this.totalSideQuestsCount,
  });

  int get _score {
    var score = 0;
    if (bossBattleStagesCleared >= 3) score++;
    if (!everStarved) score++;
    if (optionalSideQuestsClaimed >= (optionalSideQuestsTotal * 0.6).ceil()) score++;
    if (morale >= 70) score++;
    return score;
  }

  _EndingTier get _tier {
    if (_score >= 3) return _EndingTier.golden;
    if (_score >= 1) return _EndingTier.hardWon;
    return _EndingTier.scarred;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tier = _tier;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1410),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              children: [
                Icon(Icons.auto_awesome, color: tier.color, size: 52),
                const SizedBox(height: 12),
                Text(
                  l10n.endingTitle,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: tier.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: tier.color),
                  ),
                  child: Text(
                    tier.label(l10n),
                    style: TextStyle(color: tier.color, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset('assets/ui/${tier.imageKey}.webp', fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          tier.epilogue(l10n),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _StatsCard(
                          population: population,
                          populationLimit: populationLimit,
                          morale: morale,
                          bossBattleStagesCleared: bossBattleStagesCleared,
                          everStarved: everStarved,
                          totalSideQuestsClaimed: totalSideQuestsClaimed,
                          totalSideQuestsCount: totalSideQuestsCount,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: tier.color,
                      foregroundColor: const Color(0xFF1A1410),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(l10n.endingContinue, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int population;
  final int populationLimit;
  final double morale;
  final int bossBattleStagesCleared;
  final bool everStarved;
  final int totalSideQuestsClaimed;
  final int totalSideQuestsCount;

  const _StatsCard({
    required this.population,
    required this.populationLimit,
    required this.morale,
    required this.bossBattleStagesCleared,
    required this.everStarved,
    required this.totalSideQuestsClaimed,
    required this.totalSideQuestsCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.endingStatsCardTitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          _StatRow(
            icon: Icons.groups,
            label: l10n.endingStatPopulationLabel,
            value: l10n.endingStatPopulationValue(population, populationLimit),
          ),
          _StatRow(
            icon: Icons.mood,
            label: l10n.endingStatMoraleLabel,
            value: l10n.endingStatMoraleValue(morale.round()),
          ),
          _StatRow(
            icon: Icons.shield_moon,
            label: l10n.endingStatGrotLabel,
            value: l10n.endingStatGrotValue(bossBattleStagesCleared),
          ),
          _StatRow(
            icon: Icons.checklist,
            label: l10n.endingStatSideQuestsLabel,
            value: l10n.endingStatSideQuestsValue(totalSideQuestsClaimed, totalSideQuestsCount),
          ),
          _StatRow(
            icon: everStarved ? Icons.warning_amber : Icons.eco,
            label: l10n.endingStatHungerLabel,
            value: everStarved ? l10n.endingStatHungerYes : l10n.endingStatHungerNo,
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

enum _EndingTier {
  golden(color: Color(0xFFD4AF37), imageKey: 'ending_golden'),
  hardWon(color: Color(0xFF6E9B7A), imageKey: 'ending_hardwon'),
  scarred(color: Color(0xFF8C8377), imageKey: 'ending_scarred');

  final Color color;
  final String imageKey;

  const _EndingTier({required this.color, required this.imageKey});

  String label(AppLocalizations l10n) {
    switch (this) {
      case _EndingTier.golden:
        return l10n.endingTierGoldenLabel;
      case _EndingTier.hardWon:
        return l10n.endingTierHardWonLabel;
      case _EndingTier.scarred:
        return l10n.endingTierScarredLabel;
    }
  }

  String epilogue(AppLocalizations l10n) {
    switch (this) {
      case _EndingTier.golden:
        return l10n.endingTierGoldenEpilogue;
      case _EndingTier.hardWon:
        return l10n.endingTierHardWonEpilogue;
      case _EndingTier.scarred:
        return l10n.endingTierScarredEpilogue;
    }
  }
}
