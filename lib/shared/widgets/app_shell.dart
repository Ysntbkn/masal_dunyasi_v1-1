import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../core/achievements/badge_catalog.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../theme/app_theme.dart';
import 'global_confetti_burst.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: const Color(0xFFFFF3E6),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (navigationShell.currentIndex != 0) {
            navigationShell.goBranch(0);
          }
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: const Color(0xFFFFF3E6),
          body: navigationShell,
          bottomNavigationBar: _StoryBottomNav(
            selectedIndex: navigationShell.currentIndex,
            onSelected: navigationShell.goBranch,
          ),
        ),
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
    _BottomNavItem(Icons.bookmark_rounded, 'Kitaplık'),
  ];

  @override
  Widget build(BuildContext context) {
    const totalHeight = 90.0;
    const bodyTop = 23.0;
    const highlightRadius = 24.0;
    const sideMargin = 6.0;
    const bottomGap = 10.0;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: totalHeight + bottomInset + bottomGap,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomInset,
            child: const ColoredBox(color: Color(0xFFFFF3E6)),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(6, 0, 6, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: selectedIndex.toDouble()),
                duration: const Duration(milliseconds: 340),
                curve: Curves.easeOutCubic,
                builder: (context, animatedIndex, _) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final slotWidth =
                          (constraints.maxWidth - (sideMargin * 2)) /
                          _items.length;
                      final activeCenterX =
                          sideMargin +
                          (animatedIndex * slotWidth) +
                          (slotWidth / 2);

                      return SizedBox(
                        height: totalHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CustomPaint(
                              size: const Size(double.infinity, totalHeight),
                              painter: _BottomNavSurfacePainter(
                                activeCenterX: activeCenterX,
                                bodyTop: bodyTop,
                                highlightRadius: highlightRadius,
                              ),
                              child: const SizedBox.expand(),
                            ),
                            Positioned.fill(
                              top: bodyTop + 10,
                              bottom: 8,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: sideMargin,
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
                            ),
                            Positioned(
                              left: activeCenterX - highlightRadius,
                              top: bodyTop - highlightRadius,
                              width: highlightRadius * 2,
                              height: highlightRadius * 2,
                              child: IgnorePointer(
                                child: Center(
                                  child: Icon(
                                    _items[selectedIndex].icon,
                                    color: AppColors.cinnamon,
                                    size: 29,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
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
    const passiveColor = Color(0xFFAFA8A1);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.cinnamon.withValues(alpha: 0.08),
        highlightColor: AppColors.cinnamon.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 27,
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOutCubic,
                    opacity: selected ? 0 : 1,
                    child: Icon(item.icon, color: passiveColor, size: 23),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                style: TextStyle(
                  color: selected ? AppColors.cinnamon : passiveColor,
                  fontSize: selected ? 11.5 : 10.5,
                  fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  height: 1.05,
                  letterSpacing: -0.1,
                ),
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavSurfacePainter extends CustomPainter {
  const _BottomNavSurfacePainter({
    required this.activeCenterX,
    required this.bodyTop,
    required this.highlightRadius,
  });

  final double activeCenterX;
  final double bodyTop;
  final double highlightRadius;

  @override
  void paint(Canvas canvas, Size size) {
    const barRadius = 31.0;
    final notchRadius = highlightRadius + 9;

    final clampedCenterX = activeCenterX.clamp(
      notchRadius + 6,
      size.width - notchRadius - 6,
    );

    final barRect = RRect.fromLTRBR(
      6,
      bodyTop,
      size.width - 6,
      size.height - 6,
      const Radius.circular(barRadius),
    );

    final barPath = Path()..addRRect(barRect);

    final notchPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(clampedCenterX, bodyTop),
          radius: notchRadius,
        ),
      );

    final surfacePath = Path.combine(
      PathOperation.difference,
      barPath,
      notchPath,
    );

    canvas.drawShadow(
      surfacePath,
      Colors.black.withValues(alpha: 0.08),
      18,
      false,
    );

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFFFFF), Color(0xFFFFF8F1)],
      ).createShader(Rect.fromLTWH(0, bodyTop, size.width, size.height));

    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = const Color(0xFFF0E3D7);

    final activeCirclePaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E4), Color(0xFFFFD9A8)],
          ).createShader(
            Rect.fromCircle(
              center: Offset(clampedCenterX, bodyTop),
              radius: highlightRadius,
            ),
          );

    final activeCircleStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = const Color(0xFFFFC98B);

    canvas.drawPath(surfacePath, fillPaint);
    canvas.drawPath(surfacePath, rimPaint);

    canvas.drawShadow(
      Path()..addOval(
        Rect.fromCircle(
          center: Offset(clampedCenterX, bodyTop),
          radius: highlightRadius,
        ),
      ),
      Colors.black.withValues(alpha: 0.07),
      10,
      false,
    );

    canvas.drawCircle(
      Offset(clampedCenterX, bodyTop),
      highlightRadius,
      activeCirclePaint,
    );

    canvas.drawCircle(
      Offset(clampedCenterX, bodyTop),
      highlightRadius,
      activeCircleStroke,
    );
  }

  @override
  bool shouldRepaint(covariant _BottomNavSurfacePainter oldDelegate) {
    return oldDelegate.activeCenterX != activeCenterX ||
        oldDelegate.bodyTop != bodyTop ||
        oldDelegate.highlightRadius != highlightRadius;
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
            !state.isExpandedAudioPlayerVisible &&
            !hasBadgeCelebration)
          const Positioned(
            left: 16,
            right: 16,
            bottom: 104,
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
              onPressed: () {
                context.read<AppState>().setExpandedAudioPlayerVisible(true);
                context.push(AppRoutes.audioPlayer);
              },
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
                  GlobalConfettiBurst(trigger: badge.id),
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
}
