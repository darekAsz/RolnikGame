import 'package:flutter/material.dart';

import '../models/season.dart';

/// Krótki, samoznikający ekran "Tydzień N" pokazywany przed każdą planszą
/// zbiorów. Odtwarza fade-in -> chwilę utrzymania -> fade-out, po czym sam
/// się zamyka (Navigator.pop), oddając sterowanie ekranowi, który go otworzył.
class WeekTransitionScreen extends StatefulWidget {
  final int week;

  const WeekTransitionScreen({super.key, required this.week});

  @override
  State<WeekTransitionScreen> createState() => _WeekTransitionScreenState();
}

class _WeekTransitionScreenState extends State<WeekTransitionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _opacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 25),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _controller.forward().whenComplete(() {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final season = seasonForWeek(widget.week);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _opacity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tydzień ${widget.week}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                '${season.emoji} ${season.label}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                season.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
