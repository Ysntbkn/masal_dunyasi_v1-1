import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoyalDayStoryScreen extends StatefulWidget {
  const RoyalDayStoryScreen({super.key});

  @override
  State<RoyalDayStoryScreen> createState() => _RoyalDayStoryScreenState();
}

class _RoyalDayStoryScreenState extends State<RoyalDayStoryScreen> {
  static const _pageColor = Color(0xFF2F255E);
  static const _panelColor = Color(0xFFF4E0C5);

  static const _stages = [
    _RoyalStage(
      title: 'Bolum 1 - Kraliyet Gunu',
      description:
          'Bir zamanlar rengarenk ciceklerle dolu bir krallikta Mia adinda genc bir prenses yasarmis. Bugun kalede buyuk bir kutlama varmis. Cunku Mia ilk kez kraliyet balkonuna cikacakmis.',
      imagePath: 'asset/interactive/kayip_tac/bolum_1.png',
      imageAlignment: Alignment.topCenter,
      sceneType: _RoyalSceneType.bedroom,
    ),
    _RoyalStage(
      title: '',
      description:
          'Ama hazirlanirken bir sorun olmus...\nPrensesin altin taci kaybolmus!\nHerkes telaslanmis.',
      imagePath: 'asset/interactive/kayip_tac/bolum_2.png',
      imageAlignment: Alignment(0, -0.32),
      sceneType: _RoyalSceneType.corridor,
    ),
    _RoyalStage(
      title: '',
      description:
          'Mia uzgunce:\n"Tac olmadan toren baslayamaz..." demis.\nTam o sirada kucuk bir serce gelip pencereye konmus.\nSanki sana yardim etmen gerektigini soyluyormus.',
      imagePath: 'asset/interactive/kayip_tac/bolum_3.png',
      imageAlignment: Alignment.topCenter,
      sceneType: _RoyalSceneType.kitchen,
    ),
    _RoyalStage(
      title: 'Simdi Mia\'ya Yardim Etme Zamani',
      description:
          'Taci aramaya ciktin ama onune bir engel cikti.\nBu engeli kaldir ve Mia\'ya yardim et.',
      imagePath: 'asset/interactive/kayip_tac/bolum_4 engel_interaktif.png',
      imageAlignment: Alignment(0, -0.18),
      sceneType: _RoyalSceneType.corridor,
    ),
    _RoyalStage(
      title: 'Final - Balkon Toreni',
      description:
          'Kapilar acildi. Mia tacini takti ve balkona cikti. Bugunu sen kurtardin. Odul: Kraliyet Yardimcisi.',
      imagePath: 'asset/interactive/kayip_tac/bolum_5.png',
      imageAlignment: Alignment.topCenter,
      sceneType: _RoyalSceneType.balcony,
    ),
  ];

  late final List<_RoyalPage> _pages = _buildPages(_stages);

  int _currentPageIndex = 0;
  bool _soundEnabled = true;

  final Set<_RoyalInventoryItem> _inventory = <_RoyalInventoryItem>{};
  final Set<_RoyalInventoryItem> _assembledPieces = <_RoyalInventoryItem>{};

  _RoyalPage get _currentPage => _pages[_currentPageIndex];
  _RoyalStage get _currentStage => _currentPage.stage;

  bool get _canMoveNext {
    if (_currentStage.sceneType != _RoyalSceneType.crownAssembly) {
      return _currentPageIndex < _pages.length - 1;
    }

    switch (_currentStage.sceneType) {
      case _RoyalSceneType.bedroom:
      case _RoyalSceneType.corridor:
      case _RoyalSceneType.kitchen:
        return _currentPageIndex < _pages.length - 1;
      case _RoyalSceneType.crownAssembly:
        return _assembledPieces.length == 3;
      case _RoyalSceneType.balcony:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _pageColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: _pageColor,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2E245D), Color(0xFF362C72), Color(0xFF2B2157)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF34256A), Color(0xFF2B225A)],
                    ),
                  ),
                  child: Row(
                    children: [
                      _RoundActionButton(
                        icon: Icons.arrow_back_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      Expanded(
                        child: _TopProgress(
                          currentIndex: _currentPageIndex,
                          itemCount: _pages.length,
                        ),
                      ),
                      _RoundActionButton(
                        icon: _soundEnabled
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        onTap: () {
                          setState(() => _soundEnabled = !_soundEnabled);
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const inventoryAreaHeight = 112.0;
                      const overlap = 38.0;
                      final panelHeight = (constraints.maxHeight * 0.255).clamp(
                        170.0,
                        232.0,
                      );
                      final sceneBottom =
                          inventoryAreaHeight + panelHeight - overlap + 26;

                      return Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            bottom: sceneBottom,
                            child: _RoyalSceneStage(
                              stage: _currentStage,
                              inventory: _inventory,
                              assembledPieces: _assembledPieces,
                              onAssemblePiece: _assemblePiece,
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            bottom: inventoryAreaHeight + 14,
                            child: _StoryPanel(
                              title: _currentPage.title,
                              description: _currentPage.description,
                              height: panelHeight,
                              canGoBack: _currentPageIndex > 0,
                              canGoNext: _canMoveNext,
                              onBack: _currentPageIndex > 0 ? _goBack : null,
                              onNext: _canMoveNext ? _goNext : null,
                            ),
                          ),
                          Positioned(
                            left: 22,
                            right: 22,
                            bottom: 20,
                            child: _InventoryStrip(inventory: _inventory),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goBack() {
    if (_currentPageIndex == 0) return;
    setState(() => _currentPageIndex -= 1);
  }

  void _goNext() {
    if (!_canMoveNext || _currentPageIndex >= _pages.length - 1) return;
    setState(() => _currentPageIndex += 1);
  }

  void _assemblePiece(_RoyalInventoryItem item) {
    if (!_inventory.contains(item)) return;
    setState(() {
      _assembledPieces.add(item);
      if (_assembledPieces.length == 3) {
        _inventory.add(_RoyalInventoryItem.completedCrown);
      }
    });
  }

  static List<_RoyalPage> _buildPages(List<_RoyalStage> stages) {
    final pages = <_RoyalPage>[];

    for (final stage in stages) {
      final shouldSplit = switch (stage.sceneType) {
        _RoyalSceneType.bedroom ||
        _RoyalSceneType.corridor ||
        _RoyalSceneType.kitchen => true,
        _RoyalSceneType.crownAssembly || _RoyalSceneType.balcony => false,
      };

      final descriptions = shouldSplit
          ? _splitNarrative(
              stage.description,
              maxChars: stage.title.trim().isEmpty ? 112 : 92,
            )
          : [stage.description];

      for (var index = 0; index < descriptions.length; index++) {
        pages.add(
          _RoyalPage(
            stage: stage,
            title: index == 0 ? stage.title : '',
            description: descriptions[index],
          ),
        );
      }
    }

    return pages;
  }

  static List<String> _splitNarrative(String text, {required int maxChars}) {
    final words = text.replaceAll('\n', ' \n ').trim().split(RegExp(r'\s+'));
    final pages = <String>[];
    var current = '';

    for (final word in words) {
      final token = word == r'\n' ? '\n' : word;
      final proposal = token == '\n'
          ? '$current\n'
          : current.isEmpty
          ? token
          : '$current $token';

      if (current.isNotEmpty && proposal.length > maxChars) {
        pages.add(current.trim());
        current = token == '\n' ? '' : token;
        continue;
      }

      if (token == '\n') {
        if (current.isNotEmpty && !current.endsWith('\n')) {
          current = '$current\n';
        }
      } else {
        current = current.isEmpty || current.endsWith('\n')
            ? '$current$token'
            : '$current $token';
      }
    }

    if (current.trim().isNotEmpty) {
      pages.add(current.trim());
    }

    return pages.isEmpty ? [text] : pages;
  }
}

class _RoyalSceneStage extends StatelessWidget {
  const _RoyalSceneStage({
    required this.stage,
    required this.inventory,
    required this.assembledPieces,
    required this.onAssemblePiece,
  });

  final _RoyalStage stage;
  final Set<_RoyalInventoryItem> inventory;
  final Set<_RoyalInventoryItem> assembledPieces;
  final ValueChanged<_RoyalInventoryItem> onAssemblePiece;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _OptimizedSceneImage(
            path: stage.imagePath,
            alignment: stage.imageAlignment,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.68, 1],
                colors: [
                  Color(0x05000000),
                  Color(0x00000000),
                  Color(0x99231947),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: switch (stage.sceneType) {
              _RoyalSceneType.bedroom => const SizedBox.shrink(),
              _RoyalSceneType.corridor => const SizedBox.shrink(),
              _RoyalSceneType.kitchen => const SizedBox.shrink(),
              _RoyalSceneType.crownAssembly => _CrownAssemblyScene(
                inventory: inventory,
                assembledPieces: assembledPieces,
                onAssemblePiece: onAssemblePiece,
              ),
              _RoyalSceneType.balcony => const _BalconyScene(),
            },
          ),
        ],
      ),
    );
  }
}

class _OptimizedSceneImage extends StatelessWidget {
  const _OptimizedSceneImage({required this.path, required this.alignment});

  final String path;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = MediaQuery.sizeOf(context).width;
    final cacheWidth = (width * dpr).round().clamp(720, 1600);

    return Image.asset(
      path,
      fit: BoxFit.cover,
      alignment: alignment,
      filterQuality: FilterQuality.low,
      cacheWidth: cacheWidth,
      isAntiAlias: false,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF231A45),
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported_rounded,
            color: Colors.white54,
            size: 44,
          ),
        );
      },
    );
  }
}

class _CrownAssemblyScene extends StatelessWidget {
  const _CrownAssemblyScene({
    required this.inventory,
    required this.assembledPieces,
    required this.onAssemblePiece,
  });

  final Set<_RoyalInventoryItem> inventory;
  final Set<_RoyalInventoryItem> assembledPieces;
  final ValueChanged<_RoyalInventoryItem> onAssemblePiece;

  @override
  Widget build(BuildContext context) {
    const pieceOrder = [
      _RoyalInventoryItem.pieceOne,
      _RoyalInventoryItem.pieceTwo,
      _RoyalInventoryItem.pieceThree,
    ];

    return Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.10),
          child: Container(
            width: 258,
            height: 178,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: const Color(0x40FFFFFF),
              border: Border.all(
                color: assembledPieces.length == 3
                    ? const Color(0xFFFFD36A)
                    : const Color(0xFF9B8BD4),
                width: 3,
              ),
              boxShadow: assembledPieces.length == 3
                  ? const [
                      BoxShadow(
                        color: Color(0x55FFD36A),
                        blurRadius: 26,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    size: 96,
                    color: Color(0x55FFE5A5),
                  ),
                ),
                Positioned(
                  left: 34,
                  top: 60,
                  child: _CrownPieceTarget(
                    item: _RoyalInventoryItem.pieceOne,
                    accepted: assembledPieces.contains(
                      _RoyalInventoryItem.pieceOne,
                    ),
                    onAccept: onAssemblePiece,
                  ),
                ),
                Positioned(
                  left: 104,
                  top: 28,
                  child: _CrownPieceTarget(
                    item: _RoyalInventoryItem.pieceTwo,
                    accepted: assembledPieces.contains(
                      _RoyalInventoryItem.pieceTwo,
                    ),
                    onAccept: onAssemblePiece,
                  ),
                ),
                Positioned(
                  right: 34,
                  top: 60,
                  child: _CrownPieceTarget(
                    item: _RoyalInventoryItem.pieceThree,
                    accepted: assembledPieces.contains(
                      _RoyalInventoryItem.pieceThree,
                    ),
                    onAccept: onAssemblePiece,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          bottom: 34,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            runSpacing: 14,
            children: [
              for (final item in pieceOrder)
                if (inventory.contains(item) && !assembledPieces.contains(item))
                  Draggable<_RoyalInventoryItem>(
                    data: item,
                    feedback: Material(
                      color: Colors.transparent,
                      child: _CrownPieceDraggable(item: item, small: true),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _CrownPieceDraggable(item: item),
                    ),
                    child: _CrownPieceDraggable(item: item),
                  ),
            ],
          ),
        ),
        if (assembledPieces.length == 3)
          const Positioned(
            left: 84,
            right: 84,
            top: 38,
            child: _SuccessPill(text: 'Basardik!'),
          ),
      ],
    );
  }
}

class _BalconyScene extends StatelessWidget {
  const _BalconyScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 16,
          right: 16,
          top: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _Balloon(color: Color(0xFFFF8CA8)),
              _Balloon(color: Color(0xFFFFD36A)),
              _Balloon(color: Color(0xFF89E1FF)),
              _Balloon(color: Color(0xFFB9FF99)),
            ],
          ),
        ),
        const Positioned(left: 48, right: 48, bottom: 28, child: _RewardCard()),
      ],
    );
  }
}

class _StoryPanel extends StatelessWidget {
  const _StoryPanel({
    required this.title,
    required this.description,
    required this.height,
    required this.canGoBack,
    required this.canGoNext,
    required this.onBack,
    required this.onNext,
  });

  final String title;
  final String description;
  final double height;
  final bool canGoBack;
  final bool canGoNext;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: _RoyalDayStoryScreenState._panelColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0xFFFFF4DB).withValues(alpha: 0.7),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33110B27),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title.trim().isNotEmpty) ...[
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF6D3AA0),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF6A5366),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 18,
          bottom: -22,
          child: _RoundActionButton(
            icon: Icons.arrow_back_rounded,
            onTap: canGoBack ? onBack : null,
          ),
        ),
        Positioned(
          right: 18,
          bottom: -22,
          child: _RoundActionButton(
            icon: Icons.arrow_forward_rounded,
            onTap: canGoNext ? onNext : null,
          ),
        ),
      ],
    );
  }
}

class _CrownPieceTarget extends StatelessWidget {
  const _CrownPieceTarget({
    required this.item,
    required this.accepted,
    required this.onAccept,
  });

  final _RoyalInventoryItem item;
  final bool accepted;
  final ValueChanged<_RoyalInventoryItem> onAccept;

  @override
  Widget build(BuildContext context) {
    return DragTarget<_RoyalInventoryItem>(
      onWillAcceptWithDetails: (details) => details.data == item,
      onAcceptWithDetails: (details) => onAccept(details.data),
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: accepted
                ? const Color(0xFFFFE39A)
                : candidateData.isNotEmpty
                ? const Color(0xFFFAD48E)
                : const Color(0x33FFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: accepted
                  ? const Color(0xFFE0B24F)
                  : const Color(0xFF9B8BD4),
              width: 2,
            ),
          ),
          child: accepted
              ? Icon(_inventoryIcon(item), color: const Color(0xFF8D5A18))
              : null,
        );
      },
    );
  }

  IconData _inventoryIcon(_RoyalInventoryItem value) {
    switch (value) {
      case _RoyalInventoryItem.pieceOne:
        return Icons.looks_one_rounded;
      case _RoyalInventoryItem.pieceTwo:
        return Icons.looks_two_rounded;
      case _RoyalInventoryItem.pieceThree:
        return Icons.looks_3_rounded;
      case _RoyalInventoryItem.completedCrown:
        return Icons.workspace_premium_rounded;
    }
  }
}

class _CrownPieceDraggable extends StatelessWidget {
  const _CrownPieceDraggable({required this.item, this.small = false});

  final _RoyalInventoryItem item;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: small ? 50 : 60,
      height: small ? 50 : 60,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE39A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0B24F), width: 2),
      ),
      child: Icon(_iconFor(item), color: const Color(0xFF8D5A18), size: 28),
    );
  }

  IconData _iconFor(_RoyalInventoryItem value) {
    switch (value) {
      case _RoyalInventoryItem.pieceOne:
        return Icons.looks_one_rounded;
      case _RoyalInventoryItem.pieceTwo:
        return Icons.looks_two_rounded;
      case _RoyalInventoryItem.pieceThree:
        return Icons.looks_3_rounded;
      case _RoyalInventoryItem.completedCrown:
        return Icons.workspace_premium_rounded;
    }
  }
}

class _Balloon extends StatelessWidget {
  const _Balloon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 36,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Container(width: 2, height: 32, color: Colors.white70),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: Color(0xFFFFC545),
            size: 30,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Yeni Rozet: Kraliyet Yardimcisi',
              style: TextStyle(
                color: Color(0xFF5A3477),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessPill extends StatelessWidget {
  const _SuccessPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF5A3477),
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TopProgress extends StatelessWidget {
  const _TopProgress({required this.currentIndex, required this.itemCount});

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minWidth: 104),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${currentIndex + 1}/$itemCount',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final button = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA14BDE), Color(0xFF6B2FA7)],
        ),
        border: Border.all(color: const Color(0xFFE9B652), width: 2.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4A140B2E),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 60,
            height: 60,
            child: Icon(icon, color: const Color(0xFFFFD86D), size: 33),
          ),
        ),
      ),
    );

    if (enabled) {
      return button;
    }

    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: button,
    );
  }
}

class _InventoryStrip extends StatelessWidget {
  const _InventoryStrip({required this.inventory});

  final Set<_RoyalInventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    final items = inventory.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final visibleWidth = constraints.maxWidth;
        final slotWidth = ((visibleWidth - (gap * 2)) / 3).clamp(58.0, 72.0);
        final slotHeight = (slotWidth * 0.92).clamp(54.0, 66.0);
        final iconSize = (slotWidth * 0.36).clamp(19.0, 26.0);
        final slotCount = items.length < 3 ? 3 : items.length;
        final totalWidth = (slotWidth * slotCount) + (gap * (slotCount - 1));
        final horizontalInset = ((visibleWidth - totalWidth) / 2).clamp(
          0.0,
          visibleWidth,
        );

        return SizedBox(
          height: slotHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalInset),
              child: Row(
                children: List.generate(slotCount, (index) {
                  final item = index < items.length ? items[index] : null;

                  return Container(
                    width: slotWidth,
                    height: slotHeight,
                    margin: EdgeInsets.only(
                      right: index == slotCount - 1 ? 0 : gap,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: item == null
                            ? [const Color(0x66AFA5E5), const Color(0x3D6F5DB1)]
                            : [
                                const Color(0x88C6B7FF),
                                const Color(0x665D4B9C),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: item == null
                            ? const Color(0x55E3D8FF)
                            : const Color(0x99FFF0C8),
                        width: 1.4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x220E0822),
                          blurRadius: 14,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: item == null
                          ? Container(
                              width: slotWidth * 0.28,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            )
                          : Icon(
                              _inventoryIcon(item),
                              size: iconSize,
                              color: const Color(0xFFFFD36A),
                            ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _inventoryIcon(_RoyalInventoryItem item) {
    switch (item) {
      case _RoyalInventoryItem.pieceOne:
        return Icons.looks_one_rounded;
      case _RoyalInventoryItem.pieceTwo:
        return Icons.looks_two_rounded;
      case _RoyalInventoryItem.pieceThree:
        return Icons.looks_3_rounded;
      case _RoyalInventoryItem.completedCrown:
        return Icons.workspace_premium_rounded;
    }
  }
}

class _RoyalStage {
  const _RoyalStage({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.imageAlignment,
    required this.sceneType,
  });

  final String title;
  final String description;
  final String imagePath;
  final Alignment imageAlignment;
  final _RoyalSceneType sceneType;
}

class _RoyalPage {
  const _RoyalPage({
    required this.stage,
    required this.title,
    required this.description,
  });

  final _RoyalStage stage;
  final String title;
  final String description;

  _RoyalSceneType get sceneType => stage.sceneType;
}

enum _RoyalSceneType { bedroom, corridor, kitchen, crownAssembly, balcony }

enum _RoyalInventoryItem { pieceOne, pieceTwo, pieceThree, completedCrown }
