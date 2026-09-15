import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
  ];

  /// Nazwa aplikacji (tytuł okna/menedżera zadań).
  ///
  /// In pl, this message translates to:
  /// **'Rolnik: Dług Kruka'**
  String get appTitle;

  /// No description provided for @commonClose.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get commonClose;

  /// No description provided for @statsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Statystyki'**
  String get statsTitle;

  /// No description provided for @statsXpLabel.
  ///
  /// In pl, this message translates to:
  /// **'Doświadczenie'**
  String get statsXpLabel;

  /// No description provided for @statsXpValue.
  ///
  /// In pl, this message translates to:
  /// **'{xp} XP'**
  String statsXpValue(int xp);

  /// No description provided for @statsTotalCollectedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Łącznie zebrane surowce'**
  String get statsTotalCollectedLabel;

  /// No description provided for @statsLongestPathLabel.
  ///
  /// In pl, this message translates to:
  /// **'Najdłuższa ścieżka'**
  String get statsLongestPathLabel;

  /// No description provided for @statsLongestPathValue.
  ///
  /// In pl, this message translates to:
  /// **'{count} kafelków'**
  String statsLongestPathValue(int count);

  /// No description provided for @statsMaxSingleHarvestLabel.
  ///
  /// In pl, this message translates to:
  /// **'Najwięcej zebrane naraz'**
  String get statsMaxSingleHarvestLabel;

  /// No description provided for @statsPopulationLabel.
  ///
  /// In pl, this message translates to:
  /// **'Populacja'**
  String get statsPopulationLabel;

  /// No description provided for @statsPopulationDescription.
  ///
  /// In pl, this message translates to:
  /// **'Ogranicza, ilu mieszkańców można zwerbować jako żołnierzy albo przydzielić jako pracowników do budynków.'**
  String get statsPopulationDescription;

  /// No description provided for @statsMoraleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Morale wioski'**
  String get statsMoraleLabel;

  /// No description provided for @statsMoraleDescription.
  ///
  /// In pl, this message translates to:
  /// **'Im wyższe, tym więcej pozytywnych (a mniej negatywnych) wydarzeń tygodniowych. Wysokie morale ułatwia też niektóre walki z bossami.'**
  String get statsMoraleDescription;

  /// No description provided for @statsSecurityLabel.
  ///
  /// In pl, this message translates to:
  /// **'Bezpieczeństwo wioski'**
  String get statsSecurityLabel;

  /// No description provided for @statsSecurityDescription.
  ///
  /// In pl, this message translates to:
  /// **'Podnosi PŻ Wioski w finałowym starciu (do +40) i ułatwia niektóre walki z bossami.'**
  String get statsSecurityDescription;

  /// No description provided for @statsSoldiersLabel.
  ///
  /// In pl, this message translates to:
  /// **'Żołnierze (siła armii)'**
  String get statsSoldiersLabel;

  /// No description provided for @statsSoldiersDescription.
  ///
  /// In pl, this message translates to:
  /// **'Liczba żołnierzy i siła armii (uwzględnia bonus Koszar poziom 2) ułatwiają niektóre walki z bossami.'**
  String get statsSoldiersDescription;

  /// No description provided for @statsComicsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Komiksy'**
  String get statsComicsLabel;

  /// No description provided for @statsComicsUnread.
  ///
  /// In pl, this message translates to:
  /// **'{count} nieprzeczytanych'**
  String statsComicsUnread(int count);

  /// No description provided for @statsComicsAllRead.
  ///
  /// In pl, this message translates to:
  /// **'Wszystko przeczytane'**
  String get statsComicsAllRead;

  /// No description provided for @statsBoardStyleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wygląd planszy'**
  String get statsBoardStyleLabel;

  /// No description provided for @statsBoardStyleNew.
  ///
  /// In pl, this message translates to:
  /// **'Nowy'**
  String get statsBoardStyleNew;

  /// No description provided for @statsBoardStyleOld.
  ///
  /// In pl, this message translates to:
  /// **'Starszy'**
  String get statsBoardStyleOld;

  /// No description provided for @statsIconStyleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wygląd ikon surowców'**
  String get statsIconStyleLabel;

  /// No description provided for @statsIconStyleNew.
  ///
  /// In pl, this message translates to:
  /// **'Nowe'**
  String get statsIconStyleNew;

  /// No description provided for @statsIconStyleMid.
  ///
  /// In pl, this message translates to:
  /// **'Pośrednie'**
  String get statsIconStyleMid;

  /// No description provided for @statsIconStyleOld.
  ///
  /// In pl, this message translates to:
  /// **'Starsze'**
  String get statsIconStyleOld;

  /// No description provided for @statsLanguageLabel.
  ///
  /// In pl, this message translates to:
  /// **'Język'**
  String get statsLanguageLabel;

  /// No description provided for @statsLanguagePolish.
  ///
  /// In pl, this message translates to:
  /// **'Polski'**
  String get statsLanguagePolish;

  /// No description provided for @statsLanguageEnglish.
  ///
  /// In pl, this message translates to:
  /// **'English'**
  String get statsLanguageEnglish;

  /// No description provided for @comicsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Komiksy'**
  String get comicsTitle;

  /// No description provided for @comicsUnlockedCount.
  ///
  /// In pl, this message translates to:
  /// **'{unlocked} z {total} odblokowanych'**
  String comicsUnlockedCount(int unlocked, int total);

  /// No description provided for @comicsNoneYet.
  ///
  /// In pl, this message translates to:
  /// **'Pierwszy komiks pojawi się już wkrótce.'**
  String get comicsNoneYet;

  /// No description provided for @comicsNextUnlocks.
  ///
  /// In pl, this message translates to:
  /// **'Kolejny komiks odblokuje się w tygodniu {week}.'**
  String comicsNextUnlocks(int week);

  /// No description provided for @comicsWeekActLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week} · Akt {act}'**
  String comicsWeekActLabel(int week, int act);

  /// No description provided for @comicsNewBadge.
  ///
  /// In pl, this message translates to:
  /// **'NOWY'**
  String get comicsNewBadge;

  /// No description provided for @comicsWeekLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week}'**
  String comicsWeekLabel(int week);

  /// No description provided for @comicsPanelLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kadr {panel} / {count}'**
  String comicsPanelLabel(int panel, int count);

  /// No description provided for @comicsNext.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get comicsNext;

  /// No description provided for @goalsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Cele'**
  String get goalsTitle;

  /// No description provided for @goalsWeekOnly.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week}'**
  String goalsWeekOnly(int week);

  /// No description provided for @goalsWeekAct.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week} — Akt {act}: {actName}'**
  String goalsWeekAct(int week, int act, String actName);

  /// No description provided for @goalsStoryOver.
  ///
  /// In pl, this message translates to:
  /// **'Historia dobiegła końca. Wioska żyje dalej własnym tempem.'**
  String get goalsStoryOver;

  /// No description provided for @goalsMainGoal.
  ///
  /// In pl, this message translates to:
  /// **'Cel główny'**
  String get goalsMainGoal;

  /// No description provided for @goalsRequirements.
  ///
  /// In pl, this message translates to:
  /// **'Warunki'**
  String get goalsRequirements;

  /// No description provided for @goalsSideQuests.
  ///
  /// In pl, this message translates to:
  /// **'Questy poboczne'**
  String get goalsSideQuests;

  /// No description provided for @goalsStoryContext.
  ///
  /// In pl, this message translates to:
  /// **'Kontekst fabularny'**
  String get goalsStoryContext;

  /// No description provided for @goalsCompletedGoals.
  ///
  /// In pl, this message translates to:
  /// **'Ukończone cele'**
  String get goalsCompletedGoals;

  /// No description provided for @goalsResolvedActLabel.
  ///
  /// In pl, this message translates to:
  /// **'Akt {act}: {name}'**
  String goalsResolvedActLabel(int act, String name);

  /// No description provided for @goalsRequirementsMet.
  ///
  /// In pl, this message translates to:
  /// **'Warunki spełnione już teraz'**
  String get goalsRequirementsMet;

  /// No description provided for @goalsRequirementsNotMet.
  ///
  /// In pl, this message translates to:
  /// **'Warunki jeszcze niespełnione'**
  String get goalsRequirementsNotMet;

  /// No description provided for @goalsDecidedAtEnd.
  ///
  /// In pl, this message translates to:
  /// **'Powyższe warunki decydują o wyniku dopiero na koniec aktu (tydzień {endWeek}).'**
  String goalsDecidedAtEnd(int endWeek);

  /// No description provided for @goalsQuestXp.
  ///
  /// In pl, this message translates to:
  /// **'{title} (+{xp} XP)'**
  String goalsQuestXp(String title, int xp);

  /// No description provided for @harvestGridNoMovesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Brak dostępnych ruchów'**
  String get harvestGridNoMovesTitle;

  /// No description provided for @harvestGridNoMovesMessage.
  ///
  /// In pl, this message translates to:
  /// **'Na planszy nie ma już żadnego możliwego połączenia. Możesz przetasować planszę (koszt: 1 ruch).'**
  String get harvestGridNoMovesMessage;

  /// No description provided for @harvestGridCloseButton.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get harvestGridCloseButton;

  /// No description provided for @harvestGridReshuffleButton.
  ///
  /// In pl, this message translates to:
  /// **'Przetasuj (−1 ruch)'**
  String get harvestGridReshuffleButton;

  /// No description provided for @harvestScreenTutorialStep1Title.
  ///
  /// In pl, this message translates to:
  /// **'Łącz kulki'**
  String get harvestScreenTutorialStep1Title;

  /// No description provided for @harvestScreenTutorialStep1Description.
  ///
  /// In pl, this message translates to:
  /// **'Przeciągnij palcem po sąsiadujących kulkach tego samego surowca (również po skosie) i puść, żeby je zebrać. Im dłuższa ścieżka, tym więcej dostajesz.'**
  String get harvestScreenTutorialStep1Description;

  /// No description provided for @harvestScreenTutorialStep2Title.
  ///
  /// In pl, this message translates to:
  /// **'Dziki joker'**
  String get harvestScreenTutorialStep2Title;

  /// No description provided for @harvestScreenTutorialStep2Description.
  ///
  /// In pl, this message translates to:
  /// **'Ścieżka z 5+ kulek zamienia jedną z nowych kulek w jokera - łączy się z każdym surowcem i mnoży zbiory.'**
  String get harvestScreenTutorialStep2Description;

  /// No description provided for @harvestScreenTutorialStep3Title.
  ///
  /// In pl, this message translates to:
  /// **'Bomba'**
  String get harvestScreenTutorialStep3Title;

  /// No description provided for @harvestScreenTutorialStep3Description.
  ///
  /// In pl, this message translates to:
  /// **'Ścieżka z 6+ kulek zamienia jedną z nowych kulek w bombę - włączona do kolejnej ścieżki niszczy wszystkie sąsiednie kafelki.'**
  String get harvestScreenTutorialStep3Description;

  /// No description provided for @harvestScreenTutorialStep4Title.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy się kończą'**
  String get harvestScreenTutorialStep4Title;

  /// No description provided for @harvestScreenTutorialStep4Description.
  ///
  /// In pl, this message translates to:
  /// **'Każde przeciągnięcie to jeden ruch - licznik na górze pokazuje, ile zostało. Gdy się skończą, runda zbiorów dobiega końca.'**
  String get harvestScreenTutorialStep4Description;

  /// No description provided for @harvestScreenTutorialDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Jak zbierać surowce'**
  String get harvestScreenTutorialDialogTitle;

  /// No description provided for @harvestScreenTutorialGotItButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozumiem'**
  String get harvestScreenTutorialGotItButton;

  /// No description provided for @harvestScreenRoundEndTitle.
  ///
  /// In pl, this message translates to:
  /// **'⏳ Koniec ruchów'**
  String get harvestScreenRoundEndTitle;

  /// No description provided for @harvestScreenRoundEndCollectedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zebrane surowce w tym tygodniu:'**
  String get harvestScreenRoundEndCollectedLabel;

  /// No description provided for @harvestScreenRoundEndNothingCollected.
  ///
  /// In pl, this message translates to:
  /// **'Nic nie zebrano.'**
  String get harvestScreenRoundEndNothingCollected;

  /// No description provided for @harvestScreenRoundEndReplayButton.
  ///
  /// In pl, this message translates to:
  /// **'Zagraj tydzień ponownie'**
  String get harvestScreenRoundEndReplayButton;

  /// No description provided for @harvestScreenRoundEndReturnButton.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do wioski'**
  String get harvestScreenRoundEndReturnButton;

  /// No description provided for @harvestScreenShuffleConfirmTitle.
  ///
  /// In pl, this message translates to:
  /// **'Przetasować planszę?'**
  String get harvestScreenShuffleConfirmTitle;

  /// No description provided for @harvestScreenShuffleConfirmContent.
  ///
  /// In pl, this message translates to:
  /// **'Wszystkie kafelki na planszy zostaną losowo przemieszane. Koszt: 1 ruch.'**
  String get harvestScreenShuffleConfirmContent;

  /// No description provided for @harvestScreenShuffleCancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get harvestScreenShuffleCancelButton;

  /// No description provided for @harvestScreenShuffleConfirmButton.
  ///
  /// In pl, this message translates to:
  /// **'Przetasuj (−1 ruch)'**
  String get harvestScreenShuffleConfirmButton;

  /// No description provided for @harvestScreenGiveUpTitle.
  ///
  /// In pl, this message translates to:
  /// **'Odpuścić ten tydzień zbiorów?'**
  String get harvestScreenGiveUpTitle;

  /// No description provided for @harvestScreenGiveUpContent.
  ///
  /// In pl, this message translates to:
  /// **'Wrócisz do wioski, a bieżące zbiory w tym tygodniu zostaną przerwane.'**
  String get harvestScreenGiveUpContent;

  /// No description provided for @harvestScreenGiveUpStayButton.
  ///
  /// In pl, this message translates to:
  /// **'Zostań'**
  String get harvestScreenGiveUpStayButton;

  /// No description provided for @harvestScreenGiveUpConfirmButton.
  ///
  /// In pl, this message translates to:
  /// **'Odpuść tydzień'**
  String get harvestScreenGiveUpConfirmButton;

  /// No description provided for @harvestScreenAppBarTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zbiory — Tydzień {week}'**
  String harvestScreenAppBarTitle(int week);

  /// No description provided for @harvestScreenShuffleTooltip.
  ///
  /// In pl, this message translates to:
  /// **'Przetasuj planszę (−1 ruch)'**
  String get harvestScreenShuffleTooltip;

  /// No description provided for @harvestScreenMovesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy: {moves}'**
  String harvestScreenMovesLabel(int moves);

  /// No description provided for @shopTitle.
  ///
  /// In pl, this message translates to:
  /// **'Sklep'**
  String get shopTitle;

  /// No description provided for @shopSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Wydaj złoto, żeby na stałe zwiększyć liczbę ruchów na planszy zbiorów.'**
  String get shopSubtitle;

  /// No description provided for @shopMovesPerWeekLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy na tydzień'**
  String get shopMovesPerWeekLabel;

  /// No description provided for @shopMovesBreakdown.
  ///
  /// In pl, this message translates to:
  /// **'Baza {base} + dokupione {extra}'**
  String shopMovesBreakdown(int base, int extra);

  /// No description provided for @shopBuyMoveTitle.
  ///
  /// In pl, this message translates to:
  /// **'+1 ruch na tydzień (na stałe)'**
  String get shopBuyMoveTitle;

  /// No description provided for @shopGoldAvailable.
  ///
  /// In pl, this message translates to:
  /// **'Masz: {gold} złota'**
  String shopGoldAvailable(int gold);

  /// No description provided for @shopMaxMovesReached.
  ///
  /// In pl, this message translates to:
  /// **'Osiągnięto maksymalną liczbę ruchów.'**
  String get shopMaxMovesReached;

  /// No description provided for @shopCost.
  ///
  /// In pl, this message translates to:
  /// **'Koszt: {cost} złota'**
  String shopCost(int cost);

  /// No description provided for @shopBuyButton.
  ///
  /// In pl, this message translates to:
  /// **'Kup'**
  String get shopBuyButton;

  /// No description provided for @shopAutoMatchTier1Title.
  ///
  /// In pl, this message translates to:
  /// **'Automatyczne usuwanie czwórek'**
  String get shopAutoMatchTier1Title;

  /// No description provided for @shopAutoMatchTier1Description.
  ///
  /// In pl, this message translates to:
  /// **'Domyślnie kafelki ułożone w ciąg zostają na planszy, dopóki nie zbierzesz ich ręcznie. To ulepszenie sprawia, że ciągi 4+ znikają automatycznie. Nie działa w starciach z bossami - tam liczenie zawsze zostaje ręczne.'**
  String get shopAutoMatchTier1Description;

  /// No description provided for @shopAutoMatchTier2Title.
  ///
  /// In pl, this message translates to:
  /// **'Ulepszenie: automatyczne usuwanie trójek'**
  String get shopAutoMatchTier2Title;

  /// No description provided for @shopAutoMatchTier2Description.
  ///
  /// In pl, this message translates to:
  /// **'Kolejny stopień - po tym ulepszeniu automatycznie znikają też ciągi złożone tylko z 3 kafelków. Tak samo jak poprzedni stopień, nie działa w starciach z bossami.'**
  String get shopAutoMatchTier2Description;

  /// No description provided for @shopAutoMatchTier2LockedRequirement.
  ///
  /// In pl, this message translates to:
  /// **'Wymaga: automatyczne usuwanie czwórek'**
  String get shopAutoMatchTier2LockedRequirement;

  /// No description provided for @shopUnlockedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowane'**
  String get shopUnlockedLabel;

  /// No description provided for @resourcesViewLockedInfoContent.
  ///
  /// In pl, this message translates to:
  /// **'{resource} nie zostało jeszcze odkryte. Dopóki nie odblokujesz go w Okolicach wioski, wszystkie premie do tego surowca (np. z Ratusza czy budynków produkcyjnych) nie będą działać.'**
  String resourcesViewLockedInfoContent(String resource);

  /// No description provided for @resourcesViewGotItButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozumiem'**
  String get resourcesViewGotItButton;

  /// No description provided for @resourcesViewTitle.
  ///
  /// In pl, this message translates to:
  /// **'Surowce'**
  String get resourcesViewTitle;

  /// No description provided for @resourcesViewMarketButton.
  ///
  /// In pl, this message translates to:
  /// **'Rynek'**
  String get resourcesViewMarketButton;

  /// No description provided for @resourcesViewStorageLimit.
  ///
  /// In pl, this message translates to:
  /// **'Magazyn: limit {cap} każdego surowca.'**
  String resourcesViewStorageLimit(int cap);

  /// No description provided for @resourcesViewProductionConsumptionTitle.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja i zużycie surowców (tygodniowo)'**
  String get resourcesViewProductionConsumptionTitle;

  /// No description provided for @surroundingsTitle.
  ///
  /// In pl, this message translates to:
  /// **'Okolice wioski'**
  String get surroundingsTitle;

  /// No description provided for @surroundingsSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Ścieżka rozwoju: każdy kolejny etap wymaga ukończenia poprzedniego.'**
  String get surroundingsSubtitle;

  /// No description provided for @surroundingsRequiresLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wymaga: {prerequisite}'**
  String surroundingsRequiresLabel(String prerequisite);

  /// No description provided for @surroundingsPathBonus.
  ///
  /// In pl, this message translates to:
  /// **'+1 do ścieżki {resource}'**
  String surroundingsPathBonus(String resource);

  /// No description provided for @surroundingsUnlockResource.
  ///
  /// In pl, this message translates to:
  /// **'Odblokuj {resource}'**
  String surroundingsUnlockResource(String resource);

  /// No description provided for @surroundingsLevelMaxLabel.
  ///
  /// In pl, this message translates to:
  /// **'Poziom 2/2 - surowiec tygodnia'**
  String get surroundingsLevelMaxLabel;

  /// No description provided for @surroundingsLevelUpgradableLabel.
  ///
  /// In pl, this message translates to:
  /// **'Poziom 1/2 - można rozbudować'**
  String get surroundingsLevelUpgradableLabel;

  /// No description provided for @resourceFlowEmptyState.
  ///
  /// In pl, this message translates to:
  /// **'Brak zbudowanych źródeł produkcji ani zużycia.'**
  String get resourceFlowEmptyState;

  /// No description provided for @resourceFlowNetPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'{net}/tydz.'**
  String resourceFlowNetPerWeek(String net);

  /// No description provided for @splashNewGameDialogTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zacząć nową grę?'**
  String get splashNewGameDialogTitle;

  /// No description provided for @splashNewGameDialogContent.
  ///
  /// In pl, this message translates to:
  /// **'To nadpisze i bezpowrotnie usunie obecny zapis gry. Jeśli chcesz kontynuować dotychczasową rozgrywkę, wybierz zamiast tego \"Kontynuuj\".'**
  String get splashNewGameDialogContent;

  /// No description provided for @splashCancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get splashCancel;

  /// No description provided for @splashOverwriteAndStart.
  ///
  /// In pl, this message translates to:
  /// **'Nadpisz i zacznij od nowa'**
  String get splashOverwriteAndStart;

  /// No description provided for @splashTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rolnik'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Dług Kruka'**
  String get splashSubtitle;

  /// No description provided for @splashNewGame.
  ///
  /// In pl, this message translates to:
  /// **'Nowa gra'**
  String get splashNewGame;

  /// No description provided for @splashContinue.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get splashContinue;

  /// No description provided for @endingTitle.
  ///
  /// In pl, this message translates to:
  /// **'Koniec Roku Pierwszego'**
  String get endingTitle;

  /// No description provided for @endingContinue.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get endingContinue;

  /// No description provided for @endingStatsCardTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rok Pierwszy w liczbach'**
  String get endingStatsCardTitle;

  /// No description provided for @endingStatPopulationLabel.
  ///
  /// In pl, this message translates to:
  /// **'Populacja'**
  String get endingStatPopulationLabel;

  /// No description provided for @endingStatPopulationValue.
  ///
  /// In pl, this message translates to:
  /// **'{population} / {populationLimit}'**
  String endingStatPopulationValue(int population, int populationLimit);

  /// No description provided for @endingStatMoraleLabel.
  ///
  /// In pl, this message translates to:
  /// **'Morale wioski'**
  String get endingStatMoraleLabel;

  /// No description provided for @endingStatMoraleValue.
  ///
  /// In pl, this message translates to:
  /// **'{value}%'**
  String endingStatMoraleValue(int value);

  /// No description provided for @endingStatXpLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zdobyte doświadczenie'**
  String get endingStatXpLabel;

  /// No description provided for @endingStatXpValue.
  ///
  /// In pl, this message translates to:
  /// **'{xp} XP'**
  String endingStatXpValue(int xp);

  /// No description provided for @endingStatGrotLabel.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Grotem'**
  String get endingStatGrotLabel;

  /// No description provided for @endingStatGrotValue.
  ///
  /// In pl, this message translates to:
  /// **'{cleared} / 3 etapów'**
  String endingStatGrotValue(int cleared);

  /// No description provided for @endingStatSideQuestsLabel.
  ///
  /// In pl, this message translates to:
  /// **'Questy poboczne'**
  String get endingStatSideQuestsLabel;

  /// No description provided for @endingStatSideQuestsValue.
  ///
  /// In pl, this message translates to:
  /// **'{claimed} / {total}'**
  String endingStatSideQuestsValue(int claimed, int total);

  /// No description provided for @endingStatHungerLabel.
  ///
  /// In pl, this message translates to:
  /// **'Głód'**
  String get endingStatHungerLabel;

  /// No description provided for @endingStatHungerYes.
  ///
  /// In pl, this message translates to:
  /// **'Wioska go zaznała'**
  String get endingStatHungerYes;

  /// No description provided for @endingStatHungerNo.
  ///
  /// In pl, this message translates to:
  /// **'Nigdy nie nawiedził wioski'**
  String get endingStatHungerNo;

  /// No description provided for @endingTierGoldenLabel.
  ///
  /// In pl, this message translates to:
  /// **'Złoty wiek'**
  String get endingTierGoldenLabel;

  /// No description provided for @endingTierHardWonLabel.
  ///
  /// In pl, this message translates to:
  /// **'Trudne zwycięstwo'**
  String get endingTierHardWonLabel;

  /// No description provided for @endingTierScarredLabel.
  ///
  /// In pl, this message translates to:
  /// **'Blizny, które zostają'**
  String get endingTierScarredLabel;

  /// No description provided for @endingTierGoldenEpilogue.
  ///
  /// In pl, this message translates to:
  /// **'Wioska tętni życiem jak nigdy dotąd. Spichlerze pełne, mury mocne, a ludzie nie boją się już zmierzchu. Kazimierz spłacił dług, którego sam nie zaciągnął - i zrobił to z nawiązką, zamieniając brzemię dziadka w fundament czegoś trwałego. Marta zostaje - nie jako wróg, nie z konieczności, ale jako ktoś, kto wreszcie znalazł dom po drugiej stronie granicy, która przestała cokolwiek dzielić.'**
  String get endingTierGoldenEpilogue;

  /// No description provided for @endingTierHardWonEpilogue.
  ///
  /// In pl, this message translates to:
  /// **'Wioska przetrwała - poobijana, zmęczona, ale wciąż stoi. Nie wszystko poszło gładko: były noce niedostatku i starcia, których wynik ważył się na włosku. Ale dług został spłacony, a Marta i Jadwiga stoją dziś obok Kazimierza jako rodzina, którą sam sobie wybrał - nie tę, którą odziedziczył.'**
  String get endingTierHardWonEpilogue;

  /// No description provided for @endingTierScarredEpilogue.
  ///
  /// In pl, this message translates to:
  /// **'Zwycięstwo smakuje gorzko. Wioska stoi, dług spłacony, Leszy pokonany - ale cena była wysoka: głodne noce, puste spichlerze, sąsiedzi patrzący na Kazimierza inaczej niż kiedyś na Antoniego. Marta zostaje przy nim, a on sam zaczyna rozumieć, dlaczego dziadek dźwigał tę tajemnicę w milczeniu przez dwadzieścia lat - nie każde zwycięstwo da się świętować.'**
  String get endingTierScarredEpilogue;

  /// No description provided for @tutorialAppBarTitle.
  ///
  /// In pl, this message translates to:
  /// **'Jak grać'**
  String get tutorialAppBarTitle;

  /// No description provided for @tutorialStep1Title.
  ///
  /// In pl, this message translates to:
  /// **'Łącz surowce'**
  String get tutorialStep1Title;

  /// No description provided for @tutorialStep1Description.
  ///
  /// In pl, this message translates to:
  /// **'Przeciągnij palcem po sąsiadujących kafelkach tego samego surowca (również po skosie), żeby je zebrać.'**
  String get tutorialStep1Description;

  /// No description provided for @tutorialStep2Title.
  ///
  /// In pl, this message translates to:
  /// **'Dziki joker'**
  String get tutorialStep2Title;

  /// No description provided for @tutorialStep2Description.
  ///
  /// In pl, this message translates to:
  /// **'Za dłuższą ścieżkę (5 i więcej kafelków) dostajesz jokera - łączy się z każdym surowcem i mnoży zbiory.'**
  String get tutorialStep2Description;

  /// No description provided for @tutorialStep3Title.
  ///
  /// In pl, this message translates to:
  /// **'Bomba'**
  String get tutorialStep3Title;

  /// No description provided for @tutorialStep3Description.
  ///
  /// In pl, this message translates to:
  /// **'Za jeszcze dłuższą ścieżkę (6 i więcej) dostajesz bombę - włączona do ścieżki niszczy sąsiednie kafelki.'**
  String get tutorialStep3Description;

  /// No description provided for @tutorialStep4Title.
  ///
  /// In pl, this message translates to:
  /// **'Rozbuduj wioskę'**
  String get tutorialStep4Title;

  /// No description provided for @tutorialStep4Description.
  ///
  /// In pl, this message translates to:
  /// **'Zebrane surowce zostają w wiosce między tygodniami - w przyszłości posłużą do jej rozbudowy.'**
  String get tutorialStep4Description;

  /// No description provided for @tutorialFinishButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozumiem, zaczynamy!'**
  String get tutorialFinishButton;

  /// No description provided for @actFailureTitle.
  ///
  /// In pl, this message translates to:
  /// **'Porażka'**
  String get actFailureTitle;

  /// No description provided for @actFailureSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Akt {actNumber}: \"{actName}\" się nie powiódł.'**
  String actFailureSubtitle(int actNumber, String actName);

  /// No description provided for @actFailureLoadSaveHeader.
  ///
  /// In pl, this message translates to:
  /// **'Wczytaj zapis i spróbuj ponownie'**
  String get actFailureLoadSaveHeader;

  /// No description provided for @actFailureNoSavedWeeks.
  ///
  /// In pl, this message translates to:
  /// **'Brak zapisanych tygodni.'**
  String get actFailureNoSavedWeeks;

  /// No description provided for @actFailureWeekLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week}'**
  String actFailureWeekLabel(int week);

  /// No description provided for @actFailureNewGameButton.
  ///
  /// In pl, this message translates to:
  /// **'Zacznij nową grę'**
  String get actFailureNewGameButton;

  /// No description provided for @weekTransitionWeekLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week}'**
  String weekTransitionWeekLabel(int week);

  /// No description provided for @debugTitle.
  ///
  /// In pl, this message translates to:
  /// **'Debug'**
  String get debugTitle;

  /// No description provided for @debugSubtitle.
  ///
  /// In pl, this message translates to:
  /// **'Narzędzia testowe - nie są częścią normalnej rozgrywki.'**
  String get debugSubtitle;

  /// No description provided for @debugJumpToWeekHeader.
  ///
  /// In pl, this message translates to:
  /// **'Przejdź do tygodnia'**
  String get debugJumpToWeekHeader;

  /// No description provided for @debugWeekNumberLabel.
  ///
  /// In pl, this message translates to:
  /// **'Numer tygodnia (1-65)'**
  String get debugWeekNumberLabel;

  /// No description provided for @debugJumpButton.
  ///
  /// In pl, this message translates to:
  /// **'Przejdź'**
  String get debugJumpButton;

  /// No description provided for @debugAddResourcesHeader.
  ///
  /// In pl, this message translates to:
  /// **'Dodaj surowce'**
  String get debugAddResourcesHeader;

  /// No description provided for @debugAddAllButton.
  ///
  /// In pl, this message translates to:
  /// **'+100 wszystkich'**
  String get debugAddAllButton;

  /// No description provided for @debugAddResourceButton.
  ///
  /// In pl, this message translates to:
  /// **'+100 {resource}'**
  String debugAddResourceButton(String resource);

  /// No description provided for @debugBossTrainingHeader.
  ///
  /// In pl, this message translates to:
  /// **'Walka treningowa z bossem'**
  String get debugBossTrainingHeader;

  /// No description provided for @debugBossTrainingDescription.
  ///
  /// In pl, this message translates to:
  /// **'Uruchamia starcie od razu, z aktualnymi statystykami wioski - wynik NIE jest zapisywany ani nie wpływa na fabułę/surowce.'**
  String get debugBossTrainingDescription;

  /// No description provided for @debugFightGrot.
  ///
  /// In pl, this message translates to:
  /// **'Grot (tydz. 26)'**
  String get debugFightGrot;

  /// No description provided for @debugFightMarta.
  ///
  /// In pl, this message translates to:
  /// **'Marta (tydz. 39)'**
  String get debugFightMarta;

  /// No description provided for @debugFightBogdan.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan (tydz. 52)'**
  String get debugFightBogdan;

  /// No description provided for @debugFightLeszy.
  ///
  /// In pl, this message translates to:
  /// **'Leszy (tydz. 59)'**
  String get debugFightLeszy;

  /// No description provided for @bossIntroWeekLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tydzień {week}'**
  String bossIntroWeekLabel(int week);

  /// No description provided for @bossIntroPrepareButton.
  ///
  /// In pl, this message translates to:
  /// **'Przygotuj się do walki'**
  String get bossIntroPrepareButton;

  /// No description provided for @bossStage1Title.
  ///
  /// In pl, this message translates to:
  /// **'Etap 1: Umocnienia'**
  String get bossStage1Title;

  /// No description provided for @bossStage1Intro.
  ///
  /// In pl, this message translates to:
  /// **'Wróg nadciąga. Zbuduj zasieki i wykop doły, zanim dotrze do wioski.'**
  String get bossStage1Intro;

  /// No description provided for @bossStage2Title.
  ///
  /// In pl, this message translates to:
  /// **'Etap 2: Pułapki'**
  String get bossStage2Title;

  /// No description provided for @bossStage2IntroOne.
  ///
  /// In pl, this message translates to:
  /// **'Grot i jego ludzie już przy bramie - połącz dłuższe ścieżki, żeby stworzyć bomby, i zdetonuj jedną z nich.'**
  String get bossStage2IntroOne;

  /// No description provided for @bossStage2IntroMany.
  ///
  /// In pl, this message translates to:
  /// **'Grot i jego ludzie już przy bramie - połącz dłuższe ścieżki, żeby stworzyć bomby, i zdetonuj {count} z nich.'**
  String bossStage2IntroMany(int count);

  /// No description provided for @bossStage3Title.
  ///
  /// In pl, this message translates to:
  /// **'Etap 3: Starcie'**
  String get bossStage3Title;

  /// No description provided for @bossStage3Intro.
  ///
  /// In pl, this message translates to:
  /// **'Ostatnia szarża - wśród zamieszania walki wyławiaj miecze ({count}), drewno i kamień tylko zawadzają pod ręką.'**
  String bossStage3Intro(int count);

  /// No description provided for @bossAppBarTitle.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Grotem - Tydzień {week}'**
  String bossAppBarTitle(int week);

  /// No description provided for @bossMovesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy: {moves}'**
  String bossMovesLabel(int moves);

  /// No description provided for @bossStartButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij'**
  String get bossStartButton;

  /// No description provided for @bossProgressStage1.
  ///
  /// In pl, this message translates to:
  /// **'Drewno {wood}/{woodTarget} - Kamień {stone}/{stoneTarget}'**
  String bossProgressStage1(
    int wood,
    int woodTarget,
    int stone,
    int stoneTarget,
  );

  /// No description provided for @bossProgressStage2.
  ///
  /// In pl, this message translates to:
  /// **'Zdetonowane bomby: {bombs}/{target}'**
  String bossProgressStage2(int bombs, int target);

  /// No description provided for @bossProgressStage3.
  ///
  /// In pl, this message translates to:
  /// **'Miecze: {swords}/{target}'**
  String bossProgressStage3(int swords, int target);

  /// No description provided for @bossSummaryFullVictoryTitle.
  ///
  /// In pl, this message translates to:
  /// **'🎉 Pełne zwycięstwo!'**
  String get bossSummaryFullVictoryTitle;

  /// No description provided for @bossSummaryFullVictoryText.
  ///
  /// In pl, this message translates to:
  /// **'Grot pada na kolano, pokonany. Wioska obroniła się bez strat.'**
  String get bossSummaryFullVictoryText;

  /// No description provided for @bossSummaryPartialVictoryTitle.
  ///
  /// In pl, this message translates to:
  /// **'⚔️ Zwycięstwo okupione stratami'**
  String get bossSummaryPartialVictoryTitle;

  /// No description provided for @bossSummaryPartialVictoryText.
  ///
  /// In pl, this message translates to:
  /// **'Grot się wycofuje, ale starcie kosztowało wioskę część zapasów.'**
  String get bossSummaryPartialVictoryText;

  /// No description provided for @bossSummaryDefeatTitle.
  ///
  /// In pl, this message translates to:
  /// **'💀 Porażka'**
  String get bossSummaryDefeatTitle;

  /// No description provided for @bossSummaryDefeatText.
  ///
  /// In pl, this message translates to:
  /// **'Grot przełamał obronę wioski i splądrował zapasy.'**
  String get bossSummaryDefeatText;

  /// No description provided for @bossSummaryStagesCleared.
  ///
  /// In pl, this message translates to:
  /// **'Ukończone etapy: {cleared}/3'**
  String bossSummaryStagesCleared(int cleared);

  /// No description provided for @bossReturnButton.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do wioski'**
  String get bossReturnButton;

  /// No description provided for @martaStage1Title.
  ///
  /// In pl, this message translates to:
  /// **'Etap 1: Poszlaki'**
  String get martaStage1Title;

  /// No description provided for @martaStage1IntroDefault.
  ///
  /// In pl, this message translates to:
  /// **'Zbierasz ślady jej wcześniejszego, niezdarnego sabotażu - i strzępki plotek krążących po wiosce. Potrzebujesz dość poszlak, żeby stanąć przed nią z pewnością siebie ({minWood} drewna, {minStone} kamienia). Ale jeśli przesadzisz, plotka zacznie żyć własnym życiem, zanim zdążysz z nią porozmawiać - trzeba będzie spróbować jeszcze raz, a Marta zrobi się czujniejsza w etapie 2.'**
  String martaStage1IntroDefault(int minWood, int minStone);

  /// No description provided for @martaStage1IntroOvershot.
  ///
  /// In pl, this message translates to:
  /// **'Przesadziłeś/aś - plotka zaczęła żyć własnym życiem, zanim zdążyłeś/aś z nią porozmawiać. Spróbuj ponownie ({minWood} drewna, {minStone} kamienia) - ale Marta jest już czujniejsza: etap 2 będzie wymagał o jedną chwilę wahania więcej ({stage2Target}).'**
  String martaStage1IntroOvershot(int minWood, int minStone, int stage2Target);

  /// No description provided for @martaStage2Title.
  ///
  /// In pl, this message translates to:
  /// **'Etap 2: Impas'**
  String get martaStage2Title;

  /// No description provided for @martaStage2IntroOne.
  ///
  /// In pl, this message translates to:
  /// **'Marta broni się półsercem. Wyłap jedną chwilę wahania w jej ciosach (jokery) - ale unikaj eskalacji, bo agresywne, długie ścieżki (bomby) tylko ją spłoszą i wymagać będzie to więcej cierpliwości.'**
  String get martaStage2IntroOne;

  /// No description provided for @martaStage2IntroMany.
  ///
  /// In pl, this message translates to:
  /// **'Marta broni się półsercem. Wyłap {count} chwil wahania w jej ciosach (jokery) - ale unikaj eskalacji, bo agresywne, długie ścieżki (bomby) tylko ją spłoszą i wymagać będzie to więcej cierpliwości.'**
  String martaStage2IntroMany(int count);

  /// No description provided for @martaStage3Title.
  ///
  /// In pl, this message translates to:
  /// **'Etap 3: Prawda'**
  String get martaStage3Title;

  /// No description provided for @martaStage3Intro.
  ///
  /// In pl, this message translates to:
  /// **'Przełamujesz jej milczenie. Zbieraj Prawdę (drewno/kamień/woda na planszy to tylko szum, nie liczą się do niczego) - i nie spiesz się, im więcej ruchów zostanie Ci na koniec, tym pełniejsze będzie jej zaufanie.'**
  String get martaStage3Intro;

  /// No description provided for @martaAppBarTitle.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Martą - Tydzień {week}'**
  String martaAppBarTitle(int week);

  /// No description provided for @martaMovesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy: {moves}'**
  String martaMovesLabel(int moves);

  /// No description provided for @martaStartButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij'**
  String get martaStartButton;

  /// No description provided for @martaProgressStage1.
  ///
  /// In pl, this message translates to:
  /// **'Drewno {wood}/{minWood} (limit {maxWood}) - Kamień {stone}/{minStone} (limit {maxStone})'**
  String martaProgressStage1(
    int wood,
    int minWood,
    int maxWood,
    int stone,
    int minStone,
    int maxStone,
  );

  /// No description provided for @martaProgressStage2.
  ///
  /// In pl, this message translates to:
  /// **'Chwile wahania: {jokers}/{target}'**
  String martaProgressStage2(int jokers, int target);

  /// No description provided for @martaProgressStage3.
  ///
  /// In pl, this message translates to:
  /// **'Prawda: {truth}/{target}'**
  String martaProgressStage3(int truth, int target);

  /// No description provided for @martaSummaryFullTrustTitle.
  ///
  /// In pl, this message translates to:
  /// **'🎉 Pełne zaufanie'**
  String get martaSummaryFullTrustTitle;

  /// No description provided for @martaSummaryFullTrustText.
  ///
  /// In pl, this message translates to:
  /// **'Dałeś/aś jej czas, na jaki czekała. Marta mówi Ci wszystko, bez zastrzeżeń.'**
  String get martaSummaryFullTrustText;

  /// No description provided for @martaSummaryPartialTrustTitle.
  ///
  /// In pl, this message translates to:
  /// **'🤝 Przełamanie'**
  String get martaSummaryPartialTrustTitle;

  /// No description provided for @martaSummaryPartialTrustText.
  ///
  /// In pl, this message translates to:
  /// **'Marta w końcu Ci wierzy - staje się sojuszniczką, choć ostrożną.'**
  String get martaSummaryPartialTrustText;

  /// No description provided for @martaSummaryClashTitle.
  ///
  /// In pl, this message translates to:
  /// **'⚔️ Częściowe przełamanie'**
  String get martaSummaryClashTitle;

  /// No description provided for @martaSummaryClashText.
  ///
  /// In pl, this message translates to:
  /// **'Marta opuszcza broń, ale wciąż coś ukrywa przed Tobą.'**
  String get martaSummaryClashText;

  /// No description provided for @martaSummaryWithdrawTitle.
  ///
  /// In pl, this message translates to:
  /// **'💔 Wycofanie'**
  String get martaSummaryWithdrawTitle;

  /// No description provided for @martaSummaryWithdrawText.
  ///
  /// In pl, this message translates to:
  /// **'Marta zamyka się w sobie i odchodzi, nie zdradzając niczego więcej.'**
  String get martaSummaryWithdrawText;

  /// No description provided for @martaSummaryStagesCleared.
  ///
  /// In pl, this message translates to:
  /// **'Ukończone etapy: {cleared}/3'**
  String martaSummaryStagesCleared(int cleared);

  /// No description provided for @martaReturnButton.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do wioski'**
  String get martaReturnButton;

  /// No description provided for @bogdanAppBarTitle.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Bogdanem - Tydzień {week}'**
  String bogdanAppBarTitle(int week);

  /// No description provided for @bogdanMovesLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy: {moves}'**
  String bogdanMovesLabel(int moves);

  /// No description provided for @bogdanPeknicieTitle.
  ///
  /// In pl, this message translates to:
  /// **'Pęknięcie'**
  String get bogdanPeknicieTitle;

  /// No description provided for @bogdanPeknicieIntro.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan się waha, sięga po dziennik... Masz {limit} ruchów, żeby zebrać jak najwięcej Dowodu, zanim znów się zamknie w gniewie.'**
  String bogdanPeknicieIntro(int limit);

  /// No description provided for @bogdanFuriaTitle.
  ///
  /// In pl, this message translates to:
  /// **'Furia'**
  String get bogdanFuriaTitle;

  /// No description provided for @bogdanFuriaStartIntro.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan przyjeżdża osobiście, w gniewie. Uspokój go - zbierz {calmTarget} wody, zanim skończą się ruchy ({furiaLimit}), bo inaczej podpali część magazynu.'**
  String bogdanFuriaStartIntro(int calmTarget, int furiaLimit);

  /// No description provided for @bogdanFuriaRetryTitle.
  ///
  /// In pl, this message translates to:
  /// **'Furia (ponownie)'**
  String get bogdanFuriaRetryTitle;

  /// No description provided for @bogdanFuriaRetryIntro.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan zdążył podpalić część spichlerza! (-15% zboża i jabłek) Spróbuj ponownie - masz {furiaLimit} ruchów.'**
  String bogdanFuriaRetryIntro(int furiaLimit);

  /// No description provided for @bogdanFuriaRetryDiscountedIntro.
  ///
  /// In pl, this message translates to:
  /// **'Marta wbiegła i powstrzymała ojca! Zdążył podpalić tylko trochę (-5%). Spróbuj ponownie - masz {furiaLimit} ruchów.'**
  String bogdanFuriaRetryDiscountedIntro(int furiaLimit);

  /// No description provided for @bogdanFuriaAfterPeknicieIntro.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan znów wpada w gniew. Uspokój go raz jeszcze - {calmTarget} wody, {furiaLimit} ruchów.'**
  String bogdanFuriaAfterPeknicieIntro(int calmTarget, int furiaLimit);

  /// No description provided for @bogdanCollectedProofLabel.
  ///
  /// In pl, this message translates to:
  /// **'Zebrany dotąd Dowód: {current}/{target}'**
  String bogdanCollectedProofLabel(int current, int target);

  /// No description provided for @bogdanStartButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij'**
  String get bogdanStartButton;

  /// No description provided for @bogdanProgressFuria.
  ///
  /// In pl, this message translates to:
  /// **'Opanowanie: {progress}/{target} (pozostało {movesLeft} ruchów tej próby)'**
  String bogdanProgressFuria(int progress, int target, int movesLeft);

  /// No description provided for @bogdanProgressPeknicie.
  ///
  /// In pl, this message translates to:
  /// **'Dowód: {current}/{target} (pozostało {movesLeft} ruchów okna)'**
  String bogdanProgressPeknicie(int current, int target, int movesLeft);

  /// No description provided for @bogdanSummaryFullVictoryTitle.
  ///
  /// In pl, this message translates to:
  /// **'🎉 Pełne zwycięstwo'**
  String get bogdanSummaryFullVictoryTitle;

  /// No description provided for @bogdanSummaryFullVictoryText.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan pęka całkowicie pod ciężarem dowodów. Ucieka w las bez zemsty.'**
  String get bogdanSummaryFullVictoryText;

  /// No description provided for @bogdanSummaryPartialVictoryTitle.
  ///
  /// In pl, this message translates to:
  /// **'⚔️ Zwycięstwo okupione stratami'**
  String get bogdanSummaryPartialVictoryTitle;

  /// No description provided for @bogdanSummaryPartialVictoryText.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan w końcu ucieka, ale zdążył zaszkodzić wiosce po drodze.'**
  String get bogdanSummaryPartialVictoryText;

  /// No description provided for @bogdanSummaryDefeatTitle.
  ///
  /// In pl, this message translates to:
  /// **'💀 Porażka'**
  String get bogdanSummaryDefeatTitle;

  /// No description provided for @bogdanSummaryDefeatText.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy się skończyły, zanim udało się go przełamać. Bogdan odjeżdża, nadal przekonany o swojej racji.'**
  String get bogdanSummaryDefeatText;

  /// No description provided for @bogdanSummaryStats.
  ///
  /// In pl, this message translates to:
  /// **'Dowód: {proof}/{target} - Spalenia magazynu: {burns}'**
  String bogdanSummaryStats(int proof, int target, int burns);

  /// No description provided for @bogdanReturnButton.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do wioski'**
  String get bogdanReturnButton;

  /// No description provided for @leszyAbilityCounterName.
  ///
  /// In pl, this message translates to:
  /// **'Kontratak'**
  String get leszyAbilityCounterName;

  /// No description provided for @leszyAbilityCounterCost.
  ///
  /// In pl, this message translates to:
  /// **'-25 wody'**
  String get leszyAbilityCounterCost;

  /// No description provided for @leszyAbilityCounterEffect.
  ///
  /// In pl, this message translates to:
  /// **'-10 PŻ Leszemu'**
  String get leszyAbilityCounterEffect;

  /// No description provided for @leszyAbilityGuardName.
  ///
  /// In pl, this message translates to:
  /// **'Osłona'**
  String get leszyAbilityGuardName;

  /// No description provided for @leszyAbilityGuardCost.
  ///
  /// In pl, this message translates to:
  /// **'-25 kamienia'**
  String get leszyAbilityGuardCost;

  /// No description provided for @leszyAbilityGuardEffect.
  ///
  /// In pl, this message translates to:
  /// **'+10 tarczy (pochłania obrażenia, zeruje się co ruch Leszego)'**
  String get leszyAbilityGuardEffect;

  /// No description provided for @leszyAbilityHealName.
  ///
  /// In pl, this message translates to:
  /// **'Uzdrowienie'**
  String get leszyAbilityHealName;

  /// No description provided for @leszyAbilityHealCost.
  ///
  /// In pl, this message translates to:
  /// **'-25 drewna'**
  String get leszyAbilityHealCost;

  /// No description provided for @leszyAbilityHealEffect.
  ///
  /// In pl, this message translates to:
  /// **'+10 PŻ Wioski, usuwa zatrucie'**
  String get leszyAbilityHealEffect;

  /// No description provided for @leszyAbilityCleanseName.
  ///
  /// In pl, this message translates to:
  /// **'Oczyszczenie'**
  String get leszyAbilityCleanseName;

  /// No description provided for @leszyAbilityCleanseCost.
  ///
  /// In pl, this message translates to:
  /// **'-20 drewna, -20 kamienia'**
  String get leszyAbilityCleanseCost;

  /// No description provided for @leszyAbilityCleanseEffect.
  ///
  /// In pl, this message translates to:
  /// **'zeruje pulę Cienia i usuwa wszystkie kulki Cienia z planszy'**
  String get leszyAbilityCleanseEffect;

  /// No description provided for @leszyAbilityPrayerName.
  ///
  /// In pl, this message translates to:
  /// **'Modlitwa'**
  String get leszyAbilityPrayerName;

  /// No description provided for @leszyAbilityPrayerCost.
  ///
  /// In pl, this message translates to:
  /// **'-20 wody, -20 drewna'**
  String get leszyAbilityPrayerCost;

  /// No description provided for @leszyAbilityPrayerEffect.
  ///
  /// In pl, this message translates to:
  /// **'osłabia następny cios Leszego o połowę'**
  String get leszyAbilityPrayerEffect;

  /// No description provided for @leszyAbilityCalmName.
  ///
  /// In pl, this message translates to:
  /// **'Uspokojenie'**
  String get leszyAbilityCalmName;

  /// No description provided for @leszyAbilityCalmCost.
  ///
  /// In pl, this message translates to:
  /// **'-30 wody'**
  String get leszyAbilityCalmCost;

  /// No description provided for @leszyAbilityCalmEffect.
  ///
  /// In pl, this message translates to:
  /// **'-3 do siły Leszego'**
  String get leszyAbilityCalmEffect;

  /// No description provided for @leszyAbilityWallName.
  ///
  /// In pl, this message translates to:
  /// **'Wzmocnienie muru'**
  String get leszyAbilityWallName;

  /// No description provided for @leszyAbilityWallCost.
  ///
  /// In pl, this message translates to:
  /// **'-15 drewna, -15 kamienia'**
  String get leszyAbilityWallCost;

  /// No description provided for @leszyAbilityWallEffect.
  ///
  /// In pl, this message translates to:
  /// **'+2 do progu wybuchu Cienia (przeciwdziała Zagęszczeniu cienia)'**
  String get leszyAbilityWallEffect;

  /// No description provided for @leszyAbilityDispelFuryName.
  ///
  /// In pl, this message translates to:
  /// **'Rozproszenie furii'**
  String get leszyAbilityDispelFuryName;

  /// No description provided for @leszyAbilityDispelFuryCost.
  ///
  /// In pl, this message translates to:
  /// **'-15 wody'**
  String get leszyAbilityDispelFuryCost;

  /// No description provided for @leszyAbilityDispelFuryEffect.
  ///
  /// In pl, this message translates to:
  /// **'natychmiast anuluje aktywną Furię, zanim zdąży podwoić następny cios (dostępne tylko, gdy Furia aktywna)'**
  String get leszyAbilityDispelFuryEffect;

  /// No description provided for @leszyAbilityAbundanceName.
  ///
  /// In pl, this message translates to:
  /// **'Obfitość'**
  String get leszyAbilityAbundanceName;

  /// No description provided for @leszyAbilityAbundanceCost.
  ///
  /// In pl, this message translates to:
  /// **'-20 wody, -20 kamienia'**
  String get leszyAbilityAbundanceCost;

  /// No description provided for @leszyAbilityAbundanceEffect.
  ///
  /// In pl, this message translates to:
  /// **'podwaja kolejne 3 zebrane ścieżki surowców (włącznie z Mieczem i Tarczą, poza Cieniem)'**
  String get leszyAbilityAbundanceEffect;

  /// No description provided for @leszyMoveStrikeFuryDesc.
  ///
  /// In pl, this message translates to:
  /// **'Szykuje wzmocnione uderzenie w wioskę (2×{base} = -{doubled} PŻ).'**
  String leszyMoveStrikeFuryDesc(int base, int doubled);

  /// No description provided for @leszyMoveStrikeDesc.
  ///
  /// In pl, this message translates to:
  /// **'Szykuje uderzenie w wioskę (-{base} PŻ).'**
  String leszyMoveStrikeDesc(int base);

  /// No description provided for @leszyMoveDrainDesc.
  ///
  /// In pl, this message translates to:
  /// **'Chce wyssać najbogatszy zapas surowca i się nim uleczyć (o połowę zabranej ilości).'**
  String get leszyMoveDrainDesc;

  /// No description provided for @leszyMoveShadowDesc.
  ///
  /// In pl, this message translates to:
  /// **'Zagęszcza cień - trwale obniża próg wybuchu o 1 (obecnie {threshold}).'**
  String leszyMoveShadowDesc(int threshold);

  /// No description provided for @leszyMoveFuryDesc.
  ///
  /// In pl, this message translates to:
  /// **'Wpada w furię - następny cios będzie podwojony, a on sam potężniejszy (+1 siły).'**
  String get leszyMoveFuryDesc;

  /// No description provided for @leszyMoveFogDesc.
  ///
  /// In pl, this message translates to:
  /// **'Ześle mgłę - przetasuje planszę i zamieni część kafelków w cienie.'**
  String get leszyMoveFogDesc;

  /// No description provided for @leszyMovePoisonDesc.
  ///
  /// In pl, this message translates to:
  /// **'Zatruje powietrze - kolejne ruchy zabolą (-5 PŻ), da się to wyleczyć Uzdrowieniem.'**
  String get leszyMovePoisonDesc;

  /// No description provided for @leszyMoveHungerDesc.
  ///
  /// In pl, this message translates to:
  /// **'Głód pochłonie część zapasów.'**
  String get leszyMoveHungerDesc;

  /// No description provided for @leszyMoveConsumeDesc.
  ///
  /// In pl, this message translates to:
  /// **'Chce pochłonąć cień z otoczenia i uleczyć się o tyle, ile go pochłonie.'**
  String get leszyMoveConsumeDesc;

  /// No description provided for @leszyMoveRendDesc.
  ///
  /// In pl, this message translates to:
  /// **'Szykuje rozdzierające cięcie, które przebija połowę Tarczy (-{base} PŻ, częściowo mimo osłony).'**
  String leszyMoveRendDesc(int base);

  /// No description provided for @leszyMoveDespairDesc.
  ///
  /// In pl, this message translates to:
  /// **'Ogarnia go rozpacz - zaraz gwałtownie wzmocni swoją siłę (+2).'**
  String get leszyMoveDespairDesc;

  /// No description provided for @leszyMoveBlightDesc.
  ///
  /// In pl, this message translates to:
  /// **'Skazi część planszy, zamieniając kafelki wprost w Cień.'**
  String get leszyMoveBlightDesc;

  /// No description provided for @leszyMoveOtherworldDesc.
  ///
  /// In pl, this message translates to:
  /// **'Wycofuje się częściowo w zaświaty - najbliższe trafienia Mieczem zadadzą tylko połowę obrażeń.'**
  String get leszyMoveOtherworldDesc;

  /// No description provided for @leszyMoveCrumblingResolveDesc.
  ///
  /// In pl, this message translates to:
  /// **'Łamie wolę wioski - jej maksymalne PŻ trwale się skurczy.'**
  String get leszyMoveCrumblingResolveDesc;

  /// No description provided for @leszyShadowExplosionWarning.
  ///
  /// In pl, this message translates to:
  /// **'Cień osiąga próg - za chwilę eksploduje!'**
  String get leszyShadowExplosionWarning;

  /// No description provided for @leszyShadowExplosionResult.
  ///
  /// In pl, this message translates to:
  /// **'Cień eksploduje! (-{damage} PŻ Wioski)'**
  String leszyShadowExplosionResult(int damage);

  /// No description provided for @leszyActionStrike.
  ///
  /// In pl, this message translates to:
  /// **'Leszy uderza! (-{dmg} PŻ Wioski)'**
  String leszyActionStrike(int dmg);

  /// No description provided for @leszyActionDrainSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Leszy wysysa {resource} i leczy się o {healed}!'**
  String leszyActionDrainSuccess(String resource, int healed);

  /// No description provided for @leszyActionDrainFail.
  ///
  /// In pl, this message translates to:
  /// **'Leszy próbuje wyssać surowiec, ale nic nie ma.'**
  String get leszyActionDrainFail;

  /// No description provided for @leszyActionShadowThicken.
  ///
  /// In pl, this message translates to:
  /// **'Cień gęstnieje - próg wybuchu spadł do {threshold}!'**
  String leszyActionShadowThicken(int threshold);

  /// No description provided for @leszyActionFury.
  ///
  /// In pl, this message translates to:
  /// **'Leszy wpada w furię - następny cios będzie silniejszy, a on sam potężniejszy!'**
  String get leszyActionFury;

  /// No description provided for @leszyActionFog.
  ///
  /// In pl, this message translates to:
  /// **'Mgła spowija planszę - kafelki się przetasowują, część zamienia się w cienie!'**
  String get leszyActionFog;

  /// No description provided for @leszyActionPoison.
  ///
  /// In pl, this message translates to:
  /// **'Leszy zatruwa powietrze - kolejne ruchy zabolą mocniej.'**
  String get leszyActionPoison;

  /// No description provided for @leszyActionHunger.
  ///
  /// In pl, this message translates to:
  /// **'Głód Leszego pochłania część zapasów.'**
  String get leszyActionHunger;

  /// No description provided for @leszyActionConsumeSuccess.
  ///
  /// In pl, this message translates to:
  /// **'Leszy pochłania cień z otoczenia i leczy się o {amount}!'**
  String leszyActionConsumeSuccess(int amount);

  /// No description provided for @leszyActionConsumeFail.
  ///
  /// In pl, this message translates to:
  /// **'Leszy sięga po cień, ale nie ma czego pochłonąć.'**
  String get leszyActionConsumeFail;

  /// No description provided for @leszyActionRendPierce.
  ///
  /// In pl, this message translates to:
  /// **'Leszy rozdziera wioskę, przebijając połowę Tarczy! (-{dmg} PŻ Wioski)'**
  String leszyActionRendPierce(int dmg);

  /// No description provided for @leszyActionRendClaws.
  ///
  /// In pl, this message translates to:
  /// **'Leszy rozdziera wioskę pazurami! (-{dmg} PŻ Wioski)'**
  String leszyActionRendClaws(int dmg);

  /// No description provided for @leszyActionDespair.
  ///
  /// In pl, this message translates to:
  /// **'Rozpacz ogarnia Leszego - jego siła rośnie gwałtownie (+2)!'**
  String get leszyActionDespair;

  /// No description provided for @leszyActionBlight.
  ///
  /// In pl, this message translates to:
  /// **'Skażenie rozlewa się po planszy - część kafelków zamienia się w Cień!'**
  String get leszyActionBlight;

  /// No description provided for @leszyActionOtherworld.
  ///
  /// In pl, this message translates to:
  /// **'Leszy wycofuje się częściowo w zaświaty - kolejne trafienia Mieczem osłabione.'**
  String get leszyActionOtherworld;

  /// No description provided for @leszyActionCrumblingResolve.
  ///
  /// In pl, this message translates to:
  /// **'Wola wioski pęka pod ciężarem grozy - maks. PŻ Wioski spada do {maxHp}!'**
  String leszyActionCrumblingResolve(int maxHp);

  /// No description provided for @leszyAppBarTitle.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Leszym - Tydzień {week}'**
  String leszyAppBarTitle(int week);

  /// No description provided for @leszyMovesUsedLabel.
  ///
  /// In pl, this message translates to:
  /// **'Ruchy: {count}'**
  String leszyMovesUsedLabel(int count);

  /// No description provided for @leszyPhaseOnslaughtTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nawałnica'**
  String get leszyPhaseOnslaughtTitle;

  /// No description provided for @leszyPhaseHeartOfShadowTitle.
  ///
  /// In pl, this message translates to:
  /// **'Serce Cienia'**
  String get leszyPhaseHeartOfShadowTitle;

  /// No description provided for @leszyOnslaughtIntroText.
  ///
  /// In pl, this message translates to:
  /// **'Leszy uderza na wioskę w pełnej sile. Zbieraj Miecze, żeby go ranić, i Tarcze, żeby przetrwać - a zebrane drewno/kamień/wodę wykorzystaj na zdolności.'**
  String get leszyOnslaughtIntroText;

  /// No description provided for @leszyHeartOfShadowIntroText.
  ///
  /// In pl, this message translates to:
  /// **'Pierwsza fala pękła, ale z cieni wyłania się jego prawdziwa, głodniejsza forma - silniejsza od pierwszego ruchu i zdolna pożreć sam Cień, żeby się leczyć. To ostatnia próba - Twoje PŻ Wioski nie odnowiły się między starciami.'**
  String get leszyHeartOfShadowIntroText;

  /// No description provided for @leszyIntroHpSummary.
  ///
  /// In pl, this message translates to:
  /// **'PŻ Wioski: {villageHp}/{villageMaxHp} - PŻ Leszego: {leszyHp}/{leszyMaxHp}'**
  String leszyIntroHpSummary(
    int villageHp,
    int villageMaxHp,
    int leszyHp,
    int leszyMaxHp,
  );

  /// No description provided for @leszyStartButton.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij'**
  String get leszyStartButton;

  /// No description provided for @leszyBoardLegendSwordLabel.
  ///
  /// In pl, this message translates to:
  /// **'Miecz'**
  String get leszyBoardLegendSwordLabel;

  /// No description provided for @leszyBoardLegendSwordDesc.
  ///
  /// In pl, this message translates to:
  /// **'1 kafelek = 1 obrażenie Leszemu'**
  String get leszyBoardLegendSwordDesc;

  /// No description provided for @leszyBoardLegendShieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tarcza'**
  String get leszyBoardLegendShieldLabel;

  /// No description provided for @leszyBoardLegendShieldDesc.
  ///
  /// In pl, this message translates to:
  /// **'1 kafelek = 1 punkt osłony Wioski'**
  String get leszyBoardLegendShieldDesc;

  /// No description provided for @leszyBoardLegendShadowLabel.
  ///
  /// In pl, this message translates to:
  /// **'Cień'**
  String get leszyBoardLegendShadowLabel;

  /// No description provided for @leszyBoardLegendShadowDesc.
  ///
  /// In pl, this message translates to:
  /// **'Zebranie usuwa go z planszy i dodatkowo obniża pulę Cienia o 5 za kafelek - pełna pula ({threshold}, spada z czasem od Zagęszczenia cienia) eksploduje, zadając PŻ Wioski dokładnie tyle, ile pula wynosi w tej chwili.'**
  String leszyBoardLegendShadowDesc(int threshold);

  /// No description provided for @leszyBoardLegendTitle.
  ///
  /// In pl, this message translates to:
  /// **'Nowe surowce na planszy'**
  String get leszyBoardLegendTitle;

  /// No description provided for @leszyBoardLegendResourceNote.
  ///
  /// In pl, this message translates to:
  /// **'Drewno, kamień i woda dalej działają jak wcześniej - odkładają się w zapasy, które można wydać na zdolności poniżej.'**
  String get leszyBoardLegendResourceNote;

  /// No description provided for @leszyAbilitiesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zdolności'**
  String get leszyAbilitiesTitle;

  /// No description provided for @leszyStatusFuryName.
  ///
  /// In pl, this message translates to:
  /// **'Furia'**
  String get leszyStatusFuryName;

  /// No description provided for @leszyStatusFuryDesc.
  ///
  /// In pl, this message translates to:
  /// **'Furia aktywna - następny cios Leszego będzie podwojony.'**
  String get leszyStatusFuryDesc;

  /// No description provided for @leszyStatusPoisonName.
  ///
  /// In pl, this message translates to:
  /// **'Zatrucie'**
  String get leszyStatusPoisonName;

  /// No description provided for @leszyStatusPoisonDesc.
  ///
  /// In pl, this message translates to:
  /// **'Zatrucie - kolejne {ticks} ruch(y) gracza bolą dodatkowo (-5 PŻ Wioski). Da się to wyleczyć Uzdrowieniem.'**
  String leszyStatusPoisonDesc(int ticks);

  /// No description provided for @leszyStatusPrayerName.
  ///
  /// In pl, this message translates to:
  /// **'Modlitwa'**
  String get leszyStatusPrayerName;

  /// No description provided for @leszyStatusPrayerDesc.
  ///
  /// In pl, this message translates to:
  /// **'Modlitwa aktywna - następny cios Leszego osłabiony o połowę.'**
  String get leszyStatusPrayerDesc;

  /// No description provided for @leszyStatusAbundanceName.
  ///
  /// In pl, this message translates to:
  /// **'Obfitość'**
  String get leszyStatusAbundanceName;

  /// No description provided for @leszyStatusAbundanceDesc.
  ///
  /// In pl, this message translates to:
  /// **'Obfitość aktywna - kolejne {charges} zebrane ścieżki (Miecz, Tarcza, drewno/kamień/woda) liczą się podwójnie. Nie dotyczy Cienia.'**
  String leszyStatusAbundanceDesc(int charges);

  /// No description provided for @leszyStatusOtherworldName.
  ///
  /// In pl, this message translates to:
  /// **'Zaświat'**
  String get leszyStatusOtherworldName;

  /// No description provided for @leszyStatusOtherworldDesc.
  ///
  /// In pl, this message translates to:
  /// **'Leszy jest częściowo wycofany w zaświaty - kolejne {charges} trafienia Mieczem zadadzą tylko połowę obrażeń.'**
  String leszyStatusOtherworldDesc(int charges);

  /// No description provided for @leszyCloseButton.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get leszyCloseButton;

  /// No description provided for @leszyBossName.
  ///
  /// In pl, this message translates to:
  /// **'Leszy'**
  String get leszyBossName;

  /// No description provided for @leszyVillageLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wioska'**
  String get leszyVillageLabel;

  /// No description provided for @leszyHpBarLabel.
  ///
  /// In pl, this message translates to:
  /// **'{label}: {current}/{max} PŻ'**
  String leszyHpBarLabel(String label, int current, int max);

  /// No description provided for @leszyMovesUnitOne.
  ///
  /// In pl, this message translates to:
  /// **'ruch'**
  String get leszyMovesUnitOne;

  /// No description provided for @leszyMovesUnitFew.
  ///
  /// In pl, this message translates to:
  /// **'ruchy'**
  String get leszyMovesUnitFew;

  /// No description provided for @leszyMovesUnitMany.
  ///
  /// In pl, this message translates to:
  /// **'ruchów'**
  String get leszyMovesUnitMany;

  /// No description provided for @leszyMovesUntilLabel.
  ///
  /// In pl, this message translates to:
  /// **'Za {count} {unit}:'**
  String leszyMovesUntilLabel(int count, String unit);

  /// No description provided for @leszyShadowCounterLabel.
  ///
  /// In pl, this message translates to:
  /// **'Cień {current}/{threshold}'**
  String leszyShadowCounterLabel(int current, int threshold);

  /// No description provided for @leszyAbilityCostLabel.
  ///
  /// In pl, this message translates to:
  /// **'Koszt: {cost}'**
  String leszyAbilityCostLabel(String cost);

  /// No description provided for @leszyAbilityEffectLabel.
  ///
  /// In pl, this message translates to:
  /// **'Efekt: {effect}'**
  String leszyAbilityEffectLabel(String effect);

  /// No description provided for @leszyNotEnoughResources.
  ///
  /// In pl, this message translates to:
  /// **'Za mało surowców, żeby teraz użyć tej zdolności.'**
  String get leszyNotEnoughResources;

  /// No description provided for @leszyCancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get leszyCancelButton;

  /// No description provided for @leszyUseButton.
  ///
  /// In pl, this message translates to:
  /// **'Użyj'**
  String get leszyUseButton;

  /// No description provided for @leszyDefeatTitle.
  ///
  /// In pl, this message translates to:
  /// **'💀 Klęska'**
  String get leszyDefeatTitle;

  /// No description provided for @leszyDefeatMessage.
  ///
  /// In pl, this message translates to:
  /// **'Leszy okazał się za silny. Wioska nie wytrzymała naporu Cienia.'**
  String get leszyDefeatMessage;

  /// No description provided for @leszyRetryButton.
  ///
  /// In pl, this message translates to:
  /// **'Spróbuj ponownie'**
  String get leszyRetryButton;

  /// No description provided for @leszyReturnPrepareButton.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do wioski, przygotuj się lepiej'**
  String get leszyReturnPrepareButton;

  /// No description provided for @leszyVictoryTitle.
  ///
  /// In pl, this message translates to:
  /// **'🎉 Leszy pokonany'**
  String get leszyVictoryTitle;

  /// No description provided for @leszyVictoryMessage.
  ///
  /// In pl, this message translates to:
  /// **'Cień cofa się w głąb ziemi. Wioska przetrwała najgorszą noc.'**
  String get leszyVictoryMessage;

  /// No description provided for @leszyVictoryHpSummary.
  ///
  /// In pl, this message translates to:
  /// **'PŻ Wioski na koniec: {hp}/{maxHp}'**
  String leszyVictoryHpSummary(int hp, int maxHp);

  /// No description provided for @leszyReturnToVillageButton.
  ///
  /// In pl, this message translates to:
  /// **'Wróć do wioski'**
  String get leszyReturnToVillageButton;

  /// No description provided for @homeBuildingNameRatusz.
  ///
  /// In pl, this message translates to:
  /// **'Ratusz'**
  String get homeBuildingNameRatusz;

  /// No description provided for @homeSourceSoldiers.
  ///
  /// In pl, this message translates to:
  /// **'Żołnierze'**
  String get homeSourceSoldiers;

  /// No description provided for @homeSourceResidents.
  ///
  /// In pl, this message translates to:
  /// **'Mieszkańcy'**
  String get homeSourceResidents;

  /// No description provided for @homeBonusSklep.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje zakładkę \"Sklep\" w dolnym pasku nawigacji.'**
  String get homeBonusSklep;

  /// No description provided for @homeBonusPopulation.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa limit populacji o {n} (widoczne w Statystykach).'**
  String homeBonusPopulation(int n);

  /// No description provided for @homeBonusKuznia.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} złota.'**
  String homeBonusKuznia(int n);

  /// No description provided for @homeBonusSpichlerz.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} do produkcji jabłek. Zmniejsza ryzyko głodu (utraty zbiorów) o {pct}.'**
  String homeBonusSpichlerz(int n, String pct);

  /// No description provided for @homeBonusPiekarnia.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} do produkcji zboża.'**
  String homeBonusPiekarnia(int n);

  /// No description provided for @homeBonusTartak.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} do produkcji drewna.'**
  String homeBonusTartak(int n);

  /// No description provided for @homeBonusStudnia.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} do produkcji wody. Zmniejsza ryzyko pożaru (spalenia zbiorów) o {pct}.'**
  String homeBonusStudnia(int n, String pct);

  /// No description provided for @homeBonusMorale.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa morale wioski o {n} (widoczne w Statystykach).'**
  String homeBonusMorale(int n);

  /// No description provided for @homeBonusKaplica.
  ///
  /// In pl, this message translates to:
  /// **'Zmniejsza ogólną szansę zepsucia sezonowego surowca o {pct}. Zwiększa morale wioski o {n}.'**
  String homeBonusKaplica(String pct, int n);

  /// No description provided for @homeBonusSzkola.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje odkrycia w Uczelni (panel poniżej) - m.in. +1 do bazowej liczby ruchów i możliwość przydzielania pracowników do budynków.'**
  String get homeBonusSzkola;

  /// No description provided for @homeBonusRynek.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje handel surowcami w zakładce Surowce (kurs {base}→{receive}, poprawia się z rozbudową, odkryciem Dyplomacji i pracownikami - najlepszy możliwy to {best}→{receive}).'**
  String homeBonusRynek(int base, int receive, int best);

  /// No description provided for @homeBonusMagazyn.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa maksymalną ilość każdego przechowywanego surowca o {n}.'**
  String homeBonusMagazyn(int n);

  /// No description provided for @homeBonusKamieniarz.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} do produkcji kamienia.'**
  String homeBonusKamieniarz(int n);

  /// No description provided for @homeBonusKoszary.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa bezpieczeństwo wioski o {n}. Odblokowuje rekrutację żołnierzy (wymaga zbudowanej Kuźni) - panel poniżej. Każdy żołnierz zużywa {food} jabłko/tydzień - przy braku jabłek część zdezerteruje.'**
  String homeBonusKoszary(int n, int food);

  /// No description provided for @homeUpgradeRatusz.
  ///
  /// In pl, this message translates to:
  /// **'Podwaja premię tygodniową do +{n} każdego surowca.'**
  String homeUpgradeRatusz(int n);

  /// No description provided for @homeUpgradePalisade.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa limit populacji o kolejne {a} (razem +{a2}) i bezpieczeństwo wioski o kolejne {b} (razem +{b2}).'**
  String homeUpgradePalisade(int a, int a2, int b, int b2);

  /// No description provided for @homeUpgradeSklep.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa maksymalną liczbę ruchów możliwych do wykupienia w sklepie o {n} (niezależnie od bonusu za przydzielonych pracowników).'**
  String homeUpgradeSklep(int n);

  /// No description provided for @homeUpgradePopulation.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa limit populacji o kolejne {n} (razem +{n2}).'**
  String homeUpgradePopulation(int n, int n2);

  /// No description provided for @homeUpgradeKuznia.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa premię tygodniową o kolejne {n} złota (razem +{n2}/tydz.).'**
  String homeUpgradeKuznia(int n, int n2);

  /// No description provided for @homeUpgradeSpichlerz.
  ///
  /// In pl, this message translates to:
  /// **'Dalej zmniejsza ryzyko głodu o kolejne {pct} (razem -{pct2}). Produkcja jabłek bez zmian.'**
  String homeUpgradeSpichlerz(String pct, String pct2);

  /// No description provided for @homeUpgradePiekarnia.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa produkcję zboża o kolejne {n} (razem +{n2}/tydz.).'**
  String homeUpgradePiekarnia(int n, int n2);

  /// No description provided for @homeUpgradeTartak.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa produkcję drewna o kolejne {n} (razem +{n2}/tydz.).'**
  String homeUpgradeTartak(int n, int n2);

  /// No description provided for @homeUpgradeStudnia.
  ///
  /// In pl, this message translates to:
  /// **'Dalej zmniejsza ryzyko pożaru o kolejne {pct} (razem -{pct2}). Produkcja wody bez zmian.'**
  String homeUpgradeStudnia(String pct, String pct2);

  /// No description provided for @homeUpgradeBrowar.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa morale wioski o kolejne {n} (razem +{n2}).'**
  String homeUpgradeBrowar(int n, int n2);

  /// No description provided for @homeUpgradeKaplica.
  ///
  /// In pl, this message translates to:
  /// **'Całkowicie usuwa ogólną szansę zepsucia (od tego budynku) i zwiększa morale wioski o kolejne {n} (razem +{n2}).'**
  String homeUpgradeKaplica(int n, int n2);

  /// No description provided for @homeUpgradeSzkola.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje zaawansowane odkrycia - m.in. kolejne +1 do bazowej liczby ruchów (razem +2) i limit 2 pracowników na budynek.'**
  String get homeUpgradeSzkola;

  /// No description provided for @homeUpgradeRynek.
  ///
  /// In pl, this message translates to:
  /// **'Poprawia kurs wymiany do {after}→{receive} (jeden z 3 niezależnych ulepszeń do najlepszego możliwego kursu {best}→{receive}).'**
  String homeUpgradeRynek(int after, int receive, int best);

  /// No description provided for @homeUpgradeMagazyn.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa limit magazynowania o kolejne {n} (razem +{n2}).'**
  String homeUpgradeMagazyn(int n, int n2);

  /// No description provided for @homeUpgradeKamieniarz.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa produkcję kamienia o kolejne {n} (razem +{n2}/tydz.).'**
  String homeUpgradeKamieniarz(int n, int n2);

  /// No description provided for @homeUpgradeKoszary.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa bezpieczeństwo wioski o kolejne {n} (razem +{n2}) i podwaja siłę każdego żołnierza.'**
  String homeUpgradeKoszary(int n, int n2);

  /// No description provided for @homeBonusLineSimple.
  ///
  /// In pl, this message translates to:
  /// **'{label}: {base}{unit}'**
  String homeBonusLineSimple(String label, num base, String unit);

  /// No description provided for @homeBonusLineWithWorkers.
  ///
  /// In pl, this message translates to:
  /// **'{label}: baza {base}{unit}, pracownicy {sign}{workerBonus}{unit} → premia ogólna {total}{unit}'**
  String homeBonusLineWithWorkers(
    String label,
    num base,
    String unit,
    String sign,
    num workerBonus,
    num total,
  );

  /// No description provided for @homeBonusPercentSimple.
  ///
  /// In pl, this message translates to:
  /// **'{label}: {pct}'**
  String homeBonusPercentSimple(String label, String pct);

  /// No description provided for @homeBonusPercentWithWorkers.
  ///
  /// In pl, this message translates to:
  /// **'{label}: baza {basePct}, z pracownikami → premia ogólna {totalPct}'**
  String homeBonusPercentWithWorkers(
    String label,
    String basePct,
    String totalPct,
  );

  /// No description provided for @homeLabelResourceProduction.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja każdego surowca'**
  String get homeLabelResourceProduction;

  /// No description provided for @homeLabelPopulationLimit.
  ///
  /// In pl, this message translates to:
  /// **'Limit populacji'**
  String get homeLabelPopulationLimit;

  /// No description provided for @homeLabelSecurity.
  ///
  /// In pl, this message translates to:
  /// **'Bezpieczeństwo'**
  String get homeLabelSecurity;

  /// No description provided for @homeSklepLockedBonusNote.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje zakładkę Sklep (liczbowa premia dopiero po rozbudowie).'**
  String get homeSklepLockedBonusNote;

  /// No description provided for @homeSklepMovesBonusText.
  ///
  /// In pl, this message translates to:
  /// **'Maks. liczba ruchów do wykupienia: {max} (w tym +{workers} od pracowników).'**
  String homeSklepMovesBonusText(int max, int workers);

  /// No description provided for @homeLabelGoldPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'Złoto/tydz.'**
  String get homeLabelGoldPerWeek;

  /// No description provided for @homeLabelAppleProductionPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja jabłek/tydz.'**
  String get homeLabelAppleProductionPerWeek;

  /// No description provided for @homeLabelHungerRiskReduction.
  ///
  /// In pl, this message translates to:
  /// **'Redukcja ryzyka głodu'**
  String get homeLabelHungerRiskReduction;

  /// No description provided for @homeLabelGrainProductionPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja zboża/tydz.'**
  String get homeLabelGrainProductionPerWeek;

  /// No description provided for @homeLabelWoodProductionPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja drewna/tydz.'**
  String get homeLabelWoodProductionPerWeek;

  /// No description provided for @homeLabelWaterProductionPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja wody/tydz.'**
  String get homeLabelWaterProductionPerWeek;

  /// No description provided for @homeLabelFireRiskReduction.
  ///
  /// In pl, this message translates to:
  /// **'Redukcja ryzyka pożaru'**
  String get homeLabelFireRiskReduction;

  /// No description provided for @homeLabelVillageMorale.
  ///
  /// In pl, this message translates to:
  /// **'Morale wioski'**
  String get homeLabelVillageMorale;

  /// No description provided for @homeLabelSpoilRiskReduction.
  ///
  /// In pl, this message translates to:
  /// **'Redukcja ogólnej szansy zepsucia'**
  String get homeLabelSpoilRiskReduction;

  /// No description provided for @homeMarketRateBonus.
  ///
  /// In pl, this message translates to:
  /// **'Kurs wymiany: {give}→{receive} (najlepszy możliwy: {best}→{receive} = 2:1)'**
  String homeMarketRateBonus(int give, int receive, int best);

  /// No description provided for @homeLabelWarehouseLimit.
  ///
  /// In pl, this message translates to:
  /// **'Limit magazynu'**
  String get homeLabelWarehouseLimit;

  /// No description provided for @homeLabelStoneProductionPerWeek.
  ///
  /// In pl, this message translates to:
  /// **'Produkcja kamienia/tydz.'**
  String get homeLabelStoneProductionPerWeek;

  /// No description provided for @homeResourcesNotUnlockedMessage.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw odkryj wszystkie surowce w Okolicach (zbuduj Sad, Łąkę i Pole).'**
  String get homeResourcesNotUnlockedMessage;

  /// No description provided for @homeTabVillage.
  ///
  /// In pl, this message translates to:
  /// **'Wioska'**
  String get homeTabVillage;

  /// No description provided for @homeTabSurroundings.
  ///
  /// In pl, this message translates to:
  /// **'Okolice'**
  String get homeTabSurroundings;

  /// No description provided for @homeTabResources.
  ///
  /// In pl, this message translates to:
  /// **'Surowce'**
  String get homeTabResources;

  /// No description provided for @homeTabShop.
  ///
  /// In pl, this message translates to:
  /// **'Sklep'**
  String get homeTabShop;

  /// No description provided for @homeTabStats.
  ///
  /// In pl, this message translates to:
  /// **'Statystyki'**
  String get homeTabStats;

  /// No description provided for @homeTabGoals.
  ///
  /// In pl, this message translates to:
  /// **'Cele'**
  String get homeTabGoals;

  /// No description provided for @homeTabDebug.
  ///
  /// In pl, this message translates to:
  /// **'Debug'**
  String get homeTabDebug;

  /// No description provided for @homeTutorialVillageDesc.
  ///
  /// In pl, this message translates to:
  /// **'Dotknij pustej działki, żeby zbudować budynek, albo gotowego budynku, żeby go rozbudować lub zobaczyć szczegóły. Ratusz buduje się jako pierwszy i odblokowuje resztę.'**
  String get homeTutorialVillageDesc;

  /// No description provided for @homeTutorialSurroundingsDesc.
  ///
  /// In pl, this message translates to:
  /// **'Tereny wokół wioski (rzeka, las, góry...) - ich zabudowa powiększa planszę zbiorów i daje premie do surowców.'**
  String get homeTutorialSurroundingsDesc;

  /// No description provided for @homeTutorialResourcesDesc.
  ///
  /// In pl, this message translates to:
  /// **'Podgląd zapasów, produkcji i zużycia tygodniowego każdego surowca, a stąd też wymiana na targu, gdy Rynek jest gotowy.'**
  String get homeTutorialResourcesDesc;

  /// No description provided for @homeTutorialShopDesc.
  ///
  /// In pl, this message translates to:
  /// **'Kupuj dodatkowe ruchy na planszy zbiorów i ulepszenia automatycznego dopasowywania (odblokowuje się w trakcie gry).'**
  String get homeTutorialShopDesc;

  /// No description provided for @homeTutorialStatsDesc.
  ///
  /// In pl, this message translates to:
  /// **'Rekordy, populacja, morale, bezpieczeństwo, armia i komiksy fabularne, a także wybór wyglądu planszy zbiorów.'**
  String get homeTutorialStatsDesc;

  /// No description provided for @homeTutorialGoalsDesc.
  ///
  /// In pl, this message translates to:
  /// **'Cele bieżącego aktu fabuły i questy poboczne - realizuj je, żeby zdobywać doświadczenie.'**
  String get homeTutorialGoalsDesc;

  /// No description provided for @homeTutorialArrowTitle.
  ///
  /// In pl, this message translates to:
  /// **'Przycisk \"→\"'**
  String get homeTutorialArrowTitle;

  /// No description provided for @homeTutorialArrowDesc.
  ///
  /// In pl, this message translates to:
  /// **'Kończy tydzień i przenosi do planszy zbiorów (albo starcia z bossem, jeśli akurat wypada).'**
  String get homeTutorialArrowDesc;

  /// No description provided for @homeVillageTutorialTitle.
  ///
  /// In pl, this message translates to:
  /// **'Witaj w wiosce'**
  String get homeVillageTutorialTitle;

  /// No description provided for @homeVillageTutorialGotIt.
  ///
  /// In pl, this message translates to:
  /// **'Rozumiem'**
  String get homeVillageTutorialGotIt;

  /// No description provided for @homeConfirmDemolishTitle.
  ///
  /// In pl, this message translates to:
  /// **'Zburzyć budynek?'**
  String get homeConfirmDemolishTitle;

  /// No description provided for @homeConfirmDemolishMessage.
  ///
  /// In pl, this message translates to:
  /// **'Na pewno chcesz zburzyć: {name}?\nOdzyskasz połowę zainwestowanych surowców.'**
  String homeConfirmDemolishMessage(String name);

  /// No description provided for @homeCancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get homeCancel;

  /// No description provided for @homeDemolish.
  ///
  /// In pl, this message translates to:
  /// **'Zburz'**
  String get homeDemolish;

  /// No description provided for @homeRatuszBonusText.
  ///
  /// In pl, this message translates to:
  /// **'Co tydzień: +{n} każdego surowca.\nZłoto zebrane w ścieżce daje dodatkowo +1 (np. 4 w ścieżce = 5).\nWymaga odblokowania wszystkich surowców w Okolicach. Musi zostać zbudowany jako pierwszy budynek wioski - odblokowuje budowę pozostałych, a jego rozbudowa (poziom 2) odblokowuje ich rozbudowę.'**
  String homeRatuszBonusText(int n);

  /// No description provided for @homeRatuszUpgradedSnack.
  ///
  /// In pl, this message translates to:
  /// **'Ratusz rozbudowany!'**
  String get homeRatuszUpgradedSnack;

  /// No description provided for @homeBuildingNamePalisade.
  ///
  /// In pl, this message translates to:
  /// **'Palisada'**
  String get homeBuildingNamePalisade;

  /// No description provided for @homePalisadeBonusText.
  ///
  /// In pl, this message translates to:
  /// **'Zwiększa limit populacji o {pop} i bezpieczeństwo wioski o {sec} (widoczne w Statystykach).'**
  String homePalisadeBonusText(int pop, int sec);

  /// No description provided for @homePalisadeUpgradedSnack.
  ///
  /// In pl, this message translates to:
  /// **'Palisada rozbudowana!'**
  String get homePalisadeUpgradedSnack;

  /// No description provided for @homePalisadeDemolishedSnack.
  ///
  /// In pl, this message translates to:
  /// **'Palisada zburzona - odzyskano połowę surowców.'**
  String get homePalisadeDemolishedSnack;

  /// No description provided for @homeMilitaryTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wojsko'**
  String get homeMilitaryTitle;

  /// No description provided for @homeMilitaryTotalStrength.
  ///
  /// In pl, this message translates to:
  /// **'Łączna siła armii: {n}'**
  String homeMilitaryTotalStrength(int n);

  /// No description provided for @homeMilitaryAvailableResidents.
  ///
  /// In pl, this message translates to:
  /// **'Dostępni mieszkańcy: {n} (każda rekrutacja zabiera jednego z wioski).'**
  String homeMilitaryAvailableResidents(int n);

  /// No description provided for @homeMilitaryRequiresForge.
  ///
  /// In pl, this message translates to:
  /// **'Rekrutacja wymaga zbudowanej Kuźni (broń dla żołnierzy).'**
  String get homeMilitaryRequiresForge;

  /// No description provided for @homeMilitaryNotEnoughResidents.
  ///
  /// In pl, this message translates to:
  /// **'Za mało mieszkańców, żeby rekrutować kolejnego żołnierza.'**
  String get homeMilitaryNotEnoughResidents;

  /// No description provided for @homeMilitaryUnitLine.
  ///
  /// In pl, this message translates to:
  /// **'{label}: {count} (siła każdego: {strength})'**
  String homeMilitaryUnitLine(String label, int count, int strength);

  /// No description provided for @homeMilitaryRecruitButton.
  ///
  /// In pl, this message translates to:
  /// **'Rekrutuj (-{pop} mieszkaniec, -{gold} złota{extra})'**
  String homeMilitaryRecruitButton(int pop, int gold, String extra);

  /// No description provided for @homeDiscoveriesTitle.
  ///
  /// In pl, this message translates to:
  /// **'Odkrycia'**
  String get homeDiscoveriesTitle;

  /// No description provided for @homeDiscoveryUnlocked.
  ///
  /// In pl, this message translates to:
  /// **'Odkryto'**
  String get homeDiscoveryUnlocked;

  /// No description provided for @homeDiscoveryRequiresLevel.
  ///
  /// In pl, this message translates to:
  /// **'Wymaga Uczelni na poziomie {n}.'**
  String homeDiscoveryRequiresLevel(int n);

  /// No description provided for @homeDiscoveryUnlockButton.
  ///
  /// In pl, this message translates to:
  /// **'Odkryj ({cost})'**
  String homeDiscoveryUnlockButton(String cost);

  /// No description provided for @homeBuildingUpgradedSnack.
  ///
  /// In pl, this message translates to:
  /// **'{label} rozbudowany!'**
  String homeBuildingUpgradedSnack(String label);

  /// No description provided for @homeBuildingDemolishedSnack.
  ///
  /// In pl, this message translates to:
  /// **'{label}: budynek zburzony - odzyskano połowę surowców.'**
  String homeBuildingDemolishedSnack(String label);

  /// No description provided for @homeBuildingNameDom.
  ///
  /// In pl, this message translates to:
  /// **'Dom'**
  String get homeBuildingNameDom;

  /// No description provided for @homeLevel0.
  ///
  /// In pl, this message translates to:
  /// **'Poziom 0'**
  String get homeLevel0;

  /// No description provided for @homeRebuildToLevel1.
  ///
  /// In pl, this message translates to:
  /// **'Odbuduj do poziomu 1'**
  String get homeRebuildToLevel1;

  /// No description provided for @homeDecrepitHouseNotDemolishable.
  ///
  /// In pl, this message translates to:
  /// **'Opuszczonego domu nie można zburzyć - w środku wciąż mieszkają ludzie.'**
  String get homeDecrepitHouseNotDemolishable;

  /// No description provided for @homeDecrepitHouseBonusText.
  ///
  /// In pl, this message translates to:
  /// **'Dom stoi opuszczony i zaniedbany od lat - obecnie nie daje żadnego bonusu do populacji.'**
  String get homeDecrepitHouseBonusText;

  /// No description provided for @homeDecrepitHouseUpgradeText.
  ///
  /// In pl, this message translates to:
  /// **'Odbuduj dom, żeby zaczął dawać +{n} do limitu populacji.'**
  String homeDecrepitHouseUpgradeText(int n);

  /// No description provided for @homeHouseRebuiltSnack.
  ///
  /// In pl, this message translates to:
  /// **'Dom odbudowany - znów daje bonus do populacji!'**
  String get homeHouseRebuiltSnack;

  /// No description provided for @homeHouseDemolishedSnack.
  ///
  /// In pl, this message translates to:
  /// **'Dom zburzony - odzyskano połowę surowców.'**
  String get homeHouseDemolishedSnack;

  /// No description provided for @homeMarketTradeTitle.
  ///
  /// In pl, this message translates to:
  /// **'Rynek - handel'**
  String get homeMarketTradeTitle;

  /// No description provided for @homeMarketRateLine.
  ///
  /// In pl, this message translates to:
  /// **'Kurs: {give} surowca za {receive} innego.'**
  String homeMarketRateLine(int give, int receive);

  /// No description provided for @homeMarketGiveOption.
  ///
  /// In pl, this message translates to:
  /// **'Daj: {label} (masz {have})'**
  String homeMarketGiveOption(String label, int have);

  /// No description provided for @homeMarketReceiveOption.
  ///
  /// In pl, this message translates to:
  /// **'Otrzymaj: {label}'**
  String homeMarketReceiveOption(String label);

  /// No description provided for @homeMax.
  ///
  /// In pl, this message translates to:
  /// **'Maks.'**
  String get homeMax;

  /// No description provided for @homeMarketSummaryLine.
  ///
  /// In pl, this message translates to:
  /// **'Razem: oddajesz {totalGive} {giveLabel}, dostajesz {totalReceive} {receiveLabel}.'**
  String homeMarketSummaryLine(
    int totalGive,
    String giveLabel,
    int totalReceive,
    String receiveLabel,
  );

  /// No description provided for @homeMarketNotEnough.
  ///
  /// In pl, this message translates to:
  /// **'Za mało {label}, żeby wymienić choć raz.'**
  String homeMarketNotEnough(String label);

  /// No description provided for @homeClose.
  ///
  /// In pl, this message translates to:
  /// **'Zamknij'**
  String get homeClose;

  /// No description provided for @homeMarketTradeSnack.
  ///
  /// In pl, this message translates to:
  /// **'Wymieniono {totalGive} {giveLabel} na {totalReceive} {receiveLabel}.'**
  String homeMarketTradeSnack(
    int totalGive,
    String giveLabel,
    int totalReceive,
    String receiveLabel,
  );

  /// No description provided for @homeExchangeButton.
  ///
  /// In pl, this message translates to:
  /// **'Wymień'**
  String get homeExchangeButton;

  /// No description provided for @homeMoveBoughtSnack.
  ///
  /// In pl, this message translates to:
  /// **'Kupiono +1 ruch na tydzień! Teraz: {total} ruchów.'**
  String homeMoveBoughtSnack(int total);

  /// No description provided for @homeAutoMatchTier1Snack.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowano automatyczne usuwanie czwórek!'**
  String get homeAutoMatchTier1Snack;

  /// No description provided for @homeAutoMatchTier2Snack.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowano automatyczne usuwanie trójek!'**
  String get homeAutoMatchTier2Snack;

  /// No description provided for @homeAreaBuildFirst.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw zbuduj: {label}.'**
  String homeAreaBuildFirst(String label);

  /// No description provided for @homeAreaBonusStarter.
  ///
  /// In pl, this message translates to:
  /// **'{label} jest już dostępne na planszy zbiorów - ten budynek daje dodatkowo +1 do każdej zebranej ścieżki tego surowca.'**
  String homeAreaBonusStarter(String label);

  /// No description provided for @homeAreaBonusUnlock.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje {label} jako nowy surowiec do zbierania na planszy zbiorów.'**
  String homeAreaBonusUnlock(String label);

  /// No description provided for @homeAreaUpgradeText.
  ///
  /// In pl, this message translates to:
  /// **'Odblokowuje możliwość wyboru {label} jako \"surowca tygodnia\" (10-20% więcej na planszy zbiorów w wybranym tygodniu).'**
  String homeAreaUpgradeText(String label);

  /// No description provided for @homeAreaUpgradedSnack.
  ///
  /// In pl, this message translates to:
  /// **'{label} rozbudowany! Możesz teraz wybierać {resource} jako surowiec tygodnia.'**
  String homeAreaUpgradedSnack(String label, String resource);

  /// No description provided for @homeTitleUpgradedSuffix.
  ///
  /// In pl, this message translates to:
  /// **'{title} (rozbudowany)'**
  String homeTitleUpgradedSuffix(String title);

  /// No description provided for @homeTitleBuiltSuffix.
  ///
  /// In pl, this message translates to:
  /// **'{title} (zbudowany)'**
  String homeTitleBuiltSuffix(String title);

  /// No description provided for @homeAreaBuildCostTitle.
  ///
  /// In pl, this message translates to:
  /// **'Koszt budowy (poziom 1)'**
  String get homeAreaBuildCostTitle;

  /// No description provided for @homeEffectLabel.
  ///
  /// In pl, this message translates to:
  /// **'Efekt'**
  String get homeEffectLabel;

  /// No description provided for @homeLevel1.
  ///
  /// In pl, this message translates to:
  /// **'Poziom 1'**
  String get homeLevel1;

  /// No description provided for @homeUpgradeToLevel2.
  ///
  /// In pl, this message translates to:
  /// **'Rozbudowa do poziomu 2'**
  String get homeUpgradeToLevel2;

  /// No description provided for @homeLevel2.
  ///
  /// In pl, this message translates to:
  /// **'Poziom 2'**
  String get homeLevel2;

  /// No description provided for @homeDemolishRefundNote.
  ///
  /// In pl, this message translates to:
  /// **'Zburzenie zwróci połowę wszystkich zainwestowanych surowców.'**
  String get homeDemolishRefundNote;

  /// No description provided for @homeBuild.
  ///
  /// In pl, this message translates to:
  /// **'Zbuduj'**
  String get homeBuild;

  /// No description provided for @homeUpgrade.
  ///
  /// In pl, this message translates to:
  /// **'Rozbuduj'**
  String get homeUpgrade;

  /// No description provided for @homeMainBuildingNotDemolishable.
  ///
  /// In pl, this message translates to:
  /// **'Głównego budynku wioski nie można zburzyć.'**
  String get homeMainBuildingNotDemolishable;

  /// No description provided for @homeLocked.
  ///
  /// In pl, this message translates to:
  /// **'Zablokowane'**
  String get homeLocked;

  /// No description provided for @homeBuildRatuszFirst.
  ///
  /// In pl, this message translates to:
  /// **'Najpierw zbuduj Ratusz (główny budynek wioski).'**
  String get homeBuildRatuszFirst;

  /// No description provided for @homeBuildCostTitle.
  ///
  /// In pl, this message translates to:
  /// **'Koszt budowy'**
  String get homeBuildCostTitle;

  /// No description provided for @homePerksLabel.
  ///
  /// In pl, this message translates to:
  /// **'Premie'**
  String get homePerksLabel;

  /// No description provided for @homeDemolishRefund50Title.
  ///
  /// In pl, this message translates to:
  /// **'Odzysk przy zburzeniu (50%)'**
  String get homeDemolishRefund50Title;

  /// No description provided for @homeRequiresUpgradedRatusz.
  ///
  /// In pl, this message translates to:
  /// **'Wymaga rozbudowanego (poziom 2) Ratusza.'**
  String get homeRequiresUpgradedRatusz;

  /// No description provided for @homeGeneralBonusTitle.
  ///
  /// In pl, this message translates to:
  /// **'Premia ogólna'**
  String get homeGeneralBonusTitle;

  /// No description provided for @homeWorkersTitle.
  ///
  /// In pl, this message translates to:
  /// **'Pracownicy'**
  String get homeWorkersTitle;

  /// No description provided for @homeWorkersRequiresDiscovery.
  ///
  /// In pl, this message translates to:
  /// **'Wymaga odkrycia \"Zarządzanie pracownikami\" w Uczelni.'**
  String get homeWorkersRequiresDiscovery;

  /// No description provided for @homeWorkerBonusExplanation.
  ///
  /// In pl, this message translates to:
  /// **'Każdy przydzielony mieszkaniec zwiększa premię budynku o +50% (maks. {max} = {multiplier} premia).'**
  String homeWorkerBonusExplanation(int max, String multiplier);

  /// No description provided for @homeWorkerMultiplierDouble.
  ///
  /// In pl, this message translates to:
  /// **'podwójna'**
  String get homeWorkerMultiplierDouble;

  /// No description provided for @homeAvailableResidents.
  ///
  /// In pl, this message translates to:
  /// **'Wolni mieszkańcy: {n}'**
  String homeAvailableResidents(int n);

  /// No description provided for @homeWeeklyBoostTitle.
  ///
  /// In pl, this message translates to:
  /// **'Surowiec tygodnia'**
  String get homeWeeklyBoostTitle;

  /// No description provided for @homeWeeklyBoostDescription.
  ///
  /// In pl, this message translates to:
  /// **'Dzięki rozbudowanym (poziom 2) okolicom wioski możesz wybrać surowiec, który w tym tygodniu będzie pojawiał się częściej (+10-20%).'**
  String get homeWeeklyBoostDescription;

  /// No description provided for @homeSkipButton.
  ///
  /// In pl, this message translates to:
  /// **'Pomiń'**
  String get homeSkipButton;

  /// No description provided for @homeEventChoiceResultSnack.
  ///
  /// In pl, this message translates to:
  /// **'{title}: {resultText}{bonus}'**
  String homeEventChoiceResultSnack(
    String title,
    String resultText,
    String bonus,
  );

  /// No description provided for @homeEventResultSnack.
  ///
  /// In pl, this message translates to:
  /// **'{icon} {title}: {description}{bonus}'**
  String homeEventResultSnack(
    String icon,
    String title,
    String description,
    String bonus,
  );

  /// No description provided for @homeEventUnitMorale.
  ///
  /// In pl, this message translates to:
  /// **'morale'**
  String get homeEventUnitMorale;

  /// No description provided for @homeEventUnitSecurity.
  ///
  /// In pl, this message translates to:
  /// **'bezpieczeństwa'**
  String get homeEventUnitSecurity;

  /// No description provided for @homeEventUnitPopulation.
  ///
  /// In pl, this message translates to:
  /// **'populacji'**
  String get homeEventUnitPopulation;

  /// No description provided for @homeEventUnitSoldiers.
  ///
  /// In pl, this message translates to:
  /// **'żołnierzy'**
  String get homeEventUnitSoldiers;

  /// No description provided for @homeEventLossesSuffix.
  ///
  /// In pl, this message translates to:
  /// **'(straty)'**
  String get homeEventLossesSuffix;

  /// No description provided for @homeGoalNotFoughtYet.
  ///
  /// In pl, this message translates to:
  /// **'jeszcze nie stoczono'**
  String get homeGoalNotFoughtYet;

  /// No description provided for @homeGoalBattleProgress.
  ///
  /// In pl, this message translates to:
  /// **'{cleared}/3 etapów (min. {required})'**
  String homeGoalBattleProgress(int cleared, int required);

  /// No description provided for @homeGoalRatuszBuilt.
  ///
  /// In pl, this message translates to:
  /// **'Ratusz zbudowany'**
  String get homeGoalRatuszBuilt;

  /// No description provided for @homeGoalOrchardDeveloped.
  ///
  /// In pl, this message translates to:
  /// **'Sad rozwinięty'**
  String get homeGoalOrchardDeveloped;

  /// No description provided for @homeGoalMeadowDeveloped.
  ///
  /// In pl, this message translates to:
  /// **'Łąka rozwinięta'**
  String get homeGoalMeadowDeveloped;

  /// No description provided for @homeGoalFieldDeveloped.
  ///
  /// In pl, this message translates to:
  /// **'Pole rozwinięte'**
  String get homeGoalFieldDeveloped;

  /// No description provided for @homeGoalBattleGrot.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Grotem'**
  String get homeGoalBattleGrot;

  /// No description provided for @homeGoalBattleMarta.
  ///
  /// In pl, this message translates to:
  /// **'Starcie z Martą'**
  String get homeGoalBattleMarta;

  /// No description provided for @homeGoalBogdanProof.
  ///
  /// In pl, this message translates to:
  /// **'Pełny Dowód zebrany u Bogdana'**
  String get homeGoalBogdanProof;

  /// No description provided for @homeGoalArmyStrength.
  ///
  /// In pl, this message translates to:
  /// **'Siła armii'**
  String get homeGoalArmyStrength;

  /// No description provided for @homeGoalVillageSecurity.
  ///
  /// In pl, this message translates to:
  /// **'Bezpieczeństwo wioski'**
  String get homeGoalVillageSecurity;

  /// No description provided for @homeGoalLeszyDefeated.
  ///
  /// In pl, this message translates to:
  /// **'Leszy pokonany'**
  String get homeGoalLeszyDefeated;

  /// No description provided for @homeGoalQuestSladyWPopiele.
  ///
  /// In pl, this message translates to:
  /// **'Quest \"Ślady w popiele\"'**
  String get homeGoalQuestSladyWPopiele;

  /// No description provided for @homeGoalQuestRozmowaZJadwiga.
  ///
  /// In pl, this message translates to:
  /// **'Quest \"Rozmowa z Jadwigą\"'**
  String get homeGoalQuestRozmowaZJadwiga;

  /// No description provided for @homeSideQuestMoraleProgress.
  ///
  /// In pl, this message translates to:
  /// **'{n}/70 morale'**
  String homeSideQuestMoraleProgress(int n);

  /// No description provided for @homeSideQuestArmyStrengthProgress.
  ///
  /// In pl, this message translates to:
  /// **'{n}/20 siły armii'**
  String homeSideQuestArmyStrengthProgress(int n);

  /// No description provided for @homeBuilt.
  ///
  /// In pl, this message translates to:
  /// **'zbudowana'**
  String get homeBuilt;

  /// No description provided for @homeNotBuilt.
  ///
  /// In pl, this message translates to:
  /// **'niezbudowana'**
  String get homeNotBuilt;

  /// No description provided for @homeSideQuestGrotKarczmaProgress.
  ///
  /// In pl, this message translates to:
  /// **'Grot: {stages}/3 etapów (min. 2) • Karczma: {karczma}'**
  String homeSideQuestGrotKarczmaProgress(int stages, String karczma);

  /// No description provided for @homeGrotVictoryFullSnack.
  ///
  /// In pl, this message translates to:
  /// **'Grot pokonany bez strat! Łup: +15 złota, +15 drewna.'**
  String get homeGrotVictoryFullSnack;

  /// No description provided for @homeGrotVictoryPartialSnack.
  ///
  /// In pl, this message translates to:
  /// **'Grot odparty, ale starcie kosztowało wioskę: -10% drewna i złota.'**
  String get homeGrotVictoryPartialSnack;

  /// No description provided for @homeGrotDefeatSnack.
  ///
  /// In pl, this message translates to:
  /// **'Grot przełamał obronę wioski - ukończono tylko {cleared}/3 etapów starcia.'**
  String homeGrotDefeatSnack(int cleared);

  /// No description provided for @homeMartaVictoryFullTrustSnack.
  ///
  /// In pl, this message translates to:
  /// **'Marta w pełni Ci zaufała, dając sobie czas na rozmowę: +15 morale.'**
  String get homeMartaVictoryFullTrustSnack;

  /// No description provided for @homeMartaVictoryTrustSnack.
  ///
  /// In pl, this message translates to:
  /// **'Marta przełamana - staje się sojuszniczką: +10 morale.'**
  String get homeMartaVictoryTrustSnack;

  /// No description provided for @homeMartaVictoryPartialSnack.
  ///
  /// In pl, this message translates to:
  /// **'Marta częściowo Ci zaufała, ale wciąż coś ukrywa.'**
  String get homeMartaVictoryPartialSnack;

  /// No description provided for @homeMartaDefeatSnack.
  ///
  /// In pl, this message translates to:
  /// **'Marta wycofała się, nie zdradzając niczego więcej - ukończono tylko {cleared}/3 etapów starcia.'**
  String homeMartaDefeatSnack(int cleared);

  /// No description provided for @homeBogdanVictoryFullSnack.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan pęka całkowicie pod ciężarem dowodów i ucieka bez zemsty.'**
  String get homeBogdanVictoryFullSnack;

  /// No description provided for @homeBogdanVictoryPartialSnack.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan ucieka, ale zdążył podpalić część magazynu ({burns} raz(y)) po drodze.'**
  String homeBogdanVictoryPartialSnack(int burns);

  /// No description provided for @homeBogdanDefeatSnack.
  ///
  /// In pl, this message translates to:
  /// **'Nie udało się przełamać Bogdana - magazyn ucierpiał {burns} raz(y), a on wciąż jest przekonany o swojej racji.'**
  String homeBogdanDefeatSnack(int burns);

  /// No description provided for @homeDebugGrotResultSnack.
  ///
  /// In pl, this message translates to:
  /// **'Debug: starcie z Grotem zakończone - {cleared}/3 etapów (bez wpływu na zapis gry).'**
  String homeDebugGrotResultSnack(int cleared);

  /// No description provided for @homeDebugMartaResultSnack.
  ///
  /// In pl, this message translates to:
  /// **'Debug: starcie z Martą zakończone - {cleared}/3 etapów{suffix} (bez wpływu na zapis gry).'**
  String homeDebugMartaResultSnack(int cleared, String suffix);

  /// No description provided for @homeDebugMartaFullTrustSuffix.
  ///
  /// In pl, this message translates to:
  /// **' (pełne zaufanie)'**
  String get homeDebugMartaFullTrustSuffix;

  /// No description provided for @homeDebugBogdanResultSnack.
  ///
  /// In pl, this message translates to:
  /// **'Debug: starcie z Bogdanem zakończone - Dowód {proof}, {burns} spalenie(a) (bez wpływu na zapis gry).'**
  String homeDebugBogdanResultSnack(String proof, int burns);

  /// No description provided for @homeDebugProofGathered.
  ///
  /// In pl, this message translates to:
  /// **'zebrany'**
  String get homeDebugProofGathered;

  /// No description provided for @homeDebugProofIncomplete.
  ///
  /// In pl, this message translates to:
  /// **'niepełny'**
  String get homeDebugProofIncomplete;

  /// No description provided for @homeDebugLeszyResultSnack.
  ///
  /// In pl, this message translates to:
  /// **'Debug: starcie z Leszym zakończone - {result} (bez wpływu na zapis gry).'**
  String homeDebugLeszyResultSnack(String result);

  /// No description provided for @homeDebugVictory.
  ///
  /// In pl, this message translates to:
  /// **'zwycięstwo'**
  String get homeDebugVictory;

  /// No description provided for @homeDebugDefeat.
  ///
  /// In pl, this message translates to:
  /// **'porażka'**
  String get homeDebugDefeat;

  /// No description provided for @homeActFailure0.
  ///
  /// In pl, this message translates to:
  /// **'Wioska nie zdążyła przygotować się na czas - dziedzictwo Antoniego zostało zaprzepaszczone.'**
  String get homeActFailure0;

  /// No description provided for @homeActFailure1.
  ///
  /// In pl, this message translates to:
  /// **'Grot przełamał obronę nieprzygotowanej wioski.'**
  String get homeActFailure1;

  /// No description provided for @homeActFailure2.
  ///
  /// In pl, this message translates to:
  /// **'Marta nie zdradziła kluczowej prawdy, a wioska straciła nadzieję.'**
  String get homeActFailure2;

  /// No description provided for @homeActFailure3.
  ///
  /// In pl, this message translates to:
  /// **'Osłabiona głodem i słabą obroną wioska nie przetrwała konfrontacji z Bogdanem.'**
  String get homeActFailure3;

  /// No description provided for @homeActFailure4.
  ///
  /// In pl, this message translates to:
  /// **'Wioska nie zdążyła się przygotować - armia zbyt słaba, mury zbyt kruche na to, co nadchodzi z lasu.'**
  String get homeActFailure4;

  /// No description provided for @homeActFailure5.
  ///
  /// In pl, this message translates to:
  /// **'Leszy został pokonany, ale niektóre wątki pozostają niedomknięte - historia kończy się bez pełnej odpowiedzi.'**
  String get homeActFailure5;

  /// No description provided for @homeActFailureDefault.
  ///
  /// In pl, this message translates to:
  /// **'Cel tego aktu nie został osiągnięty.'**
  String get homeActFailureDefault;

  /// No description provided for @homeBossIntroGrotMessage.
  ///
  /// In pl, this message translates to:
  /// **'Grot i jego zbrojni zbliżają się do wioski. Czas przygotować obronę.'**
  String get homeBossIntroGrotMessage;

  /// No description provided for @homeBossIntroMartaMessage.
  ///
  /// In pl, this message translates to:
  /// **'Marta staje naprzeciw Ciebie, uzbrojona, wysłana przez ojca. Nie ma odwrotu.'**
  String get homeBossIntroMartaMessage;

  /// No description provided for @homeBossIntroBogdanMessage.
  ///
  /// In pl, this message translates to:
  /// **'Bogdan Kruk przybywa osobiście, żądając prawdy. Konfrontacja jest nieunikniona.'**
  String get homeBossIntroBogdanMessage;

  /// No description provided for @homeBossIntroLeszyMessage.
  ///
  /// In pl, this message translates to:
  /// **'Mroczny cień lasu budzi się w pełni. Ostateczne starcie o los wioski zaczyna się teraz.'**
  String get homeBossIntroLeszyMessage;

  /// No description provided for @homeLeszyVictorySnack.
  ///
  /// In pl, this message translates to:
  /// **'Leszy pokonany! Cień cofa się w głąb ziemi.'**
  String get homeLeszyVictorySnack;

  /// No description provided for @homeActGoalReachedSnack.
  ///
  /// In pl, this message translates to:
  /// **'Cel Aktu {actNumber} (\"{actName}\") osiągnięty! (+{xp} XP)'**
  String homeActGoalReachedSnack(int actNumber, String actName, int xp);

  /// No description provided for @homeSideQuestCompletedSnack.
  ///
  /// In pl, this message translates to:
  /// **'Quest poboczny ukończony: \"{title}\" (+{xp} XP)'**
  String homeSideQuestCompletedSnack(String title, int xp);

  /// No description provided for @homeDebugJumpedToWeekSnack.
  ///
  /// In pl, this message translates to:
  /// **'Debug: przeniesiono do tygodnia {week}.'**
  String homeDebugJumpedToWeekSnack(int week);

  /// No description provided for @homeExitGameTitle.
  ///
  /// In pl, this message translates to:
  /// **'Wyjść z gry?'**
  String get homeExitGameTitle;

  /// No description provided for @homeExitGameMessage.
  ///
  /// In pl, this message translates to:
  /// **'Na pewno chcesz zamknąć Rolnika?'**
  String get homeExitGameMessage;

  /// No description provided for @homeExit.
  ///
  /// In pl, this message translates to:
  /// **'Wyjdź'**
  String get homeExit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
