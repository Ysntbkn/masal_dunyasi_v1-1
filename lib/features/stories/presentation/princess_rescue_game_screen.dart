import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'story_screen_shared.dart';

class PrincessRescueGameScreen extends StatefulWidget {
  const PrincessRescueGameScreen({super.key});

  @override
  State<PrincessRescueGameScreen> createState() =>
      _PrincessRescueGameScreenState();
}

class _PrincessRescueGameScreenState extends State<PrincessRescueGameScreen> {
  int step = 0;
  List<String> inventory = <String>[];
  bool corridorLit = false;
  bool dragonEscaped = false;
  bool swordTried = false;

  late final List<List<Color>> _sceneGradients;

  @override
  void initState() {
    super.initState();
    final random = Random();
    const palettes = <List<Color>>[
      [Color(0xFF1E2148), Color(0xFF593B86), Color(0xFFE78F6A)],
      [Color(0xFF16213E), Color(0xFF0F3460), Color(0xFF5C7AEA)],
      [Color(0xFF2D1E2F), Color(0xFF684756), Color(0xFFF0A070)],
      [Color(0xFF1B2838), Color(0xFF355C7D), Color(0xFFF8B195)],
      [Color(0xFF2B193D), Color(0xFF6A2C70), Color(0xFFF08A5D)],
    ];
    _sceneGradients = List<List<Color>>.generate(
      4,
      (_) => palettes[random.nextInt(palettes.length)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visualStep = step > 3 ? 3 : step;
    final sceneGradient = _sceneGradients[visualStep];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: sceneGradient.last,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: sceneGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                  child: Row(
                    children: [
                      StoryBackIconButton(
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Text(
                          'Gorev ${_stepLabel()}',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Prensesi Zindandan Kurtar',
                    textAlign: TextAlign.center,
                    style: storyTitleStyle(
                      fontSize: 30,
                      color: const Color(0xFFFFF6E7),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: Container(
                      key: ValueKey<String>(_messageForCurrentStep()),
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFE3A7),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFF9A582A),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _messageForCurrentStep(),
                              style: const TextStyle(
                                color: Color(0xFF44334E),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.14),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(child: _buildSceneBackground()),
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.02),
                                    Colors.black.withValues(alpha: 0.10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(child: _buildSceneActors()),
                        ],
                      ),
                    ),
                  ),
                ),
                if (step == 2 && swordTried && !dragonEscaped)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _scareDragon,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A66),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        icon: const Icon(Icons.record_voice_over_rounded),
                        label: const Text(
                          'Ciglik At!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                  child: _buildInventoryBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSceneBackground() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            left: -20,
            top: 28,
            child: _ambientOrb(size: 110, color: const Color(0x66FFF5C3)),
          ),
          Positioned(
            right: -14,
            top: 90,
            child: _ambientOrb(size: 90, color: const Color(0x4D9CE5FF)),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneActors() {
    if (step == 0) {
      return _buildDungeonDoorScene();
    }
    if (step == 1) {
      return _buildCorridorScene();
    }
    if (step == 2) {
      return _buildDragonScene();
    }
    return _buildPrincessDoorScene();
  }

  Widget _buildDungeonDoorScene() {
    // Background asset later: asset/games/dungeon_door_closed.webp
    // Key asset later: asset/games/key.webp
    final hasKey = inventory.contains('key');

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 72,
          child: Center(
            child: GestureDetector(
              onTap: _tryOpenDungeonDoor,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 190,
                height: 250,
                decoration: BoxDecoration(
                  color: hasKey
                      ? const Color(0xFF8C5B6D)
                      : const Color(0xFF4E375F),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: hasKey
                        ? const Color(0xFFFFD36E)
                        : Colors.white.withValues(alpha: 0.18),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: hasKey
                          ? const Color(0x66FFD36E)
                          : Colors.black.withValues(alpha: 0.20),
                      blurRadius: hasKey ? 28 : 18,
                      spreadRadius: hasKey ? 3 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      hasKey ? Icons.lock_open_rounded : Icons.lock_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Zindan Kapisi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (!hasKey)
          Positioned(
            left: 42,
            bottom: 70,
            child: _glowingObject(
              icon: Icons.key_rounded,
              label: 'Anahtar',
              color: const Color(0xFFFFD45E),
              onTap: _collectDungeonKey,
            ),
          ),
      ],
    );
  }

  Widget _buildCorridorScene() {
    // Background asset later: asset/games/dark_corridor.webp
    // Lit background later: asset/games/lit_corridor.webp
    // Torch asset later: asset/games/torch.webp
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 240),
          left: corridorLit ? 36 : 14,
          right: corridorLit ? 36 : 14,
          top: corridorLit ? 70 : 84,
          bottom: 52,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            decoration: BoxDecoration(
              color: corridorLit
                  ? const Color(0xFF5D6F89).withValues(alpha: 0.72)
                  : const Color(0xFF111724).withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: corridorLit
                    ? const Color(0xFFFFD36E)
                    : Colors.white.withValues(alpha: 0.10),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: corridorLit
                      ? const Color(0x55FFD36E)
                      : Colors.black.withValues(alpha: 0.18),
                  blurRadius: 28,
                  spreadRadius: corridorLit ? 4 : 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                corridorLit
                    ? Icons.wb_incandescent_rounded
                    : Icons.nights_stay_rounded,
                size: 92,
                color: corridorLit
                    ? const Color(0xFFFFE184)
                    : Colors.white.withValues(alpha: 0.70),
              ),
            ),
          ),
        ),
        Positioned(
          right: 40,
          bottom: 78,
          child: _glowingObject(
            icon: Icons.local_fire_department_rounded,
            label: corridorLit ? 'Mesale Yandi' : 'Mesale',
            color: const Color(0xFFFF8D53),
            onTap: corridorLit ? null : _lightCorridor,
          ),
        ),
      ],
    );
  }

  Widget _buildDragonScene() {
    // Background asset later: asset/games/dragon_room.webp
    // Dragon asset later: asset/games/dragon.webp
    // Sword asset later: asset/games/sword.webp
    // Golden key asset later: asset/games/golden_key.webp
    final hasSword = inventory.contains('sword');
    final hasGoldenKey = inventory.contains('golden_key');

    return Stack(
      children: [
        Positioned(
          right: 26,
          top: 58,
          child: DragTarget<String>(
            onWillAcceptWithDetails: (details) =>
                details.data == 'sword' && !dragonEscaped,
            onAcceptWithDetails: (details) {
              if (details.data == 'sword') {
                _trySwordOnDragon();
              }
            },
            builder: (context, candidateData, rejectedData) {
              final isHovering = candidateData.isNotEmpty;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: dragonEscaped ? 0 : 1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: isHovering
                        ? const Color(0xFFB84A4A)
                        : const Color(0xFF7A3441),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: isHovering
                          ? const Color(0xFFFFE184)
                          : Colors.white.withValues(alpha: 0.16),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x66FF8761),
                        blurRadius: isHovering ? 30 : 20,
                        spreadRadius: isHovering ? 5 : 0,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 72,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Ejderha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (!hasSword)
          Positioned(
            left: 30,
            bottom: 64,
            child: _glowingObject(
              icon: Icons.gavel_rounded,
              label: 'Kilic',
              color: const Color(0xFFCAE7FF),
              onTap: _collectSword,
            ),
          ),
        if (dragonEscaped && !hasGoldenKey)
          Positioned(
            right: 58,
            bottom: 78,
            child: _glowingObject(
              icon: Icons.key_rounded,
              label: 'Altin Anahtar',
              color: const Color(0xFFFFD45E),
              onTap: _collectGoldenKey,
            ),
          ),
        if (hasSword)
          Positioned(
            left: 18,
            top: 42,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Kilici ejderhaya surukle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPrincessDoorScene() {
    // Closed background asset later: asset/games/princess_door_closed.webp
    // Open background asset later: asset/games/princess_door_open.webp
    // Princess asset later: asset/games/princess_happy.webp
    final hasGoldenKey = inventory.contains('golden_key');
    final princessFreed = step >= 4;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 66,
          child: Center(
            child: GestureDetector(
              onTap: hasGoldenKey ? _openPrincessDoor : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 210,
                height: 250,
                decoration: BoxDecoration(
                  color: princessFreed
                      ? const Color(0xFF5A8B72)
                      : const Color(0xFF465071),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: hasGoldenKey
                        ? const Color(0xFFFFD36E)
                        : Colors.white.withValues(alpha: 0.18),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: hasGoldenKey
                          ? const Color(0x55FFD36E)
                          : Colors.black.withValues(alpha: 0.18),
                      blurRadius: 28,
                      spreadRadius: hasGoldenKey ? 3 : 0,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      princessFreed
                          ? Icons.door_sliding_rounded
                          : Icons.lock_rounded,
                      color: Colors.white,
                      size: 68,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      princessFreed ? 'Kapi Acildi' : 'Prensesin Kapisi',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (princessFreed)
          Positioned(
            left: 0,
            right: 0,
            bottom: 56,
            child: Column(
              children: const [
                Icon(Icons.face_3_rounded, size: 88, color: Color(0xFFFFF2C6)),
                SizedBox(height: 8),
                Text(
                  'Prenses mutlu!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          )
        else if (!hasGoldenKey)
          Positioned(
            left: 22,
            right: 22,
            bottom: 56,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Bu kapiyi acmak icin altin anahtar lazim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInventoryBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.backpack_rounded, color: Color(0xFF9A582A)),
              SizedBox(width: 8),
              Text(
                'Envanter',
                style: TextStyle(
                  color: Color(0xFF9A582A),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (inventory.isEmpty)
            const Text(
              'Henuz esya toplanmadi.',
              style: TextStyle(
                color: Color(0xFF65546E),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: inventory.map(_buildInventoryItem).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(String item) {
    final isSword = item == 'sword';
    final itemColor = _inventoryColor(item);
    final itemWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: itemColor.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: itemColor.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_inventoryIcon(item), color: itemColor),
          const SizedBox(width: 8),
          Text(
            _inventoryLabel(item),
            style: TextStyle(
              color: itemColor,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (!isSword) {
      return itemWidget;
    }

    return Draggable<String>(
      data: 'sword',
      feedback: Material(color: Colors.transparent, child: itemWidget),
      childWhenDragging: Opacity(opacity: 0.35, child: itemWidget),
      child: itemWidget,
    );
  }

  Widget _ambientOrb({required double size, required Color color}) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      ),
    );
  }

  Widget _glowingObject({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.94, end: 1.04),
        duration: const Duration(milliseconds: 1050),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.55),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4A3957),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _collectDungeonKey() {
    if (inventory.contains('key')) return;
    setState(() {
      inventory = <String>[...inventory, 'key'];
    });
  }

  void _tryOpenDungeonDoor() {
    if (!inventory.contains('key')) {
      setState(() {});
      return;
    }
    setState(() {
      step = 1;
    });
  }

  Future<void> _lightCorridor() async {
    if (corridorLit) return;
    setState(() {
      corridorLit = true;
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      step = 2;
    });
  }

  void _collectSword() {
    if (inventory.contains('sword')) return;
    setState(() {
      inventory = <String>[...inventory, 'sword'];
    });
  }

  void _trySwordOnDragon() {
    if (!inventory.contains('sword') || dragonEscaped) return;
    setState(() {
      swordTried = true;
    });
  }

  void _scareDragon() {
    if (dragonEscaped) return;
    setState(() {
      dragonEscaped = true;
    });
  }

  void _collectGoldenKey() {
    if (inventory.contains('golden_key')) return;
    setState(() {
      inventory = <String>[...inventory, 'golden_key'];
      step = 3;
    });
  }

  void _openPrincessDoor() {
    if (!inventory.contains('golden_key')) return;
    setState(() {
      step = 4;
    });
  }

  String _messageForCurrentStep() {
    if (step == 0) {
      return inventory.contains('key')
          ? 'Anahtari buldun! Simdi kapiya dokun ve zindani ac.'
          : 'Anahtari bul ve kapiyi ac.';
    }
    if (step == 1) {
      return corridorLit
          ? 'Harika! Yol aydinlandi, birazdan ilerliyoruz.'
          : 'Mesaleyi yak, yolu aydinlat.';
    }
    if (step == 2) {
      if (!inventory.contains('sword')) {
        return 'Kilici al ve ejderhaya karsi dene.';
      }
      if (!swordTried) {
        return 'Kilici ejderhaya surukle.';
      }
      if (!dragonEscaped) {
        return 'Kilic ise yaramadi! Ejderhayi korkutmak icin yuksek sesle bagir!';
      }
      if (!inventory.contains('golden_key')) {
        return 'Ejderha kacti! Altin anahtari al.';
      }
    }
    if (step == 3) {
      return 'Altin anahtar sende. Kapiya dokun ve prensesi kurtar.';
    }
    return 'Harika! Prenses artik ozgur!';
  }

  String _stepLabel() {
    if (step <= 0) return '1/4';
    if (step == 1) return '2/4';
    if (step == 2) return '3/4';
    return '4/4';
  }

  IconData _inventoryIcon(String item) {
    switch (item) {
      case 'key':
        return Icons.key_rounded;
      case 'sword':
        return Icons.gavel_rounded;
      case 'golden_key':
        return Icons.vpn_key_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Color _inventoryColor(String item) {
    switch (item) {
      case 'key':
        return const Color(0xFFE3A82A);
      case 'sword':
        return const Color(0xFF4A86C5);
      case 'golden_key':
        return const Color(0xFFF28E2B);
      default:
        return const Color(0xFF7F63B8);
    }
  }

  String _inventoryLabel(String item) {
    switch (item) {
      case 'key':
        return 'Anahtar';
      case 'sword':
        return 'Kilic';
      case 'golden_key':
        return 'Altin Anahtar';
      default:
        return item;
    }
  }
}
