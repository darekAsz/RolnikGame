import 'comic.dart';

/// Angielskie tłumaczenia treści `kComics` (patrz `comic.dart`), kluczowane
/// przez `Comic.number` - identyczna struktura paneli/dialogów co oryginał.
/// Imiona postaci (pole `speaker` w `ComicLine`) NIE są tłumaczone, tylko
/// treść kwestii i opisy kadrów. Brakujący wpis = ekran bezpiecznie spada na
/// polski oryginał (patrz `ComicLocalization` w `comic.dart`).
class ComicTranslation {
  final String title;
  final List<ComicPanel> panels;

  const ComicTranslation(this.title, this.panels);
}

const Map<int, ComicTranslation> kComicsEn = {
  1: ComicTranslation('A New Day', [
    ComicPanel('A cart rolls into a modest but lively village at dawn.'),
    ComicPanel(
      'Old Antoni waits on the cottage porch, smiling but clearly frail.',
      [ComicLine('Antoni', "Finally. I was starting to worry you wouldn't show up.")],
    ),
    ComicPanel(
      'Inside the cottage — Antoni hands over the keys and the farm ledgers.',
      [ComicLine('Antoni', "My legs aren't what they used to be. Time you ran things around here.")],
    ),
    ComicPanel('Kazimierz studies a neglected map of the village spread out before him.'),
    ComicPanel(
      'Antoni leads Kazimierz to the window, pointing at the village below - a few empty, burned-out plots still visible among the buildings.',
      [
        ComicLine(
          'Antoni',
          "(heavily) There used to be more of it. Someone set a fire before we could defend ourselves - most of the village burned down. We've been rebuilding ever since, bit by bit.",
        ),
      ],
    ),
    ComicPanel('"Learning begins with the first spade of earth."'),
  ]),
  2: ComicTranslation('The First Bricks', [
    ComicPanel('Kazimierz pores over building plans at the table.'),
    ComicPanel(
      'Workers lay the foundations for the Town Hall, dust rising in the air.',
      [
        ComicLine('Worker', 'Where do we put the support beam, boss?'),
        ComicLine('Kazimierz', 'Here. And make it straight - grandfather will see it.'),
      ],
    ),
    ComicPanel(
      'Antoni on the porch, teacup in hand, watches with a smile.',
      [ComicLine('Antoni', "Crooked as my first fence. But it's standing!")],
    ),
    ComicPanel('The Town Hall rises at a remarkable pace.'),
    ComicPanel(
      'The Town Hall is nearly finished. Kazimierz wipes the sweat from his brow; Antoni claps from the porch.',
      [ComicLine('Antoni', "Would you look at that. Maybe resting could've waited after all.")],
    ),
    ComicPanel(
      'Evening, by the campfire.',
      [
        ComicLine(
          'Antoni',
          "Your great-grandfather raised the first cottage with his bare hands. You already have me - and these hands. "
              "That's a good start.",
        ),
      ],
    ),
  ]),
  3: ComicTranslation("The Raven's Shadow", [
    ComicPanel('A quiet morning in the yard - Antoni feeds the chickens, Kazimierz carries water.'),
    ComicPanel(
      'A raven lands on the fence, staring straight at Antoni.',
      [ComicLine('Raven', '"Caw."')],
    ),
    ComicPanel(
      'Antoni freezes; the cup slips from his hand and shatters.',
      [ComicLine('Antoni', '(quietly) Not yet...')],
    ),
    ComicPanel(
      'Kazimierz runs over, worried.',
      [ComicLine('Kazimierz', 'Grandfather? Are you all right? What do you mean, "not yet"?')],
    ),
    ComicPanel(
      'Antoni turns away, his face in shadow, staring toward the distant forest, brushing off the question.',
      [ComicLine('Antoni', "No one. I'm an old man - my nerves play tricks on me.")],
    ),
    ComicPanel('The raven flies off toward the forest.'),
  ]),
  4: ComicTranslation('Antoni Departs', [
    ComicPanel('Antoni alone, coughing hard, leaning against the doorframe.'),
    ComicPanel(
      'Kazimierz rushes in, worried.',
      [ComicLine('Kazimierz', "Grandfather, sit down, I'll fetch some water.")],
    ),
    ComicPanel('Jadwiga, keeper of the chapel, arrives with herbs.'),
    ComicPanel(
      "Jadwiga kneels beside Antoni - this time her face betrays that she knows more than she's saying.",
      [ComicLine('Jadwiga', "This isn't a cold anymore, Antoni. You know that as well as I do.")],
    ),
    ComicPanel(
      'Antoni, very weak.',
      [ComicLine('Antoni', "I'll have all eternity to rest, Jadwiga. It just needs to wait a little longer.")],
    ),
    ComicPanel(
      "As Kazimierz steps out for water, Antoni grips Jadwiga's sleeve, his voice barely audible.",
      [ComicLine('Antoni', "(whispering) Look after the boy. When the time comes... and it's coming sooner than I thought.")],
    ),
    ComicPanel(
      "Jadwiga, eyes brimming with tears she won't let herself shed.",
      [ComicLine('Jadwiga', "Tell him the truth, Antoni. Before it's too late.")],
    ),
    ComicPanel(
      'Antoni, calm, resigned.',
      [ComicLine('Antoni', 'Let him have at least this one year without that weight.')],
    ),
    ComicPanel('Night falls over the cottage - Kazimierz drifts to sleep, worn out from keeping watch.'),
    ComicPanel(
      'Dawn. Kazimierz wakes to find that Antoni has passed in his sleep, peacefully, his hand still warm. '
          'Week 7. Antoni died in his sleep - peacefully, though far too soon.',
      [ComicLine('Kazimierz', '(whispering) Grandfather...?')],
    ),
  ]),
  5: ComicTranslation('The Funeral', [
    ComicPanel('The village has been in mourning for five weeks - the people silently finish the funeral preparations.'),
    ComicPanel(
      'The day of the funeral has come - the resources gathered over these weeks have finally gone toward a coffin, '
      'a headstone, and the modest farewell feast Antoni deserved.',
    ),
    ComicPanel(
      'A modest funeral at the cemetery.',
      [
        ComicLine(
          'Jadwiga',
          'Antoni built this village with his own two hands over half a century. '
              'He left it in good hands - and he left questions, too, ones he never answered himself.',
        ),
      ],
    ),
    ComicPanel(
      'Jadwiga approaches Kazimierz after the ceremony.',
      [ComicLine('Jadwiga', 'Your grandfather left more questions than answers, child.')],
    ),
    ComicPanel(
      'Kazimierz asks.',
      [
        ComicLine('Kazimierz', 'What questions?'),
        ComicLine('Jadwiga', "Ones you're not ready for yet."),
      ],
    ),
    ComicPanel('On a distant hill, a lone rider watches the ceremony.'),
    ComicPanel('The rider turns his horse and rides away. The year has only just begun.'),
  ]),
  6: ComicTranslation('The Visit', [
    ComicPanel('A cold, elegant messenger rides into the village on horseback.'),
    ComicPanel(
      'He stops before Kazimierz, without dismounting.',
      [ComicLine('Messenger', 'Lord Bogdan Kruk sends his condolences. And some advice.')],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', "I don't know that name.")]),
    ComicPanel(
      null,
      [
        ComicLine(
          'Messenger',
          "You will. The advice is this: let the new heir not continue his grandfather's bad traditions.",
        ),
      ],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', 'What traditions?')]),
    ComicPanel(null, [ComicLine('Messenger', 'Grandfather never mentioned it? How curious.')]),
    ComicPanel(
      'The messenger turns his horse and rides out of the village.',
      [ComicLine('Messenger', 'Let this be the last courteous warning.')],
    ),
  ]),
  7: ComicTranslation('In the Dark', [
    ComicPanel('Night, silence over the village - something moves near the storehouse.'),
    ComicPanel('In the morning Kazimierz discovers the damage: scattered supplies, a broken fence.'),
    ComicPanel(
      'Worried villagers murmur among themselves.',
      [ComicLine('Villager', "Someone really doesn't want us getting back on our feet.")],
    ),
    ComicPanel(
      'An old man lowers his voice.',
      [ComicLine('Old Man', 'Just like the old days... back when those two still loved each other like brothers.')],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', 'Which two?')]),
    ComicPanel(
      'The startled villager answers.',
      [ComicLine('Old Man', 'Ah, never mind. Old history.')],
    ),
  ]),
  8: ComicTranslation('Jadwiga Speaks (Part 1)', [
    ComicPanel(
      'Kazimierz visits Jadwiga at the Chapel.',
      [ComicLine('Kazimierz', 'Who is Bogdan Kruk? And why does no one want to talk about him?')],
    ),
    ComicPanel(
      'Jadwiga sets down her cup after a long silence.',
      [ComicLine('Jadwiga', "Sit. This will be a long conversation - though you won't hear the end of it today.")],
    ),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', 'Your grandfather and Bogdan were partners once. Closer than many brothers.')],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', 'What happened?')]),
    ComicPanel(
      'Jadwiga gestures toward the distant forest.',
      [ComicLine('Jadwiga', 'Something out in those lands.')],
    ),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', "I'll say no more. I promised him my silence, and a promise is a promise.")],
    ),
    ComicPanel('Kazimierz is left alone, staring out the window toward the forest on the horizon.'),
  ]),
  9: ComicTranslation('Tribute', [
    ComicPanel(
      'An armed man with a hard face - Grot - strides into the village with a few thugs.',
      [ComicLine('Grot', "I hear you've got a new lord here.")],
    ),
    ComicPanel(
      null,
      [ComicLine('Grot', 'Nice village. Shame if something happened to it.')],
    ),
    ComicPanel(
      'Kazimierz answers through clenched teeth.',
      [ComicLine('Kazimierz', 'What do you want?')],
    ),
    ComicPanel(
      null,
      [ComicLine('Grot', 'Call it a peace toll. Courtesy of an interested party.')],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', 'Who?')]),
    ComicPanel(
      null,
      [ComicLine('Grot', "Ask your grandfather. Oh, right. He can't answer anymore.")],
    ),
    ComicPanel(
      'Grot leaves with his men.',
      [ComicLine('Grot', "I'll be back for an answer. I'd advise it be the right one.")],
    ),
  ]),
  10: ComicTranslation('Clash with Grot', [
    ComicPanel(
      'Grot returns with a larger group - the village stands ready. Grot looks surprised.',
      [ComicLine('Grot', 'Well, well. Someone actually got ready.')],
    ),
    ComicPanel("A clash breaks out between Grot's forces and the village."),
    ComicPanel('Grot drops to one knee, defeated but unbroken.'),
    ComicPanel(null, [ComicLine('Kazimierz', 'Who do you work for, Grot?')]),
    ComicPanel(
      'Grot rises slowly, smiling.',
      [ComicLine('Grot', "Old Kruk pays well for another man's pain. Not my business why.")],
    ),
    ComicPanel('Grot leaves alive - Kazimierz now has his certainty: it really is Kruk behind all of this.'),
  ]),
  11: ComicTranslation('The Stranger', [
    ComicPanel('Someone watches the village from behind the trees - a hooded woman.'),
    ComicPanel('Kazimierz notices movement and steps closer.'),
    ComicPanel('The woman flees into the trees before Kazimierz can say a word.'),
    ComicPanel('Kazimierz finds a dropped handkerchief on the ground, embroidered with the initials "M.K."'),
    ComicPanel(
      'In the forest, safe now, Marta leans against a tree, breathing hard - for the first time we see her '
      'face, full of doubt.',
    ),
  ]),
  12: ComicTranslation('The Journal', [
    ComicPanel("Kazimierz sorts through his grandfather's belongings in the attic, dust drifting in the sunlight."),
    ComicPanel('Under a floorboard he finds an old, leather-bound journal.'),
    ComicPanel('Most of the pages are torn out or burned - only one survives, stained.'),
    ComicPanel(
      "Close-up on Antoni's handwriting: \"I told him it was an accident. I didn't tell him what I saw in the forest.\"",
    ),
    ComicPanel('Kazimierz sits in silence, the journal in his lap.'),
    ComicPanel('Kazimierz hides the journal away, resolving to ask Jadwiga about it.'),
  ]),
  13: ComicTranslation('A Clumsy Sabotage', [
    ComicPanel('Night - someone attempts sabotage, clumsily and quietly.'),
    ComicPanel('A figure flees at the slightest rustle.'),
    ComicPanel('In the morning Kazimierz inspects the "damage" - laughably minor.'),
    ComicPanel(
      null,
      [ComicLine('Kazimierz', "(to himself) That wasn't Grot. Whoever this is doesn't actually want it to work.")],
    ),
    ComicPanel('Kazimierz recalls the handkerchief with the initials "M.K." - he starts putting the pieces together.'),
  ]),
  14: ComicTranslation('A Conversation by the Well', [
    ComicPanel(
      'Evening - Kazimierz finds the same figure by the well, this time not running.',
      [ComicLine('Marta', "I know you've seen me. I don't have the strength to run anymore.")],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', "You're Kruk's daughter. Marta, right?")]),
    ComicPanel(
      null,
      [ComicLine('Marta', 'And you carry the name my father hates more than anything else in the world.')],
    ),
    ComicPanel(
      'Marta sits on the edge of the well, staring into the water.',
      [ComicLine('Marta', 'My father has spent twenty years mourning Jan so hard he forgot he still has me.')],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', 'Who was Jan?')]),
    ComicPanel(
      null,
      [ComicLine('Marta', '(voice breaking) My brother. And the only thing that matters to my father - even in death.')],
    ),
    ComicPanel('Silence between them.'),
    ComicPanel('The first genuinely human, non-hostile moment in the whole story.'),
  ]),
  15: ComicTranslation('Clash with Marta', [
    ComicPanel(
      'Marta stands opposite Kazimierz, armed, but without conviction in her eyes.',
      [ComicLine('Marta', 'Father ordered it. I have no choice.')],
    ),
    ComicPanel('A restrained clash - both sides fight without full commitment.'),
    ComicPanel('Marta falls, defeated, looking almost relieved.'),
    ComicPanel(
      null,
      [ComicLine('Marta', '(from the ground, a bitter smile) Father believes your grandfather killed Jan with his bare hands.')],
    ),
    ComicPanel(null, [ComicLine('Marta', '(quieter) I... am no longer so sure.')]),
    ComicPanel('Marta gets up and leaves without further fighting - something between them has changed for good.'),
  ]),
  16: ComicTranslation('Accusation at the Market', [
    ComicPanel('The market square of a neighboring settlement, a crowd of merchants and villagers.'),
    ComicPanel(
      'Bogdan Kruk, seen clearly for the first time, climbs onto a platform, furious.',
      [ComicLine('Bogdan', 'My daughter has failed! Let everyone hear who this heir really is!')],
    ),
    ComicPanel(
      null,
      [ComicLine('Bogdan', 'A family that hides murder behind a mask of good husbandry!')],
    ),
    ComicPanel('The rumor spreads like wildfire - more and more people repeat the story, growing ever more twisted.'),
    ComicPanel(
      'Kazimierz hears about it from a nervous merchant visiting the village.',
      [ComicLine('Merchant', 'People are saying all sorts of things about your grandfather...')],
    ),
    ComicPanel('Kazimierz, heavy-hearted, realizes a confrontation is unavoidable.'),
  ]),
  17: ComicTranslation('Jadwiga Speaks (Part 2)', [
    ComicPanel(
      'Kazimierz returns to Jadwiga, journal in hand, determined.',
      [ComicLine('Kazimierz', 'I need to know. All of it.')],
    ),
    ComicPanel(
      'Jadwiga stares at the journal a long while, finally sighs.',
      [ComicLine('Jadwiga', "Jan was searching for something in the old mine. Something he shouldn't have gone looking for.")],
    ),
    ComicPanel(null, [ComicLine('Jadwiga', 'Antoni tried to stop him. He begged him to turn back.')]),
    ComicPanel(null, [ComicLine('Jadwiga', "(voice trembling) He wasn't in time.")]),
    ComicPanel(null, [ComicLine('Kazimierz', "So grandfather didn't... didn't hurt Jan?")]),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', "It's far more complicated than that, child. And it still isn't the whole truth.")],
    ),
    ComicPanel('Jadwiga looks away, clearly hiding still more - Kazimierz notices.'),
  ]),
  18: ComicTranslation('The Sealed Entrance', [
    ComicPanel('Following the clues from the journal, Kazimierz sets out for the edge of the estate.'),
    ComicPanel('A snow-covered, dark forest - the atmosphere thickens with every step.'),
    ComicPanel(
      'Kazimierz finds an old, sealed, overgrown mine entrance; unfamiliar symbols are carved into the stone above it.',
    ),
    ComicPanel("Kazimierz tries to open the entrance - without success; it's sealed fast."),
    ComicPanel('Kazimierz leaves with even more questions, but one certainty: this place matters more than anything.'),
  ]),
  19: ComicTranslation('Face to Face with Bogdan', [
    ComicPanel(
      'Bogdan Kruk arrives at the village in person, flanked by a silent escort.',
      [ComicLine('Bogdan', 'No more go-betweens. I want the truth, or I want blood.')],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', "Truth about what? I don't even know what happened!")]),
    ComicPanel(
      null,
      [ComicLine('Bogdan', '(with fury and pain) Your grandfather knew! And he took it to his grave!')],
    ),
    ComicPanel(
      'Kazimierz shows him a page from the journal.',
      [ComicLine('Kazimierz', 'Maybe this will tell you something.')],
    ),
    ComicPanel(
      'Bogdan reads, goes pale, his hands trembling.',
      [ComicLine('Bogdan', '(whispering) The forest. Not the road. He always told me it was the road...')],
    ),
    ComicPanel(
      null,
      [ComicLine('Bogdan', '(looking up, voice hardening) This changes nothing. He was still keeping something from me!')],
    ),
    ComicPanel('Bogdan steps back, ready to fight - but the first crack in his certainty is already visible in his eyes.'),
  ]),
  20: ComicTranslation('Clash with Bogdan', [
    ComicPanel('A clash in the snow - Bogdan fights with the fury of a man losing his footing.'),
    ComicPanel('Bogdan weakens, blow after blow, until he drops to his knees.'),
    ComicPanel('Kazimierz stands over him, withholding the final blow.'),
    ComicPanel(
      null,
      [
        ComicLine(
          'Bogdan',
          "(voice breaking, rising despite defeat) If your grandfather could find a way to hold back something that "
              "should have died... then I'll find a way to bring back what I lost!",
        ),
      ],
    ),
    ComicPanel('Bogdan lurches up and flees toward the forest, vanishing among the trees.'),
    ComicPanel(
      "Kazimierz is left alone in the snow with the unsettling echo of Bogdan's words - "
          '"something that should have died."',
    ),
  ]),
  21: ComicTranslation('Signs', [
    ComicPanel('Spring returns to the village, but something is wrong - forest animals flee en masse toward the settlement.'),
    ComicPanel('The well, despite the warm weather, becomes coated in an unnatural frost.'),
    ComicPanel(
      'Villagers whisper, pointing toward the forest.',
      [ComicLine('Villager', 'I saw a shadow between the trees. Too big to be a man.')],
    ),
    ComicPanel('Kazimierz watches an unsettlingly darkening patch of forest on the horizon.'),
    ComicPanel('At night, strange sounds carry from beyond the border of the estate.'),
    ComicPanel('Kazimierz wakes up uneasy - time is running out.'),
  ]),
  22: ComicTranslation('The Whole Truth', [
    ComicPanel(
      'Kazimierz confronts Jadwiga one last time, determined.',
      [ComicLine('Kazimierz', 'Something is waking in that forest. Now you MUST tell me everything.')],
    ),
    ComicPanel(
      'Jadwiga, seeing the gravity of the situation, breaks her silence completely.',
      [ComicLine('Jadwiga', 'They call him Leszy. The old, dark guardian of those lands.')],
    ),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', "Jan tried to bargain with him. For fortune, for his father's approval. The price was too high.")],
    ),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', 'Antoni managed to stop him - and seal him away again, at his own cost.')],
    ),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', '(heavily) A debt he carried in silence ever since. A debt that has now fallen to you.')],
    ),
    ComicPanel('Kazimierz, staggered by the weight of the truth, looks toward the forest with new understanding - and new fear.'),
  ]),
  23: ComicTranslation("Marta's Warning", [
    ComicPanel(
      'Marta arrives at the village, breathless, frightened.',
      [ComicLine('Marta', "Father is gone. Toward the mine. He took Jan's things with him.")],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', 'What is he planning?')]),
    ComicPanel(null, [ComicLine('Marta', "(in despair) He doesn't want to beat you anymore. He wants my brother back.")]),
    ComicPanel(null, [ComicLine('Marta', "He doesn't know what he's doing. None of us do.")]),
    ComicPanel('They both stare toward the darkening forest, knowing time is running out.'),
  ]),
  24: ComicTranslation('The Awakening', [
    ComicPanel(
      "Deep in the forest, Bogdan, surrounded by his dead son's belongings, finishes a dark ritual.",
      [ComicLine('Bogdan', '(whispering, in tears) Come back to me, son. Even like this.')],
    ),
    ComicPanel('The ground trembles, old seals shatter with a crack, darkness pours out of the mine entrance.'),
    ComicPanel('Leszy wakes fully - mightier and hungrier than ever, his form filling the sky above the forest.'),
    ComicPanel(
      'Bogdan staggers back, horrified at what he has woken.',
      [ComicLine('Bogdan', '(quietly, terrified) That... that is not my son.')],
    ),
    ComicPanel('In the village, Kazimierz and the villagers see the darkness growing over the horizon.'),
    ComicPanel('The alarm sounds through the village - time to prepare for battle.'),
  ]),
  25: ComicTranslation('The Calm Before the Storm', [
    ComicPanel(
      "The alarm still echoes over the village, but Leszy doesn't attack right away - weakened by his own "
          'awakening, he needs time to regain his full strength.',
    ),
    ComicPanel('Kazimierz makes use of every hour of delay - the Palisade reinforced day and night, soldiers drilled from dawn until dusk.'),
    ComicPanel('Since the day of the awakening, no one has seen or heard from Bogdan - a silence that breeds worse and worse fears with each passing day.'),
    ComicPanel(
      'Marta arrives at the village openly, for the first time not as an enemy or a spy.',
      [ComicLine('Marta', "I know it's a strange thing to ask, given everything... but will you help me find him?")],
    ),
    ComicPanel(
      null,
      [ComicLine('Kazimierz', 'No one deserves an end like that without answers. Not even him.')],
    ),
    ComicPanel('The village is left under guard, armed as well as it could manage, while Kazimierz and Marta set out toward the forest - this time as allies.'),
  ]),
  26: ComicTranslation('Traces in the Ashes', [
    ComicPanel('Kazimierz and Marta reach the site of the ritual - scorched earth, blackened trees.'),
    ComicPanel('They search through the ruins in silence.'),
    ComicPanel("They find the burned remains of Jan's belongings - nothing more."),
    ComicPanel(
      'Among the ashes, Marta finds one object, untouched by the fire.',
      [ComicLine('Marta', '(picking it up, startled) This... this belonged to your grandfather.')],
    ),
    ComicPanel(
      null,
      [ComicLine('Kazimierz', 'How did it get here? Grandfather never came back to this place, did he?')],
    ),
    ComicPanel('They exchange a look full of new, unsettling questions.'),
  ]),
  27: ComicTranslation('The First Attempt', [
    ComicPanel('Kazimierz and Marta visit Jadwiga with the object found in the ashes.'),
    ComicPanel(
      "Jadwiga takes it in her hand, her face hardening with understanding.",
      [ComicLine('Jadwiga', "This wasn't Bogdan's first meeting with Leszy.")],
    ),
    ComicPanel(null, [ComicLine('Marta', 'What do you mean?')]),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', 'Your father had already tried once before. Long ago. It failed.')],
    ),
    ComicPanel(
      null,
      [ComicLine('Jadwiga', 'Antoni had to intervene then too - and leave something behind as surety, to hold him back.')],
    ),
    ComicPanel(
      'Marta sits down heavily, stunned.',
      [ComicLine('Marta', 'So this has been going on longer than I thought. My whole life.')],
    ),
    ComicPanel('Kazimierz rests a hand on her shoulder - a shared burden binds them tighter than their old hostility ever did.'),
  ]),
  28: ComicTranslation('The Truth About Bogdan', [
    ComicPanel('Following the last clues, Kazimierz and Marta reach the very edge of the forest.'),
    ComicPanel(
      'There they find Bogdan - alive, but broken, aged a decade in a few short weeks. '
      '(Alternate variant: instead of Bogdan, they find only his belongings, abandoned at the end of the path.)',
    ),
    ComicPanel(
      "Bogdan, seeing his daughter, can't meet her eyes.",
      [ComicLine('Bogdan', "(whisper) I'm sorry, Marta. For everything. I went looking for my son and lost my daughter along the way.")],
    ),
    ComicPanel(
      'Marta steps closer, tears in her eyes, but without hesitation.',
      [ComicLine('Marta', "You haven't lost me yet. But you have to tell me everything now, finally.")],
    ),
    ComicPanel("Bogdan tells the rest of the truth - of the first attempt years ago, of Antoni's sacrifice, of his own despair."),
    ComicPanel(
      'Marta, listening, for the first time in twenty years, fully understands her father, her brother, and the '
      'heir she hated for so long.',
    ),
  ]),
  29: ComicTranslation('Clash with Leszy', [
    ComicPanel('Leszy bears down on the village - enormous, dark, relentless.'),
    ComicPanel("The village's defense (soldiers, the Palisade) braces for the final battle."),
    ComicPanel("An intense clash between the forces of nature and darkness and the defenders' resolve."),
    ComicPanel('Leszy is defeated and forced to retreat back into the earth, the darkness receding.'),
    ComicPanel('Bogdan, still weak from what he went through, watches from a safe distance as the shadow he himself woke finally yields.'),
    ComicPanel("Exhausted but alive, Kazimierz looks out over the battlefield - the village survived. It's nearly over."),
  ]),
  30: ComicTranslation('A New Sowing - Epilogue', [
    ComicPanel('A spring morning - Kazimierz and Marta stand together at the border of what were once disputed lands.'),
    ComicPanel('Together, they plant a young tree exactly on the boundary line - a symbolic gesture.'),
    ComicPanel(
      'Jadwiga watches from the side, relief and sorrow mingling in her eyes.',
      [ComicLine('Jadwiga', 'Your grandfather carried that debt for twenty years.')],
    ),
    ComicPanel(null, [ComicLine('Jadwiga', "You carried it for one. Maybe that's enough now.")]),
    ComicPanel(
      'Marta looks toward the forest, quiet and peaceful now.',
      [ComicLine('Marta', "Do you think it's really over?")],
    ),
    ComicPanel(null, [ComicLine('Kazimierz', "I'd like to believe it is.")]),
    ComicPanel('The forest, quiet and still in the spring sun. Closing text: "End of Year One."'),
  ]),
};
