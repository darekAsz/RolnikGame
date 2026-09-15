import 'package:flutter/material.dart';

import '../services/app_locale.dart';
import '../services/resource_icon_style_storage.dart';

enum ResourceType {
  grass,
  grain,
  wood,
  stone,
  water,
  coin,
  apple,
  sword,
  truth,
  evidence,
  shield,
  shadow,
}

/// Miecz, Prawda, Dowód, Tarcza i Cień nie są prawdziwymi surowcami
/// gospodarki wioski - pojawiają się wyłącznie na planszach starć z bossami
/// (Miecz - Grot i Leszy, Prawda - Marta, Dowód - Bogdan, Tarcza/Cień -
/// Leszy, patrz BossBattleScreen/MartaBattleScreen/BogdanBattleScreen/
/// LeszyBattleScreen). Miejsca iterujące po ResourceType.values w
/// kontekście zwykłej ekonomii (zakładka Surowce, blokada budowy itd.) muszą
/// je pomijać.
const kBattleOnlyResourceTypes = {
  ResourceType.sword,
  ResourceType.truth,
  ResourceType.evidence,
  ResourceType.shield,
  ResourceType.shadow,
};

/// Typy, które mogą zostać wylosowane jako cel poziomu (bez złota/monety -
/// to osobna kategoria zapasów wioski, nie surowiec zbierany na czas).
const kGoalEligibleTypes = [
  ResourceType.grass,
  ResourceType.grain,
  ResourceType.wood,
  ResourceType.stone,
  ResourceType.water,
  ResourceType.apple,
];

/// Surowce dostępne na planszy zbiorów od samego początku gry, zanim
/// gracz odblokuje cokolwiek w okolicach wioski.
const kStarterResourceTypes = {
  ResourceType.water,
  ResourceType.stone,
  ResourceType.wood,
};

extension ResourceTypeStyle on ResourceType {
  Color get color {
    switch (this) {
      case ResourceType.grass:
        return const Color(0xFF4CAF50);
      case ResourceType.grain:
        return const Color(0xFFD4A017);
      case ResourceType.wood:
        return const Color(0xFF8B5A2B);
      case ResourceType.stone:
        return const Color(0xFF8A8D91);
      case ResourceType.water:
        return const Color(0xFF3A8DDE);
      case ResourceType.coin:
        return const Color(0xFFFFC107);
      case ResourceType.apple:
        return const Color(0xFFD8402F);
      case ResourceType.sword:
        return const Color(0xFFAEB4BC);
      case ResourceType.truth:
        return const Color(0xFFC9A66B);
      case ResourceType.evidence:
        return const Color(0xFF6B4A2F);
      case ResourceType.shield:
        return const Color(0xFF4A7FB5);
      case ResourceType.shadow:
        return const Color(0xFF2B2033);
    }
  }

  // Wszystkie 12 typów mają już gotowe obrazki PNG w stylu "szklanej kulki
  // z symbolem w środku" (docs/midjourney_prompts.md sekcja A8) - patrz
  // widgets/resource_icon.dart, który dobiera SvgPicture/Image na
  // podstawie rozszerzenia, i harvest_grid.dart, który dla PNG pomija
  // proceduralną kulkę i pokazuje sam obrazek. Gracz może w Statystykach
  // przełączyć się na dawne płaskie ikony SVG albo na pośredni styl
  // "wypełniona kula" (patrz ResourceIconStyleStorage) - assetPath zwraca
  // wtedy odpowiednio _classicAssetPath albo _filledAssetPath.
  String get assetPath => switch (ResourceIconStyleStorage.current) {
        ResourceIconStyle.classic => _classicAssetPath,
        ResourceIconStyle.filled => _filledAssetPath,
        ResourceIconStyle.orb => _orbAssetPath,
      };

  String get _orbAssetPath {
    switch (this) {
      case ResourceType.grass:
        return 'assets/icons/grass.png';
      case ResourceType.grain:
        return 'assets/icons/grain.png';
      case ResourceType.wood:
        return 'assets/icons/wood.png';
      case ResourceType.stone:
        return 'assets/icons/stone.png';
      case ResourceType.water:
        return 'assets/icons/water.png';
      case ResourceType.coin:
        return 'assets/icons/coin.png';
      case ResourceType.apple:
        return 'assets/icons/apple.png';
      case ResourceType.sword:
        return 'assets/icons/sword.png';
      case ResourceType.truth:
        return 'assets/icons/truth.png';
      case ResourceType.evidence:
        return 'assets/icons/evidence.png';
      case ResourceType.shield:
        return 'assets/icons/shield.png';
      case ResourceType.shadow:
        return 'assets/icons/shadow.png';
    }
  }

  String get _filledAssetPath {
    switch (this) {
      case ResourceType.grass:
        return 'assets/icons/grass_filled.png';
      case ResourceType.grain:
        return 'assets/icons/grain_filled.png';
      case ResourceType.wood:
        return 'assets/icons/wood_filled.png';
      case ResourceType.stone:
        return 'assets/icons/stone_filled.png';
      case ResourceType.water:
        return 'assets/icons/water_filled.png';
      case ResourceType.coin:
        return 'assets/icons/coin_filled.png';
      case ResourceType.apple:
        return 'assets/icons/apple_filled.png';
      case ResourceType.sword:
        return 'assets/icons/sword_filled.png';
      case ResourceType.truth:
        return 'assets/icons/truth_filled.png';
      case ResourceType.evidence:
        return 'assets/icons/evidence_filled.png';
      case ResourceType.shield:
        return 'assets/icons/shield_filled.png';
      case ResourceType.shadow:
        return 'assets/icons/shadow_filled.png';
    }
  }

  String get _classicAssetPath {
    switch (this) {
      case ResourceType.grass:
        return 'assets/icons/grass_classic.png';
      case ResourceType.grain:
        return 'assets/icons/grain_classic.png';
      case ResourceType.wood:
        return 'assets/icons/wood_classic.png';
      case ResourceType.stone:
        return 'assets/icons/stone_classic.png';
      case ResourceType.water:
        return 'assets/icons/water_classic.png';
      case ResourceType.coin:
        return 'assets/icons/coin_classic.png';
      case ResourceType.apple:
        return 'assets/icons/apple_classic.png';
      case ResourceType.sword:
        return 'assets/icons/sword_classic.png';
      case ResourceType.truth:
        return 'assets/icons/truth_classic.png';
      case ResourceType.evidence:
        return 'assets/icons/evidence_classic.png';
      case ResourceType.shield:
        return 'assets/icons/shield_classic.png';
      case ResourceType.shadow:
        return 'assets/icons/shadow_classic.png';
    }
  }

  String get label {
    if (AppLocale.instance.isEnglish) {
      switch (this) {
        case ResourceType.grass:
          return 'Grass';
        case ResourceType.grain:
          return 'Grain';
        case ResourceType.wood:
          return 'Wood';
        case ResourceType.stone:
          return 'Stone';
        case ResourceType.water:
          return 'Water';
        case ResourceType.coin:
          return 'Gold';
        case ResourceType.apple:
          return 'Apple';
        case ResourceType.sword:
          return 'Sword';
        case ResourceType.truth:
          return 'Truth';
        case ResourceType.evidence:
          return 'Evidence';
        case ResourceType.shield:
          return 'Shield';
        case ResourceType.shadow:
          return 'Shadow';
      }
    }
    switch (this) {
      case ResourceType.grass:
        return 'Trawa';
      case ResourceType.grain:
        return 'Zboże';
      case ResourceType.wood:
        return 'Drewno';
      case ResourceType.stone:
        return 'Kamień';
      case ResourceType.water:
        return 'Woda';
      case ResourceType.coin:
        return 'Złoto';
      case ResourceType.apple:
        return 'Jabłko';
      case ResourceType.sword:
        return 'Miecz';
      case ResourceType.truth:
        return 'Prawda';
      case ResourceType.evidence:
        return 'Dowód';
      case ResourceType.shield:
        return 'Tarcza';
      case ResourceType.shadow:
        return 'Cień';
    }
  }
}
