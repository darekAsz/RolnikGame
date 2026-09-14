import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

enum BuildingKind {
  ratusz,
  palisade,
  sklep,
  karczma,
  dom,
  kuznia,
  spichlerz,
  piekarnia,
  tartak,
  studnia,
  browar,
  kaplica,
  szkola,
  rynek,
  magazyn,
  kamieniarz,
  koszary,
}

/// Piętnaście nowych, budowalnych budynków wioski (poza Ratuszem/Palisadą).
/// Wizualnie na razie generyczny placeholder (kolor + ikona) - docelowy,
/// bardziej rozbudowany wygląd zostanie wybrany osobno przez gracza.
const kExtraBuildingKinds = [
  BuildingKind.sklep,
  BuildingKind.karczma,
  BuildingKind.dom,
  BuildingKind.kuznia,
  BuildingKind.spichlerz,
  BuildingKind.piekarnia,
  BuildingKind.tartak,
  BuildingKind.studnia,
  BuildingKind.browar,
  BuildingKind.kaplica,
  BuildingKind.szkola,
  BuildingKind.rynek,
  BuildingKind.magazyn,
  BuildingKind.kamieniarz,
  BuildingKind.koszary,
];

/// Wszystkie 17 rodzajów budynków (Ratusz/Palisada + 15 dodatkowych) - do
/// iterowania po stanie "rozbudowany" (poziom 2), który mają wszystkie.
const kAllBuildingKinds = [
  BuildingKind.ratusz,
  BuildingKind.palisade,
  ...kExtraBuildingKinds,
];

/// Dziewięć "standardowych" działek przy końcach ścieżek - większe budynki.
const kStandardBuildingKinds = [
  BuildingKind.sklep,
  BuildingKind.karczma,
  BuildingKind.rynek,
  BuildingKind.magazyn,
  BuildingKind.kuznia,
  BuildingKind.browar,
  BuildingKind.kaplica,
  BuildingKind.szkola,
  BuildingKind.koszary,
];

/// Sześć mniejszych działek pod domy/produkcję.
const kSmallBuildingKinds = [
  BuildingKind.dom,
  BuildingKind.spichlerz,
  BuildingKind.piekarnia,
  BuildingKind.tartak,
  BuildingKind.studnia,
  BuildingKind.kamieniarz,
];

/// Budynki, które mają gotowy, wyrenderowany obrazek (zamiast generycznego
/// placeholdera) - patrz [BuildingImageCache].
const kBuildingImageAssets = {
  BuildingKind.kamieniarz: 'assets/buildings/kamieniarz.webp',
  BuildingKind.dom: 'assets/buildings/dom.webp',
  BuildingKind.sklep: 'assets/buildings/sklep.webp',
  BuildingKind.rynek: 'assets/buildings/rynek.webp',
  BuildingKind.studnia: 'assets/buildings/studnia.webp',
  BuildingKind.ratusz: 'assets/buildings/ratusz.webp',
  BuildingKind.browar: 'assets/buildings/browar.webp',
  BuildingKind.kaplica: 'assets/buildings/kaplica.webp',
  BuildingKind.karczma: 'assets/buildings/karczma.webp',
  BuildingKind.koszary: 'assets/buildings/koszary.webp',
  BuildingKind.kuznia: 'assets/buildings/kuznia.webp',
  BuildingKind.magazyn: 'assets/buildings/magazyn.webp',
  BuildingKind.piekarnia: 'assets/buildings/piekarnia.webp',
  BuildingKind.spichlerz: 'assets/buildings/spichlerz.webp',
  BuildingKind.szkola: 'assets/buildings/szkola.webp',
  BuildingKind.tartak: 'assets/buildings/tartak.webp',
};

/// Dodatkowy mnożnik rozmiaru dla obrazków, których scena jest większa/bardziej
/// złożona niż zwykła pojedyncza chata (np. Kamieniarz: chata + piec + warsztat).
const kBuildingImageScale = {
  BuildingKind.kamieniarz: 1.1,
};

/// Osobny obrazek dla budynków rozbudowanych do poziomu 2 - budynki bez
/// wpisu tutaj dalej używają jednego obrazka z [kBuildingImageAssets]
/// niezależnie od poziomu.
const kBuildingImageAssetsLevel2 = {
  BuildingKind.kamieniarz: 'assets/buildings/kamieniarz_2.webp',
  BuildingKind.dom: 'assets/buildings/dom_2.webp',
  BuildingKind.sklep: 'assets/buildings/sklep_2.webp',
  BuildingKind.kaplica: 'assets/buildings/kaplica_2.webp',
  BuildingKind.studnia: 'assets/buildings/studnia_2.webp',
  BuildingKind.szkola: 'assets/buildings/szkola_2.webp',
  BuildingKind.tartak: 'assets/buildings/tartak_2.webp',
  BuildingKind.spichlerz: 'assets/buildings/spichlerz_2.webp',
  BuildingKind.piekarnia: 'assets/buildings/piekarnia_2.webp',
  BuildingKind.kuznia: 'assets/buildings/kuznia_2.webp',
  BuildingKind.browar: 'assets/buildings/browar_2.webp',
  BuildingKind.rynek: 'assets/buildings/rynek_2.webp',
  BuildingKind.magazyn: 'assets/buildings/magazyn_2.webp',
  BuildingKind.koszary: 'assets/buildings/koszary_2.webp',
  BuildingKind.karczma: 'assets/buildings/karczma_2.webp',
  BuildingKind.ratusz: 'assets/buildings/ratusz_2.webp',
};

/// Ładuje i cache'uje gotowe obrazki budynków (renderowane z modeli 3D) jako
/// [ui.Image], żeby CustomPainter mógł je narysować bezpośrednio na canvasie.
class BuildingImageCache {
  static final Map<BuildingKind, ui.Image> _cache = {};
  static final Map<BuildingKind, ui.Image> _cacheLevel2 = {};
  static final Set<BuildingKind> _loading = {};
  static int epoch = 0;

  /// [upgraded] wybiera obrazek poziomu 2, jeśli dany budynek go ma (patrz
  /// [kBuildingImageAssetsLevel2]) - w przeciwnym razie zawsze zwraca
  /// obrazek poziomu 1.
  static ui.Image? get(BuildingKind kind, {bool upgraded = false}) {
    if (upgraded) {
      final level2 = _cacheLevel2[kind];
      if (level2 != null) return level2;
    }
    return _cache[kind];
  }

  static Future<void> preloadAll() async {
    for (final kind in kBuildingImageAssets.keys) {
      await _preload(kind, kBuildingImageAssets[kind]!, _cache);
    }
    for (final kind in kBuildingImageAssetsLevel2.keys) {
      await _preload(kind, kBuildingImageAssetsLevel2[kind]!, _cacheLevel2);
    }
  }

  static Future<void> _preload(
    BuildingKind kind,
    String path,
    Map<BuildingKind, ui.Image> cache,
  ) async {
    final loadingKey = kind;
    if (cache.containsKey(kind) || _loading.contains(loadingKey)) return;
    _loading.add(loadingKey);
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    cache[kind] = frame.image;
    _loading.remove(loadingKey);
    epoch++;
  }
}

/// Osobny, jednoobrazkowy cache dla zaniedbanego (ale wciąż zamieszkanego)
/// wyglądu dodatkowych domów przed odbudową - nie pasuje do [BuildingKind]
/// (to stan JEDNEGO konkretnego budynku - Dom - a nie osobny rodzaj
/// budynku), więc nie warto go wciskać do [BuildingImageCache].
class _DecrepitHouseImageCache {
  static ui.Image? _image;
  static bool _loading = false;

  static ui.Image? get image => _image;

  static Future<void> preload() async {
    if (_image != null || _loading) return;
    _loading = true;
    final data = await rootBundle.load('assets/buildings/dom_zaniedbany.webp');
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _image = frame.image;
    _loading = false;
    BuildingImageCache.epoch++;
  }
}

extension BuildingKindStyle on BuildingKind {
  String get label {
    switch (this) {
      case BuildingKind.ratusz:
        return 'Ratusz';
      case BuildingKind.palisade:
        return 'Palisada';
      case BuildingKind.sklep:
        return 'Sklep';
      case BuildingKind.karczma:
        return 'Karczma';
      case BuildingKind.dom:
        return 'Dom';
      case BuildingKind.kuznia:
        return 'Kuźnia';
      case BuildingKind.spichlerz:
        return 'Spichlerz';
      case BuildingKind.piekarnia:
        return 'Piekarnia';
      case BuildingKind.tartak:
        return 'Tartak';
      case BuildingKind.studnia:
        return 'Studnia';
      case BuildingKind.browar:
        return 'Browar';
      case BuildingKind.kaplica:
        return 'Kaplica';
      case BuildingKind.szkola:
        return 'Uczelnia';
      case BuildingKind.rynek:
        return 'Rynek';
      case BuildingKind.magazyn:
        return 'Magazyn';
      case BuildingKind.kamieniarz:
        return 'Kamieniarz';
      case BuildingKind.koszary:
        return 'Koszary';
    }
  }

  IconData get icon {
    switch (this) {
      case BuildingKind.sklep:
        return Icons.storefront;
      case BuildingKind.karczma:
        return Icons.local_bar;
      case BuildingKind.dom:
        return Icons.house;
      case BuildingKind.kuznia:
        return Icons.local_fire_department;
      case BuildingKind.spichlerz:
        return Icons.grain;
      case BuildingKind.piekarnia:
        return Icons.bakery_dining;
      case BuildingKind.tartak:
        return Icons.carpenter;
      case BuildingKind.studnia:
        return Icons.water_drop;
      case BuildingKind.browar:
        return Icons.sports_bar;
      case BuildingKind.kaplica:
        return Icons.church;
      case BuildingKind.szkola:
        return Icons.school;
      case BuildingKind.rynek:
        return Icons.shopping_cart;
      case BuildingKind.magazyn:
        return Icons.warehouse;
      case BuildingKind.kamieniarz:
        return Icons.construction;
      case BuildingKind.koszary:
        return Icons.shield;
      default:
        return Icons.home_work;
    }
  }

  Color get color {
    switch (this) {
      case BuildingKind.sklep:
        return const Color(0xFFD4A017);
      case BuildingKind.karczma:
        return const Color(0xFF8B5A2B);
      case BuildingKind.dom:
        return const Color(0xFFD8CBAE);
      case BuildingKind.kuznia:
        return const Color(0xFF5A5A5A);
      case BuildingKind.spichlerz:
        return const Color(0xFFC9A227);
      case BuildingKind.piekarnia:
        return const Color(0xFFC48A4D);
      case BuildingKind.tartak:
        return const Color(0xFF6E8B3D);
      case BuildingKind.studnia:
        return const Color(0xFF3A8DDE);
      case BuildingKind.browar:
        return const Color(0xFF9C6B36);
      case BuildingKind.kaplica:
        return const Color(0xFFB8C4D9);
      case BuildingKind.szkola:
        return const Color(0xFF4A6FA5);
      case BuildingKind.rynek:
        return const Color(0xFFE0803D);
      case BuildingKind.magazyn:
        return const Color(0xFF7A6A52);
      case BuildingKind.kamieniarz:
        return const Color(0xFF8A8D91);
      case BuildingKind.koszary:
        return const Color(0xFF6B3A3A);
      default:
        return const Color(0xFFD8CBAE);
    }
  }
}

/// Widok wioski: teren, mur (jeśli zbudowany), drogi i sloty budowlane.
/// Ratusz i Palisada mają dedykowane miejsca; pozostałe 15 budynków zajmuje
/// pozostałe działki wzdłuż ścieżek (patrz [kStandardBuildingKinds] /
/// [kSmallBuildingKinds]).
class VillageBoard extends StatefulWidget {
  final bool ratuszBuilt;
  final bool palisadeBuilt;
  final Map<BuildingKind, bool> builtMap;
  final List<bool> extraHousesBuilt;
  final List<bool> extraHousesActive;
  final Map<BuildingKind, int> workers;
  final Map<BuildingKind, bool> upgradedMap;
  final VoidCallback onTapRatusz;
  final VoidCallback onTapPalisade;
  final void Function(BuildingKind kind) onTapBuilding;
  final void Function(int index) onTapExtraHouse;
  final VoidCallback onTapEmptyPlot;

  const VillageBoard({
    super.key,
    required this.ratuszBuilt,
    required this.palisadeBuilt,
    required this.builtMap,
    required this.extraHousesBuilt,
    this.extraHousesActive = const [],
    this.workers = const {},
    this.upgradedMap = const {},
    required this.onTapRatusz,
    required this.onTapPalisade,
    required this.onTapBuilding,
    required this.onTapExtraHouse,
    required this.onTapEmptyPlot,
  });

  @override
  State<VillageBoard> createState() => _VillageBoardState();
}

class _VillageBoardState extends State<VillageBoard> {
  @override
  void initState() {
    super.initState();
    BuildingImageCache.preloadAll().then((_) {
      if (mounted) setState(() {});
    });
    _DecrepitHouseImageCache.preload().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wypełnia CAŁĄ dostępną przestrzeń (bez sztywnych proporcji) - nadmiar
    // ponad kształt wioski jest po prostu dodatkowym tłem trawy, więc plansza
    // nie jest rozciągana/zniekształcona, a mimo to zajmuje cały ekran.
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final layout = _VillageLayout(size);

        return GestureDetector(
          onTapUp: (details) {
            final tap = details.localPosition;
            if ((tap - layout.ratuszCenter).distance < 55 * layout.s) {
              widget.onTapRatusz();
              return;
            }
            for (var i = 0; i < kStandardBuildingKinds.length; i++) {
              final ref = _VillageLayout.standardPlotRefs[i];
              if ((tap - layout.p(ref.dx, ref.dy)).distance < 40 * layout.s) {
                widget.onTapBuilding(kStandardBuildingKinds[i]);
                return;
              }
            }
            for (var i = 0; i < kSmallBuildingKinds.length; i++) {
              final ref = _VillageLayout.smallPlotRefs[i];
              if ((tap - layout.p(ref.dx, ref.dy)).distance < 40 * layout.s) {
                widget.onTapBuilding(kSmallBuildingKinds[i]);
                return;
              }
            }
            for (var i = 0; i < _VillageLayout.extraSmallPlotRefs.length; i++) {
              final ref = _VillageLayout.extraSmallPlotRefs[i];
              if ((tap - layout.p(ref.dx, ref.dy)).distance < 30 * layout.s) {
                widget.onTapExtraHouse(i);
                return;
              }
            }
            // Palisada otacza całą wioskę, ale klikalna jest tylko brama u góry
            // muru (gdzie rysowany jest napis "Palisada"/"Zbuduj Palisadę"), a
            // nie cały jej obwód - dotknięcie boku czy dołu muru nie powinno
            // otwierać okna budynku.
            if ((tap - layout.topGate).distance < 50 * layout.s) {
              widget.onTapPalisade();
              return;
            }
            widget.onTapEmptyPlot();
          },
          child: CustomPaint(
            size: size,
            painter: _VillagePainter(
              ratuszBuilt: widget.ratuszBuilt,
              palisadeBuilt: widget.palisadeBuilt,
              builtMap: widget.builtMap,
              extraHousesBuilt: widget.extraHousesBuilt,
              extraHousesActive: widget.extraHousesActive,
              workers: widget.workers,
              upgradedMap: widget.upgradedMap,
              imageEpoch: BuildingImageCache.epoch,
            ),
          ),
        );
      },
    );
  }
}

/// Prostokątny układ wioski (nie okrągły) - wejścia od góry i od dołu, żeby
/// lepiej wypełniać pionowy ekran telefonu niż pierścień.
class _VillageLayout {
  static const double refW = 700;
  static const double refH = 1100;
  static const double wallLeft = 70, wallTop = 110, wallRight = 630, wallBottom = 990;
  static const double cornerRadius = 36;
  static const double centerX = (wallLeft + wallRight) / 2;

  // Punkt na krętej ścieżce głównej, gdzie siedzi Ratusz (nie sztywny środek muru).
  static const Offset ratuszRef = Offset(350, 400);

  // Standardowe działki (przy końcach odgałęzień organicznej sieci ścieżek).
  // Rozstawione szerzej niż wcześniej (min. ~150 jednostek między sąsiadami) -
  // gotowe, w pełni wyrenderowane grafiki budynków (assets/buildings/) są
  // dużo większe niż dawne generyczne placeholdery i przy starym, ciasnym
  // układzie wizualnie nachodziły na siebie.
  static const List<Offset> standardPlotRefs = [
    Offset(150, 500), // sklep
    Offset(570, 230), // karczma
    Offset(580, 700), // rynek
    Offset(230, 970), // magazyn
    Offset(180, 210), // kuznia
    Offset(440, 500), // browar
    Offset(140, 660), // kaplica
    Offset(110, 830), // szkola
    Offset(560, 900), // koszary
  ];

  // Mniejsze działki pod domy, rozrzucone dodatkowo wzdłuż ścieżek.
  static const List<Offset> smallPlotRefs = [
    // X=350 pokrywa się z centerX/topGate - dom musi siedzieć wyraźnie niżej
    // niż wallTop (110), inaczej zasłania etykietę "Palisada" przy bramie.
    Offset(350, 250), // dom
    Offset(540, 170), // spichlerz
    Offset(320, 630), // piekarnia
    Offset(490, 370), // tartak
    Offset(340, 790), // studnia
    Offset(480, 970), // kamieniarz
  ];

  // Dodatkowe, mniejsze działki pod zwykłe domy (odrębna pula od "Dom" -
  // każda budowalna niezależnie), z dala od wszystkich ścieżek.
  static const List<Offset> extraSmallPlotRefs = [
    Offset(610, 400),
    Offset(610, 560),
    Offset(615, 760),
    Offset(90, 355),
    Offset(270, 300),
  ];

  final double s;
  final double offsetX;
  final double offsetY;

  _VillageLayout(Size size)
      : s = math.min(size.width / refW, size.height / refH),
        offsetX = (size.width - refW * math.min(size.width / refW, size.height / refH)) / 2,
        offsetY = (size.height - refH * math.min(size.width / refW, size.height / refH)) / 2;

  Offset p(double refX, double refY) => Offset(offsetX + refX * s, offsetY + refY * s);

  Offset get ratuszCenter => p(ratuszRef.dx, ratuszRef.dy);
  Offset get topGate => p(centerX, wallTop);
  Offset get bottomGate => p(centerX, wallBottom);
  Rect get wallRect => Rect.fromLTRB(p(wallLeft, wallTop).dx, p(wallLeft, wallTop).dy, p(wallRight, wallBottom).dx, p(wallRight, wallBottom).dy);
}

Color _shade(Color base, double factor) => Color.from(
      alpha: base.a,
      red: (base.r * factor).clamp(0.0, 1.0),
      green: (base.g * factor).clamp(0.0, 1.0),
      blue: (base.b * factor).clamp(0.0, 1.0),
    );

void _fillPoly(Canvas canvas, List<Offset> points, Color color, {double strokeWidth = 1.2}) {
  final path = Path()..moveTo(points[0].dx, points[0].dy);
  for (final p in points.skip(1)) {
    path.lineTo(p.dx, p.dy);
  }
  path.close();
  canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.black.withValues(alpha: 0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth,
  );
}

void _isoBox(Canvas canvas, Offset base, double hw, double hh, double height, Color color) {
  final top = _shade(color, 1.28), left = _shade(color, 0.8), right = _shade(color, 0.56);
  final x = base.dx, y = base.dy;
  final backTop = Offset(x, y - height - hh);
  final rightTop = Offset(x + hw, y - height);
  final frontTop = Offset(x, y - height + hh);
  final leftTop = Offset(x - hw, y - height);
  final frontBot = Offset(x, y + hh);
  final leftBot = Offset(x - hw, y);
  final rightBot = Offset(x + hw, y);
  _fillPoly(canvas, [leftTop, frontTop, frontBot, leftBot], left);
  _fillPoly(canvas, [frontTop, rightTop, rightBot, frontBot], right);
  _fillPoly(canvas, [backTop, rightTop, frontTop, leftTop], top);
}

void _isoRoof(
  Canvas canvas,
  Offset base,
  double hw,
  double hh,
  double riseHeight,
  double apexHeight,
  Color color,
) {
  final left = _shade(color, 0.78);
  final right = _shade(color, 0.52);
  final front = _shade(color, 0.95);
  final back = _shade(color, 0.65);
  final x = base.dx, y = base.dy;
  final apex = Offset(x, y - riseHeight - apexHeight);
  final backTop = Offset(x, y - riseHeight - hh);
  final rightTop = Offset(x + hw, y - riseHeight);
  final frontTop = Offset(x, y - riseHeight + hh);
  final leftTop = Offset(x - hw, y - riseHeight);
  _fillPoly(canvas, [leftTop, frontTop, apex], front);
  _fillPoly(canvas, [frontTop, rightTop, apex], right);
  _fillPoly(canvas, [leftTop, apex, backTop], left);
  _fillPoly(canvas, [backTop, apex, rightTop], back);
}

void _drawLog(Canvas canvas, Offset base, double height, double s) {
  final w = 7 * s;
  final path = Path()
    ..moveTo(base.dx - w / 2, base.dy + 5 * s)
    ..lineTo(base.dx - w / 2, base.dy - height)
    ..lineTo(base.dx, base.dy - height - 6 * s)
    ..lineTo(base.dx + w / 2, base.dy - height)
    ..lineTo(base.dx + w / 2, base.dy + 5 * s)
    ..close();
  final rect = Rect.fromLTRB(base.dx - w / 2, base.dy - height - 6 * s, base.dx + w / 2, base.dy + 5 * s);
  final paint = Paint()
    ..shader = const LinearGradient(
      colors: [Color(0xFF6B4118), Color(0xFF9C6B36), Color(0xFF5C3A1B)],
      stops: [0.0, 0.5, 1.0],
    ).createShader(rect);
  canvas.drawPath(path, paint);
  canvas.drawPath(
    path,
    Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7,
  );
}

void _drawTree(Canvas canvas, Offset p, double s) {
  canvas.drawOval(
    Rect.fromCenter(center: Offset(p.dx, p.dy + 4 * s), width: 24 * s, height: 10 * s),
    Paint()..color = Colors.black.withValues(alpha: 0.2),
  );
  canvas.drawRect(
    Rect.fromCenter(center: Offset(p.dx, p.dy - 1 * s), width: 5 * s, height: 10 * s),
    Paint()..color = const Color(0xFF6B4118),
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(p.dx, p.dy - 16 * s), width: 28 * s, height: 30 * s),
    Paint()..color = const Color(0xFF3F8A2B),
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(p.dx - 4 * s, p.dy - 20 * s), width: 16 * s, height: 16 * s),
    Paint()..color = const Color(0xFF57A63C),
  );
}

void _drawEmptyPlot(
  Canvas canvas,
  Offset p,
  double s, {
  bool highlighted = false,
  Color? fillColor,
  Color? borderColor,
  String? label,
  double sizeFactor = 1.0,
}) {
  final fill = fillColor ?? (highlighted ? const Color(0xFFDCEBFA) : const Color(0xFFEDE0C0));
  final border = borderColor ?? (highlighted ? const Color(0xFF3A8DDE) : const Color(0xFFB9A46B));
  final rx = (highlighted ? 40.0 : 27.0) * s * sizeFactor;
  final ry = (highlighted ? 21.0 : 15.0) * s * sizeFactor;

  canvas.drawOval(
    Rect.fromCenter(center: p, width: rx * 2, height: ry * 2),
    Paint()..color = fill.withValues(alpha: 0.92),
  );
  _dashedOval(canvas, p, rx, ry, border, highlighted ? 3.2 * s : 2.2 * s);

  final plus = TextPainter(
    text: TextSpan(
      text: '+',
      style: TextStyle(
        color: highlighted ? const Color(0xFF1F6BB8) : const Color(0xFF8B7B4E),
        fontWeight: FontWeight.bold,
        fontSize: (highlighted ? 28 : 18) * s,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  plus.paint(canvas, Offset(p.dx - plus.width / 2, p.dy - plus.height / 2 - (highlighted ? 6 : 1) * s));

  if (label != null) {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: const Color(0xFF1F4E7A), fontWeight: FontWeight.bold, fontSize: 13 * s),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy + ry + 6 * s));
  }
}

void _dashedOval(Canvas canvas, Offset center, double rx, double ry, Color color, double strokeWidth) {
  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth;
  const dashCount = 28;
  final rect = Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);
  for (var i = 0; i < dashCount; i += 2) {
    final a0 = (i / dashCount) * 2 * math.pi;
    final sweep = (1 / dashCount) * 2 * math.pi;
    final path = Path()..addArc(rect, a0, sweep);
    canvas.drawPath(path, paint);
  }
}

void _windowMark(Canvas canvas, Offset center, double w, double h) {
  final rect = Rect.fromCenter(center: center, width: w, height: h);
  canvas.drawRect(rect, Paint()..color = const Color(0xFF28323C).withValues(alpha: 0.75));
  canvas.drawRect(
    rect,
    Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1,
  );
}

void _drawRatusz(Canvas canvas, Offset base, double s) {
  canvas.drawOval(
    Rect.fromCenter(center: Offset(base.dx, base.dy + 6 * s), width: 64 * s, height: 26 * s),
    Paint()..color = Colors.black.withValues(alpha: 0.28),
  );

  canvas.drawRect(
    Rect.fromCenter(center: Offset(base.dx, base.dy + 20 * s), width: 68 * s, height: 4 * s),
    Paint()..color = const Color(0xFFB9A46B),
  );
  _isoBox(canvas, Offset(base.dx, base.dy + 16 * s), 34 * s, 17 * s, 34 * s, const Color(0xFFD8CBAE));
  _isoBox(canvas, Offset(base.dx - 32 * s, base.dy + 22 * s), 2.4 * s, 1.2 * s, 32 * s, const Color(0xFFC9BB9A));
  _isoBox(canvas, Offset(base.dx + 32 * s, base.dy + 20 * s), 2.4 * s, 1.2 * s, 32 * s, const Color(0xFFC9BB9A));

  _windowMark(canvas, Offset(base.dx - 16 * s, base.dy - 2 * s), 7 * s, 11 * s);
  _windowMark(canvas, Offset(base.dx, base.dy + 2 * s), 7 * s, 11 * s);
  _windowMark(canvas, Offset(base.dx + 16 * s, base.dy - 2 * s), 7 * s, 11 * s);

  canvas.drawRect(
    Rect.fromCenter(center: Offset(base.dx, base.dy + 10 * s), width: 12 * s, height: 12 * s),
    Paint()..color = const Color(0xFF5C4A32),
  );
  canvas.drawRect(
    Rect.fromCenter(center: Offset(base.dx, base.dy + 18.5 * s), width: 18 * s, height: 3 * s),
    Paint()..color = const Color(0xFFC9BB9A),
  );
  canvas.drawRect(
    Rect.fromCenter(center: Offset(base.dx, base.dy + 21.5 * s), width: 20 * s, height: 3 * s),
    Paint()..color = const Color(0xFFC9BB9A),
  );

  for (final lx in [-14.0, 14.0]) {
    canvas.drawLine(
      Offset(base.dx + lx * s, base.dy + 4 * s),
      Offset(base.dx + lx * s, base.dy - 10 * s),
      Paint()
        ..color = const Color(0xFF3A281A)
        ..strokeWidth = 1.6 * s,
    );
    canvas.drawCircle(Offset(base.dx + lx * s, base.dy - 13 * s), 2.6 * s, Paint()..color = const Color(0xFFFFD54F));
  }

  _isoRoof(canvas, Offset(base.dx, base.dy - 18 * s), 40 * s, 20 * s, 0, 30 * s, const Color(0xFF4A6FA5));
  _isoBox(canvas, Offset(base.dx, base.dy - 46 * s), 9 * s, 4.5 * s, 16 * s, const Color(0xFFD8CBAE));

  canvas.drawCircle(Offset(base.dx, base.dy - 54 * s), 5 * s, Paint()..color = const Color(0xFFEDE6D2));
  canvas.drawCircle(
    Offset(base.dx, base.dy - 54 * s),
    5 * s,
    Paint()
      ..color = const Color(0xFF3A281A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * s,
  );

  _isoRoof(canvas, Offset(base.dx, base.dy - 60 * s), 11 * s, 5.5 * s, 0, 12 * s, const Color(0xFF4A6FA5));

  canvas.drawLine(
    Offset(base.dx, base.dy - 78 * s),
    Offset(base.dx, base.dy - 94 * s),
    Paint()
      ..color = const Color(0xFF6B4118)
      ..strokeWidth = 2.2 * s,
  );
  final flag = Path()
    ..moveTo(base.dx, base.dy - 94 * s)
    ..lineTo(base.dx + 16 * s, base.dy - 89 * s)
    ..lineTo(base.dx, base.dy - 84 * s)
    ..close();
  canvas.drawPath(flag, Paint()..color = const Color(0xFFC0392B));
}

void _paintIconGlyph(Canvas canvas, Offset center, IconData icon, double size, Color color) {
  final tp = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
        color: color,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
}

/// Generyczny placeholder wyglądu dla nowych budynków wioski (kolor + ikona
/// budynku) - docelowy, bardziej rozbudowany wygląd zostanie wybrany osobno.
void _drawGenericBuilding(Canvas canvas, Offset base, double s, BuildingKind kind, {double sizeFactor = 1.0}) {
  final color = kind.color;
  canvas.drawOval(
    Rect.fromCenter(center: Offset(base.dx, base.dy + 7 * s * sizeFactor), width: 70 * s * sizeFactor, height: 28 * s * sizeFactor),
    Paint()..color = Colors.black.withValues(alpha: 0.25),
  );
  _isoBox(canvas, Offset(base.dx, base.dy + 6 * s * sizeFactor), 34 * s * sizeFactor, 17 * s * sizeFactor, 34 * s * sizeFactor, color);
  _isoRoof(canvas, Offset(base.dx, base.dy - 17 * s * sizeFactor), 39 * s * sizeFactor, 20 * s * sizeFactor, 0, 25 * s * sizeFactor,
      _shade(color, 0.8));
  _paintIconGlyph(canvas, Offset(base.dx, base.dy + 1 * s * sizeFactor), kind.icon, 25 * s * sizeFactor, Colors.white);
}

/// Rysuje gotowy, wyrenderowany obrazek budynku (z modelu 3D) - obrazek ma
/// już wbudowaną własną podstawę/cień, więc jest kotwiczony dołem w [base].
void _drawBuildingImage(Canvas canvas, ui.Image image, Offset base, double s, {double sizeFactor = 1.0}) {
  final aspect = image.width / image.height;
  final targetHeight = 88 * s * sizeFactor;
  final targetWidth = targetHeight * aspect;
  final dstRect = Rect.fromLTWH(base.dx - targetWidth / 2, base.dy - targetHeight, targetWidth, targetHeight);
  final srcRect = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
  canvas.drawImageRect(image, srcRect, dstRect, Paint()..filterQuality = FilterQuality.medium);
}

/// Rysuje zbudowany budynek (gotowy obrazek albo generyczny placeholder,
/// zależnie co jest dostępne) i podpis z jego nazwą pod spodem.
void _drawBuiltBuilding(
  Canvas canvas,
  Offset pos,
  double s,
  BuildingKind kind, {
  double sizeFactor = 1.0,
  int workers = 0,
  String? labelOverride,
  bool upgraded = false,
}) {
  final extraScale = kBuildingImageScale[kind] ?? 1.0;
  final image = BuildingImageCache.get(kind, upgraded: upgraded);
  if (image != null) {
    _drawBuildingImage(canvas, image, pos, s, sizeFactor: sizeFactor * extraScale);
  } else {
    _drawGenericBuilding(canvas, pos, s, kind, sizeFactor: sizeFactor);
  }
  _drawBuildingLabel(canvas, pos, s, labelOverride ?? kind.label, sizeFactor: sizeFactor, workers: workers);
}

/// Podpis z nazwą budynku, na małej półprzezroczystej plakietce pod budynkiem
/// (żeby był czytelny niezależnie od tła, na którym stoi budynek). Jeśli
/// budynek ma przydzielonych pracowników, dopisuje 1-2 ikonki ludzika.
void _drawBuildingLabel(
  Canvas canvas,
  Offset pos,
  double s,
  String text, {
  double sizeFactor = 1.0,
  int workers = 0,
}) {
  final label = workers > 0 ? '$text ${'👤' * workers.clamp(0, 2)}' : text;
  final tp = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15 * s * sizeFactor),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final padH = 8 * s * sizeFactor, padV = 4 * s * sizeFactor;
  final center = Offset(pos.dx, pos.dy + 22 * s * sizeFactor);
  final rect = Rect.fromCenter(
    center: center,
    width: tp.width + padH * 2,
    height: tp.height + padV * 2,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(rect, Radius.circular(6 * s * sizeFactor)),
    Paint()..color = Colors.black.withValues(alpha: 0.55),
  );
  tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
}

void _drawPalisadeSwatch(Canvas canvas, Offset center, double s) {
  // Krótki odcinek muru jako podgląd stylu palisady (nie pełny pierścień).
  for (var i = -3; i <= 3; i++) {
    _drawLog(canvas, Offset(center.dx + i * 12 * s, center.dy + 24 * s), 40 * s, s);
  }
  canvas.drawRect(
    Rect.fromCenter(center: Offset(center.dx, center.dy + 26 * s), width: 90 * s, height: 6 * s),
    Paint()..color = const Color(0xFF3F7A2B),
  );
}

class _VillagePainter extends CustomPainter {
  final bool ratuszBuilt;
  final bool palisadeBuilt;
  final Map<BuildingKind, bool> builtMap;
  final List<bool> extraHousesBuilt;
  final List<bool> extraHousesActive;
  final Map<BuildingKind, int> workers;
  final Map<BuildingKind, bool> upgradedMap;
  final int imageEpoch;

  _VillagePainter({
    required this.ratuszBuilt,
    required this.palisadeBuilt,
    required this.builtMap,
    required this.extraHousesBuilt,
    this.extraHousesActive = const [],
    this.workers = const {},
    this.upgradedMap = const {},
    required this.imageEpoch,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final layout = _VillageLayout(size);
    final s = layout.s;
    Offset p(double refX, double refY) => layout.p(refX, refY);

    // ---- terrain ----
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF5FA83D));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(p(-40, -40).dx, p(-40, -40).dy, p(_VillageLayout.refW + 40, _VillageLayout.refH + 40).dx,
            p(_VillageLayout.refW + 40, _VillageLayout.refH + 40).dy),
        Radius.circular(60 * s),
      ),
      Paint()..color = const Color(0xFF71B84A),
    );

    final wallRect = layout.wallRect;
    final moatRect = wallRect.inflate(22 * s);

    // trees along the outside of the wall perimeter
    for (double x = wallRect.left + 30 * s; x < wallRect.right - 30 * s; x += 75 * s) {
      _drawTree(canvas, Offset(x, moatRect.top - 12 * s), s);
      _drawTree(canvas, Offset(x, moatRect.bottom + 12 * s), s);
    }
    for (double y = wallRect.top + 60 * s; y < wallRect.bottom - 60 * s; y += 95 * s) {
      _drawTree(canvas, Offset(moatRect.left - 12 * s, y), s);
      _drawTree(canvas, Offset(moatRect.right + 12 * s, y), s);
    }

    // ---- moat ----
    canvas.drawRRect(
      RRect.fromRectAndRadius(moatRect, Radius.circular(_VillageLayout.cornerRadius * s + 22 * s)),
      Paint()
        ..color = const Color(0xFF3A8DDE).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18 * s,
    );

    // ---- roads: organiczna, kręta sieć ścieżek (bez kątów prostych) ----
    final mainPathPaint = Paint()
      ..color = const Color(0xFFD8C9A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final mainPath = Path()
      ..moveTo(p(350, 90).dx, p(350, 90).dy)
      ..cubicTo(p(440, 220).dx, p(440, 220).dy, p(260, 300).dx, p(260, 300).dy, p(350, 400).dx, p(350, 400).dy)
      ..cubicTo(p(440, 500).dx, p(440, 500).dy, p(250, 580).dx, p(250, 580).dy, p(320, 680).dx, p(320, 680).dy)
      ..cubicTo(p(380, 760).dx, p(380, 760).dy, p(280, 830).dx, p(280, 830).dy, p(300, 900).dx, p(300, 900).dy)
      ..lineTo(p(350, 1010).dx, p(350, 1010).dy);
    canvas.drawPath(mainPath, mainPathPaint);

    final branchPaint = Paint()
      ..color = const Color(0xFFD8C9A0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    void branch(List<Offset> refPts) {
      final path = Path()..moveTo(p(refPts[0].dx, refPts[0].dy).dx, p(refPts[0].dx, refPts[0].dy).dy);
      for (var i = 1; i < refPts.length; i += 3) {
        path.cubicTo(
          p(refPts[i].dx, refPts[i].dy).dx,
          p(refPts[i].dx, refPts[i].dy).dy,
          p(refPts[i + 1].dx, refPts[i + 1].dy).dx,
          p(refPts[i + 1].dx, refPts[i + 1].dy).dy,
          p(refPts[i + 2].dx, refPts[i + 2].dy).dx,
          p(refPts[i + 2].dx, refPts[i + 2].dy).dy,
        );
      }
      canvas.drawPath(path, branchPaint);
    }

    branch([const Offset(320, 395), const Offset(220, 430), const Offset(170, 470), const Offset(150, 500)]);
    branch([const Offset(365, 380), const Offset(450, 320), const Offset(510, 270), const Offset(570, 230)]);
    branch([const Offset(335, 675), const Offset(420, 685), const Offset(500, 695), const Offset(580, 700)]);
    branch([const Offset(290, 895), const Offset(260, 930), const Offset(240, 955), const Offset(230, 970)]);
    // Nowa ścieżka po lewej z dwoma dużymi działkami.
    branch([
      const Offset(275, 585),
      const Offset(210, 600),
      const Offset(165, 630),
      const Offset(140, 660),
      const Offset(120, 710),
      const Offset(105, 770),
      const Offset(110, 830),
    ]);
    // Nowa ścieżka na dole po prawej z jedną dużą działką.
    branch([const Offset(320, 875), const Offset(410, 890), const Offset(490, 895), const Offset(560, 900)]);

    // ---- corner towers ----
    for (final corner in [
      Offset(wallRect.left, wallRect.top),
      Offset(wallRect.right, wallRect.top),
      Offset(wallRect.left, wallRect.bottom),
      Offset(wallRect.right, wallRect.bottom),
    ]) {
      canvas.drawCircle(corner, 16 * s, Paint()..color = const Color(0xFF6B4118));
      canvas.drawCircle(corner, 11 * s, Paint()..color = const Color(0xFF8B5A2B));
    }

    // ---- outer palisade (or its build marker) ----
    if (palisadeBuilt) {
      final rrect = RRect.fromRectAndRadius(wallRect, Radius.circular(_VillageLayout.cornerRadius * s));
      final wallPath = Path()..addRRect(rrect);
      final metric = wallPath.computeMetrics().first;
      final topGate = layout.topGate, bottomGate = layout.bottomGate;
      final gateHalf = 46 * s;
      for (double d = 0; d < metric.length; d += 11 * s) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent == null) continue;
        final pos = tangent.position;
        if ((pos - topGate).distance < gateHalf || (pos - bottomGate).distance < gateHalf) continue;
        _drawLog(canvas, pos, 34 * s, s);
      }
      _drawBuildingLabel(canvas, topGate, s, 'Palisada', workers: workers[BuildingKind.palisade] ?? 0);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(wallRect, Radius.circular(_VillageLayout.cornerRadius * s)),
        Paint()
          ..color = const Color(0xFF8B5A2B).withValues(alpha: 0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * s,
      );
      _drawEmptyPlot(canvas, layout.topGate, s, highlighted: true, sizeFactor: 0.8, label: 'Zbuduj Palisadę');
    }

    // ---- standardowe działki (przy końcach odgałęzień ścieżki) ----
    for (var i = 0; i < kStandardBuildingKinds.length; i++) {
      final ref = _VillageLayout.standardPlotRefs[i];
      final kind = kStandardBuildingKinds[i];
      final pos = p(ref.dx, ref.dy);
      if (builtMap[kind] ?? false) {
        _drawBuiltBuilding(
          canvas,
          pos,
          s,
          kind,
          workers: workers[kind] ?? 0,
          upgraded: upgradedMap[kind] ?? false,
        );
      } else {
        _drawEmptyPlot(canvas, pos, s, label: kind.label);
      }
    }
    // ---- działki budynków produkcyjnych/domu - ten sam duży rozmiar co powyżej ----
    for (var i = 0; i < kSmallBuildingKinds.length; i++) {
      final ref = _VillageLayout.smallPlotRefs[i];
      final kind = kSmallBuildingKinds[i];
      final pos = p(ref.dx, ref.dy);
      if (builtMap[kind] ?? false) {
        _drawBuiltBuilding(
          canvas,
          pos,
          s,
          kind,
          workers: workers[kind] ?? 0,
          upgraded: upgradedMap[kind] ?? false,
        );
      } else {
        _drawEmptyPlot(canvas, pos, s, label: kind.label);
      }
    }
    // ---- dodatkowe działki pod zwykłe domy - każda budowalna niezależnie ----
    for (var i = 0; i < _VillageLayout.extraSmallPlotRefs.length; i++) {
      final ref = _VillageLayout.extraSmallPlotRefs[i];
      final pos = p(ref.dx, ref.dy);
      if (i < extraHousesBuilt.length && extraHousesBuilt[i]) {
        // Zaniedbany (ale wciąż zamieszkany) wygląd, dopóki gracz nie
        // odbuduje tego konkretnego domu - patrz HomeShell._onTapExtraHouse.
        final decrepit = i < extraHousesActive.length && !extraHousesActive[i];
        final decrepitImage = decrepit ? _DecrepitHouseImageCache.image : null;
        if (decrepitImage != null) {
          _drawBuildingImage(canvas, decrepitImage, pos, s, sizeFactor: 0.75);
          _drawBuildingLabel(canvas, pos, s, 'Dom', sizeFactor: 0.75);
        } else {
          _drawBuiltBuilding(canvas, pos, s, BuildingKind.dom, sizeFactor: 0.75);
        }
      } else {
        _drawEmptyPlot(canvas, pos, s, sizeFactor: 0.55, label: 'Dom');
      }
    }

    // ---- Ratusz slot (na trasie głównej ścieżki) ----
    if (ratuszBuilt) {
      final ratuszUpgraded = upgradedMap[BuildingKind.ratusz] ?? false;
      final ratuszImage = BuildingImageCache.get(BuildingKind.ratusz, upgraded: ratuszUpgraded);
      if (ratuszImage != null) {
        _drawBuildingImage(canvas, ratuszImage, layout.ratuszCenter, s,
            sizeFactor: kBuildingImageScale[BuildingKind.ratusz] ?? 1.0);
      } else {
        _drawRatusz(canvas, layout.ratuszCenter, s);
      }
      _drawBuildingLabel(canvas, layout.ratuszCenter, s, 'Ratusz', workers: workers[BuildingKind.ratusz] ?? 0);
    } else {
      // Zanim Ratusz zostanie zbudowany, na jego miejscu stoi zwyczajny,
      // odziedziczony dom - nic nie daje, ale to na tej samej działce gracz
      // "buduje" prawdziwy Ratusz (patrz HomeShell._onTapRatusz). Podpis mimo
      // to od razu pokazuje "Ratusz", żeby gracz wiedział, co tu docelowo stanie.
      _drawBuiltBuilding(
        canvas,
        layout.ratuszCenter,
        s,
        BuildingKind.dom,
        sizeFactor: 0.9,
        labelOverride: 'Ratusz',
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VillagePainter oldDelegate) =>
      oldDelegate.ratuszBuilt != ratuszBuilt ||
      oldDelegate.palisadeBuilt != palisadeBuilt ||
      oldDelegate.builtMap != builtMap ||
      oldDelegate.extraHousesBuilt != extraHousesBuilt ||
      oldDelegate.extraHousesActive != extraHousesActive ||
      oldDelegate.workers != workers ||
      oldDelegate.imageEpoch != imageEpoch;
}

class _BuildingPreviewPainter extends CustomPainter {
  final BuildingKind kind;
  final bool upgraded;

  _BuildingPreviewPainter(this.kind, {this.upgraded = false});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 160;
    final center = Offset(size.width / 2, size.height / 2 + 30 * s);
    final image = BuildingImageCache.get(kind, upgraded: upgraded);

    if (kind == BuildingKind.palisade) {
      _drawPalisadeSwatch(canvas, center, s);
      return;
    }
    if (image != null) {
      // Dopasuj obrazek do dostępnego miejsca (contain-fit) zamiast
      // stałego mnożnika - inaczej duże sceny (np. Kamieniarz) wyjeżdżają
      // poza kontener podglądu.
      const padding = 14.0;
      final maxW = size.width - padding * 2;
      final maxH = size.height - padding * 2;
      final aspect = image.width / image.height;
      var w = maxW, h = maxW / aspect;
      if (h > maxH) {
        h = maxH;
        w = maxH * aspect;
      }
      final dst = Rect.fromCenter(center: Offset(size.width / 2, size.height / 2), width: w, height: h);
      final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      canvas.drawImageRect(image, src, dst, Paint()..filterQuality = FilterQuality.medium);
    } else if (kind == BuildingKind.ratusz) {
      _drawRatusz(canvas, center, s);
    } else {
      _drawGenericBuilding(canvas, center, s * 1.6, kind);
    }
  }

  @override
  bool shouldRepaint(covariant _BuildingPreviewPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.upgraded != upgraded;
}

/// Miniaturowy podgląd wyglądu budynku/budowli do okien dialogowych - jeśli
/// [upgraded] jest true i budynek ma osobny obrazek poziomu 2 (patrz
/// [kBuildingImageAssetsLevel2]), pokazuje ten obrazek zamiast poziomu 1.
class BuildingPreview extends StatelessWidget {
  final BuildingKind kind;
  final bool upgraded;

  const BuildingPreview({super.key, required this.kind, this.upgraded = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 150,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFF71B84A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomPaint(painter: _BuildingPreviewPainter(kind, upgraded: upgraded)),
    );
  }
}
