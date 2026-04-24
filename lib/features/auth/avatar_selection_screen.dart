import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';
import 'widgets/auth_onboarding_widgets.dart';

class AvatarSelectionScreen extends StatelessWidget {
  const AvatarSelectionScreen({super.key});

  static const String _heroImage = 'asset/avatar page/avatar_optimized.jpeg';

  static const List<_AvatarOption> _avatars = [
    _AvatarOption('prenses', Color(0xFFF4B46F), Icons.face_4_rounded),
    _AvatarOption('kirmizi-baslik', Color(0xFF9ED6C0), Icons.face_3_rounded),
    _AvatarOption('buyucu', Color(0xFF7B789E), Icons.face_6_rounded),
    _AvatarOption('gezgin', Color(0xFFF0C07A), Icons.face_2_rounded),
    _AvatarOption('dedektif', Color(0xFFB6D79F), Icons.face_rounded),
    _AvatarOption('denizci', Color(0xFF86CFC7), Icons.face_retouching_natural),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              AuthHeroSection(
                imagePath: _heroImage,
                imageAlignment: const Alignment(0, 0.72),
                onBack: () => context.go(AppRoutes.name),
              ),
              _AvatarPanel(avatars: _avatars),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarPanel extends StatelessWidget {
  const _AvatarPanel({required this.avatars});

  final List<_AvatarOption> avatars;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final state = context.watch<AppState>();
    final strings = AppStrings(state);
    final selectedAvatar = state.avatar;

    return Positioned(
      top: AuthOnboardingMetrics.panelTopFor(height),
      left: 0,
      right: 0,
      bottom: 0,
      child: AuthPanelSurface(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = AuthOnboardingMetrics.isCompactPanel(
              constraints.maxHeight,
            );
            final width = MediaQuery.sizeOf(context).width;
            final horizontalPadding =
                AuthOnboardingMetrics.horizontalPaddingFor(width);
            final selectorHeight = AuthOnboardingMetrics.avatarSelectorHeight(
              compact,
            );
            final avatarItemSize = AuthOnboardingMetrics.avatarItemSize(
              compact,
            );

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                compact ? 25 : 36,
                horizontalPadding,
                compact ? 8 : 10,
              ),
              child: Column(
                children: [
                  AuthPanelTitle(text: strings.avatarTitle, compact: compact),
                  SizedBox(height: compact ? 17 : 25),
                  AuthPanelSubtitle(text: strings.chooseAvatar),
                  SizedBox(height: compact ? 12 : 18),
                  _AvatarSelectorCard(
                    avatars: avatars,
                    selectedAvatar: selectedAvatar,
                    height: selectorHeight,
                    avatarItemSize: avatarItemSize,
                  ),
                  SizedBox(height: compact ? 15 : 23),
                  AuthContinueButton(
                    label: strings.continueText,
                    onPressed: () => context.go(AppRoutes.trial),
                    compact: compact,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AvatarSelectorCard extends StatelessWidget {
  const _AvatarSelectorCard({
    required this.avatars,
    required this.selectedAvatar,
    required this.height,
    required this.avatarItemSize,
  });

  final List<_AvatarOption> avatars;
  final String selectedAvatar;
  final double height;
  final double avatarItemSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6A995)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: avatars
                .take(3)
                .map(
                  (avatar) => _AvatarBubble(
                    avatar: avatar,
                    selected: avatar.id == selectedAvatar,
                    size: avatarItemSize,
                  ),
                )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: avatars
                .skip(3)
                .map(
                  (avatar) => _AvatarBubble(
                    avatar: avatar,
                    selected: avatar.id == selectedAvatar,
                    size: avatarItemSize,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({
    required this.avatar,
    required this.selected,
    required this.size,
  });

  final _AvatarOption avatar;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final innerSize = size - 6;

    return GestureDetector(
      onTap: () => context.read<AppState>().selectAvatar(avatar.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: size,
        height: size,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.cinnamon : Colors.transparent,
            width: 2,
          ),
        ),
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatar.color,
          ),
          child: Icon(avatar.icon, color: Colors.white, size: innerSize * 0.58),
        ),
      ),
    );
  }
}

class _AvatarOption {
  const _AvatarOption(this.id, this.color, this.icon);

  final String id;
  final Color color;
  final IconData icon;
}
