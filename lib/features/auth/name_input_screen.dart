import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';
import 'widgets/auth_onboarding_widgets.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  static const String _heroImage = 'asset/login page/Arkaplan.jpeg';
  static const String _backIcon = 'asset/icons/geri.svg';

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    context.read<AppState>().saveName(_controller.text);
    context.go(AppRoutes.avatar);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox.expand(
          child: Stack(
            children: [
              AuthHeroSection(
                imagePath: _heroImage,
                backIconPath: _backIcon,
                onBack: () => context.go(AppRoutes.login),
              ),
              _NamePanel(
                controller: _controller,
                focusNode: _focusNode,
                onContinue: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NamePanel extends StatelessWidget {
  const _NamePanel({
    required this.controller,
    required this.focusNode,
    required this.onContinue,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final media = MediaQuery.of(context);
    final state = context.watch<AppState>();
    final strings = AppStrings(state);
    final keyboardInset = media.viewInsets.bottom;
    final keyboardVisible = keyboardInset > 0;
    final panelTop = keyboardVisible
        ? media.padding.top + 88.0
        : AuthOnboardingMetrics.panelTopFor(height);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
      top: panelTop,
      left: 0,
      right: 0,
      bottom: keyboardVisible ? keyboardInset : 0,
      child: AuthPanelSurface(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = AuthOnboardingMetrics.isCompactPanel(
              constraints.maxHeight,
            );
            final width = MediaQuery.sizeOf(context).width;
            final horizontalPadding =
                AuthOnboardingMetrics.horizontalPaddingFor(width);
            final controlHeight = AuthOnboardingMetrics.controlHeight(compact);

            return Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                compact ? 25 : 36,
                horizontalPadding,
                compact ? 8 : 10,
              ),
              child: Column(
                children: [
                  AuthPanelTitle(text: strings.nameTitle, compact: compact),
                  SizedBox(height: compact ? 17 : 25),
                  AuthPanelSubtitle(text: strings.enterName),
                  SizedBox(height: compact ? 12 : 18),
                  SizedBox(
                    height: controlHeight,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => onContinue(),
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: strings.nameHint,
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAA0A0),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 0,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: const BorderSide(
                            color: Color(0xFFE6A995),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: const BorderSide(
                            color: AppColors.cinnamon,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 12 : 17),
                  Text(
                    strings.chooseLanguage,
                    style: const TextStyle(
                      color: AppColors.purple,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: compact ? 9 : 12),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguagePill(
                          label: 'T\u00fcrk\u00e7e',
                          selected: state.languageCode == 'tr',
                          onTap: () =>
                              context.read<AppState>().setLanguage('tr'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _LanguagePill(
                          label: 'English',
                          selected: state.languageCode == 'en',
                          onTap: () =>
                              context.read<AppState>().setLanguage('en'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 23 : 36),
                  AuthContinueButton(
                    label: strings.continueText,
                    onPressed: onContinue,
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

class _LanguagePill extends StatelessWidget {
  const _LanguagePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE6A995)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.cinnamon : Colors.white,
                border: Border.all(color: const Color(0xFFE6A995)),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
