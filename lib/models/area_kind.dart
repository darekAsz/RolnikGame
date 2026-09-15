import 'package:flutter/material.dart';

import '../services/app_locale.dart';
import 'resource_type.dart';

/// Sześć terenów w okolicach wioski, osobnych od planszy wioski samej w
/// sobie. Każdy odpowiada dokładnie jednemu surowcowi zbieranemu na planszy
/// zbiorów.
enum AreaKind { river, mountains, forest, meadow, orchard, field }

extension AreaKindStyle on AreaKind {
  ResourceType get resourceType {
    switch (this) {
      case AreaKind.river:
        return ResourceType.water;
      case AreaKind.mountains:
        return ResourceType.stone;
      case AreaKind.forest:
        return ResourceType.wood;
      case AreaKind.meadow:
        return ResourceType.grass;
      case AreaKind.orchard:
        return ResourceType.apple;
      case AreaKind.field:
        return ResourceType.grain;
    }
  }

  String get label {
    if (AppLocale.instance.isEnglish) {
      switch (this) {
        case AreaKind.river:
          return 'River';
        case AreaKind.mountains:
          return 'Mountains';
        case AreaKind.forest:
          return 'Forest';
        case AreaKind.meadow:
          return 'Meadow';
        case AreaKind.orchard:
          return 'Orchard';
        case AreaKind.field:
          return 'Field';
      }
    }
    switch (this) {
      case AreaKind.river:
        return 'Rzeka';
      case AreaKind.mountains:
        return 'Góry';
      case AreaKind.forest:
        return 'Las';
      case AreaKind.meadow:
        return 'Łąka';
      case AreaKind.orchard:
        return 'Sad';
      case AreaKind.field:
        return 'Pole';
    }
  }

  Color get terrainColor {
    switch (this) {
      case AreaKind.river:
        return const Color(0xFF3A8DDE);
      case AreaKind.mountains:
        return const Color(0xFF8A8D91);
      case AreaKind.forest:
        return const Color(0xFF2F6B27);
      case AreaKind.meadow:
        return const Color(0xFF6BAF3E);
      case AreaKind.orchard:
        return const Color(0xFFD8402F);
      case AreaKind.field:
        return const Color(0xFFD4A017);
    }
  }

  /// Rzeka/góry/las odpowiadają surowcom dostępnym od początku gry - budowa
  /// tam nie odblokowuje niczego nowego, tylko daje premię +1/ścieżkę do
  /// surowca, który i tak już można zbierać.
  bool get isStarterResource => kStarterResourceTypes.contains(resourceType);

  /// Cała okolica to jedna ścieżka rozwoju: Sad -> Łąka -> Pole odblokowują
  /// po kolei jabłko/trawę/zboże, a Rzeka -> Góry -> Las to ostatni etap,
  /// który te trzy surowce zużywa jako koszt ulepszenia.
  AreaKind? get prerequisite {
    switch (this) {
      case AreaKind.meadow:
        return AreaKind.orchard;
      case AreaKind.field:
        return AreaKind.meadow;
      case AreaKind.river:
        return AreaKind.field;
      case AreaKind.mountains:
        return AreaKind.river;
      case AreaKind.forest:
        return AreaKind.mountains;
      case AreaKind.orchard:
        return null;
    }
  }
}
