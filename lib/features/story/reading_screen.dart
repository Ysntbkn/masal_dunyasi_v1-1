import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key, required this.storyId});

  final String storyId;

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Okuma')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sayfa $_page / 5',
              style: const TextStyle(color: AppColors.lavender),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Text(
                    'Bir varmış bir yokmuş... Bu sayfada masal metni yer alacak. Devam et sistemi AppState içinde tutuluyor.',
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
                setState(() => _page = (_page % 5) + 1);
                context.read<AppState>().updateReadingProgress(
                  widget.storyId,
                  _page,
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
