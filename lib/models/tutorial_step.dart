import 'package:flutter/widgets.dart';

/// Jeden krok samouczka z podświetleniem - patrz widgets/tutorial_overlay.dart.
/// [targetKey] wskazuje realny widget na ekranie (musi być aktualnie
/// zamontowany, żeby dało się zmierzyć jego pozycję/rozmiar).
class TutorialStep {
  final GlobalKey targetKey;
  final String title;
  final String description;
  // Margines wokół podświetlonego obszaru (poza granicami samego widgetu).
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  // Opcjonalny DRUGI podświetlony element, pokazywany naraz z głównym (np.
  // ikonka danej zakładki na dolnym pasku obok podświetlonej treści tej
  // zakładki - patrz HomeShell._startTour) - własny, mały margines/promień,
  // bo to zwykle mała ikonka, nie cały panel treści.
  final GlobalKey? secondaryTargetKey;
  final EdgeInsets secondaryPadding;
  final BorderRadius secondaryBorderRadius;

  const TutorialStep({
    required this.targetKey,
    required this.title,
    required this.description,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.secondaryTargetKey,
    this.secondaryPadding = const EdgeInsets.all(6),
    this.secondaryBorderRadius = const BorderRadius.all(Radius.circular(12)),
  });
}
