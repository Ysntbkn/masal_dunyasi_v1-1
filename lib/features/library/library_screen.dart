import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/app_back_button.dart';
import 'library_widgets.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _backgroundImage =
      'asset/profil page/profile_background_optimized.jpg';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final continueItems = state.activeReadingStories;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFB05522),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFB05522),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _LibraryHero(
                imagePath: LibraryScreen._backgroundImage,
                onBack: () => context.go(AppRoutes.home),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _LibraryShortcutButton(
                        label: 'Okuduklarım',
                        onTap: () =>
                            context.push(AppRoutes.libraryCollection(false)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LibraryShortcutButton(
                        label: 'Favorilerim',
                        onTap: () =>
                            context.push(AppRoutes.libraryCollection(true)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 120),
              sliver: SliverList.list(
                children: [
                  const _LibrarySectionTitle(title: 'Okumaya Devam Et'),
                  const SizedBox(height: 18),
                  if (!state.isLibraryReady)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  else if (continueItems.isEmpty)
                    const LibraryEmptyCard(
                      message: 'Şu anda okuduğun masal yok.',
                      textColor: Colors.white,
                      backgroundColor: Color(0x2EFFFFFF),
                      borderColor: Color(0x2EFFFFFF),
                    )
                  else
                    for (final item in continueItems) ...[
                      LibraryStoryCard(
                        item: item,
                        onTap: () =>
                            context.push(AppRoutes.readStory(item.storyId)),
                        onPlay: () =>
                            context.push(AppRoutes.readStory(item.storyId)),
                      ),
                      const SizedBox(height: 16),
                    ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryHero extends StatelessWidget {
  const _LibraryHero({required this.imagePath, required this.onBack});

  final String imagePath;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 332,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.18),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  const Color(0xFF7D3A1B).withValues(alpha: 0.18),
                  const Color(0xFFB05522).withValues(alpha: 0.76),
                  const Color(0xFFB05522),
                ],
                stops: const [0, 0.48, 0.74, 1],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
              child: Column(
                children: [
                  AppHeaderBar(onBack: onBack, horizontalPadding: 0),
                  const Spacer(),
                  const Text(
                    'KUTUPHANE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'BreadMateTR',
                      fontSize: 54,
                      fontWeight: FontWeight.w400,
                      height: 0.92,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryShortcutButton extends StatelessWidget {
  const _LibraryShortcutButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFE09A),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LibrarySectionTitle extends StatelessWidget {
  const _LibrarySectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }
}
