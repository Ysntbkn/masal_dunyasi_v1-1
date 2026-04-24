// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../features/auth/widgets/auth_onboarding_widgets.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_back_button.dart';

enum _TrialTab { stories, sounds }

class TrialScreen extends StatefulWidget {
  const TrialScreen({super.key, this.storyId});

  final String? storyId;

  @override
  State<TrialScreen> createState() => _TrialScreenState();
}

class _TrialScreenState extends State<TrialScreen> {
  static const Duration _previewDuration = Duration(seconds: 4);

  final AudioPlayer _player = AudioPlayer();
  Timer? _previewTimer;
  _TrialTab _selectedTab = _TrialTab.stories;
  String? _playingId;

  late final List<_PreviewItem> _storyPreviews = [
    _PreviewItem(
      id: 'isikli-kitap',
      title: 'I\u015f\u0131lt\u0131l\u0131 Kitap',
      imagePath: 'asset/login page/Arkaplan.jpeg',
      icon: Icons.auto_stories_rounded,
      toneFrequencies: const [523.25, 659.25, 783.99],
    ),
    _PreviewItem(
      id: 'ay-ormani',
      title: 'Ay Orman\u0131',
      imagePath: 'asset/avatar page/avatar_optimized.jpeg',
      icon: Icons.forest_rounded,
      toneFrequencies: const [493.88, 587.33, 739.99],
    ),
    _PreviewItem(
      id: 'minik-ejderha',
      title: 'Minik Ejderha',
      imagePath: 'asset/login page/Arkaplan.jpeg',
      icon: Icons.local_fire_department_rounded,
      toneFrequencies: const [392.00, 523.25, 659.25],
    ),
    _PreviewItem(
      id: 'bulut-sarayi',
      title: 'Bulut Saray\u0131',
      imagePath: 'asset/avatar page/avatar_optimized.jpeg',
      icon: Icons.cloud_rounded,
      toneFrequencies: const [440.00, 554.37, 659.25],
    ),
  ];

  late final List<_PreviewItem> _soundPreviews = [
    _PreviewItem(
      id: 'uyku-ninnisi',
      title: 'Uyku Ninnisi',
      imagePath: 'asset/avatar page/avatar_optimized.jpeg',
      icon: Icons.nightlight_round,
      toneFrequencies: const [261.63, 329.63, 392.00],
    ),
    _PreviewItem(
      id: 'yagmur',
      title: 'Yumu\u015fak Ya\u011fmur',
      imagePath: 'asset/login page/Arkaplan.jpeg',
      icon: Icons.water_drop_rounded,
      toneFrequencies: const [220.00, 277.18, 329.63],
    ),
    _PreviewItem(
      id: 'yildizlar',
      title: 'Y\u0131ld\u0131z Sesi',
      imagePath: 'asset/avatar page/avatar_optimized.jpeg',
      icon: Icons.star_rounded,
      toneFrequencies: const [246.94, 311.13, 369.99],
    ),
    _PreviewItem(
      id: 'ruya',
      title: 'R\u00fcya Melodisi',
      imagePath: 'asset/login page/Arkaplan.jpeg',
      icon: Icons.bedtime_rounded,
      toneFrequencies: const [293.66, 349.23, 440.00],
    ),
  ];

  List<_PreviewItem> get _items =>
      _selectedTab == _TrialTab.stories ? _storyPreviews : _soundPreviews;

  @override
  void dispose() {
    _previewTimer?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playPreview(_PreviewItem item) async {
    _previewTimer?.cancel();
    await _player.stop();

    if (!mounted) return;
    setState(() => _playingId = item.id);

    final bytes = _PreviewToneFactory.createWav(
      item.toneFrequencies,
      duration: const Duration(seconds: 5),
    );

    try {
      await _player.setAudioSource(_MemoryAudioSource(bytes));
      await _player.play();
      _previewTimer = Timer(_previewDuration, _stopPreview);
    } catch (_) {
      if (!mounted) return;
      setState(() => _playingId = null);
    }
  }

  Future<void> _stopPreview() async {
    _previewTimer?.cancel();
    _previewTimer = null;
    await _player.stop();
    if (!mounted) return;
    setState(() => _playingId = null);
  }

  Future<void> _selectTab(_TrialTab tab) async {
    if (_selectedTab == tab) return;
    await _stopPreview();
    if (!mounted) return;
    setState(() => _selectedTab = tab);
  }

  Future<void> _continueToHome() async {
    await _stopPreview();
    if (!mounted) return;
    context.read<AppState>().completeOnboarding();
    context.go(AppRoutes.home);
  }

  void _goBack() {
    if (widget.storyId != null && context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.avatar);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 700;
    final horizontalPadding = AuthOnboardingMetrics.horizontalPaddingFor(
      size.width,
    );
    final contentWidth = size.width - (horizontalPadding * 2);
    final titleGap = compact ? 27.0 : 35.0;
    final gridGap = compact ? 24.0 : 31.0;
    final buttonGap = compact ? 20.0 : 26.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.cream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              compact ? 14 : 20,
              horizontalPadding,
              18,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gridHeight =
                    constraints.maxHeight -
                    _TrialHeader.height -
                    titleGap -
                    _TrialToggle.height -
                    gridGap -
                    buttonGap -
                    AuthOnboardingMetrics.continueButtonHeight(false);

                return Column(
                  children: [
                    _TrialHeader(onBack: _goBack),
                    SizedBox(height: titleGap),
                    _TrialToggle(
                      selectedTab: _selectedTab,
                      onChanged: _selectTab,
                    ),
                    SizedBox(height: gridGap),
                    _PreviewGrid(
                      width: contentWidth,
                      height: math.max(0, gridHeight - 2),
                      items: _items,
                      playingId: _playingId,
                      onTap: _playPreview,
                    ),
                    SizedBox(height: buttonGap + 2),
                    AuthContinueButton(
                      label: 'Devam Et',
                      onPressed: _continueToHome,
                      compact: false,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TrialHeader extends StatelessWidget {
  const _TrialHeader({required this.onBack});

  static const double height = 48;

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppHeaderBar(
      onBack: onBack,
      horizontalPadding: 0,
      title: 'ÖNCE DENE',
      titleStyle: const TextStyle(
        color: AppColors.cinnamon,
        fontFamily: 'BreadMateTR',
        fontSize: 46,
        fontWeight: FontWeight.w400,
        height: 0.92,
        letterSpacing: 0,
      ),
    );
  }
}

class _TrialToggle extends StatelessWidget {
  const _TrialToggle({required this.selectedTab, required this.onChanged});

  static const double height = 48;

  final _TrialTab selectedTab;
  final ValueChanged<_TrialTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEADAB3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _ToggleItem(
            label: 'Hikayeler',
            selected: selectedTab == _TrialTab.stories,
            onTap: () => onChanged(_TrialTab.stories),
          ),
          _ToggleItem(
            label: 'Sesler',
            selected: selectedTab == _TrialTab.sounds,
            onTap: () => onChanged(_TrialTab.sounds),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFD77D) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class _PreviewGrid extends StatelessWidget {
  const _PreviewGrid({
    required this.width,
    required this.height,
    required this.items,
    required this.playingId,
    required this.onTap,
  });

  final double width;
  final double height;
  final List<_PreviewItem> items;
  final String? playingId;
  final ValueChanged<_PreviewItem> onTap;

  @override
  Widget build(BuildContext context) {
    const spacing = 18.0;
    final cardWidth = (width - spacing) / 2;
    final cardHeight = math.max(1.0, (height - spacing) / 2);
    final aspectRatio = cardWidth / cardHeight;

    return SizedBox(
      height: height,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: aspectRatio,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _PreviewCard(
            item: item,
            playing: item.id == playingId,
            onTap: () => onTap(item),
          );
        },
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.item,
    required this.playing,
    required this.onTap,
  });

  final _PreviewItem item;
  final bool playing;
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: playing ? AppColors.cinnamon : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cinnamon.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.black.withValues(alpha: 0.16),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 31,
                    height: 31,
                    decoration: BoxDecoration(
                      color: playing
                          ? const Color(0xFFFFD77D)
                          : const Color(0xFFDDF4F3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: AppColors.cinnamon,
                      size: 23,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Icon(
                    item.icon,
                    color: Colors.white.withValues(alpha: 0.88),
                    size: 26,
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

class _PreviewItem {
  const _PreviewItem({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.icon,
    required this.toneFrequencies,
  });

  final String id;
  final String title;
  final String imagePath;
  final IconData icon;
  final List<double> toneFrequencies;
}

class _MemoryAudioSource extends StreamAudioSource {
  _MemoryAudioSource(this.bytes);

  final Uint8List bytes;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    final offset = start ?? 0;
    final responseEnd = end ?? bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: responseEnd - offset,
      offset: offset,
      stream: Stream.value(bytes.sublist(offset, responseEnd)),
      contentType: 'audio/wav',
    );
  }
}

abstract final class _PreviewToneFactory {
  static Uint8List createWav(
    List<double> frequencies, {
    required Duration duration,
  }) {
    const sampleRate = 22050;
    const channels = 1;
    const bitsPerSample = 16;
    final totalSamples = (sampleRate * duration.inMilliseconds / 1000).round();
    final dataLength = totalSamples * channels * (bitsPerSample ~/ 8);
    final bytes = Uint8List(44 + dataLength);
    final data = ByteData.view(bytes.buffer);

    _writeAscii(bytes, 0, 'RIFF');
    data.setUint32(4, 36 + dataLength, Endian.little);
    _writeAscii(bytes, 8, 'WAVE');
    _writeAscii(bytes, 12, 'fmt ');
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);
    data.setUint16(22, channels, Endian.little);
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(
      28,
      sampleRate * channels * bitsPerSample ~/ 8,
      Endian.little,
    );
    data.setUint16(32, channels * bitsPerSample ~/ 8, Endian.little);
    data.setUint16(34, bitsPerSample, Endian.little);
    _writeAscii(bytes, 36, 'data');
    data.setUint32(40, dataLength, Endian.little);

    for (var sample = 0; sample < totalSamples; sample++) {
      final seconds = sample / sampleRate;
      final envelope = _envelope(sample, totalSamples);
      final noteIndex = (seconds / 0.7).floor() % frequencies.length;
      final frequency = frequencies[noteIndex];
      final shimmerFrequency =
          frequencies[(noteIndex + 1) % frequencies.length];
      final wave =
          math.sin(2 * math.pi * frequency * seconds) * 0.72 +
          math.sin(2 * math.pi * shimmerFrequency * seconds) * 0.18;
      final value = (wave * envelope * 13000).round().clamp(-32768, 32767);
      data.setInt16(44 + sample * 2, value, Endian.little);
    }

    return bytes;
  }

  static double _envelope(int sample, int totalSamples) {
    final progress = sample / totalSamples;
    final attack = (progress / 0.08).clamp(0.0, 1.0);
    final release = ((1 - progress) / 0.16).clamp(0.0, 1.0);
    return math.min(attack, release);
  }

  static void _writeAscii(Uint8List bytes, int offset, String value) {
    for (var i = 0; i < value.length; i++) {
      bytes[offset + i] = value.codeUnitAt(i);
    }
  }
}
