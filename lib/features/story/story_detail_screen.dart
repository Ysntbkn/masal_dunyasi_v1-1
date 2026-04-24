import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../core/stories/story_catalog.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_back_button.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    final story = storyCatalogEntryFor(storyId);
    final state = context.watch<AppState>();
    final isFavorite = state.isFavoriteStory(storyId);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppBackButtonAppBarLeading.leadingWidth,
        leading: AppBackButtonAppBarLeading(
          onTap: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<AppState>().toggleFavorite(storyId),
            icon: Icon(
              isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: const Color(0xFFB2551F),
            ),
            tooltip: 'Favorilere ekle',
          ),
          const SizedBox(width: 8),
        ],
        title: const Text('Masal Detay\u0131'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.peach,
              borderRadius: BorderRadius.circular(28),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(story.imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            story.title,
            style: const TextStyle(color: AppColors.cinnamon, fontSize: 34),
          ),
          const SizedBox(height: 10),
          const Text(
            'S\u0131cak, sakin ve \u00e7ocuk dostu bir masal. Okuma ve dinleme ak\u0131\u015flar\u0131na buradan ba\u015flan\u0131r.',
            style: TextStyle(fontFamily: null, color: AppColors.lavender),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: () {
              context.read<AppState>().startReadingStory(storyId);
              context.push(AppRoutes.readStory(storyId));
            },
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('OKU'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () =>
                context.read<AppState>().playStoryAudio(story.title),
            icon: const Icon(Icons.headphones_rounded),
            label: const Text('Dinle'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.push(AppRoutes.trialStory(storyId)),
            child: const Text('\u00d6nce Dene'),
          ),
        ],
      ),
    );
  }
}
