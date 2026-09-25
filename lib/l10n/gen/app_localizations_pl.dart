// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Rolnik: Dług Kruka';

  @override
  String get commonClose => 'Zamknij';

  @override
  String get statsTitle => 'Statystyki';

  @override
  String get statsTotalCollectedLabel => 'Łącznie zebrane surowce';

  @override
  String get statsLongestPathLabel => 'Najdłuższa ścieżka';

  @override
  String statsLongestPathValue(int count) {
    return '$count kafelków';
  }

  @override
  String get statsMaxSingleHarvestLabel => 'Najwięcej zebrane naraz';

  @override
  String get statsPopulationLabel => 'Populacja';

  @override
  String get statsPopulationDescription =>
      'Ogranicza, ilu mieszkańców można zwerbować jako żołnierzy albo przydzielić jako pracowników do budynków.';

  @override
  String get statsMoraleLabel => 'Morale wioski';

  @override
  String get statsMoraleDescription =>
      'Im wyższe, tym więcej pozytywnych (a mniej negatywnych) wydarzeń tygodniowych. Wysokie morale ułatwia też niektóre walki z bossami.';

  @override
  String get statsSecurityLabel => 'Bezpieczeństwo wioski';

  @override
  String get statsSecurityDescription =>
      'Podnosi PŻ Wioski w finałowym starciu (do +40) i ułatwia niektóre walki z bossami.';

  @override
  String get statsSoldiersLabel => 'Żołnierze (siła armii)';

  @override
  String get statsSoldiersDescription =>
      'Liczba żołnierzy i siła armii (uwzględnia bonus Koszar poziom 2) ułatwiają niektóre walki z bossami.';

  @override
  String get statsComicsLabel => 'Komiksy';

  @override
  String statsComicsUnread(int count) {
    return '$count nieprzeczytanych';
  }

  @override
  String get statsComicsAllRead => 'Wszystko przeczytane';

  @override
  String get statsBoardStyleLabel => 'Wygląd planszy';

  @override
  String get statsBoardStyleNew => 'Nowy';

  @override
  String get statsBoardStyleOld => 'Starszy';

  @override
  String get statsIconStyleLabel => 'Wygląd ikon surowców';

  @override
  String get statsIconStyleNew => 'Nowe';

  @override
  String get statsIconStyleMid => 'Pośrednie';

  @override
  String get statsIconStyleOld => 'Starsze';

  @override
  String get statsLanguageLabel => 'Język';

  @override
  String get statsLanguagePolish => 'Polski';

  @override
  String get statsLanguageEnglish => 'English';

  @override
  String get statsDebugLabel => 'Debug';

  @override
  String get statsReplayTutorialLabel => 'Uruchom samouczek ponownie';

  @override
  String get comicsTitle => 'Komiksy';

  @override
  String comicsUnlockedCount(int unlocked, int total) {
    return '$unlocked z $total odblokowanych';
  }

  @override
  String get comicsNoneYet => 'Pierwszy komiks pojawi się już wkrótce.';

  @override
  String comicsNextUnlocks(int week) {
    return 'Kolejny komiks odblokuje się w tygodniu $week.';
  }

  @override
  String comicsWeekActLabel(int week, int act) {
    return 'Tydzień $week · Akt $act';
  }

  @override
  String get comicsNewBadge => 'NOWY';

  @override
  String comicsWeekLabel(int week) {
    return 'Tydzień $week';
  }

  @override
  String comicsPanelLabel(int panel, int count) {
    return 'Kadr $panel / $count';
  }

  @override
  String get comicsNext => 'Dalej';

  @override
  String get goalsTitle => 'Cele';

  @override
  String goalsWeekOnly(int week) {
    return 'Tydzień $week';
  }

  @override
  String goalsWeekAct(int week, int act, String actName) {
    return 'Tydzień $week — Akt $act: $actName';
  }

  @override
  String get goalsStoryOver =>
      'Historia dobiegła końca. Wioska żyje dalej własnym tempem.';

  @override
  String get goalsMainGoal => 'Cel główny';

  @override
  String get goalsRequirements => 'Warunki';

  @override
  String get goalsSideQuests => 'Questy poboczne';

  @override
  String get goalsNoSideQuestsThisAct => 'Brak questów pobocznych w tym akcie.';

  @override
  String get goalsStoryContext => 'Kontekst fabularny';

  @override
  String get goalsCompletedGoals => 'Ukończone cele';

  @override
  String goalsResolvedActLabel(int act, String name) {
    return 'Akt $act: $name';
  }

  @override
  String get goalsRequirementsMet => 'Warunki spełnione już teraz';

  @override
  String get goalsRequirementsNotMet => 'Warunki jeszcze niespełnione';

  @override
  String goalsDecidedAtEnd(int endWeek) {
    return 'Powyższe warunki decydują o wyniku dopiero na koniec aktu (tydzień $endWeek).';
  }

  @override
  String get harvestGridNoMovesTitle => 'Brak dostępnych ruchów';

  @override
  String get harvestGridNoMovesMessage =>
      'Na planszy nie ma już żadnego możliwego połączenia. Możesz przetasować planszę (koszt: 1 ruch).';

  @override
  String get harvestGridCloseButton => 'Zamknij';

  @override
  String get harvestGridReshuffleButton => 'Przetasuj (−1 ruch)';

  @override
  String get harvestScreenTutorialStep1Title => 'Łącz kulki';

  @override
  String get harvestScreenTutorialStep1Description =>
      'Przeciągnij palcem po sąsiadujących kulkach tego samego surowca (również po skosie) i puść, żeby je zebrać. Im dłuższa ścieżka, tym więcej dostajesz.';

  @override
  String get harvestScreenTutorialStep2Title => 'Dziki joker';

  @override
  String get harvestScreenTutorialStep2Description =>
      'Ścieżka z 5+ kulek zamienia jedną z nowych kulek w jokera - łączy się z każdym surowcem i mnoży zbiory.';

  @override
  String get harvestScreenTutorialStep3Title => 'Bomba';

  @override
  String get harvestScreenTutorialStep3Description =>
      'Ścieżka z 6+ kulek zamienia jedną z nowych kulek w bombę - włączona do kolejnej ścieżki niszczy wszystkie sąsiednie kafelki.';

  @override
  String get harvestScreenTutorialStep4Title => 'Ruchy się kończą';

  @override
  String get harvestScreenTutorialStep4Description =>
      'Każde przeciągnięcie to jeden ruch - licznik na górze pokazuje, ile zostało. Gdy się skończą, runda zbiorów dobiega końca.';

  @override
  String get harvestScreenTutorialBuildOverviewDescription =>
      'Otwiera listę wszystkiego, co możesz teraz zbudować, razem z kosztem i tym, czego jeszcze brakuje w magazynie.';

  @override
  String get harvestScreenRoundEndTitle => '⏳ Koniec ruchów';

  @override
  String get harvestScreenRoundEndCollectedLabel =>
      'Zebrane surowce w tym tygodniu:';

  @override
  String get harvestScreenRoundEndNothingCollected => 'Nic nie zebrano.';

  @override
  String get harvestScreenRoundEndReplayButton => 'Zagraj tydzień ponownie';

  @override
  String get harvestScreenRoundEndReturnButton => 'Wróć do wioski';

  @override
  String get harvestScreenShuffleConfirmTitle => 'Przetasować planszę?';

  @override
  String get harvestScreenShuffleConfirmContent =>
      'Wszystkie kafelki na planszy zostaną losowo przemieszane. Koszt: 1 ruch.';

  @override
  String get harvestScreenShuffleCancelButton => 'Anuluj';

  @override
  String get harvestScreenShuffleConfirmButton => 'Przetasuj (−1 ruch)';

  @override
  String get harvestScreenGiveUpTitle => 'Odpuścić ten tydzień zbiorów?';

  @override
  String get harvestScreenGiveUpContent =>
      'Wrócisz do wioski, a bieżące zbiory w tym tygodniu zostaną przerwane.';

  @override
  String get harvestScreenGiveUpStayButton => 'Zostań';

  @override
  String get harvestScreenGiveUpConfirmButton => 'Odpuść tydzień';

  @override
  String harvestScreenAppBarTitle(int week) {
    return 'Zbiory — Tydzień $week';
  }

  @override
  String get harvestScreenShuffleTooltip => 'Przetasuj planszę (−1 ruch)';

  @override
  String harvestScreenMovesLabel(int moves) {
    return 'Ruchy: $moves';
  }

  @override
  String get shopTitle => 'Sklep';

  @override
  String get shopSubtitle =>
      'Wydaj surowce, żeby na stałe zwiększyć liczbę ruchów na planszy zbiorów.';

  @override
  String get shopMovesPerWeekLabel => 'Ruchy na tydzień';

  @override
  String shopMovesBreakdown(int base, int extra) {
    return 'Baza $base + dokupione $extra';
  }

  @override
  String get shopBuyMoveTitle => '+1 ruch na tydzień (na stałe)';

  @override
  String get shopMaxMovesReached => 'Osiągnięto maksymalną liczbę ruchów.';

  @override
  String get shopBuyButton => 'Kup';

  @override
  String get shopAutoMatchTier1Title => 'Automatyczne usuwanie czwórek';

  @override
  String get shopAutoMatchTier1Description =>
      'Domyślnie kafelki ułożone w ciąg zostają na planszy, dopóki nie zbierzesz ich ręcznie. To ulepszenie sprawia, że ciągi 4+ znikają automatycznie. Nie działa w starciach z bossami - tam liczenie zawsze zostaje ręczne.';

  @override
  String get shopAutoMatchTier2Title =>
      'Ulepszenie: automatyczne usuwanie trójek';

  @override
  String get shopAutoMatchTier2Description =>
      'Kolejny stopień - po tym ulepszeniu automatycznie znikają też ciągi złożone tylko z 3 kafelków. Tak samo jak poprzedni stopień, nie działa w starciach z bossami.';

  @override
  String get shopAutoMatchTier2LockedRequirement =>
      'Wymaga: automatyczne usuwanie czwórek';

  @override
  String get shopUnlockedLabel => 'Odblokowane';

  @override
  String get shopMovesUnlockTitle => 'Jak zwiększyć ten limit';

  @override
  String shopMovesUnlockSklepLevel2(int bonus) {
    return 'Rozbuduj Sklep do poziomu 2 (+$bonus do limitu dokupywanych ruchów)';
  }

  @override
  String shopMovesUnlockSklepWorkers(int current, int max) {
    return 'Zatrudnij pracowników w Sklepie ($current/$max, każdy +1 do limitu)';
  }

  @override
  String shopMovesUnlockDiscovery1(int bonus) {
    return 'Zbadaj w Uczelni \"Podstawy agronomii\" (+$bonus do bazowej liczby ruchów)';
  }

  @override
  String shopMovesUnlockDiscovery2(int bonus) {
    return 'Zbadaj w Uczelni \"Zaawansowaną agronomię\" (+$bonus do bazowej liczby ruchów, wymaga Uczelni poziomu 2)';
  }

  @override
  String get buildOverviewTooltip => 'Co można teraz zbudować';

  @override
  String get buildOverviewTitle => 'Co można teraz zbudować';

  @override
  String get buildOverviewAreasSection => 'Okolice';

  @override
  String get buildOverviewBuildingsSection => 'Wioska';

  @override
  String get buildOverviewEmpty =>
      'Nic więcej nie da się teraz zbudować - najpierw odblokuj kolejne okolice albo Ratusz.';

  @override
  String resourcesViewLockedInfoContent(String resource) {
    return '$resource nie zostało jeszcze odkryte. Dopóki nie odblokujesz go w Okolicach wioski, wszystkie premie do tego surowca (np. z Ratusza czy budynków produkcyjnych) nie będą działać.';
  }

  @override
  String get resourcesViewGotItButton => 'Rozumiem';

  @override
  String get resourcesViewTitle => 'Surowce';

  @override
  String get resourcesViewMarketButton => 'Rynek';

  @override
  String resourcesViewStorageLimit(int cap) {
    return 'Magazyn: limit $cap każdego surowca.';
  }

  @override
  String get resourcesViewProductionConsumptionTitle =>
      'Produkcja i zużycie surowców (tygodniowo)';

  @override
  String get surroundingsTitle => 'Okolice wioski';

  @override
  String get surroundingsSubtitle =>
      'Ścieżka rozwoju: każdy kolejny etap wymaga ukończenia poprzedniego.';

  @override
  String surroundingsRequiresLabel(String prerequisite) {
    return 'Wymaga: $prerequisite';
  }

  @override
  String surroundingsPathBonus(String resource) {
    return '+1 do ścieżki $resource';
  }

  @override
  String surroundingsUnlockResource(String resource) {
    return 'Odblokuj $resource';
  }

  @override
  String get surroundingsLevelMaxLabel => 'Poziom 2/2 - surowiec tygodnia';

  @override
  String get surroundingsLevelUpgradableLabel =>
      'Poziom 1/2 - można rozbudować';

  @override
  String get resourceFlowEmptyState =>
      'Brak zbudowanych źródeł produkcji ani zużycia.';

  @override
  String resourceFlowNetPerWeek(String net) {
    return '$net/tydz.';
  }

  @override
  String get splashNewGameDialogTitle => 'Zacząć nową grę?';

  @override
  String get splashNewGameDialogContent =>
      'To nadpisze i bezpowrotnie usunie obecny zapis gry. Jeśli chcesz kontynuować dotychczasową rozgrywkę, wybierz zamiast tego \"Kontynuuj\".';

  @override
  String get splashCancel => 'Anuluj';

  @override
  String get splashOverwriteAndStart => 'Nadpisz i zacznij od nowa';

  @override
  String get splashTitle => 'Rolnik';

  @override
  String get splashSubtitle => 'Dług Kruka';

  @override
  String get splashNewGame => 'Nowa gra';

  @override
  String get splashContinue => 'Kontynuuj';

  @override
  String get endingTitle => 'Koniec Roku Pierwszego';

  @override
  String get endingContinue => 'Kontynuuj';

  @override
  String get endingStatsCardTitle => 'Rok Pierwszy w liczbach';

  @override
  String get endingStatPopulationLabel => 'Populacja';

  @override
  String endingStatPopulationValue(int population, int populationLimit) {
    return '$population / $populationLimit';
  }

  @override
  String get endingStatMoraleLabel => 'Morale wioski';

  @override
  String endingStatMoraleValue(int value) {
    return '$value%';
  }

  @override
  String get endingStatGrotLabel => 'Starcie z Grotem';

  @override
  String endingStatGrotValue(int cleared) {
    return '$cleared / 3 etapów';
  }

  @override
  String get endingStatSideQuestsLabel => 'Questy poboczne';

  @override
  String endingStatSideQuestsValue(int claimed, int total) {
    return '$claimed / $total';
  }

  @override
  String get endingStatHungerLabel => 'Głód';

  @override
  String get endingStatHungerYes => 'Wioska go zaznała';

  @override
  String get endingStatHungerNo => 'Nigdy nie nawiedził wioski';

  @override
  String get endingTierGoldenLabel => 'Złoty wiek';

  @override
  String get endingTierHardWonLabel => 'Trudne zwycięstwo';

  @override
  String get endingTierScarredLabel => 'Blizny, które zostają';

  @override
  String get endingTierGoldenEpilogue =>
      'Wioska tętni życiem jak nigdy dotąd. Spichlerze pełne, mury mocne, a ludzie nie boją się już zmierzchu. Kazimierz spłacił dług, którego sam nie zaciągnął - i zrobił to z nawiązką, zamieniając brzemię dziadka w fundament czegoś trwałego. Marta zostaje - nie jako wróg, nie z konieczności, ale jako ktoś, kto wreszcie znalazł dom po drugiej stronie granicy, która przestała cokolwiek dzielić.';

  @override
  String get endingTierHardWonEpilogue =>
      'Wioska przetrwała - poobijana, zmęczona, ale wciąż stoi. Nie wszystko poszło gładko: były noce niedostatku i starcia, których wynik ważył się na włosku. Ale dług został spłacony, a Marta i Jadwiga stoją dziś obok Kazimierza jako rodzina, którą sam sobie wybrał - nie tę, którą odziedziczył.';

  @override
  String get endingTierScarredEpilogue =>
      'Zwycięstwo smakuje gorzko. Wioska stoi, dług spłacony, Leszy pokonany - ale cena była wysoka: głodne noce, puste spichlerze, sąsiedzi patrzący na Kazimierza inaczej niż kiedyś na Antoniego. Marta zostaje przy nim, a on sam zaczyna rozumieć, dlaczego dziadek dźwigał tę tajemnicę w milczeniu przez dwadzieścia lat - nie każde zwycięstwo da się świętować.';

  @override
  String get tutorialNextButton => 'Dalej';

  @override
  String get tutorialBackButton => 'Wstecz';

  @override
  String get tutorialSkipButton => 'Pomiń';

  @override
  String get tutorialDoneButton => 'Zakończ';

  @override
  String get actFailureTitle => 'Porażka';

  @override
  String actFailureSubtitle(int actNumber, String actName) {
    return 'Akt $actNumber: \"$actName\" się nie powiódł.';
  }

  @override
  String get actFailureLoadSaveHeader => 'Wczytaj zapis i spróbuj ponownie';

  @override
  String get actFailureNoSavedWeeks => 'Brak zapisanych tygodni.';

  @override
  String actFailureWeekLabel(int week) {
    return 'Tydzień $week';
  }

  @override
  String get actFailureNewGameButton => 'Zacznij nową grę';

  @override
  String weekTransitionWeekLabel(int week) {
    return 'Tydzień $week';
  }

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugSubtitle =>
      'Narzędzia testowe - nie są częścią normalnej rozgrywki.';

  @override
  String get debugJumpToWeekHeader => 'Przejdź do tygodnia';

  @override
  String get debugWeekNumberLabel => 'Numer tygodnia (1-65)';

  @override
  String get debugJumpButton => 'Przejdź';

  @override
  String get debugAddResourcesHeader => 'Dodaj surowce';

  @override
  String get debugAddAllButton => '+100 wszystkich';

  @override
  String debugAddResourceButton(String resource) {
    return '+100 $resource';
  }

  @override
  String get debugBossTrainingHeader => 'Walka treningowa z bossem';

  @override
  String get debugBossTrainingDescription =>
      'Uruchamia starcie od razu, z aktualnymi statystykami wioski - wynik NIE jest zapisywany ani nie wpływa na fabułę/surowce.';

  @override
  String get debugFightGrot => 'Grot (tydz. 26)';

  @override
  String get debugFightMarta => 'Marta (tydz. 39)';

  @override
  String get debugFightBogdan => 'Bogdan (tydz. 52)';

  @override
  String get debugFightLeszy => 'Leszy (tydz. 64)';

  @override
  String bossIntroWeekLabel(int week) {
    return 'Tydzień $week';
  }

  @override
  String get bossIntroPrepareButton => 'Przygotuj się do walki';

  @override
  String get bossStage1Title => 'Etap 1: Umocnienia';

  @override
  String get bossStage1Intro =>
      'Wróg nadciąga. Zbuduj zasieki i wykop doły, zanim dotrze do wioski.';

  @override
  String get bossStage2Title => 'Etap 2: Pułapki';

  @override
  String get bossStage2IntroOne =>
      'Grot i jego ludzie już przy bramie - połącz dłuższe ścieżki, żeby stworzyć bomby, i zdetonuj jedną z nich.';

  @override
  String bossStage2IntroMany(int count) {
    return 'Grot i jego ludzie już przy bramie - połącz dłuższe ścieżki, żeby stworzyć bomby, i zdetonuj $count z nich.';
  }

  @override
  String get bossStage3Title => 'Etap 3: Starcie';

  @override
  String bossStage3Intro(int count) {
    return 'Ostatnia szarża - wśród zamieszania walki wyławiaj miecze ($count), drewno i kamień tylko zawadzają pod ręką.';
  }

  @override
  String bossAppBarTitle(int week) {
    return 'Starcie z Grotem - Tydzień $week';
  }

  @override
  String bossMovesLabel(int moves) {
    return 'Ruchy: $moves';
  }

  @override
  String get bossStartButton => 'Rozpocznij';

  @override
  String bossProgressStage1(
    int wood,
    int woodTarget,
    int stone,
    int stoneTarget,
  ) {
    return 'Drewno $wood/$woodTarget - Kamień $stone/$stoneTarget';
  }

  @override
  String bossProgressStage2(int bombs, int target) {
    return 'Zdetonowane bomby: $bombs/$target';
  }

  @override
  String bossProgressStage3(int swords, int target) {
    return 'Miecze: $swords/$target';
  }

  @override
  String get bossSummaryFullVictoryTitle => '🎉 Pełne zwycięstwo!';

  @override
  String get bossSummaryFullVictoryText =>
      'Grot pada na kolano, pokonany. Wioska obroniła się bez strat.';

  @override
  String get bossSummaryPartialVictoryTitle =>
      '⚔️ Zwycięstwo okupione stratami';

  @override
  String get bossSummaryPartialVictoryText =>
      'Grot się wycofuje, ale starcie kosztowało wioskę część zapasów.';

  @override
  String get bossSummaryDefeatTitle => '💀 Porażka';

  @override
  String get bossSummaryDefeatText =>
      'Grot przełamał obronę wioski i splądrował zapasy.';

  @override
  String bossSummaryStagesCleared(int cleared) {
    return 'Ukończone etapy: $cleared/3';
  }

  @override
  String get bossReturnButton => 'Wróć do wioski';

  @override
  String get martaStage1Title => 'Etap 1: Poszlaki';

  @override
  String martaStage1IntroDefault(int minWood, int minStone) {
    return 'Zbierasz ślady jej wcześniejszego, niezdarnego sabotażu - i strzępki plotek krążących po wiosce. Potrzebujesz dość poszlak, żeby stanąć przed nią z pewnością siebie ($minWood drewna, $minStone kamienia). Ale jeśli przesadzisz, plotka zacznie żyć własnym życiem, zanim zdążysz z nią porozmawiać - trzeba będzie spróbować jeszcze raz, a Marta zrobi się czujniejsza w etapie 2.';
  }

  @override
  String martaStage1IntroOvershot(int minWood, int minStone, int stage2Target) {
    return 'Przesadziłeś/aś - plotka zaczęła żyć własnym życiem, zanim zdążyłeś/aś z nią porozmawiać. Spróbuj ponownie ($minWood drewna, $minStone kamienia) - ale Marta jest już czujniejsza: etap 2 będzie wymagał o jedną chwilę wahania więcej ($stage2Target).';
  }

  @override
  String get martaStage2Title => 'Etap 2: Impas';

  @override
  String get martaStage2IntroOne =>
      'Marta broni się półsercem. Wyłap jedną chwilę wahania w jej ciosach (jokery) - ale unikaj eskalacji, bo agresywne, długie ścieżki (bomby) tylko ją spłoszą i wymagać będzie to więcej cierpliwości.';

  @override
  String martaStage2IntroMany(int count) {
    return 'Marta broni się półsercem. Wyłap $count chwil wahania w jej ciosach (jokery) - ale unikaj eskalacji, bo agresywne, długie ścieżki (bomby) tylko ją spłoszą i wymagać będzie to więcej cierpliwości.';
  }

  @override
  String get martaStage3Title => 'Etap 3: Prawda';

  @override
  String get martaStage3Intro =>
      'Przełamujesz jej milczenie. Zbieraj Prawdę (drewno/kamień/woda na planszy to tylko szum, nie liczą się do niczego) - i nie spiesz się, im więcej ruchów zostanie Ci na koniec, tym pełniejsze będzie jej zaufanie.';

  @override
  String martaAppBarTitle(int week) {
    return 'Starcie z Martą - Tydzień $week';
  }

  @override
  String martaMovesLabel(int moves) {
    return 'Ruchy: $moves';
  }

  @override
  String get martaStartButton => 'Rozpocznij';

  @override
  String martaProgressStage1(
    int wood,
    int minWood,
    int maxWood,
    int stone,
    int minStone,
    int maxStone,
  ) {
    return 'Drewno $wood/$minWood (limit $maxWood) - Kamień $stone/$minStone (limit $maxStone)';
  }

  @override
  String martaProgressStage2(int jokers, int target) {
    return 'Chwile wahania: $jokers/$target';
  }

  @override
  String martaProgressStage3(int truth, int target) {
    return 'Prawda: $truth/$target';
  }

  @override
  String get martaSummaryFullTrustTitle => '🎉 Pełne zaufanie';

  @override
  String get martaSummaryFullTrustText =>
      'Dałeś/aś jej czas, na jaki czekała. Marta mówi Ci wszystko, bez zastrzeżeń.';

  @override
  String get martaSummaryPartialTrustTitle => '🤝 Przełamanie';

  @override
  String get martaSummaryPartialTrustText =>
      'Marta w końcu Ci wierzy - staje się sojuszniczką, choć ostrożną.';

  @override
  String get martaSummaryClashTitle => '⚔️ Częściowe przełamanie';

  @override
  String get martaSummaryClashText =>
      'Marta opuszcza broń, ale wciąż coś ukrywa przed Tobą.';

  @override
  String get martaSummaryWithdrawTitle => '💔 Wycofanie';

  @override
  String get martaSummaryWithdrawText =>
      'Marta zamyka się w sobie i odchodzi, nie zdradzając niczego więcej.';

  @override
  String martaSummaryStagesCleared(int cleared) {
    return 'Ukończone etapy: $cleared/3';
  }

  @override
  String get martaReturnButton => 'Wróć do wioski';

  @override
  String bogdanAppBarTitle(int week) {
    return 'Starcie z Bogdanem - Tydzień $week';
  }

  @override
  String bogdanMovesLabel(int moves) {
    return 'Ruchy: $moves';
  }

  @override
  String get bogdanPeknicieTitle => 'Pęknięcie';

  @override
  String bogdanPeknicieIntro(int limit) {
    return 'Bogdan się waha, sięga po dziennik... Masz $limit ruchów, żeby zebrać jak najwięcej Dowodu, zanim znów się zamknie w gniewie.';
  }

  @override
  String get bogdanFuriaTitle => 'Furia';

  @override
  String bogdanFuriaStartIntro(int calmTarget, int furiaLimit) {
    return 'Bogdan przyjeżdża osobiście, w gniewie. Uspokój go - zbierz $calmTarget wody, zanim skończą się ruchy ($furiaLimit), bo inaczej podpali część magazynu.';
  }

  @override
  String get bogdanFuriaRetryTitle => 'Furia (ponownie)';

  @override
  String bogdanFuriaRetryIntro(int furiaLimit) {
    return 'Bogdan zdążył podpalić część spichlerza! (-15% zboża i jabłek) Spróbuj ponownie - masz $furiaLimit ruchów.';
  }

  @override
  String bogdanFuriaRetryDiscountedIntro(int furiaLimit) {
    return 'Marta wbiegła i powstrzymała ojca! Zdążył podpalić tylko trochę (-5%). Spróbuj ponownie - masz $furiaLimit ruchów.';
  }

  @override
  String bogdanFuriaAfterPeknicieIntro(int calmTarget, int furiaLimit) {
    return 'Bogdan znów wpada w gniew. Uspokój go raz jeszcze - $calmTarget wody, $furiaLimit ruchów.';
  }

  @override
  String bogdanCollectedProofLabel(int current, int target) {
    return 'Zebrany dotąd Dowód: $current/$target';
  }

  @override
  String get bogdanStartButton => 'Rozpocznij';

  @override
  String bogdanProgressFuria(int progress, int target, int movesLeft) {
    return 'Opanowanie: $progress/$target (pozostało $movesLeft ruchów tej próby)';
  }

  @override
  String bogdanProgressPeknicie(int current, int target, int movesLeft) {
    return 'Dowód: $current/$target (pozostało $movesLeft ruchów okna)';
  }

  @override
  String get bogdanSummaryFullVictoryTitle => '🎉 Pełne zwycięstwo';

  @override
  String get bogdanSummaryFullVictoryText =>
      'Bogdan pęka całkowicie pod ciężarem dowodów. Ucieka w las bez zemsty.';

  @override
  String get bogdanSummaryPartialVictoryTitle =>
      '⚔️ Zwycięstwo okupione stratami';

  @override
  String get bogdanSummaryPartialVictoryText =>
      'Bogdan w końcu ucieka, ale zdążył zaszkodzić wiosce po drodze.';

  @override
  String get bogdanSummaryDefeatTitle => '💀 Porażka';

  @override
  String get bogdanSummaryDefeatText =>
      'Ruchy się skończyły, zanim udało się go przełamać. Bogdan odjeżdża, nadal przekonany o swojej racji.';

  @override
  String bogdanSummaryStats(int proof, int target, int burns) {
    return 'Dowód: $proof/$target - Spalenia magazynu: $burns';
  }

  @override
  String get bogdanReturnButton => 'Wróć do wioski';

  @override
  String get leszyAbilityCounterName => 'Kontratak';

  @override
  String get leszyAbilityCounterCost => '-25 wody';

  @override
  String get leszyAbilityCounterEffect => '-10 PŻ Leszemu';

  @override
  String get leszyAbilityGuardName => 'Osłona';

  @override
  String get leszyAbilityGuardCost => '-25 kamienia';

  @override
  String get leszyAbilityGuardEffect =>
      '+10 tarczy (pochłania obrażenia, zeruje się co ruch Leszego)';

  @override
  String get leszyAbilityHealName => 'Uzdrowienie';

  @override
  String get leszyAbilityHealCost => '-25 drewna';

  @override
  String get leszyAbilityHealEffect => '+10 PŻ Wioski, usuwa zatrucie';

  @override
  String get leszyAbilityCleanseName => 'Oczyszczenie';

  @override
  String get leszyAbilityCleanseCost => '-20 drewna, -20 kamienia';

  @override
  String get leszyAbilityCleanseEffect =>
      'zeruje pulę Cienia i usuwa wszystkie kulki Cienia z planszy';

  @override
  String get leszyAbilityPrayerName => 'Modlitwa';

  @override
  String get leszyAbilityPrayerCost => '-20 wody, -20 drewna';

  @override
  String get leszyAbilityPrayerEffect =>
      'osłabia następny cios Leszego o połowę';

  @override
  String get leszyAbilityCalmName => 'Uspokojenie';

  @override
  String get leszyAbilityCalmCost => '-30 wody';

  @override
  String get leszyAbilityCalmEffect => '-3 do siły Leszego';

  @override
  String get leszyAbilityWallName => 'Wzmocnienie muru';

  @override
  String get leszyAbilityWallCost => '-15 drewna, -15 kamienia';

  @override
  String get leszyAbilityWallEffect =>
      '+2 do progu wybuchu Cienia (przeciwdziała Zagęszczeniu cienia)';

  @override
  String get leszyAbilityDispelFuryName => 'Rozproszenie furii';

  @override
  String get leszyAbilityDispelFuryCost => '-15 wody';

  @override
  String get leszyAbilityDispelFuryEffect =>
      'natychmiast anuluje aktywną Furię, zanim zdąży podwoić następny cios (dostępne tylko, gdy Furia aktywna)';

  @override
  String get leszyAbilityAbundanceName => 'Obfitość';

  @override
  String get leszyAbilityAbundanceCost => '-20 wody, -20 kamienia';

  @override
  String get leszyAbilityAbundanceEffect =>
      'podwaja kolejne 3 zebrane ścieżki surowców (włącznie z Mieczem i Tarczą, poza Cieniem)';

  @override
  String leszyMoveStrikeFuryDesc(int base, int doubled) {
    return 'Szykuje wzmocnione uderzenie w wioskę (2×$base = -$doubled PŻ).';
  }

  @override
  String leszyMoveStrikeDesc(int base) {
    return 'Szykuje uderzenie w wioskę (-$base PŻ).';
  }

  @override
  String get leszyMoveDrainDesc =>
      'Chce wyssać najbogatszy zapas surowca i się nim uleczyć (o połowę zabranej ilości).';

  @override
  String leszyMoveShadowDesc(int threshold) {
    return 'Zagęszcza cień - trwale obniża próg wybuchu o 1 (obecnie $threshold).';
  }

  @override
  String get leszyMoveFuryDesc =>
      'Wpada w furię - następny cios będzie podwojony, a on sam potężniejszy (+1 siły).';

  @override
  String get leszyMoveFogDesc =>
      'Ześle mgłę - przetasuje planszę i zamieni część kafelków w cienie.';

  @override
  String get leszyMovePoisonDesc =>
      'Zatruje powietrze - kolejne ruchy zabolą (-5 PŻ), da się to wyleczyć Uzdrowieniem.';

  @override
  String get leszyMoveHungerDesc => 'Głód pochłonie część zapasów.';

  @override
  String get leszyMoveConsumeDesc =>
      'Chce pochłonąć cień z otoczenia i uleczyć się o tyle, ile go pochłonie.';

  @override
  String leszyMoveRendDesc(int base) {
    return 'Szykuje rozdzierające cięcie, które przebija połowę Tarczy (-$base PŻ, częściowo mimo osłony).';
  }

  @override
  String get leszyMoveDespairDesc =>
      'Ogarnia go rozpacz - zaraz gwałtownie wzmocni swoją siłę (+2).';

  @override
  String get leszyMoveBlightDesc =>
      'Skazi część planszy, zamieniając kafelki wprost w Cień.';

  @override
  String get leszyMoveOtherworldDesc =>
      'Wycofuje się częściowo w zaświaty - najbliższe trafienia Mieczem zadadzą tylko połowę obrażeń.';

  @override
  String get leszyMoveCrumblingResolveDesc =>
      'Łamie wolę wioski - jej maksymalne PŻ trwale się skurczy.';

  @override
  String get leszyShadowExplosionWarning =>
      'Cień osiąga próg - za chwilę eksploduje!';

  @override
  String leszyShadowExplosionResult(int damage) {
    return 'Cień eksploduje! (-$damage PŻ Wioski)';
  }

  @override
  String leszyActionStrike(int dmg) {
    return 'Leszy uderza! (-$dmg PŻ Wioski)';
  }

  @override
  String leszyActionDrainSuccess(String resource, int healed) {
    return 'Leszy wysysa $resource i leczy się o $healed!';
  }

  @override
  String get leszyActionDrainFail =>
      'Leszy próbuje wyssać surowiec, ale nic nie ma.';

  @override
  String leszyActionShadowThicken(int threshold) {
    return 'Cień gęstnieje - próg wybuchu spadł do $threshold!';
  }

  @override
  String get leszyActionFury =>
      'Leszy wpada w furię - następny cios będzie silniejszy, a on sam potężniejszy!';

  @override
  String get leszyActionFog =>
      'Mgła spowija planszę - kafelki się przetasowują, część zamienia się w cienie!';

  @override
  String get leszyActionPoison =>
      'Leszy zatruwa powietrze - kolejne ruchy zabolą mocniej.';

  @override
  String get leszyActionHunger => 'Głód Leszego pochłania część zapasów.';

  @override
  String leszyActionConsumeSuccess(int amount) {
    return 'Leszy pochłania cień z otoczenia i leczy się o $amount!';
  }

  @override
  String get leszyActionConsumeFail =>
      'Leszy sięga po cień, ale nie ma czego pochłonąć.';

  @override
  String leszyActionRendPierce(int dmg) {
    return 'Leszy rozdziera wioskę, przebijając połowę Tarczy! (-$dmg PŻ Wioski)';
  }

  @override
  String leszyActionRendClaws(int dmg) {
    return 'Leszy rozdziera wioskę pazurami! (-$dmg PŻ Wioski)';
  }

  @override
  String get leszyActionDespair =>
      'Rozpacz ogarnia Leszego - jego siła rośnie gwałtownie (+2)!';

  @override
  String get leszyActionBlight =>
      'Skażenie rozlewa się po planszy - część kafelków zamienia się w Cień!';

  @override
  String get leszyActionOtherworld =>
      'Leszy wycofuje się częściowo w zaświaty - kolejne trafienia Mieczem osłabione.';

  @override
  String leszyActionCrumblingResolve(int maxHp) {
    return 'Wola wioski pęka pod ciężarem grozy - maks. PŻ Wioski spada do $maxHp!';
  }

  @override
  String leszyAppBarTitle(int week) {
    return 'Starcie z Leszym - Tydzień $week';
  }

  @override
  String leszyMovesUsedLabel(int count) {
    return 'Ruchy: $count';
  }

  @override
  String get leszyPhaseOnslaughtTitle => 'Nawałnica';

  @override
  String get leszyPhaseHeartOfShadowTitle => 'Serce Cienia';

  @override
  String get leszyOnslaughtIntroText =>
      'Leszy uderza na wioskę w pełnej sile. Zbieraj Miecze, żeby go ranić, i Tarcze, żeby przetrwać - a zebrane drewno/kamień/wodę wykorzystaj na zdolności.';

  @override
  String get leszyHeartOfShadowIntroText =>
      'Pierwsza fala pękła, ale z cieni wyłania się jego prawdziwa, głodniejsza forma - silniejsza od pierwszego ruchu i zdolna pożreć sam Cień, żeby się leczyć. To ostatnia próba - Twoje PŻ Wioski nie odnowiły się między starciami.';

  @override
  String leszyIntroHpSummary(
    int villageHp,
    int villageMaxHp,
    int leszyHp,
    int leszyMaxHp,
  ) {
    return 'PŻ Wioski: $villageHp/$villageMaxHp - PŻ Leszego: $leszyHp/$leszyMaxHp';
  }

  @override
  String get leszyStartButton => 'Rozpocznij';

  @override
  String get leszyBoardLegendSwordLabel => 'Miecz';

  @override
  String get leszyBoardLegendSwordDesc => '1 kafelek = 1 obrażenie Leszemu';

  @override
  String get leszyBoardLegendShieldLabel => 'Tarcza';

  @override
  String get leszyBoardLegendShieldDesc => '1 kafelek = 1 punkt osłony Wioski';

  @override
  String get leszyBoardLegendShadowLabel => 'Cień';

  @override
  String leszyBoardLegendShadowDesc(int threshold) {
    return 'Zebranie usuwa go z planszy i dodatkowo obniża pulę Cienia o 5 za kafelek - pełna pula ($threshold, spada z czasem od Zagęszczenia cienia) eksploduje, zadając PŻ Wioski dokładnie tyle, ile pula wynosi w tej chwili.';
  }

  @override
  String get leszyBoardLegendTitle => 'Nowe surowce na planszy';

  @override
  String get leszyBoardLegendResourceNote =>
      'Drewno, kamień i woda dalej działają jak wcześniej - odkładają się w zapasy, które można wydać na zdolności poniżej.';

  @override
  String get leszyAbilitiesTitle => 'Zdolności';

  @override
  String get leszyStatusFuryName => 'Furia';

  @override
  String get leszyStatusFuryDesc =>
      'Furia aktywna - następny cios Leszego będzie podwojony.';

  @override
  String get leszyStatusPoisonName => 'Zatrucie';

  @override
  String leszyStatusPoisonDesc(int ticks) {
    return 'Zatrucie - kolejne $ticks ruch(y) gracza bolą dodatkowo (-5 PŻ Wioski). Da się to wyleczyć Uzdrowieniem.';
  }

  @override
  String get leszyStatusPrayerName => 'Modlitwa';

  @override
  String get leszyStatusPrayerDesc =>
      'Modlitwa aktywna - następny cios Leszego osłabiony o połowę.';

  @override
  String get leszyStatusAbundanceName => 'Obfitość';

  @override
  String leszyStatusAbundanceDesc(int charges) {
    return 'Obfitość aktywna - kolejne $charges zebrane ścieżki (Miecz, Tarcza, drewno/kamień/woda) liczą się podwójnie. Nie dotyczy Cienia.';
  }

  @override
  String get leszyStatusOtherworldName => 'Zaświat';

  @override
  String leszyStatusOtherworldDesc(int charges) {
    return 'Leszy jest częściowo wycofany w zaświaty - kolejne $charges trafienia Mieczem zadadzą tylko połowę obrażeń.';
  }

  @override
  String get leszyCloseButton => 'Zamknij';

  @override
  String get leszyBossName => 'Leszy';

  @override
  String get leszyVillageLabel => 'Wioska';

  @override
  String leszyHpBarLabel(String label, int current, int max) {
    return '$label: $current/$max PŻ';
  }

  @override
  String get leszyMovesUnitOne => 'ruch';

  @override
  String get leszyMovesUnitFew => 'ruchy';

  @override
  String get leszyMovesUnitMany => 'ruchów';

  @override
  String leszyMovesUntilLabel(int count, String unit) {
    return 'Za $count $unit:';
  }

  @override
  String leszyShadowCounterLabel(int current, int threshold) {
    return 'Cień $current/$threshold';
  }

  @override
  String leszyAbilityCostLabel(String cost) {
    return 'Koszt: $cost';
  }

  @override
  String leszyAbilityEffectLabel(String effect) {
    return 'Efekt: $effect';
  }

  @override
  String get leszyNotEnoughResources =>
      'Za mało surowców, żeby teraz użyć tej zdolności.';

  @override
  String get leszyCancelButton => 'Anuluj';

  @override
  String get leszyUseButton => 'Użyj';

  @override
  String get leszyDefeatTitle => '💀 Klęska';

  @override
  String get leszyDefeatMessage =>
      'Leszy okazał się za silny. Wioska nie wytrzymała naporu Cienia.';

  @override
  String get leszyRetryButton => 'Spróbuj ponownie';

  @override
  String get leszyReturnPrepareButton => 'Wróć do wioski, przygotuj się lepiej';

  @override
  String get leszyVictoryTitle => '🎉 Leszy pokonany';

  @override
  String get leszyVictoryMessage =>
      'Cień cofa się w głąb ziemi. Wioska przetrwała najgorszą noc.';

  @override
  String leszyVictoryHpSummary(int hp, int maxHp) {
    return 'PŻ Wioski na koniec: $hp/$maxHp';
  }

  @override
  String get leszyReturnToVillageButton => 'Wróć do wioski';

  @override
  String get homeBuildingNameRatusz => 'Ratusz';

  @override
  String get homeSourceSoldiers => 'Żołnierze';

  @override
  String get homeSourceResidents => 'Mieszkańcy';

  @override
  String get homeBonusSklep =>
      'Odblokowuje zakładkę \"Sklep\" w dolnym pasku nawigacji.';

  @override
  String homeBonusPopulation(int n) {
    return 'Zwiększa limit populacji o $n (widoczne w Statystykach).';
  }

  @override
  String homeBonusKuznia(int n) {
    return 'Co tydzień: +$n złota.';
  }

  @override
  String homeBonusSpichlerz(int n, String pct) {
    return 'Co tydzień: +$n do produkcji jabłek. Zmniejsza ryzyko głodu (utraty zbiorów) o $pct.';
  }

  @override
  String homeBonusPiekarnia(int n) {
    return 'Co tydzień: +$n do produkcji zboża.';
  }

  @override
  String homeBonusTartak(int n) {
    return 'Co tydzień: +$n do produkcji drewna.';
  }

  @override
  String homeBonusStudnia(int n, String pct) {
    return 'Co tydzień: +$n do produkcji wody. Zmniejsza ryzyko pożaru (spalenia zbiorów) o $pct.';
  }

  @override
  String homeBonusMorale(int n) {
    return 'Zwiększa morale wioski o $n (widoczne w Statystykach).';
  }

  @override
  String homeBonusKaplica(String pct, int n) {
    return 'Zmniejsza ogólną szansę zepsucia sezonowego surowca o $pct. Zwiększa morale wioski o $n.';
  }

  @override
  String get homeBonusSzkola =>
      'Odblokowuje odkrycia w Uczelni (panel poniżej) - m.in. +1 do bazowej liczby ruchów i możliwość przydzielania pracowników do budynków.';

  @override
  String homeBonusRynek(int base, int receive, int best) {
    return 'Odblokowuje handel surowcami w zakładce Surowce (kurs $base→$receive, poprawia się z rozbudową, odkryciem Dyplomacji i pracownikami - najlepszy możliwy to $best→$receive).';
  }

  @override
  String homeBonusMagazyn(int n) {
    return 'Zwiększa maksymalną ilość każdego przechowywanego surowca o $n.';
  }

  @override
  String homeBonusKamieniarz(int n) {
    return 'Co tydzień: +$n do produkcji kamienia.';
  }

  @override
  String homeBonusKoszary(int n, int food) {
    return 'Zwiększa bezpieczeństwo wioski o $n. Odblokowuje rekrutację żołnierzy (wymaga zbudowanej Kuźni) - panel poniżej. Każdy żołnierz zużywa $food jabłko/tydzień - przy braku jabłek część zdezerteruje.';
  }

  @override
  String homeUpgradeRatusz(int n) {
    return 'Podwaja premię tygodniową do +$n każdego surowca.';
  }

  @override
  String homeUpgradePalisade(int a, int a2, int b, int b2) {
    return 'Zwiększa limit populacji o kolejne $a (razem +$a2) i bezpieczeństwo wioski o kolejne $b (razem +$b2).';
  }

  @override
  String homeUpgradeSklep(int n) {
    return 'Zwiększa maksymalną liczbę ruchów możliwych do wykupienia w sklepie o $n (niezależnie od bonusu za przydzielonych pracowników).';
  }

  @override
  String homeUpgradePopulation(int n, int n2) {
    return 'Zwiększa limit populacji o kolejne $n (razem +$n2).';
  }

  @override
  String homeUpgradeKuznia(int n, int n2) {
    return 'Zwiększa premię tygodniową o kolejne $n złota (razem +$n2/tydz.).';
  }

  @override
  String homeUpgradeSpichlerz(String pct, String pct2) {
    return 'Dalej zmniejsza ryzyko głodu o kolejne $pct (razem -$pct2). Produkcja jabłek bez zmian.';
  }

  @override
  String homeUpgradePiekarnia(int n, int n2) {
    return 'Zwiększa produkcję zboża o kolejne $n (razem +$n2/tydz.).';
  }

  @override
  String homeUpgradeTartak(int n, int n2) {
    return 'Zwiększa produkcję drewna o kolejne $n (razem +$n2/tydz.).';
  }

  @override
  String homeUpgradeStudnia(String pct, String pct2) {
    return 'Dalej zmniejsza ryzyko pożaru o kolejne $pct (razem -$pct2). Produkcja wody bez zmian.';
  }

  @override
  String homeUpgradeBrowar(int n, int n2) {
    return 'Zwiększa morale wioski o kolejne $n (razem +$n2).';
  }

  @override
  String homeUpgradeKaplica(int n, int n2) {
    return 'Całkowicie usuwa ogólną szansę zepsucia (od tego budynku) i zwiększa morale wioski o kolejne $n (razem +$n2).';
  }

  @override
  String get homeUpgradeSzkola =>
      'Odblokowuje zaawansowane odkrycia - m.in. kolejne +1 do bazowej liczby ruchów (razem +2) i limit 2 pracowników na budynek.';

  @override
  String homeUpgradeRynek(int after, int receive, int best) {
    return 'Poprawia kurs wymiany do $after→$receive (jeden z 3 niezależnych ulepszeń do najlepszego możliwego kursu $best→$receive).';
  }

  @override
  String homeUpgradeMagazyn(int n, int n2) {
    return 'Zwiększa limit magazynowania o kolejne $n (razem +$n2).';
  }

  @override
  String homeUpgradeKamieniarz(int n, int n2) {
    return 'Zwiększa produkcję kamienia o kolejne $n (razem +$n2/tydz.).';
  }

  @override
  String homeUpgradeKoszary(int n, int n2) {
    return 'Zwiększa bezpieczeństwo wioski o kolejne $n (razem +$n2) i podwaja siłę każdego żołnierza.';
  }

  @override
  String homeBonusLineSimple(String label, num base, String unit) {
    return '$label: $base$unit';
  }

  @override
  String homeBonusLineWithWorkers(
    String label,
    num base,
    String unit,
    String sign,
    num workerBonus,
    num total,
  ) {
    return '$label: baza $base$unit, pracownicy $sign$workerBonus$unit → premia ogólna $total$unit';
  }

  @override
  String homeBonusPercentSimple(String label, String pct) {
    return '$label: $pct';
  }

  @override
  String homeBonusPercentWithWorkers(
    String label,
    String basePct,
    String totalPct,
  ) {
    return '$label: baza $basePct, z pracownikami → premia ogólna $totalPct';
  }

  @override
  String get homeLabelResourceProduction => 'Produkcja każdego surowca';

  @override
  String get homeLabelPopulationLimit => 'Limit populacji';

  @override
  String get homeLabelSecurity => 'Bezpieczeństwo';

  @override
  String get homeSklepLockedBonusNote =>
      'Odblokowuje zakładkę Sklep (liczbowa premia dopiero po rozbudowie).';

  @override
  String homeSklepMovesBonusText(int max, int workers) {
    return 'Maks. liczba ruchów do wykupienia: $max (w tym +$workers od pracowników).';
  }

  @override
  String get homeLabelGoldPerWeek => 'Złoto/tydz.';

  @override
  String get homeLabelAppleProductionPerWeek => 'Produkcja jabłek/tydz.';

  @override
  String get homeLabelHungerRiskReduction => 'Redukcja ryzyka głodu';

  @override
  String get homeLabelGrainProductionPerWeek => 'Produkcja zboża/tydz.';

  @override
  String get homeLabelWoodProductionPerWeek => 'Produkcja drewna/tydz.';

  @override
  String get homeLabelWaterProductionPerWeek => 'Produkcja wody/tydz.';

  @override
  String get homeLabelFireRiskReduction => 'Redukcja ryzyka pożaru';

  @override
  String get homeLabelVillageMorale => 'Morale wioski';

  @override
  String get homeLabelSpoilRiskReduction => 'Redukcja ogólnej szansy zepsucia';

  @override
  String homeMarketRateBonus(int give, int receive, int best) {
    return 'Kurs wymiany: $give→$receive (najlepszy możliwy: $best→$receive = 2:1)';
  }

  @override
  String get homeLabelWarehouseLimit => 'Limit magazynu';

  @override
  String get homeLabelStoneProductionPerWeek => 'Produkcja kamienia/tydz.';

  @override
  String get homeResourcesNotUnlockedMessage =>
      'Najpierw odkryj wszystkie surowce w Okolicach (zbuduj Sad, Łąkę i Pole).';

  @override
  String get homeTabVillage => 'Wioska';

  @override
  String get homeTabSurroundings => 'Okolice';

  @override
  String get homeTabResources => 'Surowce';

  @override
  String get homeTabShop => 'Sklep';

  @override
  String get homeTabStats => 'Statystyki';

  @override
  String get homeTabGoals => 'Cele';

  @override
  String get homeTabDebug => 'Debug';

  @override
  String get homeTutorialNavBarTitle => 'Pasek nawigacji';

  @override
  String get homeTutorialNavBarDesc =>
      'Zakładki u dołu przełączają między ekranami wioski. Przejdziemy teraz po kolei przez każdy z nich.';

  @override
  String get homeTutorialVillageDesc =>
      'Dotknij pustej działki, żeby zbudować budynek, albo gotowego budynku, żeby go rozbudować lub zobaczyć szczegóły. Ratusz buduje się jako pierwszy i odblokowuje resztę.';

  @override
  String get homeTutorialSurroundingsDesc =>
      'Tereny wokół wioski (rzeka, las, góry...) - ich zabudowa powiększa planszę zbiorów i daje premie do surowców.';

  @override
  String get homeTutorialResourcesDesc =>
      'Podgląd zapasów, produkcji i zużycia tygodniowego każdego surowca, a stąd też wymiana na targu, gdy Rynek jest gotowy.';

  @override
  String get homeTutorialShopDesc =>
      'Kupuj dodatkowe ruchy na planszy zbiorów i ulepszenia automatycznego dopasowywania (odblokowuje się w trakcie gry).';

  @override
  String get homeTutorialStatsDesc =>
      'Rekordy, populacja, morale, bezpieczeństwo, armia i komiksy fabularne, a także wybór wyglądu planszy zbiorów.';

  @override
  String get homeTutorialGoalsDesc =>
      'Cel bieżącego aktu fabuły i questy poboczne - oba dają surowce do magazynu po ukończeniu.';

  @override
  String get homeTutorialArrowTitle => 'Przycisk \"→\"';

  @override
  String get homeTutorialArrowDesc =>
      'Kończy tydzień i przenosi do planszy zbiorów (albo starcia z bossem, jeśli akurat wypada).';

  @override
  String get homeConfirmDemolishTitle => 'Zburzyć budynek?';

  @override
  String homeConfirmDemolishMessage(String name) {
    return 'Na pewno chcesz zburzyć: $name?\nOdzyskasz połowę zainwestowanych surowców.';
  }

  @override
  String get homeCancel => 'Anuluj';

  @override
  String get homeDemolish => 'Zburz';

  @override
  String homeRatuszBonusText(int n) {
    return 'Co tydzień: +$n każdego surowca.\nZłoto zebrane w ścieżce daje dodatkowo +1 (np. 4 w ścieżce = 5).\nWymaga odblokowania wszystkich surowców w Okolicach. Musi zostać zbudowany jako pierwszy budynek wioski - odblokowuje budowę pozostałych, a jego rozbudowa (poziom 2) odblokowuje ich rozbudowę.';
  }

  @override
  String get homeRatuszUpgradedSnack => 'Ratusz rozbudowany!';

  @override
  String get homeBuildingNamePalisade => 'Palisada';

  @override
  String homePalisadeBonusText(int pop, int sec) {
    return 'Zwiększa limit populacji o $pop i bezpieczeństwo wioski o $sec (widoczne w Statystykach).';
  }

  @override
  String get homePalisadeUpgradedSnack => 'Palisada rozbudowana!';

  @override
  String get homePalisadeDemolishedSnack =>
      'Palisada zburzona - odzyskano połowę surowców.';

  @override
  String get homeMilitaryTitle => 'Wojsko';

  @override
  String homeMilitaryTotalStrength(int n) {
    return 'Łączna siła armii: $n';
  }

  @override
  String homeMilitaryAvailableResidents(int n) {
    return 'Dostępni mieszkańcy: $n (każda rekrutacja zabiera jednego z wioski).';
  }

  @override
  String get homeMilitaryRequiresForge =>
      'Rekrutacja wymaga zbudowanej Kuźni (broń dla żołnierzy).';

  @override
  String get homeMilitaryNotEnoughResidents =>
      'Za mało mieszkańców, żeby rekrutować kolejnego żołnierza.';

  @override
  String homeMilitaryUnitLine(String label, int count, int strength) {
    return '$label: $count (siła każdego: $strength)';
  }

  @override
  String homeMilitaryRecruitButton(int pop, int gold, String extra) {
    return 'Rekrutuj (-$pop mieszkaniec, -$gold złota$extra)';
  }

  @override
  String get homeDiscoveriesTitle => 'Odkrycia';

  @override
  String get homeDiscoveryUnlocked => 'Odkryto';

  @override
  String homeDiscoveryRequiresLevel(int n) {
    return 'Wymaga Uczelni na poziomie $n.';
  }

  @override
  String homeDiscoveryUnlockButton(String cost) {
    return 'Odkryj ($cost)';
  }

  @override
  String homeBuildingUpgradedSnack(String label) {
    return '$label rozbudowany!';
  }

  @override
  String homeBuildingDemolishedSnack(String label) {
    return '$label: budynek zburzony - odzyskano połowę surowców.';
  }

  @override
  String get homeBuildingNameDom => 'Dom';

  @override
  String get homeLevel0 => 'Poziom 0';

  @override
  String get homeRebuildToLevel1 => 'Odbuduj do poziomu 1';

  @override
  String get homeDecrepitHouseNotDemolishable =>
      'Opuszczonego domu nie można zburzyć - w środku wciąż mieszkają ludzie.';

  @override
  String get homeDecrepitHouseBonusText =>
      'Dom stoi opuszczony i zaniedbany od lat - obecnie nie daje żadnego bonusu do populacji.';

  @override
  String homeDecrepitHouseUpgradeText(int n) {
    return 'Odbuduj dom, żeby zaczął dawać +$n do limitu populacji.';
  }

  @override
  String get homeHouseRebuiltSnack =>
      'Dom odbudowany - znów daje bonus do populacji!';

  @override
  String get homeHouseDemolishedSnack =>
      'Dom zburzony - odzyskano połowę surowców.';

  @override
  String get homeMarketTradeTitle => 'Rynek - handel';

  @override
  String homeMarketRateLine(int give, int receive) {
    return 'Kurs: $give surowca za $receive innego.';
  }

  @override
  String homeMarketGiveOption(String label, int have) {
    return 'Daj: $label (masz $have)';
  }

  @override
  String homeMarketReceiveOption(String label) {
    return 'Otrzymaj: $label';
  }

  @override
  String get homeMax => 'Maks.';

  @override
  String homeMarketSummaryLine(
    int totalGive,
    String giveLabel,
    int totalReceive,
    String receiveLabel,
  ) {
    return 'Razem: oddajesz $totalGive $giveLabel, dostajesz $totalReceive $receiveLabel.';
  }

  @override
  String homeMarketNotEnough(String label) {
    return 'Za mało $label, żeby wymienić choć raz.';
  }

  @override
  String get homeClose => 'Zamknij';

  @override
  String homeMarketTradeSnack(
    int totalGive,
    String giveLabel,
    int totalReceive,
    String receiveLabel,
  ) {
    return 'Wymieniono $totalGive $giveLabel na $totalReceive $receiveLabel.';
  }

  @override
  String get homeExchangeButton => 'Wymień';

  @override
  String homeMoveBoughtSnack(int total) {
    return 'Kupiono +1 ruch na tydzień! Teraz: $total ruchów.';
  }

  @override
  String get homeAutoMatchTier1Snack =>
      'Odblokowano automatyczne usuwanie czwórek!';

  @override
  String get homeAutoMatchTier2Snack =>
      'Odblokowano automatyczne usuwanie trójek!';

  @override
  String homeAreaBuildFirst(String label) {
    return 'Najpierw zbuduj: $label.';
  }

  @override
  String homeAreaBonusStarter(String label) {
    return '$label jest już dostępne na planszy zbiorów - ten budynek daje dodatkowo +1 do każdej zebranej ścieżki tego surowca.';
  }

  @override
  String homeAreaBonusUnlock(String label) {
    return 'Odblokowuje $label jako nowy surowiec do zbierania na planszy zbiorów.';
  }

  @override
  String homeAreaUpgradeText(String label) {
    return 'Odblokowuje możliwość wyboru $label jako \"surowca tygodnia\" (10-20% więcej na planszy zbiorów w wybranym tygodniu).';
  }

  @override
  String homeAreaUpgradedSnack(String label, String resource) {
    return '$label rozbudowany! Możesz teraz wybierać $resource jako surowiec tygodnia.';
  }

  @override
  String homeTitleUpgradedSuffix(String title) {
    return '$title (rozbudowany)';
  }

  @override
  String homeTitleBuiltSuffix(String title) {
    return '$title (zbudowany)';
  }

  @override
  String get homeAreaBuildCostTitle => 'Koszt budowy (poziom 1)';

  @override
  String get homeEffectLabel => 'Efekt';

  @override
  String get homeLevel1 => 'Poziom 1';

  @override
  String get homeUpgradeToLevel2 => 'Rozbudowa do poziomu 2';

  @override
  String get homeLevel2 => 'Poziom 2';

  @override
  String get homeBuild => 'Zbuduj';

  @override
  String get homeUpgrade => 'Rozbuduj';

  @override
  String get homeMainBuildingNotDemolishable =>
      'Głównego budynku wioski nie można zburzyć.';

  @override
  String get homeLocked => 'Zablokowane';

  @override
  String get homeBuildRatuszFirst =>
      'Najpierw zbuduj Ratusz (główny budynek wioski).';

  @override
  String get homeBuildCostTitle => 'Koszt budowy';

  @override
  String get homePerksLabel => 'Premie';

  @override
  String get homeDemolishRefund50Title => 'Odzysk przy zburzeniu (50%)';

  @override
  String get homeRequiresUpgradedRatusz =>
      'Wymaga rozbudowanego (poziom 2) Ratusza.';

  @override
  String get homeRatuszLevel2LockedRequirement =>
      'Rozbudowa Ratusza odblokuje się w Akcie II (tydzień 27).';

  @override
  String get homeGeneralBonusTitle => 'Premia ogólna';

  @override
  String get homeWorkersTitle => 'Pracownicy';

  @override
  String get homeWorkersRequiresDiscovery =>
      'Wymaga odkrycia \"Zarządzanie pracownikami\" w Uczelni.';

  @override
  String homeWorkerBonusExplanation(int max, String multiplier) {
    return 'Każdy przydzielony mieszkaniec zwiększa premię budynku o +50% (maks. $max = $multiplier premia).';
  }

  @override
  String get homeWorkerMultiplierDouble => 'podwójna';

  @override
  String homeAvailableResidents(int n) {
    return 'Wolni mieszkańcy: $n';
  }

  @override
  String get homeWeeklyBoostTitle => 'Surowiec tygodnia';

  @override
  String get homeWeeklyBoostDescription =>
      'Dzięki rozbudowanym (poziom 2) okolicom wioski możesz wybrać surowiec, który w tym tygodniu będzie pojawiał się częściej (+10-20%).';

  @override
  String get homeSkipButton => 'Pomiń';

  @override
  String homeEventChoiceResultSnack(
    String title,
    String resultText,
    String bonus,
  ) {
    return '$title: $resultText$bonus';
  }

  @override
  String homeEventResultSnack(
    String icon,
    String title,
    String description,
    String bonus,
  ) {
    return '$icon $title: $description$bonus';
  }

  @override
  String get homeEventUnitMorale => 'morale';

  @override
  String get homeEventUnitSecurity => 'bezpieczeństwa';

  @override
  String get homeEventUnitPopulation => 'populacji';

  @override
  String get homeEventUnitSoldiers => 'żołnierzy';

  @override
  String get homeEventLossesSuffix => '(straty)';

  @override
  String get homeGoalNotFoughtYet => 'jeszcze nie stoczono';

  @override
  String homeGoalBattleProgress(int cleared, int required) {
    return '$cleared/3 etapów (min. $required)';
  }

  @override
  String get homeGoalRatuszBuilt => 'Ratusz zbudowany';

  @override
  String get homeGoalRatuszUpgraded => 'Ratusz rozbudowany do poziomu 2';

  @override
  String get homeGoalOrchardDeveloped => 'Sad rozwinięty';

  @override
  String get homeGoalMeadowDeveloped => 'Łąka rozwinięta';

  @override
  String get homeGoalFieldDeveloped => 'Pole rozwinięte';

  @override
  String get homeGoalBattleGrot => 'Starcie z Grotem';

  @override
  String get homeGoalBattleMarta => 'Starcie z Martą';

  @override
  String get homeGoalBogdanProof => 'Pełny Dowód zebrany u Bogdana';

  @override
  String get homeGoalArmyStrength => 'Siła armii';

  @override
  String get homeGoalVillageSecurity => 'Bezpieczeństwo wioski';

  @override
  String get homeGoalLeszyDefeated => 'Leszy pokonany';

  @override
  String get homeGoalQuestSladyWPopiele => 'Quest \"Ślady w popiele\"';

  @override
  String get homeGoalQuestRozmowaZJadwiga => 'Quest \"Rozmowa z Jadwigą\"';

  @override
  String homeSideQuestMoraleProgress(int n) {
    return '$n/70 morale';
  }

  @override
  String homeSideQuestArmyStrengthProgress(int n) {
    return '$n/20 siły armii';
  }

  @override
  String get homeBuilt => 'zbudowana';

  @override
  String get homeNotBuilt => 'niezbudowana';

  @override
  String homeSideQuestGrotKarczmaProgress(int stages, String karczma) {
    return 'Grot: $stages/3 etapów (min. 2) • Karczma: $karczma';
  }

  @override
  String get homeGrotVictoryFullSnack =>
      'Grot pokonany bez strat! Łup: +15 złota, +15 drewna.';

  @override
  String get homeGrotVictoryPartialSnack =>
      'Grot odparty, ale starcie kosztowało wioskę: -10% drewna i złota.';

  @override
  String homeGrotDefeatSnack(int cleared) {
    return 'Grot przełamał obronę wioski - ukończono tylko $cleared/3 etapów starcia.';
  }

  @override
  String get homeMartaVictoryFullTrustSnack =>
      'Marta w pełni Ci zaufała, dając sobie czas na rozmowę: +15 morale.';

  @override
  String get homeMartaVictoryTrustSnack =>
      'Marta przełamana - staje się sojuszniczką: +10 morale.';

  @override
  String get homeMartaVictoryPartialSnack =>
      'Marta częściowo Ci zaufała, ale wciąż coś ukrywa.';

  @override
  String homeMartaDefeatSnack(int cleared) {
    return 'Marta wycofała się, nie zdradzając niczego więcej - ukończono tylko $cleared/3 etapów starcia.';
  }

  @override
  String get homeBogdanVictoryFullSnack =>
      'Bogdan pęka całkowicie pod ciężarem dowodów i ucieka bez zemsty.';

  @override
  String homeBogdanVictoryPartialSnack(int burns) {
    return 'Bogdan ucieka, ale zdążył podpalić część magazynu ($burns raz(y)) po drodze.';
  }

  @override
  String homeBogdanDefeatSnack(int burns) {
    return 'Nie udało się przełamać Bogdana - magazyn ucierpiał $burns raz(y), a on wciąż jest przekonany o swojej racji.';
  }

  @override
  String homeDebugGrotResultSnack(int cleared) {
    return 'Debug: starcie z Grotem zakończone - $cleared/3 etapów (bez wpływu na zapis gry).';
  }

  @override
  String homeDebugMartaResultSnack(int cleared, String suffix) {
    return 'Debug: starcie z Martą zakończone - $cleared/3 etapów$suffix (bez wpływu na zapis gry).';
  }

  @override
  String get homeDebugMartaFullTrustSuffix => ' (pełne zaufanie)';

  @override
  String homeDebugBogdanResultSnack(String proof, int burns) {
    return 'Debug: starcie z Bogdanem zakończone - Dowód $proof, $burns spalenie(a) (bez wpływu na zapis gry).';
  }

  @override
  String get homeDebugProofGathered => 'zebrany';

  @override
  String get homeDebugProofIncomplete => 'niepełny';

  @override
  String homeDebugLeszyResultSnack(String result) {
    return 'Debug: starcie z Leszym zakończone - $result (bez wpływu na zapis gry).';
  }

  @override
  String get homeDebugVictory => 'zwycięstwo';

  @override
  String get homeDebugDefeat => 'porażka';

  @override
  String get homeActFailure0 =>
      'Wioska nie zdążyła przygotować się na czas - dziedzictwo Antoniego zostało zaprzepaszczone.';

  @override
  String get homeActFailure1 =>
      'Grot przełamał obronę nieprzygotowanej wioski.';

  @override
  String get homeActFailure2 =>
      'Marta nie zdradziła kluczowej prawdy, a wioska straciła nadzieję.';

  @override
  String get homeActFailure3 =>
      'Osłabiona głodem i słabą obroną wioska nie przetrwała konfrontacji z Bogdanem.';

  @override
  String get homeActFailure4 =>
      'Wioska nie zdążyła się przygotować - armia zbyt słaba, mury zbyt kruche na to, co nadchodzi z lasu.';

  @override
  String get homeActFailure5 =>
      'Leszy został pokonany, ale niektóre wątki pozostają niedomknięte - historia kończy się bez pełnej odpowiedzi.';

  @override
  String get homeActFailureDefault => 'Cel tego aktu nie został osiągnięty.';

  @override
  String get homeBossIntroGrotMessage =>
      'Grot i jego zbrojni zbliżają się do wioski. Czas przygotować obronę.';

  @override
  String get homeBossIntroMartaMessage =>
      'Marta staje naprzeciw Ciebie, uzbrojona, wysłana przez ojca. Nie ma odwrotu.';

  @override
  String get homeBossIntroBogdanMessage =>
      'Bogdan Kruk przybywa osobiście, żądając prawdy. Konfrontacja jest nieunikniona.';

  @override
  String get homeBossIntroLeszyMessage =>
      'Mroczny cień lasu budzi się w pełni. Ostateczne starcie o los wioski zaczyna się teraz.';

  @override
  String get homeLeszyVictorySnack =>
      'Leszy pokonany! Cień cofa się w głąb ziemi.';

  @override
  String homeActGoalReachedSnack(int actNumber, String actName, String reward) {
    return 'Cel Aktu $actNumber (\"$actName\") osiągnięty! ($reward)';
  }

  @override
  String homeSideQuestCompletedSnack(String title, String reward) {
    return 'Quest poboczny ukończony: \"$title\" ($reward)';
  }

  @override
  String homeDebugJumpedToWeekSnack(int week) {
    return 'Debug: przeniesiono do tygodnia $week.';
  }

  @override
  String get homeExitGameTitle => 'Wyjść z gry?';

  @override
  String get homeExitGameMessage => 'Na pewno chcesz zamknąć Rolnika?';

  @override
  String get homeExit => 'Wyjdź';
}
