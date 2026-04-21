import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';

class AudioPlayerScreen extends StatelessWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ses Oynatıcı')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.peach,
                child: Icon(
                  Icons.graphic_eq_rounded,
                  color: AppColors.cinnamon,
                  size: 52,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                state.activeAudioTitle ?? 'Henüz bir ses seçilmedi',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.cinnamon, fontSize: 32),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: state.hasActiveAudio ? state.stopAudio : null,
                icon: const Icon(Icons.stop_rounded),
                label: const Text('Durdur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
