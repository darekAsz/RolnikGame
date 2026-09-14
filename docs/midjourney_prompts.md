# Dług Kruka — Prompty do Midjourney

Osobna, robocza strona z gotowymi promptami do generowania komiksów gry "Rolnik" w Midjourney. Bazuje na opisach postaci z biblii fabuły (sekcja 12) i pełnych scenariuszach komiksów.

## Jak z tego korzystać

**Referencje postaci i wspólny styl są już wybrane** — każda postać ma finalny `--seed` i `--sref` (patrz sekcja A), a cała seria ma też jeden wspólny "master style" `--sref` (patrz sekcja A2), zapisane z konkretnych, zaakceptowanych obrazków. Nie trzeba już nic generować od nowa ani wybierać — po prostu używaj tych wartości, są już wliczone we wszystkie 30 promptów w Sekcji B.

1. **Sekcja A** — prompt referencyjny każdej postaci z jej `--seed` i `--sref` już dopisanym na końcu. To Twój "wzorzec" wyglądu.
2. **Sekcja B — każdy panel to OSOBNY obrazek, osobny gotowy prompt** (wróciliśmy do tego układu zamiast jednej strony z siatką paneli). Każdy komiks ma listę "Panel 1 / Panel 2 / ..." — każdy to własny, kompletny, gotowy do wklejenia prompt, z `--sref` master style (styl całej sceny) i `--oref` **jednej** priorytetowej postaci z tego kadru (`--ow 200`, dla lepszego trzymania twarzy — patrz sekcja "oref kontra sref" niżej, tam też wyjaśnienie dlaczego tylko jednej).
3. Parametry: `--ar 4:3` (kafelek poziomy, domyślny) lub `--ar 3:4` dla pionowego panelu/zbliżenia. `--style raw` ogranicza nadmierną stylizację MJ, `--sw 100` reguluje siłę stylu z `--sref` (podnieś, jeśli się "nie trzyma").
4. **Puste dymki zamiast tekstu, rozmiar zależny od długości kwestii, zawsze z jasnym adresatem** — w panelach, gdzie ktoś mówi, dopisany jest pusty dymek w rozmiarze dopasowanym do tego, ile tekstu tam faktycznie wejdzie, od najkrótszych kwestii po długie monologi. Same przymiotniki ("small", "medium") okazały się za słabą wskazówką dla MJ — dymki wychodziły śmiesznie małe (patrz zrzut ekranu w rozmowie) — więc każdy opis ma teraz konkretny punkt odniesienia: ułamek szerokości kadru (np. "spanning about a third of the panel width") albo, dla najkrótszych okrzyków, "co najmniej szerokość głowy postaci". Każdy dymek ma też jawnie zaznaczone, czyj jest — frazę `with its tail pointing directly at <postać>` zamiast samego "near" — żeby było jednoznaczne, kto mówi, nawet gdy w kadrze jest więcej niż jedna osoba. Panele bez dialogu w danym kadrze nie mają dymka (mają za to `no text`, żeby MJ nie dopisywał niczego przypadkiem).
5. **Bieda i rozbudowa wioski** — na starcie fabuły (komiksy #1-#2, Akt 0) wioska ma już dwa skromne domy (Antoniego + sąsiada), ale nic poza tym — żadnego ratusza, żadnych murów, błotniste ścieżki, łatane strzechy. Ratusz zbudowany w #2 ma wyglądać jak zwyczajny, niepozorny budynek — nie jak reprezentacyjna siedziba władzy (bo mechanicznie na starcie faktycznie niewiele daje, dopiero rozbudowa go czyni ważnym). W miarę postępu aktów (Akt I w górę) wioska może stopniowo wyglądać na bardziej rozwiniętą — to naturalne, bo gracz w tym czasie buduje kolejne budynki.
6. **Zasada "1 w pełni widoczna twarz" dotyczy tylko postaci z sekcji A (tych z własnym wzorcem/referencją)** — Kazimierza, Antoniego, Jadwigi, Bogdana, Marty, Grota. Jeśli w kadrze są dwie z nich naraz, tylko ta z `--oref` jest w pełni opisana; druga jest "poza kadrem" (głos/dłoń zza krawędzi, patrz niżej), bo MJ i tak nie dostanie jej referencji twarzy, więc lepiej, żeby nie musiała jej w pełni renderować. **Postacie bez własnej referencji (posłaniec, robotnik, kupiec, starzec, mieszkanka itd.) NIE podlegają temu ograniczeniu** — nie ma czyjej twarzy pilnować, więc mogą być normalnie w pełni widoczne obok postaci głównej. Pierwsza wersja tej zasady omijała też postacie bez referencji, co dawało dziwne, puste kadry (np. plac budowy bez robotnika mimo dialogu z nim) — poprawione.
7. **`--oref` "przecieka" na inne postacie w kadrze, jeśli waga jest za wysoka** — przy `--ow 200` twarz bezimiennego drugiego bohatera (robotnika, posłańca) wychodziła prawie identyczna jak twarz postaci referencyjnej. W panelach z dwiema osobami, gdzie druga nie ma referencji, obniżony jest teraz do `--ow 100`, a opis drugiej postaci ma jawnie wypisany silny kontrast wyglądu (inny wiek, budowa, kolor włosów, "a completely different build and coloring from the heir") — to jedyny sposób, żeby MJ ich nie sklonował.

### `--oref` kontra `--sref` — ważne rozróżnienie

Uwaga: w Midjourney V7 stary `--cref`/`--cw` został zastąpiony przez **Omni-Reference** (`--oref`/`--ow`) — dokument używa już nowej wersji.

- **`--sref <URL>`** = referencja **stylu** (paleta, światło, faktura pociągnięć) — używana tu tylko dla master style (sekcja A2), żeby wszystkie panele trzymały ten sam ogólny "look".
- **`--oref <URL>`** = referencja **postaci** (twarz/sylwetka/strój) — dużo silniej pilnuje, żeby dana postać faktycznie wyglądała jak w swoim wzorcu (sekcja A), zamiast tylko "w tym samym stylu". Pierwsza wersja dokumentu używała samego `--sref` też dla postaci, ale w praktyce twarze nie trzymały się wzorca (np. dorosły dziedzic wychodził jak dziecko) — stąd `--oref`.
- **Ważne ograniczenie `--oref`: przyjmuje tylko JEDEN obrazek referencyjny naraz** (w przeciwieństwie do starego `--cref`, gdzie dało się podać kilka URL-i). W panelach z więcej niż jedną postacią prompt zawiera `--oref` **tylko dla jednej, priorytetowej** postaci (domyślnie Kazimierza, jeśli występuje w kadrze — bo pojawia się w zdecydowanej większości paneli i jego rozpoznawalność ma największe znaczenie; w przeciwnym razie pierwszej wymienionej postaci). Pozostałe postacie w tym kadrze polegają tylko na opisie tekstowym + master `--sref`.
- Jeśli w konkretnym panelu bardziej zależy Ci na wierności innej postaci niż ta domyślnie wybrana (np. zbliżenie na twarz Antoniego, a nie Kazimierza) — po prostu podmień URL po `--oref` na tamtej postaci z sekcji A.
- `--ow` (Omni-Reference weight, domyślnie 100, sensowny zakres 50-250) reguluje siłę: wyżej (np. 300-400) = mocniejszy nacisk na twarz/strój z referencji kosztem swobody kompozycji, niżej = luźniejsza inspiracja. W dokumencie użyte jest `--ow 200` jako rozsądny środek — podnieś, jeśli podobieństwo dalej jest za słabe.

Blok stylu (już wliczony w każdy prompt niżej):
```
single comic panel, painterly semi-realistic folk illustration, Central-Eastern European rural village, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration
```

---

## A. Prompty referencyjne postaci (finalne, z --seed i --sref)

**Kazimierz**
```
painterly semi-realistic folk illustration, character reference sheet, young Eastern European male farmer heir named Kazimierz, late 20s, practical worn linen work coat in muted brown/green, tall leather boots, dark hair tied back practically, sun-weathered hands, determined tired eyes, neutral studio lighting, plain background --ar 2:3 --style raw --seed 418756596 --sref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2
```

**Antoni**
```
painterly semi-realistic folk illustration, character reference sheet, elderly Eastern European village elder, around 70, thin frail build, slightly hunched, grey beard, sparse white hair, deep warm smile-wrinkles around eyes, patched simple farmer's coat and wool vest, walking stick, gentle tired expression, neutral studio lighting, plain background --ar 2:3 --style raw --seed 3581243051 --sref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3
```

**Opis słowny Antoniego (bez referencji obrazkowej)** — na podstawie faktycznie wygenerowanego obrazka (patrz rozmowa). Wklej ten fragment bezpośrednio do dowolnego promptu z Antonim, jeśli sam `--oref` nie wystarcza (np. w panelu, gdzie priorytetowa jest inna postać, a Antoni i tak ma być rozpoznawalny):
```
elderly man in his 70s, messy swept-back silver-white hair, thick full grey-white beard and mustache covering most of the lower face, weathered ruddy sun-worn skin with deep wrinkles around the eyes, kind but weary expression, long worn tan/cream canvas coat with a brown leather repair patch on one shoulder and forearm, a dark olive-green knitted scarf or collar visible at the neckline, brown fingerless gloves, worn brown leather lace-up boots, slightly stooped posture
```

**Jadwiga**
```
painterly semi-realistic folk illustration, character reference sheet, sturdy elderly Eastern European wise woman, around 65, grey hair tied under a headscarf, stern weathered face with kind perceptive eyes, dark simple dress with apron, wooden rosary at her belt, neutral studio lighting, plain background --ar 2:3 --style raw --seed 2759188654 --sref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0
```

**Bogdan Kruk**
```
painterly semi-realistic folk illustration, character reference sheet, tall gravely built Eastern European estate owner, late 50s, gaunt from grief, greying short beard, deep-set exhausted eyes full of pain and anger, once-fine now worn dark long coat, neutral studio lighting, plain background --ar 2:3 --style raw --seed 2778408233 --sref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3
```

**Jan Kruk**
```
painterly semi-realistic folk illustration, character reference sheet, young Eastern European man, early 20s, light hair, bright ambitious hopeful eyes, confident smile, simple leather expedition vest, rope and pack, soft warm memory-glow lighting, plain background --ar 2:3 --style raw --seed 311252677 --sref https://www.midjourney.com/jobs/e4759b24-773e-4276-89e2-833998dab2d2?index=1
```

**Marta Kruk**
```
painterly semi-realistic folk illustration, character reference sheet, lean athletic Eastern European woman, late 20s, dark hair partly hidden under a hood, sharp watchful guarded expression, simple dark travel/scout clothing, small weapon at her belt, neutral studio lighting, plain background --ar 2:3 --style raw --seed 1098659428 --sref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0
```

**Grot**
```
painterly semi-realistic folk illustration, character reference sheet, stocky muscular mercenary captain, late 30s, scar across eyebrow, short cropped hair and beard, hardened pragmatic professional expression, reinforced leather armor with metal studs, neutral studio lighting, plain background --ar 2:3 --style raw --seed 3269946706 --sref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1
```

**Leszy — forma uśpiona**
```
painterly semi-realistic dark folklore illustration, ancient Slavic forest spirit, half-humanoid half-tree, deer-like antlers merging into branches, bark-like moss-covered skin, glowing pupil-less pale green eyes, dormant, resembling an ancient overgrown mossy statue or tree stump, still forest clearing, atmospheric --ar 2:3 --style raw --seed 3560442765 --sref https://www.midjourney.com/jobs/ac837e48-f4e6-4c6d-a93c-1f3e09cf0f47?index=2
```

**Leszy — forma przebudzona**
```
painterly semi-realistic dark folklore illustration, massive awakened Slavic forest spirit, sky-filling towering silhouette, deer-like antlers, bark and shadow skin, glowing pupil-less amber eyes, swirling black mist and shadow around it, predatory hungry expression, oppressive dark atmosphere --ar 2:3 --style raw --seed 3504634551 --sref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2
```

---

## A2. Master style — wspólny wzorzec stylu wioski (finalny)

To obrazek, który spina wizualnie całą serię — patrz punkt 6 w instrukcjach. Nie przedstawia konkretnej postaci ani konkretnej sceny z fabuły, tylko ogólny "look": paletę, światło, fakturę pociągnięć, styl budynków. Jego `--sref` jest już dopisany jako **pierwszy** w każdym z 30 promptów Sekcji B (przed srefami postaci) — nie trzeba nic więcej robić, jest gotowe do użycia.

```
painterly semi-realistic folk illustration, wide establishing shot of a Central-Eastern European rural village at golden hour, cluster of modest thatched-roof wooden cottages along a muddy dirt path, wooden fences, a stone well, patchy fields and a distant tree line, two distant unnamed villagers going about chores for scale (carrying a bucket, mending a fence), faces not the focus, warm muted earthy palette, soft directional golden light, subtle canvas grain, visible painterly brushwork texture, graphic novel illustration, atmospheric depth, no watermark --ar 3:2 --style raw
```

`--sref` master style: `https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1`

---

## A3. Mapa wioski — tło planszy budowy (zamiast rysowanej proceduralnie)

Plansza "Wioska" w grze (`village_board.dart`) rysuje teren, ścieżki i działki proceduralnie (CustomPainter), a budynki renderuje jako gotowe sprite'y z `assets/buildings/*.png` (np. `ratusz.png`) — **czyste low-poly rendery 3D w rzucie izometrycznym**: proste bryły, płaskie/miękkie cieniowanie, stonowana pastelowa paleta (piaskowy beż, szarość, brąz), gładkie krawędzie, bez malarskiej faktury, bez konturu tuszem, na czystym/przezroczystym tle. To ZUPEŁNIE inny styl niż painterly ilustracje komiksów (sekcja A2/B) — pierwsza wersja tego promptu pomyłkowo użyła stylu komiksowego (`--sref` master style), przez co wygenerowana mapa wyglądała jak malowana ilustracja z nieba i wzgórzami w tle, zamiast pasować do czystych brył budynków. **Poniższy prompt NIE używa już `--sref` komiksów** — styl opisany jest wprost, żeby dopasować się do `assets/buildings/`.

Ten prompt generuje gotowy obrazek do podłożenia jako tło zamiast rysunku proceduralnego — **sam teren, bez budynków, bez murów, bez ludzi i bez żadnych "+"** — bo budynki są renderowane osobno jako sprite'y nad tłem, a znaczniki "+" (puste, budowalne działki) to elementy UI dorysowywane przez appkę na wierzchu, w tych samych współrzędnych co dziś. Wystarczy podmienić tło i zostawić istniejące pozycje znaczników "+" bez zmian.

Kompozycja odpowiada wewnętrznemu układowi planszy (referencyjne płótno 700×1100, proporcja ok. 7:11): jedna kręta główna ścieżka biegnąca mniej więcej od góry do dołu, z niej odgałęzienia do polan/działek rozrzuconych po całym terenie (część tuż przy ścieżce, część odsunięta w boczne kąty), oraz lekko wyniesiona trawiasta polana bliżej górnej-środkowej części planszy (tam stoi Ratusz). Palisada NIE jest częścią tego tła — mur, jeśli zbudowany, dorysowuje się już osobno w kodzie. Perspektywa ma być **dokładnie pionowa, prosto z góry, jak zdjęcie satelitarne albo mapa** - bez widocznego horyzontu, bez ukośnego kąta. Poprzednie próby ("true top-down", "near-orthographic") wciąż dawały lekko ukośny kąt kamery ze skrawkiem horyzontu w rogu - ten prompt stawia opis kąta kamery na samym początku (MJ mocniej trzyma się słów bliżej początku promptu) i dokłada jawne `no horizon, no sky visible`.

```
directly overhead drone shot, camera pointing straight down at 90 degrees, flat top-down map view with zero perspective tilt, no horizon, no sky visible, low-poly 3D render, clean stylized mobile city-builder game asset, zoomed out wide shot showing the entire building plot from a greater distance, flat ground plane of a small empty village building site, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of soft green grass, tan dirt and warm brown paths, soft ambient occlusion shadows, gentle studio lighting, no buildings, no walls, no fences, no palisade, no enclosure, no people, no text, no watermark, one winding tan dirt path running from the top of the frame to the bottom with several smaller branching paths leading to at least twelve bare rectangular dirt clearings of varying sizes densely scattered across the grass, some clearings tucked into corners away from any path, a slightly raised open grassy clearing near the upper-center where the paths converge, the cleared plot blending seamlessly into surrounding open countryside with no border or edge, rolling green hills, a winding river and scattered trees visible only near the far edges of the frame, small distant patchwork fields in the corners --ar 7:11 --style raw
```

Uwagi:
- **Bez `--oref` i bez `--sref`** — to plansza terenu w stylu low-poly render, nie panel komiksowy, więc żadna z referencji postaci/stylu komiksów nie ma tu zastosowania. Styl trzyma się wyłącznie przez opis słowny.
- **Bez ogrodzenia/palisady** — pierwsza wygenerowana wersja dodała drewniany płot z bramami dookoła całej działki, mimo że nie było go w opisie (MJ najwyraźniej domyślił się "ogrodzonej wioski"). Prompt ma teraz jawne `no fences, no palisade, no enclosure`, żeby to wymusić — Palisada w grze i tak dorysowuje się osobno w kodzie, dopiero gdy gracz ją zbuduje.
- **Kamera coraz bardziej pionowo** — kolejne wersje (2, 3, 4) stopniowo prostowały kąt kamery, ale wciąż zostawał lekko ukośny. Piąta wersja stawia `directly overhead drone shot, camera pointing straight down at 90 degrees` na samym początku promptu i dodaje `no horizon, no sky visible` - jeśli to nadal nie wystarczy, kolejny krok to spróbować frazy `satellite view` albo `orthographic top view, architectural site plan style` zamiast "drone shot".
- Jeśli wygenerowany obrazek nadal wygląda zbyt malarsko/realistycznie, wzmocnij słowa kluczowe stylu na początku promptu (np. dodaj `3D render, Blender render, toy diorama`) i rozważ osobno wygenerowanie pojedynczego budynku tym samym promptem + `--cw 0` jako szybki test, czy w ogóle trzyma się low-poly.
- Jeśli po wygenerowaniu polany/ścieżki nie trafiają dość blisko obecnych pozycji znaczników "+", prościej przesunąć same znaczniki w kodzie (to tylko współrzędne) niż wymuszać na MJ dokładny układ.
- Wariant z murem (do użycia po zbudowaniu Palisady) można dogenerować osobno, dopisując do promptu: `a low simple wooden palisade fence enclosing the entire plot, with two open gate gaps at the top and bottom of the frame` — na razie nieużywany, bo mur już działa dobrze jako osobna warstwa w kodzie.

---

## A4. Kamieniarz — budynek (poziom 1 i 2)

`assets/buildings/kamieniarz.png` już istnieje w grze (chatka z czerwonym dachem, kamienny piec/silos ze stożkowym lejem na szczycie, drewniany żuraw-bocian z bloczkiem i liną unoszący kamień, stół roboczy z narzędziami, jeden stos ciosanych kamiennych bloków) - te dwa prompty odtwarzają ten sam styl i układ, gdyby trzeba było wygenerować świeżą wersję poziomu 1, oraz wyraźnie rozbudowaną wersję poziomu 2 (w grze poziom 2 podwaja tygodniową produkcję kamienia - patrz `HomeShell._productionAmountFor` - więc wizualnie ma to wyglądać na "dwa razy tyle roboty"). Kod obecnie ładuje jeden obrazek na budynek bez rozróżnienia poziomu (`kBuildingImageScale`/`BuildingImageCache` w `village_board.dart`) - użycie osobnego pliku dla poziomu 2 wymaga też małej zmiany w kodzie, nie tylko podmiany assetu.

Styl budynków (rzut 3/4, nie "z góry" jak mapa z A3) - bez `--sref`/`--oref`, bez odniesienia do stylu komiksów:

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small stone quarry workshop, single-story cottage with warm cream/tan walls and a terracotta gable roof, one dark window and an open dark wooden door, beside the cottage a stone kiln silo with a conical grey funnel top, a simple wooden A-frame hoist crane with a rope and pulley lifting a small stone block, a wooden workbench with a mallet and chisel leaning against it, one small stack of cut rectangular stone blocks on the ground, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan walls, terracotta roof, grey stone and brown wood, plain solid pure green chroma-key background, soft ambient occlusion shadows, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2** (rozbudowany, ok. dwa razy więcej "produkcji" w kadrze)
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger stone quarry workshop, single-story cottage with warm cream/tan walls, a terracotta gable roof and a small side extension, two windows and an open dark wooden door, beside the cottage two stone kiln silos side by side each with a conical grey funnel top, a taller double wooden hoist crane with rope and pulley lifting two stone blocks at once, a larger wooden workbench with several tools laid out, two full stacks of cut rectangular stone blocks stacked higher than the level-one version, a small stone-laden handcart parked nearby, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan walls, terracotta roof, grey stone and brown wood, plain solid pure green chroma-key background, soft ambient occlusion shadows, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

Uwagi:
- Proporcja `--ar 4:3` dobrana pod istniejący `kamieniarz.png` (szeroki układ budynek+plac, nie kwadrat) - jeśli wygenerowany kadr jest za ciasny/za luźny, dostosuj.
- Poziom 2 celowo powtarza niemal te same frazy co poziom 1 (ten sam budynek, ta sama paleta) - zmienione są tylko liczebniki (dwa silosy, dwa bloki, wyższe stosy) i dodane detale (przybudówka, wózek) - to pomaga MJ trzymać wizualną spójność między poziomami zamiast wymyślać całkiem inny budynek.
- Jeśli poziom 2 wyjdzie zbyt podobny do poziomu 1 (różnica niezauważalna), spróbuj podbić wagę różnicy dopisując na końcu `--no small quarry, single stack` (negatywny prompt) albo jawnie: `noticeably busier and larger than a small starter version`.
- **Przezroczyste tło - to wymaga osobnego kroku po wygenerowaniu, nie da się tego uzyskać samym promptem.** Midjourney zawsze zwraca płaski, nieprzezroczysty obrazek (bez kanału alfa) - żadne słowa w prompcie ("transparent background" itp.) tego nie zmienią, MJ i tak doda jakieś tło. W grze `ratusz.png`/`dom.png` mają prawdziwą przezroczystość (PNG RGBA) i dlatego wtapiają się w trawę bez białego prostokąta - a świeżo podmieniony `kamieniarz.png`/`kamieniarz_2.png` to zwykły RGB bez kanału alfa (stąd biały prostokąt widoczny na zrzucie ekranu z gry). Prompt zamieniony jest teraz na jednolite, nasycone zielone tło (`plain solid pure green chroma-key background`) zamiast białego - to dużo łatwiej usunąć automatycznie niż biel (biel czasem myli się z jasnymi elementami samego budynku), np. narzędziem typu remove.bg, funkcją "Usuń tło" w Photoshopie/GIMP-ie ("Color to Alpha" na zielonym), albo wbudowanym removerem w Midjourney (przycisk edycji obrazka). Dopiero PO usunięciu tła i zapisaniu jako PNG z kanałem alfa plik nadaje się do podmiany w `assets/buildings/`.

---

## A6. Pozostałe budynki wioski — poziom 1 i 2 (14 budynków)

Ten sam styl i ta sama logika co w A4 (Kamieniarz), zastosowana do reszty budynków wioski - każdy ma już swój obrazek poziomu 1 w `assets/buildings/*.png` (np. `studnia.png` - kryta studnia z daszkiem, `kuznia.png` - chata z kuźnią i kowadłem na zewnątrz), więc prompty "Poziom 1" odtwarzają ten ustalony wygląd, a "Poziom 2" to wyraźnie większa/bogatsza wersja tego samego budynku (więcej sprzętu/zapasów w kadrze - analogicznie do podwojenia produkcji w kodzie). Ratusz i Palisada mają własną, osobną logikę i nie są tu ujęte.

**Ważna poprawka względem A4, wyciągnięta z prób generowania Kamieniarza:** jeśli budynek stoi na piaszczystej/ziemistej "podkładce" z miękkim, rozmytym cieniem odchodzącym od tej podkładki w tło, usunięcie tła później (patrz uwaga o przezroczystości w A4) jest dużo trudniejsze - cień płynnie przechodzi tonalnie w kolor podkładki, więc nie da się ich rozdzielić samym progiem koloru przy późniejszym wycinaniu. Dlatego poniższe prompty jawnie proszą o `no ground shadow, no drop shadow` - budynek ma "unosić się" nad czystym tłem, tak jak `ratusz.png` (bez podkładki, bez cienia), co już samo w sobie ułatwia późniejsze wycięcie tła.

Wspólny blok stylu (już wliczony w każdy prompt niżej): `low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw`

### Dom (dodatkowy dom, populacja)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small peasant cottage, cream/tan walls, a thatched straw roof, one dark window, a simple wooden door, a small stack of firewood leaning against the wall, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan walls and straw-yellow roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger peasant cottage with a small side extension and a low attic dormer window, cream/tan walls, a thatched straw roof, two windows, a wooden door, a small wooden fence enclosing a tiny garden patch, a larger stack of firewood, a barrel by the door, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan walls and straw-yellow roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Dom zaniedbany (dodatkowe domy przed odbudową — stan "zaniedbany", wciąż zamieszkany) — ✅ wpięty w kod

Dwa z pięciu dodatkowych domów startują jako zaniedbane (bez bonusu do populacji, patrz `home_shell.dart` — `decrepit`) i wracają do zwykłego wyglądu Domu (Poziom 1 wyżej) dopiero po odbudowie przez gracza. **To nie ruina** — mieszkają w nim ludzie od zawsze, po prostu w gorszych warunkach niż reszta wioski, zanim gracz zdąży się nimi zająć (nie od razu po przybyciu). Grafika w `assets/buildings/dom_zaniedbany.webp`, wyświetlana przez `_DecrepitHouseImageCache` w `village_board.dart`.

**Uwaga o stylu:** obecnie wgrany plik jest malarski/szczegółowy, nie w ustalonym stylu "low-poly clay render" reszty budynków (patrz `dom.webp` dla porównania) - widoczna różnica na planszy wioski. Prompt poniżej daje wersję w spójnym stylu, gdybyś chciał/a to ujednolicić.

```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, a modest peasant cottage in worse repair than average but clearly still lived in, weathered cream/tan walls with a few patched mismatched boards, a thinning thatched roof with a couple of rough patched sections, one small window with a simple mismatched wooden shutter, a worn but functional wooden door, a thin wisp of smoke rising from a small chimney, a small unkempt woodpile, a couple of chickens pecking nearby, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted dull earthy pastel palette of weathered tan walls and greyed straw roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Sklep (sklep, odblokowuje zakładkę Sklep)

Pierwsza wersja opisywała otwarty stragan (bez ścian) - wygenerowany obrazek wyszedł jako stoisko targowe, nie budynek, i nie pasował do reszty (wszystkie inne to zamknięte budowle ze ścianami i dachem). Poprawiona wersja poniżej opisuje wprost zamknięty budynek sklepu, z witryną i towarem widocznym przez okno/przy wejściu, zamiast otwartego stołu pod markizą.

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small village general store, a compact wooden building with cream/tan plank walls, a terracotta gable roof, a single wooden door, a shop window with a few goods displayed on the sill, a hanging wooden signboard above the door, a couple of sacks and a woven basket stacked beside the entrance, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette with a warm terracotta roof accent, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village general store with a small side extension, cream/tan plank walls, a terracotta gable roof, a wooden door, two shop windows with goods displayed on the sills, a hanging wooden signboard above the door, several sacks, small barrels and woven baskets stacked by the entrance, a small handcart of extra goods parked beside it, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette with a warm terracotta roof accent, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Rynek (rynek, wymiana surowców)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, a small village market corner, two wooden market stalls with striped fabric awnings facing each other, wooden crates, baskets of produce and small sacks of grain arranged on the stalls, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette with a warm orange awning accent, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village market square, four wooden market stalls with striped fabric awnings arranged around a small open square, crates, baskets of produce, sacks of grain and stacked clay jars, a small wooden signpost in the center, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette with a warm orange awning accent, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Studnia (studnia, produkcja wody)

`studnia.png` już istnieje (kryta studnia z dwuspadowym daszkiem na czterech słupkach, kamienna cembrowina) - poziom 1 poniżej odtwarza ten wygląd.

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, a small covered village well, round stone well wall, a wooden gabled roof on four wooden posts, a wooden crossbeam under the roof, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of grey stone and terracotta roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger covered village well, wider round stone well wall with a proper wooden crank and windlass, a rope and bucket hanging over the opening, a taller wooden gabled roof on four sturdy posts, a small stone water trough beside the well, a few clay water jugs on the ground, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of grey stone and terracotta roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Browar (browar, morale)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small village brewhouse cottage, cream/tan walls, a terracotta gable roof, a chimney, a large copper brewing kettle standing outside beside the cottage, a couple of wooden barrels stacked nearby, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette with a warm copper accent, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village brewhouse with a small side extension, cream/tan walls, a terracotta gable roof, two chimneys, two large copper brewing kettles standing outside, many more wooden barrels stacked in neat rows, a small handcart loaded with barrels, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette with a warm copper accent, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Kaplica (kaplica, zmniejsza ryzyko zepsucia + morale)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small wooden village chapel, whitewashed walls, a steep terracotta roof, a modest wooden bell tower with a small bell, a simple wooden cross on top, one arched window, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of soft white walls and terracotta roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village chapel with stone-trimmed corners and a small side chapel wing, whitewashed walls, a steep terracotta roof, a taller wooden bell tower with a bigger bell, a wooden cross on top, two arched windows with soft stained-glass coloring, a small wooden fence around a tiny garden, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of soft white walls and terracotta roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Karczma (karczma, populacja)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small two-story village tavern, timber-framed cream walls, a terracotta gable roof, a hanging wooden signboard above the door, a couple of wooden barrels and a bench outside, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan and dark timber accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger two-story village tavern with an attached side wing, timber-framed cream walls, a terracotta gable roof, a hanging wooden signboard, several wooden barrels, a small outdoor seating area with a table and benches, string of small lanterns under the eaves, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan and dark timber accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Koszary (koszary, rekrutacja/bezpieczeństwo)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small wooden barracks building, plain timber walls, a simple flat-pitched roof, a wooden weapon rack with a few spears and shields beside the entrance, a straw training dummy nearby, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of weathered brown timber and grey metal accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger wooden barracks with a small watchtower attached, plain timber walls, a simple flat-pitched roof, two wooden weapon racks with spears, shields and bows, two straw training dummies, a small fenced training yard, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of weathered brown timber and grey metal accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Magazyn (magazyn, pojemność magazynowa)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, a simple large wooden storage barn, weathered plank walls, a broad gable roof, a wide double door, a few wooden crates and cloth sacks stacked outside, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of weathered brown wood, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, two connected large wooden storage barns side by side, weathered plank walls, broad gable roofs, wide double doors, many wooden crates, cloth sacks and stacked barrels outside, a loading cart, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of weathered brown wood, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Piekarnia (piekarnia, produkcja zboża/chleba)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small village bakery cottage, cream/tan walls, a terracotta gable roof, a stone bread oven built onto the side with a glowing warm opening, a wooden cooling rack with a few loaves of bread, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan walls and golden bread accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village bakery with a small side extension, cream/tan walls, a terracotta gable roof, two stone bread ovens with glowing warm openings, two wooden cooling racks full of loaves of bread, sacks of flour stacked by the door, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan walls and golden bread accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Spichlerz (spichlerz, produkcja jabłek + ryzyko głodu)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, a small wooden granary raised on short stilts to keep it dry, plank walls, a steep shingled roof, a short wooden ladder leading to the entrance, a couple of grain sacks and a basket of apples on the ground, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm brown wood and red apple accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, two wooden granaries raised on short stilts side by side, plank walls, steep shingled roofs, wooden ladders leading to the entrances, many grain sacks and several baskets full of apples on the ground, a small handcart loaded with produce, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm brown wood and red apple accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Szkoła (uczelnia, odkrycia)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small village schoolhouse, cream stone-trimmed walls, a terracotta gable roof, a small bell mounted above the entrance, one arched window, a wooden bench outside, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of soft cream walls and terracotta roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village academy with a small clock tower, cream stone-trimmed walls, a terracotta gable roof, a bell in the tower, two arched windows, a small courtyard with a wooden bench and a globe on a stand visible through the doorway, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of soft cream walls and terracotta roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Tartak (tartak, produkcja drewna)

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small village sawmill workshop, weathered plank walls, a simple gable roof, a hand-cranked wooden saw rig with a large circular blade beside the workshop, a stack of cut logs and a small pile of sawn planks, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm brown wood, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger village sawmill workshop with a small side extension, weathered plank walls, a simple gable roof, a taller wooden saw rig with a large circular blade and a small waterwheel beside it, a bigger stack of cut logs and several neat piles of sawn planks, a loaded handcart, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm brown wood, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

### Kuźnia (kuźnia, produkcja złota)

`kuznia.png` już istnieje (chata ze strzechą + kowadło, młotki, obcęgi, kupka węgla obok) - poziom 1 poniżej odtwarza ten wygląd.

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, small half-timbered blacksmith cottage, cream walls with dark wooden beams, a straw-thatched roof, a chimney, an open-sided forge yard beside the cottage with an anvil, a hammer, tongs and a small pile of black coal, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan and dark timber accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger half-timbered blacksmith cottage with a covered forge extension, cream walls with dark wooden beams, a straw-thatched roof, two chimneys, an open-sided forge yard with two anvils, several hammers and tongs, a larger pile of black coal, a small cart loaded with iron ingots, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of warm tan and dark timber accents, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

Uwagi:
- Każdy prompt jest samodzielny/gotowy do wklejenia. Poziom 1 i 2 danego budynku celowo powtarzają niemal te same frazy (ta sama paleta/budynek), zmieniając głównie liczebność i skalę sprzętu/zapasów - ten sam trik co w A4, żeby MJ trzymał spójność wizualną między poziomami.
- `--ar 4:3` jak w A4/A5 - dostosuj, jeśli konkretny budynek wychodzi za ciasny/za luźny w kadrze.
- To samo dotyczy usuwania tła co w A4 - zielone tło ułatwia automatyczne wycięcie, ale i tak wymaga osobnego kroku po wygenerowaniu (remove.bg / Photoshop / GIMP), zanim plik trafi do `assets/buildings/`.

---

## A7. Tło planszy zbiorów — pory roku i walki z bossami

Dziś tło planszy (`SeasonBackground` + `Season.boardGradientColors` w `models/season.dart`) to płaski dwukolorowy gradient plus proceduralnie rysowane cząsteczki (płatki wiosną, deszcz jesienią, śnieg zimą, nic latem) - żadnej właściwej grafiki. Starcia z bossami w ogóle nie mają własnego tła - używają tego samego gradientu co pora roku, w której akurat wypada dany tydzień (Grot = lato, Marta = jesień, Bogdan = zima, Leszy = wiosna). Te osiem promptów generuje właściwe tło - **płaską, widzianą z góry powierzchnię/"tacę do gry"**, po której poruszają się kulki (nie scenę z horyzontem, patrz doświadczenie z mapą wioski w A3) - w tym samym stylu low-poly co reszta gry.

Wspólny blok stylu: `low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw`

### Pory roku

**Wiosna** (`Season.spring` - świeża zieleń, płatki)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, fresh spring meadow ground, soft young green grass, a few scattered pink cherry-blossom petals, tiny budding sprouts, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Lato** (`Season.summer` - złote pola)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, sun-baked golden wheat field ground, warm golden-yellow dry grass texture, a faint scatter of loose wheat husks, warm bright sunlight, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Jesień** (`Season.autumn` - deszcz, opadłe liście)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, damp autumn forest floor ground, scattered fallen amber and rust-orange leaves over dark soil, a few wet puddle glints, muted overcast light, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Zima** (`Season.winter` - śnieg)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, snow-covered ground, soft pale blue-white snow texture, delicate frost crystal patterns, a few small icicle-like details at the frame edges, cool pale light, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

### Walki z bossami

**Grot** (tydz. 26 - najazd, obóz wojenny)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, trampled muddy war-camp ground, dark churned earth with scattered footprints, a few dropped arrows and embers glowing faintly, tense warm orange-red lighting, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Marta** (tydz. 39 - napięta konfrontacja o zmierzchu)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, quiet forest-edge dirt ground at dusk, soft moss patches between packed earth and pale dry grass, a faint scatter of fallen leaves, cool dusky purple-blue light, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Bogdan** (tydz. 52 - gniew, spalony magazyn)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, scorched warehouse-yard ground, dark ash and charred wood fragments over packed earth, a few glowing embers, dramatic warm red-orange firelight, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Leszy** (tydz. 59 - mroczny, ożywiony las)
```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, dark twisted forest-floor ground, gnarled bare roots winding across black soil, faint glowing purple-violet mist seeping between the roots, eerie dim shadow-lit atmosphere, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

**Wypaczona wiosna** (Akt IV-V, tydz. 53-65 — "druga wiosna") — ✅ wpięta w kod

`Season.dart` liczyłby porę roku czysto cyklicznie (`(tydzień-1) ÷ 13 mod 4`), więc bez tej zmiany tygodnie 53-65 dostawałyby dokładnie to samo tło co Akt 0. `boardImagePathForWeek(week)` (`lib/models/season.dart`) zwraca teraz `assets/boards/wiosna_wypaczona.webp` od tygodnia 53 zamiast zwykłej wiosny - `harvest_screen.dart` już z tego korzysta.

**Uwaga o stylu:** obecnie wgrany plik jest w stylu malarskim (jak komiksy), nie w ustalonym stylu "low-poly" reszty tekstur pór roku poniżej - widoczna różnica przy porównaniu z `wiosna.webp`/`lato.webp` itd. Prompt poniżej daje wersję w spójnym stylu, gdybyś chciał/a to ujednolicić.

```
low-poly 3D render, clean stylized mobile match-3 game board surface, true top-down flat playing surface texture, no horizon, no sky, seamless edge-to-edge surface filling the whole frame, spring meadow ground turning sickly, patches of withering grey-green grass shot through with thin dark creeping root-veins, a few wilted cherry-blossom petals, faint sickly violet-green glow seeping from the cracks, tense dim light, soft flat pastel shading, minimal geometric detail, no ink outlines, no painterly texture, subtle soft shadows for depth only, no distinct objects sitting on top of the surface, no people, no text, no watermark --ar 1:1 --style raw
```

Żeby to faktycznie zadziałało w grze, `Season.boardAsset` (lub odpowiednik przekazywany do `HarvestGrid`/plansz zbiorów) musiałby dostać dodatkowy warunek na `week >= 53`, zwracający nowy plik zamiast `wiosna.webp` - to osobna, mała zmiana w kodzie, nie tylko podmiana assetu.

Uwagi:
- `--ar 1:1` bo siatka zbiorów jest kwadratowa (6×6 kafelków) - dopasuj, jeśli kontener w grze akurat jest wyraźnie niekwadratowy.
- Każde tło musi wypełniać CAŁĄ ramkę bez marginesu/obwódki - w kodzie kulki renderują się bezpośrednio na tym tle jako osobna warstwa nad nim, więc obrazek powinien być jednolitą, "nieskończoną" fakturą, a nie kompozycją z wyraźnym środkiem/krawędziami.
- To NIE wymaga usuwania tła (to jest samo tło, w przeciwieństwie do budynków w A4-A6) - obrazek zapisuje się wprost jako plik JPG/PNG bez przezroczystości.
- Cząsteczki (płatki/deszcz/śnieg) generowane proceduralnie w `SeasonBackground` mogą zostać jako osobna, ruchoma warstwa NAD tym nowym statycznym tłem - nie trzeba ich domalowywać w promptach (stąd brak płatków/deszczu/śniegu w opisach powyżej, poza wiosną, gdzie parę nieruchomych płatków na ziemi to co innego niż animowane opadające).

---

## A8. Kulki surowców (wszystkie typy)

Dziś każdy kafelek na planszy to proceduralna szklista kula (radialny gradient + cień, `_CellWidget` w `harvest_grid.dart`) z płaską ikoną SVG (`assets/icons/*.svg`) wyśrodkowaną w środku. Te dwanaście promptów (wszystkie `ResourceType`) generuje gotowe kulki zamiast tego.

**Poprawki po kolejnych próbach:** pierwsza wersja próbowała pokazać surowiec jako fakturę POWIERZCHNI kuli (np. drewno = kula z usłojeniem drewna) - zbyt subtelne przy małym rozmiarze kafelka. Druga wersja (kula + symbol) generowała dobre kule, ale symbol lądował JAK OZDOBA POSTAWIONA NA WIERZCHU kuli (np. kłos zboża sterczący z góry jak antenka), zamiast być widoczny W ŚRODKU - tak jak w grze dziś (`_CellWidget`: gradientowa kula, ikona wyśrodkowana wewnątrz). Ta wersja opisuje wprost symbol **osadzony/widoczny przez środek przezroczystej, szklistej kuli** ("embedded... visible through the glossy translucent front surface like inside a glass orb"), z jawnym zaprzeczeniem "not sitting on top, not above the ball" - kolor kuli dokładnie odpowiada `ResourceType.color` z kodu.

Wspólny blok stylu: `low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy color, a single bold 3D symbol embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw`

**Trawa** (`grass`, kolor #4CAF50)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy medium-green color, a single bold 3D tuft of grass blades embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Zboże** (`grain`, kolor #D4A017)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy mustard-gold color, a single bold 3D wheat ear embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Drewno** (`wood`, kolor #8B5A2B)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy warm brown color, a single bold 3D cut wood log with visible end-grain rings embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Kamień** (`stone`, kolor #8A8D91)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy grey color, a single bold 3D chunky rock boulder embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Woda** (`water`, kolor #3A8DDE)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy bright blue color, a single bold 3D water droplet shape embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Złoto** (`coin`, kolor #FFC107)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy golden-amber color, a single bold 3D coin with an embossed stamp embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Jabłko** (`apple`, kolor #D8402F)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy red color, a single bold 3D apple with a small brown stem and a green leaf embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Miecz** (`sword`, kolor #AEB4BC, tylko starcia z bossami)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy light steel-grey color, a single bold 3D short sword embedded glowing upright at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Prawda** (`truth`, kolor #C9A66B, tylko starcie z Martą)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy warm tan-gold color, a single bold 3D rolled parchment scroll with a ribbon embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Dowód** (`evidence`, kolor #6B4A2F, tylko starcie z Bogdanem)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy dark brown color, a single bold 3D closed diary journal book embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Tarcza** (`shield`, kolor #4A7FB5, tylko starcie z Leszym)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy medium blue color, a single bold 3D round shield emblem embedded glowing upright at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Cień** (`shadow`, kolor #2B2033, tylko starcie z Leszym)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, translucent glossy dark purple-black color, a single bold 3D wispy dark smoke-flame shape with faint glowing violet eyes embedded glowing at the center of the ball, visible through the glossy translucent front surface like inside a glass orb, not sitting on top, not above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

Uwagi:
- **To wymaga usunięcia tła** (jak budynki w A4-A6) - zielone tło + `no ground shadow, no drop shadow` ułatwia automatyczne wycięcie, ale to wciąż osobny krok po wygenerowaniu, zanim plik trafi do gry.
- Kolory kul podane przy każdej nazwie to dokładne wartości z `ResourceType.color` w kodzie (`models/resource_type.dart`) - jeśli MJ odda inny odcień, warto poprawić w prompt na słowny opis bliższy realnemu heksowi (np. "warm amber-yellow" zamiast "golden-yellow"), zamiast zostawiać "z grubsza podobny" kolor.
- Podłączenie w kodzie: dziś `_CellWidget` rysuje kulkę proceduralnie (gradient + `SvgPicture.asset(type.assetPath)` na środku) - podmiana na gotowy obrazek oznacza zastąpienie całego `BoxDecoration`/`RadialGradient` bloku w `harvest_grid.dart` pojedynczym `Image.asset` per surowiec (analogicznie do `BuildingImageCache` dla budynków), a nie tylko podmianę ikony w środku. To dodatkowa zmiana w kodzie, osobna od samego wygenerowania obrazków - daj znać, jeśli mam ją zrobić po wygenerowaniu kulek.
- `--ar 1:1` i wycentrowana kompozycja są tu ważniejsze niż w budynkach - kulka musi dobrze wypełniać okrągły kafelek bez dużych pustych marginesów.
- 5 surowców bojowych (Miecz/Prawda/Dowód/Tarcza/Cień) pojawia się tylko na planszach starć z bossami (patrz `kBattleOnlyResourceTypes` w `models/resource_type.dart`) - reszta (7) to zwykła ekonomia wioski.

---

## A9. Ratusz — budynek (poziom 1 i 2)

`assets/buildings/ratusz.png` już istnieje w grze i jako jedyny budynek ma prawdziwą przezroczystość (PNG RGBA, bez białego/zielonego tła do wycinania) - dotychczasowy wygląd to czteroboczna wieżowa strażnica/zameczek z chorągiewką, co nie pasuje do reszty (uboga wioska, nie warowny gród). Poniższe prompty odchodzą od "zameczka", ale nie idą w drugą skrajność (gołą świetlicę) - to ma być najważniejszy, najbardziej solidny budynek wioski, wyraźnie okazalszy niż zwykła chata czy karczma, tylko bez kamiennych wież, murów obronnych i chorągwi. Dwupiętrowy drewniano-murowany dom starosty/dom zebrań: częściowo kamienna podmurówka, porządny gontowy dach (nie strzecha), mały drewniany dzwon na niskiej wieżyczce nad wejściem, rzeźbiony ganek. Ratusz nie ma dziś żadnego poziomu 2 (nie ma wpisu w `kBuildingImageAssetsLevel2` w `village_board.dart`, rysowany jest osobną ścieżką kodu niezależną od pętli standardowych/małych budynków) - poniższe prompty dają tę wersję jako poziom 1 oraz wyraźnie okazalszą wersję poziomu 2, w tym samym stylu co reszta budynków (A4/A6).

**Poziom 1**
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, sturdy two-story village hall, the largest and most important building in the village, lower half built of grey fieldstone, upper half timber-framed with cream plaster infill, a proper gabled shingle roof, a small wooden bell tower with an open belfry rising above the entrance, a carved wooden porch canopy over a wide double door, a few glazed windows with wooden shutters, a couple of wooden barrels and a notice post by the entrance, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of grey stone, warm cream plaster, dark timber and a weathered wood-shingle roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

**Poziom 2** (wyraźnie okazalszy)
```
low-poly 3D render, clean stylized mobile city-builder game asset, isometric elevated 3/4 view, an expanded larger sturdy two-story village hall with a side wing, the largest and most important building in the village, lower half built of grey fieldstone, upper half timber-framed with cream plaster infill, a proper gabled shingle roof, a taller wooden bell tower with a bigger open belfry and bell rising above the entrance, a wider carved wooden porch canopy with two supporting posts over a grand double door, several glazed windows with wooden shutters, a small flower box under one window, a couple of wooden barrels, a notice post and a low stone-edged flowerbed by the entrance, soft flat pastel shading, minimal smooth geometric shapes, clean rounded edges, no ink outlines, no painterly texture, muted earthy pastel palette of grey stone, warm cream plaster, dark timber and a weathered wood-shingle roof, plain solid pure green chroma-key background, no ground shadow, no drop shadow, gentle studio lighting, no text, no watermark --ar 4:3 --style raw
```

Uwagi:
- Proporcja `--ar 4:3` dobrana pod istniejący `ratusz.png` (szeroki układ), tak jak przy pozostałych budynkach.
- Poziom 2 celowo powtarza niemal te same frazy co poziom 1 (te same materiały, ta sama paleta) - zmienione są tylko detale (skrzydło boczne, większa wieżyczka, kwietnik) - analogicznie do reguły z A4/A6.
- Celowo "w połowie drogi" między poprzednią wersją-zameczkiem (za bogato, za warownie) a wcześniejszą bardzo skromną świetlicą (za biednie jak na najważniejszy budynek wioski) - kamień+drewno, gontowy dach i mała wieżyczka z dzwonem dają wrażenie wagi/ważności bez zamku i chorągwi.
- **Podłączenie w kodzie wymaga osobnej zmiany, nie tylko podmiany assetu** - Ratusz jest dziś rysowany osobnym blokiem `if (ratuszBuilt) { ... }` w `village_board.dart` (nie przez pętle `kStandardBuildingKinds`/`kSmallBuildingKinds`, które już generycznie przekazują `upgraded:`), więc dodanie `BuildingKind.ratusz` do `kBuildingImageAssetsLevel2` samo w sobie nic nie zmieni, dopóki ten osobny blok też nie zacznie przekazywać `upgraded:` do `BuildingImageCache.get`. Daj znać, jeśli mam to dopiąć po wygenerowaniu grafiki poziomu 2.
- Ponieważ `ratusz.png` ma już prawdziwy kanał alfa (nie zielone tło), świeżo wygenerowany obrazek i tak będzie wymagał usunięcia tła (jak każdy inny budynek w A4-A6) - `plain solid pure green chroma-key background, no ground shadow, no drop shadow` w prompcie ułatwia to później.

---

## A10. Bomba i Joker (specjalne kafelki)

W odróżnieniu od 12 typów surowców w A8, Bomba i Joker NIE potrzebują własnej szklanej kuli w tle - gra już rysuje pod nimi proceduralną kolorową kulę (`_bombColor`/`_jokerColor` w `_TileView` w `harvest_grid.dart`, ciemnoszara dla bomby, fioletowa dla jokera), więc te dwa prompty opisują sam symbol jako samodzielną ikonę, nie kulkę-z-symbolem-w-środku jak w A8.

**Bomba** (`assets/icons/bomb.svg` dziś, target: `assets/icons/bomb.png`)
```
low-poly 3D render, clean stylized mobile match-3 game special-tile icon, a round black cartoon bomb with a glossy dark metal body and a subtle highlight, a curled lit fuse on top with a small glowing orange spark, the bomb itself is the whole icon, no ball or sphere wrapper around it, minimal geometric shapes, no ink outlines, soft rim light, clean rounded highlight, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Joker** (`assets/icons/joker.svg` dziś, target: `assets/icons/joker.png`)
```
low-poly 3D render, clean stylized mobile match-3 game special-tile icon, a glossy faceted purple star-shaped gem crystal with sparkling highlights and a soft inner glow, the gem itself is the whole icon, no ball or sphere wrapper around it, minimal geometric shapes, no ink outlines, soft rim light, clean rounded highlight, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

Uwagi:
- `--ar 1:1` tak jak w A8 (kafelek jest okrągły/kwadratowy, nie prostokątny).
- Kolor gemu jokera (fioletowy) dobrany pod `_jokerColor = Color(0xFF9B5DE5)` z kodu, żeby pasował do koloru proceduralnej kuli za nim - jeśli wygenerowany odcień odbiega, popraw słowny opis koloru w prompt na bliższy temu heksowi.
- Tak jak w A8, MJ i tak doda jakieś tło (zielone tu, do usunięcia) - `plain solid pure green chroma-key background, no ground shadow, no drop shadow` ułatwia późniejsze wycięcie.
- Podłączenie w kodzie: `bomb.svg`/`joker.svg` są dziś jedynymi ikonami specjalnymi renderowanymi jako `SvgPicture.asset` wewnątrz proceduralnej kuli (`_TileView`) - podmiana na PNG nie wymaga zmiany logiki `usesImageOrb` (ta flaga celowo pomija `special != SpecialTile.none`, więc bomba/joker zawsze zostają na procedularnej kuli, niezależnie od rozszerzenia pliku) - wystarczy podmienić assety i ścieżki w `harvest_grid.dart` (`'assets/icons/bomb.svg'`/`'assets/icons/joker.svg'`) na `.png`, `SvgPicture.asset` na `Image.asset` w tych dwóch miejscach.

---

## A11. Kulki surowców — styl klasyczny (jednolite tło, płaska ikona)

Alternatywa dla A8 (szklana 3D kula) - gracz może w Statystykach przełączyć wygląd ikon surowców na "Starsze" (patrz `ResourceIconStyle`/`ResourceIconStyleStorage` w kodzie), co dziś pokazuje ręcznie odtworzone, bardzo proste ikony SVG (`assets/icons/*_classic.svg`) - te 12 promptów generuje docelowo lepszą, właściwie wygenerowaną wersję tego samego "starego" stylu do podmiany. W przeciwieństwie do A8 (przezroczysta szklana kula, symbol widoczny "w środku") tu chodzi o płaski, kreskówkowy design mobile-game: **jednolite kolorowe tło wypełniające cały krążek** (nie szkło, nie gradient trójwymiarowej kuli) z prostą, grubą, dwu-trzytonową ikoną na wierzchu - dokładnie taki wygląd, jaki daje dziś proceduralne renderowanie `_TileView` w `harvest_grid.dart` (gradientowa kula w kolorze `ResourceType.color` + wyśrodkowana płaska ikona), tylko lepszej jakości niż ręcznie rysowane prostokąty/koła z A11 sprzed tego promptu.

Wspólny blok stylu: `flat vector mobile game resource icon, a single bold simple icon centered on a plain solid color circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw`

**Trawa** (`grass`, tło #4CAF50)
```
flat vector mobile game resource icon, a single bold simple tuft-of-grass-blades icon centered on a plain solid medium-green (#4CAF50) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Zboże** (`grain`, tło #D4A017)
```
flat vector mobile game resource icon, a single bold simple wheat-ear icon centered on a plain solid mustard-gold (#D4A017) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Drewno** (`wood`, tło #8B5A2B)
```
flat vector mobile game resource icon, a single bold simple cut-log-with-end-grain-rings icon centered on a plain solid warm brown (#8B5A2B) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Kamień** (`stone`, tło #8A8D91)
```
flat vector mobile game resource icon, a single bold simple chunky-rock-boulder icon centered on a plain solid grey (#8A8D91) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Woda** (`water`, tło #3A8DDE)
```
flat vector mobile game resource icon, a single bold simple water-droplet icon centered on a plain solid sky-blue (#3A8DDE) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Złoto** (`coin`, tło #FFC107)
```
flat vector mobile game resource icon, a single bold simple coin-with-embossed-star-stamp icon centered on a plain solid amber-yellow (#FFC107) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Jabłko** (`apple`, tło #D8402F)
```
flat vector mobile game resource icon, a single bold simple apple-with-stem-and-leaf icon centered on a plain solid red (#D8402F) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Miecz** (`sword`, tło #AEB4BC)
```
flat vector mobile game resource icon, a single bold simple short-sword icon centered on a plain solid steel-grey (#AEB4BC) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Prawda** (`truth`, tło #C9A66B)
```
flat vector mobile game resource icon, a single bold simple rolled-parchment-scroll-with-ribbon icon centered on a plain solid tan-gold (#C9A66B) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Dowód** (`evidence`, tło #6B4A2F)
```
flat vector mobile game resource icon, a single bold simple closed-diary-journal-book icon centered on a plain solid dark brown (#6B4A2F) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Tarcza** (`shield`, tło #4A7FB5)
```
flat vector mobile game resource icon, a single bold simple round-shield-emblem icon centered on a plain solid medium-blue (#4A7FB5) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Cień** (`shadow`, tło #2B2033)
```
flat vector mobile game resource icon, a single bold simple wispy-dark-smoke-flame-shape-with-faint-glowing-violet-eyes icon centered on a plain solid dark purple-black (#2B2033) circular badge filling the entire circle edge to edge, subtle soft highlight near the top for gentle depth, clean minimal shapes, crisp flat shading with at most two tones, no 3D rendering, no glossy reflections, no glass or sphere effect, no ink outlines, centered composition, no text, no watermark --ar 1:1 --style raw
```

Uwagi:
- Symbole i kolory identyczne jak w A8 (te same 12 typów, ten sam `ResourceType.color`) - zmieniony jest tylko styl renderowania (płaski, jednolite tło zamiast szkła).
- **Tu, w przeciwieństwie do A8/A10, tło ma zostać w finalnym pliku** - to nie jest kolor do usunięcia (nie ma `chroma-key`/`no watermark background removal` w prompcie), tylko właściwe, docelowe tło ikony. Jeśli MJ i tak doda jakiś margines/teksturę poza okręgiem odcinającym się od jednolitego tła, przytnij obrazek do samego koła zamiast usuwać tło jak w A8.
- **Zrobione** - wygenerowane obrazki już podłączone jako `assets/icons/*_classic.png`, `_classicAssetPath` w `models/resource_type.dart` na nie wskazuje. `usesImageOrb` w `_TileView` (`harvest_grid.dart`) sprawdza tylko rozszerzenie `.png` (nie rozróżnia orb/classic), więc oba style automatycznie pomijają proceduralną kulę-tło - nie wyszło kółko na kółku.

---

## A12. Ikona aplikacji i grafika reklamowa (Google Play)

Dwa osobne assety do wpisu w Google Play, w innym stylu niż A8/A10/A11 (to nie są kafelki na planszy) - ikona aplikacji nawiązuje do stylu budynków (A4/A6, niski-poly 3D), grafika reklamowa do stylu komiksów (A2, malarska ilustracja folk) jako bardziej klimatyczny, marketingowy obrazek.

**Ikona aplikacji** (docelowo 1024×1024 - z niej dopiero eksportuje się mniejszą ikonę 512×512 do wpisu w Play Console, to nie jest osobny prompt, tylko zmniejszenie tego samego pliku)
```
low-poly 3D render, clean stylized mobile game app icon, a single bold glossy black raven landing with spread wings on a rustic wooden fence post, a small thatched-roof cottage silhouette and a few wheat stalks in the background, warm golden-amber gradient background evoking dusk, bold simple shapes with a strong clear silhouette readable at small size, soft rim light on the raven, minimal geometric detail, no ink outlines, centered composition filling the frame edge to edge, no text, no watermark, no logo --ar 1:1 --style raw
```

**Grafika reklamowa** (feature graphic, 1024×500 - baner na górze wpisu w sklepie)
```
cinematic wide establishing shot, painterly semi-realistic folk illustration, golden wheat fields stretching toward a small Central-Eastern European village with modest thatched-roof cottages and a wooden fence at dusk, a single black raven flying low across the amber sky in the foreground, warm muted earthy palette, soft golden directional light, subtle canvas grain, atmospheric depth, graphic novel illustration, no characters in close-up, no text, no watermark, no logo --ar 2:1 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1
```

Uwagi:
- Ikona łączy oba motywy tytułu: kruk (nazwisko rodu, "Dług Kruka") i chata/pszenica (Rolnik) - ma czytelnie działać jako mały, uproszczony kształt (telefon pokazuje ją przy ~48dp), stąd nacisk na "strong clear silhouette", nie drobne detale.
- **Bezpieczna strefa adaptacyjnej ikony**: Android maskuje ikony launchera do koła/kwadratu z zaokrąglonymi rogami (zależnie od launchera) - trzymaj najważniejszy element (kruka) w środkowych ~66% kadru, żeby nic ważnego nie ucięło się przy maskowaniu.
- `--ar 2:1` dla grafiki reklamowej to najbliższe standardowe MJ potrafi wygenerować względem docelowych 1024×500 (dokładnie 2.048:1) - po wygenerowaniu przytnij do dokładnego rozmiaru w edytorze.
- Grafika reklamowa celowo bez tekstu/logo - Google i tak nakłada własny tytuł/ikonę obok niej we wpisie, a dopisany przez MJ tekst zwykle wychodzi nieczytelny/krzywy.
- Podłączenie: to nie są assety w `assets/` (gra ich nie ładuje w runtime) - trafiają bezpośrednio do Play Console przy wpisie sklepowym (patrz `docs/google_play_publishing.md`), a ikona aplikacji dodatkowo do `android/app/src/main/res/mipmap-*/ic_launcher.png` (wymaga wygenerowania wariantów w kilku rozdzielczościach, np. przez pakiet `flutter_launcher_icons` - daj znać, jeśli mam to spiąć po wygenerowaniu obrazka).

---

## A13. Kulki surowców — styl pośredni (wypełniona, nieprzezroczysta kula)

Trzeci styl ikon surowców, pomiędzy A8 (szklana, przezroczysta kula - symbol widoczny "przez" powierzchnię jak w środku szkła) a A11 (płaskie, jednolite tło - żadnej trójwymiarowości). Tu kula ma **pozostać trójwymiarowa i błyszcząca, ale nieprzezroczysta** - pełny, nieprzeźroczysty kolor wypełniający całą kulę, a symbol nie unosi się "w środku" jak w A8, tylko jest wytłoczony/wyryty na przedniej powierzchni kuli (relief podążający za jej krzywizną) - jak pieczęć na wosku albo emblemat na metalowej kuli, nie naklejka.

**Ważne rozróżnienie względem A8, wynikające z wcześniejszej poprawki w tamtej sekcji**: tam problemem było, że symbol lądował jak ozdoba POŁOŻONA NA WIERZCHU kuli (dosłownie nad nią). Tutaj symbol MA być na przedniej powierzchni kuli - ale jako wytłoczenie/relief zintegrowany z kulistym kształtem, nie płaska naklejka i nie oddzielny obiekt unoszący się nad kulą. Stąd `embossed... as a raised relief carving that follows the curve of the sphere's surface` zamiast samego "on top".

**Paleta kolorów zmieniona względem A8/A11, żeby kulki lepiej się od siebie odróżniały.** Oryginalna paleta (współdzielona z `ResourceType.color`) miała cztery grupy kolorów zbyt blisko siebie: trzy żółto-złote (zboże, złoto, prawda), dwa brązy (drewno, dowód), dwie szarości (kamień, miecz) i dwa niebieskie (woda, tarcza) - w miniaturce kafelka na planszy różnią się głównie symbolem, a nie kolorem, co utrudnia szybkie rozpoznawanie typu surowca. Poniższe 5 kolorów zostało przesuniętych (reszta bez zmian): zboże → pomarańcz zamiast musztardowego złota, prawda → jasny pergamin zamiast złota, dowód → głęboki bordowy zamiast brązu, miecz → jasne srebro zamiast szarości, tarcza → głęboki granat zamiast średniego błękitu. Złoto zostaje jedynym "żółtym" kolorem, drewno jedynym brązem, kamień jedynym szarym, a woda jedynym jasnoniebieskim.

Wspólny blok stylu: `low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque color filling the entire sphere, a single bold 3D symbol embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw`

**Trawa** (`grass`, kolor #4CAF50)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque medium-green color filling the entire sphere, a single bold 3D tuft of grass blades embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Zboże** (`grain`, kolor A13 #E0791E - zmieniony z #D4A017, żeby nie mylić się ze złotem/prawdą)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque burnt-orange color filling the entire sphere, a single bold 3D wheat ear embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Drewno** (`wood`, kolor #8B5A2B)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque warm brown color filling the entire sphere, a single bold 3D cut log with visible end-grain rings embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Kamień** (`stone`, kolor #8A8D91)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque grey color filling the entire sphere, a single bold 3D chunky rock boulder embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Woda** (`water`, kolor #3A8DDE)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque sky-blue color filling the entire sphere, a single bold 3D water droplet embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Złoto** (`coin`, kolor #FFC107)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque amber-yellow color filling the entire sphere, a single bold 3D coin with an embossed star stamp embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Jabłko** (`apple`, kolor #D8402F)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque red color filling the entire sphere, a single bold 3D apple with stem and leaf embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Miecz** (`sword`, kolor A13 #C9D3DC - zmieniony z #AEB4BC, żeby nie mylić się z kamieniem)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque bright polished silver color filling the entire sphere, a single bold 3D short sword embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Prawda** (`truth`, kolor A13 #EDE0C3 - zmieniony z #C9A66B, żeby nie mylić się ze złotem/zbożem)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque pale ivory parchment color filling the entire sphere, a single bold 3D rolled parchment scroll with a ribbon embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Dowód** (`evidence`, kolor A13 #5B2A3B - zmieniony z #6B4A2F, żeby nie mylić się z drewnem)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque deep wine-maroon color filling the entire sphere, a single bold 3D closed diary journal book embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Tarcza** (`shield`, kolor A13 #1F3A5F - zmieniony z #4A7FB5, żeby nie mylić się z wodą)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque deep navy-blue color filling the entire sphere, a single bold 3D round shield emblem embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

**Cień** (`shadow`, kolor #2B2033)
```
low-poly 3D render, clean stylized mobile match-3 game gem icon, smooth glossy round ball, solid opaque dark purple-black color filling the entire sphere, a single bold 3D wispy dark smoke-flame shape with faint glowing violet eyes embossed into the front of the ball as a raised relief carving that follows the curve of the sphere's surface, not a flat sticker, not floating above the ball, soft rim light, clean rounded highlight, minimal geometric shapes, no ink outlines, plain solid pure green chroma-key background, no ground shadow, no drop shadow, centered composition, no text, no watermark --ar 1:1 --style raw
```

Uwagi:
- Symbole identyczne jak w A8/A11 (te same 12 typów), ale **kolory 5 z 12 kulek zostały celowo przesunięte względem `ResourceType.color`** (patrz wyżej) - zboże, prawda, dowód, miecz i tarcza. Pozostałe 7 (trawa, drewno, kamień, woda, złoto, jabłko, cień) mają kolor identyczny jak w A8/A11.
- **Konsekwencja tej zmiany**: jeśli A13 trafi kiedyś do gry, kulki na planszy będą miały inny kolor niż te same surowce pokazywane gdzie indziej w UI kolorem z `ResourceType.color` (np. paski/odznaki w innych ekranach) - do decyzji wtedy, czy warto zaktualizować `ResourceType.color` do nowej palety (ujednolicenie w całej grze) czy zostawić A13 jako wariant z własną, niezależną paletą tylko dla kulek na planszy.
- **Tło do usunięcia, tak jak w A8** (nie jak w A11) - kula jest tu nieprzezroczysta, ale samo tło dookoła niej nadal trzeba wyciąć (`plain solid pure green chroma-key background` do usunięcia przez remove.bg/GIMP itd.), bo MJ i tak doda jakieś tło wokół obiektu.
- Jeśli wygenerowany symbol znów zacznie wyglądać jak coś oddzielnego, przyklejonego nad kulą (ten sam problem co pierwotnie w A8) - wzmocnij frazę np. `carved directly into the ball's own surface, part of the same continuous sphere, no gap between symbol and ball`.
- **Podłączone w kodzie** (2026-08-23): trzecia wartość `ResourceIconStyle.filled` (`lib/services/resource_icon_style_storage.dart`), pliki `assets/icons/*_filled.png` z `_filledAssetPath` w `models/resource_type.dart`, trzecia opcja "Pośrednie" w przełączniku w Statystykach. Wygenerowane obrazki miały widoczny zielony odblask środowiska (odbicie `pure green chroma-key background` na błyszczącej powierzchni kuli, najbardziej zauważalne na jasnych/metalicznych materiałach jak złoto czy miecz) - skorygowane programowo (dociągnięcie odcienia każdej kuli do jednego koloru z zachowaniem oryginalnego cieniowania/highlightów).

---

## B. Prompty do komiksów (30) — osobny prompt na każdy panel

Każdy panel to własny, gotowy do wklejenia prompt — z `--sref` master style i tylko tych postaci, które faktycznie są w tym kadrze. Puste dymki mają rozmiar dopasowany do długości kwestii (patrz punkt 4 w instrukcjach).

### Akt 0 — Wiosna I

**#1 (tydz. 1) "Nowy dzień"** — Kazimierz, Antoni

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small poor and underdeveloped Central-Eastern European rural village with only two modest thatched-roof houses and a muddy dirt path, no other buildings, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, a horse-drawn cart entering the small poor village at sunrise, wide establishing shot showing how little is there, early spring, fresh budding trees --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small poor Central-Eastern European village, weathered cottage porch, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, frail smiling elderly grey-bearded grandfather standing alone on the porch, greeting an approaching visitor heard but not shown, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the grandfather, ready for text to be added later, early spring morning light --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, modest rustic cottage interior, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the young heir fully visible, an elderly hand entering from off-panel handing him a ring of keys and old ledger books, sizeable empty speech bubble entering from off-panel at the edge of the frame, roomy enough for a full sentence, ready for text to be added later, soft window light --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, cottage table interior, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir studying a worn, neglected village map spread on a table, only two buildings marked on it, thoughtful expression --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, cottage window overlooking a mostly empty burned village below, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the frail elderly grandfather fully visible standing at the window pointing down toward the village, wide view below showing only two or three modest houses still standing far apart from each other, surrounded by many more empty burned-out plots, blackened foundation stones, charred timber skeletons and ash-grey scorched earth where other houses used to be, overgrown weeds reclaiming the ruins, heavy sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the grandfather, ready for text to be added later, early spring morning light --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, close-up of a hand gripping a spade in freshly tilled soil, empty rectangular caption box at the top of the panel, ready for text to be added later, early spring light --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**#2 (tydz. 3) "Pierwsze cegły"** — Kazimierz, Antoni

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small poor and underdeveloped Central-Eastern European rural village, cottage table interior, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, the young heir reviewing building plans at a table, the sparse two-house village map in the background --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small poor village, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, two men standing together at a construction site with clearly different faces and builds: the heir fully visible directing the work, and right beside him a much older, heavyset, balding worker with a bushy grey mustache, weathered face, and a completely different build and coloring from the heir, in a rough sleeveless tunic gripping a wooden beam, simple wooden foundations for a plain, modest one-room town hall rising behind them, no grander than an ordinary house, dust in the air, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the worker, and a second empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, both ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 100 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, weathered cottage porch, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, the elderly grandfather on the porch with a cup of tea, watching proudly, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, small poor village, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, a montage panel, the sun arcing across the sky in three overlapping positions, a plain small town hall rising in stages, still humble and unremarkable in size --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, small poor village, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the finished town hall, small and unassuming, nothing grander than the two houses beside it, the grandfather fully visible clapping from the porch, cheering someone off-panel, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, evening campfire, warm muted earthy palette, soft directional firelight, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the grandfather fully visible speaking warmly by the campfire, an empty seat and a second bowl across the fire suggesting unseen company, large empty speech bubble spanning about half the panel width, roomy enough for a full sentence with its tail pointing directly at the grandfather, ready for text to be added later, dusk sky --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

**#3 (tydz. 5) "Cień Kruka"** — Antoni

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small farmyard, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, a calm morning in the farmyard, the elderly grandfather fully visible feeding chickens, the young heir only partially visible carrying a bucket of water in the background --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, wooden fence, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, close-up of a raven landing on a wooden fence, staring directly ahead, ominous stillness --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, farmyard, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, the elderly grandfather freezing in fear, a clay cup slipping from his hand and shattering on the ground, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, farmyard, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the young heir fully visible running over worried, calling out to his grandfather, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, farmyard, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, the grandfather turning away, face half in shadow, staring toward a distant dark tree line, brushing off the question, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, close-up of the raven taking flight, heading toward the distant forest --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**#4 (tydz. 7) "Antoni odchodzi"** — Kazimierz, Antoni, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, cottage doorway, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no text, no watermark, solo shot, only one person in frame, the frail grandfather fully visible doubled over in a violent coughing fit, one hand clutching his chest, the other gripping a doorframe for support, mouth open mid-cough, alone --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, cottage doorway, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no watermark, close-up, the heir seen from behind filling most of the frame, standing right in the wide-open cottage doorway, the open door pushed back against the wall, stepping inside, alarmed, close enough to be speaking directly to someone just off-panel, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, cottage exterior path, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no text, no watermark, solo shot, only one person in frame, an elderly wise woman in a headscarf fully visible, arriving alone with a basket of herbs, worried determined expression --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no watermark, the wise woman fully visible kneeling beside a sickbed, a clearly occupied bed with a visible blanket-covered body and a head resting on the pillow, face turned away and not shown, her own face betraying she knows more than she says, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no watermark, solo shot, only one person in frame, the grandfather fully visible lying in bed, pale and weak, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no watermark, solo shot, only one person in frame, the grandfather fully visible, gripping a sleeve entering from off-panel, whispering urgently while the heir is away fetching water, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no watermark, solo shot, only one person in frame, the wise woman fully visible, eyes full of tears she refuses to shed, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 8
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, somber mood, no watermark, solo shot, only one person in frame, the grandfather fully visible lying in bed, calm and resigned, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the grandfather, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/89ee6832-ad7c-4e85-9b15-cbca94d84def?index=3 --ow 200 --v 7
```

Panel 9
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom at night, warm muted earthy palette, dim candlelight, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, night falling over the cottage, the heir fully visible asleep exhausted in a chair --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 10
```
single comic panel, painterly semi-realistic folk illustration, cottage bedroom at dawn, warm muted earthy palette, soft dawn light, subtle canvas grain, graphic novel illustration, no watermark, dawn light, the heir fully visible waking with a stricken expression, beside him in the bed a still, blanket-covered body, one pale hand resting outside the covers, face turned away and not shown, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, empty rectangular caption box at the bottom of the panel, both ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#5 (tydz. 12) "Pogrzeb"** — Kazimierz, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small poor and still underdeveloped village of only a few modest thatched-roof cottages, muddy dirt path, grey overcast sky, cold flat light, desaturated muted palette, subtle canvas grain, graphic novel illustration, no text, no watermark, a somber scene of quiet village mourning, a handful of villagers dressed in dark simple mourning clothes, heads bowed, moving slowly and silently, one figure carrying a plain wooden coffin board, another laying wilted flowers, black cloth tied around a doorframe, no laughter or bright colors anywhere, heavy grieving atmosphere --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small poor village, overcast, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, funeral day, a plain wooden coffin, a simple gravestone and a modest farewell feast prepared by the village --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village cemetery, overcast, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, a modest funeral gathering at the village cemetery, the wise woman giving the eulogy, large empty speech bubble spanning about half the panel width, roomy enough for a full sentence with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village cemetery, overcast, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, the wise woman fully visible approaching after the ceremony, a quiet, weighty remark, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village cemetery, overcast, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible, puzzled, asking a question toward someone off-panel, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, wide overlooking shot from a distant hill, overcast, muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, in the foreground on the hill a lone horseman watching silently, below in the far distance a small poor village of only a few modest thatched-roof cottages, and beside it a tiny village cemetery with a cluster of dark-clothed mourners gathered around a grave, tiny and far away but clearly a funeral ceremony --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, distant hill, overcast, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, the horseman turning his horse and riding away, empty rectangular caption box at the bottom of the panel, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

### Akt I — Lato

**#6 (tydz. 14) "Wizyta"** — Kazimierz

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, a modest Central-Eastern European village of a few simple wooden thatched-roof houses along a muddy dirt path, visible fences and a well, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, an older, pale, gaunt messenger with slicked-back blond hair and sharp angular features, in a fine dark cloak and polished boots, mounted on a black horse, riding into the village between the houses --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, the dirt path through the middle of the modest village, a couple of simple thatched-roof houses visible on either side, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, two figures with clearly different faces and builds facing off in the village: the heir standing firm, and before him an older, pale, gaunt messenger with slicked-back blond hair and sharp angular features, a completely different build and coloring from the heir, in a fine dark cloak and polished boots, mounted on a black horse, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the messenger, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 100 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, in the middle of the modest village, a couple of simple thatched-roof houses visible in the background, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, solo shot, only one person in frame, the heir fully visible replying he doesn't know the name, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, in the middle of the modest village, a couple of simple thatched-roof houses visible in the background, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, solo shot, only one person in frame, an older, pale, gaunt messenger with slicked-back blond hair and sharp angular features, fully visible, mounted on a black horse, in a fine dark cloak and polished boots, giving a cold smile, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the messenger, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, in the middle of the modest village, a couple of simple thatched-roof houses visible in the background, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, solo shot, only one person in frame, the heir fully visible asking what traditions he means, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, in the middle of the modest village, a couple of simple thatched-roof houses visible in the background, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, solo shot, only one person in frame, an older, pale, gaunt messenger with slicked-back blond hair and sharp angular features, fully visible, mounted on a black horse, in a fine dark cloak and polished boots, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the messenger, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, the dirt path through the modest village, a couple of simple thatched-roof houses visible on either side, bright harsh summer daylight, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, an older, pale, gaunt messenger with slicked-back blond hair and sharp angular features, in a fine dark cloak and polished boots, mounted on a black horse, turning to leave the village with a parting threat, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the messenger, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**#7 (tydz. 17) "W ciemności"** — Kazimierz

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, village at night, warm muted earthy palette, moonlight, subtle canvas grain, graphic novel illustration, no text, no watermark, night, a quiet village, a shadowy figure moving near the storehouse --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village storehouse, morning light, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no text, no watermark, morning, the heir discovering the damage, scattered supplies and a broken fence --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village path, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, worried villagers murmuring nearby, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the villager woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village path, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, an old villager lowering his voice, uneasy, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the old villager, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village path, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible asking who he means, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village path, warm muted earthy palette, soft directional light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, a much older, stooped, white-haired villager with a wrinkled weathered face, fully visible, in a patched wool tunic, flustered and hurrying away, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the old villager, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**#8 (tydz. 20) "Jadwiga mówi (część 1)"** — Kazimierz, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, summer afternoon, subtle canvas grain, graphic novel illustration, no watermark, the heir fully visible visiting the wise woman, who is seated with her back mostly turned inside a small wooden chapel, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, subtle canvas grain, graphic novel illustration, no watermark, the wise woman setting down her teacup after a long silence, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, subtle canvas grain, graphic novel illustration, no watermark, the wise woman explaining the grandfather and Bogdan were once close partners, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible asking what happened, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, subtle canvas grain, graphic novel illustration, no watermark, the wise woman fully visible, her face tightening, gesturing toward the distant forest, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, subtle canvas grain, graphic novel illustration, no watermark, the wise woman saying she'll say no more, a promise of silence, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm interior window light, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir left alone, staring out the window toward the forest --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#9 (tydz. 23) "Trybut"** — Kazimierz, Grot

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, village entrance, harsh midday summer light, subtle canvas grain, graphic novel illustration, no watermark, a scarred stocky mercenary captain in studded leather armor entering the village with armed thugs, an ominous remark about the village's new master, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the captain, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village square, harsh midday summer light, subtle canvas grain, graphic novel illustration, no watermark, the mercenary captain's threatening line about the village, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the captain, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village square, harsh midday summer light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, solo shot, only one person in frame, the heir fully visible through gritted teeth asking what he wants, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village square, harsh midday summer light, subtle canvas grain, graphic novel illustration, tense mood, no watermark, the scarred stocky mercenary captain fully visible, replying about a toll, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the captain, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village square, harsh midday summer light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible asking who sent him, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village square, harsh midday summer light, subtle canvas grain, graphic novel illustration, no watermark, the scarred stocky mercenary captain fully visible, mocking smile, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the captain, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, village entrance, harsh midday summer light, subtle canvas grain, graphic novel illustration, no watermark, the captain leaving with his men, a parting threat, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the captain, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

**#10 (tydz. 26) "Starcie z Grotem"** — Kazimierz, Grot

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, village behind a wooden palisade, late summer golden light, subtle canvas grain, graphic novel illustration, no watermark, Grot returning with a larger force, finding the village fortified behind a wooden palisade with armed defenders, surprised, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at Grot, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village palisade, late summer golden light, dynamic action, subtle canvas grain, graphic novel illustration, no text, no watermark, a wide dynamic battle scene, a line of village defender soldiers clashing with Grot's armed mercenaries along the wooden palisade, swords and spears in motion, dust and chaos, no single face the focus, an army-scale skirmish rather than a duel --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village palisade, late summer golden light, subtle canvas grain, graphic novel illustration, no text, no watermark, Grot falling to one knee, defeated but unbroken --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village palisade, late summer golden light, subtle canvas grain, graphic novel illustration, no watermark, the heir asking who he works for, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village palisade, late summer golden light, subtle canvas grain, graphic novel illustration, no watermark, Grot laughing, rising slowly, naming the old Kruk, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at Grot, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village palisade, late summer golden light, subtle canvas grain, graphic novel illustration, no text, no watermark, Grot walking away alive, the heir watching him go, now certain Kruk is behind everything --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

### Akt II — Jesień

**#11 (tydz. 27) "Nieznajoma"** — Marta

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, autumn forest edge, misty autumn morning, amber fallen leaves, subtle canvas grain, graphic novel illustration, no text, no watermark, a hooded lean young woman watching the village from behind autumn trees --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village edge, misty autumn morning, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir noticing movement at the tree line, stepping closer --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, autumn forest, misty autumn morning, amber fallen leaves, subtle canvas grain, graphic novel illustration, no text, no watermark, the hooded woman fleeing between the tree trunks --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, forest floor, misty autumn morning, amber fallen leaves, subtle canvas grain, graphic novel illustration, no text, no watermark, close-up of the heir finding a dropped handkerchief on the ground, embroidered with the initials "M.K." --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, deep forest, misty autumn light, subtle canvas grain, graphic novel illustration, no text, no watermark, deep in the forest, now safe, the young woman leaning against a tree catching her breath, doubt crossing her face for the first time --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

**#12 (tydz. 30) "Dziennik"** — Kazimierz

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, dusty attic, sunbeams cutting through dust, quiet autumn afternoon, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir sorting through his grandfather's belongings in a dusty attic --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, dusty attic, sunbeams, subtle canvas grain, graphic novel illustration, no text, no watermark, close-up of the heir finding an old leather-bound diary hidden under a loose floorboard --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, subtle canvas grain, graphic novel illustration, no text, no watermark, close-up of the diary's pages, most torn out or burned, only one stained page surviving --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, subtle canvas grain, graphic novel illustration, no watermark, close-up of the grandfather's handwriting on the surviving diary page, empty rectangular caption box above it, ready for text to be added later --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, dusty attic, sunbeams, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir sitting in silence, the diary on his lap --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, dusty attic, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir hiding the diary away, resolving to ask the wise woman about it --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#13 (tydz. 33) "Niezdarny sabotaż"** — Marta

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, village storehouse at night, foggy autumn night, subtle canvas grain, graphic novel illustration, no text, no watermark, night, someone clumsily and quietly attempting sabotage near the storehouse --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village at night, foggy autumn night, subtle canvas grain, graphic novel illustration, no text, no watermark, a silhouette fleeing at the slightest sound --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village storehouse, foggy autumn morning, subtle canvas grain, graphic novel illustration, no text, no watermark, morning, the heir inspecting the laughably minimal damage --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village storehouse, foggy autumn morning, subtle canvas grain, graphic novel illustration, no watermark, the heir muttering to himself that this wasn't Grot's doing, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, foggy autumn morning, subtle canvas grain, graphic novel illustration, no text, no watermark, close-up of the heir recalling the handkerchief with the initials "M.K.", starting to connect the facts --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#14 (tydz. 36) "Rozmowa przy studni"** — Kazimierz, Marta

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, autumn leaves scattered around, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, evening, a hooded young woman fully visible at the village well, not fleeing this time, addressed by the heir's footsteps approaching off-panel, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible, naming her as Kruk's daughter Marta, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no watermark, Marta fully visible, replying about the name her father hates, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no watermark, Marta sitting on the well's edge, staring into the water, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible asking who Jan was, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no watermark, Marta fully visible, her voice breaking as she answers, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, Marta fully visible, looking down in silence --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 8
```
single comic panel, painterly semi-realistic folk illustration, stone well, warm dusk light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the first genuinely human, non-hostile moment of the whole story, Marta fully visible, a small, softening glance toward someone just off-panel --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

**#15 (tydz. 39) "Starcie z Martą"** — Kazimierz, Marta

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, bare autumn trees, late autumn overcast light, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, Marta fully visible, armed but without conviction in her eyes, facing someone off-panel, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, bare autumn trees, late autumn overcast light, dynamic action, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, Marta fully visible in a restrained clash, parrying an attack from entirely off-panel, fighting without full commitment --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, bare autumn trees, late autumn overcast light, subtle canvas grain, graphic novel illustration, no text, no watermark, Marta falling, defeated, looking almost relieved --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, bare autumn trees, late autumn overcast light, subtle canvas grain, graphic novel illustration, no watermark, Marta from the ground, a bitter smile, revealing her father's belief about the heir's grandfather, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, bare autumn trees, late autumn overcast light, subtle canvas grain, graphic novel illustration, no watermark, Marta, quieter, admitting she's no longer sure, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, bare autumn trees, late autumn overcast light, subtle canvas grain, graphic novel illustration, no text, no watermark, Marta standing, walking away without further fight, something between them changed forever --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

### Akt III — Zima

**#16 (tydz. 40) "Oskarżenie na targu"** — Bogdan

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, crowded market square, cold overcast winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, a crowded market square in a neighboring settlement, winter --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, market square platform, cold overcast winter light, subtle canvas grain, graphic novel illustration, no watermark, a gaunt grieving estate owner mounting a platform, furious, dramatic gestures, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, market square platform, cold overcast winter light, subtle canvas grain, graphic novel illustration, no watermark, the estate owner accusing the heir's family of hiding a murder, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, market square crowd, cold overcast winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, the rumor spreading through the crowd, twisted with each retelling --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village, cold overcast winter light, subtle canvas grain, graphic novel illustration, no watermark, two figures with clearly different faces and builds in the village: the heir listening, and a portly, balding, middle-aged merchant with a ruddy round face and a completely different build from the heir, in a travel-worn coat with a loaded cart behind him, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the merchant, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 100 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village, cold overcast winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir realizing, heavy-hearted, that a confrontation is now unavoidable --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#17 (tydz. 43) "Jadwiga mówi (część 2)"** — Kazimierz, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, winter afternoon through frosted windows, subtle canvas grain, graphic novel illustration, no watermark, the heir returning to the wise woman with the diary in hand, determined, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman staring long at the diary, finally sighing, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman explaining that Jan was searching for something in the old mine, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman, voice trembling, saying he didn't make it in time, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible asking if his grandfather didn't harm Jan, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman fully visible, giving a complicated answer, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, candlelight, subtle canvas grain, graphic novel illustration, no text, no watermark, the wise woman looking away, clearly hiding more, the heir noticing --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

**#18 (tydz. 46) "Zapieczętowane wejście"** — Kazimierz

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, estate border, cold winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, following the diary's clues, the heir setting out toward the estate border --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, deep snowy gnarled forest, thick fog, cold winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, a snow-covered, dark forest, the atmosphere thickening with each step --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, a massive rough-hewn stone archway carved into a snowy rock face, icicles hanging from the overhang above, a stone lintel carved with a row of unknown warding runes, heavy arched double doors of dark aged wood reinforced with black iron bands and a lattice pattern, sealed shut with a large rusted padlock and chain, broken stone wheels and rubble scattered in the snow at the base, cold winter light, warm golden light spilling onto the snowy ground in front of the door contrasting with cool blue shadows, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir fully visible approaching and finding the sealed entrance, looking up at the carved warding symbols --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, a massive rough-hewn stone archway carved into a snowy rock face, icicles hanging from the overhang above, a stone lintel carved with a row of unknown warding runes, heavy arched double doors of dark aged wood reinforced with black iron bands and a lattice pattern, sealed shut with a large rusted padlock and chain, broken stone wheels and rubble scattered in the snow at the base, cold winter light, warm golden light spilling onto the snowy ground in front of the door contrasting with cool blue shadows, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir fully visible straining hard against the sealed doors, pushing with both hands, muscles tense, the door not budging at all, firmly sealed --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, deep snowy gnarled forest, cold winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir walking away with more questions, but certainty that this place matters --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#19 (tydz. 49) "Twarzą w twarz z Bogdanem"** — Kazimierz, Bogdan

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no watermark, the gaunt grieving estate owner arriving personally at the village, surrounded by a silent armed escort, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, the heir fully visible asking truth about what, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no watermark, the gaunt grieving estate owner fully visible, furious and pained, replying about the grandfather, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no watermark, the heir showing him a torn page from the diary, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no watermark, the estate owner reading the diary page, going pale, hands trembling, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no watermark, the estate owner looking up, voice hardening, insisting it changes nothing, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, village, harsh winter daylight, subtle canvas grain, graphic novel illustration, no text, no watermark, the estate owner stepping back, ready to fight, but the first crack of doubt visible in his eyes --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

**#20 (tydz. 52) "Starcie z Bogdanem"** — Kazimierz, Bogdan

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, falling snow, stark winter light, dynamic action, subtle canvas grain, graphic novel illustration, no text, no watermark, a clash in the snow, the gaunt grieving estate owner fully visible, front and center, fighting with the fury of a man losing his footing, his opponent's blurred silhouette barely visible in the motion around him --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, falling snow, stark winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, the estate owner weakening, blow after blow, falling to his knees --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, falling snow, stark winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only the heir in frame, nobody else visible, the heir fully visible standing alone in the snow, gripping a drawn sword lowered at his side, withholding the final blow, empty trampled snow at his feet where his fallen opponent lies just out of frame --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, falling snow, stark winter light, subtle canvas grain, graphic novel illustration, no watermark, the estate owner, voice breaking, rising despite defeat, vowing to bring back what he lost, large empty speech bubble spanning about half the panel width, roomy enough for a full sentence with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, falling snow, stark winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, the estate owner breaking free and fleeing into the forest --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, falling snow, stark winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir left alone in the snow, the estate owner's unsettling words still echoing --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

### Akt IV — Wiosna II, część 1

**#21 (tydz. 53) "Znaki"** — (bez postaci głównych)

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, forest edge near the village, uneasy spring twilight, subtle canvas grain, graphic novel illustration, no text, no watermark, forest animals fleeing en masse toward the village at dusk --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village well, uneasy spring twilight, subtle canvas grain, graphic novel illustration, no text, no watermark, the village well frosting over unnaturally despite the warm spring weather --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village path, uneasy spring twilight, subtle canvas grain, graphic novel illustration, no watermark, villagers whispering, pointing worriedly toward the forest, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the villager woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village edge, uneasy spring twilight, subtle canvas grain, graphic novel illustration, no text, no watermark, a villager watching an unsettlingly dark patch of forest on the horizon --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village at night, uneasy night atmosphere, subtle canvas grain, graphic novel illustration, no text, no watermark, strange sounds heard at night beyond the estate border, villagers peering out of windows --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village at dawn, uneasy mood, subtle canvas grain, graphic novel illustration, no text, no watermark, a villager waking uneasy at dawn, a sense that time is running out --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**#22 (tydz. 55) "Pełna prawda"** — Kazimierz, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, dim candlelight, tense spring evening, subtle canvas grain, graphic novel illustration, no watermark, the heir confronting the wise woman one last time, determined, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, dim candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman, seeing the gravity of it, breaking her silence completely, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, dim candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman naming him Leszy, the old dark guardian of those lands, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, dim candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman explaining that Jan tried to bargain with him, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, dim candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman explaining the grandfather managed to stop him and reseal it at his own cost, large empty speech bubble spanning about half the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, dim candlelight, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir staring toward the forest, stunned by the weight of the truth --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#23 (tydz. 57) "Ostrzeżenie Marty"** — Kazimierz, Marta

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, village gate, stormy spring light, subtle canvas grain, graphic novel illustration, no watermark, Marta arriving at the village gate breathless and frightened, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village gate, stormy spring light, subtle canvas grain, graphic novel illustration, no watermark, the heir asking what her father is planning, empty speech bubble at least as wide as the character's head, large enough for a short phrase with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village gate, stormy spring light, subtle canvas grain, graphic novel illustration, no watermark, Marta, in despair, saying her father no longer wants to win, he wants his son back, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village gate, stormy spring light, subtle canvas grain, graphic novel illustration, no watermark, Marta saying he doesn't know what he's doing, none of them do, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village edge, stormy spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, both staring toward the darkening forest, knowing time is running out --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#24 (tydz. 58) "Przebudzenie"** — Bogdan, Leszy (przebudzony)

Panel 1
```
single comic panel, painterly semi-realistic dark folklore illustration, deep forest ritual site, dark oppressive atmosphere, subtle canvas grain, no watermark, the gaunt estate owner surrounded by his dead son's belongings, finishing a desperate ritual, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic dark folklore illustration, old mine entrance, dark oppressive atmosphere, subtle canvas grain, no text, no watermark, the ground trembling, ancient seals cracking with light, darkness pouring from the mine entrance --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 3
```
single comic panel, painterly semi-realistic dark folklore illustration, night sky over the forest, dark oppressive atmosphere, subtle canvas grain, no text, no watermark, a massive awakened Slavic forest spirit fully awakening, mightier and hungrier than ever, its silhouette filling the sky --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic dark folklore illustration, dark oppressive atmosphere, subtle canvas grain, no watermark, the estate owner recoiling, terrified of what he's woken, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village at night, distant darkness on the horizon, subtle canvas grain, graphic novel illustration, no text, no watermark, in the village, the heir and villagers seeing the growing darkness on the horizon --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village at night, alarm, subtle canvas grain, graphic novel illustration, no text, no watermark, the village alarm sounding, everyone preparing for the coming battle --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**#25 (tydz. 59) "Cisza przed burzą"** — Kazimierz, Marta

Panel 1
```
single comic panel, painterly semi-realistic dark folklore illustration, village at night, distant treeline glowing faintly with unnatural darkness, tense oppressive atmosphere, subtle canvas grain, no text, no watermark, the alarm bell's echo still hanging in the air, the awakened forest spirit lurking at the tree line but not yet advancing, weakened by its own sudden awakening --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, village palisade under urgent reinforcement, overcast daylight, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the heir fully visible directing villagers reinforcing the palisade timbers, soldiers drilling in the yard behind him, day blending into night from the pace of the work --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, village edge at dusk, villagers glancing uneasily toward the distant forest between tasks, overcast daylight, subtle canvas grain, graphic novel illustration, no text, no watermark, days of silence since the awakening with no word from the estate owner, worry deepening with each passing day --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, village gate, overcast urgent daylight, subtle canvas grain, graphic novel illustration, no watermark, Marta arriving at the village gate openly, for the first time not as an enemy or a spy, large empty speech bubble spanning about half the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, village gate, overcast urgent daylight, subtle canvas grain, graphic novel illustration, no watermark, the heir replying that no one deserves an end like that without answers, not even him, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, forest edge with a fortified village visible behind, soft overcast light, subtle canvas grain, graphic novel illustration, no text, no watermark, two people setting out toward the forest together, now as allies, both seen from behind walking side by side into the trees, beside the heir a lean athletic young woman with dark hair partly hidden under a hood, wearing simple dark travel/scout clothing with a small weapon at her belt, the reinforced, well-guarded palisade standing watch behind them --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

### Akt V — Wiosna II, część 2

**#26 (tydz. 60) "Ślady w popiele"** — Kazimierz, Marta

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, burned clearing in the forest, scorched earth, overcast spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the heir fully visible reaching the site of the ritual, scorched earth and blackened trees, a second set of footprints in the ash suggesting unseen company --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, burned clearing, overcast spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, searching through the ashes in silence --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, burned clearing, overcast spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, finding the burned remains of Jan's belongings, nothing more --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, burned clearing, overcast spring light, subtle canvas grain, graphic novel illustration, no watermark, among the ashes, Marta finding one object untouched by the fire, surprised, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, burned clearing, overcast spring light, subtle canvas grain, graphic novel illustration, no watermark, the heir asking how it got there, wondering if his grandfather ever came back, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, burned clearing, overcast spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the heir fully visible, exchanging a look full of new, unsettling questions with someone just off-panel --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#27 (tydz. 61) "Pierwsza próba"** — Kazimierz, Marta, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir fully visible, Marta and the wise woman both glimpsed only partially from behind or the side, visiting with the object found in the ashes --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman taking the object in hand, her face tightening with understanding, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no watermark, solo shot, only one person in frame, Marta fully visible asking what she means, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at Marta, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman fully visible, answering about her father's first attempt long ago, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the wise woman, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman explaining the grandfather had to intervene and leave something behind as a pledge, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no watermark, Marta sitting down heavily, stunned, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, small wooden chapel interior, warm candlelight, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, Marta fully visible, a hand entering from off-panel resting comfortingly on her shoulder, the shared burden binding them closer than old hostility ever did --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

**#28 (tydz. 62) "Prawda o Bogdanie"** — Kazimierz, Marta, Bogdan

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, forest edge clearing, soft spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, tracking the last clues, the heir fully visible reaching the very edge of the forest, a second set of footprints beside his own --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, forest edge clearing, soft spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, finding the estate owner there, alive but broken, aged a decade in a few weeks --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, forest edge clearing, soft spring light, subtle canvas grain, graphic novel illustration, no watermark, the estate owner, seeing his daughter, unable to meet her eyes, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, forest edge clearing, soft spring light, subtle canvas grain, graphic novel illustration, no watermark, Marta stepping closer, tears in her eyes but without hesitation, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, forest edge clearing, soft spring light, subtle canvas grain, graphic novel illustration, no watermark, the estate owner recounting the rest of the truth, the first failed attempt years ago, the grandfather's sacrifice, his own despair, large, tall empty speech bubble spanning about half the panel width and extending down for several lines of text with its tail pointing directly at him, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, forest edge clearing, soft spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, Marta listening, for the first time in twenty years truly understanding her father, her brother, and the heir she once hated --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

**#29 (tydz. 64) "Starcie z Leszym"** — Kazimierz, Bogdan, Leszy (przebudzony)

Panel 1
```
single comic panel, painterly semi-realistic dark folklore illustration, village at night under siege, chaotic battle light, embers and mist, subtle canvas grain, no text, no watermark, the massive forest spirit bearing down on the village, immense, dark, relentless --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic dark folklore illustration, village palisade at night, chaotic battle light, embers and mist, subtle canvas grain, no text, no watermark, the village's defenders taking their final stand behind the palisade --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic dark folklore illustration, village at night, chaotic battle light, embers and mist, dynamic action, subtle canvas grain, no text, no watermark, an intense clash of natural forces and darkness against the defenders' resolve --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic dark folklore illustration, village at night, retreating darkness, subtle canvas grain, no text, no watermark, the forest spirit defeated, forced back into the earth, the darkness retreating --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic dark folklore illustration, edge of the battlefield at night, dying embers and thinning mist, subtle canvas grain, no watermark, solo shot, only one person in frame, the gaunt estate owner, still weak from all he has endured, watching from a safe distance as the shadow he awakened finally yields --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, village battlefield at dawn, smoke clearing, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the heir fully visible, exhausted but alive, surveying the battlefield - the village has survived, this is almost over --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

**#30 (tydz. 65) "Nowy Zasiew"** — Kazimierz, Marta, Jadwiga

Panel 1
```
single comic panel, painterly semi-realistic folk illustration, border between two estates, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, a spring morning, the heir fully visible standing on the border of the once-feuding estates, someone just off-panel beside him --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 2
```
single comic panel, painterly semi-realistic folk illustration, border between two estates, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no text, no watermark, the heir together with a lean athletic young woman with dark hair partly hidden under a hood, wearing simple dark travel/scout clothing with a small weapon at her belt, the two of them planting a young tree together right on the boundary, a symbolic gesture, both kneeling side by side bent over the sapling with faces mostly turned down and away from camera --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 3
```
single comic panel, painterly semi-realistic folk illustration, border between two estates, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman watching from the side, relief and sorrow mingling in her eyes, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 4
```
single comic panel, painterly semi-realistic folk illustration, border between two estates, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no watermark, the wise woman continuing her thought about the grandfather carrying this debt for twenty years, sizeable empty speech bubble spanning about 40 percent of the panel width, roomy enough for a full sentence with its tail pointing directly at her, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/59c0180f-c391-4f36-ad5b-51237c2c60a7?index=0 --ow 200 --v 7
```

Panel 5
```
single comic panel, painterly semi-realistic folk illustration, forest edge, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no watermark, Marta fully visible looking toward the now-quiet, peaceful forest, a small question, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at Marta, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

Panel 6
```
single comic panel, painterly semi-realistic folk illustration, forest edge, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no watermark, the heir fully visible looking toward the now-quiet, peaceful forest, a small reply, empty speech bubble spanning about a third of the panel width, large enough to comfortably fit several words with its tail pointing directly at the heir, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/c74097e6-4ff2-4392-bc42-7ee48feb3a93?index=2 --ow 200 --v 7
```

Panel 7
```
single comic panel, painterly semi-realistic folk illustration, quiet forest, peaceful spring sunlight, subtle canvas grain, graphic novel illustration, no watermark, the forest, still and calm in the spring sun, empty rectangular caption box at the bottom of the panel for the closing title card, ready for text to be added later --ar 4:3 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

---

## C. Ilustracje ekranów (`BossIntroScreen`, `EndingScreen`, `SplashScreen`) — ✅ wpięte w kod

Wszystkie trzy ekrany (kiedyś czysto tekstowe) mają teraz warstwę obrazka: `BossIntroScreen` przyjmuje `portraitKey` (`assets/ui/boss_$portraitKey.webp`), `EndingScreen` dobiera obrazek wg `_EndingTier.imageKey` (`assets/ui/ending_*.webp`), `SplashScreen` ma `assets/ui/splash.webp` w tle z animowaną mgłą/pyłkami (`_SplashAmbiencePainter`) i powolnym efektem "Ken Burns". Format pionowy (`--ar 3:4`), bo wszystkie trzy to pełnoekranowe widoki telefonu, w przeciwieństwie do poziomych kadrów komiksu.

### C1. Portrety na ekranie zapowiedzi bossa (`BossIntroScreen`)

Wspólny styl: dramatyczny, na wpół realistyczny (ten sam co reszta komiksów), ale bliższy kadr niż w panelach - postać ma dominować cały ekran, tak jak dominuje uwagę gracza tuż przed walką.

**Grot** (tydz. 26 — "Grot i jego zbrojni zbliżają się do wioski")
```
painterly semi-realistic folk illustration, close three-quarter portrait, dramatic low warm evening light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the mercenary captain filling most of the frame, striding toward camera with armed men blurred in the background, hand resting confidently on his weapon, hardened pragmatic expression --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/7bcf1759-4bd7-47e9-8f75-215acfe2883b?index=1 --ow 200 --v 7
```

**Marta** (tydz. 39 — "Marta staje naprzeciw Ciebie, uzbrojona, wysłana przez ojca")
```
painterly semi-realistic folk illustration, close three-quarter portrait, dramatic cool dusk light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the lean athletic young woman filling most of the frame, standing ready with a small weapon drawn, guarded expression with a flicker of doubt underneath, forest blurred behind her --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aaac2b8a-5640-45fd-840a-497e3b443cad?index=0 --ow 200 --v 7
```

**Bogdan** (tydz. 52 — "Bogdan Kruk przybywa osobiście, żądając prawdy")
```
painterly semi-realistic folk illustration, close three-quarter portrait, dramatic overcast winter light, subtle canvas grain, graphic novel illustration, no text, no watermark, solo shot, only one person in frame, the gaunt estate owner filling most of the frame, striding forward with barely-contained fury, deep-set exhausted eyes full of pain and anger, worn dark coat, snow blurred behind him --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/49a3713b-2c59-4521-bb70-49cd016eede1?index=3 --ow 200 --v 7
```

**Leszy** (tydz. 64 — "Mroczny cień lasu budzi się w pełni")
```
painterly semi-realistic dark folklore illustration, dramatic night atmosphere, subtle canvas grain, no text, no watermark, the massive ancient forest spirit filling the entire frame, its antlered silhouette blotting out the moon, glowing pupil-less amber eyes piercing the darkness, swirling shadow and mist pouring off its bark-like form, predatory hungry presence, oppressive dread --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2 --ow 200 --v 7
```

### C1b. Przejście między fazami walki z Leszym (`LeszyBattleScreen`, ekran "Serce Cienia")

Osobna ilustracja pokazywana na ekranie między Nawałnicą a Sercem Cienia (po pokonaniu pierwszej fazy, przed drugą). Ma pokazywać moment, w którym z pokonanego, "zwykłego" Leszego wyłania się jego prawdziwa, głodniejsza forma (wchodzi w tę fazę już z podwyższoną siłą i nowym ruchem, który pożera Cień, żeby się leczyć - patrz `docs/game_systems.md` §11.4). `--oref` trzyma się referencji "Leszy — forma przebudzona" (ta sama, co portret na ekranie zapowiedzi bossa w C1, i te same bursztynowe oczy) - to ta forma rośnie w drugą, potężniejszą wersję siebie samej, nie inne stworzenie. Referencja "Leszy — forma uśpiona" (`ac837e48…`, blade zielone oczy, sekcja A) świadomie zostaje niewykorzystana tutaj - opisuje spokojną, jeszcze nieprzebudzoną postać sprzed całej fabuły, więc nie pasuje do żadnej z faz walki; jeśli kiedyś przyda się osobna grafika "Leszy przed przebudzeniem" (np. do jakiegoś retrospektywnego komiksu), to właśnie ta referencja.

```
painterly semi-realistic dark folklore illustration, dramatic night atmosphere, subtle canvas grain, no text, no watermark, the defeated first form of the ancient forest spirit collapsing into swirling black mist and embers, its glowing amber eyes dimming and going dark, a second, larger and more skeletal antlered silhouette rising up out of that dissolving shadow behind it, glowing pupil-less amber eyes igniting within the new form, hungrier and more feral than before, oppressive dread, dynamic transformation moment --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100 --oref https://www.midjourney.com/jobs/aa467e21-d841-42b9-aac9-d7c14b2adac2?index=2 --ow 200 --v 7
```

Ścieżka: `assets/ui/leszy_serce_cienia.webp` (kod już tam patrzy — plik istnieje, errorBuilder na małą ikonkę cienia zostaje tylko jako zabezpieczenie na wypadek braku pliku).

### C2. Ilustracje ekranu zakończenia (`EndingScreen`, 3 warianty epilogu)

Każdy wariant ma inny ton (patrz `_EndingTier` w kodzie) - ilustracja powinna to odzwierciedlać, nie być trzy razy tym samym ujęciem w innym kolorze.

**Złoty wiek** (`golden` — "Wioska tętni życiem jak nigdy dotąd")
```
painterly semi-realistic folk illustration, wide establishing shot, warm golden-hour spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, a thriving prosperous village seen from a gentle hillside, full granaries, sturdy repaired walls, smoke rising warmly from many chimneys, villagers going about abundant daily life, the heir and the lean athletic young woman standing together in the foreground looking out over it all, seen mostly from behind --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**Trudne zwycięstwo** (`hardWon` — "Wioska przetrwała - poobijana, zmęczona, ale wciąż stoi")
```
painterly semi-realistic folk illustration, wide establishing shot, soft overcast late-spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, a weathered village still standing after hardship, visible repairs and patched walls, thinner smoke from fewer chimneys, quiet determined activity, the heir and the lean athletic young woman standing side by side in the foreground, tired but resolute, seen mostly from behind --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

**Blizny, które zostają** (`scarred` — "Zwycięstwo smakuje gorzko")
```
painterly semi-realistic folk illustration, wide establishing shot, muted pale spring light, subtle canvas grain, graphic novel illustration, no text, no watermark, a sparse village bearing the cost of victory, empty patches where buildings once stood, only a few thin trails of smoke, villagers watching quietly from doorways, the heir standing alone in the foreground with the lean athletic young woman a step behind him, seen mostly from behind, bittersweet stillness --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```

### C3. Ekran startowy (`SplashScreen`)

Jedna, mocna ilustracja tytułowa - motyw kruka (tytuł "Dług Kruka") nad wioską, o świcie, niosąca w sobie tajemnicę całej historii bez pokazywania żadnej konkretnej postaci (tekst tytułu i przyciski dokłada Flutter osobno, więc obrazek powinien zostawić czyste miejsce u góry/dołu kadru).

```
painterly semi-realistic folk illustration, wide atmospheric establishing shot, hazy golden dawn light breaking through mist, subtle canvas grain, graphic novel illustration, moody atmospheric lighting, no text, no watermark, no people, a solitary raven perched on a weathered wooden fence post in the foreground looking toward a small modest village waking up in the misty valley below, warm light just beginning to touch the thatched roofs, a vast quiet sky above with generous empty negative space at the top of the frame --ar 3:4 --style raw --sref https://www.midjourney.com/jobs/005d958f-9132-46cc-8b5d-dc648cbe324c?index=1 --sw 100
```
