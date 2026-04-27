import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_state.dart';
import '../../../core/stories/story_catalog.dart';
import 'story_screen_shared.dart';

class StoryAudioPlayerScreen extends StatefulWidget {
  const StoryAudioPlayerScreen({super.key, this.storyId});

  final String? storyId;

  @override
  State<StoryAudioPlayerScreen> createState() => _StoryAudioPlayerScreenState();
}

class _StoryAudioPlayerScreenState extends State<StoryAudioPlayerScreen> {
  static const _totalDuration = Duration(minutes: 2);
  static const _sleepFallbackCoverPath =
      'asset/sleep page/sleep_card_bear_thumb.jpg';

  AppState? _appState;
  Timer? _timer;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState ??= context.read<AppState>();
    _appState!.setExpandedAudioPlayerVisible(true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _appState?.setExpandedAudioPlayerVisible(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final activeType = appState.activeAudioType ?? AudioSourceType.story;
    final resolvedStoryId = widget.storyId ?? appState.activeAudioStoryId;
    final story = resolvedStoryId == null
        ? null
        : storyCatalogEntryFor(resolvedStoryId);
    final rawTitle =
        appState.activeAudioTitle ?? story?.title ?? 'Ses Oynatici';
    final title = activeType == AudioSourceType.story
        ? rawTitle.toUpperCase()
        : rawTitle;
    final subtitle = activeType == AudioSourceType.sleep
        ? 'Uyku sesi'
        : 'Masal sesi';
    final coverPath =
        appState.activeAudioArtworkPath ??
        (story != null
            ? resolveStoryCoverPath(story)
            : _sleepFallbackCoverPath);
    final progress =
        _position.inMilliseconds /
        _totalDuration.inMilliseconds.clamp(1, 9999999);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF3E6),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _appState?.setExpandedAudioPlayerVisible(false);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFFF3E6),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StoryBackIconButton(
                      onTap: () {
                        _appState?.setExpandedAudioPlayerVisible(false);
                        Navigator.of(context).maybePop();
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 360,
                                maxHeight: 360,
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(34),
                                  child: Image.asset(
                                    coverPath,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: const Color(0xFFF0E0D2),
                                            ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          subtitle.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF9B897B),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: storyTitleStyle(fontSize: 29),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _PlayerCircleButton(
                              icon: Icons.replay_10_rounded,
                              size: 58,
                              onTap: _jumpBackward,
                            ),
                            const SizedBox(width: 18),
                            _PlayerCircleButton(
                              icon: _isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 84,
                              onTap: _togglePlayback,
                            ),
                            const SizedBox(width: 18),
                            _PlayerCircleButton(
                              icon: Icons.forward_10_rounded,
                              size: 58,
                              onTap: _jumpForward,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 6,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                            activeTrackColor: const Color(0xFFFF7A45),
                            inactiveTrackColor: const Color(0xFFE4DED8),
                            thumbColor: const Color(0xFFFF7A45),
                            overlayColor: const Color(0x22FF7A45),
                          ),
                          child: Slider(
                            value: progress.clamp(0, 1).toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _position = Duration(
                                  milliseconds:
                                      (_totalDuration.inMilliseconds * value)
                                          .round(),
                                );
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              Text(
                                _formatDuration(_position),
                                style: const TextStyle(
                                  color: Color(0xFF7F746C),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatDuration(_totalDuration),
                                style: const TextStyle(
                                  color: Color(0xFF7F746C),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  void _togglePlayback() {
    setState(() => _isPlaying = !_isPlaying);
    _timer?.cancel();
    if (!_isPlaying) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final next = _position + const Duration(seconds: 1);
        if (next >= _totalDuration) {
          _position = _totalDuration;
          _isPlaying = false;
          _timer?.cancel();
        } else {
          _position = next;
        }
      });
    });
  }

  void _jumpBackward() {
    setState(() {
      _position = _position - const Duration(seconds: 10);
      if (_position.isNegative) _position = Duration.zero;
    });
  }

  void _jumpForward() {
    setState(() {
      final next = _position + const Duration(seconds: 10);
      _position = next > _totalDuration ? _totalDuration : next;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PlayerCircleButton extends StatelessWidget {
  const _PlayerCircleButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  final IconData icon;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE9E4DE),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: const Color(0xFFB55222), size: size * 0.42),
        ),
      ),
    );
  }
}
