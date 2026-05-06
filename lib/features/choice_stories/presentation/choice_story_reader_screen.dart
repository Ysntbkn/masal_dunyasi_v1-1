import 'package:flutter/material.dart';

import '../../../shared/theme/app_theme.dart';
import '../data/models/choice_story.dart';

class ChoiceStoryReaderScreen extends StatefulWidget {
  const ChoiceStoryReaderScreen({super.key, required this.choiceStory});

  final ChoiceStory choiceStory;

  @override
  State<ChoiceStoryReaderScreen> createState() =>
      _ChoiceStoryReaderScreenState();
}

class _ChoiceStoryReaderScreenState extends State<ChoiceStoryReaderScreen> {
  late String _currentSceneId;
  bool _showSceneActions = false;

  ChoiceStoryScene get _currentScene => widget.choiceStory.scenes.firstWhere(
    (scene) => scene.id == _currentSceneId,
    orElse: () => widget.choiceStory.scenes.first,
  );

  @override
  void initState() {
    super.initState();
    _currentSceneId = widget.choiceStory.scenes.first.id;
    _revealSceneActions();
  }

  @override
  Widget build(BuildContext context) {
    final scene = _currentScene;

    return Scaffold(
      backgroundColor: const Color(0xFFF6FBFF),
      appBar: AppBar(
        title: Text(
          widget.choiceStory.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFDF4FF),
                        Color(0xFFFFF7EE),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 18,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (scene.imageAsset != null)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              scene.imageAsset!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const _ChoiceStoryImagePlaceholder();
                              },
                            ),
                          )
                        else
                          const AspectRatio(
                            aspectRatio: 4 / 3,
                            child: _ChoiceStoryImagePlaceholder(),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 260),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              child: Column(
                                key: ValueKey<String>(scene.id),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    scene.text,
                                    style: const TextStyle(
                                      color: AppColors.ink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: !_showSceneActions
                    ? const SizedBox(
                        key: ValueKey('choice-loading'),
                        height: 72,
                      )
                    : scene.isEnding
                    ? FilledButton(
                        key: ValueKey('ending-${scene.id}'),
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF5B4DB2),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        child: const Text('Masali Bitir'),
                      )
                    : Column(
                        key: ValueKey('options-${scene.id}'),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 10),
                            child: Text(
                              'Secimini yap',
                              style: TextStyle(
                                color: Color(0xFF7C6B58),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                          for (var i = 0; i < scene.options.length; i++) ...[
                            _ChoiceOptionButton(
                              index: i + 1,
                              label: scene.options[i].text,
                              onTap: () =>
                                  _goToScene(scene.options[i].nextSceneId),
                            ),
                            if (i != scene.options.length - 1)
                              const SizedBox(height: 10),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _revealSceneActions() {
    _showSceneActions = false;
    Future<void>.delayed(const Duration(milliseconds: 280), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _showSceneActions = true;
      });
    });
  }

  void _goToScene(String nextSceneId) {
    setState(() {
      _currentSceneId = nextSceneId;
      _showSceneActions = false;
    });
    _revealSceneActions();
  }
}

class _ChoiceOptionButton extends StatelessWidget {
  const _ChoiceOptionButton({
    required this.index,
    required this.label,
    required this.onTap,
  });

  final int index;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFFFFCF6),
            border: Border.all(color: const Color(0xFFE8D9BC)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3E4C7),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: AppColors.cinnamon,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_outward_rounded,
                color: Color(0xFF8E7656),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceStoryImagePlaceholder extends StatelessWidget {
  const _ChoiceStoryImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF0D7), Color(0xFFF7E9FF), Color(0xFFDFF5FF)],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 54,
              color: Color(0xFFA84E2B),
            ),
            SizedBox(height: 10),
            Text(
              'Masal Gorseli',
              style: TextStyle(
                color: Color(0xFFA84E2B),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
