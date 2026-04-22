import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const _backgroundImage = 'asset/rozet page/arkaplan_optimized.jpg';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1F5C98),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _AchievementsHero(
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
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 44),
              sliver: SliverGrid.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 38,
                  crossAxisSpacing: 34,
                  childAspectRatio: 0.93,
                ),
                itemBuilder: (context, index) {
                  return const _BadgeSlot();
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
  const _AchievementsHero({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 590,
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
                  const Color(0xFF1F5C98).withValues(alpha: 0.12),
                  const Color(0xFF1F5C98),
                ],
                stops: const [0, 0.58, 0.82, 1],
              ),
            ),
          ),
          Positioned(
            top: topPadding + 56,
            left: 40,
            child: Tooltip(
              message: 'Geri',
              child: GestureDetector(
                onTap: onBack,
                child: SvgPicture.asset(
                  'asset/icons/geri.svg',
                  width: 56,
                  height: 56,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 88,
            child: Text(
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
          ),
        ],
      ),
    );
  }
}

class _BadgeSlot extends StatelessWidget {
  const _BadgeSlot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
