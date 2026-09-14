import 'package:flutter/material.dart';

import '../services/game_progress_storage.dart';
import 'home_shell.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  static const _steps = [
    (
      Icons.touch_app,
      'Łącz surowce',
      'Przeciągnij palcem po sąsiadujących kafelkach tego samego surowca '
          '(również po skosie), żeby je zebrać.',
    ),
    (
      Icons.style,
      'Dziki joker',
      'Za dłuższą ścieżkę (5 i więcej kafelków) dostajesz jokera - łączy się '
          'z każdym surowcem i mnoży zbiory.',
    ),
    (
      Icons.whatshot,
      'Bomba',
      'Za jeszcze dłuższą ścieżkę (6 i więcej) dostajesz bombę - włączona do '
          'ścieżki niszczy sąsiednie kafelki.',
    ),
    (
      Icons.home_work,
      'Rozbuduj wioskę',
      'Zebrane surowce zostają w wiosce między tygodniami - w przyszłości '
          'posłużą do jej rozbudowy.',
    ),
  ];

  Future<void> _finish(BuildContext context) async {
    await GameProgressStorage.markTutorialSeen();
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jak grać')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: _steps.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    final (icon, title, description) = _steps[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(description),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _finish(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Rozumiem, zaczynamy!'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
