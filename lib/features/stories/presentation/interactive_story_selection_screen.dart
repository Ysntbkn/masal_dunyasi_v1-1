import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';

class InteractiveStorySelectionScreen extends StatefulWidget {
  const InteractiveStorySelectionScreen({super.key});

  @override
  State<InteractiveStorySelectionScreen> createState() =>
      _InteractiveStorySelectionScreenState();
}

class _InteractiveStorySelectionScreenState
    extends State<InteractiveStorySelectionScreen> {
  static const _pageColor = Color(0xFF2F255E);
  static const _headerAssetPath = 'asset/İnteraktif Başlık.png';

  static const _stories = [
    _InteractiveStoryChoice(
      id: 'royal-day',
      title: 'KRALİYET GÜNÜ',
      subtitle:
          'Mia\'nin tören günü için kayıp taç parçalarını bul ve tacı tamamla.',
      imagePath: 'asset/interactive/kayip_tac/bolum_1.png',
      isNew: true,
    ),
    _InteractiveStoryChoice(
      id: 'princess-rescue',
      title: 'PRENSESİ KURTAR',
      subtitle:
          'Kötü kıskanç cadı prensesi zindana hapsetti, sana ihtiyacı var!',
      imagePath: 'asset/home page/hayvanlar alemi.jpg',
      isNew: true,
    ),
    _InteractiveStoryChoice(
      id: 'moon-forest',
      title: 'AY ORMANI YOLCULUĞU',
      subtitle:
          'Parlayan izleri takip et, gece dostlarını bul ve yolu tamamla.',
      imagePath:
          'asset/sleep page/freepik__a-magical-fairytale-night-scene-a-little-dreamer-s__95193.png',
      isNew: false,
    ),
    _InteractiveStoryChoice(
      id: 'little-dragon',
      title: 'MİNİK EJDERHA',
      subtitle: 'Cesur ejderhaya yardım et, saklı eşyaları topla ve uçuşa geç.',
      imagePath: 'asset/books/freepik_cute-little-bear-standing_2791150604.png',
      isNew: false,
    ),
  ];

  bool _soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _pageColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _pageColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                  child: Row(
                    children: [
                      _TopIconButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      _TopIconButton(
                        icon: _soundEnabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        onTap: _toggleSound,
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                  child: _HeaderShowcase(headerAssetPath: _headerAssetPath),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F3F4),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < _stories.length;
                          index++
                        ) ...[
                          _InteractiveSelectionCard(
                            story: _stories[index],
                            onTap: () => context.push(
                              AppRoutes.interactiveStory(_stories[index].id),
                            ),
                          ),
                          if (index != _stories.length - 1)
                            const SizedBox(height: 14),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSound() {
    setState(() => _soundEnabled = !_soundEnabled);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_soundEnabled ? 'Ses açıldı' : 'Ses kapatıldı'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF6B329F),
        ),
      );
  }
}

class _HeaderShowcase extends StatelessWidget {
  const _HeaderShowcase({required this.headerAssetPath});

  final String headerAssetPath;

  static const _stars = [
    _StarDot(left: 60, top: 34, size: 10),
    _StarDot(left: 138, top: 0, size: 8),
    _StarDot(right: 112, top: 16, size: 8),
    _StarDot(left: 24, top: 96, size: 12),
    _StarDot(right: 92, top: 88, size: 10),
    _StarDot(left: 126, top: 168, size: 8),
    _StarDot(right: 48, top: 146, size: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 208,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final star in _stars) star,
          Image.asset(headerAssetPath, width: 196, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class _StarDot extends StatelessWidget {
  const _StarDot({
    this.left,
    this.right,
    required this.top,
    required this.size,
  });

  final double? left;
  final double? right;
  final double top;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      child: Icon(
        Icons.star_rounded,
        size: size,
        color: const Color(0xFFFFD46F),
      ),
    );
  }
}

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8C43C8), Color(0xFF5F2C92)],
        ),
        border: Border.all(color: const Color(0xFFE2A33D), width: 2.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(icon, color: const Color(0xFFFFD36B), size: 32),
          ),
        ),
      ),
    );
  }
}

class _InteractiveSelectionCard extends StatelessWidget {
  const _InteractiveSelectionCard({required this.story, required this.onTap});

  final _InteractiveStoryChoice story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFF2D7B4), Color(0xFFF7E9D1), Color(0xFFEFD8B4)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 330;
                    final imageWidth = compact ? 108.0 : 132.0;
                    final imageHeight = compact ? 118.0 : 132.0;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: SizedBox(
                            width: imageWidth,
                            height: imageHeight,
                            child: Image.asset(
                              story.imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: imageHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  story.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: const Color(0xFF7A29B8),
                                    fontFamily: 'BreadMateTR',
                                    fontSize: compact ? 18 : 22,
                                    height: 0.98,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  story.subtitle,
                                  maxLines: compact ? 3 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF554841),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.2,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: _StartButton(onTap: onTap),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              if (story.isNew)
                Positioned(
                  left: 6,
                  top: 6,
                  child: Transform.rotate(
                    angle: -12 * math.pi / 180,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF28D8),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'YENİ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8B3CD4), Color(0xFF65279B)],
            ),
            border: Border.all(color: const Color(0xFFE0B24F), width: 2),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: 18,
                color: Color(0xFFFFE07D),
              ),
              SizedBox(width: 4),
              Text(
                'BAŞLA',
                style: TextStyle(
                  color: Color(0xFFFFE07D),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InteractiveStoryChoice {
  const _InteractiveStoryChoice({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isNew,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isNew;
}
