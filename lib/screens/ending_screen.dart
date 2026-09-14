import 'package:flutter/material.dart';

/// Ekran zakończenia gry - pokazywany raz, zaraz po pomyślnym rozstrzygnięciu
/// Aktu V (tydzień 65, ostatni akt fabuły), po komiksie #30. Który z trzech
/// wariantów epilogu się pojawia zależy od tego, jak przebiegła cała
/// rozgrywka (patrz _score) - to jedyny etap fabuły, który się rozgałęzia,
/// bo w przeciwieństwie do poprzednich aktów nie ma tu dalszego starcia,
/// które mogłoby ocenić wynik za gracza.
class EndingScreen extends StatelessWidget {
  final int xp;
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
    required this.xp,
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
                  'Koniec Roku Pierwszego',
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
                    tier.label,
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
                          tier.epilogue,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _StatsCard(
                          xp: xp,
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Kontynuuj', style: TextStyle(fontWeight: FontWeight.bold)),
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
  final int xp;
  final int population;
  final int populationLimit;
  final double morale;
  final int bossBattleStagesCleared;
  final bool everStarved;
  final int totalSideQuestsClaimed;
  final int totalSideQuestsCount;

  const _StatsCard({
    required this.xp,
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
            'Rok Pierwszy w liczbach',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          _StatRow(icon: Icons.groups, label: 'Populacja', value: '$population / $populationLimit'),
          _StatRow(icon: Icons.mood, label: 'Morale wioski', value: '${morale.round()}%'),
          _StatRow(icon: Icons.military_tech, label: 'Zdobyte doświadczenie', value: '$xp XP'),
          _StatRow(
            icon: Icons.shield_moon,
            label: 'Starcie z Grotem',
            value: '$bossBattleStagesCleared / 3 etapów',
          ),
          _StatRow(
            icon: Icons.checklist,
            label: 'Questy poboczne',
            value: '$totalSideQuestsClaimed / $totalSideQuestsCount',
          ),
          _StatRow(
            icon: everStarved ? Icons.warning_amber : Icons.eco,
            label: 'Głód',
            value: everStarved ? 'Wioska go zaznała' : 'Nigdy nie nawiedził wioski',
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
  golden(
    label: 'Złoty wiek',
    color: Color(0xFFD4AF37),
    imageKey: 'ending_golden',
    epilogue:
        'Wioska tętni życiem jak nigdy dotąd. Spichlerze pełne, mury mocne, a ludzie nie boją się '
        'już zmierzchu. Kazimierz spłacił dług, którego sam nie zaciągnął - i zrobił to z nawiązką, '
        'zamieniając brzemię dziadka w fundament czegoś trwałego. Marta zostaje - nie jako wróg, nie '
        'z konieczności, ale jako ktoś, kto wreszcie znalazł dom po drugiej stronie granicy, która '
        'przestała cokolwiek dzielić.',
  ),
  hardWon(
    label: 'Trudne zwycięstwo',
    color: Color(0xFF6E9B7A),
    imageKey: 'ending_hardwon',
    epilogue:
        'Wioska przetrwała - poobijana, zmęczona, ale wciąż stoi. Nie wszystko poszło gładko: były '
        'noce niedostatku i starcia, których wynik ważył się na włosku. Ale dług został spłacony, a '
        'Marta i Jadwiga stoją dziś obok Kazimierza jako rodzina, którą sam sobie wybrał - nie tę, '
        'którą odziedziczył.',
  ),
  scarred(
    label: 'Blizny, które zostają',
    color: Color(0xFF8C8377),
    imageKey: 'ending_scarred',
    epilogue:
        'Zwycięstwo smakuje gorzko. Wioska stoi, dług spłacony, Leszy pokonany - ale cena była '
        'wysoka: głodne noce, puste spichlerze, sąsiedzi patrzący na Kazimierza inaczej niż kiedyś na '
        'Antoniego. Marta zostaje przy nim, a on sam zaczyna rozumieć, dlaczego dziadek dźwigał tę '
        'tajemnicę w milczeniu przez dwadzieścia lat - nie każde zwycięstwo da się świętować.',
  );

  final String label;
  final Color color;
  final String imageKey;
  final String epilogue;

  const _EndingTier({required this.label, required this.color, required this.imageKey, required this.epilogue});
}
