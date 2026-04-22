import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _backgroundImage =
      'asset/profil page/profile_background_optimized.jpg';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final avatar = _ProfileAvatarStyle.fromId(state.avatar);
    final name = state.userName.trim().isEmpty ? 'Demet' : state.userName;
    final email = '${name.trim().toLowerCase()}@gmail.com';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFF8A68),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFF8A68),
        body: Stack(
          children: [
            const _ProfileBackground(),
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
                    sliver: SliverList.list(
                      children: [
                        _ProfileTopBar(
                          onBack: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.home);
                            }
                          },
                          onSettings: () => context.push(AppRoutes.settings),
                        ),
                        const SizedBox(height: 30),
                        _ProfileCard(
                          avatar: avatar,
                          name: name,
                          email: email,
                          isPremium: state.isPremium,
                        ),
                        const SizedBox(height: 40),
                        _PremiumButton(
                          onTap: () => context.push(AppRoutes.premium),
                        ),
                        const SizedBox(height: 42),
                        const _StatsRow(),
                        const SizedBox(height: 38),
                        const Text(
                          'Okuma Hedefleri',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const _GoalCard(
                          iconPath: 'asset/icons/gunluk hedef.webp',
                          title: 'G\u00fcnl\u00fck Hedef',
                          progress: 0.58,
                        ),
                        const SizedBox(height: 20),
                        const _GoalCard(
                          iconPath: 'asset/icons/ayl\u0131k hedef.webp',
                          title: 'Ayl\u0131k Hedef',
                          progress: 0.58,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -22,
          left: -20,
          right: -20,
          height: 510,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Image.asset(
              ProfileScreen._backgroundImage,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF41A7E6).withValues(alpha: 0.42),
                Colors.white.withValues(alpha: 0.06),
                const Color(0xFFFFA06F).withValues(alpha: 0.92),
                const Color(0xFFFF7D5D),
              ],
              stops: const [0, 0.34, 0.54, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({required this.onBack, required this.onSettings});

  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfileIconButton(
          iconPath: 'asset/icons/geri.svg',
          tooltip: 'Geri',
          onTap: onBack,
        ),
        const Expanded(
          child: Text(
            'PROF\u0130L\u0130M',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'BreadMateTR',
              fontSize: 43,
              height: 0.92,
              letterSpacing: 0,
            ),
          ),
        ),
        _ProfileIconButton(
          iconPath: 'asset/icons/ayarlar.svg',
          tooltip: 'Ayarlar',
          onTap: onSettings,
        ),
      ],
    );
  }
}

class _ProfileIconButton extends StatelessWidget {
  const _ProfileIconButton({
    required this.iconPath,
    required this.tooltip,
    required this.onTap,
  });

  final String iconPath;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          child: SvgPicture.asset(iconPath, width: 44, height: 44),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.avatar,
    required this.name,
    required this.email,
    required this.isPremium,
  });

  final _ProfileAvatarStyle avatar;
  final String name;
  final String email;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatar.backgroundColor,
                  border: Border.all(color: AppColors.cinnamon, width: 6),
                ),
                child: Icon(avatar.icon, color: Colors.white, size: 72),
              ),
              Positioned(
                right: -4,
                top: 14,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE5E5E5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.black,
                    size: 21,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.cinnamon,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF9D9D9D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          if (isPremium) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD47C),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Premium Hesap',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.cinnamon,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF33D0), Color(0xFFFF6A3A)],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: const Center(
              child: Text(
                'Premium Ol',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            iconPath: 'asset/icons/okunan.webp',
            value: '3',
            label: 'Okunan',
          ),
        ),
        SizedBox(width: 28),
        Expanded(
          child: _StatCard(
            iconPath: 'asset/icons/favoriler.webp',
            value: '3',
            label: 'Favoriler',
          ),
        ),
        SizedBox(width: 28),
        Expanded(
          child: _StatCard(
            iconPath: 'asset/icons/rozet.webp',
            value: '3',
            label: 'Rozet',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.iconPath,
    required this.value,
    required this.label,
  });

  final String iconPath;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -25,
            child: Image.asset(
              iconPath,
              width: 72,
              height: 58,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.cinnamon,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.iconPath,
    required this.title,
    required this.progress,
  });

  final String iconPath;
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      padding: const EdgeInsets.fromLTRB(26, 24, 32, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF696969),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Bug\u00fcnk\u00fc okuma s\u00fcresi',
                  style: TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '10/30 dk',
                  style: TextStyle(
                    color: Color(0xFF5A5A5A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5E5E5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFC74A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatarStyle {
  const _ProfileAvatarStyle({
    required this.backgroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final IconData icon;

  static _ProfileAvatarStyle fromId(String avatarId) {
    return switch (avatarId) {
      'prenses' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFF4B46F),
        icon: Icons.face_4_rounded,
      ),
      'kirmizi-baslik' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFF9ED6C0),
        icon: Icons.face_3_rounded,
      ),
      'buyucu' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFF7B789E),
        icon: Icons.face_6_rounded,
      ),
      'gezgin' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFF0C07A),
        icon: Icons.face_2_rounded,
      ),
      'dedektif' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFB6D79F),
        icon: Icons.face_rounded,
      ),
      'denizci' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFF86CFC7),
        icon: Icons.face_retouching_natural,
      ),
      _ => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFF4B46F),
        icon: Icons.face_4_rounded,
      ),
    };
  }
}
