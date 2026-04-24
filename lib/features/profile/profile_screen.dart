import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/navigation/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_back_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _backgroundImage =
      'asset/profil page/profile_background_optimized.jpg';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final avatar = _ProfileAvatarStyle.fromId(state.avatar);
    final name = state.userName.trim().isEmpty ? 'Demet' : state.userName;
    final email = '${name.trim().toLowerCase()}@gmail.com';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: const Color(0xFFFF8A68),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFF8A68),
        body: Stack(
          children: [
            const _ProfileBackground(),
            SafeArea(
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                    sliver: SliverList.list(
                      children: [
                        _ProfileTopBar(
                          onBack: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.home);
                            }
                          },
                          onSettings: () => context.push(AppRoutes.settings),
                        ),
                        const SizedBox(height: 30),
                        _ProfileCard(
                          avatar: avatar,
                          name: name,
                          email: email,
                          isPremium: state.isPremium,
                          onEdit: () => _showEditProfileSheet(context, state),
                        ),
                        const SizedBox(height: 40),
                        _PremiumButton(
                          onTap: () => context.push(AppRoutes.premium),
                        ),
                        const SizedBox(height: 42),
                        const _StatsRow(),
                        const SizedBox(height: 38),
                        const Text(
                          'Okuma Hedefleri',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const _GoalCard(
                          iconPath: 'asset/icons/gunluk hedef.webp',
                          title: 'Günlük Hedef',
                          progress: 0.58,
                        ),
                        const SizedBox(height: 20),
                        const _GoalCard(
                          iconPath: 'asset/icons/aylık hedef.webp',
                          title: 'Aylık Hedef',
                          progress: 0.58,
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditProfileSheet(BuildContext context, AppState state) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return ChangeNotifierProvider.value(
          value: state,
          child: const _EditProfileSheet(),
        );
      },
    );
  }
}

class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: -22,
          left: -20,
          right: -20,
          height: 510,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
            child: Image.asset(
              ProfileScreen._backgroundImage,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF41A7E6).withValues(alpha: 0.42),
                Colors.white.withValues(alpha: 0.06),
                const Color(0xFFFFA06F).withValues(alpha: 0.92),
                const Color(0xFFFF7D5D),
              ],
              stops: const [0, 0.34, 0.54, 1],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar({required this.onBack, required this.onSettings});

  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return AppHeaderBar(
      onBack: onBack,
      horizontalPadding: 0,
      title: 'PROFİLİM',
      titleStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'BreadMateTR',
        fontSize: 43,
        height: 0.92,
        letterSpacing: 0,
      ),
      trailing: _SettingsButton(onTap: onSettings),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFA5471B),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.settings_rounded, color: Colors.white, size: 25),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.avatar,
    required this.name,
    required this.email,
    required this.isPremium,
    required this.onEdit,
  });

  final _ProfileAvatarStyle avatar;
  final String name;
  final String email;
  final bool isPremium;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatar.backgroundColor,
                  border: Border.all(color: AppColors.cinnamon, width: 6),
                ),
                child: Icon(avatar.icon, color: Colors.white, size: 72),
              ),
              Positioned(
                right: -4,
                top: 14,
                child: Material(
                  color: const Color(0xFFE5E5E5),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onEdit,
                    customBorder: const CircleBorder(),
                    child: const SizedBox(
                      width: 42,
                      height: 42,
                      child: Icon(
                        Icons.edit_rounded,
                        color: Colors.black,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.cinnamon,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF9D9D9D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
          ),
          if (isPremium) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD47C),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Premium Hesap',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.cinnamon,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF33D0), Color(0xFFFF6A3A)],
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: const Center(
              child: Text(
                'Premium Ol',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            iconPath: 'asset/icons/okunan.webp',
            value: '3',
            label: 'Okunan',
          ),
        ),
        SizedBox(width: 28),
        Expanded(
          child: _StatCard(
            iconPath: 'asset/icons/favoriler.webp',
            value: '3',
            label: 'Favoriler',
          ),
        ),
        SizedBox(width: 28),
        Expanded(
          child: _StatCard(
            iconPath: 'asset/icons/rozet.webp',
            value: '3',
            label: 'Rozet',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.iconPath,
    required this.value,
    required this.label,
  });

  final String iconPath;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -20,
            child: Image.asset(
              iconPath,
              width: 80,
              height: 66,
              fit: BoxFit.contain,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.cinnamon,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.iconPath,
    required this.title,
    required this.progress,
  });

  final String iconPath;
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      padding: const EdgeInsets.fromLTRB(26, 24, 32, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: Image.asset(iconPath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF696969),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Bugünkü okuma süresi',
                  style: TextStyle(
                    color: Color(0xFF8A8A8A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '10/30 dk',
                  style: TextStyle(
                    color: Color(0xFF5A5A5A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE5E5E5),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFC74A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  late String _selectedAvatar;
  int _step = 0;

  static const _avatars = [
    _AvatarOption('prenses', Color(0xFFF4B46F), Icons.face_4_rounded),
    _AvatarOption('kirmizi-baslik', Color(0xFF9ED6C0), Icons.face_3_rounded),
    _AvatarOption('buyucu', Color(0xFF7B789E), Icons.face_6_rounded),
    _AvatarOption('gezgin', Color(0xFFF0C07A), Icons.face_2_rounded),
    _AvatarOption('dedektif', Color(0xFFB6D79F), Icons.face_rounded),
    _AvatarOption('denizci', Color(0xFF86CFC7), Icons.face_retouching_natural),
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _nameController = TextEditingController(
      text: state.userName.trim().isEmpty ? 'Demet' : state.userName,
    );
    _selectedAvatar = state.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF6EE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 54,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9C9BB),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _step == 0 ? 'Adını Düzenle' : 'Avatarını Seç',
                  style: const TextStyle(
                    color: AppColors.cinnamon,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _step == 0
                      ? 'Önce profil adını güncelleyelim.'
                      : 'Şimdi profil avatarını seçebilirsin.',
                  style: const TextStyle(
                    color: Color(0xFF7E6F62),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 22),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: _step == 0 ? _buildNameStep() : _buildAvatarStep(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (_step == 1) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _step = 0),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            side: const BorderSide(color: AppColors.cinnamon),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Geri'),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: FilledButton(
                        onPressed: _handlePrimaryAction,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.cinnamon,
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(_step == 0 ? 'Devam Et' : 'Kaydet'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return Column(
      key: const ValueKey('name-step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profil Adı',
          style: TextStyle(
            color: Color(0xFF6D5B4D),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Adını yaz',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarStep() {
    return Column(
      key: const ValueKey('avatar-step'),
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              for (final avatar in _avatars.skip(row * 3).take(3)) ...[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _AvatarChoice(
                      option: avatar,
                      selected: _selectedAvatar == avatar.id,
                      onTap: () => setState(() => _selectedAvatar = avatar.id),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: 12),
        ],
      ],
    );
  }

  void _handlePrimaryAction() {
    if (_step == 0) {
      setState(() => _step = 1);
      return;
    }

    final state = context.read<AppState>();
    state.saveName(_nameController.text);
    state.selectAvatar(_selectedAvatar);
    Navigator.of(context).pop();
  }
}

class _AvatarChoice extends StatelessWidget {
  const _AvatarChoice({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _AvatarOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFE6D6) : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: selected ? AppColors.cinnamon : const Color(0xFFE7D7CB),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.color,
                ),
                child: Icon(option.icon, color: Colors.white, size: 42),
              ),
              const SizedBox(height: 10),
              Text(
                option.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected
                      ? AppColors.cinnamon
                      : const Color(0xFF6D5B4D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarOption {
  const _AvatarOption(this.id, this.color, this.icon);

  final String id;
  final Color color;
  final IconData icon;

  String get label => switch (id) {
    'prenses' => 'Prenses',
    'kirmizi-baslik' => 'Kırmızı Başlık',
    'buyucu' => 'Büyücü',
    'gezgin' => 'Gezgin',
    'dedektif' => 'Dedektif',
    'denizci' => 'Denizci',
    _ => 'Avatar',
  };
}

class _ProfileAvatarStyle {
  const _ProfileAvatarStyle({
    required this.backgroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final IconData icon;

  static _ProfileAvatarStyle fromId(String avatarId) {
    return switch (avatarId) {
      'prenses' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFF4B46F),
        icon: Icons.face_4_rounded,
      ),
      'kirmizi-baslik' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFF9ED6C0),
        icon: Icons.face_3_rounded,
      ),
      'buyucu' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFF7B789E),
        icon: Icons.face_6_rounded,
      ),
      'gezgin' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFF0C07A),
        icon: Icons.face_2_rounded,
      ),
      'dedektif' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFB6D79F),
        icon: Icons.face_rounded,
      ),
      'denizci' => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFF86CFC7),
        icon: Icons.face_retouching_natural,
      ),
      _ => const _ProfileAvatarStyle(
        backgroundColor: Color(0xFFF4B46F),
        icon: Icons.face_4_rounded,
      ),
    };
  }
}
