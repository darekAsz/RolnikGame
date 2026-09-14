// Fabularna oś gry - 6 aktów rozłożonych na 65 tygodni (5 pór roku po 13
// tygodni, druga wiosna podzielona między Akt IV i Akt V). Dane treściowe
// pochodzą z dokumentu fabuły ("Dług Kruka") - patrz zakładka Cele.

/// Jeden z etapów celu głównego w obrębie aktu - wymagania potrafią się
/// zmienić w trakcie aktu (np. dziadek umiera w tygodniu 7 i od tego
/// momentu cel główny Aktu 0 to organizacja pogrzebu, a nie nauka podstaw).
///
/// [goal] to krótkie, praktyczne podsumowanie (nagłówek etapu) - celowo bez
/// konkretnych liczb, bo te pokazuje osobna, żywa lista wymagań z aktualnym
/// postępem (patrz HomeShell._actGoalRequirements/GoalsView). [flavor] to
/// dłuższy, fabularny opis kontekstu tego etapu.
class StoryMilestone {
  final int fromWeek;
  final String goal;
  final String flavor;

  const StoryMilestone({required this.fromWeek, required this.goal, required this.flavor});
}

class StoryAct {
  final int actNumber;
  final String actName;
  final int startWeek;
  final int endWeek;
  // Posortowane rosnąco wg fromWeek; pierwszy element musi mieć
  // fromWeek == startWeek.
  final List<StoryMilestone> milestones;
  final String context;

  const StoryAct({
    required this.actNumber,
    required this.actName,
    required this.startWeek,
    required this.endWeek,
    required this.milestones,
    required this.context,
  });

  bool includesWeek(int week) => week >= startWeek && week <= endWeek;

  /// Cel główny obowiązujący w danym tygodniu - ostatni kamień milowy,
  /// którego fromWeek jest <= week.
  StoryMilestone currentMilestone(int week) {
    var current = milestones.first;
    for (final milestone in milestones) {
      if (milestone.fromWeek <= week) {
        current = milestone;
      } else {
        break;
      }
    }
    return current;
  }
}

const List<StoryAct> kStoryActs = [
  StoryAct(
    actNumber: 0,
    actName: 'Zanim odejdziesz',
    startWeek: 1,
    endWeek: 13,
    milestones: [
      StoryMilestone(
        fromWeek: 1,
        goal: 'Naucz się gospodarki i zbuduj fundamenty wioski',
        flavor:
            'Dziadek, choć coraz słabszy, cierpliwie uczy Cię prowadzenia wioski - jak '
            'rozpoznać dobrą ziemię, kiedy zbierać, komu ufać. Każdy dzień spędzony z nim '
            'to czas, którego później nie odzyskasz.',
      ),
      StoryMilestone(
        fromWeek: 7,
        goal: 'Zorganizuj godny pogrzeb Antoniego',
        flavor:
            'Antoni odszedł we śnie - spokojnie, choć zbyt wcześnie, z dłonią wciąż ciepłą. '
            'Wioska pogrążona jest w żałobie i zasługuje na pożegnanie, na jakie on sam '
            'zapracował przez pół wieku pracy.',
      ),
    ],
    context:
        'Antoni, schorowany, ale wciąż pełen ciepła, oddaje Ci ster wioski i uczy '
        'podstaw gospodarowania. Coraz częściej rzuca niepokojące, urwane uwagi '
        'o przeszłości — i o kimś, kogo imienia nie chce wymówić. Ten czas '
        'nieuchronnie zmierza ku jego śmierci.',
  ),
  StoryAct(
    actNumber: 1,
    actName: 'Ostrzeżenie',
    startWeek: 14,
    endWeek: 26,
    milestones: [
      StoryMilestone(
        fromWeek: 14,
        goal: 'Wzmocnij obronę wioski',
        flavor:
            'Ktoś zaczyna działać przez pośredników, zanim jeszcze pokazał twarz - '
            'plotki, nocny sabotaż, chłodny posłaniec na koniu. Same ostrzeżenia jeszcze '
            'nie bolą, ale wioska musi stanąć na nogi, zanim zamienią się w coś gorszego.',
      ),
      StoryMilestone(
        fromWeek: 23,
        goal: 'Przygotuj się na starcie z Grotem',
        flavor:
            'Grot i jego ludzie żądają trybutu w imieniu kogoś, kto woli na razie '
            'pozostać w cieniu. Odmowa oznacza starcie u bram wioski - lepiej, żeby '
            'zastało Cię gotowym, niż zaskoczonym.',
      ),
    ],
    context:
        'Zaraz po śmierci Antoniego, Bogdan Kruk zaczyna działać przez '
        'pośredników. Plotki, sabotaż i pierwsze wzmianki o dawnym wspólnictwie '
        'dziadka z człowiekiem, którego nazwisko wioska wypowiada z lękiem.',
  ),
  StoryAct(
    actNumber: 2,
    actName: 'Krew rodziny',
    startWeek: 27,
    endWeek: 39,
    milestones: [
      StoryMilestone(
        fromWeek: 27,
        goal: 'Zdobądź pierwsze poszlaki o przeszłości dziadka',
        flavor:
            'Ktoś obserwuje wioskę zza drzew, znika, zanim zdążysz podejść. Jadwiga wie '
            'więcej, niż mówi - czas usiąść z nią przy stole i zacząć zadawać pytania, '
            'na które od dawna nie chce odpowiadać.',
      ),
      StoryMilestone(
        fromWeek: 36,
        goal: 'Przygotuj się na starcie z Martą',
        flavor:
            'Bogdan wysyła własną córkę, żeby dokończyła to, czego nie zdołał Grot. Ale '
            'Marta, wychowana w cieniu żałoby po bracie, sama zaczyna wątpić w wersję '
            'ojca, im bliżej podchodzi do prawdy.',
      ),
    ],
    context:
        'Bogdan wysyła własną córkę, by dokończyła to, czego nie zdołał Grot. '
        'Ale Marta, wychowana w cieniu żałoby po bracie, zaczyna wątpić w '
        'wersję ojca, gdy sama zbliża się do prawdy.',
  ),
  StoryAct(
    actNumber: 3,
    actName: 'Twarzą w twarz',
    startWeek: 40,
    endWeek: 52,
    milestones: [
      StoryMilestone(
        fromWeek: 40,
        goal: 'Zabezpiecz zapasy na zimę i wzmocnij obronę',
        flavor:
            'Plotka o rzekomej zbrodni dziadka rozchodzi się po okolicznych osadach lotem '
            'błyskawicy, coraz bardziej przekręcona z każdym powtórzeniem. Zima nadciąga, '
            'a z nią konfrontacja, której nie da się już dłużej odwlekać.',
      ),
      StoryMilestone(
        fromWeek: 49,
        goal: 'Przygotuj się na starcie z Bogdanem',
        flavor:
            'Bogdan sam staje naprzeciw Ciebie, żądając prawdy albo krwi - dość mu już '
            'pośredników. Wysokie bezpieczeństwo wioski to jedyne, co może go choć trochę '
            'uspokoić, zanim furia weźmie górę.',
      ),
    ],
    context:
        'Bogdan sam staje naprzeciw Ciebie. Prawda o śmierci Jana, syna '
        'Bogdana, zaczyna wychodzić na jaw — ale to wciąż nie jest cała historia.',
  ),
  StoryAct(
    actNumber: 4,
    actName: 'Głodny Cień',
    startWeek: 53,
    endWeek: 59,
    milestones: [
      StoryMilestone(
        fromWeek: 53,
        goal: 'Obserwuj niepokojące znaki i zbrój armię',
        flavor:
            'Wiosna wraca do wioski, ale coś jest nie tak - zwierzęta masowo uciekają '
            'z lasu, studnia pokrywa się szronem mimo ciepłej pogody. Coś się budzi za '
            'granicą posiadłości, i czas ucieka.',
      ),
      StoryMilestone(
        fromWeek: 58,
        goal: 'Przygotuj się na starcie z Leszym',
        flavor:
            'Złamany żalem Bogdan dokończył rytuał, licząc, że odzyska syna. Zamiast '
            'tego obudził coś dużo starszego i dużo głodniejszego - dług, który Antoni '
            'nosił w milczeniu przez dwadzieścia lat, spadł teraz w całości na Ciebie.',
      ),
    ],
    context:
        'Złamany żalem Bogdan budzi na nowo mrocznego ducha lasu, licząc, że '
        'odzyska syna. Cała prawda — o pakcie Jana i poświęceniu Antoniego — '
        'w końcu wychodzi na jaw.',
  ),
  StoryAct(
    actNumber: 5,
    actName: 'Powrót Wiosny',
    startWeek: 60,
    endWeek: 65,
    milestones: [
      StoryMilestone(
        fromWeek: 60,
        goal: 'Rozpocznij poszukiwania Bogdana',
        flavor:
            'Od dnia przebudzenia Leszego nie ma po Bogdanie żadnego znaku życia, a '
            'wioska wciąż czeka na cios, który jeszcze nie padł. Zanim runie na nią '
            'mrok, trzeba go odnaleźć: odwiedź miejsce rytuału, porozmawiaj z Martą i '
            'Jadwigą.',
      ),
      StoryMilestone(
        fromWeek: 64,
        goal: 'Przygotuj się na starcie z Leszym',
        flavor:
            'Bogdan odnaleziony, prawda w końcu poznana - ale to jeszcze nie koniec. '
            'Leszy wciąż czeka w lesie, silniejszy niż kiedykolwiek, i tym razem nie da '
            'się dłużej zwlekać z ostatecznym starciem.',
      ),
    ],
    context:
        'Od Bogdana, zaginionego od dnia przebudzenia Leszego, nie ma żadnego znaku '
        'życia. To czas poszukiwań i odpowiedzi - zanim Leszy uderzy, a sprawa, która '
        'ciążyła nad dwiema rodzinami od dwudziestu lat, zostanie zamknięta raz na '
        'zawsze.',
  ),
];

StoryAct? storyActForWeek(int week) {
  for (final act in kStoryActs) {
    if (act.includesWeek(week)) return act;
  }
  return null;
}
