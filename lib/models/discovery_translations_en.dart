import 'discovery.dart';

/// Angielskie tłumaczenia treści `kDiscoveries` (patrz `discovery.dart`),
/// kluczowane przez `DiscoveryId`. Brakujący wpis = ekran bezpiecznie spada
/// na polski oryginał (patrz `DiscoveryLocalization` w `discovery.dart`).
class DiscoveryTranslation {
  final String name;
  final String description;

  const DiscoveryTranslation(this.name, this.description);
}

const Map<DiscoveryId, DiscoveryTranslation> kDiscoveriesEn = {
  DiscoveryId.moves1: DiscoveryTranslation(
    'Basics of Agronomy',
    '+1 to the base number of moves on the harvest board.',
  ),
  DiscoveryId.moves2: DiscoveryTranslation(
    'Advanced Agronomy',
    'One more +1 to the base number of moves (+2 total).',
  ),
  DiscoveryId.workers1: DiscoveryTranslation(
    'Worker Management I',
    'Unlocks assigning 1 worker to buildings that grant a bonus.',
  ),
  DiscoveryId.workers2: DiscoveryTranslation(
    'Worker Management II',
    'Raises the limit to 2 workers per building.',
  ),
  DiscoveryId.storageBonus: DiscoveryTranslation(
    'Bookkeeping',
    'An extra +150 to the storage limit for every resource, independent of the Warehouse.',
  ),
  DiscoveryId.cartography: DiscoveryTranslation(
    'Cartography',
    "Adds an extra column to the harvest board, independent of the village's surroundings.",
  ),
  DiscoveryId.ruralMedicine: DiscoveryTranslation(
    'Rural Medicine',
    'Famine no longer kills villagers - only the morale penalty remains.',
  ),
  DiscoveryId.foodEfficiency: DiscoveryTranslation(
    'Reserve Agronomy',
    'Villagers consume less grain (1 grain feeds more people).',
  ),
  DiscoveryId.diplomacy: DiscoveryTranslation(
    'Diplomacy',
    'Improves the exchange rate at the Market - one of three independent '
        'upgrades toward the best possible rate (alongside Market level and assigned workers).',
  ),
  DiscoveryId.militarySmithing: DiscoveryTranslation(
    'Military Smithing',
    "Increases every soldier's strength by +1, independent of Barracks level.",
  ),
  DiscoveryId.fastGrowth: DiscoveryTranslation(
    'Faster Growth',
    'Doubles the population growth rate (based on village morale), with enough food.',
  ),
  DiscoveryId.weatherForecast: DiscoveryTranslation(
    'Meteorology',
    'Increases the chance of a positive (instead of negative) random event.',
  ),
  DiscoveryId.earlyJoker: DiscoveryTranslation(
    'Lucky Streak',
    'A wild joker now appears from a chain of 4 tiles (instead of 5).',
  ),
  DiscoveryId.earlyBomb: DiscoveryTranslation(
    'Explosive Fervor',
    'A bomb now appears from a chain of 5 tiles (instead of 6).',
  ),
};
