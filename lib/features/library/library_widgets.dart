import 'package:flutter/material.dart';

import '../../core/state/app_state.dart';

class LibraryStoryCard extends StatelessWidget {
  const LibraryStoryCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onPlay,
  });

  final StoryLibraryItem item;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final progressText = '%${(item.progress * 100).round()} Tamamlandi';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item.imagePath,
                  width: 68,
                  height: 88,
                  fit: BoxFit.cover,
                  cacheWidth: 180,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        if (item.isCompleted) ...[
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
                    const SizedBox(height: 16),
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
                              widthFactor: item.progress,
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
              const SizedBox(width: 12),
              Material(
                color: const Color(0xFFDADADA),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onPlay,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 54,
                    height: 54,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFFB3521D),
                      size: 30,
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

class LibraryEmptyCard extends StatelessWidget {
  const LibraryEmptyCard({
    super.key,
    required this.message,
    this.textColor = const Color(0xFF6D6255),
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFF0E2D3),
  });

  final String message;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
