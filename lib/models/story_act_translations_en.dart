/// Angielskie tłumaczenia treści `kStoryActs` (patrz `story_act.dart`),
/// kluczowane przez `StoryAct.actNumber`. `milestones` musi mieć dokładnie
/// tyle elementów co `StoryAct.milestones`, w tej samej kolejności - patrz
/// `StoryActLocalization.localizedMilestone` w `story_act.dart`, które łączy
/// je po indeksie. Brakujący wpis = ekran bezpiecznie spada na polski
/// oryginał.
class StoryMilestoneTranslation {
  final String goal;
  final String flavor;

  const StoryMilestoneTranslation(this.goal, this.flavor);
}

class StoryActTranslation {
  final String actName;
  final String context;
  final List<StoryMilestoneTranslation> milestones;

  const StoryActTranslation(this.actName, this.context, this.milestones);
}

const Map<int, StoryActTranslation> kStoryActsEn = {
  0: StoryActTranslation(
    'Before You Go',
    'Antoni, ailing but still full of warmth, hands you the reins of the village and '
        "teaches you the basics of farming. More and more often he lets slip unsettling, "
        "broken remarks about the past - and about someone whose name he refuses to speak. "
        "This time is inexorably heading toward his death.",
    [
      StoryMilestoneTranslation(
        "Learn to manage the farm and lay the foundations of the village",
        "Grandfather, weaker by the day, patiently teaches you how to run the village - "
            "how to recognize good soil, when to harvest, whom to trust. Every day spent "
            "with him is time you will never get back.",
      ),
      StoryMilestoneTranslation(
        "Give Antoni a fitting funeral",
        "Antoni passed in his sleep - peacefully, though too soon, his hand still warm. "
            "The village is drowning in grief, and he has earned a farewell worthy of half "
            "a century's labor.",
      ),
    ],
  ),
  1: StoryActTranslation(
    'The Warning',
    "Right after Antoni's death, Bogdan Kruk begins moving through intermediaries. "
        "Rumors, sabotage, and the first mentions of your grandfather's old partnership "
        "with a man whose name the village speaks only in fear.",
    [
      StoryMilestoneTranslation(
        "Strengthen the village's defenses",
        "Someone begins moving through intermediaries before ever showing a face - "
            "rumors, nighttime sabotage, a cold messenger on horseback. The warnings alone "
            "don't hurt yet, but the village must get on its feet before they turn into "
            "something worse.",
      ),
      StoryMilestoneTranslation(
        "Prepare for the confrontation with Grot",
        "Grot and his men demand tribute in the name of someone who, for now, prefers to "
            "stay in the shadows. Refusal means a clash at the village gates - better it "
            "finds you ready than caught off guard.",
      ),
    ],
  ),
  2: StoryActTranslation(
    'Blood of the Family',
    "Bogdan sends his own daughter to finish what Grot could not. But Marta, raised in "
        "the shadow of grief for her brother, begins to doubt her father's version of "
        "events as she draws closer to the truth herself.",
    [
      StoryMilestoneTranslation(
        "Gather the first clues about your grandfather's past",
        "Someone watches the village from behind the trees, vanishing before you can "
            "approach. Jadwiga knows more than she says - it's time to sit with her at the "
            "table and start asking the questions she has long refused to answer.",
      ),
      StoryMilestoneTranslation(
        "Prepare for the confrontation with Marta",
        "Bogdan sends his own daughter to finish what Grot could not. But Marta, raised "
            "in the shadow of grief for her brother, begins to doubt her father's version "
            "of events the closer she gets to the truth.",
      ),
    ],
  ),
  3: StoryActTranslation(
    'Face to Face',
    "Bogdan finally stands before you himself. The truth about the death of Jan, "
        "Bogdan's son, begins to surface - but it is still not the whole story.",
    [
      StoryMilestoneTranslation(
        "Secure winter supplies and strengthen your defenses",
        "Word of your grandfather's alleged crime spreads through the neighboring "
            "settlements like wildfire, twisted further with every retelling. Winter is "
            "coming, and with it a confrontation that can no longer be put off.",
      ),
      StoryMilestoneTranslation(
        "Prepare for the confrontation with Bogdan",
        "Bogdan finally stands before you himself, demanding truth or blood - he is done "
            "with intermediaries. High village security is the only thing that might calm "
            "him even a little before fury takes over.",
      ),
    ],
  ),
  4: StoryActTranslation(
    'The Hungry Shadow',
    "Bogdan, broken by grief, awakens the dark spirit of the forest once more, hoping to "
        "get his son back. The whole truth - about Jan's pact and Antoni's sacrifice - "
        "finally comes to light.",
    [
      StoryMilestoneTranslation(
        "Watch for troubling signs and arm your forces",
        "Spring returns to the village, but something is wrong - animals are fleeing the "
            "forest en masse, and the well frosts over despite the warm weather. Something "
            "is waking beyond the edge of the land, and time is running out.",
      ),
      StoryMilestoneTranslation(
        "Prepare for the confrontation with Leszy",
        "Bogdan, broken by grief, completed the ritual, hoping to get his son back. "
            "Instead he woke something far older and far hungrier - the debt Antoni "
            "carried in silence for twenty years has now fallen entirely on you.",
      ),
    ],
  ),
  5: StoryActTranslation(
    'The Return of Spring',
    "There has been no sign of life from Bogdan, missing since the day Leszy awoke. "
        "This is a time for searching and for answers - before Leszy strikes, and the "
        "matter that has weighed on two families for twenty years is closed once and "
        "for all.",
    [
      StoryMilestoneTranslation(
        "Begin the search for Bogdan",
        "Since the day Leszy awoke, there has been no sign of life from Bogdan, and the "
            "village still waits for a blow that has yet to fall. Before the darkness "
            "descends, he must be found: visit the site of the ritual, and speak with "
            "Marta and Jadwiga.",
      ),
      StoryMilestoneTranslation(
        "Prepare for the confrontation with Leszy",
        "Bogdan is found, the truth finally known - but this is not the end. Leszy still "
            "waits in the forest, stronger than ever, and this time the final "
            "confrontation can no longer be delayed.",
      ),
    ],
  ),
};
