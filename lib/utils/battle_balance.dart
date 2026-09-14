/// Mnożnik wagi losowania surowca-celu w starciach z bossami (Miecz/Tarcza
/// - zależne od bezpieczeństwa wioski; Prawda/Dowód - zależne od morale).
/// Słabszy wskaźnik = rzadszy surowiec na planszy (min. 30% normalnej wagi
/// przy wskaźniku 0), ale nigdy nie znika całkiem (maks. 100% przy pełnym
/// wskaźniku) - cel etapu ma zawsze dać się ukończyć, tylko wolniej.
double battleWeightMultiplier(num indicator, {num max = 100}) {
  final ratio = (indicator / max).clamp(0.0, 1.0);
  return 0.3 + 0.7 * ratio;
}
