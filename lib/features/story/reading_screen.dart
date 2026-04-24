import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';
import '../../core/stories/story_catalog.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_back_button.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key, required this.storyId});

  final String storyId;

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late int _page;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    state.startReadingStory(widget.storyId);
    _page = state.readingPageFor(widget.storyId);
  }

  @override
  Widget build(BuildContext context) {
    final story = storyCatalogEntryFor(widget.storyId);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: AppBackButtonAppBarLeading.leadingWidth,
        leading: AppBackButtonAppBarLeading(
          onTap: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Okuma'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              story.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.cinnamon,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Sayfa $_page / ${story.totalPages}',
              style: const TextStyle(color: AppColors.lavender),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    'Bir varm\u0131\u015f bir yokmu\u015f... Bu sayfada masal metni yer alacak. Devam et sistemi AppState i\u00e7inde tutuluyor.',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: null,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final nextPage = (_page % story.totalPages) + 1;
                setState(() => _page = nextPage);
                context.read<AppState>().updateReadingProgress(
                  widget.storyId,
                  nextPage,
                );
              },
              child: const Text('Sonraki Sayfa'),
            ),
          ],
        ),
      ),
    );
  }
}
