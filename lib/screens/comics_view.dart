import 'package:flutter/material.dart';

import '../models/comic.dart';

/// Zakładka "Komiksy" - lista odblokowanych (wg tygodnia) plansz fabularnych.
/// Na razie w wersji czysto tekstowej: każdy panel to opis kadru + dialogi.
class ComicsView extends StatelessWidget {
  final int week;
  final Set<int> readComics;
  final ValueChanged<int> onRead;
  // Komiksy odsłaniające wynik starcia z bossem (patrz
  // HomeShell._isComicRevealed) - mimo że tydzień już minął, nie powinny się
  // pojawić w tej liście, dopóki gracz faktycznie nie stoczył tej walki
  // (inaczej dałoby się poznać wynik z zakładki Komiksy, zanim w ogóle
  // wejdzie się w starcie).
  final Set<int> hiddenComicNumbers;

  const ComicsView({
    super.key,
    required this.week,
    required this.readComics,
    required this.onRead,
    this.hiddenComicNumbers = const {},
  });

  @override
  Widget build(BuildContext context) {
    final unlocked = comicsUnlockedThroughWeek(week)
        .where((c) => !hiddenComicNumbers.contains(c.number))
        .toList();
    final nextLocked = kComics.where((c) => c.week > week).firstOrNull;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Komiksy', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            '${unlocked.length} z ${kComics.length} odblokowanych',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: unlocked.isEmpty
                ? const Center(child: Text('Pierwszy komiks pojawi się już wkrótce.'))
                : ListView.separated(
                    itemCount: unlocked.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final comic = unlocked[index];
                      final isNew = !readComics.contains(comic.number);
                      return _ComicListTile(
                        comic: comic,
                        isNew: isNew,
                        onTap: () async {
                          onRead(comic.number);
                          if (!context.mounted) return;
                          await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ComicReaderScreen(comic: comic)),
                          );
                        },
                      );
                    },
                  ),
          ),
          if (nextLocked != null) ...[
            const SizedBox(height: 8),
            Text(
              'Kolejny komiks odblokuje się w tygodniu ${nextLocked.week}.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class _ComicListTile extends StatelessWidget {
  final Comic comic;
  final bool isNew;
  final VoidCallback onTap;

  const _ComicListTile({required this.comic, required this.isNew, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: scheme.primaryContainer,
                child: Text('${comic.number}', style: TextStyle(color: scheme.onPrimaryContainer)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comic.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      'Tydzień ${comic.week} · Akt ${comic.actNumber}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              if (isNew)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: scheme.error,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'NOWY',
                    style: TextStyle(
                      color: scheme.onError,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
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

class ComicReaderScreen extends StatefulWidget {
  final Comic comic;

  const ComicReaderScreen({super.key, required this.comic});

  @override
  State<ComicReaderScreen> createState() => _ComicReaderScreenState();
}

class _ComicReaderScreenState extends State<ComicReaderScreen> {
  final _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comic = widget.comic;
    // Strona 0 to plansza tytułowa (Akt / pora roku / tydzień), potem kolejno
    // wszystkie kadry komiksu - stąd +1 wszędzie, gdzie liczymy strony.
    final pageCount = comic.panels.length + 1;
    return Scaffold(
      appBar: AppBar(
        title: Text('#${comic.number} ${comic.title}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: pageCount,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, index) {
                if (index == 0) return _ActIntroTile(comic: comic);
                return _PanelTile(
                  panel: comic.panels[index - 1],
                  comicNumber: comic.number,
                  panelNumber: index,
                  panelCount: comic.panels.length,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < pageCount; i++)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _page
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  final isLast = _page == pageCount - 1;
                  if (isLast) {
                    Navigator.of(context).pop();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(_page == pageCount - 1 ? 'OK' : 'Dalej'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Plansza tytułowa wyświetlana jako pierwsza strona każdego komiksu -
/// pokazuje akt, porę roku i tydzień fabuły, w którym dzieje się historia.
class _ActIntroTile extends StatelessWidget {
  final Comic comic;

  const _ActIntroTile({required this.comic});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final actInfo = kComicActInfo[comic.actNumber];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (actInfo != null) ...[
              Text(
                actInfo.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                actInfo.season,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
            ],
            Text(
              'Tydzień ${comic.week}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              comic.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelTile extends StatelessWidget {
  final ComicPanel panel;
  final int comicNumber;
  final int panelNumber;
  final int panelCount;

  const _PanelTile({
    required this.panel,
    required this.comicNumber,
    required this.panelNumber,
    required this.panelCount,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final imagePath = 'assets/comics/${comicNumber}_$panelNumber.webp';
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kadr $panelNumber / $panelCount',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.cover,
              // Rysunek nie jest jeszcze gotowy dla każdego kadru - w takim
              // wypadku pokazujemy miejsce zastępcze, a opis kadru i tak
              // wyświetla się niżej jako podpis.
              errorBuilder: (context, error, stackTrace) => _MissingArtPlaceholder(scheme: scheme),
            ),
          ),
          if (panel.description != null) ...[
            const SizedBox(height: 10),
            Text(
              panel.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
          // Kontener z dialogami ma sens tylko wtedy, gdy panel faktycznie ma
          // jakieś kwestie - bez tego warunku puste panele (samo tło/opis,
          // bez dialogu) pokazywały pusty prostokąt z tłem i obwódką.
          if (panel.lines.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final line in panel.lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: '${line.speaker}: ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: scheme.primary),
                              ),
                              TextSpan(text: line.text),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Zastępuje grafikę kadru, dopóki dany panel jeszcze jej nie ma
/// (assets/comics/{numer}_{panel}.webp) - opis kadru i tak wyświetla się
/// niżej jako podpis, więc tutaj wystarczy sama ikona miejsca zastępczego.
class _MissingArtPlaceholder extends StatelessWidget {
  final ColorScheme scheme;

  const _MissingArtPlaceholder({required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Icon(Icons.image_outlined, size: 32, color: scheme.onSurfaceVariant),
    );
  }
}
