# Rolnik: Dług Kruka — systemy i mechaniki gry

Kompletny opis wszystkich systemów gry, spisany na podstawie faktycznego stanu kodu (nie założeń projektowych) — każda liczba poniżej pochodzi bezpośrednio z `lib/`. Dokument służy jako referencja balansu i mechanik, nie jako fabularny spoiler-poradnik (fabuła streszczona jest tylko w zarysie, w sekcji 10).

---

## 1. Przegląd

Rolnik: Dług Kruka to hybryda **budowania wioski** i **dopasowywania kulek (match-3)**, spięta fabułą osadzoną w słowiańskim folklorze — gracz (Kazimierz) dziedziczy podupadłe gospodarstwo dziadka wraz z tajemniczym długiem rodziny Kruków. Gra toczy się w cyklu tygodniowym przez **65 tygodni** (6 aktów fabularnych), naprzemiennie: tydzień w wiosce (budowanie, decyzje) → runda zbiorów (plansza match-3) → czasem zamiast zwykłych zbiorów: starcie z jednym z 4 bossów.

## 2. Pętla rozgrywki (cykl tygodniowy)

1. **Ekran wioski** — gracz buduje/rozbudowuje budynki, zarządza Okolicami, sklepem, Uczelnią, przydziela pracowników.
2. Gracz naciska przycisk „→ [tydzień]”, żeby zakończyć tydzień.
3. **Plansza zbiorów** (match-3) — ograniczona liczba ruchów, zbieranie surowców. W tygodniach 26/39/52/64 zamiast tego uruchamia się **starcie z bossem**. Panel podsumowania po wyczerpaniu ruchów ma opcję **„Zagraj tydzień ponownie”** — cofa zebrane w tej próbie surowce (przez przywrócenie checkpointu sprzed rundy) i rozdaje nową planszę od zera; dotyczy tylko zwykłych zbiorów, nie starć z bossami.
4. Po zbiorach: ewentualne **losowe wydarzenie tygodniowe**, aktualizacja populacji (głód/wzrost), zapisanie **checkpointu**, sprawdzenie **questów pobocznych** i **celu bieżącego aktu**.
5. Jeśli to ostatni tydzień aktu i cel nie został spełniony → **ekran porażki aktu** (przywróć checkpoint albo zacznij od nowa).
6. Powrót do kroku 1.

---

## 3. Surowce i plansza zbiorów (match-3)

### 3.1. Typy surowców (12)

| Surowiec | Kolor (hex) | Kategoria |
|---|---|---|
| Trawa (`grass`) | `#4CAF50` | ekonomia |
| Zboże (`grain`) | `#D4A017` | ekonomia |
| Drewno (`wood`) | `#8B5A2B` | ekonomia |
| Kamień (`stone`) | `#8A8D91` | ekonomia |
| Woda (`water`) | `#3A8DDE` | ekonomia |
| Złoto (`coin`) | `#FFC107` | ekonomia (waluta) |
| Jabłko (`apple`) | `#D8402F` | ekonomia |
| Miecz (`sword`) | `#AEB4BC` | bojowy — Grot, Leszy |
| Prawda (`truth`) | `#C9A66B` | bojowy — Marta |
| Dowód (`evidence`) | `#6B4A2F` | bojowy — Bogdan |
| Tarcza (`shield`) | `#4A7FB5` | bojowy — Leszy |
| Cień (`shadow`) | `#2B2033` | bojowy — Leszy |

- **7 surowców ekonomii** (grass/grain/wood/stone/water/coin/apple) krążą w normalnej gospodarce wioski (magazyn, budowa, Rynek).
- **5 surowców bojowych** pojawiają się wyłącznie na planszach starć z bossami, nigdy w zwykłej ekonomii.
- **Surowce startowe** (dostępne od tygodnia 1, przed rozwinięciem Okolic): woda, kamień, drewno.
- **Surowce kwalifikujące się jako cel poziomu**: trawa, zboże, drewno, kamień, woda, jabłko (bez złota — to osobna kategoria zapasów, nie „zbieraj na czas”).

### 3.2. Mechanika dopasowywania

- Gracz przeciąga palcem po sąsiadujących kafelkach tego samego typu — sąsiedztwo jest **8-kierunkowe** (również po skosie), zarówno przy budowaniu ścieżki, jak i przy wybuchu bomby.
- Minimalna długość ścieżki do zebrania: 2 kafelki.
- **Złoto łączy się tylko z innym złotem** — to zwykły surowiec, nie „dziki” kafelek.

### 3.3. Wzór na wynik zbiórki

Niech `rawCount` = liczba kafelków w ścieżce, `base` = liczba zwykłych (niespecjalnych, niezepsutych) kafelków, `jokerCount` = liczba jokerów w ścieżce:

```
base == 0 i jokerCount > 0  →  wynik = jokerCount²
jokerCount == 0             →  wynik = base
jokerCount == 1              →  wynik = base + 1
jokerCount ≥ 2               →  wynik = base × jokerCount
```

Bomby w ścieżce nie liczą się do `base` — mają własny, osobny mechanizm zbierania (patrz niżej).

### 3.4. Joker i bomba

- Domyślne progi: joker przy ścieżce **5+**, bomba przy ścieżce **6+** (`minComboForJoker`/`minComboForBomb`).
- Obniżane o 1 przez odkrycia Uczelni: „Szczęśliwa passa” (joker → 4), „Wybuchowy zapał” (bomba → 5).
- Gdy ścieżka osiąga próg bomby, sprawdzana jest ona **przed** progiem jokera (bomba ma priorytet przy bardzo długich ścieżkach).
- Nowy specjalny kafelek zastępuje losowy nowo spadnięty kafelek w miejscu zebranej ścieżki.
- **Bomba**: po włączeniu do ścieżki niszczy wszystkich swoich 8-kierunkowych sąsiadów (poza kafelkami już należącymi do ścieżki) — zniszczone kafelki zbierane są osobno, po typie. Jedno przeciągnięcie może przejść przez kilka bomb naraz — każda detonuje osobno (ważne np. dla celu „zdetonuj N bomb” u Grota), ale liczy się jako **jeden ruch**.

### 3.5. Zepsute kafelki

- Tylko dla sezonowo „psującego się” surowca (zboże latem, woda zimą — patrz 3.7).
- Bazowa szansa: **10%** (`kSpoiledChance`), redukowana przez poziomy Kaplicy/Studni/Spichlerza (patrz sekcja 5).
- Zepsuty kafelek łączy się normalnie w ścieżkę, ale **daje zero surowca** po zebraniu (wizualnie: przygaszony, z ikoną ognia/śniegu).

### 3.6. Auto-dopasowywanie (kupowane w sklepie)

| Poziom | Efekt |
|---|---|
| 0 (brak) | wyłączone — gracz musi ręcznie przeciągać każdą ścieżkę |
| 1 | ciągi 4+ tego samego typu w rzędzie/kolumnie znikają automatycznie |
| 2 | ciągi 3+ znikają automatycznie |

Uruchamia się też raz automatycznie ~550ms po rozdaniu nowej planszy, oraz kaskadowo po każdym spadnięciu nowych kafelków.

**Nie działa w starciach z bossami** (Grot/Marta/Bogdan/Leszy) — tam liczenie zawsze zostaje ręczne, niezależnie od wykupionego poziomu.

### 3.7. Wagi losowania i pory roku

- Wszystkie typy surowców mają **identyczną bazową wagę losowania** (dawniej złoto miało wagę obniżoną — to zostało wyrównane).
- Modyfikatory sezonowe (`weightMultipliers`):

| Pora roku | Modyfikator wag | Psujący się surowiec |
|---|---|---|
| Wiosna 🌱 | kamień ×1.1, drewno ×1.1 | brak |
| Lato ☀️ | zboże ×1.1 | Zboże (Spalone) |
| Jesień 🍂 | jabłko ×1.1, trawa ×1.1 | brak |
| Zima ❄️ | woda ×0.9 | Woda (Zamarznięte) |

- Każda pora roku trwa 13 tygodni, cyklicznie od tygodnia 1 (wiosna → lato → jesień → zima → wiosna...).

### 3.8. Surowiec tygodnia (weekly boost)

- Odblokowany, gdy przynajmniej jedna Okolica jest rozbudowana do poziomu 2.
- Gracz wybiera jeden surowiec na początku tygodnia (albo pomija) — jego waga losowania dostaje losowy bonus **+10% do +20%**.

---

## 4. Wioska i budynki

### 4.1. Wszystkie 17 rodzajów budynków

Ratusz, Palisada, Sklep, Karczma, Dom, Kuźnia, Spichlerz, Piekarnia, Tartak, Studnia, Browar, Kaplica, Uczelnia (wewn. `szkola`), Rynek, Magazyn, Kamieniarz, Koszary.

- **9 standardowych działek**: Sklep, Karczma, Rynek, Magazyn, Kuźnia, Browar, Kaplica, Uczelnia, Koszary.
- **6 małych działek**: Dom, Spichlerz, Piekarnia, Tartak, Studnia, Kamieniarz.
- Ratusz i Palisada mają własne, unikalne miejsca na planszy (Ratusz na głównej ścieżce, Palisada jako mur wokół całej wioski, klikalna tylko przy bramie).
- Dodatkowo: **5 niezależnych działek pod dodatkowe Domy** (patrz 4.6).

### 4.2. Koszty budowy (poziom 1)

| Budynek | Koszt |
|---|---|
| Sklep | 12 drewna, 8 kamienia, 8 złota |
| Karczma | 15 drewna, 10 kamienia |
| Dom | 10 drewna, 6 kamienia |
| Kuźnia | 15 drewna, 12 kamienia |
| Spichlerz | 15 drewna, 10 kamienia |
| Piekarnia | 15 drewna, 10 kamienia |
| Tartak | 12 drewna, 10 kamienia |
| Studnia | 12 drewna, 10 kamienia |
| Browar | 12 drewna, 8 kamienia, 6 złota |
| Kaplica | 15 drewna, 10 kamienia, 8 złota |
| Uczelnia | 18 drewna, 12 kamienia, 10 złota |
| Rynek | 18 drewna, 12 kamienia, 10 złota |
| Magazyn | 20 drewna, 15 kamienia |
| Kamieniarz | 12 drewna, 8 kamienia |
| Koszary | 20 drewna, 15 kamienia, 12 złota |
| **Ratusz** | 15 trawy, 15 zboża, 20 drewna, 15 kamienia, 15 wody, 10 złota, 15 jabłek (celowo duży — pierwszy wydatek z każdego z 7 surowców) |
| **Palisada** | 20 drewna, 15 kamienia |

**Koszt rozbudowy (poziom 2) jest identyczny dla wszystkich 17 budynków: 25 złota** — czysta inwestycja złota, niezależna od kosztu poziomu 1.

**Zburzenie** zwraca 50% kosztu poziomu 1 (i poziomu 2, jeśli rozbudowany). Ratusza nie da się zburzyć.

### 4.3. Kolejność odblokowania

1. **Wszystkie 7 surowców ekonomii musi być odblokowanych** (przez rozwój Okolic — Sad, Łąka, Pole), zanim da się zbudować cokolwiek w wiosce, łącznie z Ratuszem.
2. **Ratusz musi być zbudowany, zanim da się zbudować jakikolwiek inny budynek** (w tym Palisadę).
3. **Rozbudowa Ratusza do poziomu 2 odblokowuje się dopiero w Akcie II (tydzień 27)** - to też nowy, dodatkowy cel główny tego aktu (patrz 10), niezależny od starcia z Martą.
4. **Ratusz musi być rozbudowany do poziomu 2, zanim da się rozbudować jakikolwiek inny budynek do poziomu 2.**

### 4.4. Efekty budynków (poziom 1 → poziom 2)

| Budynek | Poziom 1 | Poziom 2 |
|---|---|---|
| **Ratusz** | +2 każdego odblokowanego surowca/tydzień; +1 do złota zebranego na planszy | +4 każdego surowca/tydzień |
| **Palisada** | +1 limit populacji, +20 bezpieczeństwa | +2 limit populacji (łącznie), +40 bezpieczeństwa (łącznie) |
| **Sklep** | odblokowuje zakładkę Sklep | +2 do limitu dokupowanych ruchów |
| **Karczma** | +2 limit populacji | +4 limit populacji (łącznie) |
| **Dom** | +3 limit populacji | +6 limit populacji (łącznie) |
| **Kuźnia** | +2 złota/tydzień; odblokowuje rekrutację w Koszarach | +4 złota/tydzień |
| **Spichlerz** | +3 jabłka/tydzień; -5% ryzyka zepsucia | produkcja BEZ podwojenia (nadal +3); -10% ryzyka (łącznie) |
| **Piekarnia** | +3 zboża/tydzień | +6 zboża/tydzień |
| **Tartak** | +3 drewna/tydzień | +6 drewna/tydzień |
| **Studnia** | +3 wody/tydzień; -3% ryzyka zepsucia | produkcja BEZ podwojenia (nadal +3); -6% ryzyka (łącznie) |
| **Browar** | +10 morale | +20 morale (łącznie) |
| **Kaplica** | -5% ryzyka zepsucia; +5 morale | -10% ryzyka (łącznie, efektywnie zeruje bazowe 10%); +10 morale (łącznie) |
| **Uczelnia** | odblokowuje panel odkryć (wymagające poziomu 1) | odblokowuje odkrycia wymagające poziomu 2 |
| **Rynek** | wymiana: 8 oddane → 1 otrzymane (surowy start) | wymiana: 6 oddane → 1 otrzymane (jedno z 3 niezależnych ulepszeń) — patrz sekcja 8 |
| **Magazyn** | +50 do limitu magazynu każdego surowca | +100 (łącznie) |
| **Kamieniarz** | +3 kamienia/tydzień | +6 kamienia/tydzień |
| **Koszary** | +5 bezpieczeństwa; odblokowuje rekrutację (wymaga zbudowanej Kuźni) | +10 bezpieczeństwa (łącznie); **podwaja siłę każdego żołnierza** |

*Wszystkie powyższe wartości produkcyjne/bonusowe skalują się dodatkowo przez system pracowników (patrz 4.5).*

**Rekrutacja w Koszarach** — 3 typy żołnierzy, rosnąca progresja koszt/siła (każdy kolejny typ wyraźnie lepszy, nie tylko inny): koszt złota (`_soldierRecruitCostGold` = 3) jest wspólny dla wszystkich typów, tylko surowiec dodatkowy i siła bazowa się różnią.

| Jednostka | Siła bazowa | Koszt dodatkowy |
|---|---|---|
| Włócznik | 1 | 3 drewna |
| Łucznik | 2 | 5 drewna |
| Zbrojny | 3 | 6 kamienia |

Koszary poziom 2 podwaja siłę KAŻDEGO żołnierza (patrz tabela wyżej); Kowalstwo wojskowe (Uczelnia) dodaje płaskie +1 siły do każdego.

### 4.5. Pracownicy

- Limit pracowników na budynek: **0** domyślnie → **1** po odkryciu „Zarządzanie pracownikami I” → **2** po „Zarządzanie pracownikami II” (oba w Uczelni).
- Każdy przydzielony pracownik daje **+50% do premii budynku**, maks. 2 pracowników = podwojona premia.
- Przydzielenie pracownika zużywa jednostkę **limitu populacji** (wspólna pula na całą wioskę), nie samą liczbę mieszkańców.
- Wyjątki od reguły +50%/pracownika - płaski, addytywny bonus zamiast mnożnika: **Sklep** (+1 do limitu dokupywanych ruchów/pracownika), **Rynek** (-1 do kursu wymiany/pracownika) i **Magazyn** (+25 do limitu magazynu/pracownika, patrz niżej).

### 4.6. Dodatkowe domy

- **5 niezależnych działek**, osobnych od standardowego budynku „Dom”, rozsianych po wiosce z dala od ścieżek.
- Fabularny twist: na starcie gry 2 z nich stoją już zbudowane, ale **zaniedbane (poziom 0)** — wciąż mieszkają w nich ludzie, ale nie dają bonusu do populacji, dopóki nie zostaną „odbudowane" do poziomu 1 (koszt jak rozbudowa: 25 złota). To pierwszy, wcześniejszy krok, zanim dom stanie się w pełni aktywny. **Nie da się ich zburzyć** w tym stanie (nie ma czego zwracać, a mieszkańcy zostają) — burzenie jest możliwe dopiero po odbudowie, jak przy każdym innym Domu.
- Każdy aktywny dodatkowy dom daje **+3 do limitu populacji**, tak jak standardowy budynek „Dom” - i tak jak on, **można go rozbudować do poziomu 2** za kolejne 25 złota, podwajając premię do +6 (bez skalowania pracownikami — nie ma tu przydziału pracowników).

---

## 5. Statystyki wioski

| Statystyka | Baza | Składniki |
|---|---|---|
| **Limit populacji** | 5 | + Dom (3/6, skal. pracownikami) + Karczma (2/4, skal.) + Palisada (1/2, skal.) + aktywne dodatkowe domy (3/6 każdy, rozbudowa niezależna od pracowników) + bonus z wydarzeń |
| **Morale** (0-100) | 50 | + Browar (10/20, skal.) + Kaplica (5/10, skal.) + bonus z wydarzeń + (bezpieczeństwo / 100) |
| **Bezpieczeństwo** | 0 | + Palisada (20/40, skal.) + Koszary (5/10, skal.) + bonus z wydarzeń |
| **Limit magazynu** (na surowiec) | 100 | + Magazyn (50/100 wg poziomu, NIE skal. pracownikami) + Magazyn: +25/pracownika (flat, maks. 2 = +50) + odkrycie „Rachunkowość” (+150 flat) |
| **Ryzyko zepsucia** (bazowo 10%) | — | − Kaplica (5%/10%) − Studnia (3%/6%) − Spichlerz (3%/6%), suma przycięta do [0%, 10%] |

**Populacja i głód**: zużycie zboża = `ceil(populacja / 1)`, czyli 1 zboże/mieszkaniec (dzielnik +1 z odkryciem „Agronomia zapasowa”, czyli 2 mieszkańców/1 zboże). Brakujące zboże jest dobierane z jabłek jako zapasowe źródło jedzenia (dokładnie brakująca ilość, nie cała potrzeba) - głód następuje dopiero, gdy i jabłek nie starcza: populacja -1 (0 z odkryciem „Medycyna wiejska”), morale -5. Jeśli jedzenia wystarcza i populacja &lt; limit → wzrost zależny od morale wioski: `morale/100` mieszkańca/tydzień (np. 50% morale = +0,5/tydzień), **×2 z odkryciem „Szybszy przyrost”**. Ułamkowa reszta odkłada się między tygodniami (patrz `HomeShell._populationGrowthProgress`), więc np. stałe 0,5/tydzień faktycznie daje +1 co dwa tygodnie, nie jest tracone przy zaokrąglaniu.

---

## 6. Okolice (Surroundings) — 6 terenów

Kolejność odblokowania (każdy wymaga poprzedniego): **Sad → Łąka → Pole → Las → Rzeka → Góry**.

| Teren | Surowiec | Efekt (Sad/Łąka/Pole = nowy surowiec; Las/Rzeka/Góry = surowiec startowy) |
|---|---|---|
| Sad | Jabłko | odblokowuje nowy typ na planszy |
| Łąka | Trawa | odblokowuje nowy typ |
| Pole | Zboże | odblokowuje nowy typ |
| Las | Drewno | już dostępna od startu — zamiast tego +1 do każdej ścieżki tego surowca |
| Rzeka | Woda | już dostępna od startu — +1 do każdej ścieżki |
| Góry | Kamień | już dostępna od startu — +1 do każdej ścieżki |

Ta premia +1 działa też w starciach z bossami, wszędzie tam, gdzie dany surowiec da się zebrać/zbankować (np. Miecz z drewna u Grota, Opanowanie wodą u Bogdana, zdolności bankujące drewno/kamień/wodę u Leszego) — wcześniej działała tylko w zwykłych zbiorach.

- Koszt poziomu 1 rośnie wraz z terenem, ale drewno jest celowo złagodzone dla pierwszych czterech terenów (Sad: 7 drewna/8 kamienia → Łąka: 9 drewna → Pole: 11 drewna → Las: 14 drewna, 15 kamienia, 12 jabłka, 10 trawy, 10 zboża), podczas gdy Rzeka/Góry jako faktycznie ostatni etap zostają przy pełnym koszcie: 18 drewna, 15 kamienia, 12 jabłka, 10 trawy, 10 zboża (czyli konsumują surowce odblokowane wcześniejszymi terenami).
- Koszt poziomu 2: **flat 20 złota** dla każdego terenu.
- Poziom 2 dowolnego terenu odblokowuje „Surowiec tygodnia” (patrz 3.8).
- Każdy zbudowany teren (poziom 1) dodaje **+1 wiersz** do planszy zbiorów; komplet 6 terenów dodaje dodatkowo **+1 kolumnę** (niezależnie odkrycie „Kartografia” też dodaje +1 kolumnę).

---

## 7. Uczelnia — 14 odkryć

*Koszty przeliczone wg wartości efektu i wymaganego poziomu Uczelni: tanie usprawnienia poziomu 1 → solidniejsze inwestycje poziomu 2 → Szczęśliwa passa/Wybuchowy zapał jako szczyt (jedyne odkrycia zmieniające na stałe samą mechanikę match-3, nie tylko ekonomię wioski). Wszystkie ceny podniesione o ~1/3 względem pierwotnych.*

| Odkrycie | Poziom Uczelni | Koszt | Efekt |
|---|---|---|---|
| Podstawy agronomii | 1 | 13 złota | +1 ruch bazowy |
| Zaawansowana agronomia | 2 | 20 złota | +1 ruch bazowy (razem +2) |
| Zarządzanie pracownikami I | 1 | 20 złota, 13 drewna, 13 kamienia | odblokowuje 1 pracownika/budynek |
| Zarządzanie pracownikami II | 2 | 33 złota, 20 drewna, 20 kamienia | limit pracowników → 2 |
| Rachunkowość | 1 | 16 złota, 13 drewna | +150 do limitu magazynu (każdy surowiec) |
| Medycyna wiejska | 1 | 13 złota, 11 zboża | głód nie zabiera populacji, tylko morale |
| Agronomia zapasowa | 1 | 13 złota, 11 zboża | dzielnik zużycia zboża 4→6 |
| Meteorologia | 1 | 16 złota | +15pp do szansy na pozytywne wydarzenie |
| Kartografia | 2 | 27 złota, 20 drewna, 20 kamienia | +1 kolumna planszy zbiorów |
| Dyplomacja | 2 | 20 złota | +1 do ilości otrzymywanej przy wymianie na Rynku |
| Kowalstwo wojskowe | 2 | 24 złota, 13 kamienia | +1 siły każdego żołnierza |
| Szybszy przyrost | 2 | 24 złota, 13 zboża | ×2 do tempa przyrostu populacji (zależnego od morale) |
| **Szczęśliwa passa** | 2 | 33 złota, 27 drewna, 27 kamienia | joker już od ścieżki 4 (zamiast 5) |
| **Wybuchowy zapał** | 2 | 47 złota, 33 drewna, 33 kamienia, 20 zboża | bomba już od ścieżki 5 (zamiast 6) |

---

## 8. Sklep i Rynek

- **Dokupowanie ruchów**: baza 10 (+1 za każde z dwóch odkryć agronomii, maks. 12), limit dokupionych ruchów **2** z samym Sklepem (poziom 1), **+4 więcej (razem 6)** po rozbudowie do poziomu 2 — świadomie rosnący skok, **+1 za każdego przydzielonego pracownika** (maks. 2, dodatek prosty i addytywny, nie mnożnik). Koszt rośnie z każdym zakupem, trzema surowcami naraz: **50 złota + 15 za każdy już kupiony**, **15 drewna + 5 za każdy już kupiony**, **10 kamienia + 5 za każdy już kupiony**.
- **Auto-dopasowywanie**: poziom 1 (ciągi 4+) kosztuje 60 złota, 20 drewna, 20 kamienia; poziom 2 (ciągi 3+, wymaga poziomu 1, realna zmiana mechaniki match-3) kosztuje jeszcze więcej - 100 złota, 30 drewna, 30 kamienia.
- **Kurs wymiany na Rynku**: zawsze dostajesz **1** surowiec. Ile trzeba oddać, spada z 3 niezależnych ulepszeń: Rynek poziom 2 (**-2**), odkrycie Dyplomacji (**-2**), przydzieleni pracownicy (do 2, **-1 za każdego**). Bez żadnego z nich: **8→1** (surowy początek). Z kompletem wszystkich trzech: dokładnie **2→1** — to twardy sufit, kurs nigdy nie jest lepszy, żeby handel nie stał się darmowym generatorem surowców. Ulepszenia sumują się niezależnie, np. odkrycie Dyplomacji + 1 pracownik = **-3**, czyli **5→1**.

---

## 9. Wydarzenia tygodniowe

- **50% szansy** na jakiekolwiek wydarzenie w danym tygodniu.
- Jeśli wystąpi: **30% szansy**, że to wydarzenie **z wyborem** (2 opcje do wyboru); w przeciwnym razie proporcja pozytywne/negatywne zależy od morale (`clamp(morale/100 + bonus_pogodowy, 0.15, 0.9)` — wyższe morale = więcej pozytywnych).
- Pula: **155 wydarzeń** (pozytywne, negatywne, wyborowe — część sezonowa, część ogólna).
- **Wydarzenia z wyborem sprawdzają przystępność cenową**: jeśli gracza nie stać na którąkolwiek opcję wydarzenia (np. „Wędrowny bard” chce 3 złota za występ), całe wydarzenie jest pomijane przy losowaniu tego tygodnia — nie proponuje się wyboru, który faktycznie wyborem nie jest.
- Zwykłe wydarzenia negatywne (pech — np. susza) nie są w ten sposób filtrowane — to zamierzona strata, bezpiecznie przycinana do zera zapasów, gdyby ich zabrakło.

---

## 10. Fabuła — akty i cele (zarys, bez spoilerów)

| Akt | Nazwa | Tygodnie | Cel (żeby przejść dalej) |
|---|---|---|---|
| 0 | Zanim odejdziesz | 1-13 | Ratusz + Sad/Łąka/Pole zbudowane + określone zapasy każdego z 7 surowców |
| I | Ostrzeżenie | 14-26 | pokonać min. 2/3 etapów starcia z **Grotem** |
| II | Krew rodziny | 27-39 | min. 2/3 etapów starcia z **Martą** + rozbudowany Ratusz (poziom 2) |
| III | Twarzą w twarz | 40-52 | pełny Dowód w starciu z **Bogdanem** |
| IV | Głodny Cień | 53-59 | siła armii ≥ 20 i bezpieczeństwo ≥ 50 (gotowość na starcie z **Leszym**, w środku Aktu V) |
| V | Powrót Wiosny | 60-65 | zwyciężyć **Leszego** (tydzień 64) + ukończyć questy „Ślady w popiele” i „Rozmowa z Jadwigą” (patrz 12 — śledzone od Aktu II/III, ale wymagane dopiero jako część celu Aktu V) |

- Niespełnienie celu na ostatnim tygodniu aktu → **ekran porażki aktu** → przywrócenie dowolnego wcześniejszego checkpointu albo nowa gra.
- Każdy ukończony cel aktu: paczka surowców do magazynu, rosnąca z numerem aktu - `20 + akt×4` drewna, `20 + akt×4` kamienia, `10 + akt×4` złota (Akt 0: 20/20/10 → Akt V: 40/40/30).

---

## 11. Starcia z bossami

### 11.1. Grot (tydzień 26, koniec Aktu I) — czysta walka obronna

3 liniowe etapy, wspólna pula **30 ruchów**:

1. **Umocnienia**: zbierz 30 drewna + 20 kamienia (woda/zboże to szum).
2. **Pułapki**: zdetonuj `(6 − liczba_żołnierzy − (Palisada? 1 : 0))` bomb, min. 2, maks. 6.
3. **Starcie**: zbierz `(20 − liczba_żołnierzy × 3)` mieczy, min. 5, maks. 20. Waga losowania Miecza na planszy przycięta zależnie od **bezpieczeństwa** (30% normalnej wagi przy 0, 100% przy 100+) — patrz 11.5.

Wynik: 3/3 etapów → +15 złota, +15 drewna. 2/3 → -10% drewna i złota. ≤1/3 → nie spełnia celu Aktu I.

### 11.2. Marta (tydzień 39, koniec Aktu II) — budowanie zaufania, nie walka

3 etapy, wspólna pula **32 ruchy**:

1. **Poszlaki**: zbierz drewno i kamień w PRZEDZIALE (nie tylko minimum) — przesada resetuje etap i podnosi próg etapu 2.
2. **Impas**: złap `(8 − poziom_Kaplicy − (morale≥60? 1:0))`, przycięte do [5, 8], „chwil wahania” (jokery) — długie ścieżki (bomby) tylko **zwiększają** cel, nie pomagają.
3. **Prawda**: zbierz `(20 − morale/5)` Prawdy — waga losowania na planszy przycięta zależnie od **morale** (30% przy 0, 100% przy 100), patrz 11.5. Ukończenie z **5+ ruchami w zapasie** = pełne zaufanie (lepsze zakończenie).

Wynik: 3/3 + pełne zaufanie → +15 morale. 3/3 bez bonusu → +10 morale. 2/3 → brak nagrody. ≤1/3 → nie spełnia celu Aktu II.

### 11.3. Bogdan Kruk (tydzień 52, koniec Aktu III) — uspokój i zbierz dowody

Naprzemienny cykl **Furia ↔ Pęknięcie**, wspólna pula **40 ruchów**:

- **Furia** (8 ruchów na próbę): zbierz `max(10, 25 − bezpieczeństwo/4)` wody, żeby go uspokoić. Porażka → część spichlerza spłonie (-15%, albo -5% jeśli Marta ma pełne zaufanie i jeszcze nie użyła tej jednorazowej ulgi) i próba się powtarza.
- **Pęknięcie** (5 ruchów na okno): zbierz Dowód — cel łączny **20** w całej walce, licząc przez wszystkie okna. Waga losowania Dowodu przycięta zależnie od **morale** (patrz 11.5).

Kary za spalenie stosują się **zawsze**, niezależnie od wyniku. Sukces = brak dodatkowej nagrody poza fabularną — pełny Dowód wymagany do celu Aktu III.

### 11.4. Leszy (tydzień 64, w środku Aktu V) — finałowa walka na PŻ

Jedyne prawdziwe starcie na punkty życia, w **dwóch kolejnych ekranach** (Nawałnica → Serce Cienia), oba do wygrania w jednym podejściu (PŻ Wioski NIE odnawia się między nimi).

- **PŻ Wioski** = `100 + min(bezpieczeństwo, 40)` (maks. możliwe: **140** — bezpieczeństwo teoretycznie sięga +100, ale tu jest przycięte). **PŻ Leszego**: `max(90, 100 − siła_armii×1.5)` w **obu fazach** (minimum podniesione z 60/80 do **90**; baza Serca Cienia obniżona ze 130 przez 120 do **tej samej bazy co Nawałnica** — mniej PŻ niż wcześniej, w zamian za wyższą siłę startową i własną, mocniejszą pulę ruchów, patrz niżej).
- Plansza: miecz (obrażenia), tarcza (+1 osłony, limit 50, **zeruje się po każdym ruchu Leszego**), cień (zbieranie usuwa go z planszy I dodatkowo -5 do puli Cienia za kafelek), plus drewno/kamień/woda (bankowane na zdolności).
- **Próg wybuchu Cienia** zaczyna na **15** i trwale spada o 1 za każdym użyciem "Zagęszczenia cienia" (min. **10** - po osiągnięciu minimum ta umiejętność wypada z puli losowania Leszego) - im dłużej trwa walka, tym mniej kulek Cienia trzeba zostawić na planszy, żeby wybuchła. **Pula Cienia** = punkty w akumulatorze (rosną tylko od zbierania - patrz wyżej, w drugą stronę) + kulki Cienia **wciąż leżące na planszy**. Sprawdzane po KAŻDYM ruchu - gracza i Leszego, nie tylko co jego turę. Gdy pula ≥ próg → wybuch z **~700ms opóźnieniem** (licznik/pasek Cienia zostaje na pełnej wartości przez ten czas, z komunikatem "Cień osiąga próg - za chwilę eksploduje!", zamiast znikać w tej samej klatce co ostatnia dorzucona kulka): wszystkie kulki Cienia znikają z planszy, PŻ Wioski traci dokładnie tyle, ile pula wynosiła w chwili przekroczenia progu (może przekroczyć próg), pula wraca do 0.
- Leszy wykonuje ruch co **5 ruchów gracza**, losując z puli **przypisanej do bieżącej fazy** - Nawałnica i Serce Cienia **nie dzielą żadnych ruchów poza Uderzeniem** (wspólny, podstawowy atak obu faz; patrz `_onslaughtMoves`/`_heartOfShadowMoves`) - to naprawdę inny przeciwnik w fazie 2, nie ta sama lista z wyższymi liczbami.
  - **Nawałnica (7 typów)**: uderzenie (obrażenia + trwałe +1 siły), wyssanie surowca, zagęszczenie cienia (-1 do progu wybuchu), furia (podwaja następny cios, +1 siły), mgła (tasuje planszę + zamienia 20% w cień), zatrucie (3× -5 PŻ za kolejny ruch), głód (-10 do zbanowanych surowców).
  - **Serce Cienia (7 typów)**: uderzenie (jak wyżej) + 6 własnych:
    - **Pochłonięcie** — zjada cały Cień aktualnie leżący na planszy (pulę + kulki) i leczy się o tyle samo, ile pochłonął. Odwraca logikę Cienia z fazy 1: zamiast czekać na wybuch (kara dla gracza), staje się też zasobem bossa, więc nie da się już go bezkarnie zostawiać na planszy "na potem".
    - **Rozdarcie** — `12 + siła` obrażeń, ale Tarcza chroni tylko w **połowie** (efektywne pochłanianie = `tarcza ÷ 2`) - sama Osłona przestaje wystarczać jako jedyna obrona w tej fazie.
    - **Rozpacz** — czysty samo-buff: **+2 do siły** (dwa razy szybciej niż zwykłe Uderzenie), bez obrażeń tym razem.
    - **Skażenie** — zamienia **30%** losowych kafelków wprost w Cień, bez tasowania (mocniejszy, bardziej bezpośredni odpowiednik Mgły z fazy 1).
    - **Zaświat** — Leszy częściowo wycofuje się w zaświaty: kolejne **2 trafienia Mieczem** zadają tylko połowę obrażeń.
    - **Zachwianie Woli** — **trwale** obniża maksymalne PŻ Wioski o 10 (min. 30), przycinając też aktualne PŻ, jeśli akurat przekraczają nowy limit. Jedyny ruch w grze, który zmienia sam limit, nie tylko aktualną wartość - zresetowany do pełnej bazy tylko przez "Spróbuj ponownie" (patrz niżej), nigdy przez samo przejście między fazami.
- **Serce Cienia startuje z siłą 2** (zamiast 0) - "prawdziwa forma" nie musi się dopiero rozkręcać jak Nawałnica.
- **Siła Leszego rośnie z Uderzenia** (+1, PO rozstrzygnięciu tego ciosu, nie przed) **i z Rozpaczy** (+2, tylko Serce Cienia) - pozostałe ruchy jej nie zwiększają. Furia dolicza swój własny, niezależny +1.
- Przejście Nawałnica → Serce Cienia ma własny ekran z ilustracją (`assets/ui/leszy_serce_cienia.webp`, prompt w `docs/midjourney_prompts.md` sekcja C1b) - spada na małą ikonkę Cienia jako placeholder, dopóki plik nie istnieje.
- 9 zdolności gracza - **żadna nie zużywa ruchu** (nie przybliża kolejnej tury Leszego), w przeciwieństwie do zbierania na planszy:
  - Kontratak (25 wody) → -10 PŻ Leszemu
  - Osłona (25 kamienia) → +10 tarczy
  - Uzdrowienie (25 drewna) → +10 PŻ Wioski + usuwa zatrucie
  - Oczyszczenie (20 drewna + 20 kamienia) → zeruje pulę Cienia **i** usuwa wszystkie kulki Cienia z planszy
  - Modlitwa (20 wody + 20 drewna) → połowa obrażeń następnego ciosu
  - Uspokojenie (30 wody) → -3 do siły Leszego
  - Wzmocnienie muru (15 drewna + 15 kamienia) → +2 do progu wybuchu Cienia (przeciwdziała Zagęszczeniu cienia, przycięte do startowych 15)
  - Rozproszenie furii (15 wody, dostępne tylko gdy Furia aktywna) → natychmiast anuluje aktywną Furię, zanim zdąży podwoić następny cios
  - Obfitość (20 wody + 20 kamienia) → podwaja efekt kolejnych 3 zebranych ścieżek (Miecz, Tarcza, drewno/kamień/woda) - zużywa się jedna "szarża" na ścieżkę, niezależnie od jej długości; **Cień celowo wyłączony** (nie dubluje redukcji puli Cienia i nie zużywa na to szarży)
- Porażka (PŻ Wioski = 0) → ekran „Spróbuj ponownie” (pełny reset walki) albo powrót do wioski bez postępu tygodnia. Zwycięstwo w obu ekranach → cel Aktu V spełniony (patrz 10 - starcie przeniesione z Aktu IV na tydzień 64 w środku Aktu V).
- Waga losowania Miecza i Tarczy przycięta zależnie od **bezpieczeństwa** (patrz 11.5). Cień ma normalną wagę — to element zagrożenia, nie nagroda do zbierania.

### 11.5. Rzadsze surowce-cele w starciach

Miecz, Tarcza, Prawda i Dowód (surowce-cele specyficzne dla danego starcia) mają **niższą wagę losowania niż reszta planszy** — im słabszy odpowiedni wskaźnik wioski, tym rzadziej się pojawiają: `mnożnik = 0.3 + 0.7 × min(wskaźnik/100, 1)`, czyli od **30% normalnej wagi** (wskaźnik = 0) do **100%** (wskaźnik ≥ 100). Nigdy nie spada do zera — cel zawsze da się ukończyć, tylko wolniej.

| Surowiec | Starcie | Zależy od |
|---|---|---|
| Miecz (`sword`) | Grot (etap 3), Leszy | bezpieczeństwo |
| Tarcza (`shield`) | Leszy | bezpieczeństwo |
| Prawda (`truth`) | Marta (etap 3) | morale |
| Dowód (`evidence`) | Bogdan (Pęknięcie) | morale |

---

## 12. Questy poboczne (11)

Nie wygasają, można je ukończyć w dowolnym momencie gry, niezależnie od bieżącego aktu — dają jednorazową paczkę surowców do magazynu (dobraną tematycznie i pod skalę kosztów danego aktu), tak samo jak cel główny każdego aktu (patrz 10). „Akt” w tabeli to akt, w którym quest pojawia się w zakładce Cele (czyli od kiedy jego warunek faktycznie może zostać spełniony) — dla „Ostatnia lekcja” dodatkowo dopiero od tygodnia 7 (śmierć Antoniego), nie od początku Aktu 0.

Wyjątek: „Ślady w popiele” i „Rozmowa z Jadwigą” są śledzone i można je ukończyć już w Akcie II/III (kiedy realnie rozstrzyga się ich warunek), ale ich ukończenie jest DODATKOWO wymagane jako część celu głównego Aktu V (patrz 10) — jeśli gracz je pominie, dowie się o tym dopiero przy próbie zamknięcia gry.

| Quest | Akt | Nagroda | Warunek |
|---|---|---|---|
| Ostatnia lekcja | 0 (od tyg. 7) | +15 drewna, +15 kamienia | Ratusz poziom 2 |
| Dobry sąsiad | 0 | +10 zboża, +10 jabłka, +5 złota | Karczma zbudowana |
| Milczenie Jadwigi | 1 | +20 kamienia, +10 złota | Kaplica zbudowana |
| Wdowa po najemniku | 1 | +20 drewna, +15 kamienia, +10 złota | min. 2/3 etapów Grota + Karczma |
| Ostatni list | 2 | +20 złota, +10 trawy | odkrycie „Kartografia” |
| Marta incognito | 2 | +20 jabłka, +15 trawy, +10 złota | morale ≥ 70 |
| Ślady w popiele | 2 | +20 zboża, +15 wody, +15 złota | pełne zaufanie Marty (wymagane też do celu Aktu V) |
| Stary handlarz | 3 | +25 złota, +15 drewna | Rynek zbudowany |
| Rozmowa z Jadwigą | 3 | +20 kamienia, +20 złota | pełny Dowód u Bogdana (wymagane też do celu Aktu V) |
| Klątwa studni | 4 | +30 wody, +15 kamienia | Studnia poziom 2 |
| Ostatnia szarża | 4 | +30 drewna, +30 kamienia, +15 złota | siła armii ≥ 20 |

---

## 13. Komiksy

**30 paneli fabularnych**, po jednym co ~2-3 tygodnie, odblokowywane automatycznie po osiągnięciu przypisanego tygodnia. Rozłożone po aktach: Akt 0 (#1-5), Akt I (#6-10), Akt II (#11-15), Akt III (#16-20), Akt IV (#21-25), Akt V (#26-30) — każdy akt odpowiada osobnej porze roku w fabule.

- Komiks przypisany do tygodnia N odblokowuje się dopiero, gdy tydzień N **w pełni się zakończy** (nie w chwili, gdy gracz do niego dopiero dociera) — patrz `_showPendingComics`, wywoływane na końcu `_startWeek` z numerem właśnie zakończonego tygodnia, nie już zaktualizowanym `_week`.
- **Wyjątek dla 4 komiksów opisujących wynik starcia z bossem** (#10 Grot, #15 Marta, #20 Bogdan, #29 Leszy): dodatkowo zablokowane, dopóki dana walka nie zostanie faktycznie stoczona (sprawdzane po fladze wyniku, nie po numerze tygodnia) — inaczej dałoby się poznać wynik walki z zakładki Komiksy, zanim się ją stoczy. Ukryte też na liście w zakładce Komiksy (`ComicsView.hiddenComicNumbers`), nie tylko w automatycznym wyskakującym okienku.

## 15. Zapisy i checkpointy

- **Checkpoint zapisywany co tydzień** (nie tylko przed bossami) — pełna migawka stanu gry pod kluczem numeru tygodnia.
- Przy porażce aktu gracz wybiera dowolny wcześniej zapisany tydzień do przywrócenia, albo zaczyna od zera.
- Zapis jest odporny na starsze/usunięte identyfikatory (np. usunięty quest poboczny) — nie powoduje awarii przy wczytywaniu starszego zapisu.

## 16. Ustawienia wizualne

- **Styl planszy** (`BoardStyle`): `photo` (teksturowane tło sezonowe, domyślne) vs `classic` (płaski gradient dwukolorowy, stary wygląd).
- **Styl ikon surowców** (`ResourceIconStyle`): `orb` (szklana kula 3D z symbolem w środku, domyślne) vs `filled` (nieprzezroczysta kolorowa kula z wytłoczonym symbolem, pośredni styl) vs `classic` (jednolite kolorowe tło + prosta płaska ikona).
- Oba przełączniki dostępne w zakładce Statystyki, zapisywane trwale.

---

*Dokument wygenerowany na podstawie analizy kodu w `c:\Users\Darek\Desktop\rolnikGra\lib\` — stan na 23 sierpnia 2026.*
