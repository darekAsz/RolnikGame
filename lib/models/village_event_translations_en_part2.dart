import 'village_event_translations_en.dart';

/// Część 2/2 (zdarzenia od ~78 do końca `kVillageEvents`, patrz
/// `village_event.dart`) - patrz `village_event_translations_en.dart`, gdzie
/// obie części są łączone.
const Map<String, VillageEventTranslation> kVillageEventsEnPart2 = {
  // ---- pozytywne ----
  'general_pos_24': VillageEventTranslation(
    'Favorable Wind',
    'Favorable weather speeds up the ripening of fruit.',
  ),
  'general_pos_25': VillageEventTranslation(
    'Spirit of Community',
    'Villagers spontaneously help one another.',
  ),

  // ---- negatywne ----
  'general_neg_1': VillageEventTranslation(
    'Thief in the Night',
    'A night thief robbed part of the village treasury.',
  ),
  'general_neg_2': VillageEventTranslation(
    'Gossip and Discord',
    'Gossip sparked disputes between neighbors.',
  ),
  'general_neg_3': VillageEventTranslation(
    'Broken Equipment',
    'Several important carpentry tools broke down.',
  ),
  'general_neg_4': VillageEventTranslation(
    'Cracked Millstone',
    'The millstone cracked while in use and needs replacing.',
  ),
  'general_neg_5': VillageEventTranslation(
    'Contaminated Well',
    'One of the wells was accidentally contaminated.',
  ),
  'general_neg_6': VillageEventTranslation(
    'Pests in the Granary',
    'Rodents got into the grain stores.',
  ),
  'general_neg_7': VillageEventTranslation(
    'Wormy Apples',
    'Part of the apple harvest turned out to be wormy.',
  ),
  'general_neg_8': VillageEventTranslation(
    'Scorched Grass',
    'An uncontrolled fire consumed part of the meadow.',
  ),
  'general_neg_9': VillageEventTranslation(
    'Boundary Dispute',
    'A dispute over plot boundaries soured the village mood.',
  ),
  'general_neg_10': VillageEventTranslation(
    'Swindler at the Market',
    'A swindler cheated the village out of some of its gold at the market.',
  ),
  'general_neg_11': VillageEventTranslation(
    'Collapsed Wall',
    'An old wall collapsed, destroying stone stores.',
  ),
  'general_neg_12': VillageEventTranslation(
    'Rotten Beams',
    'Rotten beams had to be urgently replaced.',
  ),
  'general_neg_13': VillageEventTranslation(
    'Water Poisoning',
    'Contamination poisoned part of the water stores.',
  ),
  'general_neg_14': VillageEventTranslation(
    'Poor Harvest',
    "This year's grain harvest is worse than usual.",
  ),
  'general_neg_15': VillageEventTranslation(
    'Fodder Theft',
    'Thieves stole part of the animal fodder stores.',
  ),
  'general_neg_16': VillageEventTranslation(
    'Discontent Over Taxes',
    'A tax increase stirred discontent among the villagers.',
  ),
  'general_neg_17': VillageEventTranslation(
    'Damaged Cart',
    'A damaged transport cart needs urgent repair.',
  ),
  'general_neg_18': VillageEventTranslation(
    'False Alarm',
    'A false alarm about raiders alarmed the whole village.',
  ),
  'general_neg_19': VillageEventTranslation(
    'Family Quarrel',
    'A quarrel between two families soured the village atmosphere.',
  ),
  'general_neg_20': VillageEventTranslation(
    'Broken Mining Tools',
    "The stonemasons' tools need urgent repair.",
  ),
  'general_neg_21': VillageEventTranslation(
    'Poultry Plague',
    "A plague decimated the village's poultry.",
  ),
  'general_neg_22': VillageEventTranslation(
    'Dishonest Merchant',
    'A merchant cheated on the weight of goods sold.',
  ),
  'general_neg_23': VillageEventTranslation(
    'Musty Stores',
    'Part of the grain got wet and went moldy in storage.',
  ),
  'general_neg_24': VillageEventTranslation(
    'Insects in the Orchard',
    'Pests attacked the fruit trees in the orchard.',
  ),
  'general_neg_25': VillageEventTranslation(
    'Dried-Up Well',
    'One of the wells unexpectedly dried up.',
  ),

  // ============================================================
  // OGÓLNE Z WYBOREM - 50 pozycji
  // ============================================================
  'choice_alchemist': VillageEventTranslation(
    'Traveling Alchemist',
    'An alchemist offers a mysterious elixir in exchange for resources.',
    [
      VillageEventOptionTranslation(
        'Buy the elixir',
        'The elixir proves useful - the villagers feel better.',
      ),
      VillageEventOptionTranslation('Refuse', 'The alchemist continues on his way.'),
    ],
  ),
  'choice_fire_refugees': VillageEventTranslation(
    'Refugees from the Fire',
    'A group of refugees from a nearby, burned-down settlement asks for shelter.',
    [
      VillageEventOptionTranslation('Take them in', 'New residents settle in the village.'),
      VillageEventOptionTranslation('Turn them away', 'The refugees seek help elsewhere.'),
    ],
  ),
  'choice_grain_loan': VillageEventTranslation(
    'Request for a Grain Loan',
    'A neighboring village asks to borrow grain for spring sowing.',
    [
      VillageEventOptionTranslation('Lend it', 'The neighbors are very grateful for the help.'),
      VillageEventOptionTranslation('Refuse', 'The neighbors will remember this refusal.'),
    ],
  ),
  'choice_bard': VillageEventTranslation(
    'Traveling Bard',
    'A bard offers a performance at the market in exchange for payment.',
    [
      VillageEventOptionTranslation(
        'Pay for the performance',
        "The performance brightens the whole village's evening.",
      ),
      VillageEventOptionTranslation(
        'Chase him off',
        'The bard leaves regretfully, and the villagers mourn the lost entertainment.',
      ),
    ],
  ),
  'choice_well_dispute': VillageEventTranslation(
    'Dispute Over the Well',
    'Two neighbors are arguing over access to a shared well.',
    [
      VillageEventOptionTranslation('Settle it fairly', 'The dispute is resolved amicably.'),
      VillageEventOptionTranslation('Ignore it', 'The dispute drags on, souring the mood.'),
    ],
  ),
  'choice_wood_offer': VillageEventTranslation(
    'Offer for Wood',
    'A merchant offers a good price for the wood stores.',
    [
      VillageEventOptionTranslation('Sell it', "The wood goes onto the merchant's cart."),
      VillageEventOptionTranslation('Keep it', 'The wood stays in storage.'),
    ],
  ),
  'choice_poor_family': VillageEventTranslation(
    "A Poor Family's Request",
    'A poor family asks for some grain stores to survive the month.',
    [
      VillageEventOptionTranslation(
        'Help them',
        'The family is grateful, and the village shows its solidarity.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        'The family manages on their own, bitterly remembering the refusal.',
      ),
    ],
  ),
  'choice_healer': VillageEventTranslation(
    'Traveling Healer',
    'A healer offers to inoculate the villagers for a fee.',
    [
      VillageEventOptionTranslation('Pay', 'The villagers feel safer.'),
      VillageEventOptionTranslation(
        'Send him away',
        'The healer moves on, and the villagers are left without inoculations, which worries them.',
      ),
    ],
  ),
  'choice_wounded_traveler': VillageEventTranslation(
    'Wounded Traveler',
    'A wounded traveler asks for food and care.',
    [
      VillageEventOptionTranslation(
        'Tend to him',
        'The traveler recovers and blesses the village.',
      ),
      VillageEventOptionTranslation('Leave him', 'The traveler leaves under his own power.'),
    ],
  ),
  'choice_alliance': VillageEventTranslation(
    'Alliance Offer',
    'A neighboring village proposes a defensive alliance in exchange for tribute.',
    [
      VillageEventOptionTranslation(
        'Accept the alliance',
        "The alliance strengthens the village's defenses.",
      ),
      VillageEventOptionTranslation(
        'Reject it',
        "The village remains independent, but without an ally's support it feels less secure.",
      ),
    ],
  ),
  'choice_wedding_permission': VillageEventTranslation(
    'Request for a Wedding',
    'A young couple asks for permission to marry without a traditional dowry.',
    [
      VillageEventOptionTranslation('Agree', 'The wedding takes place to the joy of the village.'),
      VillageEventOptionTranslation('Refuse', 'The couple is disappointed by the decision.'),
    ],
  ),
  'choice_traveling_smith': VillageEventTranslation(
    'Traveling Smith',
    "A smith offers free tool repairs in exchange for a night's lodging.",
    [
      VillageEventOptionTranslation(
        'Offer lodging',
        'The tools are restored to good condition.',
      ),
      VillageEventOptionTranslation('Refuse', 'The smith moves on.'),
    ],
  ),
  'choice_old_mine_map': VillageEventTranslation(
    'Map of an Old Mine',
    'An old map pointing to an abandoned stone mine has been found.',
    [
      VillageEventOptionTranslation(
        'Explore the mine',
        'The expedition brings back valuable stone.',
      ),
      VillageEventOptionTranslation(
        'Ignore the map',
        'The map ends up in a chest of old junk.',
      ),
    ],
  ),
  'choice_shepherds': VillageEventTranslation(
    'Traveling Shepherds',
    "Shepherds ask to graze their flocks on the village's meadows.",
    [
      VillageEventOptionTranslation(
        'Allow it, for a fee',
        'The shepherds pay for the grazing, but the meadows suffer a little.',
      ),
      VillageEventOptionTranslation('Drive them off', 'The shepherds seek other pastures.'),
    ],
  ),
  'choice_teacher': VillageEventTranslation(
    'Traveling Teacher',
    'A teacher offers to settle down and teach the children in exchange for room and board.',
    [
      VillageEventOptionTranslation(
        'Accept',
        'The children learn eagerly, and the village is proud.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        'The teacher seeks another village, and the parents regret the lost chance for their children.',
      ),
    ],
  ),
  'choice_juggler': VillageEventTranslation(
    'Traveling Juggler',
    'A juggler asks for permission to perform at the market.',
    [
      VillageEventOptionTranslation('Allow it', 'The performances prove very popular.'),
      VillageEventOptionTranslation(
        'Refuse',
        'The juggler leaves disappointed, and the villagers make no secret of their own disappointment.',
      ),
    ],
  ),
  'choice_orphan': VillageEventTranslation(
    'Orphan Seeking a Home',
    'An orphaned child seeks shelter in the village.',
    [
      VillageEventOptionTranslation('Take the child in', 'The child finds a new home.'),
      VillageEventOptionTranslation(
        'Send the child away',
        'The child ends up in a distant orphanage.',
      ),
    ],
  ),
  'choice_gold_rumor': VillageEventTranslation(
    'Rumor of Gold',
    'Rumors circulate of gold hidden in the nearby forest.',
    [
      VillageEventOptionTranslation('Search for the gold', 'The search partly pays off.'),
      VillageEventOptionTranslation(
        'Ignore the rumors',
        'No one wastes time searching.',
      ),
    ],
  ),
  'choice_priest': VillageEventTranslation(
    'Traveling Priest',
    'A priest of another faith asks to hold a service.',
    [
      VillageEventOptionTranslation(
        'Hear him out',
        'The service brings comfort to some of the villagers.',
      ),
      VillageEventOptionTranslation(
        'Send him away',
        'The priest leaves without a word, and some villagers feel deprived of comfort.',
      ),
    ],
  ),
  'choice_animal_trader': VillageEventTranslation(
    'Livestock Trader',
    'A trader offers healthy livestock for sale.',
    [
      VillageEventOptionTranslation(
        'Buy the animals',
        'The new animals enrich the farmsteads.',
      ),
      VillageEventOptionTranslation('Refuse', 'The trader moves on.'),
    ],
  ),
  'choice_neighbor_famine': VillageEventTranslation(
    'Famine Among Neighbors',
    'A neighboring village struck by crop failure asks for food.',
    [
      VillageEventOptionTranslation(
        'Share the stores',
        'The neighbors long remember this help.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        'The neighbors manage on their own, offended by the refusal.',
      ),
    ],
  ),
  'choice_herbalist': VillageEventTranslation(
    'Traveling Herbalist',
    'A herbalist offers effective herbal remedies.',
    [
      VillageEventOptionTranslation(
        'Buy the remedies',
        "The remedies improve the villagers' wellbeing.",
      ),
      VillageEventOptionTranslation('Refuse', 'The herbalist moves on.'),
    ],
  ),
  'choice_hunt': VillageEventTranslation(
    'Shared Hunt',
    'Hunters invite the village to join a shared hunt.',
    [
      VillageEventOptionTranslation('Join in', 'The hunt brings in extra supplies.'),
      VillageEventOptionTranslation('Stay home', 'Life carries on as usual.'),
    ],
  ),
  'choice_wounded_horse': VillageEventTranslation(
    'Wounded Horse',
    'A wounded, abandoned horse is found on the road.',
    [
      VillageEventOptionTranslation(
        'Take the horse in',
        'Once healed, the horse proves useful around the farm.',
      ),
      VillageEventOptionTranslation('Set it free', 'The horse wanders off on its own.'),
    ],
  ),
  'choice_craftsman': VillageEventTranslation(
    'Traveling Craftsman',
    'A craftsman is looking for a place to set up a workshop in the village.',
    [
      VillageEventOptionTranslation('Take him in', 'The workshop starts to bring benefits.'),
      VillageEventOptionTranslation('Turn him away', 'The craftsman looks for another village.'),
    ],
  ),
  'choice_volunteers': VillageEventTranslation(
    'Request for Volunteers',
    'A neighboring village asks for volunteers to help with joint defense.',
    [
      VillageEventOptionTranslation(
        'Send volunteers',
        "Helping the ally strengthens relations but thins the village's own ranks.",
      ),
      VillageEventOptionTranslation('Refuse', 'The village keeps everyone for itself.'),
    ],
  ),
  'choice_weapon_trade': VillageEventTranslation(
    'Weapons Trade Offer',
    "A merchant offers weapons useful for the village's defense.",
    [
      VillageEventOptionTranslation(
        'Buy the weapons',
        'Better-armed guards feel more confident.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        'The merchant moves on, and the guards are left without better weapons.',
      ),
    ],
  ),
  'choice_suspicious_stranger': VillageEventTranslation(
    'Suspicious Stranger',
    'A stranger is lurking around the village, causing unease.',
    [
      VillageEventOptionTranslation(
        'Question him',
        'The stranger turns out to be harmless, and the guards stay more alert.',
      ),
      VillageEventOptionTranslation('Ignore him', 'Unease lingers in the village.'),
    ],
  ),
  'choice_fortune_teller': VillageEventTranslation(
    'Traveling Fortune Teller',
    'A fortune teller offers to read the future for a fee.',
    [
      VillageEventOptionTranslation(
        'Pay for a reading',
        'The prophecy comforts the villagers.',
      ),
      VillageEventOptionTranslation(
        'Send her away',
        'The fortune teller leaves with a smile, though some regret missing her prophecy.',
      ),
    ],
  ),
  'choice_playground': VillageEventTranslation(
    'Request for a Playground',
    'The children ask for a simple playground to be built.',
    [
      VillageEventOptionTranslation(
        'Build the playground',
        'The children are delighted with the new place to play.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        'The children play as before, clearly disappointed by the decision.',
      ),
    ],
  ),
  'choice_orchard_investment': VillageEventTranslation(
    'Investment in the Orchard',
    'A gardener proposes investing in expanding the orchard.',
    [
      VillageEventOptionTranslation(
        'Invest',
        'The new saplings quickly begin to bear fruit.',
      ),
      VillageEventOptionTranslation('Refuse', 'The orchard stays unchanged.'),
    ],
  ),
  'choice_inheritance_dispute': VillageEventTranslation(
    'Inheritance Dispute',
    'A family asks for help settling a dispute over inheriting a farmstead.',
    [
      VillageEventOptionTranslation('Settle it fairly', 'The family accepts the verdict.'),
      VillageEventOptionTranslation(
        "Don't get involved",
        'The dispute drags on, souring relations in the village.',
      ),
    ],
  ),
  'choice_musician': VillageEventTranslation(
    'Traveling Musician',
    'A musician is looking for a patron to fund his stay.',
    [
      VillageEventOptionTranslation(
        'Support the musician',
        "The music brightens the whole village's evenings.",
      ),
      VillageEventOptionTranslation(
        'Refuse',
        "The musician plays elsewhere, and the village's evenings are a little less cheerful.",
      ),
    ],
  ),
  'choice_mercenaries': VillageEventTranslation(
    'Mercenary Offer',
    'A band of mercenaries offers to protect the village for a fee.',
    [
      VillageEventOptionTranslation(
        'Hire them',
        'The mercenaries strengthen the defense for a while.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        "The village relies only on its own strength, without the mercenaries' extra protection.",
      ),
    ],
  ),
  'choice_relative_letter': VillageEventTranslation(
    'Letter from a Relative',
    'A letter from a long-lost relative asks for financial help.',
    [
      VillageEventOptionTranslation('Send help', 'The relative is very grateful.'),
      VillageEventOptionTranslation('Ignore the letter', 'The letter goes unanswered.'),
    ],
  ),
  'choice_risky_caravan': VillageEventTranslation(
    'Risky Caravan',
    'A merchant proposes sending a caravan to a distant city.',
    [
      VillageEventOptionTranslation(
        'Send the caravan',
        'The caravan returns with a profit, though the journey was hard.',
      ),
      VillageEventOptionTranslation('Decline', 'The village takes no risks.'),
    ],
  ),
  'choice_elders_request': VillageEventTranslation(
    "Elders' Request",
    'The village elders ask for a greater say in decisions concerning the village.',
    [
      VillageEventOptionTranslation('Agree', 'The elders feel appreciated.'),
      VillageEventOptionTranslation('Refuse', 'The elders are disappointed by the decision.'),
    ],
  ),
  'choice_abandoned_cart': VillageEventTranslation(
    'Abandoned Cart',
    'An abandoned cart full of goods is found on the road.',
    [
      VillageEventOptionTranslation(
        'Return it to the owner',
        'The honesty is appreciated throughout the area.',
      ),
      VillageEventOptionTranslation(
        'Keep the goods',
        'The village gains the goods, but rumors of dishonesty spread.',
      ),
    ],
  ),
  'choice_builder_plans': VillageEventTranslation(
    "A Builder's Plans",
    'A traveling builder offers to sell plans for economical construction.',
    [
      VillageEventOptionTranslation(
        'Buy the plans',
        'The plans help save on building materials.',
      ),
      VillageEventOptionTranslation('Reject the offer', 'The village builds the old way.'),
    ],
  ),
  'choice_horse_race': VillageEventTranslation(
    'Request for a Racehorse',
    "Race organizers ask to borrow the village's best horse.",
    [
      VillageEventOptionTranslation(
        'Lend the horse',
        'The horse wins the race, bringing home a prize.',
      ),
      VillageEventOptionTranslation('Refuse', 'The horse stays safely in the stable.'),
    ],
  ),
  'choice_pilgrims': VillageEventTranslation(
    'Group of Pilgrims',
    'Pilgrims ask for lodging on their way to a holy site.',
    [
      VillageEventOptionTranslation(
        'Take them in',
        'The pilgrims bless the village for its hospitality.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        "The pilgrims seek lodging elsewhere, and refusing hospitality does not befit the village's good name.",
      ),
    ],
  ),
  'choice_new_crop': VillageEventTranslation(
    'Learning a New Crop',
    'A wanderer offers to teach a new method of growing grain.',
    [
      VillageEventOptionTranslation('Pay for the lesson', 'The new method increases yields.'),
      VillageEventOptionTranslation('Refuse', 'The village farms the land as before.'),
    ],
  ),
  'choice_worker_conflict': VillageEventTranslation(
    'Worker Conflict',
    'A dispute has broken out between workers at a construction site.',
    [
      VillageEventOptionTranslation('Intervene', 'The dispute is quickly resolved.'),
      VillageEventOptionTranslation(
        'Ignore it',
        'The dispute takes a toll on the working atmosphere.',
      ),
    ],
  ),
  'choice_debt_collector': VillageEventTranslation(
    'Debt Collector',
    'A traveling collector demands repayment of an old, forgotten debt.',
    [
      VillageEventOptionTranslation(
        'Pay the debt',
        'The matter is closed without further trouble.',
      ),
      VillageEventOptionTranslation(
        'Refuse to pay',
        'The collector leaves angry, threatening to return.',
      ),
    ],
  ),
  'choice_shared_well': VillageEventTranslation(
    'Shared Well',
    'Neighbors propose jointly building a well on the border between the villages.',
    [
      VillageEventOptionTranslation('Build it together', 'The new well serves both villages.'),
      VillageEventOptionTranslation('Refuse', 'Each village manages on its own.'),
    ],
  ),
  'choice_rare_animal': VillageEventTranslation(
    'Rare Livestock',
    'A trader offers a rare, valuable breed of livestock.',
    [
      VillageEventOptionTranslation(
        'Buy the animal',
        'The animal quickly becomes the pride of the farmstead.',
      ),
      VillageEventOptionTranslation('Refuse', 'The trader looks for another buyer.'),
    ],
  ),
  'choice_chronicler': VillageEventTranslation(
    'Village Chronicler',
    "A traveling writer wants to record the village's history in a chronicle.",
    [
      VillageEventOptionTranslation(
        'Allow him',
        'The villagers are proud that their history will be recorded.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        "The village's history remains unrecorded, to the disappointment of some villagers.",
      ),
    ],
  ),
  'choice_lend_tools': VillageEventTranslation(
    'Request for Tools',
    'A neighboring village asks to borrow building tools.',
    [
      VillageEventOptionTranslation(
        'Lend the tools',
        'The neighbors are grateful for the help.',
      ),
      VillageEventOptionTranslation('Refuse', 'The village keeps the tools for itself.'),
    ],
  ),
  'choice_exotic_seeds': VillageEventTranslation(
    'Exotic Seeds',
    'A mysterious merchant offers exotic seeds of unknown plants.',
    [
      VillageEventOptionTranslation(
        'Buy the seeds',
        'The new plants yield surprisingly well.',
      ),
      VillageEventOptionTranslation(
        'Refuse',
        'The merchant puts the seeds back in his pouch.',
      ),
    ],
  ),
  'choice_tax_law': VillageEventTranslation(
    'New Tax Law',
    'The council of elders proposes introducing a new, higher tax.',
    [
      VillageEventOptionTranslation(
        'Introduce the tax',
        'The treasury grows, but the villagers are unhappy.',
      ),
      VillageEventOptionTranslation('Reject it', 'Taxes remain unchanged.'),
    ],
  ),
};
