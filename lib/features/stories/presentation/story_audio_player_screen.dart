import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Timer? _timer;
  Duration _position = Duration.zero;
  bool _isPlaying = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = storyCatalogEntryFor(widget.storyId ?? 'minik-ayicik');
    final coverPath = resolveStoryCoverPath(story);
    final progress =
        _position.inMilliseconds / _totalDuration.inMilliseconds.clamp(1, 9999999);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF3E6),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E6),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(coverPath, fit: BoxFit.cover),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.22),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipPath(
                            clipper: const StoryWaveClipper(
                              waveHeight: 50,
                              curveDepth: 30,
                            ),
                            child: Container(
                              height: 110,
                              color: const Color(0xFFFFF3E6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -20),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                      child: Column(
                        children: [
                          Text(
                            storyDisplayTitle(story),
                            textAlign: TextAlign.center,
                            style: storyTitleStyle(fontSize: 29),
                          ),
                          const SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _PlayerCircleButton(
                                icon: Icons.skip_previous_rounded,
                                size: 58,
                                onTap: _jumpBackward,
                              ),
                              const SizedBox(width: 18),
                              _PlayerCircleButton(
                                icon: _isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 76,
                                onTap: _togglePlayback,
                              ),
                              const SizedBox(width: 18),
                              _PlayerCircleButton(
                                icon: Icons.skip_next_rounded,
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
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: StoryBackIconButton(
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            ),
          ],
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
