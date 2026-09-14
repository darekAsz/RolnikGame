import 'package:flutter/material.dart';

import '../models/resource_type.dart';
import '../widgets/resource_icon.dart';

/// Ekran sklepu - na razie jedyna oferta to trwałe dokupienie dodatkowych
/// ruchów na planszy zbiorów, płatne złotem. Koszt rośnie z każdym zakupem.
class ShopView extends StatelessWidget {
  final int baseMoves;
  final int extraMoves;
  final int maxTotalMoves;
  final int goldAvailable;
  final int nextCost;
  final VoidCallback onBuy;
  final int autoMatchTier;
  final int autoMatchTier1Cost;
  final int autoMatchTier2Cost;
  final VoidCallback onBuyAutoMatchTier1;
  final VoidCallback onBuyAutoMatchTier2;

  const ShopView({
    super.key,
    required this.baseMoves,
    required this.extraMoves,
    required this.maxTotalMoves,
    required this.goldAvailable,
    required this.nextCost,
    required this.onBuy,
    required this.autoMatchTier,
    required this.autoMatchTier1Cost,
    required this.autoMatchTier2Cost,
    required this.onBuyAutoMatchTier1,
    required this.onBuyAutoMatchTier2,
  });

  @override
  Widget build(BuildContext context) {
    final totalMoves = baseMoves + extraMoves;
    final atMax = totalMoves >= maxTotalMoves;
    final canAfford = !atMax && goldAvailable >= nextCost;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sklep', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Wydaj złoto, żeby na stałe zwiększyć liczbę ruchów na planszy zbiorów.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.bolt, size: 30, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ruchy na tydzień', style: Theme.of(context).textTheme.labelMedium),
                      Text(
                        '$totalMoves / $maxTotalMoves',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Baza $baseMoves + dokupione $extraMoves',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: resourceIconAsset(ResourceType.coin.assetPath, size: 32),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '+1 ruch na tydzień (na stałe)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Masz: $goldAvailable złota'),
                if (atMax)
                  const Text(
                    'Osiągnięto maksymalną liczbę ruchów.',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
                  )
                else
                  Text(
                    'Koszt: $nextCost złota',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canAfford ? const Color(0xFF2F9E57) : const Color(0xFFC0392B),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: canAfford ? onBuy : null,
                    child: const Text('Kup'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _AutoMatchTierCard(
            icon: Icons.auto_awesome,
            title: 'Automatyczne usuwanie czwórek',
            description: 'Domyślnie kafelki ułożone w ciąg zostają na planszy, dopóki '
                'nie zbierzesz ich ręcznie. To ulepszenie sprawia, że ciągi 4+ znikają '
                'automatycznie. Nie działa w starciach z bossami - tam liczenie zawsze '
                'zostaje ręczne.',
            unlocked: autoMatchTier >= 1,
            locked: false,
            lockedText: null,
            goldAvailable: goldAvailable,
            cost: autoMatchTier1Cost,
            onBuy: onBuyAutoMatchTier1,
          ),
          const SizedBox(height: 16),
          _AutoMatchTierCard(
            icon: Icons.auto_awesome_motion,
            title: 'Ulepszenie: automatyczne usuwanie trójek',
            description: 'Kolejny stopień - po tym ulepszeniu automatycznie znikają '
                'też ciągi złożone tylko z 3 kafelków. Tak samo jak poprzedni stopień, '
                'nie działa w starciach z bossami.',
            unlocked: autoMatchTier >= 2,
            locked: autoMatchTier < 1,
            lockedText: 'Wymaga: automatyczne usuwanie czwórek',
            goldAvailable: goldAvailable,
            cost: autoMatchTier2Cost,
            onBuy: onBuyAutoMatchTier2,
          ),
        ],
      ),
    );
  }
}

/// Karta jednego stopnia ulepszenia automatycznego usuwania ciągów - może
/// być zablokowana (wymaga poprzedniego stopnia), dostępna do kupienia albo
/// już odblokowana.
class _AutoMatchTierCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;
  final bool locked;
  final String? lockedText;
  final int goldAvailable;
  final int cost;
  final VoidCallback onBuy;

  const _AutoMatchTierCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
    required this.locked,
    required this.lockedText,
    required this.goldAvailable,
    required this.cost,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = !locked && !unlocked && goldAvailable >= cost;
    return Opacity(
      opacity: locked ? 0.6 : 1,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  locked ? Icons.lock : icon,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            if (unlocked)
              const Text(
                'Odblokowane',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F9E57)),
              )
            else if (locked)
              Text(
                lockedText ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC0392B)),
              )
            else ...[
              Text('Masz: $goldAvailable złota'),
              Text(
                'Koszt: $cost złota',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: canAfford ? const Color(0xFF2F9E57) : const Color(0xFFC0392B),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canAfford ? onBuy : null,
                  child: const Text('Kup'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
