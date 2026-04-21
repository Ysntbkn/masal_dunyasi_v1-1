import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/section_scaffold.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(context.watch<AppState>());

    return SectionScaffold(
      title: strings.library,
      children: [
        Text(strings.continueReading, style: const TextStyle(fontSize: 26)),
        StoryCard(
          title: strings.isEnglishLabel('Moonlight Forest', 'Ay Işığı Ormanı'),
          subtitle: strings.isEnglishLabel(
            'Continue from page 3',
            '3. sayfadan devam et',
          ),
          onTap: () => context.push(AppRoutes.story('ay-isigi-ormani')),
        ),
        const SizedBox(height: 14),
        Text(strings.favorites, style: const TextStyle(fontSize: 26)),
        StoryCard(
          title: strings.isEnglishLabel('Song of the Wind', 'Rüzgarın Şarkısı'),
          subtitle: strings.isEnglishLabel('Favorite story', 'Favori masal'),
          onTap: () => context.push(AppRoutes.story('ruzgarin-sarkisi')),
        ),
        const SizedBox(height: 14),
        Text(strings.readStories, style: const TextStyle(fontSize: 26)),
        StoryCard(
          title: strings.isEnglishLabel('Cloud Palace', 'Bulut Sarayı'),
          subtitle: strings.isEnglishLabel('Completed', 'Tamamlandı'),
          onTap: () => context.push(AppRoutes.story('bulut-sarayi')),
        ),
      ],
    );
  }
}
