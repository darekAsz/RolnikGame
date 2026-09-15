import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../services/game_progress_storage.dart';
import 'home_shell.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  static List<(IconData, String, String)> _steps(AppLocalizations l10n) => [
        (Icons.touch_app, l10n.tutorialStep1Title, l10n.tutorialStep1Description),
        (Icons.style, l10n.tutorialStep2Title, l10n.tutorialStep2Description),
        (Icons.whatshot, l10n.tutorialStep3Title, l10n.tutorialStep3Description),
        (Icons.home_work, l10n.tutorialStep4Title, l10n.tutorialStep4Description),
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
    final l10n = AppLocalizations.of(context)!;
    final steps = _steps(l10n);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tutorialAppBarTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: steps.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    final (icon, title, description) = steps[index];
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(l10n.tutorialFinishButton),
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
