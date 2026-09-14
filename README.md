# Rolnik: Dług Kruka

Gra mobilna (Flutter) łącząca budowę i rozwój wioski z mechaniką match-3 zbierania
surowców, osadzona w mrocznej słowiańskiej fabule o spłacaniu rodzinnego długu i
tajemnicy budzącego się w lesie Leszego.

## O grze

- **Zbiory (match-3)** — surowce (trawa, zboże, drewno, kamień, woda, złoto, jabłka)
  zbierane na siatce dopasowań, z limitem ruchów na turę.
- **Wioska** — 17 typów budynków do postawienia i rozbudowania (Ratusz, Sklep,
  Kuźnia, Rynek, Koszary i inne), każdy z własnymi bonusami i poziomami.
- **Rynek** — wymiana nadwyżek surowców po kursie poprawianym przez ulepszenia.
- **Odkrycia** — drzewko technologii odblokowywane przez Uczelnię.
- **Questy poboczne i cele fabularne** — nagradzane doświadczeniem.
- **Starcia z bossami** — Grot, Marta, Bogdan i Leszy, każdy z własną mechaniką walki.
- **Fabuła** — 30+ komiksów narracyjnych rozłożonych na ok. 64 tygodnie rozgrywki
  (5 aktów), plus losowe zdarzenia tygodniowe zależne od pory roku i morale wioski.

Gra działa w pełni **offline** — cały postęp zapisywany jest lokalnie
(`SharedPreferences`), bez łączności z internetem.

## Stack

- [Flutter](https://flutter.dev) / Dart, Material 3
- Testowane na Flutter 3.44.6 (`environment: sdk: ^3.12.2` w `pubspec.yaml`)
- Wydawana na Android (Google Play); projekt zawiera też szkielety pod
  iOS/Windows/macOS/Linux/Web wygenerowane przez `flutter create`, nie wszystkie
  aktywnie testowane

## Uruchomienie

```bash
flutter pub get
flutter run
```

## Struktura projektu

```
lib/
  screens/   ekrany (wioska, zbiory, walki z bossami, statystyki, cele, komiksy...)
  models/    dane gry (budynki, surowce, komiksy, zdarzenia, questy, odkrycia)
  services/  trwały zapis stanu gry (SharedPreferences)
  widgets/   komponenty UI wielokrotnego użytku (plansza wioski, siatka zbiorów...)
assets/      grafiki, ikony, dźwięki, komiksy
docs/        dokumentacja projektowa - mechaniki gry, fabuła, publikacja w Google Play
```

Dokumentacja w `docs/` (mechaniki gry, pełna fabuła, proces wydania w Google Play,
prompty do generowania grafik) to dobry punkt startowy do zrozumienia projektu.

## Build wydania (Android)

Pełna instrukcja podpisywania i publikacji: [`docs/google_play_publishing.md`](docs/google_play_publishing.md).

```bash
flutter build appbundle --release
```

Wymaga lokalnego `android/key.properties` i pliku klucza `.jks` — celowo **poza**
repozytorium (patrz `.gitignore`), nie są dołączone.

## Licencja

Brak licencji open-source — wszystkie prawa zastrzeżone. Kod udostępniony publicznie
do wglądu, bez prawa do kopiowania, modyfikowania ani redystrybucji bez zgody autora.
