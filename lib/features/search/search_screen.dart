import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/app_routes.dart';
import '../../shared/widgets/app_back_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _cardImage = 'asset/sleep page/sleep_card_bear_thumb.jpg';

  static const _stories = [
    _SearchStory('minik-ayicik-1', 'Minik Ayicik', 0.54),
    _SearchStory('minik-ayicik-2', 'Minik Ayicik', 1, completed: true),
    _SearchStory('minik-ayicik-3', 'Minik Ayicik', 0.54),
    _SearchStory('minik-ayicik-4', 'Minik Ayicik', 0.54),
    _SearchStory('minik-ayicik-5', 'Minik Ayicik', 0.54),
    _SearchStory('minik-ayicik-6', 'Minik Ayicik', 0.54),
  ];

  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredStories = _stories.where((story) {
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return story.title.toLowerCase().contains(query);
    }).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF4E6),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4E6),
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              24,
              6,
              24,
              MediaQuery.paddingOf(context).bottom + 118,
            ),
            children: [
              Row(
                children: [
                  AppBackButton(onTap: () => context.pop()),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SearchField(
                      controller: _controller,
                      query: _query,
                      onChanged: (value) => setState(() => _query = value),
                      onClear: () {
                        _controller.clear();
                        setState(() => _query = '');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              for (final story in filteredStories) ...[
                _SearchStoryCard(
                  imagePath: _cardImage,
                  story: story,
                  onTap: () => context.push(AppRoutes.story(story.id)),
                ),
                const SizedBox(height: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              cursorColor: Colors.black87,
              decoration: const InputDecoration(
                hintText: 'Masal Ara',
                hintStyle: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Icon(
              Icons.close_rounded,
              color: query.isEmpty
                  ? const Color(0xFF9D9D9D).withValues(alpha: 0.8)
                  : const Color(0xFF8B8B8B),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchStoryCard extends StatelessWidget {
  const _SearchStoryCard({
    required this.imagePath,
    required this.story,
    required this.onTap,
  });

  final String imagePath;
  final _SearchStory story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progressText = '%${(story.progress * 100).round()} Tamamlandi';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 68,
                  height: 88,
                  fit: BoxFit.cover,
                  cacheWidth: 180,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              story.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                          if (story.completed) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFB2551F),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Okundu',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        progressText,
                        style: const TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            children: [
                              Container(color: const Color(0xFFE4E4E4)),
                              FractionallySizedBox(
                                widthFactor: story.progress,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFFFC33A),
                                        Color(0xFFFF7B39),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchStory {
  const _SearchStory(
    this.id,
    this.title,
    this.progress, {
    this.completed = false,
  });

  final String id;
  final String title;
  final double progress;
  final bool completed;
}
