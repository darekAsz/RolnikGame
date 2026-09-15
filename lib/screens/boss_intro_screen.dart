import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// Plansza ostrzegawcza pokazywana tuż przed każdym starciem z bossem,
/// zaraz po WeekTransitionScreen - zamiast wchodzić w walkę bez zapowiedzi,
/// gracz najpierw widzi krótki komunikat "coś/ktoś się zbliża, przygotuj
/// się" i sam decyduje, kiedy rozpocząć starcie (w przeciwieństwie do
/// WeekTransitionScreen ta plansza NIE znika sama).
class BossIntroScreen extends StatelessWidget {
  final String bossName;
  final String message;
  final int week;
  // Klucz portretu w assets/ui/boss_$portraitKey.webp (grot/marta/bogdan/leszy)
  // - null dla starć bez własnego portretu (na razie żadne, ale zostaje
  // opcjonalne, żeby ekran nie wywalał się na przyszły boss bez grafiki).
  final String? portraitKey;

  const BossIntroScreen({
    super.key,
    required this.bossName,
    required this.message,
    required this.week,
    this.portraitKey,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF1A1410),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (portraitKey != null)
            Image.asset('assets/ui/boss_$portraitKey.webp', fit: BoxFit.cover),
          if (portraitKey != null)
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x991A1410), Color(0x331A1410), Color(0xF21A1410)],
                  stops: [0.0, 0.4, 0.85],
                ),
              ),
            ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (portraitKey == null) ...[
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFD4A017), size: 56),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      l10n.bossIntroWeekLabel(week),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bossName,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        child: Text(l10n.bossIntroPrepareButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
