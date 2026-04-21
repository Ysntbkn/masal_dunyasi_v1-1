import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/section_scaffold.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final strings = AppStrings(state);

    return SectionScaffold(
      title: strings.sleepSounds,
      children: [
        RoundedActionCard(
          title: strings.isEnglishLabel('Rain and Book', 'Yağmur ve Kitap'),
          subtitle: strings.startMiniPlayer,
          icon: Icons.water_drop_rounded,
          onTap: () => context.read<AppState>().playSleepAudio(
            strings.isEnglishLabel('Rain and Book', 'Yağmur ve Kitap'),
          ),
        ),
        RoundedActionCard(
          title: strings.isEnglishLabel('Night Forest', 'Gece Ormanı'),
          subtitle: strings.startMiniPlayer,
          icon: Icons.forest_rounded,
          onTap: () => context.read<AppState>().playSleepAudio(
            strings.isEnglishLabel('Night Forest', 'Gece Ormanı'),
          ),
        ),
        RoundedActionCard(
          title: strings.isEnglishLabel('Soft Lullaby', 'Yumuşak Ninni'),
          subtitle: strings.startMiniPlayer,
          icon: Icons.music_note_rounded,
          onTap: () => context.read<AppState>().playSleepAudio(
            strings.isEnglishLabel('Soft Lullaby', 'Yumuşak Ninni'),
          ),
        ),
      ],
    );
  }
}
