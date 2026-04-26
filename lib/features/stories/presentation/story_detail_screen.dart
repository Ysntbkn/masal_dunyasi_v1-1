import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/state/app_state.dart';
import '../../../core/stories/story_catalog.dart';
import 'story_audio_player_screen.dart';
import 'story_reader_screen.dart';
import 'story_screen_shared.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    final story = storyCatalogEntryFor(storyId);
    final coverPath = resolveStoryCoverPath(story);
    final relatedStories = _resolveRelatedStories(story);
    final isFavorite = context.watch<AppState>().isFavoriteStory(storyId);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF3E6),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E6),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                StoryHeroImage(
                  imagePath: coverPath,
                  height: MediaQuery.sizeOf(context).height * 0.44,
                  bottomRadius: 26,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 0, 24),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          storyDisplayTitle(story),
                          textAlign: TextAlign.center,
                          style: storyTitleStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 26),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: StoryPrimaryButton(
                          label: 'Oku',
                          icon: Icons.menu_book_rounded,
                          color: const Color(0xFFB55222),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    StoryReaderScreen(storyId: storyId),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: StoryPrimaryButton(
                          label: 'Dinle',
                          icon: Icons.play_arrow_rounded,
                          color: const Color(0xFFD4B875),
                          onTap: () {
                            context.read<AppState>().playStoryAudio(
                              story.title,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => StoryAudioPlayerScreen(
                                  storyId: storyId,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          for (final label in _chipLabels(story))
                            _StoryChip(label: label),
                        ],
                      ),
                      const SizedBox(height: 34),
                      const Text(
                        'Benzer Hikayeler',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF269C9A),
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            for (final item in relatedStories)
                              _RelatedStoryCard(
                                story: item,
                                onTap: () => context.pushReplacement(
                                  AppRoutes.story(item.id),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    StoryBackIconButton(
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    StoryOverlayIconButton(
                      icon: isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      onTap: () =>
                          context.read<AppState>().toggleFavorite(storyId),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _chipLabels(StoryCatalogEntry story) {
    final labels = story.categories.take(4).toList();
    if (labels.length >= 4) return labels;
    return [...labels, ...List.generate(4 - labels.length, (_) => 'Kategori')];
  }

  List<StoryCatalogEntry> _resolveRelatedStories(StoryCatalogEntry story) {
    final uniqueIds = <String>{
      ...story.relatedStoryIds.where((id) => id != story.id),
      ...storyCatalog.keys.where((id) => id != story.id),
    }.take(3);
    return uniqueIds.map(storyCatalogEntryFor).toList();
  }
}

class _StoryChip extends StatelessWidget {
  const _StoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E1DA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF6E655D),
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _RelatedStoryCard extends StatelessWidget {
  const _RelatedStoryCard({required this.story, required this.onTap});

  final StoryCatalogEntry story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 108,
          height: 156,
          child: Column(
            children: [
              SizedBox(
                height: 126,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        resolveStoryCoverPath(story),
                        width: 108,
                        height: 126,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 4,
                      top: 4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD8B45F),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          size: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                story.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF564A42),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
