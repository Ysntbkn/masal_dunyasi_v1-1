import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _coverImage =
      'asset/books/freepik_cute-little-bear-standing_2791150604.png';
  static const _adSlides = [
    AdSlide(
      title: 'PREMIUM OL',
      subtitle:
          'S\u0131n\u0131rs\u0131z masal, uyku sesi ve \u00f6zel koleksiyonlar.',
      imagePath: 'asset/home page/premium.png',
    ),
    AdSlide(
      title: 'REKLAMSIZ DENEY\u0130M',
      subtitle: 'Masal keyfi b\u00f6l\u00fcnmeden devam etsin.',
      imagePath: 'asset/home page/no ads.png',
    ),
  ];

  static const _skills = [
    StoryTile('ormani-kesfet', 'Ke\u015ffet', _coverImage),
    StoryTile('minik-dostlar', 'Dostluk', _coverImage),
    StoryTile('uyku-yolculugu', 'Uyku', _coverImage),
  ];

  static const _categories = [
    CategoryTile('hayvanlar', 'Hayvanlar', _coverImage),
    CategoryTile('uyku', 'Uyku', _coverImage),
    CategoryTile('fantastik', 'Fantastik', _coverImage),
  ];

  static const _tags = [
    'Macera',
    'Uyku',
    'E\u011fitici',
    'Fantastik',
    'Hayvanlar',
    'Dostluk',
  ];

  final PageController _adController = PageController();
  Timer? _adTimer;
  int _adIndex = 0;

  @override
  void initState() {
    super.initState();
    _adTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || _adSlides.length < 2) return;
      final next = (_adIndex + 1) % _adSlides.length;
      _adController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _adController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = context.watch<AppState>().isPremium;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            sliver: SliverList.list(
              children: [
                FeaturedCard(
                  imagePath: _coverImage,
                  onTap: () =>
                      context.push(AppRoutes.story('ucretsiz-masallar')),
                  onProfileTap: () => context.push(AppRoutes.profile),
                ),
                if (!isPremium) ...[
                  const SizedBox(height: 18),
                  PremiumAdSlider(
                    controller: _adController,
                    slides: _adSlides,
                    activeIndex: _adIndex,
                    onPageChanged: (index) => setState(() => _adIndex = index),
                    onTap: () => context.push(AppRoutes.premium),
                  ),
                ],
                const SizedBox(height: 18),
                SectionHeader(
                  title: 'Yeteneklerini Ke\u015ffet',
                  actionLabel: 'T\u00fcm\u00fcn\u00fc G\u00f6r',
                  onAction: () => context.push(AppRoutes.categories),
                ),
                const SizedBox(height: 10),
                HorizontalStoryList(items: _skills),
                const SizedBox(height: 22),
                CategoryBlock(
                  title: 'MACERAYA \u00c7IKALIM',
                  categoryId: 'macera',
                  backgroundImage:
                      'asset/home page/maceraya \u00e7\u0131kal\u0131m.jpg',
                  accentColor: const Color(0xFF63B8CD),
                  stories: _skills,
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Kategoriler',
                  actionLabel: 'T\u00fcm\u00fcn\u00fc G\u00f6r',
                  onAction: () => context.push(AppRoutes.categories),
                ),
                const SizedBox(height: 10),
                CategoryStrip(items: _categories),
                const SizedBox(height: 22),
                CategoryBlock(
                  title: 'HAYVANLAR ALEM\u0130',
                  categoryId: 'hayvanlar',
                  backgroundImage: 'asset/home page/hayvanlar alemi.jpg',
                  accentColor: const Color(0xFF2F9B78),
                  stories: _skills,
                ),
                const SizedBox(height: 24),
                AllCategories(tags: _tags),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.onProfileTap,
  });

  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.11),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
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
                          Colors.black.withValues(alpha: 0.35),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    left: 14,
                    child: GestureDetector(
                      onTap: onProfileTap,
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.face_5_rounded,
                          color: AppColors.cinnamon,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 22,
                    bottom: 24,
                    child: Text(
                      '\u00dcCRETS\u0130Z MASALLAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'BreadMateTR',
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        height: 0.95,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PremiumAdSlider extends StatelessWidget {
  const PremiumAdSlider({
    super.key,
    required this.controller,
    required this.slides,
    required this.activeIndex,
    required this.onPageChanged,
    required this.onTap,
  });

  final PageController controller;
  final List<AdSlide> slides;
  final int activeIndex;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: Stack(
        children: [
          PageView.builder(
            controller: controller,
            onPageChanged: onPageChanged,
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return PremiumBanner(slide: slide, onTap: onTap);
            },
          ),
          Positioned(
            left: 22,
            bottom: 13,
            child: Row(
              children: [
                for (var i = 0; i < slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: activeIndex == i ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: activeIndex == i
                          ? AppColors.cinnamon
                          : AppColors.cinnamon.withValues(alpha: 0.24),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key, required this.slide, required this.onTap});

  final AdSlide slide;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD7E6), Color(0xFFFFE9C4)],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned(
                  left: 18,
                  top: 22,
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        slide.title,
                        style: const TextStyle(
                          color: AppColors.cinnamon,
                          fontFamily: 'BreadMateTR',
                          fontSize: 28,
                          height: 0.95,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        slide.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.lavender,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  top: 0,
                  width: 150,
                  child: Image.asset(slide.imagePath, fit: BoxFit.cover),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.cinnamon,
              textStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class HorizontalStoryList extends StatelessWidget {
  const HorizontalStoryList({super.key, required this.items});

  final List<StoryTile> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 98,
            child: SmallStoryCard(
              title: item.title,
              imagePath: item.imagePath,
              onTap: () => context.push(AppRoutes.story(item.id)),
            ),
          );
        },
      ),
    );
  }
}

class SmallStoryCard extends StatelessWidget {
  const SmallStoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(imagePath, fit: BoxFit.cover),
                Positioned(
                  top: 7,
                  left: 7,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDDF4F3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.cinnamon,
                      size: 14,
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
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

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({
    super.key,
    required this.title,
    required this.categoryId,
    required this.backgroundImage,
    required this.accentColor,
    required this.stories,
  });

  final String title;
  final String categoryId;
  final String backgroundImage;
  final Color accentColor;
  final List<StoryTile> stories;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(AppRoutes.category(categoryId)),
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1.8,
                  child: Image.asset(backgroundImage, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'BreadMateTR',
                  fontSize: 30,
                  height: 0.95,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 0.78,
                        child: SmallStoryCard(
                          title: stories[i].title,
                          imagePath: stories[i].imagePath,
                          onTap: () =>
                              context.push(AppRoutes.story(stories[i].id)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key, required this.items});

  final List<CategoryTile> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 11),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 98,
            child: SmallStoryCard(
              title: item.title,
              imagePath: item.imagePath,
              onTap: () => context.push(AppRoutes.category(item.id)),
            ),
          );
        },
      ),
    );
  }
}

class AllCategories extends StatelessWidget {
  const AllCategories({super.key, required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          const Text(
            'T\u00dcM KATEGOR\u0130LER',
            style: TextStyle(
              color: AppColors.cinnamon,
              fontFamily: 'BreadMateTR',
              fontSize: 30,
              height: 0.95,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final tag in tags)
                ActionChip(
                  onPressed: () =>
                      context.push(AppRoutes.category(tag.toLowerCase())),
                  label: Text(tag),
                  backgroundColor: const Color(0xFFF4EEE7),
                  side: BorderSide.none,
                  labelStyle: const TextStyle(
                    color: AppColors.lavender,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdSlide {
  const AdSlide({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  final String title;
  final String subtitle;
  final String imagePath;
}

class StoryTile {
  const StoryTile(this.id, this.title, this.imagePath);

  final String id;
  final String title;
  final String imagePath;
}

class CategoryTile {
  const CategoryTile(this.id, this.title, this.imagePath);

  final String id;
  final String title;
  final String imagePath;
}
