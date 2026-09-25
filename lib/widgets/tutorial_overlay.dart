import 'package:flutter/material.dart';

import '../l10n/gen/app_localizations.dart';
import '../models/tutorial_step.dart';

/// Nakładka samouczka z podświetleniem "na żywo" - przyciemnia cały ekran
/// poza wskazanym widgetem (patrz TutorialStep.targetKey) i pokazuje obok
/// niego kartę z tytułem/opisem oraz nawigacją Wstecz/Dalej/Pomiń. Element
/// jest lokalizowany przez GlobalKey, więc musi być w danej chwili
/// zamontowany w drzewie widgetów - przy zmianie zakładki (patrz
/// HomeShell._tourAdvanceTo) trzeba poczekać klatkę, zanim nowy cel stanie
/// się mierzalny, stąd wbudowany mechanizm ponawiania pomiaru.
class TutorialOverlay extends StatefulWidget {
  final List<TutorialStep> steps;
  final int stepIndex;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.stepIndex,
    required this.onNext,
    required this.onSkip,
    this.onBack,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  Rect? _targetRect;
  int _measureAttempt = 0;

  @override
  void initState() {
    super.initState();
    _scheduleMeasure();
  }

  @override
  void didUpdateWidget(covariant TutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stepIndex != widget.stepIndex) {
      _targetRect = null;
      _measureAttempt = 0;
      _scheduleMeasure();
    }
  }

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;
    final step = widget.steps[widget.stepIndex];
    final renderObject = step.targetKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final topLeft = renderObject.localToGlobal(Offset.zero);
      final rect = step.padding.inflateRect(topLeft & renderObject.size);
      setState(() => _targetRect = rect);
      return;
    }
    // Cel jeszcze nie zbudowany (np. tuż po przełączeniu zakładki) - spróbuj
    // ponownie w kolejnej klatce, maks. ~1s, zanim poddamy się na cichy fallback.
    if (_measureAttempt < 60) {
      _measureAttempt++;
      _scheduleMeasure();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final step = widget.steps[widget.stepIndex];
    final screenSize = MediaQuery.of(context).size;
    final rect = _targetRect;
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: CustomPaint(
              size: screenSize,
              painter: _SpotlightPainter(
                rect: rect,
                borderRadius: step.borderRadius,
              ),
            ),
          ),
          if (rect != null)
            _TutorialCard(
              rect: rect,
              screenSize: screenSize,
              title: step.title,
              description: step.description,
              stepIndex: widget.stepIndex,
              stepCount: widget.steps.length,
              onBack: widget.onBack,
              onNext: widget.onNext,
              onSkip: widget.onSkip,
              l10n: l10n,
            ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect? rect;
  final BorderRadius borderRadius;

  const _SpotlightPainter({required this.rect, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final scrimPaint = Paint()..color = const Color(0xCC120C06);
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, scrimPaint);
    final target = rect;
    if (target != null) {
      final holePaint = Paint()..blendMode = BlendMode.clear;
      canvas.drawRRect(borderRadius.toRRect(target), holePaint);
    }
    canvas.restore();
    if (target != null) {
      final borderPaint = Paint()
        ..color = const Color(0xFFD9A066)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawRRect(borderRadius.toRRect(target), borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.rect != rect || oldDelegate.borderRadius != borderRadius;
}

class _TutorialCard extends StatelessWidget {
  final Rect rect;
  final Size screenSize;
  final String title;
  final String description;
  final int stepIndex;
  final int stepCount;
  final VoidCallback? onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final AppLocalizations l10n;

  const _TutorialCard({
    required this.rect,
    required this.screenSize,
    required this.title,
    required this.description,
    required this.stepIndex,
    required this.stepCount,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    const cardWidth = 300.0;
    const margin = 16.0;
    final spaceBelow = screenSize.height - rect.bottom;
    final spaceAbove = rect.top;
    final preferBelow = spaceBelow >= spaceAbove;
    final left = (rect.center.dx - cardWidth / 2).clamp(
      margin,
      screenSize.width - cardWidth - margin,
    );
    final isLast = stepIndex == stepCount - 1;

    // Gdy podświetlony obszar zajmuje prawie cały ekran (np. cała treść
    // zakładki, patrz kroki z padding:EdgeInsets.zero), nie ma miejsca obok
    // niego na kartę - zamiast pozwolić jej wyjechać poza ekran, przyklejamy
    // ją wtedy do góry/dołu ekranu (nakładając się na podświetlenie) i
    // ograniczamy wysokość, żeby zawsze zmieściła się w całości.
    final usableSpace = preferBelow ? spaceBelow : spaceAbove;
    final overlay = usableSpace < 170;
    final double? top = overlay
        ? (preferBelow ? null : margin)
        : (preferBelow ? rect.bottom + 12 : null);
    final double? bottom = overlay
        ? (preferBelow ? margin : null)
        : (preferBelow ? null : (screenSize.height - rect.top + 12));

    return Positioned(
      left: left,
      top: top,
      bottom: bottom,
      width: cardWidth,
      child: Material(
        color: const Color(0xFFFBEFD8),
        elevation: 10,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenSize.height - 2 * margin,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF3E2712),
                        ),
                      ),
                    ),
                    Text(
                      '${stepIndex + 1}/$stepCount',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8A7860),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF3E2712),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    TextButton(
                      onPressed: onSkip,
                      child: Text(l10n.tutorialSkipButton),
                    ),
                    const Spacer(),
                    if (onBack != null) ...[
                      TextButton(
                        onPressed: onBack,
                        child: Text(l10n.tutorialBackButton),
                      ),
                      const SizedBox(width: 4),
                    ],
                    FilledButton(
                      onPressed: onNext,
                      child: Text(
                        isLast
                            ? l10n.tutorialDoneButton
                            : l10n.tutorialNextButton,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
