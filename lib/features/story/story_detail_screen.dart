import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../core/stories/story_catalog.dart';
import '../../shared/theme/app_theme.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    final story = storyCatalogEntryFor(storyId);
    final state = context.watch<AppState>();
    final isFavorite = state.isFavoriteStory(storyId);
    final relatedStories = _relatedStoriesFor(story);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF6ED),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF6ED),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _StoryHero(
                imagePath: story.imagePath,
                isFavorite: isFavorite,
                onBack: () => context.pop(),
                onFavorite: () => context.read<AppState>().toggleFavorite(storyId),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -26),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF6ED),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
                    child: Column(
                      children: [
                        Text(
                          story.title.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.cinnamon,
                            fontFamily: 'BreadMateTR',
                            fontSize: 34,
                            height: 0.95,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _PrimaryActionButton(
                          label: 'Oku',
                          color: AppColors.cinnamon,
                          icon: Icons.menu_book_rounded,
                          onTap: () {
                            context.read<AppState>().startReadingStory(storyId);
                            context.push(AppRoutes.readStory(storyId));
                          },
                        ),
                        const SizedBox(height: 12),
                        _PrimaryActionButton(
                          label: 'Dinle',
                          color: const Color(0xFFD8BE72),
                          icon: Icons.play_arrow_rounded,
                          onTap: () {
                            final appState = context.read<AppState>();
                            appState.playStoryAudio(story.title);
                            context.push(AppRoutes.audioPlayer);
                          },
                        ),
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            story.summary,
                            style: const TextStyle(
                              color: Color(0xFF7B6D61),
                              fontSize: 14,
                              height: 1.55,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            for (final category in story.categories)
                              _CategoryChip(label: category),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Benzer Hikayeler',
                            style: TextStyle(
                              color: Color(0xFF1FA6BE),
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 132,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedStories.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final related = relatedStories[index];
                              return _RelatedStoryCard(
                                story: related,
                                onTap: () => context.pushReplacement(
                                  AppRoutes.story(related.id),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<StoryCatalogEntry> _relatedStoriesFor(StoryCatalogEntry story) {
    final ids = <String>{
      ...story.relatedStoryIds,
      ...storyCatalog.keys.where((id) => id != story.id),
    };

    return ids
        .where((id) => id != story.id)
        .take(6)
        .map(storyCatalogEntryFor)
        .toList();
  }
}

class _StoryHero extends StatelessWidget {
  const _StoryHero({
    required this.imagePath,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
  });

  final String imagePath;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.10),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.12),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            top: topPadding + 12,
            child: _HeroIconButton(
              icon: Icons.chevron_left_rounded,
              onTap: onBack,
            ),
          ),
          Positioned(
            right: 18,
            top: topPadding + 12,
            child: _HeroIconButton(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              onTap: onFavorite,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cinnamon,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Ink(
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF5B5B5B),
          fontSize: 11,
          fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          width: 92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        story.imagePath,
                        width: 92,
                        height: double.infinity,
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
                          color: Color(0xFFD7B35C),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                          size: 12,
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
                  color: AppColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
