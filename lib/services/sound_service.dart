import 'package:audioplayers/audioplayers.dart';

/// Odtwarza krótkie efekty dźwiękowe gry przy użyciu małej, stałej puli
/// odtwarzaczy na dźwięk (zamiast tworzenia nowej instancji [AudioPlayer]
/// za każdym razem). Tworzenie/niszczenie odtwarzacza to kosztowna operacja
/// na natywnym zasobie audio - robione setki razy w trakcie jednej sesji
/// gry (każde zbieranie, kaskada dopasowań, wybuch bomby) prowadziło do
/// wyczerpania natywnych zasobów dźwiękowych (cichnący dźwięk) i spadków
/// płynności (przycinanie) po dłuższej grze. Pula odtwarzaczy jest
/// tworzona raz i używana wielokrotnie przez cały czas działania aplikacji.
class SoundService {
  static const _poolSize = 4;

  static final List<AudioPlayer> _collectPool = _buildPool();
  static final List<AudioPlayer> _bombPool = _buildPool();
  static int _collectIndex = 0;
  static int _bombIndex = 0;

  static List<AudioPlayer> _buildPool() {
    return List.generate(_poolSize, (_) {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      return player;
    });
  }

  static Future<void> _play(List<AudioPlayer> pool, int index, String assetPath) async {
    final player = pool[index];
    await player.stop();
    await player.play(AssetSource(assetPath), mode: PlayerMode.lowLatency);
  }

  static void playCollect() {
    _play(_collectPool, _collectIndex, 'sounds/collect.wav');
    _collectIndex = (_collectIndex + 1) % _poolSize;
  }

  static void playBombExplosion() {
    _play(_bombPool, _bombIndex, 'sounds/bomb.wav');
    _bombIndex = (_bombIndex + 1) % _poolSize;
  }
}
