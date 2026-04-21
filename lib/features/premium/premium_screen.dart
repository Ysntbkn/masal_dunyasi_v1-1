import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/section_scaffold.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Premium',
      children: [
        const Text(
          'Masal Dünyası Premium',
          style: TextStyle(color: AppColors.cinnamon, fontSize: 34),
        ),
        const SizedBox(height: 12),
        RoundedActionCard(
          title: 'Aylık Paket',
          subtitle: 'Tüm masallar ve sesler',
          icon: Icons.calendar_month_rounded,
          onTap: () => context.read<AppState>().setPremium(true),
        ),
        RoundedActionCard(
          title: 'Yıllık Paket',
          subtitle: 'En avantajlı seçenek',
          icon: Icons.workspace_premium_rounded,
          onTap: () => context.read<AppState>().setPremium(true),
        ),
        OutlinedButton(
          onPressed: () => context.read<AppState>().setPremium(true),
          child: const Text('Restore Purchase'),
        ),
      ],
    );
  }
}
