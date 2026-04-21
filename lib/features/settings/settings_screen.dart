import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';
import '../../shared/widgets/section_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Ayarlar',
      children: [
        RoundedActionCard(
          title: 'Dil Seçimi',
          subtitle: 'Türkçe',
          icon: Icons.language_rounded,
          onTap: () {},
        ),
        RoundedActionCard(
          title: 'Gizlilik Politikası',
          subtitle: 'Politika sayfasını aç',
          icon: Icons.privacy_tip_rounded,
          onTap: () {},
        ),
        RoundedActionCard(
          title: 'Geri Bildirim',
          subtitle: 'Bize fikrini söyle',
          icon: Icons.feedback_rounded,
          onTap: () {},
        ),
        RoundedActionCard(
          title: 'Çıkış Yap',
          subtitle: 'Onboarding akışına dön',
          icon: Icons.logout_rounded,
          onTap: context.read<AppState>().signOut,
        ),
      ],
    );
  }
}
