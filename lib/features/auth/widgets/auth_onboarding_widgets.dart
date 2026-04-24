import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme.dart';
import '../../../shared/widgets/app_back_button.dart';

abstract final class AuthOnboardingMetrics {
  static const double heroHeightFactor = 0.55;
  static const double panelTopFactor = 0.46;
  static const double panelRadius = 44;

  static double heroHeightFor(double screenHeight) =>
      screenHeight * heroHeightFactor;

  static double panelTopFor(double screenHeight) =>
      screenHeight * panelTopFactor;

  static double horizontalPaddingFor(double screenWidth) =>
      (screenWidth * 0.085).clamp(28.0, 36.0);

  static bool isCompactPanel(double panelHeight) => panelHeight < 360;

  static double titleSize(bool compact) => compact ? 34.0 : 41.0;

  static double controlHeight(bool compact) => compact ? 40.0 : 48.0;

  static double continueButtonHeight(bool compact) => compact ? 48.0 : 58.0;

  static double avatarSelectorHeight(bool compact) => compact ? 112.0 : 132.0;

  static double avatarItemSize(bool compact) => compact ? 48.0 : 56.0;
}

class AuthHeroSection extends StatelessWidget {
  const AuthHeroSection({
    super.key,
    required this.imagePath,
    required this.onBack,
    this.imageAlignment = Alignment.topCenter,
  });

  final String imagePath;
  final VoidCallback onBack;
  final AlignmentGeometry imageAlignment;

  @override
  Widget build(BuildContext context) {
    final heroHeight = AuthOnboardingMetrics.heroHeightFor(
      MediaQuery.sizeOf(context).height,
    );

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover, alignment: imageAlignment),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 28, left: 28),
                child: AppBackButton(onTap: onBack),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPanelSurface extends StatelessWidget {
  const AuthPanelSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AuthOnboardingMetrics.panelRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinnamon.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class AuthPanelTitle extends StatelessWidget {
  const AuthPanelTitle({super.key, required this.text, required this.compact});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.cinnamon,
        fontFamily: 'BreadMateTR',
        fontSize: AuthOnboardingMetrics.titleSize(compact),
        fontWeight: FontWeight.w400,
        height: 0.92,
        letterSpacing: 0,
      ),
    );
  }
}

class AuthPanelSubtitle extends StatelessWidget {
  const AuthPanelSubtitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.purple,
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.1,
        letterSpacing: 0,
      ),
    );
  }
}

class AuthContinueButton extends StatelessWidget {
  const AuthContinueButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.compact,
  });

  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AuthOnboardingMetrics.continueButtonHeight(compact),
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.cinnamon,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
