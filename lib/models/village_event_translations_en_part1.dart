import 'village_event_translations_en.dart';

/// Część 1/2 (pierwsze ~77 zdarzeń z `kVillageEvents`, patrz `village_event.dart`)
/// - patrz `village_event_translations_en.dart`, gdzie obie części są łączone.
const Map<String, VillageEventTranslation> kVillageEventsEnPart1 = {
  // ---- positive ----
  'trader_gift': VillageEventTranslation(
    'Traveling Merchant',
    "A traveling merchant, delighted by the village's hospitality, leaves behind a gift of his wares.",
  ),
  'bountiful_harvest': VillageEventTranslation(
    'Bountiful Harvest',
    "This year's harvest exceeded all expectations - the granaries are bursting at the seams.",
  ),
  'spring_rains': VillageEventTranslation(
    'Spring Rains',
    'Gentle spring rains have enriched the fields and filled the wells.',
  ),
  'stone_vein': VillageEventTranslation(
    'New Stone Vein',
    'The stonemasons have struck a rich vein of good stone.',
  ),
  'village_festival': VillageEventTranslation(
    'Village Festival',
    "A spontaneous celebration lifts spirits across the whole village.",
  ),

  // ---- negative ----
  'granary_fire': VillageEventTranslation(
    'Granary Fire',
    'Carelessness near the oven sparked a fire - part of the stores burned.',
  ),
  'drought': VillageEventTranslation(
    'Drought',
    'The lack of rain has dried up the wells and fields.',
  ),
  'harsh_winter': VillageEventTranslation(
    'Harsh Winter',
    "Frost and snow have made life difficult for the villagers.",
  ),
  'bandit_raid': VillageEventTranslation(
    'Bandit Raid',
    'A band of bandits plundered the granaries before the defenders could react.',
  ),
  'livestock_illness': VillageEventTranslation(
    'Livestock Illness',
    'A mysterious disease is decimating the livestock.',
  ),

  // ---- choice ----
  'immigrants': VillageEventTranslation(
    'Immigrants Seeking Refuge',
    'A group of travelers asks to be let into the village and settle permanently.',
    [
      VillageEventOptionTranslation(
        'Accept',
        'The new residents raise the population limit, but take some of the stores to get started.',
      ),
      VillageEventOptionTranslation(
        'Turn Away',
        "The travelers leave to seek their fortune elsewhere, and word of the cold reception does the village's reputation no favors.",
      ),
    ],
  ),
  'preacher': VillageEventTranslation(
    'Traveling Preacher',
    'A preacher asks for permission to give sermons in the village market.',
    [
      VillageEventOptionTranslation(
        'Allow',
        'The sermons raise morale, but the collection plate thins the treasury.',
      ),
      VillageEventOptionTranslation('Drive Him Off', 'The preacher leaves empty-handed.'),
    ],
  ),
  'caravan': VillageEventTranslation(
    'Merchant Caravan',
    'Merchants offer to trade wood and stone for gold.',
    [
      VillageEventOptionTranslation(
        'Trade',
        'Some of the wood and stone stores are exchanged for gold.',
      ),
      VillageEventOptionTranslation('Refuse', 'The caravan moves on.'),
    ],
  ),
  'deserter': VillageEventTranslation(
    'Deserter Seeking Shelter',
    'A runaway soldier asks to join the barracks in exchange for shelter.',
    [
      VillageEventOptionTranslation(
        'Accept',
        'The deserter strengthens the ranks, though some villagers are unhappy about it.',
      ),
      VillageEventOptionTranslation('Turn Away', 'The deserter disappears into the forest.'),
    ],
  ),

  // ============================================================
  // SPRING - 5 positive, 5 negative
  // ============================================================
  'spring_pos_1': VillageEventTranslation(
    'Blooming Orchards',
    'The orchards are covered in blossoms, promising a bountiful apple harvest.',
  ),
  'spring_pos_2': VillageEventTranslation(
    'Meltwater Fills the Wells',
    'Melting snow has filled the wells with clean water.',
  ),
  'spring_pos_3': VillageEventTranslation(
    'Successful Sowing',
    'Grain sown in the fertile spring soil sprouts quickly.',
  ),
  'spring_pos_4': VillageEventTranslation(
    'Return of the Birds',
    "The birds' return after winter is a good omen and lifts spirits in the village.",
  ),
  'spring_pos_5': VillageEventTranslation(
    'Spring Fair',
    'The first fair after winter brings unexpected earnings.',
  ),
  'spring_neg_1': VillageEventTranslation(
    'Spring Flood',
    'Meltwater floods have soaked part of the wood stores kept low by the river.',
  ),
  'spring_neg_2': VillageEventTranslation(
    'Spring Colds',
    'Changeable weather has laid half the village low with colds.',
  ),
  'spring_neg_3': VillageEventTranslation(
    'Snail Plague',
    'Snails have attacked the young crops right after sowing.',
  ),
  'spring_neg_4': VillageEventTranslation(
    'Landslide',
    'Ground softened by meltwater gave way, destroying part of the stone stores.',
  ),
  'spring_neg_5': VillageEventTranslation(
    'Spring Gale',
    'A strong wind tore the roof off one of the sheds storing grass.',
  ),

  // ============================================================
  // SUMMER - 5 positive, 5 negative
  // ============================================================
  'summer_pos_1': VillageEventTranslation(
    'Golden Harvest',
    'Hot, sunny days have sped up the ripening of the grain.',
  ),
  'summer_pos_2': VillageEventTranslation(
    'Fruitful Orchard',
    'Summer has blessed the orchard with exceptionally sweet apples.',
  ),
  'summer_pos_3': VillageEventTranslation(
    'Summer Fair',
    'Traveling merchants are happy to pay a good price for the summer stores.',
  ),
  'summer_pos_4': VillageEventTranslation(
    'Lush Pastures',
    'Warm days have the grass growing like weeds.',
  ),
  'summer_pos_5': VillageEventTranslation(
    'Evening Bonfires',
    'Warm summer evenings are perfect for gathering around the bonfire.',
  ),
  'summer_neg_1': VillageEventTranslation(
    'Heat Wave',
    'Record heat has dried up part of the water stores.',
  ),
  'summer_neg_2': VillageEventTranslation(
    'Sunburn',
    "Working under the blazing sun has taken a toll on the villagers' health.",
  ),
  'summer_neg_3': VillageEventTranslation(
    'Dry Grass Fire',
    'A spark from a bonfire consumed a stretch of sun-parched grass.',
  ),
  'summer_neg_4': VillageEventTranslation(
    'Locust Plague',
    'A swarm of locusts swept through the grain fields.',
  ),
  'summer_neg_5': VillageEventTranslation(
    'Cracked Tool Handles',
    'The heat dried out and cracked the wooden tool handles.',
  ),

  // ============================================================
  // AUTUMN - 5 positive, 5 negative
  // ============================================================
  'autumn_pos_1': VillageEventTranslation(
    'Fruit Harvest',
    'The fruit trees have yielded an exceptionally sweet crop.',
  ),
  'autumn_pos_2': VillageEventTranslation(
    'Autumn Market',
    'The autumn market draws crowds of merchants from the area.',
  ),
  'autumn_pos_3': VillageEventTranslation(
    'Winter Stores',
    'The villagers efficiently gather supplies ahead of the coming winter.',
  ),
  'autumn_pos_4': VillageEventTranslation(
    'Indian Summer',
    "The warm, sunny days of Indian summer lift everyone's spirits.",
  ),
  'autumn_pos_5': VillageEventTranslation(
    'Mushroom Picking',
    'The forests, damp from the rain, are rich with mushrooms and herbs.',
  ),
  'autumn_neg_1': VillageEventTranslation(
    'Autumn Downpours',
    'Heavy autumn rains soaked and ruined part of the wood stores.',
  ),
  'autumn_neg_2': VillageEventTranslation(
    'Early Frost',
    'Unexpected frost has damaged part of the orchard.',
  ),
  'autumn_neg_3': VillageEventTranslation(
    'Muddy Roads',
    'Waterlogged roads are hampering trade with neighboring villages.',
  ),
  'autumn_neg_4': VillageEventTranslation(
    'Rotting Leaves',
    'Rotting leaves have contaminated part of the fodder stores.',
  ),
  'autumn_neg_5': VillageEventTranslation(
    'Autumn Blues',
    "The shortening days are weighing on the villagers' spirits.",
  ),

  // ============================================================
  // WINTER - 5 positive, 5 negative
  // ============================================================
  'winter_pos_1': VillageEventTranslation(
    'Glittering Winter',
    'The picturesque, sparkling snow lifts spirits despite the cold.',
  ),
  'winter_pos_2': VillageEventTranslation(
    'Successful Hunt',
    'The winter hunt has brought in more game than usual.',
  ),
  'winter_pos_3': VillageEventTranslation(
    'Carolers',
    'Carolers visiting the village bring joy and a sense of community.',
  ),
  'winter_pos_4': VillageEventTranslation(
    'Ice on the River',
    'The frozen river makes it easier to transport heavy stone.',
  ),
  'winter_pos_5': VillageEventTranslation(
    'Mild Winter',
    'An unusually mild winter has spared the grain stores.',
  ),
  'winter_neg_1': VillageEventTranslation(
    'Freezing Night',
    'A hard frost has frozen part of the wells.',
  ),
  'winter_neg_2': VillageEventTranslation(
    'Snowstorm',
    'A blizzard tore the roof off the firewood warehouse.',
  ),
  'winter_neg_3': VillageEventTranslation(
    'Winter Flu',
    'The flu spreads quickly in the winter cold.',
  ),
  'winter_neg_4': VillageEventTranslation(
    'Wolves by the Farmstead',
    'Hungry wolves are prowling around the farmsteads, unsettling the villagers.',
  ),
  'winter_neg_5': VillageEventTranslation(
    'Cracked Well Lining',
    'Frost has cracked the stone well linings - they need repair.',
  ),

  // ============================================================
  // GENERAL (any season) - positive (part 1: general_pos_1..23)
  // ============================================================
  'general_pos_1': VillageEventTranslation(
    'Lucky Find',
    'Someone found coins lost long ago.',
  ),
  'general_pos_2': VillageEventTranslation(
    'Good Omen',
    'The signs foretell good fortune for the whole village.',
  ),
  'general_pos_3': VillageEventTranslation(
    "The Baker's New Recipe",
    'The baker has refined his recipe, using grain more efficiently.',
  ),
  'general_pos_4': VillageEventTranslation(
    'Skilled Blacksmith',
    'The blacksmith has streamlined production, saving on materials.',
  ),
  'general_pos_5': VillageEventTranslation(
    'Skilled Carpenter',
    'The carpenter manages wood efficiently, leaving a surplus.',
  ),
  'general_pos_6': VillageEventTranslation(
    'Clean Spring',
    'A new, clean spring has been discovered on the edge of the village.',
  ),
  'general_pos_7': VillageEventTranslation(
    'Abundant Orchard',
    'The fruit trees have yielded far beyond expectations.',
  ),
  'general_pos_8': VillageEventTranslation(
    'Lush Grass',
    'The meadows around the village have grown thick with healthy grass.',
  ),
  'general_pos_9': VillageEventTranslation(
    'Village Wedding',
    'A lively wedding lifts the spirits of every villager.',
  ),
  'general_pos_10': VillageEventTranslation(
    'Successful Trade',
    'A successful deal with a passing merchant brings a profit.',
  ),
  'general_pos_11': VillageEventTranslation(
    'New Building Idea',
    'The carpenter has proposed a more economical building method.',
  ),
  'general_pos_12': VillageEventTranslation(
    'Fertile Soil',
    'The soil in the fields has proven exceptionally fertile this year.',
  ),
  'general_pos_13': VillageEventTranslation(
    'Discovered Treasure',
    'Children playing outside the village found a buried treasure.',
  ),
  'general_pos_14': VillageEventTranslation(
    'Hospitality Pays Off',
    'Travelers appreciate the hospitality and leave small gifts.',
  ),
  'general_pos_15': VillageEventTranslation(
    'Efficient Work Organization',
    'Better work organization speeds up stone quarrying.',
  ),
  'general_pos_16': VillageEventTranslation(
    'Rain Right on Time',
    'Rain fell exactly when the fields needed it most.',
  ),
  'general_pos_17': VillageEventTranslation(
    'Successful Breeding',
    'Livestock breeding yields better results than usual.',
  ),
  'general_pos_18': VillageEventTranslation(
    'Vigilant Guards',
    "The guards' vigilance scared off suspicious vagrants.",
  ),
  'general_pos_19': VillageEventTranslation(
    'Joyful Children',
    'The laughter of children playing in the streets lifts spirits.',
  ),
  'general_pos_20': VillageEventTranslation(
    'Honest Tax Collector',
    'The tax collector settled accounts with the village honestly.',
  ),
  'general_pos_21': VillageEventTranslation(
    'Solid Foundations',
    'A new foundation-building method saves on stone.',
  ),
  'general_pos_22': VillageEventTranslation(
    'New Well',
    'The villagers worked together to dig an additional well.',
  ),
  'general_pos_23': VillageEventTranslation(
    'Support from Neighbors',
    'A neighboring village has sent a gift of grain.',
  ),
};
