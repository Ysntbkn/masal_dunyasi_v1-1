import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrincessRescueGameScreen extends StatefulWidget {
  const PrincessRescueGameScreen({super.key});

  @override
  State<PrincessRescueGameScreen> createState() =>
      _PrincessRescueGameScreenState();
}

class _PrincessRescueGameScreenState extends State<PrincessRescueGameScreen> {
  static const _pageColor = Color(0xFF2F255E);
  static const _panelColor = Color(0xFFF4E0C5);

  static const _stages = [
    _GameStage(
      title: 'Zindan Kapisi',
      description:
          'Kapinin acilmasi icin anahtari bul. Parlayan anahtara dokun, sonra ileri oka bas.',
      sceneType: _SceneType.dungeonDoor,
      slotItem: _InventoryItem.key,
    ),
    _GameStage(
      title: 'Karanlik Koridor',
      description:
          'Koridor cok karanlik. Mesaleyi yak ve yolu aydinlat. Sonra ileri gidebilirsin.',
      sceneType: _SceneType.corridor,
      slotItem: _InventoryItem.torch,
    ),
    _GameStage(
      title: 'Ejderha Odasi',
      description:
          'Ejderha altin anahtari koruyor. Korkutmak icin ses butonuna dokun ve yolu ac.',
      sceneType: _SceneType.dragon,
      slotItem: _InventoryItem.goldenKey,
    ),
    _GameStage(
      title: 'Prensesin Kilidi',
      description:
          'Altin anahtar artik sende. Kapiya dokun ve prensesi kurtarmak icin son adimi tamamla.',
      sceneType: _SceneType.princessDoor,
      slotItem: _InventoryItem.crown,
    ),
    _GameStage(
      title: 'Mutlu Son',
      description:
          'Harika! Prenses kurtuldu. Macera tamamlandi, dilersen geri donup tekrar oynayabilirsin.',
      sceneType: _SceneType.celebration,
    ),
  ];

  int _currentStageIndex = 0;
  bool _soundEnabled = true;
  final Set<_InventoryItem> _inventory = <_InventoryItem>{};

  _GameStage get _currentStage => _stages[_currentStageIndex];

  bool get _canMoveNext {
    if (_currentStageIndex >= _stages.length - 1) return false;
    final requiredItem = _currentStage.slotItem;
    if (requiredItem == null) return true;
    return _inventory.contains(requiredItem);
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
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                child: Row(
                  children: [
                    _RoundActionButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    Expanded(
                      child: _TopProgress(
                        currentIndex: _currentStageIndex,
                        itemCount: _stages.length,
                      ),
                    ),
                    _RoundActionButton(
                      icon: _soundEnabled
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      onTap: _toggleSound,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _SceneStage(
                          stage: _currentStage,
                          inventory: _inventory,
                          onInteract: _handleSceneInteraction,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 150,
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  20,
                                  20,
                                  28,
                                ),
                                decoration: BoxDecoration(
                                  color: _panelColor,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentStage.title,
                                      style: const TextStyle(
                                        color: Color(0xFF5A3477),
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _currentStage.description,
                                      style: const TextStyle(
                                        color: Color(0xFF5F514A),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 12,
                                bottom: -32,
                                child: _RoundActionButton(
                                  icon: Icons.arrow_back_rounded,
                                  onTap: _currentStageIndex > 0
                                      ? _goBack
                                      : null,
                                ),
                              ),
                              Positioned(
                                right: 12,
                                bottom: -32,
                                child: _RoundActionButton(
                                  icon: Icons.arrow_forward_rounded,
                                  onTap: _canMoveNext ? _goNext : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          _InventorySlots(inventory: _inventory),
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
    );
  }

  void _toggleSound() {
    setState(() => _soundEnabled = !_soundEnabled);
  }

  void _goBack() {
    if (_currentStageIndex == 0) return;
    setState(() => _currentStageIndex -= 1);
  }

  void _goNext() {
    if (!_canMoveNext) return;
    setState(() => _currentStageIndex += 1);
  }

  void _handleSceneInteraction(_InventoryItem item) {
    if (_inventory.contains(item)) return;
    setState(() => _inventory.add(item));
  }
}

class _TopProgress extends StatelessWidget {
  const _TopProgress({required this.currentIndex, required this.itemCount});

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${currentIndex + 1}/$itemCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var index = 0; index < itemCount; index++) ...[
              if (index > 0)
                Container(width: 30, height: 4, color: const Color(0xFF6B5698)),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: index <= currentIndex
                      ? const Color(0xFFFFC545)
                      : const Color(0xFF6B5698),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ],
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

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8C43C8), Color(0xFF5F2C92)],
          ),
          border: Border.all(color: const Color(0xFFE2A33D), width: 2.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(icon, color: const Color(0xFFFFD36B), size: 32),
            ),
          ),
        ),
      ),
    );
  }
}

class _SceneStage extends StatelessWidget {
  const _SceneStage({
    required this.stage,
    required this.inventory,
    required this.onInteract,
  });

  final _GameStage stage;
  final Set<_InventoryItem> inventory;
  final ValueChanged<_InventoryItem> onInteract;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E153B), Color(0xFF140F26), Color(0xFF281B49)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: _StoneWallPattern()),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.08),
                    Colors.black.withValues(alpha: 0.22),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 124,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF493225).withValues(alpha: 0.10),
                    const Color(0xFF5F3C29).withValues(alpha: 0.48),
                    const Color(0xFF684129).withValues(alpha: 0.76),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 128,
            child: _TorchGlow(alignment: Alignment.centerLeft),
          ),
          Positioned(
            right: 24,
            top: 128,
            child: _TorchGlow(alignment: Alignment.centerRight),
          ),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(14, 28, 14, 14),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 340,
                      height: 470,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 8,
                            top: 92,
                            child: _TorchGlow(alignment: Alignment.centerLeft),
                          ),
                          Positioned(
                            right: 8,
                            top: 92,
                            child: _TorchGlow(alignment: Alignment.centerRight),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                16,
                                18,
                                18,
                              ),
                              child: _SceneContent(
                                stage: stage,
                                inventory: inventory,
                                onInteract: onInteract,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneContent extends StatelessWidget {
  const _SceneContent({
    required this.stage,
    required this.inventory,
    required this.onInteract,
  });

  final _GameStage stage;
  final Set<_InventoryItem> inventory;
  final ValueChanged<_InventoryItem> onInteract;

  @override
  Widget build(BuildContext context) {
    switch (stage.sceneType) {
      case _SceneType.dungeonDoor:
        return _DungeonDoorScene(
          unlocked: inventory.contains(_InventoryItem.key),
          onKeyTap: () => onInteract(_InventoryItem.key),
        );
      case _SceneType.corridor:
        return _CorridorScene(
          lit: inventory.contains(_InventoryItem.torch),
          onTorchTap: () => onInteract(_InventoryItem.torch),
        );
      case _SceneType.dragon:
        return _DragonScene(
          dragonGone: inventory.contains(_InventoryItem.goldenKey),
          onShoutTap: () => onInteract(_InventoryItem.goldenKey),
        );
      case _SceneType.princessDoor:
        return _PrincessDoorScene(
          open: inventory.contains(_InventoryItem.crown),
          onDoorTap: () => onInteract(_InventoryItem.crown),
        );
      case _SceneType.celebration:
        return const _CelebrationScene();
    }
  }
}

class _DungeonDoorScene extends StatelessWidget {
  const _DungeonDoorScene({required this.unlocked, required this.onKeyTap});

  final bool unlocked;
  final VoidCallback onKeyTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: _DoorFrame(
            lockOpen: unlocked,
            title: unlocked ? 'Kilit Acildi' : 'Buyuk Kapi',
          ),
        ),
        if (!unlocked)
          Positioned(
            left: 24,
            bottom: 30,
            child: _SceneCollectible(icon: Icons.key_rounded, onTap: onKeyTap),
          ),
      ],
    );
  }
}

class _CorridorScene extends StatelessWidget {
  const _CorridorScene({required this.lit, required this.onTorchTap});

  final bool lit;
  final VoidCallback onTorchTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 240,
            height: 340,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: lit
                    ? [
                        const Color(0xFF525D7C),
                        const Color(0xFF2F344D),
                        const Color(0xFF1A1C28),
                      ]
                    : [
                        const Color(0xFF242138),
                        const Color(0xFF181522),
                        const Color(0xFF0E0C14),
                      ],
              ),
              border: Border.all(
                color: lit ? const Color(0xFFFFC54E) : const Color(0xFF3F355A),
                width: 3,
              ),
            ),
            child: Center(
              child: Icon(
                lit ? Icons.wb_incandescent_rounded : Icons.dark_mode_rounded,
                size: 92,
                color: lit ? const Color(0xFFFFD978) : const Color(0xFF7A7297),
              ),
            ),
          ),
        ),
        if (!lit)
          Positioned(
            right: 20,
            bottom: 58,
            child: _SceneCollectible(
              icon: Icons.local_fire_department_rounded,
              onTap: onTorchTap,
            ),
          ),
      ],
    );
  }
}

class _DragonScene extends StatelessWidget {
  const _DragonScene({required this.dragonGone, required this.onShoutTap});

  final bool dragonGone;
  final VoidCallback onShoutTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 250,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: dragonGone
                    ? [const Color(0xFF2F4058), const Color(0xFF1C2536)]
                    : [const Color(0xFF5B2636), const Color(0xFF2C1320)],
              ),
              border: Border.all(
                color: dragonGone
                    ? const Color(0xFF8CA5C7)
                    : const Color(0xFFB55A46),
                width: 3,
              ),
            ),
            child: Center(
              child: Icon(
                dragonGone
                    ? Icons.vpn_key_rounded
                    : Icons.local_fire_department_rounded,
                size: 110,
                color: dragonGone
                    ? const Color(0xFFFFD36A)
                    : const Color(0xFFFF8B5E),
              ),
            ),
          ),
        ),
        if (!dragonGone)
          Positioned(
            left: 0,
            right: 0,
            bottom: 28,
            child: Center(
              child: FilledButton.icon(
                onPressed: onShoutTap,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF8A3FD1),
                  foregroundColor: const Color(0xFFFFE083),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFFE0B24F), width: 2),
                  ),
                ),
                icon: const Icon(Icons.record_voice_over_rounded),
                label: const Text(
                  'Ses Cikar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PrincessDoorScene extends StatelessWidget {
  const _PrincessDoorScene({required this.open, required this.onDoorTap});

  final bool open;
  final VoidCallback onDoorTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: onDoorTap,
            child: _DoorFrame(
              lockOpen: open,
              title: open ? 'Prenses Kurtuldu' : 'Son Kapi',
            ),
          ),
        ),
        if (open)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: Icon(
                Icons.emoji_events_rounded,
                size: 72,
                color: Color(0xFFFFD36A),
              ),
            ),
          ),
      ],
    );
  }
}

class _CelebrationScene extends StatelessWidget {
  const _CelebrationScene();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 260,
        height: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B3A88), Color(0xFF30204D)],
          ),
          border: Border.all(color: Color(0xFFE0B24F), width: 3),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.celebration_rounded, size: 96, color: Color(0xFFFFD36A)),
            SizedBox(height: 14),
            Text(
              'Masal Tamamlandi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoorFrame extends StatelessWidget {
  const _DoorFrame({required this.lockOpen, required this.title});

  final bool lockOpen;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 390,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 250,
            height: 360,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(120),
              border: Border.all(color: const Color(0xFF5B463F), width: 18),
            ),
          ),
          Container(
            width: 210,
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF3E271F),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1A161C), width: 6),
            ),
            child: Stack(
              children: [
                for (var index = 0; index < 4; index++)
                  Positioned(
                    left: 20 + (index * 44),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 8,
                      color: const Color(0xFF1E1A1D).withValues(alpha: 0.72),
                    ),
                  ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 80,
                  child: Container(height: 8, color: const Color(0xFF19161A)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 88,
                  child: Container(height: 8, color: const Color(0xFF19161A)),
                ),
              ],
            ),
          ),
          Positioned(
            top: 114,
            child: Container(
              width: 74,
              height: 86,
              decoration: BoxDecoration(
                color: const Color(0xFF70533F),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A1F1A), width: 3),
              ),
              child: Icon(
                lockOpen ? Icons.lock_open_rounded : Icons.lock_rounded,
                size: 42,
                color: const Color(0xFFFFBE5A),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFFD36A),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneCollectible extends StatelessWidget {
  const _SceneCollectible({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFFE3A7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0B24F), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66FFC24B),
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF9A582A), size: 30),
      ),
    );
  }
}

class _TorchGlow extends StatelessWidget {
  const _TorchGlow({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 140,
      child: Stack(
        alignment: alignment,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFB347).withValues(alpha: 0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Icon(
              Icons.local_fire_department_rounded,
              size: 44,
              color: const Color(0xFFFFA43A),
            ),
          ),
          Positioned(
            top: 42,
            child: Container(
              width: 16,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF38231F),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventorySlots extends StatelessWidget {
  const _InventorySlots({required this.inventory});

  final Set<_InventoryItem> inventory;

  @override
  Widget build(BuildContext context) {
    final items = inventory.toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final visibleWidth = constraints.maxWidth;
        final slotWidth = ((visibleWidth - (gap * 2)) / 3).clamp(64.0, 78.0);
        final slotHeight = (slotWidth * 0.84).clamp(54.0, 66.0);
        final iconSize = (slotWidth * 0.34).clamp(20.0, 28.0);
        final slotCount = items.length < 3 ? 3 : items.length;

        return SizedBox(
          height: slotHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
                    color: const Color(0xFF4B3A7F),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: item == null
                      ? null
                      : Icon(
                          _inventoryIcon(item),
                          size: iconSize,
                          color: const Color(0xFFFFD36A),
                        ),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  IconData _inventoryIcon(_InventoryItem item) {
    switch (item) {
      case _InventoryItem.key:
        return Icons.key_rounded;
      case _InventoryItem.torch:
        return Icons.local_fire_department_rounded;
      case _InventoryItem.goldenKey:
        return Icons.vpn_key_rounded;
      case _InventoryItem.crown:
        return Icons.workspace_premium_rounded;
    }
  }
}

class _StoneWallPattern extends StatelessWidget {
  const _StoneWallPattern();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const blockW = 56.0;
        const blockH = 44.0;
        final columns = (constraints.maxWidth / blockW).ceil();
        final rows = (constraints.maxHeight / blockH).ceil();

        return Column(
          children: List.generate(rows, (row) {
            return Row(
              children: List.generate(columns, (column) {
                final shifted = row.isOdd ? blockW / 2 : 0.0;

                return Transform.translate(
                  offset: Offset(column == 0 ? shifted : 0, 0),
                  child: Container(
                    width: blockW,
                    height: blockH,
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        const Color(0xFF2D223F),
                        const Color(0xFF1A1428),
                        ((row + column) % 3) / 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }),
            );
          }),
        );
      },
    );
  }
}

class _GameStage {
  const _GameStage({
    required this.title,
    required this.description,
    required this.sceneType,
    this.slotItem,
  });

  final String title;
  final String description;
  final _SceneType sceneType;
  final _InventoryItem? slotItem;
}

enum _SceneType { dungeonDoor, corridor, dragon, princessDoor, celebration }

enum _InventoryItem { key, torch, goldenKey, crown }
