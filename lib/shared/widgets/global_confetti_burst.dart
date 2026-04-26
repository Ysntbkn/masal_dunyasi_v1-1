import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GlobalConfettiBurst extends StatefulWidget {
  const GlobalConfettiBurst({
    super.key,
    this.trigger,
    this.duration = const Duration(milliseconds: 1400),
    this.emissionFrequency = 0.05,
    this.numberOfParticles = 14,
    this.maxBlastForce = 18,
    this.minBlastForce = 8,
    this.gravity = 0.24,
    this.shouldLoop = false,
    this.colors = const [
      Color(0xFFFFC84A),
      Color(0xFFFF8B3D),
      Color(0xFF7BC6B2),
      Color(0xFF6AA8FF),
      Color(0xFFFF6F91),
    ],
  });

  final Object? trigger;
  final Duration duration;
  final double emissionFrequency;
  final int numberOfParticles;
  final double maxBlastForce;
  final double minBlastForce;
  final double gravity;
  final bool shouldLoop;
  final List<Color> colors;

  @override
  State<GlobalConfettiBurst> createState() => _GlobalConfettiBurstState();
}

class _GlobalConfettiBurstState extends State<GlobalConfettiBurst> {
  late final ConfettiController _leftController;
  late final ConfettiController _rightController;

  @override
  void initState() {
    super.initState();
    _leftController = ConfettiController(duration: widget.duration);
    _rightController = ConfettiController(duration: widget.duration);
    _play();
  }

  @override
  void didUpdateWidget(covariant GlobalConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger ||
        oldWidget.duration != widget.duration) {
      _play();
    }
  }

  @override
  void dispose() {
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: ConfettiWidget(
            confettiController: _leftController,
            blastDirection: pi / 4,
            emissionFrequency: widget.emissionFrequency,
            numberOfParticles: widget.numberOfParticles,
            maxBlastForce: widget.maxBlastForce,
            minBlastForce: widget.minBlastForce,
            gravity: widget.gravity,
            shouldLoop: widget.shouldLoop,
            colors: widget.colors,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: ConfettiWidget(
            confettiController: _rightController,
            blastDirection: 3 * pi / 4,
            emissionFrequency: widget.emissionFrequency,
            numberOfParticles: widget.numberOfParticles,
            maxBlastForce: widget.maxBlastForce,
            minBlastForce: widget.minBlastForce,
            gravity: widget.gravity,
            shouldLoop: widget.shouldLoop,
            colors: widget.colors,
          ),
        ),
      ],
    );
  }

  void _play() {
    _leftController
      ..stop()
      ..play();
    _rightController
      ..stop()
      ..play();
  }
}
