import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/interactive_story_scene.dart';
import 'story_screen_shared.dart';

class InteractiveStoryScreen extends StatefulWidget {
  const InteractiveStoryScreen({
    super.key,
    required this.storyTitle,
    required this.scenes,
  });

  final String storyTitle;
  final List<InteractiveStoryScene> scenes;

  @override
  State<InteractiveStoryScreen> createState() => _InteractiveStoryScreenState();
}

class _InteractiveStoryScreenState extends State<InteractiveStoryScreen> {
  static const LinearGradient _pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF4DE), Color(0xFFF9E7FF), Color(0xFFE0F5FF)],
  );

  late final List<InteractiveStoryScene> _scenes;

  int _currentSceneIndex = 0;
  String? _statusMessage;
  Color _statusColor = const Color(0xFF2E9F8F);

  InteractiveStoryScene get _currentScene => _scenes[_currentSceneIndex];

  bool get _isLastScene => _currentSceneIndex == _scenes.length - 1;

  bool get _isCheckpointUnlocked =>
      _currentScene.checkpoint?.isUnlocked ?? true;

  bool get _areObjectsComplete =>
      _currentScene.objects.every((object) => object.isCollected);

  bool get _canGoNext =>
      !_isLastScene && _isCheckpointUnlocked && _areObjectsComplete;

  @override
  void initState() {
    super.initState();
    _scenes = widget.scenes
        .map(
          (scene) => scene.copyWith(
            objects: scene.objects.map((object) => object.copyWith()).toList(),
            checkpoint: scene.checkpoint?.copyWith(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final progressText = '${_currentSceneIndex + 1}/${_scenes.length}';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF4DE),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4DE),
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: _pageGradient),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
                  child: Row(
                    children: [
                      StoryBackIconButton(
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      _ProgressBadge(label: progressText),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.storyTitle,
                    textAlign: TextAlign.center,
                    style: storyTitleStyle(
                      fontSize: 28,
                      color: const Color(0xFFA84C2A),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SceneCard(
                          scene: _currentScene,
                          progressText: progressText,
                          onObjectTap: _handleObjectTap,
                        ),
                        if (_statusMessage != null) ...[
                          const SizedBox(height: 14),
                          _StatusBanner(
                            message: _statusMessage!,
                            color: _statusColor,
                          ),
                        ],
                        if (_currentScene.checkpoint != null) ...[
                          const SizedBox(height: 14),
                          if (_isCheckpointUnlocked)
                            _UnlockedCheckpointCard(
                              hasPendingObjects: !_areObjectsComplete,
                            )
                          else
                            _CheckpointCard(
                              checkpoint: _currentScene.checkpoint!,
                              onUnlockPressed: _attemptCheckpointUnlock,
                              onHintPressed: _showHintDialog,
                            ),
                        ],
                        if (_currentScene.objects.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          _SceneHintCard(
                            isComplete: _areObjectsComplete,
                            scene: _currentScene,
                          ),
                        ],
                        if (_isLastScene) ...[
                          const SizedBox(height: 14),
                          const _CelebrationCard(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: const Color(0xFFFFF4DE),
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
          child: SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: _NavigationButton(
                    label: 'Geri',
                    icon: Icons.chevron_left_rounded,
                    color: const Color(0xFFE6B77E),
                    onTap: _currentSceneIndex > 0 ? _goPrevious : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NavigationButton(
                    label: 'Sonraki',
                    icon: Icons.chevron_right_rounded,
                    color: const Color(0xFFEF7C73),
                    isTrailingIcon: true,
                    onTap: _canGoNext ? _goNext : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goPrevious() {
    if (_currentSceneIndex == 0) return;
    setState(() {
      _currentSceneIndex -= 1;
      _statusMessage = null;
    });
  }

  void _goNext() {
    if (!_canGoNext) return;
    setState(() {
      _currentSceneIndex += 1;
      _statusMessage = _isLastScene
          ? 'Prensese çok yaklaştın, devam et! 👑'
          : 'Yeni sahne açıldı 🌈';
      _statusColor = const Color(0xFF4AA3D8);
    });
  }

  void _handleObjectTap(InteractiveObject object) {
    if (object.isCollected) {
      _showStatus('${object.label} zaten hazır bekliyor 👀', _statusColor);
      return;
    }

    final checkpoint = _currentScene.checkpoint;
    final needsUnlock =
        checkpoint != null &&
        !checkpoint.isUnlocked &&
        object.actionType == InteractiveObjectActionType.open;

    if (needsUnlock) {
      _showStatus(
        'Önce sihirli kelimeyi söylemelisin 🔐',
        const Color(0xFFE28C59),
      );
      return;
    }

    final updatedObjects = _currentScene.objects
        .map(
          (item) =>
              item.id == object.id ? item.copyWith(isCollected: true) : item,
        )
        .toList();

    setState(() {
      _scenes[_currentSceneIndex] = _currentScene.copyWith(
        objects: updatedObjects,
      );
    });

    _showStatus(
      _interactionMessage(object),
      _interactionColor(object.actionType),
    );
  }

  // This method is the single unlock entry point, ready for future speech input.
  void _attemptCheckpointUnlock() {
    final checkpoint = _currentScene.checkpoint;
    if (checkpoint == null || checkpoint.isUnlocked) return;

    final isCorrect = _matchesKeyword(
      spokenText: checkpoint.requiredKeyword,
      requiredKeyword: checkpoint.requiredKeyword,
    );

    if (!isCorrect) {
      _showStatus(
        'Bu sihirli kelime olmadı, tekrar deneyelim ✨',
        const Color(0xFFE28C59),
      );
      return;
    }

    setState(() {
      _scenes[_currentSceneIndex] = _currentScene.copyWith(
        checkpoint: checkpoint.copyWith(isUnlocked: true),
      );
    });

    _showStatus('Kapı açıldı ✨', const Color(0xFF32A47C));
  }

  bool _matchesKeyword({
    required String spokenText,
    required String requiredKeyword,
  }) {
    return _normalizeKeyword(spokenText) == _normalizeKeyword(requiredKeyword);
  }

  String _normalizeKeyword(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ç', 'c')
        .replaceAll('ö', 'o')
        .replaceAll('ü', 'u');
  }

  void _showHintDialog() {
    final hintText = _currentScene.checkpoint?.hintText;
    if (hintText == null) return;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'İpucu',
            style: TextStyle(
              color: Color(0xFFA84C2A),
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            hintText,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4C4458),
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  String _interactionMessage(InteractiveObject object) {
    switch (object.actionType) {
      case InteractiveObjectActionType.collect:
        return '${object.label} alındı 🗝️';
      case InteractiveObjectActionType.open:
        return '${object.label} açıldı 🚪';
      case InteractiveObjectActionType.reward:
        return '${object.label} toplandı ⭐';
    }
  }

  Color _interactionColor(InteractiveObjectActionType actionType) {
    switch (actionType) {
      case InteractiveObjectActionType.collect:
        return const Color(0xFF4AA3D8);
      case InteractiveObjectActionType.open:
        return const Color(0xFF32A47C);
      case InteractiveObjectActionType.reward:
        return const Color(0xFFE9A93C);
    }
  }

  void _showStatus(String message, Color color) {
    if (!mounted) return;

    setState(() {
      _statusMessage = message;
      _statusColor = color;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.scene,
    required this.progressText,
    required this.onObjectTap,
  });

  final InteractiveStoryScene scene;
  final String progressText;
  final ValueChanged<InteractiveObject> onObjectTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: AspectRatio(
          aspectRatio: 0.92,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const objectSize = 82.0;
              const horizontalInset = 12.0;
              const topInset = 20.0;
              const bottomTextHeight = 126.0;
              final availableWidth =
                  constraints.maxWidth - objectSize - (horizontalInset * 2);
              final availableHeight =
                  constraints.maxHeight -
                  bottomTextHeight -
                  objectSize -
                  topInset -
                  20;

              return Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFB8E8FF),
                          Color(0xFFF8D9F6),
                          Color(0xFFFFF2DA),
                        ],
                      ),
                    ),
                    child: scene.backgroundAsset == null
                        ? null
                        : Image.asset(
                            scene.backgroundAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.10),
                          Colors.black.withValues(alpha: 0.03),
                          Colors.black.withValues(alpha: 0.22),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    top: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Sahne $progressText',
                        style: const TextStyle(
                          color: Color(0xFF74574A),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  for (final object in scene.objects)
                    Positioned(
                      left:
                          horizontalInset + (availableWidth * object.positionX),
                      top: topInset + (availableHeight * object.positionY),
                      child: _InteractiveObjectChip(
                        object: object,
                        onTap: () => onObjectTap(object),
                      ),
                    ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            scene.title,
                            style: const TextStyle(
                              color: Color(0xFFA84C2A),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            scene.text,
                            style: const TextStyle(
                              color: Color(0xFF4C4458),
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 1.45,
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
      ),
    );
  }
}

class _InteractiveObjectChip extends StatelessWidget {
  const _InteractiveObjectChip({required this.object, required this.onTap});

  final InteractiveObject object;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = object.isCollected
        ? const Color(0xFF32A47C)
        : const Color(0xFFA84C2A);

    return AnimatedScale(
      scale: object.isCollected ? 0.96 : 1,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            width: 82,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.94),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: object.isCollected
                    ? const Color(0xFF32A47C)
                    : const Color(0xFFFFD39C),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 34,
                  child: object.assetIcon != null
                      ? Image.asset(
                          object.assetIcon!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _iconForName(object.iconName),
                              color: iconColor,
                              size: 28,
                            );
                          },
                        )
                      : Icon(
                          _iconForName(object.iconName),
                          color: iconColor,
                          size: 30,
                        ),
                ),
                const SizedBox(height: 6),
                Text(
                  object.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5D4A43),
                    height: 1.15,
                  ),
                ),
                if (object.isCollected) ...[
                  const SizedBox(height: 4),
                  const Text(
                    'Tamam',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF32A47C),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForName(String? iconName) {
    switch (iconName) {
      case 'key':
        return Icons.key_rounded;
      case 'door':
        return Icons.lock_open_rounded;
      case 'star':
        return Icons.star_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}

class _CheckpointCard extends StatelessWidget {
  const _CheckpointCard({
    required this.checkpoint,
    required this.onUnlockPressed,
    required this.onHintPressed,
  });

  final UnlockCheckpoint checkpoint;
  final VoidCallback onUnlockPressed;
  final VoidCallback onHintPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_rounded, color: Color(0xFFA84C2A)),
              SizedBox(width: 8),
              Text(
                'Sihirli Kilit',
                style: TextStyle(
                  color: Color(0xFFA84C2A),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            checkpoint.instructionText,
            style: const TextStyle(
              color: Color(0xFF4C4458),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniActionButton(
                  label: 'Kelimeyi Söyledim',
                  icon: Icons.mic_rounded,
                  color: const Color(0xFFEF7C73),
                  onTap: onUnlockPressed,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniActionButton(
                  label: 'İpucu',
                  icon: Icons.lightbulb_rounded,
                  color: const Color(0xFFE6B77E),
                  onTap: onHintPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnlockedCheckpointCard extends StatelessWidget {
  const _UnlockedCheckpointCard({required this.hasPendingObjects});

  final bool hasPendingObjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6FFF3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF32A47C),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_open_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasPendingObjects
                  ? 'Kapı açıldı ✨ Şimdi sahnedeki objeye dokunarak ilerle.'
                  : 'Sihirli kilit çözüldü. Sonraki sahne hazır!',
              style: const TextStyle(
                color: Color(0xFF1F6E56),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneHintCard extends StatelessWidget {
  const _SceneHintCard({required this.isComplete, required this.scene});

  final bool isComplete;
  final InteractiveStoryScene scene;

  @override
  Widget build(BuildContext context) {
    final remainingCount = scene.objects
        .where((object) => !object.isCollected)
        .length;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app_rounded, color: Color(0xFF4AA3D8)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isComplete
                  ? 'Harika! Bu sahnedeki tüm nesneleri keşfettin.'
                  : 'İlerlemek için $remainingCount nesneye daha dokun.',
              style: const TextStyle(
                color: Color(0xFF4C4458),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CelebrationCard extends StatelessWidget {
  const _CelebrationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Icon(Icons.celebration_rounded, color: Color(0xFFE9A93C), size: 28),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Masal tamamlandı. İnteraktif mod ilk demo haliyle hazır! 🎉',
              style: TextStyle(
                color: Color(0xFF4C4458),
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_stories_rounded,
            size: 18,
            color: Color(0xFFA84C2A),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA84C2A),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isTrailingIcon = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isTrailingIcon;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = onTap == null
        ? const Color(0xFFB9A79E)
        : Colors.white;

    return Opacity(
      opacity: onTap == null ? 0.65 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              color: onTap == null ? const Color(0xFFF0E1D4) : color,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isTrailingIcon) ...[
                  Icon(icon, color: foregroundColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (isTrailingIcon) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: foregroundColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  const _MiniActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
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
