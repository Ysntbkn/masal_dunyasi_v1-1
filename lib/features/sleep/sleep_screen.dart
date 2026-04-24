import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/widgets/app_back_button.dart';

enum _SleepTab { lullabies, sounds }

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  static const _backgroundImage =
      'asset/sleep page/sleep_background_optimized.jpg';
  static const _cardImage = 'asset/sleep page/sleep_card_bear_thumb.jpg';

  static const _lullabies = [
    _SleepTrack('Dandini Dandini\nDastana', '1 dk'),
    _SleepTrack('Dandini Dandini\nDastana', '1 dk'),
    _SleepTrack('Dandini Dandini\nDastana', '1 dk'),
    _SleepTrack('Dandini Dandini\nDastana', '1 dk'),
    _SleepTrack('Dandini Dandini\nDastana', '1 dk'),
  ];

  static const _sounds = [
    _SleepTrack('Ya\u011fmur\nSesi', '1 dk'),
    _SleepTrack('R\u00fczgar\nSesi', '1 dk'),
    _SleepTrack('Gece\nOrman\u0131', '1 dk'),
    _SleepTrack('Dalga\nSesi', '1 dk'),
    _SleepTrack('Beyaz\nG\u00fcr\u00fclt\u00fc', '1 dk'),
  ];

  _SleepTab _selectedTab = _SleepTab.lullabies;

  List<_SleepTrack> get _tracks =>
      _selectedTab == _SleepTab.lullabies ? _lullabies : _sounds;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFF444B7A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF444B7A),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final tabTop = (height * 0.35).clamp(262.0, 324.0);
            final listTop = tabTop + 66;

            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Transform.translate(
                    offset: const Offset(0, -240),
                    child: Image.asset(
                      _backgroundImage,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.32),
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF2A376B).withValues(alpha: 0.22),
                          const Color(0xFF384677).withValues(alpha: 0.14),
                          const Color(0xFF434C78).withValues(alpha: 0.78),
                          const Color(0xFF454C7A).withValues(alpha: 0.98),
                        ],
                        stops: const [0, 0.35, 0.58, 1],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: AppHeaderBar(
                            onBack: () => context.go(AppRoutes.home),
                            horizontalPadding: 0,
                            title: 'UYKU',
                            titleStyle: const TextStyle(
                              color: Color(0xFFB3521D),
                              fontFamily: 'BreadMateTR',
                              fontSize: 43,
                              fontWeight: FontWeight.w400,
                              height: 0.92,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          top: tabTop,
                          left: 16,
                          right: 16,
                          child: _SleepSegmentedControl(
                            selectedTab: _selectedTab,
                            onChanged: (tab) =>
                                setState(() => _selectedTab = tab),
                          ),
                        ),
                        Positioned(
                          top: listTop,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _SleepTrackList(
                            imagePath: _cardImage,
                            tracks: _tracks,
                            bottomPadding:
                                MediaQuery.paddingOf(context).bottom + 128,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SleepSegmentedControl extends StatelessWidget {
  const _SleepSegmentedControl({
    required this.selectedTab,
    required this.onChanged,
  });

  final _SleepTab selectedTab;
  final ValueChanged<_SleepTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4E3B1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentButton(
              label: 'Ninniler',
              selected: selectedTab == _SleepTab.lullabies,
              onTap: () => onChanged(_SleepTab.lullabies),
            ),
          ),
          Expanded(
            child: _SegmentButton(
              label: 'Sesler',
              selected: selectedTab == _SleepTab.sounds,
              onTap: () => onChanged(_SleepTab.sounds),
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFFE09A) : Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
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

class _SleepTrackList extends StatelessWidget {
  const _SleepTrackList({
    required this.imagePath,
    required this.tracks,
    required this.bottomPadding,
  });

  final String imagePath;
  final List<_SleepTrack> tracks;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: tracks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final track = tracks[index];
        return _SleepTrackCard(
          imagePath: imagePath,
          track: track,
          onTap: () => context.read<AppState>().playSleepAudio(track.title),
        );
      },
    );
  }
}

class _SleepTrackCard extends StatelessWidget {
  const _SleepTrackCard({
    required this.imagePath,
    required this.track,
    required this.onTap,
  });

  final String imagePath;
  final _SleepTrack track;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              cacheWidth: 256,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.08,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  track.duration,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Material(
            color: const Color(0xFFDADADA),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 62,
                height: 62,
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFB3521D),
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepTrack {
  const _SleepTrack(this.title, this.duration);

  final String title;
  final String duration;
}
