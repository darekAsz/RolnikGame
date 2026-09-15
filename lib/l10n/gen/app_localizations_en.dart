// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rolnik: Dług Kruka';

  @override
  String get commonClose => 'Close';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get statsXpLabel => 'Experience';

  @override
  String statsXpValue(int xp) {
    return '$xp XP';
  }

  @override
  String get statsTotalCollectedLabel => 'Total resources collected';

  @override
  String get statsLongestPathLabel => 'Longest path';

  @override
  String statsLongestPathValue(int count) {
    return '$count tiles';
  }

  @override
  String get statsMaxSingleHarvestLabel => 'Most collected at once';

  @override
  String get statsPopulationLabel => 'Population';

  @override
  String get statsPopulationDescription =>
      'Limits how many villagers can be recruited as soldiers or assigned as workers to buildings.';

  @override
  String get statsMoraleLabel => 'Village morale';

  @override
  String get statsMoraleDescription =>
      'The higher it is, the more positive (and fewer negative) weekly events occur. High morale also makes some boss battles easier.';

  @override
  String get statsSecurityLabel => 'Village security';

  @override
  String get statsSecurityDescription =>
      'Raises Village HP in the final battle (up to +40) and makes some boss battles easier.';

  @override
  String get statsSoldiersLabel => 'Soldiers (army strength)';

  @override
  String get statsSoldiersDescription =>
      'The number of soldiers and army strength (including the Barracks level 2 bonus) make some boss battles easier.';

  @override
  String get statsComicsLabel => 'Comics';

  @override
  String statsComicsUnread(int count) {
    return '$count unread';
  }

  @override
  String get statsComicsAllRead => 'All read';

  @override
  String get statsBoardStyleLabel => 'Board style';

  @override
  String get statsBoardStyleNew => 'New';

  @override
  String get statsBoardStyleOld => 'Older';

  @override
  String get statsIconStyleLabel => 'Resource icon style';

  @override
  String get statsIconStyleNew => 'New';

  @override
  String get statsIconStyleMid => 'Intermediate';

  @override
  String get statsIconStyleOld => 'Older';

  @override
  String get statsLanguageLabel => 'Language';

  @override
  String get statsLanguagePolish => 'Polish';

  @override
  String get statsLanguageEnglish => 'English';

  @override
  String get comicsTitle => 'Comics';

  @override
  String comicsUnlockedCount(int unlocked, int total) {
    return '$unlocked of $total unlocked';
  }

  @override
  String get comicsNoneYet => 'The first comic will appear soon.';

  @override
  String comicsNextUnlocks(int week) {
    return 'The next comic unlocks in week $week.';
  }

  @override
  String comicsWeekActLabel(int week, int act) {
    return 'Week $week · Act $act';
  }

  @override
  String get comicsNewBadge => 'NEW';

  @override
  String comicsWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String comicsPanelLabel(int panel, int count) {
    return 'Panel $panel / $count';
  }

  @override
  String get comicsNext => 'Next';

  @override
  String get goalsTitle => 'Goals';

  @override
  String goalsWeekOnly(int week) {
    return 'Week $week';
  }

  @override
  String goalsWeekAct(int week, int act, String actName) {
    return 'Week $week — Act $act: $actName';
  }

  @override
  String get goalsStoryOver =>
      'The story has come to an end. The village carries on at its own pace.';

  @override
  String get goalsMainGoal => 'Main goal';

  @override
  String get goalsRequirements => 'Requirements';

  @override
  String get goalsSideQuests => 'Side quests';

  @override
  String get goalsStoryContext => 'Story context';

  @override
  String get goalsCompletedGoals => 'Completed goals';

  @override
  String goalsResolvedActLabel(int act, String name) {
    return 'Act $act: $name';
  }

  @override
  String get goalsRequirementsMet => 'Requirements already met';

  @override
  String get goalsRequirementsNotMet => 'Requirements not yet met';

  @override
  String goalsDecidedAtEnd(int endWeek) {
    return 'The requirements above only decide the outcome at the end of the act (week $endWeek).';
  }

  @override
  String goalsQuestXp(String title, int xp) {
    return '$title (+$xp XP)';
  }

  @override
  String get harvestGridNoMovesTitle => 'No available moves';

  @override
  String get harvestGridNoMovesMessage =>
      'There are no more possible matches on the board. You can reshuffle the board (cost: 1 move).';

  @override
  String get harvestGridCloseButton => 'Close';

  @override
  String get harvestGridReshuffleButton => 'Reshuffle (−1 move)';

  @override
  String get harvestScreenTutorialStep1Title => 'Connect the orbs';

  @override
  String get harvestScreenTutorialStep1Description =>
      'Drag your finger across neighboring orbs of the same resource (diagonals count too) and release to collect them. The longer the chain, the more you get.';

  @override
  String get harvestScreenTutorialStep2Title => 'Wild joker';

  @override
  String get harvestScreenTutorialStep2Description =>
      'A chain of 5+ orbs turns one of the new orbs into a joker — it connects with any resource and multiplies your harvest.';

  @override
  String get harvestScreenTutorialStep3Title => 'Bomb';

  @override
  String get harvestScreenTutorialStep3Description =>
      'A chain of 6+ orbs turns one of the new orbs into a bomb — when included in your next chain, it destroys all neighboring tiles.';

  @override
  String get harvestScreenTutorialStep4Title => 'Moves run out';

  @override
  String get harvestScreenTutorialStep4Description =>
      'Each drag counts as one move — the counter at the top shows how many are left. When they run out, the harvest round ends.';

  @override
  String get harvestScreenTutorialDialogTitle => 'How to harvest resources';

  @override
  String get harvestScreenTutorialGotItButton => 'Got it';

  @override
  String get harvestScreenRoundEndTitle => '⏳ Out of moves';

  @override
  String get harvestScreenRoundEndCollectedLabel =>
      'Resources collected this week:';

  @override
  String get harvestScreenRoundEndNothingCollected => 'Nothing was collected.';

  @override
  String get harvestScreenRoundEndReplayButton => 'Replay this week';

  @override
  String get harvestScreenRoundEndReturnButton => 'Return to the village';

  @override
  String get harvestScreenShuffleConfirmTitle => 'Shuffle the board?';

  @override
  String get harvestScreenShuffleConfirmContent =>
      'All tiles on the board will be randomly shuffled. Cost: 1 move.';

  @override
  String get harvestScreenShuffleCancelButton => 'Cancel';

  @override
  String get harvestScreenShuffleConfirmButton => 'Shuffle (−1 move)';

  @override
  String get harvestScreenGiveUpTitle => 'Give up this harvest week?';

  @override
  String get harvestScreenGiveUpContent =>
      'You\'ll return to the village, and this week\'s harvest in progress will be cancelled.';

  @override
  String get harvestScreenGiveUpStayButton => 'Stay';

  @override
  String get harvestScreenGiveUpConfirmButton => 'Give up the week';

  @override
  String harvestScreenAppBarTitle(int week) {
    return 'Harvest — Week $week';
  }

  @override
  String get harvestScreenShuffleTooltip => 'Shuffle board (−1 move)';

  @override
  String harvestScreenMovesLabel(int moves) {
    return 'Moves: $moves';
  }

  @override
  String get shopTitle => 'Shop';

  @override
  String get shopSubtitle =>
      'Spend gold to permanently increase the number of moves on the harvest board.';

  @override
  String get shopMovesPerWeekLabel => 'Moves per week';

  @override
  String shopMovesBreakdown(int base, int extra) {
    return 'Base $base + purchased $extra';
  }

  @override
  String get shopBuyMoveTitle => '+1 move per week (permanent)';

  @override
  String shopGoldAvailable(int gold) {
    return 'You have: $gold gold';
  }

  @override
  String get shopMaxMovesReached => 'Maximum number of moves reached.';

  @override
  String shopCost(int cost) {
    return 'Cost: $cost gold';
  }

  @override
  String get shopBuyButton => 'Buy';

  @override
  String get shopAutoMatchTier1Title =>
      'Automatic clearing of four-tile matches';

  @override
  String get shopAutoMatchTier1Description =>
      'By default, tiles arranged in a match stay on the board until you collect them by hand. This upgrade makes matches of 4 or more disappear automatically. It doesn\'t work during boss battles — there, collecting always stays manual.';

  @override
  String get shopAutoMatchTier2Title =>
      'Upgrade: automatic clearing of three-tile matches';

  @override
  String get shopAutoMatchTier2Description =>
      'The next tier — after this upgrade, matches made of just 3 tiles also disappear automatically. Just like the previous tier, it doesn\'t work during boss battles.';

  @override
  String get shopAutoMatchTier2LockedRequirement =>
      'Requires: automatic clearing of four-tile matches';

  @override
  String get shopUnlockedLabel => 'Unlocked';

  @override
  String resourcesViewLockedInfoContent(String resource) {
    return '$resource hasn\'t been discovered yet. Until you unlock it in the Village Surroundings, all bonuses to this resource (e.g. from the Town Hall or production buildings) won\'t apply.';
  }

  @override
  String get resourcesViewGotItButton => 'Got it';

  @override
  String get resourcesViewTitle => 'Resources';

  @override
  String get resourcesViewMarketButton => 'Market';

  @override
  String resourcesViewStorageLimit(int cap) {
    return 'Storage: limit of $cap for each resource.';
  }

  @override
  String get resourcesViewProductionConsumptionTitle =>
      'Weekly production and consumption';

  @override
  String get surroundingsTitle => 'Village Surroundings';

  @override
  String get surroundingsSubtitle =>
      'Development path: each stage requires the previous one to be completed.';

  @override
  String surroundingsRequiresLabel(String prerequisite) {
    return 'Requires: $prerequisite';
  }

  @override
  String surroundingsPathBonus(String resource) {
    return '+1 to the $resource path';
  }

  @override
  String surroundingsUnlockResource(String resource) {
    return 'Unlock $resource';
  }

  @override
  String get surroundingsLevelMaxLabel => 'Level 2/2 - resource of the week';

  @override
  String get surroundingsLevelUpgradableLabel => 'Level 1/2 - can be upgraded';

  @override
  String get resourceFlowEmptyState =>
      'No production or consumption sources built yet.';

  @override
  String resourceFlowNetPerWeek(String net) {
    return '$net/wk';
  }

  @override
  String get splashNewGameDialogTitle => 'Start a new game?';

  @override
  String get splashNewGameDialogContent =>
      'This will overwrite and permanently delete your current save. If you want to continue your existing playthrough, choose \"Continue\" instead.';

  @override
  String get splashCancel => 'Cancel';

  @override
  String get splashOverwriteAndStart => 'Overwrite and start over';

  @override
  String get splashTitle => 'Farmer';

  @override
  String get splashSubtitle => 'The Raven\'s Debt';

  @override
  String get splashNewGame => 'New Game';

  @override
  String get splashContinue => 'Continue';

  @override
  String get endingTitle => 'The End of Year One';

  @override
  String get endingContinue => 'Continue';

  @override
  String get endingStatsCardTitle => 'Year One in numbers';

  @override
  String get endingStatPopulationLabel => 'Population';

  @override
  String endingStatPopulationValue(int population, int populationLimit) {
    return '$population / $populationLimit';
  }

  @override
  String get endingStatMoraleLabel => 'Village morale';

  @override
  String endingStatMoraleValue(int value) {
    return '$value%';
  }

  @override
  String get endingStatXpLabel => 'Experience earned';

  @override
  String endingStatXpValue(int xp) {
    return '$xp XP';
  }

  @override
  String get endingStatGrotLabel => 'Battle with Grot';

  @override
  String endingStatGrotValue(int cleared) {
    return '$cleared / 3 stages';
  }

  @override
  String get endingStatSideQuestsLabel => 'Side quests';

  @override
  String endingStatSideQuestsValue(int claimed, int total) {
    return '$claimed / $total';
  }

  @override
  String get endingStatHungerLabel => 'Hunger';

  @override
  String get endingStatHungerYes => 'The village went through it';

  @override
  String get endingStatHungerNo => 'It never struck the village';

  @override
  String get endingTierGoldenLabel => 'Golden Age';

  @override
  String get endingTierHardWonLabel => 'Hard-Won Victory';

  @override
  String get endingTierScarredLabel => 'Scars That Remain';

  @override
  String get endingTierGoldenEpilogue =>
      'The village is thriving like never before. Granaries full, walls strong, and people no longer fear the dusk. Kazimierz repaid a debt he never took on himself - and did it with interest, turning his grandfather\'s burden into the foundation of something lasting. Marta stays - not as an enemy, not out of necessity, but as someone who finally found a home on the other side of a border that stopped dividing anything.';

  @override
  String get endingTierHardWonEpilogue =>
      'The village survived - bruised, exhausted, but still standing. Not everything went smoothly: there were nights of hardship and battles whose outcome hung by a thread. But the debt was paid, and Marta and Jadwiga now stand beside Kazimierz as the family he chose for himself - not the one he inherited.';

  @override
  String get endingTierScarredEpilogue =>
      'Victory tastes bitter. The village stands, the debt is paid, Leszy defeated - but the price was high: hungry nights, empty granaries, neighbors looking at Kazimierz differently than they once looked at Antoni. Marta stays by his side, and he himself begins to understand why his grandfather carried this secret in silence for twenty years - not every victory can be celebrated.';

  @override
  String get tutorialAppBarTitle => 'How to Play';

  @override
  String get tutorialStep1Title => 'Chain resources';

  @override
  String get tutorialStep1Description =>
      'Drag your finger across adjacent tiles of the same resource (diagonals count too) to collect them.';

  @override
  String get tutorialStep2Title => 'Wild joker';

  @override
  String get tutorialStep2Description =>
      'A longer chain (5 tiles or more) earns you a joker - it connects with any resource and multiplies your harvest.';

  @override
  String get tutorialStep3Title => 'Bomb';

  @override
  String get tutorialStep3Description =>
      'An even longer chain (6 or more) earns you a bomb - added to a chain, it destroys neighboring tiles.';

  @override
  String get tutorialStep4Title => 'Expand the village';

  @override
  String get tutorialStep4Description =>
      'Collected resources stay in the village between weeks - in the future they\'ll be used to expand it.';

  @override
  String get tutorialFinishButton => 'Got it, let\'s start!';

  @override
  String get actFailureTitle => 'Defeat';

  @override
  String actFailureSubtitle(int actNumber, String actName) {
    return 'Act $actNumber: \"$actName\" has failed.';
  }

  @override
  String get actFailureLoadSaveHeader => 'Load a save and try again';

  @override
  String get actFailureNoSavedWeeks => 'No saved weeks.';

  @override
  String actFailureWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String get actFailureNewGameButton => 'Start a new game';

  @override
  String weekTransitionWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugSubtitle => 'Testing tools - not part of normal gameplay.';

  @override
  String get debugJumpToWeekHeader => 'Jump to week';

  @override
  String get debugWeekNumberLabel => 'Week number (1-65)';

  @override
  String get debugJumpButton => 'Jump';

  @override
  String get debugAddResourcesHeader => 'Add resources';

  @override
  String get debugAddAllButton => '+100 all';

  @override
  String debugAddResourceButton(String resource) {
    return '+100 $resource';
  }

  @override
  String get debugBossTrainingHeader => 'Boss training battle';

  @override
  String get debugBossTrainingDescription =>
      'Starts the battle immediately, using the village\'s current stats - the result is NOT saved and does not affect the story or resources.';

  @override
  String get debugFightGrot => 'Grot (week 26)';

  @override
  String get debugFightMarta => 'Marta (week 39)';

  @override
  String get debugFightBogdan => 'Bogdan (week 52)';

  @override
  String get debugFightLeszy => 'Leszy (week 59)';

  @override
  String bossIntroWeekLabel(int week) {
    return 'Week $week';
  }

  @override
  String get bossIntroPrepareButton => 'Prepare for battle';

  @override
  String get bossStage1Title => 'Stage 1: Fortifications';

  @override
  String get bossStage1Intro =>
      'The enemy is approaching. Build barricades and dig trenches before they reach the village.';

  @override
  String get bossStage2Title => 'Stage 2: Traps';

  @override
  String get bossStage2IntroOne =>
      'Grot and his men are already at the gate - connect longer paths to create bombs, and detonate one of them.';

  @override
  String bossStage2IntroMany(int count) {
    return 'Grot and his men are already at the gate - connect longer paths to create bombs, and detonate $count of them.';
  }

  @override
  String get bossStage3Title => 'Stage 3: Clash';

  @override
  String bossStage3Intro(int count) {
    return 'The final charge - amid the chaos of battle, pick out swords ($count); wood and stone just get in the way.';
  }

  @override
  String bossAppBarTitle(int week) {
    return 'Battle with Grot - Week $week';
  }

  @override
  String bossMovesLabel(int moves) {
    return 'Moves: $moves';
  }

  @override
  String get bossStartButton => 'Start';

  @override
  String bossProgressStage1(
    int wood,
    int woodTarget,
    int stone,
    int stoneTarget,
  ) {
    return 'Wood $wood/$woodTarget - Stone $stone/$stoneTarget';
  }

  @override
  String bossProgressStage2(int bombs, int target) {
    return 'Bombs detonated: $bombs/$target';
  }

  @override
  String bossProgressStage3(int swords, int target) {
    return 'Swords: $swords/$target';
  }

  @override
  String get bossSummaryFullVictoryTitle => '🎉 Full victory!';

  @override
  String get bossSummaryFullVictoryText =>
      'Grot falls to his knee, defeated. The village defended itself without losses.';

  @override
  String get bossSummaryPartialVictoryTitle => '⚔️ Victory at a cost';

  @override
  String get bossSummaryPartialVictoryText =>
      'Grot retreats, but the battle cost the village some of its supplies.';

  @override
  String get bossSummaryDefeatTitle => '💀 Defeat';

  @override
  String get bossSummaryDefeatText =>
      'Grot broke through the village\'s defenses and plundered its supplies.';

  @override
  String bossSummaryStagesCleared(int cleared) {
    return 'Stages completed: $cleared/3';
  }

  @override
  String get bossReturnButton => 'Return to the village';

  @override
  String get martaStage1Title => 'Stage 1: Clues';

  @override
  String martaStage1IntroDefault(int minWood, int minStone) {
    return 'You\'re gathering traces of her earlier, clumsy sabotage - and scraps of gossip circulating around the village. You need enough evidence to confront her with confidence ($minWood wood, $minStone stone). But if you overdo it, the rumor will take on a life of its own before you can talk to her - you\'ll have to try again, and Marta will become more wary in stage 2.';
  }

  @override
  String martaStage1IntroOvershot(int minWood, int minStone, int stage2Target) {
    return 'You overdid it - the rumor took on a life of its own before you could talk to her. Try again ($minWood wood, $minStone stone) - but Marta is already more wary: stage 2 will require one more moment of hesitation ($stage2Target).';
  }

  @override
  String get martaStage2Title => 'Stage 2: Stalemate';

  @override
  String get martaStage2IntroOne =>
      'Marta is defending half-heartedly. Catch one moment of hesitation in her blows (jokers) - but avoid escalation, since aggressive, long paths (bombs) will only spook her and demand more patience.';

  @override
  String martaStage2IntroMany(int count) {
    return 'Marta is defending half-heartedly. Catch $count moments of hesitation in her blows (jokers) - but avoid escalation, since aggressive, long paths (bombs) will only spook her and demand more patience.';
  }

  @override
  String get martaStage3Title => 'Stage 3: Truth';

  @override
  String get martaStage3Intro =>
      'You\'re breaking through her silence. Collect Truth (wood/stone/water on the board are just noise, they don\'t count for anything) - and don\'t rush, the more moves you have left at the end, the fuller her trust will be.';

  @override
  String martaAppBarTitle(int week) {
    return 'Battle with Marta - Week $week';
  }

  @override
  String martaMovesLabel(int moves) {
    return 'Moves: $moves';
  }

  @override
  String get martaStartButton => 'Start';

  @override
  String martaProgressStage1(
    int wood,
    int minWood,
    int maxWood,
    int stone,
    int minStone,
    int maxStone,
  ) {
    return 'Wood $wood/$minWood (limit $maxWood) - Stone $stone/$minStone (limit $maxStone)';
  }

  @override
  String martaProgressStage2(int jokers, int target) {
    return 'Moments of hesitation: $jokers/$target';
  }

  @override
  String martaProgressStage3(int truth, int target) {
    return 'Truth: $truth/$target';
  }

  @override
  String get martaSummaryFullTrustTitle => '🎉 Full trust';

  @override
  String get martaSummaryFullTrustText =>
      'You gave her the time she was waiting for. Marta tells you everything, without reservation.';

  @override
  String get martaSummaryPartialTrustTitle => '🤝 Breakthrough';

  @override
  String get martaSummaryPartialTrustText =>
      'Marta finally believes you - she becomes an ally, though a cautious one.';

  @override
  String get martaSummaryClashTitle => '⚔️ Partial breakthrough';

  @override
  String get martaSummaryClashText =>
      'Marta lowers her weapon, but she\'s still hiding something from you.';

  @override
  String get martaSummaryWithdrawTitle => '💔 Withdrawal';

  @override
  String get martaSummaryWithdrawText =>
      'Marta closes herself off and leaves, revealing nothing more.';

  @override
  String martaSummaryStagesCleared(int cleared) {
    return 'Stages completed: $cleared/3';
  }

  @override
  String get martaReturnButton => 'Return to the village';

  @override
  String bogdanAppBarTitle(int week) {
    return 'Battle with Bogdan - Week $week';
  }

  @override
  String bogdanMovesLabel(int moves) {
    return 'Moves: $moves';
  }

  @override
  String get bogdanPeknicieTitle => 'Crack';

  @override
  String bogdanPeknicieIntro(int limit) {
    return 'Bogdan hesitates, reaching for the diary... You have $limit moves to collect as much Evidence as possible before he shuts himself off in anger again.';
  }

  @override
  String get bogdanFuriaTitle => 'Fury';

  @override
  String bogdanFuriaStartIntro(int calmTarget, int furiaLimit) {
    return 'Bogdan arrives in person, furious. Calm him down - gather $calmTarget water before the moves run out ($furiaLimit), or he\'ll set part of the storehouse on fire.';
  }

  @override
  String get bogdanFuriaRetryTitle => 'Fury (again)';

  @override
  String bogdanFuriaRetryIntro(int furiaLimit) {
    return 'Bogdan managed to set part of the granary on fire! (-15% grain and apples) Try again - you have $furiaLimit moves.';
  }

  @override
  String bogdanFuriaRetryDiscountedIntro(int furiaLimit) {
    return 'Marta ran in and stopped her father! He only managed to burn a little (-5%). Try again - you have $furiaLimit moves.';
  }

  @override
  String bogdanFuriaAfterPeknicieIntro(int calmTarget, int furiaLimit) {
    return 'Bogdan flies into a rage again. Calm him down once more - $calmTarget water, $furiaLimit moves.';
  }

  @override
  String bogdanCollectedProofLabel(int current, int target) {
    return 'Evidence collected so far: $current/$target';
  }

  @override
  String get bogdanStartButton => 'Start';

  @override
  String bogdanProgressFuria(int progress, int target, int movesLeft) {
    return 'Composure: $progress/$target ($movesLeft moves left this attempt)';
  }

  @override
  String bogdanProgressPeknicie(int current, int target, int movesLeft) {
    return 'Evidence: $current/$target ($movesLeft moves left in this window)';
  }

  @override
  String get bogdanSummaryFullVictoryTitle => '🎉 Full victory';

  @override
  String get bogdanSummaryFullVictoryText =>
      'Bogdan breaks completely under the weight of the evidence. He flees into the forest without revenge.';

  @override
  String get bogdanSummaryPartialVictoryTitle => '⚔️ Victory at a cost';

  @override
  String get bogdanSummaryPartialVictoryText =>
      'Bogdan finally flees, but he managed to hurt the village along the way.';

  @override
  String get bogdanSummaryDefeatTitle => '💀 Defeat';

  @override
  String get bogdanSummaryDefeatText =>
      'The moves ran out before he could be broken. Bogdan rides off, still convinced he\'s right.';

  @override
  String bogdanSummaryStats(int proof, int target, int burns) {
    return 'Evidence: $proof/$target - Storehouse burns: $burns';
  }

  @override
  String get bogdanReturnButton => 'Return to the village';

  @override
  String get leszyAbilityCounterName => 'Counterattack';

  @override
  String get leszyAbilityCounterCost => '-25 water';

  @override
  String get leszyAbilityCounterEffect => '-10 HP to Leszy';

  @override
  String get leszyAbilityGuardName => 'Guard';

  @override
  String get leszyAbilityGuardCost => '-25 stone';

  @override
  String get leszyAbilityGuardEffect =>
      '+10 shield (absorbs damage, resets after each of Leszy\'s turns)';

  @override
  String get leszyAbilityHealName => 'Healing';

  @override
  String get leszyAbilityHealCost => '-25 wood';

  @override
  String get leszyAbilityHealEffect => '+10 Village HP, removes poison';

  @override
  String get leszyAbilityCleanseName => 'Cleansing';

  @override
  String get leszyAbilityCleanseCost => '-20 wood, -20 stone';

  @override
  String get leszyAbilityCleanseEffect =>
      'resets the Shadow pool to zero and removes all Shadow orbs from the board';

  @override
  String get leszyAbilityPrayerName => 'Prayer';

  @override
  String get leszyAbilityPrayerCost => '-20 water, -20 wood';

  @override
  String get leszyAbilityPrayerEffect => 'halves Leszy\'s next blow';

  @override
  String get leszyAbilityCalmName => 'Calming';

  @override
  String get leszyAbilityCalmCost => '-30 water';

  @override
  String get leszyAbilityCalmEffect => '-3 to Leszy\'s strength';

  @override
  String get leszyAbilityWallName => 'Wall Reinforcement';

  @override
  String get leszyAbilityWallCost => '-15 wood, -15 stone';

  @override
  String get leszyAbilityWallEffect =>
      '+2 to the Shadow explosion threshold (counters Shadow Thickening)';

  @override
  String get leszyAbilityDispelFuryName => 'Dispel Fury';

  @override
  String get leszyAbilityDispelFuryCost => '-15 water';

  @override
  String get leszyAbilityDispelFuryEffect =>
      'immediately cancels active Fury before it can double the next blow (available only while Fury is active)';

  @override
  String get leszyAbilityAbundanceName => 'Abundance';

  @override
  String get leszyAbilityAbundanceCost => '-20 water, -20 stone';

  @override
  String get leszyAbilityAbundanceEffect =>
      'doubles the next 3 harvested resource paths (including Sword and Shield, excluding Shadow)';

  @override
  String leszyMoveStrikeFuryDesc(int base, int doubled) {
    return 'Prepares an empowered strike on the village (2×$base = -$doubled HP).';
  }

  @override
  String leszyMoveStrikeDesc(int base) {
    return 'Prepares to strike the village (-$base HP).';
  }

  @override
  String get leszyMoveDrainDesc =>
      'Wants to drain the richest resource stockpile and heal with it (for half the amount taken).';

  @override
  String leszyMoveShadowDesc(int threshold) {
    return 'Thickens the shadow - permanently lowers the explosion threshold by 1 (currently $threshold).';
  }

  @override
  String get leszyMoveFuryDesc =>
      'Flies into a fury - the next blow will be doubled, and he himself more powerful (+1 strength).';

  @override
  String get leszyMoveFogDesc =>
      'Sends fog - shuffles the board and turns some tiles into Shadow.';

  @override
  String get leszyMovePoisonDesc =>
      'Poisons the air - your next moves will hurt (-5 HP), curable with Healing.';

  @override
  String get leszyMoveHungerDesc => 'Hunger will devour part of your supplies.';

  @override
  String get leszyMoveConsumeDesc =>
      'Wants to devour the Shadow around him and heal for however much he consumes.';

  @override
  String leszyMoveRendDesc(int base) {
    return 'Prepares a rending strike that pierces half the Shield (-$base HP, partially even with a shield).';
  }

  @override
  String get leszyMoveDespairDesc =>
      'Despair grips him - he is about to sharply boost his strength (+2).';

  @override
  String get leszyMoveBlightDesc =>
      'Blights part of the board, turning tiles directly into Shadow.';

  @override
  String get leszyMoveOtherworldDesc =>
      'Partially withdraws into the otherworld - the next Sword hits will deal only half damage.';

  @override
  String get leszyMoveCrumblingResolveDesc =>
      'Breaks the village\'s resolve - its maximum HP will permanently shrink.';

  @override
  String get leszyShadowExplosionWarning =>
      'The Shadow reaches its threshold - it\'s about to explode!';

  @override
  String leszyShadowExplosionResult(int damage) {
    return 'The Shadow explodes! (-$damage Village HP)';
  }

  @override
  String leszyActionStrike(int dmg) {
    return 'Leszy strikes! (-$dmg Village HP)';
  }

  @override
  String leszyActionDrainSuccess(String resource, int healed) {
    return 'Leszy drains $resource and heals for $healed!';
  }

  @override
  String get leszyActionDrainFail =>
      'Leszy tries to drain a resource, but there is nothing to take.';

  @override
  String leszyActionShadowThicken(int threshold) {
    return 'The Shadow thickens - the explosion threshold drops to $threshold!';
  }

  @override
  String get leszyActionFury =>
      'Leszy flies into a fury - the next blow will be stronger, and he himself more powerful!';

  @override
  String get leszyActionFog =>
      'Fog blankets the board - tiles shuffle, some turn into Shadow!';

  @override
  String get leszyActionPoison =>
      'Leszy poisons the air - your next moves will hurt more.';

  @override
  String get leszyActionHunger =>
      'Leszy\'s hunger devours part of your supplies.';

  @override
  String leszyActionConsumeSuccess(int amount) {
    return 'Leszy devours the Shadow around him and heals for $amount!';
  }

  @override
  String get leszyActionConsumeFail =>
      'Leszy reaches for the Shadow, but there is nothing to devour.';

  @override
  String leszyActionRendPierce(int dmg) {
    return 'Leszy tears into the village, piercing half the Shield! (-$dmg Village HP)';
  }

  @override
  String leszyActionRendClaws(int dmg) {
    return 'Leszy tears into the village with his claws! (-$dmg Village HP)';
  }

  @override
  String get leszyActionDespair =>
      'Despair grips Leszy - his strength surges (+2)!';

  @override
  String get leszyActionBlight =>
      'Blight spreads across the board - some tiles turn into Shadow!';

  @override
  String get leszyActionOtherworld =>
      'Leszy partially withdraws into the otherworld - the next Sword hits will be weakened.';

  @override
  String leszyActionCrumblingResolve(int maxHp) {
    return 'The village\'s resolve crumbles under the weight of dread - max Village HP drops to $maxHp!';
  }

  @override
  String leszyAppBarTitle(int week) {
    return 'Clash with Leszy - Week $week';
  }

  @override
  String leszyMovesUsedLabel(int count) {
    return 'Moves: $count';
  }

  @override
  String get leszyPhaseOnslaughtTitle => 'Onslaught';

  @override
  String get leszyPhaseHeartOfShadowTitle => 'Heart of Shadow';

  @override
  String get leszyOnslaughtIntroText =>
      'Leszy strikes the village at full strength. Gather Swords to wound him, and Shields to survive - then spend the wood/stone/water you collect on abilities.';

  @override
  String get leszyHeartOfShadowIntroText =>
      'The first wave has broken, but from the shadows emerges his true, hungrier form - stronger from the very first move, and able to devour the Shadow itself to heal. This is the final trial - your Village HP has not recovered between clashes.';

  @override
  String leszyIntroHpSummary(
    int villageHp,
    int villageMaxHp,
    int leszyHp,
    int leszyMaxHp,
  ) {
    return 'Village HP: $villageHp/$villageMaxHp - Leszy HP: $leszyHp/$leszyMaxHp';
  }

  @override
  String get leszyStartButton => 'Begin';

  @override
  String get leszyBoardLegendSwordLabel => 'Sword';

  @override
  String get leszyBoardLegendSwordDesc => '1 tile = 1 damage to Leszy';

  @override
  String get leszyBoardLegendShieldLabel => 'Shield';

  @override
  String get leszyBoardLegendShieldDesc => '1 tile = 1 point of Village shield';

  @override
  String get leszyBoardLegendShadowLabel => 'Shadow';

  @override
  String leszyBoardLegendShadowDesc(int threshold) {
    return 'Collecting it removes it from the board and also lowers the Shadow pool by 5 per tile - a full pool ($threshold, which drops over time from Shadow Thickening) explodes, dealing Village HP damage equal to whatever the pool holds at that moment.';
  }

  @override
  String get leszyBoardLegendTitle => 'New resources on the board';

  @override
  String get leszyBoardLegendResourceNote =>
      'Wood, stone, and water still work as before - they accumulate into supplies you can spend on abilities below.';

  @override
  String get leszyAbilitiesTitle => 'Abilities';

  @override
  String get leszyStatusFuryName => 'Fury';

  @override
  String get leszyStatusFuryDesc =>
      'Fury active - Leszy\'s next blow will be doubled.';

  @override
  String get leszyStatusPoisonName => 'Poison';

  @override
  String leszyStatusPoisonDesc(int ticks) {
    return 'Poison - your next $ticks move(s) hurt extra (-5 Village HP). This can be cured with Healing.';
  }

  @override
  String get leszyStatusPrayerName => 'Prayer';

  @override
  String get leszyStatusPrayerDesc =>
      'Prayer active - Leszy\'s next blow is halved.';

  @override
  String get leszyStatusAbundanceName => 'Abundance';

  @override
  String leszyStatusAbundanceDesc(int charges) {
    return 'Abundance active - the next $charges harvested paths (Sword, Shield, wood/stone/water) count double. Does not apply to Shadow.';
  }

  @override
  String get leszyStatusOtherworldName => 'Otherworld';

  @override
  String leszyStatusOtherworldDesc(int charges) {
    return 'Leszy is partially withdrawn into the otherworld - the next $charges Sword hits will deal only half damage.';
  }

  @override
  String get leszyCloseButton => 'Close';

  @override
  String get leszyBossName => 'Leszy';

  @override
  String get leszyVillageLabel => 'Village';

  @override
  String leszyHpBarLabel(String label, int current, int max) {
    return '$label: $current/$max HP';
  }

  @override
  String get leszyMovesUnitOne => 'move';

  @override
  String get leszyMovesUnitFew => 'moves';

  @override
  String get leszyMovesUnitMany => 'moves';

  @override
  String leszyMovesUntilLabel(int count, String unit) {
    return 'In $count $unit:';
  }

  @override
  String leszyShadowCounterLabel(int current, int threshold) {
    return 'Shadow $current/$threshold';
  }

  @override
  String leszyAbilityCostLabel(String cost) {
    return 'Cost: $cost';
  }

  @override
  String leszyAbilityEffectLabel(String effect) {
    return 'Effect: $effect';
  }

  @override
  String get leszyNotEnoughResources =>
      'Not enough resources to use this ability right now.';

  @override
  String get leszyCancelButton => 'Cancel';

  @override
  String get leszyUseButton => 'Use';

  @override
  String get leszyDefeatTitle => '💀 Defeat';

  @override
  String get leszyDefeatMessage =>
      'Leszy proved too strong. The village could not withstand the Shadow\'s onslaught.';

  @override
  String get leszyRetryButton => 'Try Again';

  @override
  String get leszyReturnPrepareButton =>
      'Return to the village, prepare better';

  @override
  String get leszyVictoryTitle => '🎉 Leszy Defeated';

  @override
  String get leszyVictoryMessage =>
      'The Shadow retreats deep into the earth. The village has survived its worst night.';

  @override
  String leszyVictoryHpSummary(int hp, int maxHp) {
    return 'Final Village HP: $hp/$maxHp';
  }

  @override
  String get leszyReturnToVillageButton => 'Return to the village';

  @override
  String get homeBuildingNameRatusz => 'Town Hall';

  @override
  String get homeSourceSoldiers => 'Soldiers';

  @override
  String get homeSourceResidents => 'Residents';

  @override
  String get homeBonusSklep =>
      'Unlocks the \"Shop\" tab in the bottom navigation bar.';

  @override
  String homeBonusPopulation(int n) {
    return 'Increases the population limit by $n (visible in Statistics).';
  }

  @override
  String homeBonusKuznia(int n) {
    return 'Every week: +$n gold.';
  }

  @override
  String homeBonusSpichlerz(int n, String pct) {
    return 'Every week: +$n to apple production. Reduces the risk of famine (losing the harvest) by $pct.';
  }

  @override
  String homeBonusPiekarnia(int n) {
    return 'Every week: +$n to grain production.';
  }

  @override
  String homeBonusTartak(int n) {
    return 'Every week: +$n to wood production.';
  }

  @override
  String homeBonusStudnia(int n, String pct) {
    return 'Every week: +$n to water production. Reduces the risk of fire (burning the harvest) by $pct.';
  }

  @override
  String homeBonusMorale(int n) {
    return 'Increases village morale by $n (visible in Statistics).';
  }

  @override
  String homeBonusKaplica(String pct, int n) {
    return 'Reduces the overall chance of seasonal resource spoilage by $pct. Increases village morale by $n.';
  }

  @override
  String get homeBonusSzkola =>
      'Unlocks discoveries at the Academy (panel below) - including +1 to the base number of moves and the ability to assign workers to buildings.';

  @override
  String homeBonusRynek(int base, int receive, int best) {
    return 'Unlocks resource trading in the Resources tab (rate $base→$receive, improves with upgrades, the Diplomacy discovery, and workers - the best possible is $best→$receive).';
  }

  @override
  String homeBonusMagazyn(int n) {
    return 'Increases the maximum amount of each stored resource by $n.';
  }

  @override
  String homeBonusKamieniarz(int n) {
    return 'Every week: +$n to stone production.';
  }

  @override
  String homeBonusKoszary(int n, int food) {
    return 'Increases village security by $n. Unlocks soldier recruitment (requires a built Forge) - panel below. Each soldier consumes $food apple/week - if apples run out, some will desert.';
  }

  @override
  String homeUpgradeRatusz(int n) {
    return 'Doubles the weekly bonus to +$n of each resource.';
  }

  @override
  String homeUpgradePalisade(int a, int a2, int b, int b2) {
    return 'Increases the population limit by another $a (+$a2 total) and village security by another $b (+$b2 total).';
  }

  @override
  String homeUpgradeSklep(int n) {
    return 'Increases the maximum number of moves purchasable in the shop by $n (independent of the bonus from assigned workers).';
  }

  @override
  String homeUpgradePopulation(int n, int n2) {
    return 'Increases the population limit by another $n (+$n2 total).';
  }

  @override
  String homeUpgradeKuznia(int n, int n2) {
    return 'Increases the weekly bonus by another $n gold (+$n2/week total).';
  }

  @override
  String homeUpgradeSpichlerz(String pct, String pct2) {
    return 'Further reduces the risk of famine by another $pct (-$pct2 total). Apple production unchanged.';
  }

  @override
  String homeUpgradePiekarnia(int n, int n2) {
    return 'Increases grain production by another $n (+$n2/week total).';
  }

  @override
  String homeUpgradeTartak(int n, int n2) {
    return 'Increases wood production by another $n (+$n2/week total).';
  }

  @override
  String homeUpgradeStudnia(String pct, String pct2) {
    return 'Further reduces the risk of fire by another $pct (-$pct2 total). Water production unchanged.';
  }

  @override
  String homeUpgradeBrowar(int n, int n2) {
    return 'Increases village morale by another $n (+$n2 total).';
  }

  @override
  String homeUpgradeKaplica(int n, int n2) {
    return 'Completely removes the overall spoilage chance (from this building) and increases village morale by another $n (+$n2 total).';
  }

  @override
  String get homeUpgradeSzkola =>
      'Unlocks advanced discoveries - including another +1 to the base number of moves (+2 total) and a limit of 2 workers per building.';

  @override
  String homeUpgradeRynek(int after, int receive, int best) {
    return 'Improves the exchange rate to $after→$receive (one of 3 independent upgrades toward the best possible rate of $best→$receive).';
  }

  @override
  String homeUpgradeMagazyn(int n, int n2) {
    return 'Increases the storage limit by another $n (+$n2 total).';
  }

  @override
  String homeUpgradeKamieniarz(int n, int n2) {
    return 'Increases stone production by another $n (+$n2/week total).';
  }

  @override
  String homeUpgradeKoszary(int n, int n2) {
    return 'Increases village security by another $n (+$n2 total) and doubles the strength of every soldier.';
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
    return '$label: base $base$unit, workers $sign$workerBonus$unit → total bonus $total$unit';
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
    return '$label: base $basePct, with workers → total bonus $totalPct';
  }

  @override
  String get homeLabelResourceProduction => 'Production of each resource';

  @override
  String get homeLabelPopulationLimit => 'Population limit';

  @override
  String get homeLabelSecurity => 'Security';

  @override
  String get homeSklepLockedBonusNote =>
      'Unlocks the Shop tab (numeric bonus only after upgrading).';

  @override
  String homeSklepMovesBonusText(int max, int workers) {
    return 'Max. number of purchasable moves: $max (including +$workers from workers).';
  }

  @override
  String get homeLabelGoldPerWeek => 'Gold/week';

  @override
  String get homeLabelAppleProductionPerWeek => 'Apple production/week';

  @override
  String get homeLabelHungerRiskReduction => 'Famine risk reduction';

  @override
  String get homeLabelGrainProductionPerWeek => 'Grain production/week';

  @override
  String get homeLabelWoodProductionPerWeek => 'Wood production/week';

  @override
  String get homeLabelWaterProductionPerWeek => 'Water production/week';

  @override
  String get homeLabelFireRiskReduction => 'Fire risk reduction';

  @override
  String get homeLabelVillageMorale => 'Village morale';

  @override
  String get homeLabelSpoilRiskReduction => 'Overall spoilage risk reduction';

  @override
  String homeMarketRateBonus(int give, int receive, int best) {
    return 'Exchange rate: $give→$receive (best possible: $best→$receive = 2:1)';
  }

  @override
  String get homeLabelWarehouseLimit => 'Warehouse limit';

  @override
  String get homeLabelStoneProductionPerWeek => 'Stone production/week';

  @override
  String get homeResourcesNotUnlockedMessage =>
      'First discover all resources in the Surroundings (build the Orchard, Meadow, and Field).';

  @override
  String get homeTabVillage => 'Village';

  @override
  String get homeTabSurroundings => 'Surroundings';

  @override
  String get homeTabResources => 'Resources';

  @override
  String get homeTabShop => 'Shop';

  @override
  String get homeTabStats => 'Statistics';

  @override
  String get homeTabGoals => 'Goals';

  @override
  String get homeTabDebug => 'Debug';

  @override
  String get homeTutorialVillageDesc =>
      'Tap an empty plot to build a building, or an existing building to upgrade it or see details. The Town Hall is built first and unlocks the rest.';

  @override
  String get homeTutorialSurroundingsDesc =>
      'The land around the village (river, forest, mountains...) - developing it enlarges the harvest board and gives resource bonuses.';

  @override
  String get homeTutorialResourcesDesc =>
      'A view of stockpiles, weekly production and consumption of each resource, and from here also trading at the market once the Market is ready.';

  @override
  String get homeTutorialShopDesc =>
      'Buy extra moves on the harvest board and automatic-matching upgrades (unlocks during the game).';

  @override
  String get homeTutorialStatsDesc =>
      'Records, population, morale, security, army, and story comics, plus the harvest board\'s appearance settings.';

  @override
  String get homeTutorialGoalsDesc =>
      'The current story act\'s goals and side quests - complete them to earn experience.';

  @override
  String get homeTutorialArrowTitle => 'The \"→\" button';

  @override
  String get homeTutorialArrowDesc =>
      'Ends the week and moves on to the harvest board (or a boss battle, if one falls this week).';

  @override
  String get homeVillageTutorialTitle => 'Welcome to the village';

  @override
  String get homeVillageTutorialGotIt => 'Got it';

  @override
  String get homeConfirmDemolishTitle => 'Demolish the building?';

  @override
  String homeConfirmDemolishMessage(String name) {
    return 'Are you sure you want to demolish: $name?\nYou\'ll recover half of the invested resources.';
  }

  @override
  String get homeCancel => 'Cancel';

  @override
  String get homeDemolish => 'Demolish';

  @override
  String homeRatuszBonusText(int n) {
    return 'Every week: +$n of each resource.\nGold collected in a chain gives an extra +1 (e.g. 4 in a chain = 5).\nRequires unlocking all resources in the Surroundings. Must be built as the village\'s first building - it unlocks building the rest, and upgrading it (level 2) unlocks upgrading them.';
  }

  @override
  String get homeRatuszUpgradedSnack => 'Town Hall upgraded!';

  @override
  String get homeBuildingNamePalisade => 'Palisade';

  @override
  String homePalisadeBonusText(int pop, int sec) {
    return 'Increases the population limit by $pop and village security by $sec (visible in Statistics).';
  }

  @override
  String get homePalisadeUpgradedSnack => 'Palisade upgraded!';

  @override
  String get homePalisadeDemolishedSnack =>
      'Palisade demolished - half the resources recovered.';

  @override
  String get homeMilitaryTitle => 'Military';

  @override
  String homeMilitaryTotalStrength(int n) {
    return 'Total army strength: $n';
  }

  @override
  String homeMilitaryAvailableResidents(int n) {
    return 'Available residents: $n (each recruitment takes one from the village).';
  }

  @override
  String get homeMilitaryRequiresForge =>
      'Recruitment requires a built Forge (weapons for soldiers).';

  @override
  String get homeMilitaryNotEnoughResidents =>
      'Not enough residents to recruit another soldier.';

  @override
  String homeMilitaryUnitLine(String label, int count, int strength) {
    return '$label: $count (strength each: $strength)';
  }

  @override
  String homeMilitaryRecruitButton(int pop, int gold, String extra) {
    return 'Recruit (-$pop resident, -$gold gold$extra)';
  }

  @override
  String get homeDiscoveriesTitle => 'Discoveries';

  @override
  String get homeDiscoveryUnlocked => 'Discovered';

  @override
  String homeDiscoveryRequiresLevel(int n) {
    return 'Requires the Academy at level $n.';
  }

  @override
  String homeDiscoveryUnlockButton(String cost) {
    return 'Discover ($cost)';
  }

  @override
  String homeBuildingUpgradedSnack(String label) {
    return '$label upgraded!';
  }

  @override
  String homeBuildingDemolishedSnack(String label) {
    return '$label: building demolished - half the resources recovered.';
  }

  @override
  String get homeBuildingNameDom => 'House';

  @override
  String get homeLevel0 => 'Level 0';

  @override
  String get homeRebuildToLevel1 => 'Rebuild to level 1';

  @override
  String get homeDecrepitHouseNotDemolishable =>
      'An abandoned house can\'t be demolished - people still live inside.';

  @override
  String get homeDecrepitHouseBonusText =>
      'The house has stood abandoned and neglected for years - it currently gives no population bonus.';

  @override
  String homeDecrepitHouseUpgradeText(int n) {
    return 'Rebuild the house so it starts giving +$n to the population limit.';
  }

  @override
  String get homeHouseRebuiltSnack =>
      'House rebuilt - it gives a population bonus again!';

  @override
  String get homeHouseDemolishedSnack =>
      'House demolished - half the resources recovered.';

  @override
  String get homeMarketTradeTitle => 'Market - Trade';

  @override
  String homeMarketRateLine(int give, int receive) {
    return 'Rate: $give of a resource for $receive of another.';
  }

  @override
  String homeMarketGiveOption(String label, int have) {
    return 'Give: $label (you have $have)';
  }

  @override
  String homeMarketReceiveOption(String label) {
    return 'Receive: $label';
  }

  @override
  String get homeMax => 'Max.';

  @override
  String homeMarketSummaryLine(
    int totalGive,
    String giveLabel,
    int totalReceive,
    String receiveLabel,
  ) {
    return 'Total: you give $totalGive $giveLabel, you get $totalReceive $receiveLabel.';
  }

  @override
  String homeMarketNotEnough(String label) {
    return 'Not enough $label to trade even once.';
  }

  @override
  String get homeClose => 'Close';

  @override
  String homeMarketTradeSnack(
    int totalGive,
    String giveLabel,
    int totalReceive,
    String receiveLabel,
  ) {
    return 'Traded $totalGive $giveLabel for $totalReceive $receiveLabel.';
  }

  @override
  String get homeExchangeButton => 'Trade';

  @override
  String homeMoveBoughtSnack(int total) {
    return 'Bought +1 move per week! Now: $total moves.';
  }

  @override
  String get homeAutoMatchTier1Snack =>
      'Automatic clearing of four-tile matches unlocked!';

  @override
  String get homeAutoMatchTier2Snack =>
      'Automatic clearing of three-tile matches unlocked!';

  @override
  String homeAreaBuildFirst(String label) {
    return 'First build: $label.';
  }

  @override
  String homeAreaBonusStarter(String label) {
    return '$label is already available on the harvest board - this building additionally gives +1 to every collected chain of this resource.';
  }

  @override
  String homeAreaBonusUnlock(String label) {
    return 'Unlocks $label as a new resource to collect on the harvest board.';
  }

  @override
  String homeAreaUpgradeText(String label) {
    return 'Unlocks the ability to choose $label as the \"resource of the week\" (10-20% more on the harvest board in the chosen week).';
  }

  @override
  String homeAreaUpgradedSnack(String label, String resource) {
    return '$label upgraded! You can now choose $resource as the resource of the week.';
  }

  @override
  String homeTitleUpgradedSuffix(String title) {
    return '$title (upgraded)';
  }

  @override
  String homeTitleBuiltSuffix(String title) {
    return '$title (built)';
  }

  @override
  String get homeAreaBuildCostTitle => 'Build cost (level 1)';

  @override
  String get homeEffectLabel => 'Effect';

  @override
  String get homeLevel1 => 'Level 1';

  @override
  String get homeUpgradeToLevel2 => 'Upgrade to level 2';

  @override
  String get homeLevel2 => 'Level 2';

  @override
  String get homeDemolishRefundNote =>
      'Demolishing will refund half of all invested resources.';

  @override
  String get homeBuild => 'Build';

  @override
  String get homeUpgrade => 'Upgrade';

  @override
  String get homeMainBuildingNotDemolishable =>
      'The village\'s main building can\'t be demolished.';

  @override
  String get homeLocked => 'Locked';

  @override
  String get homeBuildRatuszFirst =>
      'First build the Town Hall (the village\'s main building).';

  @override
  String get homeBuildCostTitle => 'Build cost';

  @override
  String get homePerksLabel => 'Perks';

  @override
  String get homeDemolishRefund50Title => 'Refund on demolish (50%)';

  @override
  String get homeRequiresUpgradedRatusz =>
      'Requires an upgraded (level 2) Town Hall.';

  @override
  String get homeGeneralBonusTitle => 'Overall bonus';

  @override
  String get homeWorkersTitle => 'Workers';

  @override
  String get homeWorkersRequiresDiscovery =>
      'Requires the \"Worker Management\" discovery at the Academy.';

  @override
  String homeWorkerBonusExplanation(int max, String multiplier) {
    return 'Each assigned resident increases the building\'s bonus by +50% (max $max = $multiplier bonus).';
  }

  @override
  String get homeWorkerMultiplierDouble => 'double';

  @override
  String homeAvailableResidents(int n) {
    return 'Free residents: $n';
  }

  @override
  String get homeWeeklyBoostTitle => 'Resource of the week';

  @override
  String get homeWeeklyBoostDescription =>
      'Thanks to the village\'s upgraded (level 2) surroundings, you can choose a resource that will appear more often this week (+10-20%).';

  @override
  String get homeSkipButton => 'Skip';

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
  String get homeEventUnitSecurity => 'security';

  @override
  String get homeEventUnitPopulation => 'population';

  @override
  String get homeEventUnitSoldiers => 'soldiers';

  @override
  String get homeEventLossesSuffix => '(losses)';

  @override
  String get homeGoalNotFoughtYet => 'not fought yet';

  @override
  String homeGoalBattleProgress(int cleared, int required) {
    return '$cleared/3 stages (min. $required)';
  }

  @override
  String get homeGoalRatuszBuilt => 'Town Hall built';

  @override
  String get homeGoalOrchardDeveloped => 'Orchard developed';

  @override
  String get homeGoalMeadowDeveloped => 'Meadow developed';

  @override
  String get homeGoalFieldDeveloped => 'Field developed';

  @override
  String get homeGoalBattleGrot => 'Battle with Grot';

  @override
  String get homeGoalBattleMarta => 'Battle with Marta';

  @override
  String get homeGoalBogdanProof => 'Full Evidence gathered from Bogdan';

  @override
  String get homeGoalArmyStrength => 'Army strength';

  @override
  String get homeGoalVillageSecurity => 'Village security';

  @override
  String get homeGoalLeszyDefeated => 'Leszy defeated';

  @override
  String get homeGoalQuestSladyWPopiele => 'Quest \"Traces in the Ashes\"';

  @override
  String get homeGoalQuestRozmowaZJadwiga =>
      'Quest \"A Conversation with Jadwiga\"';

  @override
  String homeSideQuestMoraleProgress(int n) {
    return '$n/70 morale';
  }

  @override
  String homeSideQuestArmyStrengthProgress(int n) {
    return '$n/20 army strength';
  }

  @override
  String get homeBuilt => 'built';

  @override
  String get homeNotBuilt => 'not built';

  @override
  String homeSideQuestGrotKarczmaProgress(int stages, String karczma) {
    return 'Grot: $stages/3 stages (min. 2) • Tavern: $karczma';
  }

  @override
  String get homeGrotVictoryFullSnack =>
      'Grot defeated without losses! Loot: +15 gold, +15 wood.';

  @override
  String get homeGrotVictoryPartialSnack =>
      'Grot repelled, but the battle cost the village: -10% wood and gold.';

  @override
  String homeGrotDefeatSnack(int cleared) {
    return 'Grot broke through the village\'s defenses - only $cleared/3 battle stages were completed.';
  }

  @override
  String get homeMartaVictoryFullTrustSnack =>
      'Marta fully trusted you, giving herself time to talk: +15 morale.';

  @override
  String get homeMartaVictoryTrustSnack =>
      'Marta won over - she becomes an ally: +10 morale.';

  @override
  String get homeMartaVictoryPartialSnack =>
      'Marta partially trusted you, but she\'s still hiding something.';

  @override
  String homeMartaDefeatSnack(int cleared) {
    return 'Marta withdrew without revealing anything more - only $cleared/3 battle stages were completed.';
  }

  @override
  String get homeBogdanVictoryFullSnack =>
      'Bogdan breaks completely under the weight of the evidence and flees without revenge.';

  @override
  String homeBogdanVictoryPartialSnack(int burns) {
    return 'Bogdan flees, but managed to set fire to part of the warehouse ($burns time(s)) along the way.';
  }

  @override
  String homeBogdanDefeatSnack(int burns) {
    return 'Bogdan couldn\'t be broken - the warehouse suffered $burns time(s), and he\'s still convinced he\'s right.';
  }

  @override
  String homeDebugGrotResultSnack(int cleared) {
    return 'Debug: battle with Grot finished - $cleared/3 stages (no effect on the save).';
  }

  @override
  String homeDebugMartaResultSnack(int cleared, String suffix) {
    return 'Debug: battle with Marta finished - $cleared/3 stages$suffix (no effect on the save).';
  }

  @override
  String get homeDebugMartaFullTrustSuffix => ' (full trust)';

  @override
  String homeDebugBogdanResultSnack(String proof, int burns) {
    return 'Debug: battle with Bogdan finished - Evidence $proof, $burns burn(s) (no effect on the save).';
  }

  @override
  String get homeDebugProofGathered => 'gathered';

  @override
  String get homeDebugProofIncomplete => 'incomplete';

  @override
  String homeDebugLeszyResultSnack(String result) {
    return 'Debug: battle with Leszy finished - $result (no effect on the save).';
  }

  @override
  String get homeDebugVictory => 'victory';

  @override
  String get homeDebugDefeat => 'defeat';

  @override
  String get homeActFailure0 =>
      'The village didn\'t manage to prepare in time - Antoni\'s legacy was squandered.';

  @override
  String get homeActFailure1 =>
      'Grot broke through the unprepared village\'s defenses.';

  @override
  String get homeActFailure2 =>
      'Marta didn\'t reveal the crucial truth, and the village lost hope.';

  @override
  String get homeActFailure3 =>
      'Weakened by hunger and poor defenses, the village didn\'t survive the confrontation with Bogdan.';

  @override
  String get homeActFailure4 =>
      'The village didn\'t manage to prepare - the army too weak, the walls too fragile for what\'s coming from the forest.';

  @override
  String get homeActFailure5 =>
      'Leszy was defeated, but some threads remain unresolved - the story ends without a full answer.';

  @override
  String get homeActFailureDefault => 'This act\'s goal was not achieved.';

  @override
  String get homeBossIntroGrotMessage =>
      'Grot and his men are approaching the village. Time to prepare the defense.';

  @override
  String get homeBossIntroMartaMessage =>
      'Marta stands before you, armed, sent by her father. There is no turning back.';

  @override
  String get homeBossIntroBogdanMessage =>
      'Bogdan Kruk arrives in person, demanding the truth. Confrontation is inevitable.';

  @override
  String get homeBossIntroLeszyMessage =>
      'The dark shadow of the forest fully awakens. The final battle for the village\'s fate begins now.';

  @override
  String get homeLeszyVictorySnack =>
      'Leszy defeated! The Shadow retreats deep into the earth.';

  @override
  String homeActGoalReachedSnack(int actNumber, String actName, int xp) {
    return 'Act $actNumber (\"$actName\") goal achieved! (+$xp XP)';
  }

  @override
  String homeSideQuestCompletedSnack(String title, int xp) {
    return 'Side quest completed: \"$title\" (+$xp XP)';
  }

  @override
  String homeDebugJumpedToWeekSnack(int week) {
    return 'Debug: jumped to week $week.';
  }

  @override
  String get homeExitGameTitle => 'Exit the game?';

  @override
  String get homeExitGameMessage => 'Are you sure you want to close Farmer?';

  @override
  String get homeExit => 'Exit';
}
