import 'package:flutter/material.dart';

import '../../../core/stories/story_catalog.dart';

const _fallbackCoverAssetPath =
    'asset/books/freepik_cute-little-bear-standing_2791150604.png';

String resolveStoryCoverPath(StoryCatalogEntry story) {
  final path = story.imagePath.trim();
  return path.isEmpty ? _fallbackCoverAssetPath : path;
}

String storyDisplayTitle(StoryCatalogEntry story) {
  final title = story.title.trim();
  return title.isEmpty ? 'MİNİK AYICIK' : title.toUpperCase();
}

TextStyle storyTitleStyle({
  double fontSize = 30,
  Color color = const Color(0xFFA9471F),
}) {
  return TextStyle(
    fontFamily: 'BreadMateTR',
    color: color,
    fontSize: fontSize,
    height: 0.96,
    letterSpacing: 0.4,
  );
}

class StoryOverlayIconButton extends StatelessWidget {
  const StoryOverlayIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFFB55222),
    this.iconColor = Colors.white,
    this.size = 44,
    this.borderRadius = 11,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}

class StoryBackIconButton extends StatelessWidget {
  const StoryBackIconButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF7E3CD).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFD39A68).withValues(alpha: 0.85),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: StoryOverlayIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        iconColor: const Color(0xFF8F4A22),
        size: 46,
        borderRadius: 15,
      ),
    );
  }
}

class StoryHeroImage extends StatelessWidget {
  const StoryHeroImage({
    super.key,
    required this.imagePath,
    required this.height,
    this.bottomRadius = 26,
  });

  final String imagePath;
  final double height;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
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
                    Colors.black.withValues(alpha: 0.22),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.10),
                  ],
                  stops: const [0, 0.38, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoryWaveClipper extends CustomClipper<Path> {
  const StoryWaveClipper({
    this.waveHeight = 38,
    this.curveDepth = 24,
  });

  final double waveHeight;
  final double curveDepth;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - waveHeight)
      ..quadraticBezierTo(
        size.width * 0.16,
        size.height - waveHeight - curveDepth,
        size.width * 0.34,
        size.height - waveHeight + 4,
      )
      ..quadraticBezierTo(
        size.width * 0.52,
        size.height - waveHeight + curveDepth,
        size.width * 0.72,
        size.height - waveHeight + 2,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height - waveHeight - curveDepth,
        size.width,
        size.height - waveHeight + 6,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant StoryWaveClipper oldClipper) {
    return oldClipper.waveHeight != waveHeight ||
        oldClipper.curveDepth != curveDepth;
  }
}

class StoryPrimaryButton extends StatelessWidget {
  const StoryPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Ink(
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
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
