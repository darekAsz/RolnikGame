import 'package:flutter/widgets.dart';

import 'locale_storage.dart';

/// Globalny, aktualnie wybrany język gry (PL/EN) - `ValueNotifier` zamiast
/// zwykłej stałej, bo `main.dart` buduje na nim `MaterialApp` (patrz
/// `ValueListenableBuilder` w `RolnikApp`), więc zmiana wartości przebudowuje
/// całą aplikację. Dzięki temu z tej samej wartości mogą bezpiecznie
/// korzystać też miejsca bez `BuildContext` (gettery etykiet na enumach,
/// tłumaczenia komiksów/zdarzeń/questów/odkryć w `lib/models/`) - odczyt jest
/// synchroniczny, a odświeżenie po zmianie języka załatwia przebudowa całego
/// drzewa widgetów pod `MaterialApp`.
class AppLocale extends ValueNotifier<Locale> {
  AppLocale._() : super(const Locale('pl'));

  static final AppLocale instance = AppLocale._();

  bool get isEnglish => value.languageCode == 'en';

  Future<void> load() async {
    value = Locale(await LocaleStorage.load());
  }

  Future<void> set(Locale locale) async {
    value = locale;
    await LocaleStorage.save(locale.languageCode);
  }
}
