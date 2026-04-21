import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/section_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final strings = AppStrings(state);

    return SectionScaffold(
      title: strings.profile,
      actions: [
        IconButton(
          onPressed: () => context.push(AppRoutes.settings),
          icon: const Icon(Icons.settings_rounded),
          tooltip: strings.settings,
        ),
      ],
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.peach,
                  child: Icon(
                    Icons.face_5_rounded,
                    color: AppColors.cinnamon,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userName,
                        style: const TextStyle(fontSize: 28),
                      ),
                      Text(
                        state.isPremium
                            ? strings.premiumActive
                            : strings.freeAccount,
                        style: const TextStyle(
                          fontFamily: null,
                          color: AppColors.lavender,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RoundedActionCard(
          title: strings.premium,
          subtitle: strings.isEnglishLabel(
            'View monthly and yearly plans.',
            'Aylık ve yıllık paketleri gör.',
          ),
          icon: Icons.diamond_rounded,
          onTap: () => context.push(AppRoutes.premium),
        ),
        RoundedActionCard(
          title: strings.achievements,
          subtitle: strings.isEnglishLabel(
            'Review your achievements.',
            'Başarılarını incele.',
          ),
          icon: Icons.emoji_events_rounded,
          onTap: () => context.push(AppRoutes.achievements),
        ),
        RoundedActionCard(
          title: strings.settings,
          subtitle: strings.isEnglishLabel(
            'Language, privacy, and feedback.',
            'Dil, gizlilik ve geri bildirim.',
          ),
          icon: Icons.settings_rounded,
          onTap: () => context.push(AppRoutes.settings),
        ),
      ],
    );
  }
}
