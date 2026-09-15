import '../services/app_locale.dart';
import 'comic_translations_en.dart';

/// Model komiksów fabularnych "Dług Kruka" - tekstowe plansze (na razie bez
/// grafiki) prezentowane graczowi w miarę postępu tygodni. Treść odpowiada
/// scenariuszom ze scenopisu fabuły (30 komiksów, po jednym co 2-3 tygodnie).
class ComicLine {
  final String speaker;
  final String text;

  const ComicLine(this.speaker, this.text);
}

class ComicPanel {
  // Może być puste, gdy panel to wyłącznie dialog bez dodatkowego opisu kadru.
  final String? description;
  final List<ComicLine> lines;

  const ComicPanel(this.description, [this.lines = const []]);
}

class Comic {
  final int number;
  final int week;
  final int actNumber;
  final String title;
  final List<ComicPanel> panels;

  const Comic({
    required this.number,
    required this.week,
    required this.actNumber,
    required this.title,
    required this.panels,
  });
}

extension ComicLocalization on Comic {
  String get localizedTitle =>
      AppLocale.instance.isEnglish ? (kComicsEn[number]?.title ?? title) : title;

  List<ComicPanel> get localizedPanels =>
      AppLocale.instance.isEnglish ? (kComicsEn[number]?.panels ?? panels) : panels;
}

/// Etykieta aktu i pora roku - wyświetlane na planszy tytułowej przed
/// pierwszym kadrem każdego komiksu (patrz "6. Harmonogram komiksów").
class ComicActInfo {
  final String label;
  final String season;
  final String actName;

  const ComicActInfo(this.label, this.season, this.actName);
}

const Map<int, ComicActInfo> kComicActInfo = {
  0: ComicActInfo('Akt 0', 'Wiosna I', 'Zanim odejdziesz'),
  1: ComicActInfo('Akt I', 'Lato', 'Ostrzeżenie'),
  2: ComicActInfo('Akt II', 'Jesień', 'Krew rodziny'),
  3: ComicActInfo('Akt III', 'Zima', 'Twarzą w twarz'),
  4: ComicActInfo('Akt IV', 'Wiosna II', 'Głodny Cień'),
  5: ComicActInfo('Akt V', 'Wiosna II', 'Powrót Wiosny'),
};

const List<Comic> kComics = [
  Comic(
    number: 1,
    week: 1,
    actNumber: 0,
    title: 'Nowy dzień',
    panels: [
      ComicPanel('Wóz wjeżdża do skromnej, ale żywej wioski o poranku.'),
      ComicPanel(
        'Na progu chaty czeka stary, uśmiechnięty, ale wyraźnie osłabiony Antoni.',
        [ComicLine('Antoni', 'Nareszcie. Zaczynałem się martwić, że się nie zjawisz.')],
      ),
      ComicPanel(
        'Wnętrze chaty - Antoni przekazuje klucze i księgi gospodarskie.',
        [ComicLine('Antoni', 'Nogi już nie te. Czas, żebyś to Ty prowadził interesy.')],
      ),
      ComicPanel('Kazimierz patrzy na rozłożoną przed sobą, zaniedbaną mapę wioski.'),
      ComicPanel(
        'Antoni prowadzi Kazimierza do okna, wskazując na wioskę w dole - kilka pustych, spalonych działek wciąż widocznych między zabudowaniami.',
        [
          ComicLine(
            'Antoni',
            '(ciężko) Kiedyś było tu więcej. Ktoś podłożył ogień, zanim zdążyliśmy się obronić - większość wioski spłonęła. Odbudowujemy się od tamtej pory, po trochu.',
          ),
        ],
      ),
      ComicPanel('"Nauka zaczyna się od pierwszej łopaty ziemi."'),
    ],
  ),
  Comic(
    number: 2,
    week: 3,
    actNumber: 0,
    title: 'Pierwsze cegły',
    panels: [
      ComicPanel('Kazimierz przegląda plany budowy przy stole.'),
      ComicPanel(
        'Robotnicy kładą fundamenty pod Ratusz, unosi się kurz.',
        [
          ComicLine('Robotnik', 'Gdzie stawiamy belkę nośną, szefie?'),
          ComicLine('Kazimierz', 'Tutaj. I niech będzie prosto, bo dziadek to zobaczy.'),
        ],
      ),
      ComicPanel(
        'Antoni na ganku, z kubkiem herbaty, patrzy z uśmiechem.',
        [ComicLine('Antoni', 'Krzywo jak mój pierwszy płot. Ale stoi!')],
      ),
      ComicPanel('Ratusz powstaje w bardzo szybkim tempie.'),
      ComicPanel(
        'Ratusz jest prawie gotowy. Kazimierz ociera pot z czoła, Antoni klaszcze z ganku.',
        [ComicLine('Antoni', 'Patrzcie no. Może jednak było warto zaczekać z odpoczynkiem.')],
      ),
      ComicPanel(
        'Wieczorem, przy ognisku.',
        [
          ComicLine(
            'Antoni',
            'Twój pradziadek postawił pierwszą chatę gołymi rękami. Ty masz już mnie i te ręce. '
                'To dobry początek.',
          ),
        ],
      ),
    ],
  ),
  Comic(
    number: 3,
    week: 5,
    actNumber: 0,
    title: 'Cień Kruka',
    panels: [
      ComicPanel('Spokojny poranek na podwórzu - Antoni karmi kury, Kazimierz nosi wodę.'),
      ComicPanel(
        'Kruk ląduje na płocie, patrzy prosto na Antoniego.',
        [ComicLine('Kruk', '"Kra."')],
      ),
      ComicPanel(
        'Antoni zastyga, kubek wypada mu z ręki i się tłucze.',
        [ComicLine('Antoni', '(cicho) Jeszcze nie teraz...')],
      ),
      ComicPanel(
        'Kazimierz podbiega zaniepokojony.',
        [ComicLine('Kazimierz', 'Dziadku? Wszystko gra? Co to znaczy "jeszcze nie teraz"?')],
      ),
      ComicPanel(
        'Antoni odwraca się, twarz w cieniu, patrzy w stronę dalekiego lasu, zbywa pytanie.',
        [ComicLine('Antoni', 'Nikt. Stary już jestem, nerwy płatają figle.')],
      ),
      ComicPanel('Kruk odlatuje w stronę lasu.'),
    ],
  ),
  Comic(
    number: 4,
    week: 7,
    actNumber: 0,
    title: 'Antoni odchodzi',
    panels: [
      ComicPanel('Antoni sam, kaszle mocno, opiera się o framugę drzwi.'),
      ComicPanel(
        'Kazimierz wpada zaniepokojony.',
        [ComicLine('Kazimierz', 'Dziadku, usiądź, przyniosę wody.')],
      ),
      ComicPanel('Jadwiga, opiekunka kaplicy, przybywa z ziołami.'),
      ComicPanel(
        'Jadwiga klęka przy Antonim - tym razem jej twarz zdradza, że wie więcej, niż mówi.',
        [ComicLine('Jadwiga', 'To już nie przeziębienie, Antoni. Wiesz o tym równie dobrze jak ja.')],
      ),
      ComicPanel(
        'Antoni, bardzo słaby.',
        [ComicLine('Antoni', 'Odpoczynek będę miał przez wieczność, Jadwigo. Jeszcze chwilę musi zaczekać.')],
      ),
      ComicPanel(
        'Gdy Kazimierz wychodzi po wodę, Antoni chwyta Jadwigę za rękaw, głos ledwie słyszalny.',
        [ComicLine('Antoni', '(szeptem) Zaopiekuj się dzieckiem. Gdy przyjdzie czas... a przyjdzie szybciej, niż myślałem.')],
      ),
      ComicPanel(
        'Jadwiga, oczy pełne łez, których nie pozwala sobie uronić.',
        [ComicLine('Jadwiga', 'Powiedz mu prawdę, Antoni. Zanim będzie za późno.')],
      ),
      ComicPanel(
        'Antoni, spokojny, zrezygnowany.',
        [ComicLine('Antoni', 'Niech chociaż ten rok pożyje bez tego ciężaru.')],
      ),
      ComicPanel('Noc zapada nad chatą - Kazimierz zasypia wyczerpany czuwaniem.'),
      ComicPanel(
        'Świt. Kazimierz budzi się i widzi, że Antoni odszedł we śnie, spokojnie, z dłonią wciąż ciepłą. '
            'Tydzień 7. Antoni odszedł we śnie - spokojnie, choć zbyt wcześnie.',
        [ComicLine('Kazimierz', '(szeptem) Dziadku...?')],
      ),
    ],
  ),
  Comic(
    number: 5,
    week: 12,
    actNumber: 0,
    title: 'Pogrzeb',
    panels: [
      ComicPanel('Wioska pogrążona w żałobie od pięciu tygodni - mieszkańcy w milczeniu kończą przygotowania do pogrzebu.'),
      ComicPanel(
        'Nadszedł dzień pogrzebu - zgromadzone przez te tygodnie surowce posłużyły wreszcie na trumnę, kamień '
        'nagrobny i skromną ucztę pożegnalną, jaką Antoni sobie zasłużył.',
      ),
      ComicPanel(
        'Skromny pogrzeb na cmentarzu.',
        [
          ComicLine(
            'Jadwiga',
            'Antoni budował tę wioskę własnymi rękami przez pół wieku. '
                'Zostawił ją w dobrych rękach - i zostawił też pytania, na które sam nigdy nie odpowiedział.',
          ),
        ],
      ),
      ComicPanel(
        'Jadwiga podchodzi do Kazimierza po ceremonii.',
        [ComicLine('Jadwiga', 'Twój dziadek zostawił więcej pytań niż odpowiedzi, dziecko.')],
      ),
      ComicPanel(
        'Kazimierz pyta.',
        [
          ComicLine('Kazimierz', 'Jakich pytań?'),
          ComicLine('Jadwiga', 'Takich, na które jeszcze nie jesteś gotowy.'),
        ],
      ),
      ComicPanel('Na wzgórzu w oddali samotny jeździec obserwuje ceremonię.'),
      ComicPanel('Jeździec zawraca konia i odjeżdża. Rok się dopiero zaczyna.'),
    ],
  ),
  Comic(
    number: 6,
    week: 14,
    actNumber: 1,
    title: 'Wizyta',
    panels: [
      ComicPanel('Do wioski wjeżdża chłodny, elegancki posłaniec na koniu.'),
      ComicPanel(
        'Zatrzymuje się przed Kazimierzem, nie schodząc z siodła.',
        [ComicLine('Posłaniec', 'Pan Bogdan Kruk przesyła kondolencje. I radę.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Nie znam tego nazwiska.')]),
      ComicPanel(
        null,
        [
          ComicLine(
            'Posłaniec',
            'Pozna Pan. Rada brzmi: niech nowy dziedzic nie kontynuuje '
                'złych tradycji dziadka.',
          ),
        ],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Jakich tradycji?')]),
      ComicPanel(null, [ComicLine('Posłaniec', 'Tego dziadek nie powiedział? Ciekawe.')]),
      ComicPanel(
        'Posłaniec zawraca konia i odjeżdża z wioski.',
        [ComicLine('Posłaniec', 'Niech to będzie ostatnie uprzejme ostrzeżenie.')],
      ),
    ],
  ),
  Comic(
    number: 7,
    week: 17,
    actNumber: 1,
    title: 'W ciemności',
    panels: [
      ComicPanel('Noc, cisza w wiosce - coś porusza się przy magazynie.'),
      ComicPanel('Rano Kazimierz odkrywa zniszczenia: rozrzucone zapasy, uszkodzony płot.'),
      ComicPanel(
        'Zaniepokojeni mieszkańcy komentują.',
        [ComicLine('Mieszkanka', 'Ktoś tu naprawdę nie chce, żebyśmy się podnieśli.')],
      ),
      ComicPanel(
        'Starszy wieśniak ścisza głos.',
        [ComicLine('Starzec', 'To jak za dawnych lat... kiedy ci dwaj jeszcze kochali się jak bracia.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Jacy dwaj?')]),
      ComicPanel(
        'Spłoszony wieśniak odpowiada.',
        [ComicLine('Starzec', 'A, nieważne. Stare dzieje.')],
      ),
    ],
  ),
  Comic(
    number: 8,
    week: 20,
    actNumber: 1,
    title: 'Jadwiga mówi (część 1)',
    panels: [
      ComicPanel(
        'Kazimierz odwiedza Jadwigę w Kaplicy.',
        [ComicLine('Kazimierz', 'Kim jest Bogdan Kruk? I dlaczego nikt nie chce o nim mówić?')],
      ),
      ComicPanel(
        'Jadwiga odstawia filiżankę po długiej chwili ciszy.',
        [ComicLine('Jadwiga', 'Siadaj. To będzie długa rozmowa - choć nie dziś usłyszysz jej koniec.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'Twój dziadek i Bogdan byli kiedyś wspólnikami. Bliższymi niż niejeden brat.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Co się stało?')]),
      ComicPanel(
        'Jadwiga gestem wskazuje w stronę odległego lasu.',
        [ComicLine('Jadwiga', 'Coś na tamtych terenach.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'Więcej nie powiem. Obiecałam mu milczenie, a przysięgi się dotrzymuje.')],
      ),
      ComicPanel('Kazimierz zostaje sam, patrząc przez okno w stronę lasu na horyzoncie.'),
    ],
  ),
  Comic(
    number: 9,
    week: 23,
    actNumber: 1,
    title: 'Trybut',
    panels: [
      ComicPanel(
        'Do wioski wkracza uzbrojony mężczyzna o twardej twarzy - Grot - z kilkoma zbirami.',
        [ComicLine('Grot', 'Słyszałem, że macie tu nowego pana.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Grot', 'Ładna wioska. Szkoda by było, gdyby coś się jej stało.')],
      ),
      ComicPanel(
        'Kazimierz odpowiada przez zaciśnięte zęby.',
        [ComicLine('Kazimierz', 'Czego chcesz?')],
      ),
      ComicPanel(
        null,
        [ComicLine('Grot', 'Nazwijmy to opłatą za spokój. Płynącą od pewnego zainteresowanego.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Kogo?')]),
      ComicPanel(
        null,
        [ComicLine('Grot', 'Zapytaj dziadka. A, no tak. Nie może już odpowiedzieć.')],
      ),
      ComicPanel(
        'Grot odchodzi ze swoimi ludźmi.',
        [ComicLine('Grot', 'Wrócę po odpowiedź. Radzę, żeby była właściwa.')],
      ),
    ],
  ),
  Comic(
    number: 10,
    week: 26,
    actNumber: 1,
    title: 'Starcie z Grotem',
    panels: [
      ComicPanel(
        'Grot wraca z większą grupą - wioska stoi przygotowana. Grot wydaje się zaskoczony.',
        [ComicLine('Grot', 'Patrzcie, patrzcie. Ktoś się jednak przygotował.')],
      ),
      ComicPanel('Między siłami Grota a wioski dochodzi do starcia.'),
      ComicPanel('Grot pada na kolano, pokonany, ale niezłamany.'),
      ComicPanel(null, [ComicLine('Kazimierz', 'Dla kogo pracujesz, Grot?')]),
      ComicPanel(
        'Grot wstaje powoli, uśmiecha się.',
        [ComicLine('Grot', 'Stary Kruk dobrze płaci za cudzy ból. Ale to nie moja sprawa, czemu.')],
      ),
      ComicPanel('Grot odchodzi żywy - Kazimierz zyskuje pewność: to naprawdę Kruk stoi za wszystkim.'),
    ],
  ),
  Comic(
    number: 11,
    week: 27,
    actNumber: 2,
    title: 'Nieznajoma',
    panels: [
      ComicPanel('Ktoś obserwuje wioskę zza drzew - kobieta w kapturze.'),
      ComicPanel('Kazimierz zauważa ruch, podchodzi bliżej.'),
      ComicPanel('Kobieta ucieka między drzewa, zanim Kazimierz zdąży cokolwiek powiedzieć.'),
      ComicPanel('Kazimierz znajduje na ziemi upuszczoną chusteczkę z wyszytymi inicjałami "M.K.".'),
      ComicPanel(
        'W lesie, bezpieczna już Marta opiera się o drzewo, ciężko oddychając - pierwszy raz widzimy jej '
        'twarz, pełną wątpliwości.',
      ),
    ],
  ),
  Comic(
    number: 12,
    week: 30,
    actNumber: 2,
    title: 'Dziennik',
    panels: [
      ComicPanel('Kazimierz porządkuje rzeczy po dziadku na strychu, kurz w promieniach słońca.'),
      ComicPanel('Pod deską podłogową znajduje stary, oprawiony w skórę dziennik.'),
      ComicPanel('Większość stron jest wyrwana lub spalona - ocalała tylko jedna, poplamiona.'),
      ComicPanel(
        'Zbliżenie na pismo Antoniego: "Powiedziałem mu, że to wypadek. Nie powiedziałem, co widziałem w lesie."',
      ),
      ComicPanel('Kazimierz siedzi w milczeniu, dziennik na kolanach.'),
      ComicPanel('Kazimierz chowa dziennik, postanawiając zapytać o niego Jadwigę.'),
    ],
  ),
  Comic(
    number: 13,
    week: 33,
    actNumber: 2,
    title: 'Niezdarny sabotaż',
    panels: [
      ComicPanel('Noc - ktoś próbuje wywołać sabotaż, ale wyraźnie niezdarnie i po cichu.'),
      ComicPanel('Sylwetka ucieka, gdy tylko coś zaszeleści.'),
      ComicPanel('Rano Kazimierz ogląda "szkody" - śmiesznie minimalne.'),
      ComicPanel(
        null,
        [ComicLine('Kazimierz', '(do siebie) To nie był Grot. Ktoś tu wcale nie chce, żeby to zadziałało.')],
      ),
      ComicPanel('Kazimierz przypomina sobie chusteczkę z inicjałami "M.K." - zaczyna łączyć fakty.'),
    ],
  ),
  Comic(
    number: 14,
    week: 36,
    actNumber: 2,
    title: 'Rozmowa przy studni',
    panels: [
      ComicPanel(
        'Wieczór - Kazimierz zastaje przy studni tę samą postać, tym razem nieuciekającą.',
        [ComicLine('Marta', 'Wiem, że mnie widziałeś. Nie mam już siły uciekać.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Jesteś córką Kruka. Marta, prawda?')]),
      ComicPanel(
        null,
        [ComicLine('Marta', 'A ty nosisz nazwisko, którego mój ojciec nienawidzi bardziej niż czegokolwiek na świecie.')],
      ),
      ComicPanel(
        'Marta siada na brzegu studni, patrzy w wodę.',
        [ComicLine('Marta', 'Mój ojciec od dwudziestu lat opłakuje Jana tak mocno, że zapomniał, iż wciąż ma mnie.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Kim był Jan?')]),
      ComicPanel(
        null,
        [ComicLine('Marta', '(głos się łamie) Moim bratem. I jedynym, co się dla ojca liczy - nawet po śmierci.')],
      ),
      ComicPanel('Cisza między nimi.'),
      ComicPanel('Pierwszy naprawdę ludzki, niewrogi moment całej historii.'),
    ],
  ),
  Comic(
    number: 15,
    week: 39,
    actNumber: 2,
    title: 'Starcie z Martą',
    panels: [
      ComicPanel(
        'Marta stoi naprzeciw Kazimierza, uzbrojona, ale bez przekonania w oczach.',
        [ComicLine('Marta', 'Ojciec kazał. Nie mam wyboru.')],
      ),
      ComicPanel('Starcie - powściągliwe, obie strony walczą bez pełnego zaangażowania.'),
      ComicPanel('Marta pada, pokonana, wygląda niemal na ulżoną.'),
      ComicPanel(
        null,
        [ComicLine('Marta', '(z ziemi, gorzki uśmiech) Ojciec wierzy, że wasz dziadek zabił Jana gołymi rękami.')],
      ),
      ComicPanel(null, [ComicLine('Marta', '(ciszej) Ja... nie jestem już taka pewna.')]),
      ComicPanel('Marta wstaje, odchodzi bez dalszej walki - coś się między nimi zmieniło na zawsze.'),
    ],
  ),
  Comic(
    number: 16,
    week: 40,
    actNumber: 3,
    title: 'Oskarżenie na targu',
    panels: [
      ComicPanel('Rynek w sąsiedniej osadzie, tłum kupców i wieśniaków.'),
      ComicPanel(
        'Bogdan Kruk, po raz pierwszy widziany wyraźnie, wchodzi na podest, wściekły.',
        [ComicLine('Bogdan', 'Moja córka zawiodła! Niech wszyscy usłyszą, kim naprawdę jest ten dziedzic!')],
      ),
      ComicPanel(
        null,
        [ComicLine('Bogdan', 'Rodzina, która ukrywa morderstwo pod maską gospodarności!')],
      ),
      ComicPanel('Plotka rozchodzi się lotem błyskawicy - kolejni ludzie powtarzają historię, coraz bardziej przekręconą.'),
      ComicPanel(
        'Kazimierz słyszy o tym od zdenerwowanego kupca odwiedzającego wioskę.',
        [ComicLine('Kupiec', 'Ludzie gadają różne rzeczy o Waszym dziadku...')],
      ),
      ComicPanel('Kazimierz, z ciężkim sercem, rozumie, że konfrontacja jest nieunikniona.'),
    ],
  ),
  Comic(
    number: 17,
    week: 43,
    actNumber: 3,
    title: 'Jadwiga mówi (część 2)',
    panels: [
      ComicPanel(
        'Kazimierz wraca do Jadwigi z dziennikiem w dłoni, zdeterminowany.',
        [ComicLine('Kazimierz', 'Muszę wiedzieć. Cała reszta.')],
      ),
      ComicPanel(
        'Jadwiga długo patrzy na dziennik, w końcu wzdycha.',
        [ComicLine('Jadwiga', 'Jan szukał czegoś w starej kopalni. Czegoś, czego szukać nie powinien.')],
      ),
      ComicPanel(null, [ComicLine('Jadwiga', 'Antoni próbował go powstrzymać. Błagał, żeby zawrócił.')]),
      ComicPanel(null, [ComicLine('Jadwiga', '(głos drży) Nie zdążył.')]),
      ComicPanel(null, [ComicLine('Kazimierz', 'Więc dziadek nie... nie skrzywdził Jana?')]),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'To dużo bardziej skomplikowane, dziecko. I to wciąż nie cała prawda.')],
      ),
      ComicPanel('Jadwiga odwraca wzrok, wyraźnie ukrywając jeszcze więcej - Kazimierz to zauważa.'),
    ],
  ),
  Comic(
    number: 18,
    week: 46,
    actNumber: 3,
    title: 'Zapieczętowane wejście',
    panels: [
      ComicPanel('Kierując się wskazówkami z dziennika, Kazimierz wyrusza ku granicy posiadłości.'),
      ComicPanel('Zaśnieżony, mroczny las - atmosfera gęstnieje z każdym krokiem.'),
      ComicPanel(
        'Kazimierz odnajduje stare, zapieczętowane, obrośnięte wejście do kopalni, na kamieniu nad nim '
        'widnieją wyryte, nieznane symbole.',
      ),
      ComicPanel('Kazimierz próbuje otworzyć wejście - bezskutecznie, jest solidnie zapieczętowane.'),
      ComicPanel('Kazimierz odchodzi z jeszcze większą liczbą pytań, ale pewnością: to miejsce ma kluczowe znaczenie.'),
    ],
  ),
  Comic(
    number: 19,
    week: 49,
    actNumber: 3,
    title: 'Twarzą w twarz z Bogdanem',
    panels: [
      ComicPanel(
        'Bogdan Kruk osobiście przybywa do wioski, otoczony milczącą eskortą.',
        [ComicLine('Bogdan', 'Dość pośredników. Chcę prawdy albo krwi.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Prawdy o czym? Nie wiem nawet, co się stało!')]),
      ComicPanel(
        null,
        [ComicLine('Bogdan', '(z wściekłością i bólem) Twój dziadek wiedział! I zabrał to ze sobą do grobu!')],
      ),
      ComicPanel(
        'Kazimierz pokazuje mu stronę z dziennika.',
        [ComicLine('Kazimierz', 'Może to panu coś powie.')],
      ),
      ComicPanel(
        'Bogdan czyta, blednie, ręce mu drżą.',
        [ComicLine('Bogdan', '(szeptem) Las. Nie droga. Zawsze mówił mi o drodze...')],
      ),
      ComicPanel(
        null,
        [ComicLine('Bogdan', '(podnosząc wzrok, głos twardnieje) To nie zmienia niczego. Wciąż mi coś ukrywał!')],
      ),
      ComicPanel('Bogdan cofa się o krok, gotowy do starcia - ale w jego oczach widać już pierwsze pęknięcie pewności.'),
    ],
  ),
  Comic(
    number: 20,
    week: 52,
    actNumber: 3,
    title: 'Starcie z Bogdanem',
    panels: [
      ComicPanel('Starcie na śniegu - Bogdan walczy z furią człowieka, który traci grunt pod nogami.'),
      ComicPanel('Bogdan słabnie, atak za atakiem, aż pada na kolana.'),
      ComicPanel('Kazimierz stoi nad nim, nie zadając ostatecznego ciosu.'),
      ComicPanel(
        null,
        [
          ComicLine(
            'Bogdan',
            '(łamiącym się głosem, wstając mimo porażki) Jeśli wasz dziadek mógł znaleźć sposób, żeby '
                'zatrzymać coś, co powinno umrzeć... ja też znajdę sposób, żeby przywrócić to, co straciłem!',
          ),
        ],
      ),
      ComicPanel('Bogdan zrywa się i ucieka w stronę lasu, znikając między drzewami.'),
      ComicPanel('Kazimierz zostaje sam na śniegu z niepokojącym echem słów Bogdana - "coś, co powinno umrzeć".'),
    ],
  ),
  Comic(
    number: 21,
    week: 53,
    actNumber: 4,
    title: 'Znaki',
    panels: [
      ComicPanel('Wiosna wraca do wioski, ale coś jest nie tak - zwierzęta z lasu masowo uciekają w stronę osady.'),
      ComicPanel('Studnia, mimo ciepłej pogody, pokrywa się nienaturalnym szronem.'),
      ComicPanel(
        'Mieszkańcy szepczą, wskazując w stronę lasu.',
        [ComicLine('Wieśniaczka', 'Widziałam cień między drzewami. Za duży jak na człowieka.')],
      ),
      ComicPanel('Kazimierz obserwuje niepokojąco ciemniejący skrawek lasu na horyzoncie.'),
      ComicPanel('Nocą dziwne odgłosy dobiegają zza granicy posiadłości.'),
      ComicPanel('Kazimierz budzi się zaniepokojony - czas ucieka.'),
    ],
  ),
  Comic(
    number: 22,
    week: 55,
    actNumber: 4,
    title: 'Pełna prawda',
    panels: [
      ComicPanel(
        'Kazimierz konfrontuje Jadwigę ostatni raz, zdeterminowany.',
        [ComicLine('Kazimierz', 'Coś się budzi w tym lesie. Teraz MUSISZ mi powiedzieć wszystko.')],
      ),
      ComicPanel(
        'Jadwiga, widząc powagę sytuacji, łamie milczenie całkowicie.',
        [ComicLine('Jadwiga', 'Nazywają go Leszym. Stary, mroczny opiekun tamtych ziem.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'Jan próbował z nim targować się. O fortunę, o uznanie ojca. Cena była zbyt wysoka.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'Antoni zdołał go powstrzymać - i zapieczętować z powrotem, własnym kosztem.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', '(ciężko) Dług, który od tamtej pory nosił w milczeniu. Dług, który teraz spadł na ciebie.')],
      ),
      ComicPanel('Kazimierz, oszołomiony ciężarem prawdy, patrzy w stronę lasu z nowym zrozumieniem i strachem.'),
    ],
  ),
  Comic(
    number: 23,
    week: 57,
    actNumber: 4,
    title: 'Ostrzeżenie Marty',
    panels: [
      ComicPanel(
        'Marta przybywa do wioski, zdyszana, przestraszona.',
        [ComicLine('Marta', 'Ojciec zniknął. W stronę kopalni. Zabrał ze sobą rzeczy Jana.')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Co on planuje?')]),
      ComicPanel(null, [ComicLine('Marta', '(z rozpaczą) On już nie chce wygrać z tobą. On chce odzyskać mojego brata.')]),
      ComicPanel(null, [ComicLine('Marta', 'Nie wie, co robi. Nikt z nas tego nie wie.')]),
      ComicPanel('Oboje patrzą w stronę ciemniejącego lasu, wiedząc, że czas się kończy.'),
    ],
  ),
  Comic(
    number: 24,
    week: 58,
    actNumber: 4,
    title: 'Przebudzenie',
    panels: [
      ComicPanel(
        'Głęboko w lesie Bogdan, otoczony rzeczami zmarłego syna, kończy mroczny rytuał.',
        [ComicLine('Bogdan', '(szepcze, ze łzami) Wróć do mnie, synu. Choćby w takiej postaci.')],
      ),
      ComicPanel('Ziemia drży, stare pieczęcie pękają z hukiem, ciemność wylewa się z wejścia do kopalni.'),
      ComicPanel('Leszy budzi się w pełni - potężniejszy i głodniejszy niż kiedykolwiek, jego sylwetka wypełnia niebo nad lasem.'),
      ComicPanel(
        'Bogdan cofa się, przerażony tym, co obudził.',
        [ComicLine('Bogdan', '(cicho, z przerażeniem) To... to nie jest mój syn.')],
      ),
      ComicPanel('W wiosce Kazimierz i mieszkańcy widzą narastającą ciemność nad horyzontem.'),
      ComicPanel('Alarm rozbrzmiewa w wiosce - czas przygotować się na starcie.'),
    ],
  ),
  Comic(
    number: 25,
    week: 59,
    actNumber: 4,
    title: 'Cisza przed burzą',
    panels: [
      ComicPanel('Alarm wciąż niesie się nad wioską, ale Leszy nie atakuje od razu - osłabiony własnym przebudzeniem, potrzebuje czasu, by odzyskać pełnię sił.'),
      ComicPanel('Kazimierz wykorzystuje każdą godzinę zwłoki - Palisada wzmacniana dzień i noc, żołnierze szkoleni od świtu do zmierzchu.'),
      ComicPanel('Od dnia przebudzenia nikt nie widział ani nie słyszał o Bogdanie - cisza, która z każdym dniem budzi coraz gorsze przeczucia.'),
      ComicPanel(
        'Marta przybywa do wioski otwarcie, po raz pierwszy nie jako wróg ani szpieg.',
        [ComicLine('Marta', 'Wiem, że to dziwna prośba, biorąc pod uwagę wszystko... ale pomożesz mi go znaleźć?')],
      ),
      ComicPanel(
        null,
        [ComicLine('Kazimierz', 'Nikt nie zasługuje na taki koniec bez odpowiedzi. Nawet on.')],
      ),
      ComicPanel('Wioska zostaje pod strażą, uzbrojona najlepiej, jak zdołała się przygotować, a Kazimierz i Marta wyruszają w stronę lasu, tym razem jako sojusznicy.'),
    ],
  ),
  Comic(
    number: 26,
    week: 60,
    actNumber: 5,
    title: 'Ślady w popiele',
    panels: [
      ComicPanel('Kazimierz i Marta docierają do miejsca rytuału - spalona ziemia, poczerniałe drzewa.'),
      ComicPanel('Przeszukują zgliszcza w milczeniu.'),
      ComicPanel('Znajdują spalone resztki rzeczy Jana - nic więcej.'),
      ComicPanel(
        'Wśród popiołu Marta znajduje jeden przedmiot, nietknięty przez ogień.',
        [ComicLine('Marta', '(podnosząc go, zdziwiona) To... to należało do twojego dziadka.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Kazimierz', 'Skąd to tutaj? Dziadek nigdy więcej tu nie wracał, prawda?')],
      ),
      ComicPanel('Oboje wymieniają spojrzenia pełne nowych, niepokojących pytań.'),
    ],
  ),
  Comic(
    number: 27,
    week: 61,
    actNumber: 5,
    title: 'Pierwsza próba',
    panels: [
      ComicPanel('Kazimierz i Marta odwiedzają Jadwigę z przedmiotem znalezionym w popiele.'),
      ComicPanel(
        'Jadwiga bierze go do ręki, jej twarz tężeje ze zrozumienia.',
        [ComicLine('Jadwiga', 'To nie było pierwsze spotkanie Bogdana z Leszym.')],
      ),
      ComicPanel(null, [ComicLine('Marta', 'Co masz na myśli?')]),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'Twój ojciec próbował już wcześniej. Dawno temu. Nieudanie.')],
      ),
      ComicPanel(
        null,
        [ComicLine('Jadwiga', 'Antoni musiał wtedy interweniować - i zostawić coś w zastaw, żeby go powstrzymać.')],
      ),
      ComicPanel(
        'Marta siada ciężko, oszołomiona.',
        [ComicLine('Marta', 'Więc to trwa dłużej, niż myślałam. Całe moje życie.')],
      ),
      ComicPanel('Kazimierz kładzie dłoń na jej ramieniu - wspólne brzemię łączy ich mocniej niż dawna wrogość.'),
    ],
  ),
  Comic(
    number: 28,
    week: 62,
    actNumber: 5,
    title: 'Prawda o Bogdanie',
    panels: [
      ComicPanel('Tropiąc ostatnie wskazówki, Kazimierz i Marta docierają na samą granicę lasu.'),
      ComicPanel(
        'Tam odnajdują Bogdana - żywego, ale złamanego, postarzałego o dekadę w ciągu kilku tygodni. '
        '(Wariant alternatywny: zamiast Bogdana, znajdują tylko jego rzeczy, porzucone u kresu ścieżki.)',
      ),
      ComicPanel(
        'Bogdan, widząc córkę, nie potrafi spojrzeć jej w oczy.',
        [ComicLine('Bogdan', '(szept) Przepraszam, Marta. Za wszystko. Szukałem syna i straciłem córkę po drodze.')],
      ),
      ComicPanel(
        'Marta podchodzi bliżej, z łzami w oczach, ale bez wahania.',
        [ComicLine('Marta', 'Jeszcze mnie nie straciłeś. Ale musisz mi wreszcie powiedzieć wszystko.')],
      ),
      ComicPanel('Bogdan opowiada resztę prawdy - o pierwszej próbie sprzed lat, o poświęceniu Antoniego, o własnej rozpaczy.'),
      ComicPanel(
        'Marta, słuchając, po raz pierwszy od dwudziestu lat rozumie w pełni i ojca, i brata, i dziedzica, '
        'którego tak długo nienawidziła.',
      ),
    ],
  ),
  Comic(
    number: 29,
    week: 64,
    actNumber: 5,
    title: 'Starcie z Leszym',
    panels: [
      ComicPanel('Leszy nadciąga na wioskę - ogromny, mroczny, nieubłagany.'),
      ComicPanel('Obrona wioski (żołnierze, Palisada) staje do ostatecznej walki.'),
      ComicPanel('Intensywne starcie sił natury i mroku z determinacją obrońców.'),
      ComicPanel('Leszy zostaje pokonany i zmuszony do odwrotu w głąb ziemi, ciemność się cofa.'),
      ComicPanel('Bogdan, wciąż słaby po tym, co przeszedł, patrzy z bezpiecznego dystansu, jak cień, który sam obudził, w końcu ustępuje.'),
      ComicPanel('Wyczerpany, ale żywy Kazimierz rozgląda się po polu bitwy - wioska przetrwała. To już prawie koniec.'),
    ],
  ),
  Comic(
    number: 30,
    week: 65,
    actNumber: 5,
    title: 'Nowy Zasiew - Epilog',
    panels: [
      ComicPanel('Wiosenny poranek - Kazimierz i Marta stoją razem na granicy dawniej spornych posiadłości.'),
      ComicPanel('Oboje sadzą razem młode drzewko dokładnie na granicy - symboliczny gest.'),
      ComicPanel(
        'Jadwiga obserwuje z boku, w jej oczach mieszają się ulga i smutek.',
        [ComicLine('Jadwiga', 'Twój dziadek nosił ten dług dwadzieścia lat.')],
      ),
      ComicPanel(null, [ComicLine('Jadwiga', 'Ty poniosłeś go jeden rok. Może to już wystarczy.')]),
      ComicPanel(
        'Marta patrzy w stronę cichego, spokojnego teraz lasu.',
        [ComicLine('Marta', 'Myślisz, że to już koniec?')],
      ),
      ComicPanel(null, [ComicLine('Kazimierz', 'Chciałbym w to wierzyć.')]),
      ComicPanel('Las, cichy i nieruchomy w wiosennym słońcu. Napis zamykający: "Koniec Roku Pierwszego."'),
    ],
  ),
];

Comic? comicByNumber(int number) {
  for (final comic in kComics) {
    if (comic.number == number) return comic;
  }
  return null;
}

List<Comic> comicsUnlockedThroughWeek(int week) =>
    kComics.where((c) => c.week <= week).toList();
