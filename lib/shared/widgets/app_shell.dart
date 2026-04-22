import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    _BottomNavItem(Icons.bookmark_rounded, 'Kitapl\u0131k'),
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

    return Stack(
      children: [
        child,
        if (state.hasActiveAudio && state.onboardingComplete)
          const Positioned(
            left: 16,
            right: 16,
            bottom: 88,
            child: MiniPlayer(),
          ),
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
              tooltip: 'Oynatıcıyı aç',
            ),
            IconButton(
              onPressed: state.stopAudio,
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Kapat',
            ),
          ],
        ),
      ),
    );
  }
}
