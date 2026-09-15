import 'dart:math';

import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../services/area_storage.dart';
import '../services/comic_storage.dart';
import '../services/discovery_storage.dart';
import '../services/experience_storage.dart';
import '../services/game_progress_storage.dart';
import '../services/population_storage.dart';
import '../services/resource_storage.dart';
import '../services/shop_storage.dart';
import '../services/stats_storage.dart';
import '../services/story_progress_storage.dart';
import '../services/village_building_storage.dart';
import '../services/village_event_storage.dart';
import 'home_shell.dart';
import 'tutorial_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _loaded = false;
  bool _hasSave = false;

  // Bardzo powolny "Ken Burns" (delikatne dosunięcie tła) + osobny,
  // szybszy zegar dla mgły/pyłków unoszących się nad wioską - rozdzielone,
  // żeby dało się je dowolnie retuszować (prędkość, zasięg) niezależnie.
  late final AnimationController _zoomController;
  late final AnimationController _ambienceController;

  @override
  void initState() {
    super.initState();
    _load();
    _zoomController = AnimationController(vsync: this, duration: const Duration(seconds: 26))
      ..repeat(reverse: true);
    _ambienceController = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _zoomController.dispose();
    _ambienceController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final progress = await GameProgressStorage.load();
    if (!mounted) return;
    setState(() {
      _hasSave = progress.hasSave;
      _loaded = true;
    });
  }

  // Potwierdzenie tylko gdy jest co nadpisać - świeży telefon bez żadnego
  // zapisu (_hasSave == false) nie musi pytać, bo "Nowa gra" i tak nic nie
  // niszczy w tym wypadku.
  Future<void> _onNewGamePressed() async {
    if (_hasSave) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.splashNewGameDialogTitle),
            content: Text(l10n.splashNewGameDialogContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(l10n.splashCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.splashOverwriteAndStart),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;
    }
    if (!mounted) return;
    await _newGame();
  }

  Future<void> _newGame() async {
    await ResourceStorage.reset();
    await GameProgressStorage.startNewGame();
    await StatsStorage.reset();
    await AreaStorage.reset();
    await ShopStorage.reset();
    await VillageBuildingStorage.reset();
    // Wioska odziedziczona po Antonim nie jest pusta - stoją w niej już dwa
    // domy, ale zaniedbane od lat i nie dające bonusu do populacji, dopóki
    // gracz ich nie odbuduje (patrz HomeShell._onTapExtraHouse). Ratusz
    // pozostaje niezbudowany - na jego miejscu stoi zwykły dom (patrz
    // rysowanie działki Ratusza w village_board.dart), a "budowa" Ratusza to
    // w praktyce zastąpienie go prawdziwym budynkiem.
    await VillageBuildingStorage.setExtraHouseBuilt(0, true);
    await VillageBuildingStorage.setExtraHouseActive(0, false);
    await VillageBuildingStorage.setExtraHouseBuilt(1, true);
    await VillageBuildingStorage.setExtraHouseActive(1, false);
    await VillageEventStorage.reset();
    await PopulationStorage.reset();
    await DiscoveryStorage.reset();
    await StoryProgressStorage.reset();
    await ComicStorage.reset();
    await ExperienceStorage.reset();
    final progress = await GameProgressStorage.load();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            progress.tutorialSeen ? const HomeShell() : const TutorialScreen(),
      ),
    );
  }

  void _continueGame() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _zoomController,
            builder: (context, child) {
              final scale = 1.0 + 0.06 * Curves.easeInOut.transform(_zoomController.value);
              return Transform.scale(scale: scale, child: child);
            },
            child: Image.asset('assets/ui/splash.webp', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _ambienceController,
                builder: (context, _) => CustomPaint(painter: _SplashAmbiencePainter(_ambienceController.value)),
              ),
            ),
          ),
          // Ciemniejsze u dołu (czytelność tekstu/przycisków nad zabudową
          // wioski), niemal przezroczyste u góry (nie zasłania nieba/kruka).
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0x261A1410), Color(0xE61A1410)],
                  stops: [0.0, 0.5, 0.92],
                ),
              ),
            ),
          ),
          if (!_loaded)
            const Center(child: CircularProgressIndicator())
          else
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      l10n.splashTitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: const [Shadow(color: Colors.black87, blurRadius: 12)],
                          ),
                    ),
                    Text(
                      l10n.splashSubtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                            letterSpacing: 1.5,
                            shadows: const [Shadow(color: Colors.black87, blurRadius: 8)],
                          ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: 220,
                      child: FilledButton(
                        onPressed: _onNewGamePressed,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(l10n.splashNewGame),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 220,
                      child: OutlinedButton(
                        onPressed: _hasSave ? _continueGame : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(l10n.splashContinue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Delikatna, bezustannie pętląca się warstwa "życia" nad statyczną
/// ilustracją ekranu startowego - kilka smug mgły dryfujących nisko nad
/// wioską i garstka unoszących się drobin/iskier. Celowo bez próby animacji
/// samego kruka (jedna statyczna ilustracja nie udźwignie wiarygodnego
/// machania skrzydłem bez osobnej grafiki) - to podmienia ambicję na coś,
/// co faktycznie wygląda dobrze przy pojedynczym, nieruchomym rysunku.
class _SplashAmbiencePainter extends CustomPainter {
  final double t;

  _SplashAmbiencePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    _drawMist(canvas, size);
    _drawMotes(canvas, size);
  }

  void _drawMist(Canvas canvas, Size size) {
    final bandTop = size.height * 0.42;
    final bandHeight = size.height * 0.28;
    const blobCount = 4;
    for (var i = 0; i < blobCount; i++) {
      final phase = (t + i / blobCount) % 1.0;
      final dx = (phase * 1.3 - 0.15) * size.width;
      final dy = bandTop + bandHeight * (0.15 + 0.7 * ((i * 37) % 100) / 100);
      final radiusX = size.width * 0.32;
      final radiusY = bandHeight * 0.4;
      final fade = sin(phase * pi);
      final opacity = 0.05 + 0.05 * fade.clamp(0.0, 1.0);
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withValues(alpha: opacity), Colors.white.withValues(alpha: 0)],
        ).createShader(Rect.fromCenter(center: Offset(dx, dy), width: radiusX * 2, height: radiusY * 2));
      canvas.drawOval(Rect.fromCenter(center: Offset(dx, dy), width: radiusX * 2, height: radiusY * 2), paint);
    }
  }

  void _drawMotes(Canvas canvas, Size size) {
    final random = Random(7);
    final paint = Paint()..color = const Color(0xFFE9C77A);
    const moteCount = 10;
    for (var i = 0; i < moteCount; i++) {
      final seedX = random.nextDouble();
      final speed = 0.6 + random.nextDouble() * 0.5;
      final phase = (t * speed + i / moteCount) % 1.0;
      final dy = size.height * (0.85 - phase * 0.55);
      final sway = sin((phase * 2 * pi) + i) * size.width * 0.02;
      final dx = seedX * size.width + sway;
      final radius = 1.0 + random.nextDouble() * 1.4;
      final opacity = (sin(phase * pi)).clamp(0.0, 1.0) * 0.5;
      canvas.drawCircle(Offset(dx, dy), radius, paint..color = const Color(0xFFE9C77A).withValues(alpha: opacity));
    }
  }

  @override
  bool shouldRepaint(covariant _SplashAmbiencePainter oldDelegate) => oldDelegate.t != t;
}
