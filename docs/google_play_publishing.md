# Rolnik: Dług Kruka — publikacja w Google Play

Notatki robocze do wydania gry w Google Play, spisane na podstawie faktycznego stanu tego projektu. Debug build (ten wgrywany dziś przez `adb push`) nie nadaje się do sklepu — inny proces podpisywania, formatu i wpisu sklepowego.

## 0. Stan projektu — co już zrobione, co zostało

Zrobione:
- Nazwa aplikacji ustawiona na **"Rolnik: Dług Kruka"** (`android:label` w `AndroidManifest.xml`, `title:` w `main.dart`).
- `description:` w `pubspec.yaml` zaktualizowany (nie jest to opis sklepowy, ale porządkuje plik).
- **Ikona aplikacji** wygenerowana (prompt A12) i podpięta - master plik w `store_assets/app_icon_1024.png`, `android/app/src/main/res/mipmap-*/ic_launcher.png` przegenerowane pakietem `flutter_launcher_icons` (config w `pubspec.yaml`, uruchamiane przez `dart run flutter_launcher_icons` po każdej podmianie master obrazka).
- **Grafika reklamowa** wygenerowana i przycięta do dokładnych 1024×500 - `store_assets/feature_graphic_1024x500.png`, gotowa do wgrania w Play Console (etap 3).
- **Klucz podpisywania i build release** gotowe (etap 2) - `android/key.properties` (nie commitować, w `.gitignore`), `upload-keystore.jks` w formacie **JKS** (PKCS12, domyślny format nowszego `keytool`, dawał błąd `Given final block not properly padded` przy podpisywaniu przez Gradle mimo poprawnego hasła - trzeba było wymusić `-storetype JKS` przy generowaniu). `flutter build appbundle --release` przechodzi czysto.
- **Rozmiar aplikacji zmniejszony o 75%** (375 MB → **92,4 MB**) - `assets/comics/` (188 plików, było 281 MB), `assets/boards/` (13 MB) i `assets/buildings/` (30 MB, z zachowaniem przezroczystości) przekonwertowane z PNG na **WebP** (jakość 88-90) - malarskie/teksturowane ilustracje to najgorszy przypadek dla bezstratnego PNG, WebP dał ~88% redukcji bez zauważalnej utraty jakości. Wszystkie ścieżki w kodzie (`comics_view.dart`, `village_board.dart`, `season.dart`, ekrany starć z bossami) zaktualizowane na `.webp`. `assets/icons/` (kulki surowców, mniejsze pliki) zostały bez zmian jako PNG.

Zostało (patrz sekcje niżej):
- **Zakładka "Debug"** w `home_shell.dart` (skok w tygodniach, dodawanie surowców, natychmiastowe wygrywanie starć z bossami) jest dziś zawsze widoczna, niezależnie od trybu builda. **Celowo zostaje na razie** (decyzja z 2026-08-22) - do ukrycia dopiero bezpośrednio przed właściwym wydaniem.
- Wpis sklepowy, klasyfikacja treści, testy — patrz etapy 1, 3-6.

## 1. Konto Google Play Console

Rejestracja: [play.google.com/console/signup](https://play.google.com/console/signup)

- Jednorazowa opłata **25 USD**.
- Weryfikacja tożsamości (dowód osobisty, czasem telefon) — może potrwać od kilku godzin do kilku dni.
- **Nowe konta osobiste** muszą dodatkowo przejść zamknięty test przed odblokowaniem publikacji na produkcję — patrz etap 5. Warto to uwzględnić w planowaniu terminu premiery już teraz.

## 2. Podpisywanie aplikacji i build release ✅ zrobione

Klucz uploadu (jednorazowo, **trzymaj plik poza projektem i zrób kopię zapasową** — zgubiony klucz oznacza utratę możliwości aktualizowania aplikacji pod tym samym wpisem w sklepie):

```bash
keytool -genkeypair -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload \
  -storepass TWOJEHASLO -keypass TWOJEHASLO -storetype JKS
```

**`-storetype JKS` jest tu krytyczne.** Nowszy `keytool` domyślnie tworzy magazyn w formacie PKCS12 - wygląda poprawnie i `keytool -list`/`-certreq` go czyta bez problemu, ale Gradle przy `bundleRelease`/`assembleRelease` potrafi wtedy wywalić się błędem `Failed to read key ... Given final block not properly padded`, mimo w 100% poprawnego hasła (niekompatybilność konkretnej wersji JDK używanej przez Gradle z domyślnym PBE tego PKCS12). Wymuszenie starego, sprawdzonego formatu JKS usuwa ten problem. `-storepass`/`-keypass` podane wprost w poleceniu (zamiast osobnych interaktywnych pytań) eliminują też ryzyko literówki między dwoma promptami.

Plik `android/key.properties` (nie commitować - już w `.gitignore`, wraz z `*.jks`):

```properties
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=C:/Users/Darek/Desktop/rolnikGra/upload-keystore.jks
```

Ścieżka absolutna jest tu bezpieczniejsza niż względna (`../upload-keystore.jks`) - nie zależy od tego, względem którego katalogu Gradle akurat ją rozwiąże.

`android/app/build.gradle.kts` już wczytuje ten plik i podpina `signingConfigs.release` w `buildTypes.release` (z awaryjnym fallbackiem na klucz debug, gdyby `key.properties` nie istniał - np. świeży checkout projektu na innym komputerze bez tego pliku).

Build:

```bash
flutter build appbundle --release
```

Wynik: `build/app/outputs/bundle/release/app-release.aab`. Google wymaga formatu **AAB** (Android App Bundle), nie APK, dla nowych aplikacji — `flutter build apk` (używane dziś do testów na telefonie przez `adb push`) nie nadaje się do wysyłki.

## 3. Wpis w sklepie

W Play Console → **Store presence**:

| Element | Wymóg | Status w projekcie |
|---|---|---|
| Ikona aplikacji | 512×512 PNG | Do wygenerowania (A12) i eksportu z 1024×1024 |
| Grafika reklamowa (feature graphic) | 1024×500 | Do wygenerowania (A12) |
| Zrzuty ekranu | min. 2, telefon | Można zrobić z działającej gry |
| Krótki opis | do 80 znaków | Do napisania |
| Pełny opis | do 4000 znaków | Do napisania |
| Kategoria | Gry → Symulacje pasuje lepiej niż Puzzle (budowa wioski jest trzonem, nie samo dopasowywanie) | — |
| E-mail kontaktowy | wymagany | — |
| Polityka prywatności | wymagany URL, nawet przy zerowym zbieraniu danych | Wystarczy jedna strona (np. GitHub Pages) z jednym zdaniem: gra działa offline i nic nie wysyła |

## 4. Klasyfikacja treści i grupa odbiorców

W Play Console → **App content**:

- **Kwestionariusz IARC** — generuje ocenę wieku automatycznie z odpowiedzi. Starcia z bossami to dopasowywanie klocków (match-3), nie przemoc graficzna, więc ocena powinna wyjść nisko.
- **Bezpieczeństwo danych** — "Aplikacja nie zbiera ani nie udostępnia danych użytkownika". Zgodne z rzeczywistością: `AndroidManifest.xml` nie deklaruje uprawnienia `INTERNET`, cały zapis stanu gry idzie lokalnie przez `SharedPreferences` (`GameProgressStorage`, `ResourceStorage` itd.) — to najkrótsza część całego zgłoszenia.
- **Grupa odbiorców** — jeśli nie celujesz świadomie w dzieci poniżej 13 lat, nie zaznaczaj tego wprost: włącza to dodatkowe wymagania Family Policy (m.in. dodatkowe ograniczenia reklam/danych), których projekt dziś nie musi spełniać.

## 5. Test wewnętrzny → zamknięty → produkcja

W Play Console → **Testing**:

1. Wgraj `.aab` na ścieżkę **Internal testing** (własne konto Google jako tester) — najszybszy sposób, by sprawdzić, czy paczka w ogóle się instaluje i uruchamia z Play Console.
2. Nowe konta deweloperskie muszą przejść **test zamknięty** (closed testing) — realni testerzy zapisani na minimum ok. 14 dni (dokładny próg liczby testerów bywa aktualizowany przez Google, sprawdź aktualny wymóg bezpośrednio w Console przy zakładaniu testu) — zanim odblokuje się wniosek o dostęp do produkcji.
3. Dopiero po spełnieniu wymogu: wniosek o **dostęp do produkcji**.

## 6. Zgłoszenie do recenzji i aktualizacje

Po zatwierdzeniu dostępu do produkcji: zgłoszenie wydania do recenzji Google (zwykle godziny do kilku dni).

Każda kolejna aktualizacja:

```bash
# 1. podbij version: w pubspec.yaml (numer buildu zawsze w górę, np. 1.0.0+1 -> 1.0.1+2)
# 2. zbuduj ponownie
flutter build appbundle --release
# 3. wgraj nowy .aab jako nowe wydanie w Play Console
```

## Powiązane

- Prompty do ikony aplikacji i grafiki reklamowej: `docs/midjourney_prompts.md`, sekcja A12.
- Propozycje nazwy gry i pierwsza wersja tego przewodnika (Artifact): [Wydanie na Google Play](https://claude.ai/code/artifact/d2ab1d48-ad76-4eac-acf9-f5128be7e8c8).
