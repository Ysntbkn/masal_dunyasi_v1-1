import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

enum _PremiumPlan { monthly, yearly }

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  static const _backgroundImage = 'asset/profil page/background_optimized.jpg';

  _PremiumPlan _selectedPlan = _PremiumPlan.yearly;

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<AppState>().isPremium;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFE49E),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFE49E),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final compact = height < 760;

            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: -120,
                  left: 0,
                  right: 0,
                  bottom: 120,
                  child: Image.asset(
                    _backgroundImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.02),
                        Colors.black.withValues(alpha: 0.08),
                        const Color(0xFFFFE7A8).withValues(alpha: 0.42),
                        const Color(0xFFFFE49E).withValues(alpha: 0.98),
                        const Color(0xFFFFE49E),
                      ],
                      stops: const [0, 0.24, 0.34, 0.48, 1],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      compact ? 10 : 16,
                      24,
                      compact ? 10 : 18,
                    ),
                    child: Column(
                      children: [
                        _PremiumTopBar(
                          onBack: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.home);
                            }
                          },
                        ),
                        const Spacer(flex: 8),
                        SizedBox(height: compact ? 22 : 34),
                        _PremiumContent(
                          compact: compact,
                          selectedPlan: _selectedPlan,
                          isPremium: isPremium,
                          onPlanChanged: (plan) =>
                              setState(() => _selectedPlan = plan),
                          onContinue: () =>
                              context.read<AppState>().setPremium(true),
                          onRevert: () =>
                              context.read<AppState>().setPremium(false),
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PremiumTopBar extends StatelessWidget {
  const _PremiumTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TopIconButton(
          icon: Icons.chevron_left_rounded,
          tooltip: 'Geri',
          onTap: onBack,
        ),
        const Spacer(),
      ],
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: const Color(0xFFA84E2B),
        borderRadius: BorderRadius.circular(3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

class _PremiumContent extends StatelessWidget {
  const _PremiumContent({
    required this.compact,
    required this.selectedPlan,
    required this.isPremium,
    required this.onPlanChanged,
    required this.onContinue,
    required this.onRevert,
  });

  final bool compact;
  final _PremiumPlan selectedPlan;
  final bool isPremium;
  final ValueChanged<_PremiumPlan> onPlanChanged;
  final VoidCallback onContinue;
  final VoidCallback onRevert;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'PREMIUM OL',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.cinnamon,
            fontFamily: 'BreadMateTR',
            fontSize: compact ? 34 : 42,
            height: 0.92,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: compact ? 10 : 14),
        Text(
          'T\u00fcm Masal ve Seslerin Kilidini A\u00e7\u0131n',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.cinnamon,
            fontSize: compact ? 15 : 18,
            fontWeight: FontWeight.w500,
            height: 1.1,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: compact ? 6 : 8),
        Text(
          '\u00c7ocu\u011funuzu hayal g\u00fcc\u00fcn\u00fc destekleyen\ng\u00fcvenli bir masal d\u00fcnyas\u0131na eri\u015fin.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: compact ? 10 : 12,
            fontWeight: FontWeight.w500,
            height: 1.25,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: compact ? 14 : 20),
        _PlanButton(
          label: 'Ayl\u0131k',
          price: '36 TL',
          selected: selectedPlan == _PremiumPlan.monthly,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onTap: () => onPlanChanged(_PremiumPlan.monthly),
        ),
        SizedBox(height: compact ? 10 : 14),
        _PlanButton(
          label: 'Y\u0131ll\u0131k',
          price: '360 TL',
          selected: selectedPlan == _PremiumPlan.yearly,
          backgroundColor: const Color(0xFF43BBD3),
          foregroundColor: Colors.white,
          onTap: () => onPlanChanged(_PremiumPlan.yearly),
        ),
        SizedBox(height: compact ? 10 : 14),
        const Text(
          '\u0130stedi\u011finiz zaman iptal edebilirsiniz - Taahh\u00fct yok',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
        ),
        SizedBox(height: compact ? 14 : 20),
        _ContinueButton(onTap: onContinue),
        SizedBox(height: compact ? 8 : 12),
        TextButton(
          onPressed: onRevert,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF6F2DBD),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          child: Text(
            isPremium
                ? 'Geri Al'
                : 'Sat\u0131n Al\u0131mlar\u0131 Geri Y\u00fckle',
          ),
        ),
      ],
    );
  }
}

class _PlanButton extends StatelessWidget {
  const _PlanButton({
    required this.label,
    required this.price,
    required this.selected,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  final String label;
  final String price;
  final bool selected;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 62,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 104,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    price,
                    maxLines: 1,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: foregroundColor, width: 1.2),
                  color: selected
                      ? foregroundColor.withValues(alpha: 0.12)
                      : Colors.transparent,
                ),
                child: selected
                    ? Center(
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: foregroundColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: Ink(
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF32D4), Color(0xFFFF6E37)],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: const Center(
            child: Text(
              'Devam Et',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
