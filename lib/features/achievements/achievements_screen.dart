import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/achievements/badge_catalog.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/app_back_button.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const _backgroundImage = 'asset/rozet page/arkaplan_optimized.jpg';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final heroHeight = (screenHeight * 0.42).clamp(360.0, 430.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF2A66A4),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _AchievementsHero(
                height: heroHeight,
                onBack: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 148),
              sliver: SliverGrid.builder(
                itemCount: badgeCatalog.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) {
                  final badge = badgeCatalog[index];
                  return _BadgeSlot(badge: badge);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementsHero extends StatelessWidget {
  const _AchievementsHero({required this.height, required this.onBack});

  final double height;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AchievementsScreen._backgroundImage,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.3),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.08),
                  Colors.transparent,
                  const Color(0xFF2A66A4).withValues(alpha: 0.18),
                  const Color(0xFF2A66A4),
                ],
                stops: const [0, 0.58, 0.82, 1],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
              child: Column(
                children: [
                  AppHeaderBar(onBack: onBack, horizontalPadding: 0),
                  const Spacer(),
                  const Text(
                    'ROZETLER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'BreadMateTR',
                      fontSize: 54,
                      height: 0.92,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeSlot extends StatelessWidget {
  const _BadgeSlot({required this.badge});

  final BadgeDefinition badge;

  static const _greyscaleMatrix = <double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    final unlocked = context.select<AppState, bool>(
      (state) => state.isBadgeUnlocked(badge.id),
    );
    Widget image = Padding(
      padding: const EdgeInsets.all(4),
      child: Image.asset(
        badge.assetPath,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );

    if (!unlocked) {
      image = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_greyscaleMatrix),
        child: Opacity(opacity: 0.78, child: image),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showPreview(context, unlocked),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: image,
          ),
        ),
      ),
    );
  }

  Future<void> _showPreview(BuildContext context, bool unlocked) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: const Color(0xFFFFF9F2),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2F2A25),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 240,
                  height: 240,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: unlocked
                      ? Image.asset(badge.assetPath, fit: BoxFit.contain)
                      : ColorFiltered(
                          colorFilter: const ColorFilter.matrix(
                            _greyscaleMatrix,
                          ),
                          child: Opacity(
                            opacity: 0.78,
                            child: Image.asset(
                              badge.assetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF2A66A4),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Kapat'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
