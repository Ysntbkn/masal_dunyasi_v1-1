import 'dart:async';
import 'dart:math' as math;

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
  static const Size _designCanvasSize = Size(360, 480);
  static const Duration _idleObjectHintDelay = Duration(seconds: 5);
  static const Duration _idleObjectHintVisible = Duration(milliseconds: 1400);
  static const Duration _statusBannerVisible = Duration(seconds: 2);

  late final List<InteractiveStoryScene> _scenes;
  final Map<String, Offset> _dragOffsets = <String, Offset>{};
  Timer? _idleHintTimer;
  Timer? _idleHintClearTimer;
  Timer? _statusClearTimer;

  int _currentSceneIndex = 0;
  int _objectHintSignal = 0;
  String? _statusMessage;
  String? _hintObjectId;
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
    _restartIdleObjectHint();
  }

  @override
  void dispose() {
    _idleHintTimer?.cancel();
    _idleHintClearTimer?.cancel();
    _statusClearTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressText = '${_currentSceneIndex + 1}/${_scenes.length}';
    final supportPanel = _buildSupportPanel();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFFF4DE),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4DE),
        body: Stack(
          children: [
            DecoratedBox(
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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: _SceneCard(
                                scene: _currentScene,
                                progressText: progressText,
                                dragOffsetFor: _dragOffsetFor,
                                onObjectTap: _handleObjectTap,
                                onObjectDragUpdate: _handleObjectDragUpdate,
                                onObjectDragEnd: _handleObjectDragEnd,
                                hintObjectId: _hintObjectId,
                                hintSignal: _objectHintSignal,
                              ),
                            ),
                            if (supportPanel != null) ...[
                              const SizedBox(height: 12),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: supportPanel,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: IgnorePointer(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.15),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _statusMessage == null
                      ? const SizedBox.shrink()
                      : _StatusBanner(
                          key: ValueKey<String>(_statusMessage!),
                          message: _statusMessage!,
                          color: _statusColor,
                        ),
                ),
              ),
            ),
          ],
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
                    label: _isLastScene ? 'Tamam' : 'Sonraki',
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
    _statusClearTimer?.cancel();
    _restartIdleObjectHint();
  }

  void _goNext() {
    if (!_canGoNext) return;
    setState(() {
      _currentSceneIndex += 1;
      _statusMessage = null;
    });
    _statusClearTimer?.cancel();
    _restartIdleObjectHint();
  }

  void _handleObjectTap(InteractiveObject object) {
    _restartIdleObjectHint();

    if (object.isCollected) {
      _showStatus('${object.label} zaten tamamlandi.', _statusColor);
      return;
    }

    if (_isDragObject(object)) {
      _showStatus(
        '${object.label} nesnesini surukleyerek kenara cek.',
        const Color(0xFFE28C59),
      );
      return;
    }

    final checkpoint = _currentScene.checkpoint;
    final needsUnlock =
        checkpoint != null &&
        !checkpoint.isUnlocked &&
        object.actionType == InteractiveObjectActionType.open;

    if (needsUnlock) {
      _showStatus(
        'Once sihirli kelimeyi soylemelisin.',
        const Color(0xFFE28C59),
      );
      return;
    }

    _markObjectComplete(
      object,
      message: _interactionMessage(object),
      color: _interactionColor(object.actionType),
    );
  }

  void _handleObjectDragUpdate(InteractiveObject object, Offset delta) {
    if (!_isDragObject(object) || object.isCollected) return;

    _restartIdleObjectHint();
    final key = _dragObjectKey(_currentScene.id, object.id);
    setState(() {
      _dragOffsets[key] = (_dragOffsets[key] ?? Offset.zero) + delta;
    });
  }

  void _handleObjectDragEnd(InteractiveObject object, double completeDistance) {
    if (!_isDragObject(object) || object.isCollected) return;

    _restartIdleObjectHint();
    final key = _dragObjectKey(_currentScene.id, object.id);
    final distance = (_dragOffsets[key] ?? Offset.zero).distance;

    if (distance >= completeDistance) {
      _dragOffsets.remove(key);
      _markObjectComplete(
        object,
        message: '${object.label} kenara cekildi. Yol acildi!',
        color: const Color(0xFF32A47C),
      );
      return;
    }

    setState(() {
      _dragOffsets[key] = Offset.zero;
    });

    _showStatus(
      '${object.label} icin biraz daha suruklemeliyiz.',
      const Color(0xFFE28C59),
    );
  }

  void _markObjectComplete(
    InteractiveObject object, {
    required String message,
    required Color color,
  }) {
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

    _restartIdleObjectHint();
    _showStatus(message, color);
  }

  Offset _dragOffsetFor(String sceneId, String objectId) {
    return _dragOffsets[_dragObjectKey(sceneId, objectId)] ?? Offset.zero;
  }

  Widget? _buildSupportPanel() {
    if (_currentScene.checkpoint != null) {
      if (_isCheckpointUnlocked) {
        return _UnlockedCheckpointCard(
          key: const ValueKey<String>('checkpoint_unlocked'),
          hasPendingObjects: !_areObjectsComplete,
        );
      }

      return _CheckpointCard(
        key: const ValueKey<String>('checkpoint_locked'),
        checkpoint: _currentScene.checkpoint!,
        onUnlockPressed: _attemptCheckpointUnlock,
        onHintPressed: _showHintDialog,
      );
    }

    if (_currentScene.type == InteractiveSceneType.reward) {
      return const _CelebrationCard(key: ValueKey<String>('reward'));
    }

    return null;
  }

  void _restartIdleObjectHint() {
    _idleHintTimer?.cancel();
    _idleHintClearTimer?.cancel();

    if (!mounted) return;

    if (_hintObjectId != null) {
      setState(() {
        _hintObjectId = null;
      });
    }

    if (_currentScene.type == InteractiveSceneType.story ||
        _currentScene.type == InteractiveSceneType.reward ||
        _currentScene.objects.every((object) => object.isCollected)) {
      return;
    }

    final sceneId = _currentScene.id;
    _idleHintTimer = Timer(_idleObjectHintDelay, () {
      if (!mounted || _currentScene.id != sceneId) return;

      final targetObject = _currentScene.objects.firstWhere(
        (object) => !object.isCollected,
      );

      setState(() {
        _hintObjectId = targetObject.id;
        _objectHintSignal += 1;
      });

      _idleHintClearTimer = Timer(_idleObjectHintVisible, () {
        if (!mounted || _currentScene.id != sceneId) return;
        setState(() {
          _hintObjectId = null;
        });
      });
    });
  }

  String _dragObjectKey(String sceneId, String objectId) {
    return '$sceneId::$objectId';
  }

  bool _isDragObject(InteractiveObject object) {
    return object.actionType == InteractiveObjectActionType.drag ||
        object.isDraggable;
  }

  void _attemptCheckpointUnlock() {
    final checkpoint = _currentScene.checkpoint;
    if (checkpoint == null || checkpoint.isUnlocked) return;

    _restartIdleObjectHint();
    final isCorrect = _matchesKeyword(
      spokenText: checkpoint.requiredKeyword,
      requiredKeyword: checkpoint.requiredKeyword,
    );

    if (!isCorrect) {
      _showStatus(
        'Bu sihirli kelime olmadi, tekrar deneyelim.',
        const Color(0xFFE28C59),
      );
      return;
    }

    setState(() {
      _scenes[_currentSceneIndex] = _currentScene.copyWith(
        checkpoint: checkpoint.copyWith(isUnlocked: true),
      );
    });

    _restartIdleObjectHint();
    _showStatus('Kilit acildi.', const Color(0xFF32A47C));
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
            'Ipucu',
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
        return '${object.label} bulundu.';
      case InteractiveObjectActionType.open:
        return '${object.label} acildi.';
      case InteractiveObjectActionType.reward:
        return '${object.label} kazanildi.';
      case InteractiveObjectActionType.drag:
        return '${object.label} tasindi.';
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
      case InteractiveObjectActionType.drag:
        return const Color(0xFFEF7C73);
    }
  }

  void _showStatus(String message, Color color) {
    if (!mounted) return;

    _statusClearTimer?.cancel();
    setState(() {
      _statusMessage = message;
      _statusColor = color;
    });

    _statusClearTimer = Timer(_statusBannerVisible, () {
      if (!mounted) return;
      setState(() {
        if (_statusMessage == message) {
          _statusMessage = null;
        }
      });
    });
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.scene,
    required this.progressText,
    required this.dragOffsetFor,
    required this.onObjectTap,
    required this.onObjectDragUpdate,
    required this.onObjectDragEnd,
    required this.hintObjectId,
    required this.hintSignal,
  });

  final InteractiveStoryScene scene;
  final String progressText;
  final Offset Function(String sceneId, String objectId) dragOffsetFor;
  final ValueChanged<InteractiveObject> onObjectTap;
  final void Function(InteractiveObject object, Offset delta)
  onObjectDragUpdate;
  final void Function(InteractiveObject object, double completeDistance)
  onObjectDragEnd;
  final String? hintObjectId;
  final int hintSignal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              const textPanelHeight = 132.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: math.max(
                      0,
                      constraints.maxHeight - textPanelHeight,
                    ),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: _SceneCanvas(
                          scene: scene,
                          progressText: progressText,
                          dragOffsetFor: dragOffsetFor,
                          onObjectTap: onObjectTap,
                          onObjectDragUpdate: onObjectDragUpdate,
                          onObjectDragEnd: onObjectDragEnd,
                          hintObjectId: hintObjectId,
                          hintSignal: hintSignal,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: textPanelHeight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: SingleChildScrollView(
                        child: Text(
                          scene.text,
                          style: const TextStyle(
                            color: Color(0xFF4C4458),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
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

class _SceneCanvas extends StatelessWidget {
  const _SceneCanvas({
    required this.scene,
    required this.progressText,
    required this.dragOffsetFor,
    required this.onObjectTap,
    required this.onObjectDragUpdate,
    required this.onObjectDragEnd,
    required this.hintObjectId,
    required this.hintSignal,
  });

  final InteractiveStoryScene scene;
  final String progressText;
  final Offset Function(String sceneId, String objectId) dragOffsetFor;
  final ValueChanged<InteractiveObject> onObjectTap;
  final void Function(InteractiveObject object, Offset delta)
  onObjectDragUpdate;
  final void Function(InteractiveObject object, double completeDistance)
  onObjectDragEnd;
  final String? hintObjectId;
  final int hintSignal;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageSize = Size(constraints.maxWidth, constraints.maxHeight);

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
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.low,
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
                    Colors.black.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.16),
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
            if (scene.type == InteractiveSceneType.reward)
              const Center(child: _RewardOverlay()),
            for (final object in scene.objects)
              _SceneObjectLayer(
                sceneId: scene.id,
                object: object,
                stageSize: stageSize,
                dragOffset: dragOffsetFor(scene.id, object.id),
                onTap: () => onObjectTap(object),
                onDragUpdate: (delta) => onObjectDragUpdate(object, delta),
                onDragEnd: (distance) => onObjectDragEnd(object, distance),
                shouldHint: hintObjectId == object.id,
                hintSignal: hintSignal,
              ),
          ],
        );
      },
    );
  }
}

class _SceneObjectLayer extends StatelessWidget {
  const _SceneObjectLayer({
    required this.sceneId,
    required this.object,
    required this.stageSize,
    required this.dragOffset,
    required this.onTap,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.shouldHint,
    required this.hintSignal,
  });

  final String sceneId;
  final InteractiveObject object;
  final Size stageSize;
  final Offset dragOffset;
  final VoidCallback onTap;
  final ValueChanged<Offset> onDragUpdate;
  final ValueChanged<double> onDragEnd;
  final bool shouldHint;
  final int hintSignal;

  @override
  Widget build(BuildContext context) {
    if (object.isCollected &&
        object.actionType == InteractiveObjectActionType.drag) {
      return const SizedBox.shrink();
    }

    final metrics = _SceneObjectMetrics.fromObject(
      object: object,
      stageSize: stageSize,
      dragOffset: dragOffset,
    );
    final isDragObject =
        object.actionType == InteractiveObjectActionType.drag ||
        object.isDraggable;
    final completeDistance = math.max(metrics.width * 0.42, 42.0).toDouble();

    return Positioned(
      left: metrics.left,
      top: metrics.top,
      child: _SceneObjectWidget(
        object: object,
        width: metrics.width,
        height: metrics.height,
        isDragObject: isDragObject,
        onTap: onTap,
        onDragUpdate: onDragUpdate,
        onDragEnd: () => onDragEnd(completeDistance),
        shouldHint: shouldHint,
        hintSignal: hintSignal,
      ),
    );
  }
}

class _SceneObjectMetrics {
  const _SceneObjectMetrics({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  factory _SceneObjectMetrics.fromObject({
    required InteractiveObject object,
    required Size stageSize,
    required Offset dragOffset,
  }) {
    final scaleX =
        stageSize.width / _InteractiveStoryScreenState._designCanvasSize.width;
    final scaleY =
        stageSize.height /
        _InteractiveStoryScreenState._designCanvasSize.height;
    final width = object.width * scaleX;
    final height = object.height * scaleY;
    final anchorX = object.positionX * stageSize.width;
    final anchorY = object.positionY * stageSize.height;

    final leftTop = _resolveAnchorTopLeft(
      anchor: object.anchor,
      anchorX: anchorX,
      anchorY: anchorY,
      width: width,
      height: height,
    );

    return _SceneObjectMetrics(
      left: leftTop.dx + dragOffset.dx,
      top: leftTop.dy + dragOffset.dy,
      width: width,
      height: height,
    );
  }

  static Offset _resolveAnchorTopLeft({
    required InteractiveObjectAnchor anchor,
    required double anchorX,
    required double anchorY,
    required double width,
    required double height,
  }) {
    switch (anchor) {
      case InteractiveObjectAnchor.topLeft:
        return Offset(anchorX, anchorY);
      case InteractiveObjectAnchor.topCenter:
        return Offset(anchorX - (width / 2), anchorY);
      case InteractiveObjectAnchor.topRight:
        return Offset(anchorX - width, anchorY);
      case InteractiveObjectAnchor.centerLeft:
        return Offset(anchorX, anchorY - (height / 2));
      case InteractiveObjectAnchor.center:
        return Offset(anchorX - (width / 2), anchorY - (height / 2));
      case InteractiveObjectAnchor.centerRight:
        return Offset(anchorX - width, anchorY - (height / 2));
      case InteractiveObjectAnchor.bottomLeft:
        return Offset(anchorX, anchorY - height);
      case InteractiveObjectAnchor.bottomCenter:
        return Offset(anchorX - (width / 2), anchorY - height);
      case InteractiveObjectAnchor.bottomRight:
        return Offset(anchorX - width, anchorY - height);
    }
  }
}

class _SceneObjectWidget extends StatefulWidget {
  const _SceneObjectWidget({
    required this.object,
    required this.width,
    required this.height,
    required this.isDragObject,
    required this.onTap,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.shouldHint,
    required this.hintSignal,
  });

  final InteractiveObject object;
  final double width;
  final double height;
  final bool isDragObject;
  final VoidCallback onTap;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;
  final bool shouldHint;
  final int hintSignal;

  @override
  State<_SceneObjectWidget> createState() => _SceneObjectWidgetState();
}

class _SceneObjectWidgetState extends State<_SceneObjectWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void didUpdateWidget(covariant _SceneObjectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldHint &&
        widget.hintSignal != oldWidget.hintSignal &&
        !widget.object.isCollected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: widget.object.isCollected && !widget.isDragObject
                  ? 0.5
                  : 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: widget.isDragObject
                      ? const []
                      : [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.45),
                            blurRadius: widget.object.assetIcon == null
                                ? 12
                                : 22,
                            spreadRadius: widget.object.assetIcon == null
                                ? 0
                                : 2,
                          ),
                        ],
                ),
                child: widget.object.assetIcon != null
                    ? Image.asset(
                        widget.object.assetIcon!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return _FallbackObjectIcon(
                            iconName: widget.object.iconName,
                            isCollected: widget.object.isCollected,
                          );
                        },
                      )
                    : _FallbackObjectIcon(
                        iconName: widget.object.iconName,
                        isCollected: widget.object.isCollected,
                      ),
              ),
            ),
          ),
          if (widget.object.isCollected && !widget.isDragObject)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF32A47C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );

    final animatedContent = AnimatedBuilder(
      animation: _controller,
      child: content,
      builder: (context, child) {
        final progress = Curves.easeInOut.transform(_controller.value);
        final rotation =
            math.sin(progress * math.pi * 6) * 0.1 * (1 - progress);
        final bounce = math.sin(progress * math.pi * 3) * 8;
        final scale = 1 + (math.sin(progress * math.pi) * 0.06);

        return Transform.translate(
          offset: Offset(0, -bounce.abs()),
          child: Transform.rotate(
            angle: rotation,
            child: Transform.scale(scale: scale, child: child),
          ),
        );
      },
    );

    if (widget.isDragObject) {
      return GestureDetector(
        onPanUpdate: (details) => widget.onDragUpdate(details.delta),
        onPanEnd: (_) => widget.onDragEnd(),
        child: animatedContent,
      );
    }

    return GestureDetector(onTap: widget.onTap, child: animatedContent);
  }
}

class _FallbackObjectIcon extends StatelessWidget {
  const _FallbackObjectIcon({
    required this.iconName,
    required this.isCollected,
  });

  final String? iconName;
  final bool isCollected;

  @override
  Widget build(BuildContext context) {
    final iconColor = isCollected
        ? const Color(0xFF32A47C)
        : const Color(0xFFA84C2A);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isCollected
              ? const Color(0xFF32A47C)
              : const Color(0xFFFFD39C),
          width: 2,
        ),
      ),
      child: Center(
        child: Icon(_iconForName(iconName), color: iconColor, size: 30),
      ),
    );
  }

  static IconData _iconForName(String? iconName) {
    switch (iconName) {
      case 'key':
        return Icons.key_rounded;
      case 'door':
        return Icons.lock_open_rounded;
      case 'star':
        return Icons.star_rounded;
      case 'mirror':
        return Icons.auto_awesome_rounded;
      case 'box':
        return Icons.inventory_2_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}

class _RewardOverlay extends StatelessWidget {
  const _RewardOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26),
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: Color(0xFFE9A93C),
            size: 58,
          ),
          SizedBox(height: 10),
          Text(
            'Kraliyet Yardimcisi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFA84C2A),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckpointCard extends StatelessWidget {
  const _CheckpointCard({
    super.key,
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
          const SizedBox(height: 10),
          Text(
            checkpoint.instructionText,
            style: const TextStyle(
              color: Color(0xFF4C4458),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniActionButton(
                  label: 'Kelimeyi Soyledim',
                  icon: Icons.mic_rounded,
                  color: const Color(0xFFEF7C73),
                  onTap: onUnlockPressed,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniActionButton(
                  label: 'Ipucu',
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
  const _UnlockedCheckpointCard({super.key, required this.hasPendingObjects});

  final bool hasPendingObjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                  ? 'Kilit acildi. Simdi sahnedeki gorevi tamamlayarak ilerle.'
                  : 'Sihirli kilit cozuldu. Sonraki sahne hazir!',
              style: const TextStyle(
                color: Color(0xFF1F6E56),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CelebrationCard extends StatelessWidget {
  const _CelebrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
              'Masal tamamlandi. Yeni maceralar icin artik sadece sahne verisi tanimlaman yeterli.',
              style: TextStyle(
                color: Color(0xFF4C4458),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({super.key, required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.24), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 14,
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
