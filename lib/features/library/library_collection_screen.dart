import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/app_back_button.dart';
import 'library_widgets.dart';

enum LibraryCollectionKind { completed, favorites }

class LibraryCollectionScreen extends StatelessWidget {
  const LibraryCollectionScreen({super.key, required this.kind});

  final LibraryCollectionKind kind;

  bool get _isFavorites => kind == LibraryCollectionKind.favorites;

  String get _title => _isFavorites ? 'Favorilerim' : 'Okuduklarım';

  String get _emptyMessage => _isFavorites
      ? 'Henüz favorilere eklediğin bir masal yok.'
      : 'Henüz okuduğun bir masal yok.';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = _isFavorites ? state.favoriteStories : state.completedStories;

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
              AppHeaderBar(
                onBack: () => context.pop(),
                horizontalPadding: 0,
                title: _title,
                titleStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 24),
              if (!state.isLibraryReady)
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFB2551F)),
                  ),
                )
              else if (items.isEmpty)
                LibraryEmptyCard(
                  message: _emptyMessage,
                  textColor: const Color(0xFF6D6255),
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFFF0E2D3),
                )
              else
                for (final item in items) ...[
                  LibraryStoryCard(
                    item: item,
                    onTap: () => context.push(AppRoutes.story(item.storyId)),
                    onPlay: () {
                      context.read<AppState>().startReadingStory(item.storyId);
                      context.push(AppRoutes.readStory(item.storyId));
                    },
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
