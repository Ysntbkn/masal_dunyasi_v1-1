import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../core/achievements/badge_catalog.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _StoryBottomNav(
        selectedIndex: navigationShell.currentIndex,
        onSelected: navigationShell.goBranch,
      ),
    );
  }
}

class _StoryBottomNav extends StatelessWidget {
  const _StoryBottomNav({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    _BottomNavItem(Icons.auto_stories_rounded, 'Masallar'),
    _BottomNavItem(Icons.nightlight_round, 'Uyku'),
    _BottomNavItem(Icons.emoji_events_rounded, 'Rozet'),
    _BottomNavItem(Icons.bookmark_rounded, 'Kitaplik'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(22, 8, 22, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            for (var i = 0; i < _items.length; i++)
              Expanded(
                child: _BottomNavButton(
                  item: _items[i],
                  selected: selectedIndex == i,
                  onTap: () => onSelected(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 52,
        decoration: BoxDecoration(
          color: selected ? AppColors.peach.withValues(alpha: 0.65) : null,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              color: selected ? AppColors.cinnamon : const Color(0xFFB9B1A9),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? AppColors.cinnamon : const Color(0xFFB9B1A9),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem {
  const _BottomNavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

class AppRouteWrapper extends StatelessWidget {
  const AppRouteWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final hasBadgeCelebration = state.activeBadgeCelebration != null;

    return Stack(
      children: [
        child,
        if (state.hasActiveAudio &&
            state.onboardingComplete &&
            !hasBadgeCelebration)
          const Positioned(
            left: 16,
            right: 16,
            bottom: 88,
            child: MiniPlayer(),
          ),
        const BadgeCelebrationOverlay(),
      ],
    );
  }
}

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final typeLabel = state.activeAudioType == AudioSourceType.sleep
        ? 'Uyku sesi'
        : 'Masal sesi';

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.peach,
              foregroundColor: AppColors.cinnamon,
              child: Icon(Icons.play_arrow_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.activeAudioTitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: null,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    typeLabel,
                    style: const TextStyle(
                      fontFamily: null,
                      color: AppColors.lavender,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.push(AppRoutes.audioPlayer),
              icon: const Icon(Icons.open_in_full_rounded),
            ),
            IconButton(
              onPressed: state.stopAudio,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class BadgeCelebrationOverlay extends StatefulWidget {
  const BadgeCelebrationOverlay({super.key});

  @override
  State<BadgeCelebrationOverlay> createState() =>
      _BadgeCelebrationOverlayState();
}

class _BadgeCelebrationOverlayState extends State<BadgeCelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final AudioPlayer _player = AudioPlayer();
  final List<_ConfettiParticle> _particles = <_ConfettiParticle>[];
  Timer? _dismissTimer;
  String? _currentBadgeId;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final badge = context.select<AppState, BadgeDefinition?>(
      (state) => state.activeBadgeCelebration,
    );

    if (badge == null) {
      _currentBadgeId = null;
      return const SizedBox.shrink();
    }

    if (badge.id != _currentBadgeId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _startCelebration(badge);
      });
    }

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.42),
        child: InkWell(
          onTap: _dismissCelebration,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ConfettiPainter(
                        particles: _particles,
                        progress: Curves.easeOut.transform(_controller.value),
                      ),
                    ),
                  ),
                  Center(
                    child: Transform.scale(
                      scale: 0.92 + (_controller.value * 0.08),
                      child: Container(
                        width: 280,
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7EF),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Yeni Rozet!',
                              style: TextStyle(
                                color: AppColors.cinnamon,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: 168,
                              height: 168,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Image.asset(
                                badge.assetPath,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              badge.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF3C342E),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tebrikler, yeni bir rozet kazandin.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF7A6E63),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 18),
                            FilledButton(
                              onPressed: _dismissCelebration,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.cinnamon,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text('Harika'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _ConfettiPainter(
                          particles: _particles,
                          progress: Curves.easeOut.transform(_controller.value),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _startCelebration(BadgeDefinition badge) {
    _currentBadgeId = badge.id;
    _dismissTimer?.cancel();
    _particles
      ..clear()
      ..addAll(_buildParticles(badge.id.hashCode));
    _controller.forward(from: 0);
    unawaited(_playSound());
    _dismissTimer = Timer(
      const Duration(milliseconds: 2600),
      _dismissCelebration,
    );
  }

  Future<void> _playSound() async {
    try {
      await _player.setAsset('asset/audio/badge_unlock.wav');
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (_) {
      // UI should still celebrate even if audio is unavailable.
    }
  }

  void _dismissCelebration() {
    _dismissTimer?.cancel();
    if (!mounted) return;
    _currentBadgeId = null;
    context.read<AppState>().dismissBadgeCelebration();
  }

  List<_ConfettiParticle> _buildParticles(int seed) {
    final random = math.Random(seed);
    final colors = [
      const Color(0xFFFFC44D),
      const Color(0xFFFF7E54),
      const Color(0xFF63D6FF),
      const Color(0xFFB96BFF),
      const Color(0xFF7CDB7C),
      const Color(0xFFFF6BA6),
    ];

    return List<_ConfettiParticle>.generate(64, (index) {
      return _ConfettiParticle(
        angle: (random.nextDouble() * math.pi) - (math.pi / 2),
        distance: 120 + (random.nextDouble() * 220),
        fall: 90 + (random.nextDouble() * 180),
        size: 8 + (random.nextDouble() * 10),
        color: colors[random.nextInt(colors.length)],
      );
    });
  }
}

class _ConfettiParticle {
  const _ConfettiParticle({
    required this.angle,
    required this.distance,
    required this.fall,
    required this.size,
    required this.color,
  });

  final double angle;
  final double distance;
  final double fall;
  final double size;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter({required this.particles, required this.progress});

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.34);
    for (final particle in particles) {
      final dx = math.cos(particle.angle) * particle.distance * progress;
      final dy =
          math.sin(particle.angle) * particle.distance * progress +
          (particle.fall * progress * progress);
      final paint = Paint()
        ..color = particle.color.withValues(
          alpha: 0.18 + ((1 - progress) * 0.82),
        );
      final rect = Rect.fromCenter(
        center: Offset(center.dx + dx, center.dy + dy),
        width: particle.size,
        height: particle.size * 0.66,
      );
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(progress * math.pi * 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: rect.width,
            height: rect.height,
          ),
          Radius.circular(particle.size * 0.24),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.particles != particles;
  }
}
