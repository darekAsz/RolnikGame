import 'package:shared_preferences/shared_preferences.dart';

/// Wygląd ikon surowców - `orb` to gotowe obrazki "szklanej kulki z
/// symbolem w środku" (assets/icons/*.png, docs/midjourney_prompts.md
/// sekcja A8), `classic` to płaski styl "jednolite kolorowe tło + prosta
/// ikona" (assets/icons/*_classic.png, sekcja A11) nawiązujący do dawnych
/// ikon SVG sprzed wprowadzenia kulek, `filled` to pośredni styl "kula
/// nieprzezroczysta, wypełniona jednym kolorem, z wytłoczonym symbolem"
/// (assets/icons/*_filled.png, sekcja A13).
enum ResourceIconStyle { orb, classic, filled }

class ResourceIconStyleStorage {
  static const _key = 'resource_icon_style';

  // Wartość w pamięci, czytana synchronicznie przez ResourceType.assetPath -
  // dziesiątki miejsc w kodzie wołają to pole bezpośrednio w build(), więc
  // wątkowanie tego jako jawnego parametru przez każdy z nich (tak jak
  // BoardStyle dla planszy) byłoby nieproporcjonalnie inwazyjne. Ładowana
  // raz przy starcie (patrz HomeShell._load) i aktualizowana przy zmianie
  // w Statystykach - efekt widoczny od następnego przebudowania widoku
  // (np. zmiana zakładki), nie w połowie trwającej rundy zbiorów.
  static ResourceIconStyle current = ResourceIconStyle.orb;

  static Future<ResourceIconStyle> load() async {
    final prefs = await SharedPreferences.getInstance();
    switch (prefs.getString(_key)) {
      case 'classic':
        current = ResourceIconStyle.classic;
      case 'filled':
        current = ResourceIconStyle.filled;
      default:
        current = ResourceIconStyle.orb;
    }
    return current;
  }

  static Future<void> save(ResourceIconStyle style) async {
    current = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, style.name);
  }
}
