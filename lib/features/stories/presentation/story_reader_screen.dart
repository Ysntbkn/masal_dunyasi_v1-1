import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_flip/page_flip.dart';
import 'package:provider/provider.dart';

import '../../../core/state/app_state.dart';
import '../../../core/stories/story_catalog.dart';
import '../../../shared/widgets/app_back_button.dart';
import '../../../shared/widgets/global_confetti_burst.dart';
import 'story_screen_shared.dart';

const _readerScaffoldColor = Color(0xFFFFF8F1);
const _readerControlColor = Color(0xFFF8EBDD);
const _pageTurnDuration = Duration(milliseconds: 380);

class StoryReaderScreen extends StatefulWidget {
  const StoryReaderScreen({super.key, required this.storyId});

  final String storyId;

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  final PageFlipController _pageFlipController = PageFlipController();

  late final StoryCatalogEntry _story;
  late final List<String> _pages;
  late final List<Widget> _bookPages;
  late final String _coverPath;
  late int _page;

  bool _isAnimating = false;
  bool _completionDialogShown = false;

  @override
  void initState() {
    super.initState();
    _story = storyCatalogEntryFor(widget.storyId);
    _pages = _storyPagesFor(_story);
    _coverPath = resolveStoryCoverPath(_story);
    _bookPages = List<Widget>.generate(
      _pages.length,
      (index) => _ReaderPageContent(
        coverPath: _coverPath,
        pageText: _pages[index],
        imageAlignment: _pageImageAlignment(index),
      ),
    );

    final state = context.read<AppState>();
    state.startReadingStory(widget.storyId);
    _page = state.readingPageFor(widget.storyId).clamp(1, _pages.length);
    _completionDialogShown = _page >= _pages.length;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _page / _pages.length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _readerScaffoldColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: PageFlipWidget(
                controller: _pageFlipController,
                backgroundColor: Colors.white,
                duration: _pageTurnDuration,
                initialIndex: _page - 1,
                cutoffForward: 0.75,
                cutoffPrevious: 0.15,
                onFlipStart: () {
                  if (!mounted) return;
                  setState(() => _isAnimating = true);
                },
                onPageFlipped: (pageIndex) => _syncPage(pageIndex + 1),
                children: _bookPages,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: AppBackButton(
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: _readerScaffoldColor,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 16),
            child: _ReaderControlBar(
              progress: progress,
              onPrevious: _page > 1 && !_isAnimating ? _goPrevious : null,
              onNext: _page < _pages.length && !_isAnimating ? _goNext : null,
            ),
          ),
        ),
      ),
    );
  }

  void _goPrevious() {
    if (_page <= 1 || _isAnimating) return;
    _pageFlipController.previousPage();
  }

  void _goNext() {
    if (_page >= _pages.length || _isAnimating) return;
    _pageFlipController.nextPage();
  }

  void _syncPage(int nextPage) {
    final clampedPage = nextPage.clamp(1, _pages.length);
    if (!mounted) return;

    setState(() {
      _page = clampedPage;
      _isAnimating = false;
    });

    context.read<AppState>().updateReadingProgress(widget.storyId, _page);

    if (_page >= _pages.length && !_completionDialogShown) {
      _completionDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showCompletionDialog();
      });
    }
  }

  Future<void> _showCompletionDialog() async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tebrikler',
      barrierColor: Colors.black.withValues(alpha: 0.24),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _ReaderCompletionDialog();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class _ReaderPageContent extends StatelessWidget {
  const _ReaderPageContent({
    required this.coverPath,
    required this.pageText,
    required this.imageAlignment,
  });

  final String coverPath;
  final String pageText;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final heroHeight = (size.height * 0.40).clamp(300.0, 380.0);

    return ColoredBox(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: heroHeight,
            child: Image.asset(
              coverPath,
              fit: BoxFit.cover,
              alignment: imageAlignment,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: heroHeight - 54,
            bottom: 0,
            child: _ReaderTextSurface(pageText: pageText),
          ),
        ],
      ),
    );
  }
}

class _ReaderTextSurface extends StatelessWidget {
  const _ReaderTextSurface({required this.pageText});

  final String pageText;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const ReaderWaveClipper(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(28, 78, 28, 24),
        child: Text(
          pageText,
          style: const TextStyle(
            color: Color(0xFF202020),
            fontSize: 22.5,
            height: 1.84,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _ReaderControlBar extends StatelessWidget {
  const _ReaderControlBar({
    required this.progress,
    required this.onPrevious,
    required this.onNext,
  });

  final double progress;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _readerControlColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _ReaderArrowButton(
            icon: Icons.chevron_left_rounded,
            onTap: onPrevious,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE6DDD4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE58A2B),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _ReaderArrowButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _ReaderArrowButton extends StatelessWidget {
  const _ReaderArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFB95A27),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: onTap == null ? 0.42 : 1),
            size: 21,
          ),
        ),
      ),
    );
  }
}

class ReaderWaveClipper extends CustomClipper<Path> {
  const ReaderWaveClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 42);
    path.cubicTo(
      size.width * 0.22,
      0,
      size.width * 0.38,
      0,
      size.width * 0.50,
      28,
    );
    path.cubicTo(size.width * 0.64, 58, size.width * 0.78, 58, size.width, 24);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ReaderCompletionDialog extends StatelessWidget {
  const _ReaderCompletionDialog();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GlobalConfettiBurst(),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tebrikler!',
                      style: TextStyle(
                        color: Color(0xFFB95A27),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Masalin sonuna geldin. Harika okudun!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4B433C),
                        fontSize: 17,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB95A27),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Kapat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Alignment _pageImageAlignment(int pageIndex) {
  const alignments = [
    Alignment(0.0, -0.05),
    Alignment(-0.12, 0.0),
    Alignment(0.10, -0.08),
    Alignment(-0.08, 0.08),
    Alignment(0.12, 0.0),
  ];

  return alignments[pageIndex % alignments.length];
}

List<String> _storyPagesFor(StoryCatalogEntry story) {
  final title = story.title.toLowerCase();

  return [
    '$title boyunca sabah isigi yumusacik yapraklara vuruyor, minik ayicik sessiz ormanda etrafini merakla izliyordu. Her yerde altin tozlari gibi parlayan kucuk isiklar vardi.',
    'Kelebekler ciceklerin arasinda dolasirken minik dostumuz yavas adimlarla patikada ilerledi. Kalbi sakindi; yeni bir sey ogrenmenin heyecaniyla gulumsemeye devam etti.',
    'Bir sure sonra ciceklerin ardinda minicik bir dost belirdi. Ikisi birlikte isiltinin geldigi yone bakti ve gunun en guzel surpizlerinin paylasildikca cogaldigini fark etti.',
    'Ormandaki ruzgar hafifce esince yapraklar ninni gibi sesler cikardi. Minik ayicik, cesaretin bazen sadece nazik kalmak ve etrafa sevgiyle bakmak oldugunu dusundu.',
    'Aksam yaklasirken gokyuzu sicak renklere boyandi. Minik kahramanimiz eve donerken bugunun hikayesini kalbinde tasidi ve yarin acilacak yeni sayfayi merak etti.',
  ];
}
