import 'package:flutter/material.dart';

import 'resource_type.dart';

/// Pory roku, każda trwająca 13 tygodni (wiosna -> lato -> jesień -> zima ->
/// wiosna...), zaczynając od tygodnia 1 = wiosna. Odpowiada dokładnie
/// podziałowi fabuły na akty - patrz models/story_act.dart (Akt 0 = pierwsza
/// wiosna tyg. 1-13, ..., Akt IV/V = druga wiosna tyg. 53-65).
enum Season { spring, summer, autumn, winter }

/// Liczba tygodni trwania jednej pory roku - zgodna z długością aktu fabuły.
const int kWeeksPerSeason = 13;

/// Dekoracyjny motyw rysowany na tle planszy zbiorów w danej porze roku.
enum SeasonBoardOverlay { none, petals, rain, snow }

Season seasonForWeek(int week) =>
    Season.values[((week - 1) ~/ kWeeksPerSeason) % Season.values.length];

/// Tydzień, od którego "druga wiosna" (Akt IV/V, patrz story_act.dart)
/// zamienia zwykłą wiosenną fakturę planszy na wypaczoną, mroczniejszą wersję
/// - las budzi Leszego, więc nawet ta sama pora roku wygląda już inaczej.
const int kCorruptedSpringStartWeek = 53;

/// Jak [SeasonStyle.boardImagePath], ale dla tygodni "drugiej wiosny" (od
/// [kCorruptedSpringStartWeek]) zwraca osobną, wypaczoną fakturę zamiast
/// zwykłej wiosny, mimo że to wciąż ta sama pora roku w cyklu.
String boardImagePathForWeek(int week) {
  final season = seasonForWeek(week);
  if (season == Season.spring && week >= kCorruptedSpringStartWeek) {
    return 'assets/boards/wiosna_wypaczona.webp';
  }
  return season.boardImagePath;
}

extension SeasonStyle on Season {
  String get label {
    switch (this) {
      case Season.spring:
        return 'Wiosna';
      case Season.summer:
        return 'Lato';
      case Season.autumn:
        return 'Jesień';
      case Season.winter:
        return 'Zima';
    }
  }

  String get emoji {
    switch (this) {
      case Season.spring:
        return '🌱';
      case Season.summer:
        return '☀️';
      case Season.autumn:
        return '🍂';
      case Season.winter:
        return '❄️';
    }
  }

  /// Mnożniki wag losowania surowców na planszy zbiorów w danej porze roku.
  Map<ResourceType, double> get weightMultipliers {
    switch (this) {
      case Season.spring:
        return const {ResourceType.stone: 1.1, ResourceType.wood: 0.9};
      case Season.summer:
        return const {ResourceType.grain: 1.1};
      case Season.autumn:
        return const {ResourceType.apple: 1.1, ResourceType.grass: 1.1};
      case Season.winter:
        return const {ResourceType.water: 0.9};
    }
  }

  /// Surowiec, który w tej porze roku ma szansę "zepsuć się" (spalone zboże
  /// latem, zamarznięta woda zimą) i nie dać nic po zebraniu - albo null,
  /// jeśli ta pora roku nie psuje żadnego surowca.
  ResourceType? get spoiledResourceType {
    switch (this) {
      case Season.summer:
        return ResourceType.grain;
      case Season.winter:
        return ResourceType.water;
      case Season.spring:
      case Season.autumn:
        return null;
    }
  }

  String get spoiledLabel {
    switch (this) {
      case Season.summer:
        return 'Spalone';
      case Season.winter:
        return 'Zamarznięte';
      case Season.spring:
      case Season.autumn:
        return '';
    }
  }

  String get description {
    switch (this) {
      case Season.spring:
        return 'Więcej kamienia, mniej drewna.';
      case Season.summer:
        return 'Więcej zboża, ale część kłosów jest spalona.';
      case Season.autumn:
        return 'Więcej jabłek i trawy.';
      case Season.winter:
        return 'Mniej wody, część jest zamarznięta.';
    }
  }

  /// Obrazek tła planszy zbiorów (płaska, widziana z góry faktura terenu -
  /// patrz docs/midjourney_prompts.md sekcja A7). Starcia z bossami używają
  /// tego samego obrazka co pora roku, w której akurat wypada dany tydzień -
  /// nie mają na razie własnych dedykowanych teł.
  String get boardImagePath {
    switch (this) {
      case Season.spring:
        return 'assets/boards/wiosna.webp';
      case Season.summer:
        return 'assets/boards/lato.webp';
      case Season.autumn:
        return 'assets/boards/jesien.webp';
      case Season.winter:
        return 'assets/boards/zima.webp';
    }
  }

  /// Dawny, płaski gradient tła planszy zbiorów sprzed dodania obrazków
  /// tekstur w [boardImagePath] - dostępny jako "starszy wygląd planszy" w
  /// Statystykach (patrz BoardStyleStorage).
  List<Color> get boardGradientColors {
    switch (this) {
      case Season.spring:
        return const [Color(0xFFDCEDC8), Color(0xFFA5D6A7)];
      case Season.summer:
        return const [Color(0xFFFFF9C4), Color(0xFFFFD54F)];
      case Season.autumn:
        return const [Color(0xFFFFCCBC), Color(0xFFBCAAA4)];
      case Season.winter:
        return const [Color(0xFFE3F2FD), Color(0xFFB3E5FC)];
    }
  }

  SeasonBoardOverlay get boardOverlay {
    switch (this) {
      case Season.spring:
        return SeasonBoardOverlay.petals;
      case Season.summer:
        return SeasonBoardOverlay.none;
      case Season.autumn:
        return SeasonBoardOverlay.rain;
      case Season.winter:
        return SeasonBoardOverlay.snow;
    }
  }
}

const double kSpoiledChance = 0.10;
