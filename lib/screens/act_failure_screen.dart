import 'package:flutter/material.dart';

/// Ekran porażki na koniec aktu - cel główny danego aktu nie został
/// osiągnięty na czas. W odróżnieniu od dawnego "miękkiego" systemu kar
/// (gra leciała dalej z gorszymi surowcami), to jest prawdziwy koniec
/// bieżącej próby - jedyne wyjście to wczytać zapis z wcześniejszego
/// tygodnia (patrz CheckpointStorage) albo zacząć od nowa.
///
/// Zwraca przez Navigator.pop: numer tygodnia do wczytania, albo -1, jeśli
/// gracz wybrał "Zacznij nową grę".
class ActFailureScreen extends StatelessWidget {
  final int actNumber;
  final String actName;
  final String flavorText;
  final List<int> checkpointWeeks;

  const ActFailureScreen({
    super.key,
    required this.actNumber,
    required this.actName,
    required this.flavorText,
    required this.checkpointWeeks,
  });

  @override
  Widget build(BuildContext context) {
    final sortedWeeks = [...checkpointWeeks]..sort((a, b) => b.compareTo(a));
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1410),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Icon(Icons.close_rounded, color: Color(0xFFC0392B), size: 56),
                const SizedBox(height: 12),
                Text(
                  'Porażka',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Akt $actNumber: "$actName" się nie powiódł.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  flavorText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white60),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Wczytaj zapis i spróbuj ponownie',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: sortedWeeks.isEmpty
                      ? Center(
                          child: Text(
                            'Brak zapisanych tygodni.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
                          ),
                        )
                      : ListView.separated(
                          itemCount: sortedWeeks.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final week = sortedWeeks[index];
                            return Material(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                              child: ListTile(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                leading: const Icon(Icons.restore, color: Colors.white70),
                                title: Text('Tydzień $week', style: const TextStyle(color: Colors.white)),
                                onTap: () => Navigator.of(context).pop(week),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white30),
                    ),
                    onPressed: () => Navigator.of(context).pop(-1),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('Zacznij nową grę'),
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
