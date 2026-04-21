import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const String _heroImage = 'asset/login page/Arkaplan.jpeg';
  static const String _closeIcon = 'asset/icons/close.svg';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: const Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              HeroImageSection(
                imagePath: _heroImage,
                closeIconPath: _closeIcon,
              ),
              _PanelPositioner(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelPositioner extends StatelessWidget {
  const _PanelPositioner();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Positioned(
      top: height * 0.46,
      left: 0,
      right: 0,
      bottom: 0,
      child: const BottomAuthPanel(),
    );
  }
}

class HeroImageSection extends StatelessWidget {
  const HeroImageSection({
    super.key,
    required this.imagePath,
    required this.closeIconPath,
  });

  final String imagePath;
  final String closeIconPath;

  @override
  Widget build(BuildContext context) {
    final heroHeight = MediaQuery.sizeOf(context).height * 0.55;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 32, left: 28),
                child: SizedBox(
                  width: 39,
                  height: 39,
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    icon: SvgPicture.asset(closeIconPath),
                    tooltip: 'Kapat',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomAuthPanel extends StatelessWidget {
  const BottomAuthPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<AppState>());

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(44)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cinnamon.withValues(alpha: 0.05),
            blurRadius: 22,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 360;
            final width = MediaQuery.sizeOf(context).width;
            final horizontalPadding = (width * 0.085).clamp(28.0, 36.0);
            final titleSize = compact ? 40.0 : 49.0;
            final buttonHeight = compact ? 49.0 : 58.0;
            final topGap = compact ? 26.0 : 35.0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topGap,
                horizontalPadding,
                compact ? 8 : 10,
              ),
              child: Column(
                children: [
                  Text(
                    strings.loginTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.cinnamon,
                      fontFamily: 'BreadMateTR',
                      fontSize: titleSize,
                      fontWeight: FontWeight.w400,
                      height: 0.92,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: compact ? 17 : 25),
                  Text(
                    strings.chooseMethod,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.purple,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: compact ? 12 : 18),
                  GoogleLoginButton(height: buttonHeight),
                  SizedBox(height: compact ? 13 : 18),
                  Text(
                    strings.or,
                    style: TextStyle(
                      color: AppColors.purple,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: compact ? 13 : 20),
                  GuestLoginButton(height: buttonHeight),
                  SizedBox(height: compact ? 18 : 25),
                  const TermsText(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<AppState>());

    return SizedBox(
      height: height,
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          context.read<AppState>().startSession();
          context.go(AppRoutes.name);
        },
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.peach,
          foregroundColor: AppColors.ink,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoogleMark(),
            const SizedBox(width: 54),
            Flexible(
              child: Text(
                strings.googleLogin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
              ),
            ),
            const SizedBox(width: 22),
          ],
        ),
      ),
    );
  }
}

class GuestLoginButton extends StatelessWidget {
  const GuestLoginButton({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<AppState>());

    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          context.read<AppState>().startSession();
          context.go(AppRoutes.name);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFAAA0A0),
          side: const BorderSide(color: Color(0xFFE6A995), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: const StadiumBorder(),
        ),
        child: Text(
          strings.guestLogin,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<AppState>());
    final baseStyle = TextStyle(
      color: AppColors.purple.withValues(alpha: 0.92),
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.28,
      letterSpacing: 0,
    );
    final linkStyle = baseStyle.copyWith(fontWeight: FontWeight.w700);

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: strings.termsStart),
          TextSpan(
            text: strings.termsOfService,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(text: strings.and),
          TextSpan(
            text: strings.privacyPolicy,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(text: strings.termsEnd),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class GoogleMark extends StatelessWidget {
  const GoogleMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 21,
      height: 21,
      child: CustomPaint(painter: _GoogleMarkPainter()),
    );
  }
}

class _GoogleMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.18;
    final rect = (Offset.zero & size).deflate(stroke / 2);

    Paint paint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.square;

    canvas.drawArc(rect, -0.48, 1.05, false, paint(const Color(0xFF4285F4)));
    canvas.drawArc(rect, 0.62, 1.03, false, paint(const Color(0xFF34A853)));
    canvas.drawArc(rect, 1.70, 1.05, false, paint(const Color(0xFFFBBC05)));
    canvas.drawArc(rect, 2.86, 1.18, false, paint(const Color(0xFFEA4335)));

    final blue = paint(const Color(0xFF4285F4))..strokeCap = StrokeCap.square;
    canvas.drawLine(
      Offset(size.width * 0.53, size.height * 0.51),
      Offset(size.width * 0.94, size.height * 0.51),
      blue,
    );
    canvas.drawLine(
      Offset(size.width * 0.82, size.height * 0.51),
      Offset(size.width * 0.68, size.height * 0.72),
      blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
