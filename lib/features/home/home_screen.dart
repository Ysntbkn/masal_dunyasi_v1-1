import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    AdSlide(imagePath: 'asset/home page/premium.png'),
    AdSlide(imagePath: 'asset/home page/no ads.png'),
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
    final bottomSafeGap = MediaQuery.paddingOf(context).bottom + 124;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFEDF8FD),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF8FD),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: HomeHero(
                imagePath: _coverImage,
                onTap: () => context.push(AppRoutes.story('ucretsiz-masallar')),
                onProfileTap: () => context.push(AppRoutes.profile),
                onSearchTap: () => context.push(AppRoutes.search),
              ),
            ),
            if (!isPremium)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: PremiumAdSlider(
                    controller: _adController,
                    slides: _adSlides,
                    activeIndex: _adIndex,
                    onPageChanged: (index) => setState(() => _adIndex = index),
                    onTap: () => context.push(AppRoutes.premium),
                  ),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18, isPremium ? 28 : 18, 18, 0),
              sliver: SliverList.list(
                children: [
                  SectionHeader(title: 'Yeteneklerini Ke\u015ffet'),
                  const SizedBox(height: 10),
                  HorizontalStoryList(items: _skills),
                  const SizedBox(height: 22),
                  CategoryBlock(
                    title: 'MACERAYA \u00c7IKALIM',
                    subtitle:
                        'Sevimli Ay\u0131c\u0131k Popi ile D\u00fcnya Turuna \u00c7\u0131k',
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
                    subtitle:
                        'Dostumuz Hayvanlar\u0131n Maceras\u0131na Kat\u0131l',
                    categoryId: 'hayvanlar',
                    backgroundImage: 'asset/home page/hayvanlar alemi.jpg',
                    accentColor: const Color(0xFF4A935B),
                    stories: _skills,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: AllCategories(
                tags: _tags,
                bottomPadding: bottomSafeGap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHero extends StatelessWidget {
  const HomeHero({
    super.key,
    required this.imagePath,
    required this.onTap,
    required this.onProfileTap,
    required this.onSearchTap,
  });

  final String imagePath;
  final VoidCallback onTap;
  final VoidCallback onProfileTap;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final heroHeight = (screenHeight * 0.62).clamp(500.0, 585.0);
    final topPadding = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: heroHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.04, 0.48),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: topPadding + 44,
                  left: 32,
                  right: 32,
                  height: 56,
                  child: _HeroSearchBar(
                    onProfileTap: onProfileTap,
                    onSearchTap: onSearchTap,
                  ),
                ),
                Positioned(
                  left: 32,
                  right: 32,
                  bottom: 66,
                  child: _HeroTitlePill(onTap: onTap),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 34,
                  child: _HeroIndicators(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSearchBar extends StatelessWidget {
  const _HeroSearchBar({required this.onProfileTap, required this.onSearchTap});

  final VoidCallback onProfileTap;
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    final avatar = _HomeAvatarStyle.fromId(context.watch<AppState>().avatar);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            color: const Color(0xFFDDE7CB).withValues(alpha: 0.54),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: avatar.backgroundColor,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.74),
                      width: 2,
                    ),
                  ),
                  child: Icon(avatar.icon, color: Colors.white, size: 30),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSearchTap,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.45),
                  ),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 32,
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

class _HomeAvatarStyle {
  const _HomeAvatarStyle({required this.backgroundColor, required this.icon});

  final Color backgroundColor;
  final IconData icon;

  static _HomeAvatarStyle fromId(String avatarId) {
    return switch (avatarId) {
      'prenses' => const _HomeAvatarStyle(
        backgroundColor: Color(0xFFF4B46F),
        icon: Icons.face_4_rounded,
      ),
      'kirmizi-baslik' => const _HomeAvatarStyle(
        backgroundColor: Color(0xFF9ED6C0),
        icon: Icons.face_3_rounded,
      ),
      'buyucu' => const _HomeAvatarStyle(
        backgroundColor: Color(0xFF7B789E),
        icon: Icons.face_6_rounded,
      ),
      'gezgin' => const _HomeAvatarStyle(
        backgroundColor: Color(0xFFF0C07A),
        icon: Icons.face_2_rounded,
      ),
      'dedektif' => const _HomeAvatarStyle(
        backgroundColor: Color(0xFFB6D79F),
        icon: Icons.face_rounded,
      ),
      'denizci' => const _HomeAvatarStyle(
        backgroundColor: Color(0xFF86CFC7),
        icon: Icons.face_retouching_natural,
      ),
      _ => const _HomeAvatarStyle(
        backgroundColor: Color(0xFFF4B46F),
        icon: Icons.face_4_rounded,
      ),
    };
  }
}

class _HeroTitlePill extends StatelessWidget {
  const _HeroTitlePill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFA97945).withValues(alpha: 0.34),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '\u00dcCRETS\u0130Z MASALLAR',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'BreadMateTR',
                  fontSize: 35,
                  fontWeight: FontWeight.w400,
                  height: 0.92,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroIndicators extends StatelessWidget {
  const _HeroIndicators();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _IndicatorBar(color: Colors.white, width: 38),
        SizedBox(width: 10),
        _IndicatorBar(color: Color(0xBFE8EFE8), width: 54),
        SizedBox(width: 10),
        _IndicatorBar(color: Color(0xBFE8EFE8), width: 54),
        SizedBox(width: 10),
        _IndicatorBar(color: Color(0xBFE8EFE8), width: 54),
      ],
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

  static const _adAspectRatio = 1029 / 757;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final adHeight = constraints.maxWidth / _adAspectRatio;

        return SizedBox(
          height: adHeight + 28,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: adHeight,
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: onPageChanged,
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return PremiumBanner(slide: slide, onTap: onTap);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < slides.length; i++) ...[
                      if (i > 0) const SizedBox(width: 7),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: activeIndex == i ? 28 : 28,
                        height: 7,
                        decoration: BoxDecoration(
                          color: activeIndex == i
                              ? AppColors.cinnamon
                              : const Color(0xFFC6D1D2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PremiumBanner extends StatelessWidget {
  const PremiumBanner({super.key, required this.slide, required this.onTap});

  final AdSlide slide;
  final VoidCallback onTap;

  static const _adAspectRatio = 1029 / 757;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: AspectRatio(
          aspectRatio: _adAspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Image.asset(
              slide.imagePath,
              fit: BoxFit.fill,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _IndicatorBar extends StatelessWidget {
  const _IndicatorBar({required this.color, required this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
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
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
        ),
        if (actionLabel != null)
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFD47C),
              foregroundColor: AppColors.cinnamon,
              minimumSize: const Size(130, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(actionLabel!),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
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
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 122,
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
    final locked = !context.watch<AppState>().isPremium;

    return Semantics(
      label: title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(imagePath, fit: BoxFit.cover),
                  if (locked)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 29,
                        height: 29,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD87C),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.black,
                          size: 18,
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

class CategoryBlock extends StatelessWidget {
  const CategoryBlock({
    super.key,
    required this.title,
    this.subtitle,
    required this.categoryId,
    required this.backgroundImage,
    required this.accentColor,
    required this.stories,
  });

  final String title;
  final String? subtitle;
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Ink(
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 1.36,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(backgroundImage, fit: BoxFit.cover),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              accentColor.withValues(alpha: 0.04),
                              accentColor.withValues(alpha: 0.28),
                              accentColor.withValues(alpha: 0.72),
                              accentColor,
                            ],
                            stops: const [0.36, 0.55, 0.68, 0.82, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 22,
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                title,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'BreadMateTR',
                                  fontSize: 37,
                                  height: 0.94,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 18, 12, 22),
                  child: _CategoryStoryCarousel(stories: stories),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryStoryCarousel extends StatelessWidget {
  const _CategoryStoryCarousel({required this.stories});

  final List<StoryTile> stories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sideWidth = (constraints.maxWidth * 0.29).clamp(86.0, 118.0);
        final centerWidth = (constraints.maxWidth * 0.38).clamp(116.0, 152.0);
        final sideHeight = sideWidth / 0.78;
        final centerHeight = centerWidth / 0.78;

        return SizedBox(
          height: centerHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                left: 0,
                bottom: 22,
                width: sideWidth,
                height: sideHeight,
                child: SmallStoryCard(
                  title: stories[0].title,
                  imagePath: stories[0].imagePath,
                  onTap: () => context.push(AppRoutes.story(stories[0].id)),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 22,
                width: sideWidth,
                height: sideHeight,
                child: SmallStoryCard(
                  title: stories[2].title,
                  imagePath: stories[2].imagePath,
                  onTap: () => context.push(AppRoutes.story(stories[2].id)),
                ),
              ),
              SizedBox(
                width: centerWidth,
                height: centerHeight,
                child: SmallStoryCard(
                  title: stories[1].title,
                  imagePath: stories[1].imagePath,
                  onTap: () => context.push(AppRoutes.story(stories[1].id)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key, required this.items});

  final List<CategoryTile> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 122,
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
  const AllCategories({
    super.key,
    required this.tags,
    this.bottomPadding = 38,
  });

  final List<String> tags;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, 32, 22, bottomPadding),
      color: const Color(0xFFF1ECE6),
      child: Column(
        children: [
          const Text(
            'T\u00dcM KATEGOR\u0130LER',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.cinnamon,
              fontFamily: 'BreadMateTR',
              fontSize: 43,
              height: 0.96,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 26),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 14,
            children: [
              for (final tag in tags)
                ActionChip(
                  onPressed: () =>
                      context.push(AppRoutes.category(tag.toLowerCase())),
                  label: SizedBox(
                    width: 92,
                    child: Text(
                      tag,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  labelPadding: const EdgeInsets.symmetric(vertical: 7),
                  labelStyle: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
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
  const AdSlide({required this.imagePath});

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
