import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';

/// Pokazuje komunikat wioski jako małe, samodzielne okienko u góry ekranu.
/// W odróżnieniu od zwykłego SnackBara nie znika samo - trzeba je zamknąć
/// krzyżykiem. Kolejne komunikaty (np. cała seria z jednego przejścia
/// tygodnia: wydarzenie, potem produkcja, potem wynik aktu) dokładają się do
/// tego samego okienka w kolejności zgłaszania, z możliwością przeglądania
/// strzałkami wstecz/dalej.
void showEventPopup(BuildContext context, String message) {
  _EventPopupQueue.instance.add(context, message);
}

/// Zamyka i czyści bieżącą kolejkę powiadomień - wywoływane na początku
/// nowego tygodnia, żeby seria komunikatów z poprzedniej akcji nie mieszała
/// się z serią należącą do właśnie zaczynającego się tygodnia.
void clearEventPopups() {
  _EventPopupQueue.instance.clear();
}

class _EventPopupQueue {
  _EventPopupQueue._();
  static final instance = _EventPopupQueue._();

  OverlayEntry? _entry;
  final ValueNotifier<List<String>> messages = ValueNotifier(const []);
  final ValueNotifier<int> index = ValueNotifier(0);

  void add(BuildContext context, String message) {
    // Unikaj identycznego komunikatu zaraz pod rząd (np. gdy ten sam quest/
    // zdarzenie zostanie sprawdzone dwukrotnie w tej samej serii) - bez tego
    // okienko potrafiło pokazać dwie takie same karty z rzędu.
    if (messages.value.isNotEmpty && messages.value.last == message) return;
    final wasEmpty = messages.value.isEmpty;
    messages.value = [...messages.value, message];
    if (wasEmpty) index.value = 0;

    if (_entry == null) {
      final overlay = Overlay.maybeOf(context);
      if (overlay == null) return;
      _entry = OverlayEntry(builder: (context) => _EventPopupCard(queue: this));
      overlay.insert(_entry!);
    }
  }

  void close() {
    _entry?.remove();
    _entry = null;
    messages.value = const [];
    index.value = 0;
  }

  void clear() => close();
}

class _EventPopupCard extends StatelessWidget {
  final _EventPopupQueue queue;

  const _EventPopupCard({required this.queue});

  // Kolory drewnianej ramki: ciemna kora na zewnątrz, jasny akcent drewna
  // jako cienka linia wewnątrz, treść na tle przypominającym pergamin -
  // stałe kolory niezależne od motywu (jasny/ciemny), żeby "drewniana
  // tabliczka" zawsze wyglądała tak samo.
  static const _outerWood = Color(0xFF4A2E17);
  static const _innerWoodAccent = Color(0xFFD9A066);
  static const _parchment = Color(0xFFFBEFD8);
  static const _inkColor = Color(0xFF3E2712);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: ValueListenableBuilder<List<String>>(
        valueListenable: queue.messages,
        builder: (context, messages, _) {
          if (messages.isEmpty) return const SizedBox.shrink();
          return ValueListenableBuilder<int>(
            valueListenable: queue.index,
            builder: (context, index, _) {
              final safeIndex = index.clamp(0, messages.length - 1);
              return Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: _outerWood,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 5)),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: _innerWoodAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: _parchment,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.campaign, color: _outerWood, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    messages[safeIndex],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: _inkColor),
                                  ),
                                ),
                                if (messages.length > 1) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: safeIndex > 0
                                            ? () => queue.index.value = safeIndex - 1
                                            : null,
                                        icon: const Icon(Icons.arrow_back_ios_new,
                                            size: 16, color: _outerWood),
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${safeIndex + 1}/${messages.length}',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                              color: _inkColor,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: safeIndex < messages.length - 1
                                            ? () => queue.index.value = safeIndex + 1
                                            : null,
                                        icon: const Icon(Icons.arrow_forward_ios,
                                            size: 16, color: _outerWood),
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: queue.close,
                            icon: const Icon(Icons.close, size: 18, color: _outerWood),
                            visualDensity: VisualDensity.compact,
                            tooltip: AppLocalizations.of(context)!.commonClose,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
