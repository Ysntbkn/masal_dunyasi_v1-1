import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    final title = _titleFromId(storyId);

    return Scaffold(
      appBar: AppBar(title: const Text('Masal Detayı')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: AppColors.peach,
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AppColors.cinnamon,
              size: 76,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            style: const TextStyle(color: AppColors.cinnamon, fontSize: 34),
          ),
          const SizedBox(height: 10),
          const Text(
            'Sıcak, sakin ve çocuk dostu bir masal. Okuma ve dinleme akışlarına buradan başlanır.',
            style: TextStyle(fontFamily: null, color: AppColors.lavender),
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.readStory(storyId)),
            icon: const Icon(Icons.menu_book_rounded),
            label: const Text('OKU'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => context.read<AppState>().playStoryAudio(title),
            icon: const Icon(Icons.headphones_rounded),
            label: const Text('Dinle'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => context.push(AppRoutes.trialStory(storyId)),
            child: const Text('Önce Dene'),
          ),
        ],
      ),
    );
  }
}

String _titleFromId(String id) {
  return id
      .split('-')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}
