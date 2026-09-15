import 'package:flutter/material.dart';

import '../services/app_locale.dart';
import 'resource_type.dart';

/// Trzy rodzaje jednostek rekrutowanych w Koszarach - każdy z innym kosztem
/// (poza złotem, zawsze drewno lub kamień) i inną siłą bazową.
enum UnitType { spearman, archer, warrior }

/// Kolorystyka wybrana przez gracza spośród 5 zaproponowanych wariantów
/// (patrz artefakt "Wygląd żołnierzy - Koszary"): włócznik = Żelazna Straż,
/// łucznik = Leśny Strażnik, zbrojny = Rekrut.
class UnitPalette {
  final Color tunic;
  final Color tunicDark;
  final Color metal;
  final Color metalDark;
  final Color accent;
  final Color? cloak;

  const UnitPalette({
    required this.tunic,
    required this.tunicDark,
    required this.metal,
    required this.metalDark,
    required this.accent,
    this.cloak,
  });
}

extension UnitTypeStyle on UnitType {
  String get label {
    if (AppLocale.instance.isEnglish) {
      switch (this) {
        case UnitType.spearman:
          return 'Spearman';
        case UnitType.archer:
          return 'Archer';
        case UnitType.warrior:
          return 'Warrior';
      }
    }
    switch (this) {
      case UnitType.spearman:
        return 'Włócznik';
      case UnitType.archer:
        return 'Łucznik';
      case UnitType.warrior:
        return 'Zbrojny';
    }
  }

  String get emoji {
    switch (this) {
      case UnitType.spearman:
        return '🔱';
      case UnitType.archer:
        return '🏹';
      case UnitType.warrior:
        return '🛡️';
    }
  }

  // Rosnąca progresja koszt/siła: włócznik najtańszy i najsłabszy, łucznik
  // droższy i mocniejszy, zbrojny najdroższy i najmocniejszy - każdy kolejny
  // typ ma być wyraźnie lepszy, nie tylko inny.
  int get baseStrength {
    switch (this) {
      case UnitType.spearman:
        return 1;
      case UnitType.archer:
        return 2;
      case UnitType.warrior:
        return 3;
    }
  }

  /// Koszt rekrutacji jednej jednostki (poza kosztem złota - patrz
  /// HomeShell._soldierRecruitCostGold, wspólny dla wszystkich typów).
  Map<ResourceType, int> get recruitCost {
    switch (this) {
      case UnitType.spearman:
        return const {ResourceType.wood: 3};
      case UnitType.archer:
        return const {ResourceType.wood: 5};
      case UnitType.warrior:
        return const {ResourceType.stone: 6};
    }
  }

  UnitPalette get palette {
    switch (this) {
      case UnitType.spearman:
        // Żelazna Straż
        return const UnitPalette(
          tunic: Color(0xFF5B6470),
          tunicDark: Color(0xFF383F47),
          metal: Color(0xFFC7CDD6),
          metalDark: Color(0xFF7D8794),
          accent: Color(0xFF9FB4C9),
          cloak: Color(0xFF454E58),
        );
      case UnitType.archer:
        // Leśny Strażnik
        return const UnitPalette(
          tunic: Color(0xFF45643A),
          tunicDark: Color(0xFF2C4126),
          metal: Color(0xFF8C9A7C),
          metalDark: Color(0xFF5C6B4E),
          accent: Color(0xFFB3D17A),
          cloak: Color(0xFF33502B),
        );
      case UnitType.warrior:
        // Rekrut
        return const UnitPalette(
          tunic: Color(0xFF8A6642),
          tunicDark: Color(0xFF5C4227),
          metal: Color(0xFFB8B0A2),
          metalDark: Color(0xFF7D766A),
          accent: Color(0xFFC9A227),
        );
    }
  }
}
